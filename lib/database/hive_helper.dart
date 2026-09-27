import 'package:fitness/models/activity_model.dart';
import 'package:hive/hive.dart';

class HiveHelper {
  static const String activitiesBoxName = 'activitiesBox';

  static Future<void> init() async {
    await Hive.openBox<ActivityModel>(activitiesBoxName);
  }

  static Box<ActivityModel> get activitiesBox =>
      Hive.box<ActivityModel>(activitiesBoxName);

  static Future<void> addActivity(ActivityModel activity) async {
    await activitiesBox.add(activity);
  }

  static List<ActivityModel> getAllActivities() {
    return activitiesBox.values.toList();
  }

  static List<ActivityModel> getTodayActivities() {
    final today = DateTime.now().toIso8601String().substring(0, 10);

    return activitiesBox.values
        .where((activity) => activity.date == today)
        .toList();
  }

  static Future<void> deleteActivity(ActivityModel activity) async {
    await activity.delete();
  }
}
