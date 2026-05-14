import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flightbooking/core/utils/formater.dart';
import 'package:flightbooking/core/widgets/App_widget.dart';
import 'package:flightbooking/features/flight_search/data/models/flight_search_model.dart';
import 'package:flightbooking/features/flight_search/presentation/pages/flight_search_result_screen.dart';
import 'package:flightbooking/features/flight_search/presentation/pages/select_from_screen.dart';
import 'package:flightbooking/features/flight_search/presentation/provider/flight_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final TextEditingController departureController = TextEditingController();
  final int people = 1;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    departureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appWidget = AppWidget();
    final af = AppFormatter();
    const String img =
        "https://cdn-icons-png.flaticon.com/512/3135/3135715.png";

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => FlightSearchProvider(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  // top color container.......
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryBlue,
                          AppColors.lightBlue,
                          AppColors.scaffoldBg,
                        ],
                      ),
                    ),
                    child: Column(children: [

                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // title and profile..................
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppWidget.appText(
                                text: "Plan your trip",
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              Container(
                                padding: EdgeInsets.all(1.5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.cardBg,
                                ),
                                child: AppCircleImage(
                                  imagePath: img,
                                  radius: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // card................
                        AppCard(
                          child: Column(
                            children: [
                              // from...........
                              AppTextField(
                                controller: fromController,
                                labelText: "From",
                                isBorderHide: true,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) => FlightSearchProvider(),
                                        child: const SelectFromScreen(
                                          isDeparture: true,
                                        ),
                                      ),
                                    ),
                                  ); //
                                  if (result != null) {
                                    fromController.text = result;
                                  }
                                },
                              ),
                              // center button............
                              GestureDetector(
                                child: Transform.translate(
                                  offset: const Offset(0, -5),
                                  child: SizedBox(
                                    height: 40,
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        // line
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              height: 1.2,
                                              color: AppColors.shadow,
                                            ),
                                          ),
                                        ),

                                        // button
                                        Positioned(
                                          right: 20,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.chipBg,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                ),
                                              ],
                                            ),
                                            child: const Icon(
                                              Icons.swap_vert,
                                              color: AppColors.textDark,
                                              size: 23,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  final temp = fromController.text;
                                  fromController.text = toController.text;
                                  toController.text = temp;
                                },
                              ),
                              // to............
                              AppTextField(
                                controller: toController,
                                labelText: "To",
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) => FlightSearchProvider(),
                                        child: const SelectFromScreen(
                                          isDeparture: false,
                                        ),
                                      ),
                                    ),
                                  );

                                  if (result != null) {
                                    toController.text = result;
                                  }
                                },
                              ),
                              appWidget.appSizeBoxHeight(10),
                              // departure and amount
                              Row(
                                children: [
                                  Expanded(
                                    child: AppTextField(
                                      controller: departureController,
                                      labelText: "Departure",
                                      suffixIcon: Icons.departure_board_sharp,
                                      suffixIconColor: AppColors.textDark,
                                      onTap: () async {
                                        final DateTime?
                                        pickedDate = await showDatePicker(
                                          context: context,

                                          initialDate: DateTime.now(),

                                          firstDate: DateTime.now(),

                                          lastDate: DateTime(2030),

                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                      primary: Colors.black,
                                                      onPrimary: Colors.white,
                                                      surface: Colors.white,
                                                      onSurface: Colors.black,
                                                    ),

                                                dialogTheme: DialogThemeData(
                                                  backgroundColor:
                                                      AppColors.white,
                                                ),
                                              ),

                                              child: child!,
                                            );
                                          },
                                        );

                                        if (pickedDate != null) {
                                          final formattedDate =
                                              "${AppFormatter.formatFlightDate(pickedDate)}";

                                          departureController.text =
                                              formattedDate;
                                        }
                                      },
                                    ),
                                  ),
                                  appWidget.appSizeBoxWidth(15),
                                  Expanded(
                                    child: AppTextField(
                                      labelText: "People",
                                      suffixIcon:
                                          Icons.keyboard_arrow_down_outlined,
                                      suffixIconColor: AppColors.textDark,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              appWidget.appSizeBoxHeight(20),

                              AppButton(
                                text: "Search flight",
                                onTap: () {
                                  final request = FlightSearchRequestModel(
                                    from: af.removeSpace(fromController),
                                    to: af.removeSpace(toController),
                                    date: af.removeSpace(departureController),
                                    passengers: people,
                                    sortBy: FlightSortType.priceAsc,
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) =>
                                            FlightSearchProvider()
                                              ..getFlights(request),
                                        child: const FlightSearchResultScreen(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              appWidget.appSizeBoxHeight(10),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppWidget.appText(
                          text: "Saved trips",
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),

                        TextButton(
                          onPressed: () {},
                          child: AppWidget.appText(
                            text: "See more",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 250, // card height ke according adjust kar
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 300, // card width
                              child: AppSearchScreenCart(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
