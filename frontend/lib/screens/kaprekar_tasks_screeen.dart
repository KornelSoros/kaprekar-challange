import 'package:flutter/material.dart';
import 'package:frontend/models/kaprekar_task.dart';
import 'package:frontend/widgets/solution_steps_dialog.dart';

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
                              child: Text("Elkezdés"),
                            ),

                            SizedBox(width: 5),

                            ElevatedButton(
                              onPressed: () {
                                final steps =
                                    kaprekarNumList[index].solutionSteps;

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 200,
                                      child: SolutionStepsDialog(steps: steps),
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
