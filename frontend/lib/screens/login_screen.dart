import 'package:flutter/material.dart';
import 'package:frontend/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Felhasználónév",
                  ),
                ),

                SizedBox(height: 10),

                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: "Jelszó",
                  ),
                ),

                SizedBox(height: 10),

                ElevatedButton(
                  onPressed: null,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
