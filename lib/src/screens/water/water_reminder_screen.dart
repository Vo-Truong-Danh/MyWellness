import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WaterReminderScreen extends StatefulWidget {
  @override
  _WaterReminderScreenState createState() => _WaterReminderScreenState();
}

class _WaterReminderScreenState extends State<WaterReminderScreen> {
  bool _isLoading = false;
  bool _isReminderEnabled = false;
  int _targetWaterIntake = 2000; // ml
  int _currentWaterIntake = 0;
  int _glassSize = 250; // ml

  // Thời gian nhắc nhở
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 22, minute: 0);
  int _reminderInterval = 120; // phút

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Tải cài đặt từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool enabled = prefs.getBool('water_reminder_enabled') ?? false;
      int target = prefs.getInt('water_target') ?? 2000;
      int glass = prefs.getInt('water_glass_size') ?? 250;
      int interval = prefs.getInt('water_reminder_interval') ?? 120;
      int startHour = prefs.getInt('water_start_hour') ?? 8;
      int startMinute = prefs.getInt('water_start_minute') ?? 0;
      int endHour = prefs.getInt('water_end_hour') ?? 22;
      int endMinute = prefs.getInt('water_end_minute') ?? 0;

      // Tải dữ liệu nước uống hôm nay từ Firestore
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health_records')
            .where('date', isEqualTo: Timestamp.fromDate(today))
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
          _currentWaterIntake = data['waterIntake'] ?? 0;
        }
      }

      setState(() {
        _isReminderEnabled = enabled;
        _targetWaterIntake = target;
        _glassSize = glass;
        _reminderInterval = interval;
        _startTime = TimeOfDay(hour: startHour, minute: startMinute);
        _endTime = TimeOfDay(hour: endHour, minute: endMinute);
      });
    } catch (e) {
      print('Error loading water reminder settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải cài đặt. Vui lòng thử lại!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lưu cài đặt vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('water_reminder_enabled', _isReminderEnabled);
      await prefs.setInt('water_target', _targetWaterIntake);
      await prefs.setInt('water_glass_size', _glassSize);
      await prefs.setInt('water_reminder_interval', _reminderInterval);
      await prefs.setInt('water_start_hour', _startTime.hour);
      await prefs.setInt('water_start_minute', _startTime.minute);
      await prefs.setInt('water_end_hour', _endTime.hour);
      await prefs.setInt('water_end_minute', _endTime.minute);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cài đặt đã được lưu!')),
      );
    } catch (e) {
      print('Error saving water reminder settings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu cài đặt. Vui lòng thử lại!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay initialTime = isStartTime ? _startTime : _endTime;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _addWater() async {
    setState(() {
      _currentWaterIntake += _glassSize;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime now = DateTime.now();
        DateTime today = DateTime(now.year, now.month, now.day);

        // Kiểm tra nếu đã có bản ghi cho ngày hôm nay
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health_records')
            .where('date', isEqualTo: Timestamp.fromDate(today))
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          // Tạo bản ghi mới nếu chưa có
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('health_records')
              .add({
                'date': Timestamp.fromDate(today),
                'waterIntake': _currentWaterIntake,
                'createdAt': FieldValue.serverTimestamp(),
              });
        } else {
          // Cập nhật bản ghi hiện có
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('health_records')
              .doc(snapshot.docs.first.id)
              .update({
                'waterIntake': _currentWaterIntake,
              });
        }
      }
    } catch (e) {
      print('Error updating water intake: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật lượng nước. Vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _targetWaterIntake > 0
        ? _currentWaterIntake / _targetWaterIntake
        : 0.0;

    if (progress > 1.0) progress = 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Nhắc nhở uống nước'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị tiến trình uống nước
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hôm nay',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$_currentWaterIntake / $_targetWaterIntake ml',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            color: Theme.of(context).primaryColor,
                            minHeight: 12.0,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton.icon(
                            onPressed: _addWater,
                            icon: Icon(Icons.local_drink),
                            label: Text('Thêm $_glassSize ml'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              minimumSize: Size(double.infinity, 50.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.0),
                  Text(
                    'Cài đặt nhắc nhở',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Bật/tắt nhắc nhở
                  SwitchListTile(
                    title: Text('Bật nhắc nhở'),
                    subtitle: Text(_isReminderEnabled
                        ? 'Đã bật (chức năng thông báo đang được phát triển)'
                        : 'Đang tắt'),
                    value: _isReminderEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isReminderEnabled = value;
                      });
                      if (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Chức năng thông báo đang được phát triển')),
                        );
                      }
                    },
                    secondary: Icon(Icons.notifications),
                  ),

                  Divider(),

                  // Mục tiêu uống nước
                  ListTile(
                    title: Text('Mục tiêu hàng ngày'),
                    subtitle: Text('$_targetWaterIntake ml'),
                    leading: Icon(Icons.flag),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildTargetDialog(),
                        );
                      },
                    ),
                  ),

                  // Kích thước cốc nước
                  ListTile(
                    title: Text('Dung tích cốc nước'),
                    subtitle: Text('$_glassSize ml'),
                    leading: Icon(Icons.water_drop),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildGlassSizeDialog(),
                        );
                      },
                    ),
                  ),

                  // Thời gian bắt đầu
                  ListTile(
                    title: Text('Thời gian bắt đầu'),
                    subtitle: Text('${_startTime.format(context)}'),
                    leading: Icon(Icons.access_time),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _selectTime(context, true),
                    ),
                  ),

                  // Thời gian kết thúc
                  ListTile(
                    title: Text('Thời gian kết thúc'),
                    subtitle: Text('${_endTime.format(context)}'),
                    leading: Icon(Icons.access_time_filled),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _selectTime(context, false),
                    ),
                  ),

                  // Khoảng thời gian nhắc nhở
                  ListTile(
                    title: Text('Khoảng thời gian nhắc nhở'),
                    subtitle: Text('$_reminderInterval phút'),
                    leading: Icon(Icons.timer),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => _buildIntervalDialog(),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 24.0),
                  // Nút lưu cài đặt
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: _saveSettings,
                      child: Text('Lưu cài đặt', style: TextStyle(fontSize: 16.0)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTargetDialog() {
    TextEditingController controller = TextEditingController(text: _targetWaterIntake.toString());

    return AlertDialog(
      title: Text('Mục tiêu uống nước'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Lượng nước (ml)',
          hintText: 'Nhập mục tiêu uống nước hàng ngày',
          suffixText: 'ml',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            int? value = int.tryParse(controller.text);
            if (value != null && value > 0) {
              setState(() {
                _targetWaterIntake = value;
              });
              Navigator.pop(context);
            }
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }

  Widget _buildGlassSizeDialog() {
    TextEditingController controller = TextEditingController(text: _glassSize.toString());

    return AlertDialog(
      title: Text('Dung tích cốc nước'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Dung tích (ml)',
          hintText: 'Nhập dung tích của cốc nước',
          suffixText: 'ml',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            int? value = int.tryParse(controller.text);
            if (value != null && value > 0) {
              setState(() {
                _glassSize = value;
              });
              Navigator.pop(context);
            }
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }

  Widget _buildIntervalDialog() {
    TextEditingController controller = TextEditingController(text: _reminderInterval.toString());

    return AlertDialog(
      title: Text('Khoảng thời gian nhắc nhở'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Thời gian (phút)',
          hintText: 'Nhập khoảng thời gian giữa các lần nhắc nhở',
          suffixText: 'phút',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            int? value = int.tryParse(controller.text);
            if (value != null && value > 0) {
              setState(() {
                _reminderInterval = value;
              });
              Navigator.pop(context);
            }
          },
          child: Text('Lưu'),
        ),
      ],
    );
  }
}
