import 'package:flutter/material.dart';
import 'package:my_wellness/src/core/recipe/identify_3_colors.dart';
import 'package:my_wellness/src/screens/home/dialogaddhabit.dart';
import 'package:my_wellness/src/widget/canhbaohr.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Homepage();
  }
}

class Homepage extends State<HomePage> {
  static double Hr = 189; // Giá trị HR hiện tại
  Color ColorHr = identify_3_colors_exception(
    Hr,
    [60, 100],
    [50, 59],
    [20, 49],
    [120, 200],
    Colors.red,
    Colors.orange,
  );

  static double Weight = 69; // Giá trị Weight hiện tại
  double Kcal = 520; // Giá trị Kcal hiện tại
  double DailyGoal = 0.35; // % Hoàn thành các hoạt động hiện tại

  @override
  void initState() {
    super.initState();
    if (ColorHr == Colors.orange) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => Canhbaohr(HR: Hr),
            barrierDismissible: true,
          );
        }
      });
    }
    if (ColorHr == Colors.red) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => NguyHiemHR(HR: Hr),
            barrierDismissible: true,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _buildStepsCard()),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildSmallInfoCard(
                          icon: Icons.favorite,
                          iconColor: Colors.redAccent,
                          label: ' HR',
                          value: Text(
                            '${Hr.toInt()} bpm',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ColorHr,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildSmallInfoCard(
                          icon: Icons.scale,
                          iconColor: Colors.blueAccent,
                          label: 'Weight',
                          value: Text(
                            '69 kg',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 12),
                        _buildSmallInfoCard(
                          icon: Icons.local_fire_department,
                          iconColor: Colors.orangeAccent,
                          label: 'Kcal',
                          value: Text(
                            '520 ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSportsCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            useSafeArea: true,
            // animationStyle: AnimationStyle(
            //   curve: Curves.fastLinearToSlowEaseIn,
            //   duration: Duration(milliseconds: 400),
            // ),
            context: context,
            builder: (context) {
              return AddHabitDialog();
            },
          );
        },
        backgroundColor: Color(0xFF30C9B7),
        tooltip: 'Thêm mới',
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildStepsCard() {
    // tiến trình (0.0 đến 1.0)
    double currentProgress = 0.35;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color(0xFF30C9B7),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Colors.white, size: 29),
              SizedBox(width: 8),
              Text(
                'DailyGoal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              width: 130,
              height: 130,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.3),
                    ),
                  ),
                  CircularProgressIndicator(
                    value: currentProgress,
                    strokeWidth: 8,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    backgroundColor: Colors.transparent,
                  ),
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '35%', // % hòàn thành mục tiêu hằng ngày
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required Text value,
    VoidCallback? onTap, // Thêm tham số onTap
  }) {
    return InkWell(
      // Bọc bằng InkWell để có hiệu ứng gợn sóng và xử lý onTap
      onTap: onTap, // Gán callback
      borderRadius: BorderRadius.circular(
        15.0,
      ), // Để hiệu ứng gợn sóng khớp với bo góc của Container
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          // ... (Nội dung còn lại của Row giữ nguyên)
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Expanded(child: value),
          ],
        ),
      ),
    );
  }

  Widget _buildSportsCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF30C9B7).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.fitness_center,
              color: Color(0xFF30C9B7),
              size: 28,
            ), // Icon tạ
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '--km',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Thể thao',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        ],
      ),
    );
  }
}
