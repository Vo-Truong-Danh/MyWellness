import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:my_wellness/views/screens/health/add_health_record_screen.dart';

class HealthHistoryScreen extends StatefulWidget {
  const HealthHistoryScreen({super.key});

  @override
  _HealthHistoryScreenState createState() => _HealthHistoryScreenState();
}

class _HealthHistoryScreenState extends State<HealthHistoryScreen>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  List<Map<String, dynamic>> _healthRecords = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHealthHistory();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadHealthHistory();
    }
  }

  Future<void> _loadHealthHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot healthData =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('health_records')
                .orderBy('date', descending: true)
                .limit(30)
                .get();

        List<Map<String, dynamic>> records = [];
        for (var doc in healthData.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          records.add(data);
        }

        setState(() {
          _healthRecords = records;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading health history: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể tải lịch sử sức khỏe. Vui lòng thử lại!'),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else {
      return 'N/A';
    }
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildHealthRecordItem(Map<String, dynamic> record) {
    final date = _formatDate(record['date']);
    final weight = record['weight']?.toString() ?? 'N/A';
    final bloodPressure =
        record['bloodPressure'] != null
            ? '${record['bloodPressure']['systolic']}/${record['bloodPressure']['diastolic']} mmHg'
            : 'N/A';
    final heartRate = record['heartRate']?.toString() ?? 'N/A';
    final stepCount = record['stepCount']?.toString() ?? 'N/A';
    final sleepHours = record['sleepHours']?.toString() ?? 'N/A';
    final waterIntake = record['waterIntake']?.toString() ?? 'N/A';

    IconData statusIcon = Icons.check_circle;
    Color statusColor = Colors.green;
    String statusText = 'Tốt';

    if (record['bloodPressure'] != null) {
      int systolic = record['bloodPressure']['systolic'] ?? 0;
      int diastolic = record['bloodPressure']['diastolic'] ?? 0;

      if (systolic > 140 || diastolic > 90 || systolic < 90 || diastolic < 60) {
        statusIcon = Icons.warning;
        statusColor = Colors.orange;
        statusText = 'Cảnh báo';
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ngày: $date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16.0),
                      SizedBox(width: 4.0),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 8.0),
            _buildHealthDetail('Cân nặng', '$weight kg', Icons.monitor_weight),
            _buildHealthDetail('Huyết áp', bloodPressure, Icons.favorite),
            _buildHealthDetail(
              'Nhịp tim',
              '$heartRate bpm',
              Icons.favorite_border,
            ),
            _buildHealthDetail(
              'Số bước chân',
              stepCount,
              Icons.directions_walk,
            ),
            _buildHealthDetail('Giờ ngủ', '$sleepHours giờ', Icons.bedtime),
            _buildHealthDetail(
              'Nước uống',
              '$waterIntake ml',
              Icons.water_drop,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthDetail(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.teal),
          SizedBox(width: 8),
          Text(title, style: TextStyle(color: Colors.grey[700])),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử sức khỏe'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadHealthHistory,
            tooltip: 'Làm mới dữ liệu',
          ),
        ],
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _healthRecords.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: Colors.grey),
                    SizedBox(height: 16.0),
                    Text(
                      'Chưa có dữ liệu sức khỏe',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 24.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddHealthRecordScreen(),
                          ),
                        );
                        if (result == true) {
                          _loadHealthHistory();
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text('Thêm dữ liệu mới'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: _loadHealthHistory,
                child: ListView.builder(
                  padding: EdgeInsets.all(12.0),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _healthRecords.length,
                  itemBuilder: (context, index) {
                    return _buildHealthRecordItem(_healthRecords[index]);
                  },
                ),
              ),
      floatingActionButton:
          _healthRecords.isNotEmpty
              ? FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddHealthRecordScreen(),
                    ),
                  );
                  if (result == true) {
                    _loadHealthHistory();
                  }
                },
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.add),
                tooltip: 'Thêm dữ liệu mới',
              )
              : null,
    );
  }
}
