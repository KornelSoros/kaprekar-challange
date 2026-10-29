import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/home_screen.dart';

class SolveDialog extends StatefulWidget {
  final int startingNum;

  const SolveDialog({super.key, required this.startingNum});

  @override
  State<SolveDialog> createState() => _SolveDialogState();
}

class _SolveDialogState extends State<SolveDialog> {
  final numberOfStepsController = TextEditingController();
  int textFieldNumber = 0;
  List<TextEditingController> solutionControllers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("${widget.startingNum.toString()} megoldásának lépései"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Ennyi lépésből áll a megoldás:"),

              SizedBox(width: 8),

              SizedBox(
                width: 50,
                child: TextField(
                  controller: numberOfStepsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(2),
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(),
                  ),

                  onTap: () {
                    numberOfStepsController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: numberOfStepsController.text.length,
                    );
                  },

                  onChanged: (_) {
                    final prevTextFieldNumber = textFieldNumber;

                    textFieldNumber =
                        int.tryParse(numberOfStepsController.text) ?? 0;

                    if (prevTextFieldNumber > textFieldNumber) {
                      solutionControllers.removeRange(
                        3 * (prevTextFieldNumber - textFieldNumber),
                        solutionControllers.length - 1,
                      );
                    }

                    if (prevTextFieldNumber < textFieldNumber) {
                      solutionControllers.addAll(
                        List.generate(
                          3 * (textFieldNumber - prevTextFieldNumber),
                          (_) => TextEditingController(),
                        ),
                      );
                    }

                    print(
                      "Mostani: $textFieldNumber, előző: $prevTextFieldNumber",
                    );

                    setState(() {});
                  },
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < textFieldNumber; i++) ...[
                    Padding(
                      padding: EdgeInsetsGeometry.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: solutionControllers[i * 3],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Text("-", style: TextStyle(fontSize: 40)),

                          SizedBox(width: 10),

                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: solutionControllers[i * 3 + 1],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Text("=", style: TextStyle(fontSize: 40)),

                          SizedBox(width: 10),

                          SizedBox(
                            width: 100,
                            child: TextFormField(
                              controller: solutionControllers[i * 3 + 2],
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              print(
                solutionControllers
                    .map((controller) => controller.text)
                    .toList(),
              );
            },
            icon: Icon(Icons.send),
            label: Text("Megoldás beküldése"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
            label: Text("Vissza a többi feladványhoz"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
