import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_log.dart';
import '../models/user_model.dart';
import '../models/health_entries.dart';
import '../services/health_data_service.dart';

class HealthDataProvider extends ChangeNotifier {
  final HealthDataService _service = HealthDataService();

  UserModel? _userData;
  UserModel? get userData => _userData;

  DailyLog? _dailyLog;
  DailyLog? get dailyLog => _dailyLog;

  bool _loading = false;
  bool get loading => _loading;

  // Lấy thông tin người dùng
  Future<void> loadUserData() async {
    _loading = true;
    notifyListeners();

    _userData = await _service.getUserData();

    _loading = false;
    notifyListeners();
  }

  // Lấy nhật ký ngày
  Future<void> loadDailyLog(DateTime date) async {
    _loading = true;
    notifyListeners();

    try {
      _dailyLog = await _service.getDailyLog(date);
      print("Đã tải nhật ký cho ngày: ${DateFormat('yyyy-MM-dd').format(date)}");
      if (_dailyLog != null) {
        print("Đã tìm thấy dữ liệu: ${_dailyLog!.nutritionLogs?.length ?? 0} món ăn, ${_dailyLog!.workoutLogs?.length ?? 0} bài tập");
      } else {
        print("Không tìm thấy dữ liệu cho ngày này");
      }
    } catch (e) {
      print("Lỗi khi tải nhật ký: $e");
    }

    _loading = false;
    notifyListeners();
  }

  // Lấy nhịp tim mới nhất
  double? getLatestHeartRate() {
    if (_dailyLog?.heartRateReadings == null || _dailyLog!.heartRateReadings!.isEmpty) {
      return null;
    }
    // Sắp xếp theo thời gian giảm dần và lấy giá trị đầu tiên
    final sortedReadings = List.of(_dailyLog!.heartRateReadings!)
      ..sort((a, b) => b.time.compareTo(a.time));

    return sortedReadings.first.value;
  }

  // Lấy huyết áp mới nhất
  BloodPressureEntry? getLatestBloodPressure() {
    if (_dailyLog?.bloodPressureReadings == null || _dailyLog!.bloodPressureReadings!.isEmpty) {
      return null;
    }
    // Sắp xếp theo thời gian giảm dần và lấy giá trị đầu tiên
    final sortedReadings = List.of(_dailyLog!.bloodPressureReadings!)
      ..sort((a, b) => b.time.compareTo(a.time));

    return sortedReadings.first;
  }

  // Thêm chỉ số nhịp tim
  Future<bool> addHeartRateReading(double value, DateTime date) async {
    final success = await _service.addHeartRateReading(value, date);
    if (success) {
      await loadDailyLog(date); // Tải lại dữ liệu
    }
    return success;
  }

  // Thêm chỉ số huyết áp
  Future<bool> addBloodPressureReading(int systolic, int diastolic, DateTime date) async {
    final success = await _service.addBloodPressureReading(systolic, diastolic, date);
    if (success) {
      await loadDailyLog(date); // Tải lại dữ liệu
    }
    return success;
  }

  // Cập nhật lượng nước đã uống
  Future<bool> updateWaterIntake(double amount, DateTime date) async {
    final success = await _service.updateWaterIntake(amount, date);
    if (success) {
      await loadDailyLog(date); // Tải lại dữ liệu
    }
    return success;
  }

  // Thêm món ăn
  Future<bool> addFoodEntry(String name, double calories, String? mealType,
      Map<String, double>? macros, DateTime date) async {
    final foodEntry = FoodEntry(
      name: name,
      calories: calories,
      mealType: mealType,
      macros: macros,
      loggedAt: DateTime.now(),
    );

    final success = await _service.addFoodEntry(foodEntry, date);
    if (success) {
      await loadDailyLog(date); // Tải lại dữ liệu
    }
    return success;
  }

  // Thêm bài tập
  Future<bool> addWorkoutEntry(String name, String type, int? durationMinutes,
      double? caloriesBurned, String? intensity, DateTime date) async {
    final workoutEntry = WorkoutEntry(
      name: name,
      type: type,
      durationMinutes: durationMinutes,
      caloriesBurned: caloriesBurned,
      intensity: intensity,
      loggedAt: DateTime.now(),
    );

    final success = await _service.addWorkoutEntry(workoutEntry, date);
    if (success) {
      await loadDailyLog(date); // Tải lại dữ liệu
    }
    return success;
  }

  // Cập nhật cân nặng
  Future<bool> updateWeight(double weight, DateTime date) async {
    final success = await _service.updateWeight(weight, date);
    if (success) {
      await loadUserData(); // Tải lại thông tin người dùng
      await loadDailyLog(date); // Tải lại nhật ký của ngày
    }
    return success;
  }

  // Tính toán tổng lượng calo đã tiêu thụ trong ngày
  double getTotalCalories() {
    if (_dailyLog?.loggedCalories == null) return 0.0;
    return _dailyLog!.loggedCalories!;
  }

  // Tính toán tỷ lệ hoàn thành mục tiêu calo
  double getCalorieProgress() {
    if (_userData?.dailyCalorieTarget == null || _userData!.dailyCalorieTarget == 0) {
      return 0.0;
    }

    double total = getTotalCalories();
    return total / _userData!.dailyCalorieTarget!;
  }

  // Tính toán tỷ lệ hoàn thành mục tiêu hàng ngày (dựa trên nhiều yếu tố)
  double getDailyGoalProgress() {
    if (_userData == null || _dailyLog == null) return 0.0;

    // Giả sử mục tiêu hàng ngày là tổng hợp từ nhiều yếu tố: nước, calo, bước chân, thói quen
    double waterProgress = 0.0;
    if (_userData?.dailyWaterTarget != null && _userData!.dailyWaterTarget! > 0) {
      waterProgress = (_dailyLog?.currentWaterIntake ?? 0) / _userData!.dailyWaterTarget!;
    }

    double calorieProgress = getCalorieProgress();

    double stepsProgress = 0.0;
    if (_userData?.dailyStepsTarget != null && _userData!.dailyStepsTarget! > 0) {
      stepsProgress = (_dailyLog?.currentSteps ?? 0) / _userData!.dailyStepsTarget!;
    }

    // Giới hạn mỗi tiến trình tối đa là 1.0
    waterProgress = waterProgress > 1.0 ? 1.0 : waterProgress;
    calorieProgress = calorieProgress > 1.0 ? 1.0 : calorieProgress;
    stepsProgress = stepsProgress > 1.0 ? 1.0 : stepsProgress;

    // Trọng số cho mỗi tiến trình
    const double waterWeight = 0.3;
    const double calorieWeight = 0.3;
    const double stepsWeight = 0.4;

    // Tính toán tiến trình tổng thể
    double overallProgress = (waterProgress * waterWeight) +
                             (calorieProgress * calorieWeight) +
                             (stepsProgress * stepsWeight);

    return overallProgress;
  }
}
