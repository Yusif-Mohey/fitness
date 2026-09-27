import 'package:fitness/database/hive_helper.dart';
import 'package:fitness/models/activity_model.dart';
import 'package:fitness/views/add_activity_page.dart';
import 'package:fitness/widgets/cutom_progress.dart';
import 'package:fitness/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ActivityModel> todayActivities = [];
  bool isLoading = true;
  late int targetDailyKcal;
  int totalCalories = 0;
  int totalDuration = 0;
  int totalWorkouts = 0;

  @override
  void initState() {
    super.initState();

    targetDailyKcal = 1200;

    loadTodayData();
  }

  Future<void> loadTodayData() async {
    setState(() {
      isLoading = true;
    });

    final data = HiveHelper.getTodayActivities();

    int calories = 0;
    int duration = 0;

    for (var activity in data) {
      calories += activity.calories;
      duration += activity.duration;
    }

    setState(() {
      todayActivities = data;
      totalCalories = calories;
      totalDuration = duration;
      totalWorkouts = data.length;
      isLoading = false;
    });
  }

  Future<void> deleteActivity(ActivityModel activity) async {
    await HiveHelper.deleteActivity(activity);
    await loadTodayData();
  }

  double get progressValue {
    if (totalCalories >= targetDailyKcal) return 1;
    return totalCalories / targetDailyKcal;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddActivityPage()),
          );
          await loadTodayData();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Activity'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    const Color(0xFF0F0F14),
                    const Color(0xFF1B1B2F),
                    const Color(0xFF241B3A),
                  ]
                : [
                    const Color(0xFFF7F7FB),
                    const Color(0xFFEFF6FF),
                    const Color(0xFFEFFBF5),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: loadTodayData,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        'Fitness Tracker',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        today,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomProgress(
                        isDark: isDark,
                        progressValue: progressValue,
                        total: totalCalories,
                        targetDaily: targetDailyKcal,
                        type: 'Kacl',
                      ),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Workouts',
                              value: '$totalWorkouts',
                              icon: Icons.fitness_center_rounded,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              title: 'Minutes',
                              value: '$totalDuration',
                              icon: Icons.timer_rounded,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              title: 'Calories',
                              value: '$totalCalories',
                              icon: Icons.local_fire_department_rounded,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Text(
                        "Today's Activities",
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      if (todayActivities.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.05)
                                : Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : Colors.black.withValues(alpha: 0.04),
                            ),
                          ),
                          child: const Center(
                            child: Text('No activities logged today yet.'),
                          ),
                        )
                      else
                        ...todayActivities.map((activity) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.white.withValues(alpha: 0.95),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.04),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.directions_run_rounded,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.type,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${activity.duration} min • ${activity.calories} kcal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: isDark
                                                  ? Colors.white70
                                                  : Colors.black54,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => deleteActivity(activity),
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                      const SizedBox(height: 90),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
