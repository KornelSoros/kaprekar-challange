import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/screens/home_screen.dart';
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
                    backgroundColor: Colors.greenAccent.shade100,
                  ),
                  label: Text("Bejelentkezés"),
                  icon: Icon(Icons.login),
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
                          builder: (context) => RegisterScreen(),
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
