import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marti_case/core/extension/context_extension.dart';
import 'package:marti_case/feature/location_tracking/vm/location_tracking_vm.dart';
import 'package:stacked/stacked.dart';

final class LocationTrackingView extends StatelessWidget {
  const LocationTrackingView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationTrackingVm>.reactive(
      viewModelBuilder: () => LocationTrackingVm(context),
      builder: (context, model, child) => Scaffold(
        floatingActionButton: Container(
          width: double.infinity,
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () => model.isTracking
                    ? model.stopTracking()
                    : model.startTracking((e) => context.showPermissionError(e)),
                child: Text(model.isTracking ? 'Stop' : 'Start'),
              ),
              ElevatedButton(
                onPressed: model.resetRoute,
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
        body: GoogleMap(
          onMapCreated: (controller) => model.mapController = controller,
          initialCameraPosition: const CameraPosition(
            target: LatLng(41.056844783291105, 28.8932773118224),
          ),
          markers: model.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }
}
