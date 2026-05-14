import '../../../flight_details/data/models/flight_detail_model.dart';

enum FlightSortType { priceAsc, priceDesc, durationAsc, departureAsc }

extension FlightSortTypeExtension on FlightSortType {
  String get value {
    switch (this) {
      case FlightSortType.priceAsc:
        return "price_asc";

      case FlightSortType.priceDesc:
        return "price_desc";

      case FlightSortType.durationAsc:
        return "duration_asc";

      case FlightSortType.departureAsc:
        return "departure_asc";
    }
  }

  String get title {
    switch (this) {
      case FlightSortType.priceAsc:
        return "Lowest Price";

      case FlightSortType.priceDesc:
        return "Highest Price";

      case FlightSortType.durationAsc:
        return "Fastest";

      case FlightSortType.departureAsc:
        return "Early Departure";
    }
  }

  static FlightSortType fromValue(String? value) {
    switch (value) {
      case "price_desc":
        return FlightSortType.priceDesc;

      case "duration_asc":
        return FlightSortType.durationAsc;

      case "departure_asc":
        return FlightSortType.departureAsc;

      default:
        return FlightSortType.priceAsc;
    }
  }
}

// =====================================
// RESPONSE MODEL
// =====================================

class FlightResponse {
  final String status;
  final String message;
  final FlightData data;

  FlightResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FlightResponse.fromJson(Map<String, dynamic> json) {
    return FlightResponse(
      status: json["status"] ?? "",

      message: json["message"] ?? "",

      data: FlightData.fromJson(json["data"] ?? {}),
    );
  }
}

// =====================================
// FLIGHT DATA
// =====================================

class FlightData {
  final List<FlightModel> flights;

  final PaginationModel pagination;

  FlightData({required this.flights, required this.pagination});

  factory FlightData.fromJson(Map<String, dynamic> json) {
    return FlightData(
      flights: (json["flights"] as List? ?? [])
          .map((e) => FlightModel.fromJson(e))
          .toList(),

      pagination: PaginationModel.fromJson(json["pagination"] ?? {}),
    );
  }
}

// =====================================
// FLIGHT MODEL
// =====================================

class FlightModel {
  final int id;

  final String airlineName;

  final String airlineLogo;

  final String flightNumber;

  final AirportModel departure;

  final AirportModel arrival;

  final String duration;

  final PriceModel price;

  final String aircraftType;

  final int stops;

  FlightModel({
    required this.id,

    required this.airlineName,

    required this.airlineLogo,

    required this.flightNumber,

    required this.departure,

    required this.arrival,

    required this.duration,

    required this.price,

    required this.aircraftType,

    required this.stops,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json["id"] ?? 0,

      airlineName: json["airline_name"] ?? "",

      airlineLogo: json["airline_logo"] ?? "",

      flightNumber: json["flight_number"] ?? "",

      departure: AirportModel.fromJson(json["departure"] ?? {}),

      arrival: AirportModel.fromJson(json["arrival"] ?? {}),

      duration: json["duration"] ?? "",

      price: PriceModel.fromJson(json["price"] ?? {}),

      aircraftType: json["aircraft_type"] ?? "",

      stops: json["stops"] ?? 0,
    );
  }
}

// =====================================
// PRICE MODEL
// =====================================

class PriceModel {
  final num amount;

  final String currency;

  PriceModel({required this.amount, required this.currency});

  factory PriceModel.fromJson(Map<String, dynamic> json) {
    return PriceModel(
      amount: json["amount"] ?? 0,

      currency: json["currency"] ?? "",
    );
  }
}

// =====================================
// REQUEST MODEL
// =====================================

class FlightSearchRequestModel {
  final String from;
  final String to;
  final String date;
  final int passengers;
  final FlightSortType sortBy;
  // filters
  final String? airline;
  final double? priceMin;
  final double? priceMax;
  final int? stops;
  final String? aircraftType;

  const FlightSearchRequestModel({
    required this.from,
    required this.to,
    required this.date,
    required this.passengers,
    required this.sortBy,
    this.airline,
    this.priceMin,
    this.priceMax,
    this.stops,
    this.aircraftType,
  });

  factory FlightSearchRequestModel.fromJson(Map<String, dynamic> json) {
    final filters = json["filters"] ?? {};

    return FlightSearchRequestModel(
      from: json["from"] ?? "",
      to: json["to"] ?? "",
      date: json["date"] ?? "",
      passengers: json["passengers"] ?? 1,
      sortBy: FlightSortTypeExtension.fromValue(json["sort_by"]),
      airline: filters["airline"],
      priceMin: filters["price_min"]?.toDouble(),
      priceMax: filters["price_max"]?.toDouble(),
      stops: filters["stops"],
      aircraftType: filters["aircraft_type"],
    );
  }

  Map<String, dynamic> toJson({int page = 1, int limit = 10}) {
    final filters = {
      "airline": airline,
      "price_min": priceMin,
      "price_max": priceMax,
      "stops": stops,
      "aircraft_type": aircraftType,
    };

    /// remove null filters
    filters.removeWhere((key, value) => value == null);

    final data = {
      "from": from,
      "to": to,
      "date": date,
      "passengers": passengers,
      "sort_by": sortBy.value,
      "filters": filters,
      "page": page,
      "limit": limit,
    };

    /// remove empty strings
    data.removeWhere((key, value) => value is String && value.isEmpty);

    return data;
  }

  FlightSearchRequestModel copyWith({
    String? from,

    String? to,

    String? date,

    int? passengers,

    FlightSortType? sortBy,

    String? airline,

    double? priceMin,

    double? priceMax,

    int? stops,

    String? aircraftType,
  }) {
    return FlightSearchRequestModel(
      from: from ?? this.from,

      to: to ?? this.to,

      date: date ?? this.date,

      passengers: passengers ?? this.passengers,

      sortBy: sortBy ?? this.sortBy,

      airline: airline ?? this.airline,

      priceMin: priceMin ?? this.priceMin,

      priceMax: priceMax ?? this.priceMax,

      stops: stops ?? this.stops,

      aircraftType: aircraftType ?? this.aircraftType,
    );
  }
}
// =====================================
// PAGINATION MODEL
// =====================================

class PaginationModel {
  final int total;

  final int totalPages;

  final int currentPage;

  final int limit;

  final bool hasNextPage;

  final bool hasPrevPage;

  const PaginationModel({
    required this.total,

    required this.totalPages,

    required this.currentPage,

    required this.limit,

    required this.hasNextPage,

    required this.hasPrevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      total: json["total"] ?? 0,

      totalPages: json["totalPages"] ?? 0,

      currentPage: json["currentPage"] ?? 1,

      limit: json["limit"] ?? 10,

      hasNextPage: json["hasNextPage"] ?? false,

      hasPrevPage: json["hasPrevPage"] ?? false,
    );
  }
}

// =====================================
// AIRPORT MODEL FOR DATA SELECTION
// =====================================
class AirportDataModel {
  final String airportCode;

  final String city;

  final String airlineName;

  final String aircraftType;

  const AirportDataModel({
    required this.airportCode,

    required this.city,

    required this.airlineName,

    required this.aircraftType,
  });
}
