import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/number_service.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final numberService = NumberService(dio: Dio());
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
                int? newNumber = await numberService.generateNewNumber();
                setState(() {
                  startingNumber = newNumber;
                });
              },
              child: Text("Új szám generálása"),
            ),
          ],
        ),
      ),
    );
  }
}
