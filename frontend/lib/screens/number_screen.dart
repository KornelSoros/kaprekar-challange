import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/kaprekar_tasks_screeen.dart';

import '../services/number_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final numberService = NumberService(
    dio: Dio(BaseOptions(connectTimeout: Duration(seconds: 10))),
  );
  int? startingNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(),

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
                    await numberService.addNewKaprakarNum();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Sikeresen új Kaprekar-feladványt generáltál!",
                        ),
                        showCloseIcon: true,
                      ),
                    );
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

              Spacer(),

              ElevatedButton(
                onPressed: () async {
                  final allKaprekarTasks = await numberService
                      .getAllKaprekarTasks();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return KaprekarTasksScreeen(
                          allKaprekarTasks: allKaprekarTasks,
                        );
                      },
                    ),
                  );
                },
                child: Text("Eddigi Kaprekar-feladványok"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
