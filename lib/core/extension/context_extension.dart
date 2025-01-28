import 'package:flutter/material.dart';
import 'package:marti_case/core/utils/permission_handler.dart';

extension ContextExtensions on BuildContext {
  void showMarkerLocation(String address) {
    showModalBottomSheet(
      context: this,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(64),
          width: double.infinity,
          child: Text(
            address,
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  void showPermissionError(String message) {
    showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: const Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
            const TextButton(
              onPressed: PermissionHandler.openAppSettings,
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }
}
