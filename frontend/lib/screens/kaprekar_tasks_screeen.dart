import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/kaprekar_task.dart';
import 'package:frontend/models/user.dart';
import 'package:frontend/services/number_service.dart';
import 'package:frontend/widgets/solution_steps_dialog.dart';
import 'package:frontend/widgets/solve_dialog.dart';

class KaprekarTasksScreeen extends StatefulWidget {
  final UserPublic currentUser;
  final VoidCallback logout;

  const KaprekarTasksScreeen({
    super.key,
    required this.currentUser,
    required this.logout,
  });

  @override
  State<KaprekarTasksScreeen> createState() => _KaprekarTasksScreeenState();
}

class _KaprekarTasksScreeenState extends State<KaprekarTasksScreeen> {
  List<KaprekarTask>? allKaprekarTasks;
  late NumberService numberService;

  Future<void> initDatas() async {
    final stroage = FlutterSecureStorage();
    final accessToken = await stroage.read(key: 'access_token') ?? "";

    numberService = NumberService(
      dio: Dio(
        BaseOptions(
          connectTimeout: Duration(minutes: 10),
          headers: {'Authorization': 'Bearer $accessToken'},
          baseUrl: "$baserUrl/number",
        ),
      ),
    );

    allKaprekarTasks = await numberService.getKaprekarTasksByUserId();
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await initDatas(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<KaprekarTask> kaprekarNumList = allKaprekarTasks ?? [];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Text(widget.currentUser == null ? "" : widget.currentUser!.username),
          IconButton(onPressed: widget.logout, icon: Icon(Icons.logout)),
        ],
        backgroundColor: Colors.blueGrey.shade300,
        foregroundColor: Colors.blue.shade100,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                kaprekarNumList[index].startingNum.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),

                              if (kaprekarNumList[index].submittedSteps != null)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "Eredményed: ${kaprekarNumList[index].earnedScore}/${kaprekarNumList[index].totalScore}",
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SolveDialog(
                                        task: kaprekarNumList[index],
                                        submittedSteps: kaprekarNumList[index]
                                            .submittedSteps,
                                        currentUser: widget.currentUser,
                                        logout: widget.logout,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                kaprekarNumList[index].submittedSteps == null
                                    ? "Elkezdés"
                                    : "Megoldásom",
                              ),
                            ),

                            SizedBox(width: 5),

                            ElevatedButton(
                              onPressed: () {
                                final steps =
                                    kaprekarNumList[index].solutionSteps;

                                if (steps != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 200,
                                        child: SolutionStepsDialog(
                                          steps: steps,
                                        ),
                                      );
                                    },
                                  );
                                }
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
