import 'package:flutter/material.dart';

final class LocationTrackingView extends StatelessWidget {
  const LocationTrackingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracking'),
      ),
      body: Center(
        child: Text('Location Tracking'),
      ),
    );
  }
}
