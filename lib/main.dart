import 'package:flutter/material.dart';
import 'package:marti_case/feature/location_tracking/view/location_tracking_view.dart';

void main() {
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LocationTrackingView(),
    );
  }
}
