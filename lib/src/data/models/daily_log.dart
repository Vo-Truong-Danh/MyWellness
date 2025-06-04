import 'package:cloud_firestore/cloud_firestore.dart';
import 'health_entries.dart';

class DailyLog {
  final String id; // YYYY-MM-DD format
  final DateTime date;
  final double? currentWeight;
  final double? loggedCalories;
  final double? currentWaterIntake;
  final int? currentSteps;
  final List<HeartRateEntry>? heartRateReadings;
  final List<BloodPressureEntry>? bloodPressureReadings;
  final List<WorkoutEntry>? workoutLogs;
  final List<FoodEntry>? nutritionLogs;
  final Map<String, bool>? habitCompletions;

  DailyLog({
    required this.id,
    required this.date,
    this.currentWeight,
    this.loggedCalories,
    this.currentWaterIntake,
    this.currentSteps,
    this.heartRateReadings,
    this.bloodPressureReadings,
    this.workoutLogs,
    this.nutritionLogs,
    this.habitCompletions,
  });

  factory DailyLog.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<HeartRateEntry>? heartRateEntries;
    if (data['heartRateReadings'] != null) {
      heartRateEntries = (data['heartRateReadings'] as List)
        .map((entry) => HeartRateEntry.fromMap(entry as Map<String, dynamic>))
        .toList();
    }

    List<BloodPressureEntry>? bloodPressureEntries;
    if (data['bloodPressureReadings'] != null) {
      bloodPressureEntries = (data['bloodPressureReadings'] as List)
        .map((entry) => BloodPressureEntry.fromMap(entry as Map<String, dynamic>))
        .toList();
    }

    List<WorkoutEntry>? workoutEntries;
    if (data['workoutLogs'] != null) {
      workoutEntries = (data['workoutLogs'] as List)
        .map((entry) => WorkoutEntry.fromMap(entry as Map<String, dynamic>))
        .toList();
    }

    List<FoodEntry>? foodEntries;
    if (data['nutritionLogs'] != null) {
      foodEntries = (data['nutritionLogs'] as List)
        .map((entry) => FoodEntry.fromMap(entry as Map<String, dynamic>))
        .toList();
    }

    // Xử lý chuyển đổi kiểu dữ liệu đúng cách
    double? currentWeight;
    if (data['currentWeight'] != null) {
      currentWeight = data['currentWeight'] is int
          ? (data['currentWeight'] as int).toDouble()
          : data['currentWeight']?.toDouble();
    }

    double? loggedCalories;
    if (data['loggedCalories'] != null) {
      loggedCalories = data['loggedCalories'] is int
          ? (data['loggedCalories'] as int).toDouble()
          : data['loggedCalories']?.toDouble();
    }

    double? currentWaterIntake;
    if (data['currentWaterIntake'] != null) {
      currentWaterIntake = data['currentWaterIntake'] is int
          ? (data['currentWaterIntake'] as int).toDouble()
          : data['currentWaterIntake']?.toDouble();
    }

    return DailyLog(
      id: doc.id,
      date: data['date'] != null
        ? (data['date'] is Timestamp
            ? (data['date'] as Timestamp).toDate()
            : DateTime.tryParse(data['date'].toString()) ?? DateTime.now())
        : DateTime.now(),
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: data['currentSteps'],
      heartRateReadings: heartRateEntries,
      bloodPressureReadings: bloodPressureEntries,
      workoutLogs: workoutEntries,
      nutritionLogs: foodEntries,
      habitCompletions: data['habitCompletions'] != null
        ? Map<String, bool>.from(data['habitCompletions'])
        : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'currentWeight': currentWeight,
      'loggedCalories': loggedCalories,
      'currentWaterIntake': currentWaterIntake,
      'currentSteps': currentSteps,
      'heartRateReadings': heartRateReadings?.map((e) => e.toMap()).toList(),
      'bloodPressureReadings': bloodPressureReadings?.map((e) => e.toMap()).toList(),
      'workoutLogs': workoutLogs?.map((e) => e.toMap()).toList(),
      'nutritionLogs': nutritionLogs?.map((e) => e.toMap()).toList(),
      'habitCompletions': habitCompletions,
    };
  }

  // Create an empty daily log with just the date
  factory DailyLog.createEmpty(String dateStr) {
    return DailyLog(
      id: dateStr,
      date: DateTime.parse(dateStr),
      currentWeight: null,
      loggedCalories: 0,
      currentWaterIntake: 0,
      currentSteps: 0,
      heartRateReadings: [],
      bloodPressureReadings: [],
      workoutLogs: [],
      nutritionLogs: [],
      habitCompletions: {},
    );
  }

  // Add a heart rate reading to the daily log
  DailyLog addHeartRateReading(HeartRateEntry entry) {
    final List<HeartRateEntry> updatedReadings =
      [...(heartRateReadings ?? []), entry];

    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: currentSteps,
      heartRateReadings: updatedReadings,
      bloodPressureReadings: bloodPressureReadings,
      workoutLogs: workoutLogs,
      nutritionLogs: nutritionLogs,
      habitCompletions: habitCompletions,
    );
  }

  // Add a blood pressure reading to the daily log
  DailyLog addBloodPressureReading(BloodPressureEntry entry) {
    final List<BloodPressureEntry> updatedReadings =
      [...(bloodPressureReadings ?? []), entry];

    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: currentSteps,
      heartRateReadings: heartRateReadings,
      bloodPressureReadings: updatedReadings,
      workoutLogs: workoutLogs,
      nutritionLogs: nutritionLogs,
      habitCompletions: habitCompletions,
    );
  }

  // Add a workout to the daily log
  DailyLog addWorkout(WorkoutEntry entry) {
    final List<WorkoutEntry> updatedWorkouts =
      [...(workoutLogs ?? []), entry];

    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: currentSteps,
      heartRateReadings: heartRateReadings,
      bloodPressureReadings: bloodPressureReadings,
      workoutLogs: updatedWorkouts,
      nutritionLogs: nutritionLogs,
      habitCompletions: habitCompletions,
    );
  }

  // Add a food entry to the daily log
  DailyLog addFoodEntry(FoodEntry entry) {
    final List<FoodEntry> updatedEntries =
      [...(nutritionLogs ?? []), entry];
    final double newCalories = (loggedCalories ?? 0) + entry.calories;

    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: newCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: currentSteps,
      heartRateReadings: heartRateReadings,
      bloodPressureReadings: bloodPressureReadings,
      workoutLogs: workoutLogs,
      nutritionLogs: updatedEntries,
      habitCompletions: habitCompletions,
    );
  }

  // Update water intake
  DailyLog updateWaterIntake(double amount) {
    final double newAmount = (currentWaterIntake ?? 0) + amount;

    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: newAmount,
      currentSteps: currentSteps,
      heartRateReadings: heartRateReadings,
      bloodPressureReadings: bloodPressureReadings,
      workoutLogs: workoutLogs,
      nutritionLogs: nutritionLogs,
      habitCompletions: habitCompletions,
    );
  }

  // Update steps count
  DailyLog updateSteps(int steps) {
    return DailyLog(
      id: id,
      date: date,
      currentWeight: currentWeight,
      loggedCalories: loggedCalories,
      currentWaterIntake: currentWaterIntake,
      currentSteps: steps,
      heartRateReadings: heartRateReadings,
      bloodPressureReadings: bloodPressureReadings,
      workoutLogs: workoutLogs,
      nutritionLogs: nutritionLogs,
      habitCompletions: habitCompletions,
    );
  }
}
