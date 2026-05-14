import 'package:flutter/material.dart';
import '../../../../core/widgets/App_widget.dart';
import '../../data/models/flight_detail_model.dart';

class FLightDetailPassengerInfoTile extends StatelessWidget {
  final PassengerModel passengerModel;
  const FLightDetailPassengerInfoTile({super.key, required this.passengerModel});

  @override
  Widget build(BuildContext context) {
    final p = passengerModel;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          AppCircleImage(imagePath: p.profilePicture,radius: 20,),
          AppWidget().appSizeBoxWidth(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppWidget.appText(text: "PASSENGER ${p.passengerNumber}",color: Colors.grey,),
              AppWidget.appText(text: p.name,fontWeight: FontWeight.bold)
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppWidget.appText(text: "SEAT",color: Colors.grey,),
              AppWidget.appText(text: p.seat,fontWeight: FontWeight.bold)
            ],
          ),
        ],
      ),
    );
  }
}
