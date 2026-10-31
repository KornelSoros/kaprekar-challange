class KaprekarTask {
  final int id;
  final int startingNum;
  final int? earnedScore;
  final int? totalScore;
  final List<List<int>>? submittedSteps;
  final List<List<int>>? solutionSteps;

  const KaprekarTask({
    required this.id,
    required this.startingNum,
    this.earnedScore,
    this.totalScore,
    this.submittedSteps,
    this.solutionSteps,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'startingNum': this.startingNum,
      'earnedScore': this.earnedScore,
      'totalScore': this.totalScore,
      'submittedSteps': this.submittedSteps,
      'solutionSteps': this.solutionSteps,
    };
  }

  factory KaprekarTask.fromMap(Map<String, dynamic> map) {
    return KaprekarTask(
      id: map['id'] as int,
      startingNum: map['starting_num'] as int,
      earnedScore: map['earned_score'] != null
          ? (map['earned_score'] as int)
          : null,
      totalScore: map['total_score'] != null
          ? (map['total_score'] as int)
          : null,
      submittedSteps: map['submitted_steps'] != null
          ? (map['submitted_steps'] as List)
                .map((step) => List<int>.from(step as List))
                .toList()
          : null,

      solutionSteps: map['solution_steps'] != null
          ? (map['solution_steps'] as List)
                .map((step) => List<int>.from(step as List))
                .toList()
          : null,
    );
  }
}
