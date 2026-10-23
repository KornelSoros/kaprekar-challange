import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class SolutionStepsDialog extends StatefulWidget {
  final List steps;

  const SolutionStepsDialog({super.key, required this.steps});

  @override
  State<SolutionStepsDialog> createState() => _SolutionStepsDialogState();
}

class _SolutionStepsDialogState extends State<SolutionStepsDialog> {
  List<List> finishedLines = [];
  bool animationFinished = false;

  Widget animateSolutionSteps(List steps) {
    if (!animationFinished && steps.isNotEmpty) {
      return Center(
        child: AnimatedTextKit(
          key: const ValueKey("kaprekar_animation"),
          isRepeatingAnimation: false,
          animatedTexts: steps
              .map(
                (step) =>
                    TyperAnimatedText("${step[0]} - ${step[1]} = ${step[2]}"),
              )
              .toList(),
          onNext: (nextIndex, isLast) {
            setState(() {
              finishedLines.add(steps[nextIndex]);
            });
          },
          onFinished: () {
            setState(() {
              animationFinished = true;
            });
          },
          pause: Duration.zero,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = widget.steps;

    return SimpleDialog(
      title: Center(child: Text("A megoldás lépései")),

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

        animateSolutionSteps(steps),

        SizedBox(height: 10),

        if (animationFinished)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    finishedLines = [];
                    animationFinished = false;
                  });
                  animateSolutionSteps(steps);
                },
                label: Text("Újra"),
                icon: Icon(Icons.repeat),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),

              SizedBox(width: 5),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                label: Text("Rendben"),
                icon: Icon(Icons.close),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
