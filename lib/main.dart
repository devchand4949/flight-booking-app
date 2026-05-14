import 'package:flightbooking/core/constants/app_colors.dart';
import 'package:flightbooking/core/services/api_services.dart';
import 'package:flightbooking/core/theme/app_theme.dart';
import 'package:flightbooking/features/flight_search/presentation/pages/flight_search_screen.dart';
import 'package:flutter/material.dart';

void main() {

  ApiService().dio;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: const FlightSearchScreen(),
    );
  }
}

