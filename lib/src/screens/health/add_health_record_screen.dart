import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AddHealthRecordScreen extends StatefulWidget {
  @override
  _AddHealthRecordScreenState createState() => _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();

  // Controllers cho các trường nhập liệu
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _stepCountController = TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();
  final TextEditingController _waterIntakeController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Khởi tạo giá trị mặc định khi mở màn hình
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi đóng màn hình
    _weightController.dispose();
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _stepCountController.dispose();
    _sleepHoursController.dispose();
    _waterIntakeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveHealthRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Chuẩn bị dữ liệu sức khỏe
        Map<String, dynamic> healthData = {
          'date': Timestamp.fromDate(_selectedDate),
          'createdAt': FieldValue.serverTimestamp(),
          'weight': double.tryParse(_weightController.text),
          'bloodPressure': {
            'systolic': int.tryParse(_systolicController.text),
            'diastolic': int.tryParse(_diastolicController.text),
          },
          'heartRate': int.tryParse(_heartRateController.text),
          'stepCount': int.tryParse(_stepCountController.text),
          'sleepHours': double.tryParse(_sleepHoursController.text),
          'waterIntake': int.tryParse(_waterIntakeController.text),
          'notes': _notesController.text,
        };

        // Lưu dữ liệu vào Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health_records')
            .add(healthData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dữ liệu sức khỏe đã được lưu thành công!')),
        );

        Navigator.pop(context, true); // Quay lại với kết quả thành công
      }
    } catch (e) {
      print('Error saving health record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu dữ liệu. Vui lòng thử lại!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveHeartRateData(int? heartRate) async {
    if (heartRate == null) return;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Map<String, dynamic> heartRateData = {
          'heartRate': heartRate,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health_records')
            .where('date', isEqualTo: Timestamp.fromDate(_selectedDate))
            .get();

        if (snapshot.docs.isNotEmpty) {
          await snapshot.docs.first.reference.update(heartRateData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nhịp tim đã được cập nhật thành công!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không có dữ liệu để cập nhật nhịp tim!')),
          );
        }
      }
    } catch (e) {
      print('Error updating heart rate: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật nhịp tim. Vui lòng thử lại!')),
      );
    }
  }

  Future<void> _loadExistingData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('health_records')
            .where('date', isEqualTo: Timestamp.fromDate(_selectedDate))
            .get();

        if (snapshot.docs.isNotEmpty) {
          Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
          setState(() {
            _weightController.text = data['weight']?.toString() ?? '';
            _systolicController.text = data['bloodPressure']?['systolic']?.toString() ?? '';
            _diastolicController.text = data['bloodPressure']?['diastolic']?.toString() ?? '';
            _heartRateController.text = data['heartRate']?.toString() ?? '';
            _stepCountController.text = data['stepCount']?.toString() ?? '';
            _sleepHoursController.text = data['sleepHours']?.toString() ?? '';
            _waterIntakeController.text = data['waterIntake']?.toString() ?? '';
            _notesController.text = data['notes'] ?? '';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Không có dữ liệu cho ngày đã chọn!')),
          );
        }
      }
    } catch (e) {
      print('Error loading health record: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu. Vui lòng thử lại!')),
      );
    }
  }

  Widget _buildNumberInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? unit,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: unit,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        validator: validator ?? (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm dữ liệu sức khỏe'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Thêm nút làm mới dữ liệu
          IconButton(
            icon: Icon(Icons.update),
            tooltip: 'Cập nhật dữ liệu',
            onPressed: () async {
              // Hiển thị dialog xác nhận
              bool confirm = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Xác nhận'),
                  content: Text('Cập nhật dữ liệu sức khỏe cho ngày ${DateFormat('dd/MM/yyyy').format(_selectedDate)}?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Xác nhận', style: TextStyle(color: Theme.of(context).primaryColor)),
                    ),
                  ],
                ),
              ) ?? false;

              if (confirm) {
                setState(() {
                  _isLoading = true;
                });
                await _loadExistingData();
                setState(() {
                  _isLoading = false;
                });
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chọn ngày
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(12.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ngày ghi nhận:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Theme.of(context).primaryColor,
                                        size: 26,
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.edit_calendar,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),

                    // Cân nặng
                    _buildNumberInput(
                      controller: _weightController,
                      label: 'Cân nặng',
                      hint: 'Nhập cân nặng của bạn',
                      unit: 'kg',
                    ),

                    // Huyết áp
                    Row(
                      children: [
                        Expanded(
                          child: _buildNumberInput(
                            controller: _systolicController,
                            label: 'Huyết áp tâm thu',
                            hint: 'Tâm thu',
                            unit: 'mmHg',
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: _buildNumberInput(
                            controller: _diastolicController,
                            label: 'Huyết áp tâm trương',
                            hint: 'Tâm trương',
                            unit: 'mmHg',
                          ),
                        ),
                      ],
                    ),

                    // Nhịp tim
                    GestureDetector(
                      onTap: () async {
                        // Hiển thị dialog nhập nhịp tim
                        String? result = await showDialog<String>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Cập nhật nhịp tim'),
                            content: TextField(
                              controller: TextEditingController(text: _heartRateController.text),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Nhịp tim',
                                suffixText: 'bpm',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                // Cập nhật giá trị mới
                                _heartRateController.text = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Hủy'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Trả về giá trị mới
                                  Navigator.pop(context, _heartRateController.text);
                                },
                                child: Text('Cập nhật', style: TextStyle(color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          ),
                        );

                        if (result != null) {
                          setState(() {
                            _heartRateController.text = result;
                          });

                          // Lưu dữ liệu ngay lập tức
                          _saveHeartRateData(int.tryParse(result));
                        }
                      },
                      child: _buildNumberInput(
                        controller: _heartRateController,
                        label: 'Nhịp tim',
                        hint: 'Nhập nhịp tim của bạn',
                        unit: 'bpm',
                      ),
                    ),

                    // Số bước chân
                    _buildNumberInput(
                      controller: _stepCountController,
                      label: 'Số bước chân',
                      hint: 'Nhập số bước chân hôm nay',
                      unit: 'bước',
                    ),

                    // Giờ ngủ
                    _buildNumberInput(
                      controller: _sleepHoursController,
                      label: 'Giờ ngủ',
                      hint: 'Số giờ ngủ',
                      unit: 'giờ',
                    ),

                    // Lượng nước uống
                    _buildNumberInput(
                      controller: _waterIntakeController,
                      label: 'Lượng nước uống',
                      hint: 'Lượng nước đã uống',
                      unit: 'ml',
                    ),

                    // Ghi chú
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Ghi chú',
                          hintText: 'Nhập ghi chú về sức khỏe của bạn (nếu có)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.0),
                    // Nút lưu
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _saveHealthRecord,
                        child: Text('Lưu dữ liệu', style: TextStyle(fontSize: 16.0)),
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
            ),
    );
  }
}
