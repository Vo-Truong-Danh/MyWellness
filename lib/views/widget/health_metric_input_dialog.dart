import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/providers/health_data_provider.dart';
import '../../controllers/providers/selected_date_provider.dart';
import 'package:my_wellness/views/screens/home/homepage.dart';

/// Hiển thị hộp thoại nhập thông số sức khỏe với cơ chế tự động làm mới dữ liệu.
///
/// Các tham số:
/// - title: Tiêu đề hộp thoại
/// - inputFields: Danh sách các trường nhập liệu
/// - onSave: Hàm thực hiện lưu dữ liệu, trả về Future<bool>
class HealthMetricInputDialog extends StatefulWidget {
  final String title;
  final List<InputField> inputFields;
  final Future<bool> Function(Map<String, dynamic> values) onSave;

  const HealthMetricInputDialog({
    super.key,
    required this.title,
    required this.inputFields,
    required this.onSave,
  });

  /// Hiển thị hộp thoại và trả về kết quả (true nếu thêm thành công)
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required List<InputField> inputFields,
    required Future<bool> Function(Map<String, dynamic> values) onSave,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder:
          (context) => HealthMetricInputDialog(
            title: title,
            inputFields: inputFields,
            onSave: onSave,
          ),
    );
  }

  @override
  _HealthMetricInputDialogState createState() =>
      _HealthMetricInputDialogState();
}

class _HealthMetricInputDialogState extends State<HealthMetricInputDialog> {
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controllers và giá trị mặc định
    for (var field in widget.inputFields) {
      _controllers[field.name] = TextEditingController(
        text: field.initialValue?.toString() ?? '',
      );
      _values[field.name] = field.initialValue;
    }
  }

  @override
  void dispose() {
    // Giải phóng controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  // Xử lý khi người dùng bấm nút lưu
  Future<void> _handleSave() async {
    // Kiểm tra các trường bắt buộc
    bool isValid = true;
    String? errorMessage;

    for (var field in widget.inputFields) {
      if (field.required &&
          (_values[field.name] == null ||
              _values[field.name].toString().isEmpty)) {
        isValid = false;
        errorMessage = 'Vui lòng nhập đầy đủ thông tin';
        break;
      }
    }

    if (!isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage ?? 'Dữ liệu không hợp lệ'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await widget.onSave(_values);

      if (success && mounted) {
        // Nếu thêm thành công, làm mới dữ liệu trước khi đóng hộp thoại
        final healthProvider = Provider.of<HealthDataProvider>(
          context,
          listen: false,
        );
        final dateProvider = Provider.of<SelectedDateProvider>(
          context,
          listen: false,
        );

        // Chờ một chút để đảm bảo dữ liệu được lưu đầy đủ
        await Future.delayed(Duration(milliseconds: 300));

        // Làm mới dữ liệu
        await healthProvider.loadDailyLog(dateProvider.selectedDate);

        // Thông báo UI cập nhật ngay lập tức
        healthProvider.notifyListeners();

        // Gọi phương thức static để làm mới HomePage
        HomePage.refreshData();

        // Hiển thị thông báo thành công
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã thêm thành công!'),
              backgroundColor: Colors.green,
            ),
          );

          // Đóng hộp thoại và trả về kết quả thành công
          Navigator.of(context).pop(true);
        }
      } else {
        // Hiển thị thông báo lỗi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Có lỗi xảy ra, vui lòng thử lại'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      // Xử lý lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading ? _buildLoadingView() : _buildInputForm(),
      ),
    );
  }

  // Hiển thị giao diện đang tải
  Widget _buildLoadingView() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF30C9B7)),
          ),
          SizedBox(height: 16),
          Text('Đang lưu dữ liệu...'),
        ],
      ),
    );
  }

  // Hiển thị form nhập liệu
  Widget _buildInputForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...widget.inputFields.map((field) => _buildInputField(field)),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF30C9B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _handleSave,
              child: Text('Lưu', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
    );
  }

  // Hiển thị từng trường nhập liệu
  Widget _buildInputField(InputField field) {
    switch (field.type) {
      case InputFieldType.number:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextField(
            controller: _controllers[field.name],
            keyboardType: TextInputType.numberWithOptions(
              decimal: field.allowDecimal,
            ),
            decoration: InputDecoration(
              labelText: field.label,
              hintText: field.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixText: field.suffix,
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                _values[field.name] = null;
                return;
              }
              if (field.allowDecimal) {
                _values[field.name] = double.tryParse(value);
              } else {
                _values[field.name] = int.tryParse(value);
              }
            },
          ),
        );
      case InputFieldType.text:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextField(
            controller: _controllers[field.name],
            decoration: InputDecoration(
              labelText: field.label,
              hintText: field.hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              _values[field.name] = value;
            },
          ),
        );
      case InputFieldType.dropdown:
        final List<String> options = field.options ?? [];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: DropdownButtonFormField<String>(
            value: _values[field.name] as String?,
            decoration: InputDecoration(
              labelText: field.label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items:
                options.map((option) {
                  return DropdownMenuItem(value: option, child: Text(option));
                }).toList(),
            onChanged: (value) {
              setState(() {
                _values[field.name] = value;
              });
            },
          ),
        );
      default:
        return SizedBox.shrink();
    }
  }
}

/// Loại dữ liệu của trường nhập liệu
enum InputFieldType { text, number, dropdown }

/// Định nghĩa một trường nhập liệu
class InputField {
  final String name;
  final String label;
  final String? hint;
  final String? suffix;
  final InputFieldType type;
  final dynamic initialValue;
  final bool required;
  final bool allowDecimal;
  final List<String>? options; // Dùng cho dropdown

  InputField({
    required this.name,
    required this.label,
    this.hint,
    this.suffix,
    this.type = InputFieldType.text,
    this.initialValue,
    this.required = false,
    this.allowDecimal = false,
    this.options,
  });
}
