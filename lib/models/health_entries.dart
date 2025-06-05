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
      time: map['time'] != null
          ? (map['time'] is Timestamp
              ? (map['time'] as Timestamp).toDate()
              : DateTime.tryParse(map['time'].toString()) ?? DateTime.now())
          : DateTime.now(),
      value: map['value'] is int
          ? (map['value'] as int).toDouble()
          : map['value']?.toDouble() ?? 0.0,
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
      time: map['time'] != null && map['time'] is Timestamp
          ? (map['time'] as Timestamp).toDate()
          : DateTime.tryParse(map['time'].toString()) ?? DateTime.now(),
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
  final String? id; // Add id property
  final String name;
  final double calories;
  final String? mealType; // breakfast, lunch, dinner, snack
  final Map<String, double>? macros; // protein, carbs, fat
  final double? quantity;
  final String? unit;
  final DateTime loggedAt;

  FoodEntry({
    this.id, // Make it optional but accessible
    required this.name,
    required this.calories,
    this.mealType,
    this.macros,
    this.quantity,
    this.unit,
    required this.loggedAt,
  });

  factory FoodEntry.fromMap(Map<String, dynamic> map) {
    // Xử lý calories - có thể là int hoặc double từ Firestore
    double calories = 0.0;
    if (map['calories'] != null) {
      calories = map['calories'] is int
          ? (map['calories'] as int).toDouble()
          : map['calories']?.toDouble() ?? 0.0;
    }

    // Xử lý macros
    Map<String, double>? macrosMap;
    if (map['macros'] != null) {
      macrosMap = {};
      (map['macros'] as Map<String, dynamic>).forEach((key, value) {
        if (value is int) {
          macrosMap![key] = value.toDouble();
        } else if (value is double) {
          macrosMap![key] = value;
        }
      });
    }

    // Xử lý quantity
    double? quantity;
    if (map['quantity'] != null) {
      quantity = map['quantity'] is int
          ? (map['quantity'] as int).toDouble()
          : map['quantity']?.toDouble();
    }

    return FoodEntry(
      id: map['id'],
      name: map['name'] ?? '',
      calories: calories,
      mealType: map['mealType'],
      macros: macrosMap,
      quantity: quantity,
      unit: map['unit'],
      loggedAt: (map['loggedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
  final String? id; // Add id property
  final String name;
  final String type; // cardio, strength, flexibility
  final int? durationMinutes;
  final double? caloriesBurned;
  final List<Map<String, dynamic>>? sets; // for strength workouts: [{'reps': 10, 'weight': 50.0}]
  final String? intensity; // low, medium, high
  final DateTime loggedAt;

  WorkoutEntry({
    this.id, // Make it optional but accessible
    required this.name,
    required this.type,
    this.durationMinutes,
    this.caloriesBurned,
    this.sets,
    this.intensity,
    required this.loggedAt,
  });

  factory WorkoutEntry.fromMap(Map<String, dynamic> map) {
    // Xử lý caloriesBurned - có thể là int hoặc double từ Firestore
    double? caloriesBurned;
    if (map['caloriesBurned'] != null) {
      caloriesBurned = map['caloriesBurned'] is int
          ? (map['caloriesBurned'] as int).toDouble()
          : map['caloriesBurned']?.toDouble();
    }

    return WorkoutEntry(
      id: map['id'],
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      durationMinutes: map['durationMinutes'],
      caloriesBurned: caloriesBurned,
      sets: map['sets'] != null ? List<Map<String, dynamic>>.from(map['sets']) : null,
      intensity: map['intensity'],
      loggedAt: (map['loggedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
