import 'package:flightbooking/core/constants/api_endpoint.dart';
import 'package:flightbooking/core/services/api_services.dart';
import 'package:flightbooking/features/flight_details/data/models/flight_detail_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/error_handler.dart';

class FlightDetailProvider extends ChangeNotifier {

  bool isLoading = false;
  FlightDetailModel? flightDetailModel;
  List<PassengerModel> passengerModel = [];
  BookingInfoModel? bookingInfoModel;

  String? errorMessage;
  int? currentFlightId;

  Future<void> getFlightDetail(int flightId,) async {

    try {
      errorMessage = null;
      currentFlightId = flightId;
      isLoading = true;
      notifyListeners();

      final res = await ApiService().getApi(
        ApiEndPoint.flight,
        queryParameters: {
          "id": flightId,
        },
      );

      final data = FlightDetailsResponse.fromJson(res);

      flightDetailModel = data.data.flightDetails;
      passengerModel = data.data.passengers;
      bookingInfoModel = data.data.bookingInfo;

    } catch (e) {
      debugPrint(e.toString());
      final error = ErrorHandler().handleError(e);
      errorMessage = error.message;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}