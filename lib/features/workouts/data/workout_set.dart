class WorkoutSet {
  final int setNumber;
  final String previous;
  double weight;
  int reps;
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.previous,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });
}
