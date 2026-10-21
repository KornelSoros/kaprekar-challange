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
                                final steps =
                                    kaprekarNumList[index].solutionSteps;
                                List<List> finishedLines = [];
                                bool animationFinished = false;

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 200,
                                      child: StatefulBuilder(
                                        builder: (context, setDialogState) {
                                          return SimpleDialog(
                                            children: [
                                              Column(
                                                children: finishedLines
                                                    .map(
                                                      (finishedLine) => Text(
                                                        "${finishedLine[0]} - ${finishedLine[1]} = ${finishedLine[2]}",
                                                      ),
                                                    )
                                                    .toList(),
                                              ),

                                              if (!animationFinished &&
                                                  steps.isNotEmpty)
                                                AnimatedTextKit(
                                                  key: const ValueKey(
                                                    "kaprekar_animation",
                                                  ),
                                                  isRepeatingAnimation: false,
                                                  animatedTexts: steps
                                                      .map(
                                                        (
                                                          step,
                                                        ) => TyperAnimatedText(
                                                          "${step[0]} - ${step[1]} = ${step[2]}",
                                                        ),
                                                      )
                                                      .toList(),
                                                  onNext: (nextIndex, isLast) {
                                                    setDialogState(() {
                                                      finishedLines.add(
                                                        steps[nextIndex],
                                                      );
                                                    });
                                                  },
                                                  onFinished: () {
                                                    setDialogState(() {
                                                      animationFinished = true;
                                                    });
                                                  },
                                                  pause: Duration.zero,
                                                ),
                                            ],
                                          );
                                        },
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
