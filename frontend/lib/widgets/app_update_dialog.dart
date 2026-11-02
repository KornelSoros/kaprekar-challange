import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/app_update_service.dart';

Future<void> showAppUpdateDialog(BuildContext context, AppUpdate update) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: !update.mandatory,
    builder: (dialogContext) {
      return PopScope(
        canPop: !update.mandatory,
        child: AlertDialog(
          title: const Text('Új verzió érhető el!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verzió: ${update.version}'),
              const SizedBox(height: 12),
              Text(update.releaseNotes),
            ],
          ),
          actions: [
            if (!update.mandatory)
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Később'),
              ),
            FilledButton(
              onPressed: () async {
                final uri = Uri.parse(update.downloadUrl);

                final success = await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );

                if (!success && dialogContext.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nem sikerült megnyitni a letöltést.'),
                    ),
                  );
                }
              },
              child: const Text('Frissítés'),
            ),
          ],
        ),
      );
    },
  );
}
