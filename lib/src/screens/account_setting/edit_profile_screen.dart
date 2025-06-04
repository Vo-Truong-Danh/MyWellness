import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const EditProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  String _selectedGender = 'Nam';
  String _selectedGoal = 'Giảm cân';
  DateTime? _selectedDate;
  bool _isLoading = false;

  final List<String> _genders = ['Nam', 'Nữ', 'Khác'];
  final List<String> _goals = [
    'Giảm cân',
    'Tăng cân',
    'Duy trì cân nặng',
    'Tăng cơ',
    'Sức khỏe tổng thể'
  ];

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() {
    final User? user = FirebaseAuth.instance.currentUser;

    // Điền thông tin từ userData được truyền vào
    if (widget.userData != null) {
      _nameController.text = widget.userData!['name'] ?? user?.displayName ?? '';
      _heightController.text = widget.userData!['height']?.toString() ?? '';
      _weightController.text = widget.userData!['weight']?.toString() ?? '';

      if (widget.userData!['dateOfBirth'] != null) {
        if (widget.userData!['dateOfBirth'] is Timestamp) {
          _selectedDate = widget.userData!['dateOfBirth'].toDate();
        } else if (widget.userData!['dateOfBirth'] is String) {
          try {
            _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.userData!['dateOfBirth']);
          } catch (e) {
            print('Lỗi khi chuyển đổi ngày: $e');
          }
        }

        if (_selectedDate != null) {
          _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        }
      }

      if (widget.userData!['gender'] != null) {
        _selectedGender = widget.userData!['gender'];
      }

      if (widget.userData!['fitnessGoal'] != null) {
        _selectedGoal = widget.userData!['fitnessGoal'];
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Chọn ngày sinh',
      cancelText: 'Hủy',
      confirmText: 'Chọn',
      fieldLabelText: 'Ngày sinh',
      fieldHintText: 'Ngày/Tháng/Năm',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF30C9B7),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('Người dùng chưa đăng nhập');
        }

        final userData = {
          'name': _nameController.text.trim(),
          'height': _heightController.text.isEmpty ? null : double.parse(_heightController.text),
          'weight': _weightController.text.isEmpty ? null : double.parse(_weightController.text),
          'dateOfBirth': _selectedDate,
          'gender': _selectedGender,
          'fitnessGoal': _selectedGoal,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        // Cập nhật displayName trong Firebase Auth
        await user.updateDisplayName(_nameController.text.trim());

        // Cập nhật thông tin trong Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(userData, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã cập nhật thông tin thành công'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi cập nhật thông tin: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF30C9B7),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Tên
                    _buildLabel('Họ và tên'),
                    _buildTextField(
                      controller: _nameController,
                      hintText: 'Nhập họ và tên',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Giới tính
                    _buildLabel('Giới tính'),
                    _buildDropdown(
                      items: _genders,
                      value: _selectedGender,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedGender = value;
                          });
                        }
                      },
                      prefixIcon: Icons.people_outline,
                    ),

                    const SizedBox(height: 20),

                    // Ngày sinh
                    _buildLabel('Ngày sinh'),
                    _buildTextField(
                      controller: _dateOfBirthController,
                      hintText: 'Chọn ngày sinh',
                      prefixIcon: Icons.calendar_today,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),

                    const SizedBox(height: 20),

                    // Chiều cao
                    _buildLabel('Chiều cao (cm)'),
                    _buildTextField(
                      controller: _heightController,
                      hintText: 'Nhập chiều cao',
                      prefixIcon: Icons.height,
                      keyboardType: TextInputType.number,
                      suffixText: 'cm',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Cân nặng
                    _buildLabel('Cân nặng (kg)'),
                    _buildTextField(
                      controller: _weightController,
                      hintText: 'Nhập cân nặng',
                      prefixIcon: Icons.monitor_weight,
                      keyboardType: TextInputType.number,
                      suffixText: 'kg',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Mục tiêu sức khỏe
                    _buildLabel('Mục tiêu'),
                    _buildDropdown(
                      items: _goals,
                      value: _selectedGoal,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedGoal = value;
                          });
                        }
                      },
                      prefixIcon: Icons.flag_outlined,
                    ),

                    const SizedBox(height: 40),

                    // Nút lưu
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF30C9B7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Lưu thông tin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? suffixText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Color(0xFF30C9B7)),
        suffixText: suffixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFF30C9B7), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade300, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      onTap: onTap,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String value,
    required ValueChanged<String?> onChanged,
    required IconData prefixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, color: Color(0xFF30C9B7)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}
