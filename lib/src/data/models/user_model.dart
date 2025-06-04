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

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      height: data['height']?.toDouble(),
      weight: data['weight']?.toDouble(),
      dateOfBirth: data['dateOfBirth'] != null ? (data['dateOfBirth'] as Timestamp).toDate() : null,
      gender: data['gender'],
      fitnessGoal: data['fitnessGoal'],
      dailyCalorieTarget: data['dailyCalorieTarget']?.toDouble(),
      dailyWaterTarget: data['dailyWaterTarget']?.toDouble(),
      dailyStepsTarget: data['dailyStepsTarget'],
      activityLevel: data['activityLevel'],
      heartRateRange: data['heartRateRange'] != null
        ? Map<String, double>.from(data['heartRateRange'])
        : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'dateOfBirth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'fitnessGoal': fitnessGoal,
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyWaterTarget': dailyWaterTarget,
      'dailyStepsTarget': dailyStepsTarget,
      'activityLevel': activityLevel,
      'heartRateRange': heartRateRange,
    };
  }
}
