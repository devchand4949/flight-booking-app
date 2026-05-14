import 'package:flightbooking/core/widgets/App_widget.dart';
import 'package:flightbooking/features/flight_search/data/models/flight_search_model.dart';
import 'package:flightbooking/features/flight_search/presentation/pages/select_option_screen.dart';
import 'package:flutter/material.dart';

class FlightFilterScreen extends StatefulWidget {
  final FlightSearchRequestModel flightSearchRequestModel;
  final List<String> airlines;
  final List<String> aircraftTypes;

  const FlightFilterScreen({
    super.key,
    required this.flightSearchRequestModel,
    required this.airlines,
    required this.aircraftTypes,
  });

  @override
  State<FlightFilterScreen> createState() => _FlightFilterScreenState();
}

class _FlightFilterScreenState extends State<FlightFilterScreen> {
  final airlineController = TextEditingController();
  final aircraftController = TextEditingController();

  RangeValues priceRange = const RangeValues(50, 500);

  int selectedStops = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advanced Filter")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Airline
            GestureDetector(
              onTap: () async {
                if (widget.airlines.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No airlines available")),
                  );
                  return;
                }

                final selected = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectOptionScreen(
                      options: widget.airlines,
                      type: SelectionType.airline,
                      selectedValue: airlineController.text,
                    ),
                  ),
                );

                if (selected != null) {
                  airlineController.text = selected;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: airlineController,
                  decoration: const InputDecoration(
                    labelText: "Airline",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Aircraft
            GestureDetector(
              onTap: () async {
                if (widget.aircraftTypes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("No aircraft available")),
                  );
                  return;
                }

                final selected = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectOptionScreen(
                      options: widget.aircraftTypes,
                      type: SelectionType.aircraft,
                      selectedValue: aircraftController.text,
                    ),
                  ),
                );

                if (selected != null) {
                  aircraftController.text = selected;
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: aircraftController,
                  decoration: const InputDecoration(
                    labelText: "Aircraft Type",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Price Range
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Price Range: \$${priceRange.start.round()} - ₹${priceRange.end.round()}",
              ),
            ),

            RangeSlider(
              values: priceRange,
              min: 50,
              max: 500,
              labels: RangeLabels(
                priceRange.start.round().toString(),
                priceRange.end.round().toString(),
              ),
              onChanged: (v) {
                setState(() {
                  priceRange = v;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Stops
            DropdownButtonFormField<int>(
              value: selectedStops,
              decoration: const InputDecoration(
                labelText: "Stops",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text("Direct")),
                DropdownMenuItem(value: 1, child: Text("1 Stop")),
                DropdownMenuItem(value: 2, child: Text("2 Stops")),
              ],
              onChanged: (v) {
                setState(() {
                  selectedStops = v!;
                });
              },
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 45,
              child: AppButton(
                text: "Apply filter",
                onTap: () {
                  final filter = widget.flightSearchRequestModel.copyWith(
                    airline: airlineController.text,
                    aircraftType: aircraftController.text,
                    priceMin: priceRange.start,
                    priceMax: priceRange.end,
                    stops: selectedStops,
                  );

                  Navigator.pop(context, filter);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
