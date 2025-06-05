import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final double? height;
  final double? weight;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? fitnessGoal;
  final double? dailyCalorieTarget;
  final double? dailyWaterTarget;
  final int? dailyStepsTarget;
  final String? activityLevel;
  final Map<String, double>? heartRateRange;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.height,
    this.weight,
    this.dateOfBirth,
    this.gender,
    this.fitnessGoal,
    this.dailyCalorieTarget,
    this.dailyWaterTarget,
    this.dailyStepsTarget,
    this.activityLevel,
    this.heartRateRange,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Convert heartRateRange values to doubles
    Map<String, double>? heartRateRange;
    if (data['heartRateRange'] != null) {
      heartRateRange = {};
      final Map<String, dynamic> rawRanges = Map<String, dynamic>.from(data['heartRateRange']);
      rawRanges.forEach((key, value) {
        if (value is int) {
          heartRateRange![key] = value.toDouble();
        } else if (value is double) {
          heartRateRange![key] = value;
        }
      });
    }

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      height: data['height'] != null ?
        (data['height'] is int ? (data['height'] as int).toDouble() : data['height']) : null,
      weight: data['weight'] != null ?
        (data['weight'] is int ? (data['weight'] as int).toDouble() : data['weight']) : null,
      dateOfBirth: data['dateOfBirth'] != null && data['dateOfBirth'] is Timestamp
          ? (data['dateOfBirth'] as Timestamp).toDate()
          : data['dateOfBirth'] != null
              ? DateTime.tryParse(data['dateOfBirth'].toString())
              : null,
      gender: data['gender'],
      fitnessGoal: data['fitnessGoal'],
      dailyCalorieTarget: data['dailyCalorieTarget'] != null ?
        (data['dailyCalorieTarget'] is int ? (data['dailyCalorieTarget'] as int).toDouble() : data['dailyCalorieTarget']) : null,
      dailyWaterTarget: data['dailyWaterTarget'] != null ?
        (data['dailyWaterTarget'] is int ? (data['dailyWaterTarget'] as int).toDouble() : data['dailyWaterTarget']) : null,
      dailyStepsTarget: data['dailyStepsTarget'],
      activityLevel: data['activityLevel'],
      heartRateRange: heartRateRange,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'fitnessGoal': fitnessGoal,
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyWaterTarget': dailyWaterTarget,
      'dailyStepsTarget': dailyStepsTarget,
      'activityLevel': activityLevel,
      'heartRateRange': heartRateRange,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    double? height,
    double? weight,
    DateTime? dateOfBirth,
    String? gender,
    String? fitnessGoal,
    double? dailyCalorieTarget,
    double? dailyWaterTarget,
    int? dailyStepsTarget,
    String? activityLevel,
    Map<String, double>? heartRateRange,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyWaterTarget: dailyWaterTarget ?? this.dailyWaterTarget,
      dailyStepsTarget: dailyStepsTarget ?? this.dailyStepsTarget,
      activityLevel: activityLevel ?? this.activityLevel,
      heartRateRange: heartRateRange ?? this.heartRateRange,
    );
  }
}
