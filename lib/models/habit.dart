import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String name;
  final String type; // "drink_water", "exercise", etc.
  final String goalType; // "count", "task"
  final double targetValue;
  final int repeatStyle; // 0: daily, 1: specific days, 2: interval
  final List<String>? selectedDays; // ["Monday", "Wednesday", "Friday"]
  final int? intervalDays; // For every X days
  final DateTime createdAt;
  final bool isActive;
  final List<HabitReminder>? reminders;

  Habit({
    required this.id,
    required this.name,
    required this.type,
    required this.goalType,
    required this.targetValue,
    required this.repeatStyle,
    this.selectedDays,
    this.intervalDays,
    required this.createdAt,
    required this.isActive,
    this.reminders,
  });

  factory Habit.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<HabitReminder>? reminderList;
    if (data['reminders'] != null) {
      reminderList = (data['reminders'] as List)
        .map((item) => HabitReminder.fromMap(item))
        .toList();
    }

    return Habit(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      goalType: data['goalType'] ?? 'count',
      targetValue: data['targetValue']?.toDouble() ?? 0.0,
      repeatStyle: data['repeatStyle'] ?? 0,
      selectedDays: data['selectedDays'] != null
        ? List<String>.from(data['selectedDays'])
        : null,
      intervalDays: data['intervalDays'],
      createdAt: data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
      isActive: data['isActive'] ?? true,
      reminders: reminderList,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'goalType': goalType,
      'targetValue': targetValue,
      'repeatStyle': repeatStyle,
      'selectedDays': selectedDays,
      'intervalDays': intervalDays,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'reminders': reminders?.map((reminder) => reminder.toMap()).toList(),
    };
  }

  // Create a copy of this habit with updated properties
  Habit copyWith({
    String? name,
    String? type,
    String? goalType,
    double? targetValue,
    int? repeatStyle,
    List<String>? selectedDays,
    int? intervalDays,
    DateTime? createdAt,
    bool? isActive,
    List<HabitReminder>? reminders,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      goalType: goalType ?? this.goalType,
      targetValue: targetValue ?? this.targetValue,
      repeatStyle: repeatStyle ?? this.repeatStyle,
      selectedDays: selectedDays ?? this.selectedDays,
      intervalDays: intervalDays ?? this.intervalDays,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      reminders: reminders ?? this.reminders,
    );
  }

  // Check if habit should be active for the given date
  bool isActiveForDate(DateTime date) {
    if (!isActive) return false;

    switch (repeatStyle) {
      case 0: // daily
        return true;
      case 1: // specific days
        if (selectedDays == null || selectedDays!.isEmpty) return false;
        String dayName = _getDayName(date.weekday);
        return selectedDays!.contains(dayName);
      case 2: // interval
        if (intervalDays == null || intervalDays! <= 0) return false;
        final difference = date.difference(createdAt).inDays;
        return difference % intervalDays! == 0;
      default:
        return false;
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }
}

class HabitReminder {
  final String time; // "08:00" format
  final String message;
  final bool isActive;

  HabitReminder({
    required this.time,
    required this.message,
    required this.isActive,
  });

  factory HabitReminder.fromMap(Map<String, dynamic> map) {
    return HabitReminder(
      time: map['time'] ?? '',
      message: map['message'] ?? '',
      isActive: map['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'message': message,
      'isActive': isActive,
    };
  }
}
