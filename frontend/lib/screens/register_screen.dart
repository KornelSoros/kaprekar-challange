import 'package:flutter/material.dart';
import 'package:frontend/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                  child: Text("Regisztráció"),
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
