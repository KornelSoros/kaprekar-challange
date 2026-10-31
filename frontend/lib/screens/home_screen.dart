import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/kaprekar_tasks_screeen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/user_service.dart';

import '../constants.dart';
import '../services/number_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String accessToken;
  late NumberService numberService;
  late UserService userService;
  int? startingNumber;
  UserPublic? currentUser;

  Future<void> initDatas() async {
    final storage = FlutterSecureStorage();
    accessToken = await storage.read(key: 'access_token') ?? "";
    numberService = NumberService(
      dio: Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 10),
          headers: {'Authorization': 'Bearer $accessToken'},
          baseUrl: '$baserUrl/number',
        ),
      ),
    );
    userService = UserService(
      dio: Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 10),
          headers: {'Authorization': 'Bearer $accessToken'},
          baseUrl: '$baserUrl/user',
        ),
      ),
    );

    currentUser = await userService.getCurrentUser();

    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initDatas();
    });
    super.initState();
  }

  Future<void> logout() async {
    await userService.logout();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(currentUser == null ? "" : currentUser!.username),
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.blueGrey.shade300,
        foregroundColor: Colors.blue.shade100,
        automaticallyImplyLeading: false,
      ),
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
                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return KaprekarTasksScreeen(
                          currentUser: currentUser!,
                          logout: logout,
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
