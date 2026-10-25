import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/number_screen.dart';
import 'package:frontend/screens/register_screen.dart';
import 'package:frontend/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  int? loginStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Kaprekar-feladványok app")),
        backgroundColor: Colors.blueGrey.shade300,
        foregroundColor: Colors.blue.shade100,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Card(
            color: Colors.grey.shade50,
            child: Column(
              children: [
                Text(
                  "Üdv újra!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),

                Text("A feladványokhoz jeletkezz be!"),

                SizedBox(height: 10),

                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Felhasználónév",
                  ),
                ),

                SizedBox(height: 10),

                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Jelszó",
                  ),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () async {
                    final service = UserService(dio: Dio());
                    final loginResponse = await service.login(
                      username: usernameController.text,
                      password: passwordController.text,
                    );

                    setState(() {
                      loginStatus = loginResponse;
                    });

                    if (!context.mounted) return;
                    if (loginStatus == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen();
                          },
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  child: Text("Bejelentkezés"),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Még nincs fiókod? "),
                    InkWell(
                      child: Text(
                        "Regisztrálj",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterScreen();
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                if (loginStatus != null && loginStatus != 200)
                  Text(
                    "Sikertelen bejelentkezés!",
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
