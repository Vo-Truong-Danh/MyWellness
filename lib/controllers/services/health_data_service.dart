import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/daily_log.dart';
import '../../models/user_model.dart';
import '../../models/health_entries.dart';
import 'package:intl/intl.dart';

class HealthDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Lấy ID người dùng hiện tại
  String? get currentUserId => _auth.currentUser?.uid;

  // Lấy thông tin người dùng
  Future<UserModel?> getUserData() async {
    if (currentUserId == null) return null;

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(currentUserId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Lỗi khi lấy dữ liệu người dùng: $e');
      return null;
    }
  }

  // Lấy nhật ký sức khỏe theo ngày
  Future<DailyLog?> getDailyLog(DateTime date) async {
    if (currentUserId == null) return null;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('daily_logs')
              .doc(dateStr)
              .get();

      if (doc.exists) {
        return DailyLog.fromFirestore(doc);
      }

      // Trả về nhật ký trống nếu không tìm thấy dữ liệu cho ngày này
      return DailyLog.createEmpty(dateStr);
    } catch (e) {
      print('Lỗi khi lấy dữ liệu nhật ký ngày: $e');
      return null;
    }
  }

  // Thêm chỉ số nhịp tim
  Future<bool> addHeartRateReading(double value, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Tạo một bản ghi nhịp tim mới
      HeartRateEntry entry = HeartRateEntry(time: DateTime.now(), value: value);

      // Cập nhật hoặc tạo mới document tương ứng với ngày
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'heartRateReadings': FieldValue.arrayUnion([entry.toMap()]),
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi thêm chỉ số nhịp tim: $e');
      return false;
    }
  }

  // Thêm chỉ số huyết áp
  Future<bool> addBloodPressureReading(
    int systolic,
    int diastolic,
    DateTime date,
  ) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Tạo một bản ghi huyết áp mới
      BloodPressureEntry entry = BloodPressureEntry(
        time: DateTime.now(),
        systolic: systolic,
        diastolic: diastolic,
      );

      // Cập nhật hoặc tạo mới document tương ứng với ngày
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'bloodPressureReadings': FieldValue.arrayUnion([entry.toMap()]),
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi thêm chỉ số huyết áp: $e');
      return false;
    }
  }

  // Cập nhật lượng nước đã uống
  Future<bool> updateWaterIntake(double amount, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('daily_logs')
              .doc(dateStr)
              .get();

      double currentIntake = 0;
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        currentIntake = data['currentWaterIntake']?.toDouble() ?? 0;
      }

      // Cập nhật hoặc tạo mới document tương ứng với ngày
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'currentWaterIntake': currentIntake + amount,
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi cập nhật lượng nước: $e');
      return false;
    }
  }

  // Thêm món ăn vào nhật ký
  Future<bool> addFoodEntry(FoodEntry food, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Cập nhật hoặc tạo mới document tương ứng với ngày
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'nutritionLogs': FieldValue.arrayUnion([food.toMap()]),
            'loggedCalories': FieldValue.increment(food.calories),
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi thêm món ăn: $e');
      return false;
    }
  }

  // Thêm bài tập vào nhật ký
  Future<bool> addWorkoutEntry(WorkoutEntry workout, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Cập nhật hoặc tạo mới document tương ứng với ngày
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'workoutLogs': FieldValue.arrayUnion([workout.toMap()]),
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi thêm bài tập: $e');
      return false;
    }
  }

  // Xóa bài tập khỏi nhật ký
  Future<bool> deleteWorkout(String workoutId, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Lấy dữ liệu hiện tại
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('daily_logs')
              .doc(dateStr)
              .get();

      if (!doc.exists) return false;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> workouts = data['workoutLogs'] ?? [];

      // Lọc bỏ workout cần xóa
      List<dynamic> updatedWorkouts =
          workouts.where((workout) {
            return workout['id'] != workoutId;
          }).toList();

      // Cập nhật lại danh sách workout
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .update({'workoutLogs': updatedWorkouts});

      return true;
    } catch (e) {
      print('Lỗi khi xóa bài tập: $e');
      return false;
    }
  }

  // Xóa món ăn khỏi nhật ký
  Future<bool> deleteNutrition(String nutritionId, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Lấy dữ liệu hiện tại
      DocumentSnapshot doc =
          await _firestore
              .collection('users')
              .doc(currentUserId)
              .collection('daily_logs')
              .doc(dateStr)
              .get();

      if (!doc.exists) return false;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> nutritions = data['nutritionLogs'] ?? [];

      // Tìm món ăn cần xóa để trừ calories
      double caloriesToSubtract = 0;
      for (var nutrition in nutritions) {
        if (nutrition['id'] == nutritionId && nutrition['calories'] != null) {
          caloriesToSubtract =
              (nutrition['calories'] is int)
                  ? (nutrition['calories'] as int).toDouble()
                  : nutrition['calories']?.toDouble() ?? 0;
          break;
        }
      }

      // Lọc bỏ món ăn cần xóa
      List<dynamic> updatedNutritions =
          nutritions.where((nutrition) {
            return nutrition['id'] != nutritionId;
          }).toList();

      // Cập nhật lại danh sách món ăn và giảm calories
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .update({
            'nutritionLogs': updatedNutritions,
            'loggedCalories': FieldValue.increment(-caloriesToSubtract),
          });

      return true;
    } catch (e) {
      print('Lỗi khi xóa món ăn: $e');
      return false;
    }
  }

  // Cập nhật cân nặng
  Future<bool> updateWeight(double weight, DateTime date) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Cập nhật cân nặng cho ngày cụ thể
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'currentWeight': weight,
          }, SetOptions(merge: true));

      // Cập nhật cân nặng mới nhất cho thông tin người dùng
      await _firestore.collection('users').doc(currentUserId).update({
        'weight': weight,
      });

      return true;
    } catch (e) {
      print('Lỗi khi cập nhật cân nặng: $e');
      return false;
    }
  }

  // Cập nhật hoàn thành thói quen
  Future<bool> updateHabitCompletion(
    String habitId,
    bool completed,
    DateTime date,
  ) async {
    if (currentUserId == null) return false;

    String dateStr = DateFormat('yyyy-MM-dd').format(date);

    try {
      // Cập nhật trạng thái hoàn thành thói quen cho ngày cụ thể
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('daily_logs')
          .doc(dateStr)
          .set({
            'date': Timestamp.fromDate(date),
            'habitCompletions': {habitId: completed},
          }, SetOptions(merge: true));

      return true;
    } catch (e) {
      print('Lỗi khi cập nhật hoàn thành thói quen: $e');
      return false;
    }
  }
}
