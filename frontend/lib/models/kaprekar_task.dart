class KaprekarTask {
  final int id;
  final int startingNum;
  final List? solutionSteps;

  const KaprekarTask({
    required this.id,
    required this.startingNum,
    this.solutionSteps,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'startingNum': this.startingNum,
      'solutionSteps': this.solutionSteps,
    };
  }

  factory KaprekarTask.fromMap(Map<String, dynamic> map) {
    return KaprekarTask(
      id: map['id'] as int,
      startingNum: map['starting_num'] as int,
      solutionSteps: map['solution_steps'] != null
          ? map['solution_steps'] as List
          : null,
    );
  }
}
