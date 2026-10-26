import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

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
                  "Üdv!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),

                Text("Hozz létre új fiókot!"),

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
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Jelszó",
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                ElevatedButton.icon(
                  onPressed: () async {
                    final service = UserService(
                      dio: Dio(
                        BaseOptions(
                          connectTimeout: Duration(minutes: 10),
                          baseUrl: '$baserUrl/user',
                        ),
                      ),
                    );

                    await service.register(
                      User(
                        username: usernameController.text,
                        password: passwordController.text,
                      ),
                    );

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Sikeres regisztráció! Átirányítunk a bejelentkezésre",
                        ),
                      ),
                    );

                    Future.delayed(Duration(seconds: 3), () {
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                    backgroundColor: Colors.greenAccent.shade100,
                  ),
                  label: Text("Regisztráció"),
                  icon: Icon(Icons.app_registration),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Már van fiókod? "),
                    InkWell(
                      child: Text(
                        "Jelentkezz be",
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
