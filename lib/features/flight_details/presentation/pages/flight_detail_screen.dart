import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flightbooking/core/widgets/App_widget.dart';
import 'package:flightbooking/features/flight_details/presentation/provider/flight_detail_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../widgets/flight_detail_passengerInfo_tile.dart';

class FlightDetailScreen extends StatelessWidget {
  const FlightDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FlightDetailProvider>(
          builder: (context,provider,child){
            final f = provider.flightDetailModel;
            final p = provider.passengerModel;
            final b = provider.bookingInfoModel;

            if(provider.isLoading){
              return Center(child: CircularProgressIndicator(),);
            }

            if(provider.errorMessage != null){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                    ),

                    const SizedBox(height: 12),

                    AppWidget.appText(text: provider.errorMessage!,color: Colors.grey,fontSize: 14,textAlign: TextAlign.center),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if(provider.currentFlightId != null){
                          provider.getFlightDetail(
                            provider.currentFlightId!,
                          );
                        }
                      },
                      child: AppWidget.appText(text: "Retry",color: Colors.grey,fontSize: 14,textAlign: TextAlign.center),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16,70,16,0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        AppCircleIconButton(onTap: ()=>Navigator.pop(context), icon: CupertinoIcons.back),
                        AppWidget().appSizeBoxWidth(60),
                        AppWidget.appText(text: "Your flight details",fontSize: 16,fontWeight: FontWeight.bold),
                      ],
                    ),
                    AppWidget().appSizeBoxHeight(30),

                    // flight info.........................
                    if(f != null)
                      TicketCard(
                        topChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            AppCardLogoTitleId(logo: f.airlineLogo, title: f.airlineName, flightNumber: f.flightNumber,isFlightNumShow: true,),
                            AppWidget().appSizeBoxHeight(15),
                            AppFromToCartTime(departure: f.departure, arrival: f.arrival, duration: f.duration),
                            // full border.................
                          ],
                        ),

                        bottomChild: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppCardDate(title: 'TERMINAL', value: f.terminal,),
                                AppCardDate(title: 'GATE', value: f.gate,),
                                AppCardDate(title: 'CLASS', value: f.flightClass,),
                              ],
                            ),
                          ],
                        ),
                      ),

                    // passenger info .....................
                    if(p.isNotEmpty && b != null)
                      TicketCard(
                        //passenger............
                        topChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            AppWidget.appText(text: "Passengers info",fontSize: 14,fontWeight: FontWeight.bold),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: p.length,
                              itemBuilder: (context, index) {

                                final passenger = p[index];

                                return Column(
                                  children: [

                                    FLightDetailPassengerInfoTile(
                                      passengerModel: passenger,
                                    ),

                                    // divider between passengers
                                    if (index != p.length - 1)
                                      Container(
                                        height: 1.2,
                                        width: double.infinity,
                                        color: AppColors.shadow,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),

                        // barcode ....+
                        bottomChild: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6,),
                              child: SizedBox(
                                width: double.infinity,
                                child: SvgPicture.string(
                                  b.barcode,
                                  height: 80,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 70,
                      child: Column(
                        children: [
                          AppButton(text: "Download & Save pass", onTap: (){}),
                          Spacer(),
                          Container(
                            height: 5,
                            width: 130,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppColors.black
                            ),
                          ),
                          AppWidget().appSizeBoxHeight(3),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}


