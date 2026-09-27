import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 0)
class ActivityModel extends HiveObject {
  @HiveField(0)
  final String type;

  @HiveField(1)
  final int duration;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final String date;

  ActivityModel({
    required this.type,
    required this.duration,
    required this.calories,
    required this.date,
  });
}
