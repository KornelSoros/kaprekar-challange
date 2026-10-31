import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/kaprekar_task.dart';
import 'package:frontend/screens/kaprekar_tasks_screeen.dart';
import 'package:frontend/services/number_service.dart';

import '../models/user.dart';

class SolveDialog extends StatefulWidget {
  final KaprekarTask task;
  final List<List<int>>? submittedSteps;
  final UserPublic currentUser;
  final VoidCallback logout;

  const SolveDialog({
    super.key,
    required this.task,
    this.submittedSteps,
    required this.currentUser,
    required this.logout,
  });

  @override
  State<SolveDialog> createState() => _SolveDialogState();
}

class _SolveDialogState extends State<SolveDialog> {
  final numberOfStepsController = TextEditingController();
  int textFieldNumber = 0;
  List<TextEditingController> solutionControllers = [];
  NumberService? numberService;

  Future<void> initDatas() async {
    final storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'access_token');

    numberService = NumberService(
      dio: Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 10),
          headers: {'Authorization': 'Bearer $accessToken'},
          baseUrl: '$baserUrl/number',
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await initDatas(),
    );
    if (widget.submittedSteps != null) {
      numberOfStepsController.text = widget.submittedSteps!.length.toString();

      for (
        int i = 0;
        i < (int.tryParse(numberOfStepsController.text) ?? 0);
        i++
      ) {
        for (int j = 0; j < 3; j++) {
          solutionControllers.add(
            TextEditingController(
              text: widget.submittedSteps![i][j].toString(),
            ),
          );
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              "${widget.task.startingNum.toString()} megoldásának lépései",
            ),
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
                    enabled: widget.submittedSteps == null,
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
                          solutionControllers.length -
                              3 * (prevTextFieldNumber - textFieldNumber),
                          solutionControllers.length,
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
                    for (
                      int i = 0;
                      i <
                          (widget.submittedSteps == null
                              ? textFieldNumber
                              : widget.submittedSteps!.length);
                      i++
                    ) ...[
                      Padding(
                        padding: EdgeInsetsGeometry.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int j = 0; j < 3; j++) ...[
                              SizedBox(
                                width: 100,
                                child: TextFormField(
                                  enabled: widget.submittedSteps == null,
                                  controller: solutionControllers[i * 3 + j],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              if (j == 0 || j == 1) ...[
                                SizedBox(width: 10),

                                Text(
                                  j == 0 ? "-" : "=",
                                  style: TextStyle(fontSize: 40),
                                ),

                                SizedBox(width: 10),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            ElevatedButton.icon(
              onPressed: () async {
                final response = await showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      children: [
                        Text("Biztos szeretnéd beküldeni a megoldást"),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },

                          icon: Icon(Icons.close),

                          label: Text("Nem"),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },

                          icon: Icon(Icons.check),

                          label: Text("Igen"),
                        ),
                      ],
                    );
                  },
                );

                if (response == false) return;

                final List<int> solutionValues = solutionControllers
                    .map((controller) => int.tryParse(controller.text) ?? 0)
                    .toList();

                final List<List<int>> solutionStepPartions = [];

                for (int i = 0; i < solutionValues.length; i += 3) {
                  solutionStepPartions.add(
                    solutionValues.getRange(i, i + 3).toList(),
                  );
                }

                await numberService!.sendSolution(
                  id: widget.task.id,
                  solutionSteps: solutionStepPartions,
                );

                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return KaprekarTasksScreeen(
                        currentUser: widget.currentUser,
                        logout: widget.logout,
                      );
                    },
                  ),
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
                      return KaprekarTasksScreeen(
                        currentUser: widget.currentUser,
                        logout: widget.logout,
                      );
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
      ),
    );
  }
}
