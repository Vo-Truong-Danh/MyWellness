import 'package:cloud_firestore/cloud_firestore.dart';

class HeartRateEntry {
  final DateTime time;
  final double value;
  
  HeartRateEntry({
    required this.time,
    required this.value,
  });
  
  factory HeartRateEntry.fromMap(Map<String, dynamic> map) {
    return HeartRateEntry(
      time: (map['time'] as Timestamp).toDate(),
      value: map['value']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': Timestamp.fromDate(time),
      'value': value,
    };
  }
}

class BloodPressureEntry {
  final DateTime time;
  final int systolic;
  final int diastolic;

  BloodPressureEntry({
    required this.time,
    required this.systolic,
    required this.diastolic,
  });

  factory BloodPressureEntry.fromMap(Map<String, dynamic> map) {
    return BloodPressureEntry(
      time: (map['time'] as Timestamp).toDate(),
      systolic: map['systolic'] ?? 0,
      diastolic: map['diastolic'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': Timestamp.fromDate(time),
      'systolic': systolic,
      'diastolic': diastolic,
    };
  }
}

class FoodEntry {
  final String name;
  final double calories;
  final String? mealType; // breakfast, lunch, dinner, snack
  final Map<String, double>? macros; // protein, carbs, fat
  final double? quantity;
  final String? unit;
  final DateTime loggedAt;

  FoodEntry({
    required this.name,
    required this.calories,
    this.mealType,
    this.macros,
    this.quantity,
    this.unit,
    required this.loggedAt,
  });

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    return FoodEntry(
      name: map['name'] ?? '',
      calories: map['calories']?.toDouble() ?? 0.0,
      mealType: map['mealType'],
      macros: map['macros'] != null ? Map<String, double>.from(map['macros']) : null,
      quantity: map['quantity']?.toDouble(),
      unit: map['unit'],
      loggedAt: (map['loggedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'mealType': mealType,
      'macros': macros,
      'quantity': quantity,
      'unit': unit,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }
}

class WorkoutEntry {
  final String name;
  final String type; // cardio, strength, flexibility
  final int? durationMinutes;
  final double? caloriesBurned;
  final List<Map<String, dynamic>>? sets; // for strength workouts: [{'reps': 10, 'weight': 50.0}]
  final String? intensity; // low, medium, high
  final DateTime loggedAt;

  WorkoutEntry({
    required this.name,
    required this.type,
    this.durationMinutes,
    this.caloriesBurned,
    this.sets,
    this.intensity,
    required this.loggedAt,
  });

  factory WorkoutEntry.fromMap(Map<String, dynamic> map) {
    return WorkoutEntry(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      durationMinutes: map['durationMinutes'],
      caloriesBurned: map['caloriesBurned']?.toDouble(),
      sets: map['sets'] != null ? List<Map<String, dynamic>>.from(map['sets']) : null,
      intensity: map['intensity'],
      loggedAt: (map['loggedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'sets': sets,
      'intensity': intensity,
      'loggedAt': Timestamp.fromDate(loggedAt),
    };
  }
}
