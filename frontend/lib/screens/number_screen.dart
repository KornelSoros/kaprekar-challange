import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/kaprekar_task.dart';

import '../services/number_service.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final numberService = NumberService(
    dio: Dio(BaseOptions(connectTimeout: Duration(seconds: 10))),
  );
  int? startingNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              startingNumber == null
                  ? "Generálj egy számot!"
                  : startingNumber.toString(),
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                try {
                  KaprekarTask? newNumber = await numberService.getKaprekarNum(
                    id: 1,
                  );
                  print("A SZÁM: ${newNumber}");

                  if (!context.mounted) return;

                  setState(() {
                    startingNumber = newNumber.startingNum;
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Hiba történt a hálózat elérésekor! $e"),
                    ),
                  );
                }
              },
              child: Text("Új szám generálása"),
            ),
          ],
        ),
      ),
    );
  }
}
