import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';

class HealthMetricsDialog extends StatefulWidget {
  final bool isHeartRate; // true nếu là nhịp tim, false nếu là huyết áp

  const HealthMetricsDialog({Key? key, required this.isHeartRate}) : super(key: key);

  @override
  _HealthMetricsDialogState createState() => _HealthMetricsDialogState();
}

class _HealthMetricsDialogState extends State<HealthMetricsDialog> {
  // Giá trị nhịp tim (HR)
  double _heartRate = 70;

  // Giá trị huyết áp (BP)
  int _systolic = 120;
  int _diastolic = 80;

  // Trạng thái đang lưu
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isHeartRate ? 'Cập nhật nhịp tim' : 'Cập nhật huyết áp',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Hiển thị UI tương ứng với loại thông số
            widget.isHeartRate
              ? _buildHeartRateInput()
              : _buildBloodPressureInput(),

            const SizedBox(height: 30),

            // Nút hủy và lưu
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  child: Text('Hủy'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: _isSaving ? null : _saveData,
                  child: _isSaving
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      )
                    : Text(
                        'Lưu',
                        style: TextStyle(color: Colors.white),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UI nhập nhịp tim
  Widget _buildHeartRateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${_heartRate.toInt()}',
              style: TextStyle(
                fontSize: 40,
                color: _getHeartRateColor(_heartRate),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(' bpm', style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 10),
        Slider(
          value: _heartRate,
          min: 30,
          max: 200,
          divisions: 170,
          activeColor: _getHeartRateColor(_heartRate),
          onChanged: (value) {
            setState(() {
              _heartRate = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('30', style: TextStyle(color: Colors.grey)),
            Text('200', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // UI nhập huyết áp
  Widget _buildBloodPressureInput() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_systolic / $_diastolic',
              style: TextStyle(
                fontSize: 40,
                color: _getBloodPressureColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(' mmHg', style: TextStyle(fontSize: 20)),
          ],
        ),
        SizedBox(height: 20),
        Text('Tâm thu (Systolic)', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _systolic.toDouble(),
          min: 70,
          max: 200,
          divisions: 130,
          activeColor: _getBloodPressureColor(),
          onChanged: (value) {
            setState(() {
              _systolic = value.toInt();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('70', style: TextStyle(color: Colors.grey)),
            Text('200', style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 20),
        Text('Tâm trương (Diastolic)', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: _diastolic.toDouble(),
          min: 40,
          max: 130,
          divisions: 90,
          activeColor: _getBloodPressureColor(),
          onChanged: (value) {
            setState(() {
              _diastolic = value.toInt();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('40', style: TextStyle(color: Colors.grey)),
            Text('130', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  // Màu sắc dựa trên nhịp tim
  Color _getHeartRateColor(double hr) {
    if (hr < 60 || hr > 100) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }

  // Màu sắc dựa trên huyết áp
  Color _getBloodPressureColor() {
    if (_systolic > 140 || _diastolic > 90 || _systolic < 90 || _diastolic < 60) {
      return Colors.red;
    } else if (_systolic > 120 || _diastolic > 80) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  // Lưu dữ liệu
  void _saveData() async {
    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

    setState(() {
      _isSaving = true;
    });

    bool success = false;

    if (widget.isHeartRate) {
      // Lưu nhịp tim
      success = await healthProvider.addHeartRateReading(
        _heartRate,
        dateProvider.selectedDate
      );
    } else {
      // Lưu huyết áp
      success = await healthProvider.addBloodPressureReading(
        _systolic,
        _diastolic,
        dateProvider.selectedDate
      );
    }

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi khi lưu dữ liệu. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
