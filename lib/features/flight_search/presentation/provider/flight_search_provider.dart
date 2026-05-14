import 'package:flightbooking/core/constants/api_endpoint.dart';
import 'package:flightbooking/core/error/error_handler.dart';
import 'package:flightbooking/core/services/api_services.dart';
import 'package:flightbooking/features/flight_search/data/models/flight_search_model.dart';
import 'package:flutter/material.dart';

class FlightSearchProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isGetFlightLoading = false;
  bool isPaginationLoading = false;
  String? errorMessage;

  List<AirportDataModel> departureAirports = [];

  List<AirportDataModel> arrivalAirports = [];

  FlightSortType selectedSort = FlightSortType.priceAsc;

  List<FlightModel> flights = [];

  List<String> airlines = [];

  List<String> aircraftTypes = [];

  int currentPage = 1;

  bool hasNextPage = true;

  final ScrollController scrollController = ScrollController();

  // current request store .........................
  FlightSearchRequestModel? currentRequest;

  FlightSearchProvider() {
    scrollController.addListener(_scrollListener);
  }

  Future<void> applySort(FlightSortType sortType) async {
    selectedSort = sortType;

    currentPage = 1;

    hasNextPage = true;

    flights.clear();

    notifyListeners();

    if (currentRequest == null) return;

    currentRequest = currentRequest!.copyWith(sortBy: sortType);

    await getFlights(currentRequest!);
  }

  // pagination scroll.............
  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isPaginationLoading &&
        hasNextPage &&
        currentRequest != null) {
      getFlights(currentRequest!);
    }
  }

  //airport code................
  Future<void> getAirportCodes() async {
    try {
      if (departureAirports.isNotEmpty && arrivalAirports.isNotEmpty) {
        return;
      }
      isLoading = true;
      notifyListeners();

      final response = await ApiService().getApi(ApiEndPoint.list);

      final flights = response["data"]["flights"] as List;

      /// departure airports
      departureAirports = flights.map<AirportDataModel>((e) {
        return AirportDataModel(
          airportCode: e["departure"]["airport_code"].toString(),
          city: e["departure"]["city"].toString(),
          airlineName: e["airline_name"].toString(),
          aircraftType: e["aircraft_type"].toString(),
        );
      }).toList();

      /// arrival airports
      arrivalAirports = flights.map<AirportDataModel>((e) {
        return AirportDataModel(
          airportCode: e["arrival"]["airport_code"].toString(),
          city: e["arrival"]["city"].toString(),
          airlineName: e["airline_name"].toString(),
          aircraftType: e["aircraft_type"].toString(),
        );
      }).toList();

      /// remove duplicates
      departureAirports = {
        for (var e in departureAirports) e.airportCode: e,
      }.values.toList();

      arrivalAirports = {
        for (var e in arrivalAirports) e.airportCode: e,
      }.values.toList();
    } catch (e) {
      final error = ErrorHandler().handleError(e);
      errorMessage = error.message;
      debugPrint(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // get flight.................
  Future<void> getFlights(FlightSearchRequestModel request) async {
    try {
      errorMessage = null;
      // sava current request
      currentRequest = request;

      // prevent duplicate call
      if (isGetFlightLoading || isPaginationLoading) {
        return;
      }

      //first time page loader
      if (currentPage == 1) {
        isGetFlightLoading = true;
      } else {
        isPaginationLoading = true;
      }

      notifyListeners();

      // api call
      final response = await ApiService().getApi(
        ApiEndPoint.list,
        queryParameters: request.toJson(page: currentPage, limit: 10),
      );

      final data = FlightResponse.fromJson(response);

      // remove duplicates
      final newFlights = data.data.flights.where((newFlight) {
        return !flights.any((oldFlight) => oldFlight.id == newFlight.id);
      }).toList();
      flights.addAll(newFlights);

      // extract unique airlines and aircraft types
      _extractAirlinesAndAircraftTypes();

      // pagination
      final pagination = data.data.pagination;

      hasNextPage = pagination.hasNextPage;

      // next page
      if (hasNextPage) {
        currentPage++;
      }
    } catch (e) {
      final error = ErrorHandler().handleError(e);
      errorMessage = error.message;
      debugPrint(e.toString());
    } finally {
      isGetFlightLoading = false;
      isPaginationLoading = false;
      notifyListeners();
    }
  }

  // extract airlines and aircraft types from flights
  void _extractAirlinesAndAircraftTypes() {
    final airlineSet = <String>{};
    final aircraftSet = <String>{};

    for (var flight in flights) {
      airlineSet.add(flight.airlineName);
      aircraftSet.add(flight.aircraftType);
    }

    airlines = airlineSet.toList();
    aircraftTypes = aircraftSet.toList();

    airlines.sort();
    aircraftTypes.sort();
  }

  // refresh
  Future<void> refreshFlights() async {
    if (currentRequest == null) {
      return;
    }

    currentPage = 1;
    hasNextPage = true;
    flights.clear();
    await getFlights(currentRequest!);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }
}
