import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';
import 'package:my_wellness/src/screens/nutrition_tracking/add_food_screen.dart';
import 'package:my_wellness/src/screens/workout_tracking/add_workout_screen.dart';
import 'package:my_wellness/src/widget/add_options_bottom_sheet.dart';
import 'package:my_wellness/src/widget/health_card_row.dart';
import 'package:my_wellness/src/widget/habitcountcheck.dart';
import 'package:my_wellness/src/widget/habittaskcheck.dart';

// Global key to access HomePage state
final GlobalKey<_HomePageV2State> homePageKey = GlobalKey<_HomePageV2State>();

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: homePageKey);

  static void refreshData() {
    if (homePageKey.currentState != null) {
      homePageKey.currentState!.refreshData();
    }
  }

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  void refreshData() {
    final healthProvider = Provider.of<HealthDataProvider>(
      context,
      listen: false,
    );
    final dateProvider = Provider.of<SelectedDateProvider>(
      context,
      listen: false,
    );
    healthProvider.loadUserData();
    healthProvider.loadDailyLog(dateProvider.selectedDate);
    setState(() {});
  }

  void _showUpdateHealthDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Cập nhật thể trạng'),
            content: Text('Tính năng cập nhật thể trạng sẽ sớm được thêm vào.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Đóng'),
              ),
            ],
          ),
    );
  }

  void _showAddOptionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddOptionsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF30C9B7);
    final accentColor = Color(0xFF1E88E5);
    final backgroundColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor,
                Color(0xFF26A69A), // Màu thứ hai cho gradient đẹp hơn
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
            Text(
              'Sức Khỏe Của Tôi',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.update, color: Colors.white),
              onPressed: _showUpdateHealthDialog,
              tooltip: 'Cập nhật thể trạng',
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            refreshData();
            await Future.delayed(Duration(milliseconds: 500));
          },
          color: primaryColor,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateSelector(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HealthCardRow(),
                      _buildSectionHeader('Hoạt động thể thao', Icons.fitness_center),
                      SizedBox(height: 10), // Giảm từ 10 xuống 8
                      _buildSportsCard(),
                      SizedBox(height: 16), // Giảm từ 24 xuống 16
                      _buildSectionHeader('Nhật ký hôm nay', Icons.note_alt),
                      SizedBox(height: 12), // Giảm từ 10 xuống 8
                      _buildDailyLogSection(),
                      SizedBox(height: 16), // Giảm từ 24 xuống 16
                      _buildSectionHeader('Thói quen', Icons.repeat),
                      SizedBox(height: 10), // Giảm từ 10 xuống 8
                      _buildHabitsSection(),
                      SizedBox(height: 30), // Giảm từ 50 xuống 30
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddOptionsDialog,
        backgroundColor: primaryColor,
        icon: Icon(Icons.add),
        label: Text('Thêm'),
        elevation: 4,
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) => Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: Color(0xFF30C9B7)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildDailyLogSection() {
    final primaryColor = Color(0xFF30C9B7);

    return Consumer<HealthDataProvider>(
      builder: (_, provider, __) {
        final log = provider.dailyLog;
        if (log == null ||
            ((log.workoutLogs?.isEmpty ?? true) &&
                (log.nutritionLogs?.isEmpty ?? true))) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset('assets/images/diet.png', height: 60),
                SizedBox(height: 12),
                Text(
                  'Chưa có dữ liệu cho ngày hôm nay',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddFoodScreen()),
                        );
                      },
                      icon: Icon(Icons.restaurant_menu, size: 16),
                      label: Text('Thêm thực phẩm'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AddWorkoutScreen()),
                        );
                      },
                      icon: Icon(Icons.fitness_center, size: 16),
                      label: Text('Thêm bài tập'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        List<Widget> items = [];

        // Hiển thị tiêu đề phần nếu có dữ liệu tương ứng
        if (log.workoutLogs != null && log.workoutLogs!.isNotEmpty) {
          items.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 4.0),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Hoạt động thể thao',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
          items.addAll(_buildWorkoutLogs(provider));
          items.add(SizedBox(height: 16));
        }

        if (log.nutritionLogs != null && log.nutritionLogs!.isNotEmpty) {
          items.add(
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 4.0),
              child: Row(
                children: [
                  Icon(Icons.restaurant, color: Colors.blue.shade700, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Dinh dưỡng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          );
          items.addAll(_buildNutritionLogs(provider));
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items,
          ),
        );
      },
    );
  }

  List<Widget> _buildWorkoutLogs(HealthDataProvider provider) {
    final primaryColor = Color(0xFF30C9B7);

    return provider.dailyLog!.workoutLogs!.asMap().entries.map((entry) {
      final index = entry.key;
      final w = entry.value;
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Dismissible(
                key: Key('workout-${w.id ?? index}'),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Xóa hoạt động thể thao'),
                      content: Text('Bạn có chắc chắn muốn xóa hoạt động này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Xóa', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  // Delete workout entry
                  provider.deleteWorkout(w);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa hoạt động thể thao'),
                      backgroundColor: primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'HOÀN TÁC',
                        textColor: Colors.white,
                        onPressed: () {
                          provider.undoDeleteWorkout();
                        },
                      ),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.fitness_center, color: Colors.orange),
                  ),
                  title: Text(
                    w.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4),
                          Text(
                            w.type ?? 'Không phân loại',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.timer,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${w.durationMinutes} phút',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${w.caloriesBurned?.toInt() ?? 0} kcal',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildNutritionLogs(HealthDataProvider provider) {
    final primaryColor = Color(0xFF30C9B7);
    final backgroundColor = Color(0xFFF5F5F5);

    return provider.dailyLog!.nutritionLogs!.asMap().entries.map((entry) {
      final index = entry.key;
      final f = entry.value;
      return AnimationConfiguration.staggeredList(
        position: index,
        duration: Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.7), // Updated to match main background better
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Dismissible(
                key: Key('nutrition-${f.id ?? index}'),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Xóa bữa ăn'),
                      content: Text('Bạn có chắc chắn muốn xóa bữa ăn này?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Xóa', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  // Delete nutrition entry
                  provider.deleteNutrition(f);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã xóa bữa ăn'),
                      backgroundColor: primaryColor,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      action: SnackBarAction(
                        label: 'HOÀN TÁC',
                        textColor: Colors.white,
                        onPressed: () {
                          // Undo logic could be added here
                          provider.undoDeleteNutrition();
                        },
                      ),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.restaurant, color: Colors.blue),
                  ),
                  title: Text(
                    f.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.lunch_dining,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4),
                          Text(
                            f.mealType ?? 'Không phân loại',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${f.calories.toInt()} calories',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${f.calories.toInt()} kcal',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDateSelector() {
    return Consumer<SelectedDateProvider>(
      builder: (context, dp, child) {
        final selected = dp.selectedDate;
        final today = DateTime.now();
        final start = selected.subtract(Duration(days: selected.weekday % 7));
        final week = List.generate(7, (i) => start.add(Duration(days: i)));
        final primaryColor = Color(0xFF30C9B7);

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, Color(0xFF26A69A)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Hiện thị thông tin lựa chọn
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: dp.previousWeek,
                      borderRadius: BorderRadius.circular(30),
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'calendar_header',
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            // In hoa chữ T trong tháng bằng cách xử lý chuỗi sau định dạng
                            DateFormat(
                              'MMMM yyyy',
                              'vi_VN',
                            ).format(selected).replaceFirst('t', 'T'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: dp.nextWeek,
                      borderRadius: BorderRadius.circular(30),
                      splashColor: Colors.white.withOpacity(0.3),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 115,
                child: AnimationLimiter(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: week.length,
                    itemBuilder: (context, index) {
                      final date = week[index];
                      final isSelected =
                          date.year == selected.year &&
                          date.month == selected.month &&
                          date.day == selected.day;
                      final isToday =
                          date.year == today.year &&
                          date.month == today.month &&
                          date.day == today.day;

                      // Tạo điểm hoạt động giả để hiển thị
                      final hasActivity =
                          date.day % 3 == 0; // Giả lập ngày có hoạt động

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 375),
                        child: SlideAnimation(
                          horizontalOffset: 50.0,
                          child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                dp.setDate(date);
                                Provider.of<HealthDataProvider>(
                                  context,
                                  listen: false,
                                ).loadDailyLog(date);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: EdgeInsets.symmetric(horizontal: 6),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 8,
                                              offset: Offset(0, 2),
                                            ),
                                          ]
                                          : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'E',
                                        'vi_VN',
                                      ).format(date).toUpperCase(),
                                      style: TextStyle(
                                        color:
                                            isSelected
                                                ? primaryColor
                                                : Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                isToday && !isSelected
                                                    ? Colors.white.withOpacity(
                                                      0.3,
                                                    )
                                                    : isSelected
                                                    ? primaryColor.withOpacity(
                                                      0.1,
                                                    )
                                                    : Colors.transparent,
                                            border:
                                                isToday
                                                    ? Border.all(
                                                      color:
                                                          isSelected
                                                              ? primaryColor
                                                              : Colors.white,
                                                      width: 2,
                                                    )
                                                    : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isSelected
                                                        ? primaryColor
                                                        : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Chỉ báo có hoạt động
                                        if (hasActivity)
                                          Positioned(
                                            bottom: -2,
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    isSelected
                                                        ? primaryColor
                                                        : Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    // Hiển thị thông tin nếu là ngày hôm nay
                                    if (isToday)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              isSelected
                                                  ? primaryColor.withOpacity(
                                                    0.2,
                                                  )
                                                  : Colors.white.withOpacity(
                                                    0.3,
                                                  ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          'Hôm nay',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                isSelected
                                                    ? primaryColor
                                                    : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Hiển thị dòng chú thích ở dưới
            ],
          ),
        );
      },
    );
  }

  Widget _buildSportsCard() {
    final primaryColor = Color(0xFF30C9B7);

    return Consumer<HealthDataProvider>(
      builder: (_, provider, __) {
        final workouts = provider.dailyLog?.workoutLogs;
        if (workouts == null || workouts.isEmpty) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Image.asset('assets/images/exercise.png', height: 60),
                SizedBox(height: 12),
                Text(
                  'Chưa có hoạt động thể thao hôm nay',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade800),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddWorkoutScreen()),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white, size: 16),
                  label: Text(
                    'Thêm hoạt động',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          );
        }

        int totalMin = workouts.fold(
          0,
          (sum, w) => sum + (w.durationMinutes ?? 0),
        );
        int totalCal = workouts.fold(
          0,
          (sum, w) => sum + (w.caloriesBurned?.toInt() ?? 0),
        );

        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(Icons.timer, '$totalMin', 'phút', Colors.blue),
                  _statItem(Icons.whatshot, '$totalCal', 'kcal', Colors.orange),
                  _statItem(Icons.fitness_center, '${workouts.length}', 'hoạt động', primaryColor),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: primaryColor, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Hoạt động đã hoàn thành',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHabitsSection() {
    final primaryColor = Color(0xFF30C9B7);

    return AnimationConfiguration.staggeredList(
      position: 4,
      duration: Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 70.0,
        child: FadeInAnimation(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Tiêu đề phần
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Thói quen hàng ngày',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '2/3 hoàn thành',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

                // Thói quen uống nước
                _buildHabitItem(
                  icon: 'assets/images/water_glass.png',
                  title: 'Uống nước',
                  subtitle: 'Duy trì cơ thể khỏe mạnh',
                  badgeText: '5/8',
                  badgeIcon: Icons.water_drop,
                  badgeColor: Color(0xFF57C5F8),
                  isCompleted: false,
                  progress: 5 / 8,
                ),

                // Thói quen tập thể dục
                _buildHabitItem(
                  icon: 'assets/images/exercise.png',
                  title: 'Tập thể dục',
                  subtitle: 'Hôm nay 30 phút',
                  isCompleted: true,
                  completedColor: primaryColor,
                ),

                // Thói quen ngủ đủ giấc
                _buildHabitItem(
                  icon: 'assets/images/sleep.png',
                  title: 'Ngủ đủ giấc',
                  subtitle: 'Đặt mục tiêu 8 giờ mỗi đêm',
                  isCompleted: true,
                  completedColor: Color(0xFF8E44AD),
                ),

                Divider(height: 1, thickness: 1, color: Colors.grey.shade100),

                // Nút quản lý thói quen
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Tính năng quản lý thói quen đang được phát triển',
                          ),
                          backgroundColor: primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Quản lý thói quen',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHabitItem({
    required String icon,
    required String title,
    required String subtitle,
    String? badgeText,
    IconData? badgeIcon,
    Color? badgeColor,
    bool isCompleted = false,
    Color? completedColor,
    double? progress,
  }) {
    final primaryColor = Color(0xFF30C9B7);

    return Dismissible(
      key: Key('habit-$title'),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Xóa thói quen'),
            content: Text('Bạn có chắc chắn muốn xóa thói quen này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('H���y'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Xóa', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        // Delete habit
        // Ở đây cần thêm logic xóa thói quen khi đã tích hợp với cơ sở dữ liệu
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xóa thói quen: $title'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            action: SnackBarAction(
              label: 'HOÀN TÁC',
              textColor: Colors.white,
              onPressed: () {
                // Undo logic would be added here when implemented
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Đã khôi phục thói quen: $title'),
                    backgroundColor: primaryColor,
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        );
      },
      child: InkWell(
        onTap: () {
          // Xử lý khi nhấn vào thói quen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã cập nhật thói quen: $title'),
              backgroundColor: completedColor ?? Color(0xFF30C9B7),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (completedColor ?? Color(0xFF57C5F8)).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(icon, height: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    // Thanh tiến trình nếu có
                    if (progress != null) ...[
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          badgeColor ?? Color(0xFF57C5F8),
                        ),
                        minHeight: 5,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ],
                ),
              ),
              if (badgeText != null && badgeIcon != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        badgeColor?.withOpacity(0.1) ??
                        Color(0xFF57C5F8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        badgeText,
                        style: TextStyle(
                          color: badgeColor ?? Color(0xFF57C5F8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        badgeIcon,
                        color: badgeColor ?? Color(0xFF57C5F8),
                        size: 16,
                      ),
                    ],
                  ),
                )
              else if (isCompleted)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (completedColor ?? Color(0xFF30C9B7)).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: completedColor ?? Color(0xFF30C9B7),
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
