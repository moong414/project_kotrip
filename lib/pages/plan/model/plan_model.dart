class PlanModel {
  final String time;
  final String? place;
  final String todo;

  PlanModel({required this.time, this.place, required this.todo});

  Map<String, dynamic> toMap() {
    return {'time': time, 'place': place ?? '', 'todo': todo};
  }

  factory PlanModel.fromMap(Map<String, dynamic> map) {
    return PlanModel(
      time: map['time'] ?? '',
      place: map['place'],
      todo: map['todo'] ?? '',
    );
  }
}
