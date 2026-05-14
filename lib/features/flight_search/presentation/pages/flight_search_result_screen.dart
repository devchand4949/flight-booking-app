import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flightbooking/core/widgets/App_widget.dart';
import 'package:flightbooking/features/flight_search/presentation/provider/flight_search_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/flight_search_model.dart';
import 'filter_screen.dart';

class FlightSearchResultScreen extends StatelessWidget {
  const FlightSearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sorts = [
      FlightSortType.priceAsc,
      FlightSortType.priceDesc,
      FlightSortType.durationAsc,
      FlightSortType.departureAsc,
    ];
    return Scaffold(
      body: Consumer<FlightSearchProvider>(
        builder: (context, provider, child) {
          if (provider.isGetFlightLoading) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          if (provider.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),

                    const SizedBox(height: 12),

                    AppWidget.appText(
                      text: provider.errorMessage!,
                      color: Colors.grey,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (provider.currentRequest != null) {
                          provider.getFlights(provider.currentRequest!);
                        }
                      },
                      child: AppWidget.appText(
                        text: "Retry",
                        color: Colors.grey,
                        fontSize: 14,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.flights.isEmpty) {
            return Scaffold(
              body: Center(
                child: AppWidget.appText(
                  text: "No flights found for selected filters",
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            );
          }

          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppCircleIconButton(
                        onTap: () => Navigator.pop(context),
                        icon: CupertinoIcons.back,
                      ),
                      AppWidget.appText(
                        text: "Flight result",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      AppCircleIconButton(
                        onTap: () => Navigator.pop(context),
                        icon: Icons.more_vert,
                      ),
                    ],
                  ),

                  AppWidget().appSizeBoxHeight(10),
                  // sorting .................
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: sorts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final sort = sorts[index];
                        final isSelected = provider.selectedSort == sort;

                        return AppButton(
                          text: sort.title,
                          onTap: () => provider.applySort(sort),
                          width: 140,
                          fontSize: 12,
                          backgroundColor: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.white,
                          textColor: isSelected
                              ? AppColors.white
                              : AppColors.textDark,
                        );
                      },
                    ),
                  ),
                  AppWidget().appSizeBoxHeight(10),

                  // flight data...............
                  Expanded(
                    child: ListView.builder(
                      controller: provider.scrollController,
                      itemCount:
                          provider.flights.length +
                          (provider.isPaginationLoading ? 1 : 0),
                      itemBuilder: (ctx, index) {
                        // pagination loader
                        if (index == provider.flights.length) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final flight = provider.flights[index];
                        return AppSearchResultScreenCart(flightModel: flight);
                      },
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              backgroundColor: AppColors.lightBlue,
              onPressed: () async {
                if (provider.currentRequest == null) {
                  return;
                }
                final filter = await Navigator.push<FlightSearchRequestModel>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FlightFilterScreen(
                      flightSearchRequestModel: provider.currentRequest!,
                      airlines: provider.airlines,
                      aircraftTypes: provider.aircraftTypes,
                    ),
                  ),
                );

                if (filter != null) {
                  provider.currentPage = 1;
                  provider.hasNextPage = true;
                  provider.flights.clear();
                  await provider.getFlights(filter);
                }
              },
              child: const Icon(
                Icons.filter_alt_outlined,
                color: AppColors.primaryBlue,
                size: 26,
              ),
            ),
          );
        },
      ),
    );
  }
}
