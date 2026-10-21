import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/kaprekar_task.dart';

class KaprekarTasksScreeen extends StatefulWidget {
  final List<KaprekarTask> allKaprekarTasks;

  const KaprekarTasksScreeen({super.key, required this.allKaprekarTasks});

  @override
  State<KaprekarTasksScreeen> createState() => _KaprekarTasksScreeenState();
}

class _KaprekarTasksScreeenState extends State<KaprekarTasksScreeen> {
  @override
  Widget build(BuildContext context) {
    final List<KaprekarTask> kaprekarNumList = widget.allKaprekarTasks;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Text(
                          kaprekarNumList[index].startingNum.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: null,
                              child: Text("Elkezdése"),
                            ),

                            SizedBox(width: 5),

                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 200,
                                      child: SimpleDialog(
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: kaprekarNumList[index]
                                                .solutionSteps
                                                .map(
                                                  (step) => AnimatedTextKit(
                                                    animatedTexts: [
                                                      TyperAnimatedText(
                                                        "${step[0]} - ${step[1]} = ${step[2]}",
                                                      ),
                                                      TyperAnimatedText(
                                                        "AAAAAAAAAAAAAAAAAA",
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("Megoldás"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  // Text(kaprekarNumList[index].startingNum.toString());
                },
                itemCount: kaprekarNumList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
