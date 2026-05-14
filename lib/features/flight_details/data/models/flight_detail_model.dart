class FlightDetailsResponse {

  final String status;
  final String message;
  final FlightDetailsData data;

  FlightDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory FlightDetailsResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return FlightDetailsResponse(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: FlightDetailsData.fromJson(
        json["data"] ?? {},
      ),
    );
  }
}

class FlightDetailsData {

  final FlightDetailModel flightDetails;
  final List<PassengerModel> passengers;
  final BookingInfoModel bookingInfo;

  FlightDetailsData({
    required this.flightDetails,
    required this.passengers,
    required this.bookingInfo,
  });

  factory FlightDetailsData.fromJson(
      Map<String, dynamic> json,
      ) {
    return FlightDetailsData(
      flightDetails: FlightDetailModel.fromJson(
        json["flight_details"] ?? {},
      ),

      passengers: (json["passengers"] as List? ?? [])
          .map(
            (e) => PassengerModel.fromJson(e),
      )
          .toList(),

      bookingInfo: BookingInfoModel.fromJson(
        json["booking_info"] ?? {},
      ),
    );
  }
}

class FlightDetailModel {

  final int id;
  final String airlineName;
  final String airlineLogo;
  final String flightId;
  final String flightNumber;

  final AirportModel departure;
  final AirportModel arrival;

  final String duration;
  final String aircraftType;

  final int stops;

  final String terminal;
  final String gate;
  final String flightClass;

  FlightDetailModel({
    required this.id,
    required this.airlineName,
    required this.airlineLogo,
    required this.flightId,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.aircraftType,
    required this.stops,
    required this.terminal,
    required this.gate,
    required this.flightClass,
  });

  factory FlightDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return FlightDetailModel(
      id: json["id"] ?? 0,

      airlineName:
      json["airline_name"] ?? "",

      airlineLogo:
      json["airline_logo"] ?? "",

      flightId:
      json["flight_id"] ?? "",

      flightNumber:
      json["flight_number"] ?? "",

      departure: AirportModel.fromJson(
        json["departure"] ?? {},
      ),

      arrival: AirportModel.fromJson(
        json["arrival"] ?? {},
      ),

      duration:
      json["duration"] ?? "",

      aircraftType:
      json["aircraft_type"] ?? "",

      stops:
      json["stops"] ?? 0,

      terminal:
      json["terminal"] ?? "",

      gate:
      json["gate"] ?? "",

      flightClass:
      json["class"] ?? "",
    );
  }
}

class AirportModel {

  final String time;
  final String airportCode;
  final String city;

  AirportModel({
    required this.time,
    required this.airportCode,
    required this.city,
  });

  factory AirportModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return AirportModel(
      time: json["time"] ?? "",

      airportCode:
      json["airport_code"] ?? "",

      city:
      json["city"] ?? "",
    );
  }
}

class PassengerModel {

  final int passengerNumber;
  final String title;
  final String name;
  final String seat;
  final String profilePicture;

  PassengerModel({
    required this.passengerNumber,
    required this.title,
    required this.name,
    required this.seat,
    required this.profilePicture,
  });

  factory PassengerModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PassengerModel(
      passengerNumber:
      json["passenger_number"] ?? 0,

      title:
      json["title"] ?? "",

      name:
      json["name"] ?? "",

      seat:
      json["seat"] ?? "",

      profilePicture:
      json["profile_picture"] ?? "",
    );
  }
}

class BookingInfoModel {

  final int totalPassengers;
  final String bookingReference;
  final String bookingDate;
  final String barcode;

  BookingInfoModel({
    required this.totalPassengers,
    required this.bookingReference,
    required this.bookingDate,
    required this.barcode,
  });

  factory BookingInfoModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BookingInfoModel(
      totalPassengers:
      json["total_passengers"] ?? 0,

      bookingReference:
      json["booking_reference"] ?? "",

      bookingDate:
      json["booking_date"] ?? "",

      barcode:
      json["barcode"] ?? "",
    );
  }
}