import 'package:flutter/material.dart';
import 'package:marti_case/core/init/dependency_injection.dart';
import 'package:marti_case/feature/location_tracking/view/location_tracking_view.dart';

Future<void> main() async {
  await DependencyInjection.init();
  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Marti Case',
      debugShowCheckedModeBanner: false,
      home: LocationTrackingView(),
    );
  }
}
