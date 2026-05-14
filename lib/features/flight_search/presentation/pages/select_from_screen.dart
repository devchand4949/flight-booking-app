import 'package:flightbooking/features/flight_search/presentation/provider/flight_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectFromScreen extends StatefulWidget {
  final bool isDeparture;
  const SelectFromScreen({super.key, required this.isDeparture});

  @override
  State<SelectFromScreen> createState() => _SelectFromScreenState();
}

class _SelectFromScreenState extends State<SelectFromScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FlightSearchProvider>().getAirportCodes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isDeparture ? "Select Departure" : "Select Arrival"),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        child: Consumer<FlightSearchProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final airportList = widget.isDeparture
                ? provider.departureAirports
                : provider.arrivalAirports;

            if (airportList.isEmpty) {
              return const Center(child: Text("No airports found"));
            }

            return ListView.separated(
              itemCount: airportList.length,

              separatorBuilder: (_, __) => const Divider(height: 1),

              itemBuilder: (context, index) {
                final airport = airportList[index];

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  title: Text(
                    "${airport.airportCode} (${airport.city})",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    Navigator.pop(context, airport.airportCode);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
