import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
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
                    flex: 1, // Chiếm 1 phần không gian
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSmallInfoCard(
                          icon: Icons.favorite,
                          iconColor: Colors.redAccent,
                          label: ' HR',
                          value: '80 BPM',
                        ),
                        SizedBox(height: 12),
                        _buildSmallInfoCard(
                          icon: Icons.scale,
                          iconColor: Colors.blueAccent,
                          label: 'Weight',
                          value: '69 Kg',
                        ),
                        SizedBox(height: 12),
                        _buildSmallInfoCard(
                          icon: Icons.track_changes,
                          iconColor: Colors.orangeAccent,
                          label: 'Mục tiêu',
                          value: '0%',
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
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFF30C9B7),
        tooltip: 'Thêm mới',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildStepsCard() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Color(0xFF30C9B7), // Màu teal
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
              Icon(
                Icons.local_fire_department,
                color: Colors.white,
                size: 29,
              ), // Icon bước chân
              SizedBox(width: 8),
              Text(
                'Kcal',
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
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 8,
                ),
              ),
              child: Center(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(
                      0.2,
                    ), // Vòng tròn mờ bên trong
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '350',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: iconColor, size: 22),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
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
              color: Color(0xFF30C9B7).withOpacity(0.2), // Màu teal nhạt
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
