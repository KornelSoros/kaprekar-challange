import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/kaprekar_tasks_screeen.dart';

import '../services/number_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String accessToken;
  late NumberService numberService;
  int? startingNumber;

  Future<void> initAcessToken() async {
    final storage = FlutterSecureStorage();
    accessToken = await storage.read(key: 'access_token') ?? "";
    print("EZ A TOKEN: $accessToken!");
    numberService = NumberService(
      dio: Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 10),
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => initAcessToken());
    super.initState();
  }

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

                  if (!context.mounted) return;

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
