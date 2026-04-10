import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> showCipherDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  VoidCallback? onConfirm,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.pop(context, true);
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

Future<bool> ensureCameraPermission(BuildContext context) async {
  if (!context.mounted) return false;
  final status = await Permission.camera.status;
  if (status.isGranted) return true;

  if (status.isDenied) {
    if (!context.mounted) return false;
    final shouldRequest = await showCipherDialog(
      context,
      title: 'Camera Access Needed',
      body: 'Cipher needs camera access to scan QR codes.',
      confirmLabel: 'Grant Permission',
    );
    if (!shouldRequest) return false;
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  if (status.isPermanentlyDenied) {
    if (!context.mounted) return false;
    await showCipherDialog(
      context,
      title: 'Permission Required',
      body: 'Please enable camera in Settings to use the scanner.',
      confirmLabel: 'Open Settings',
      onConfirm: openAppSettings,
    );
  }
  return false;
}
