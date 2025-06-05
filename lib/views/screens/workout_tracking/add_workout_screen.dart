import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/controllers/providers/health_data_provider.dart';
import 'package:my_wellness/controllers/providers/selected_date_provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  // Các loại bài tập
  final List<String> workoutTypes = ['Cardio', 'Sức mạnh', 'Linh hoạt', 'Khác'];
  String selectedWorkoutType = 'Cardio';

  // Các mức độ cường độ
  final List<String> intensityLevels = ['Nhẹ', 'Trung bình', 'Cao'];

  // Danh sách bài tập phổ biến
  final List<Map<String, dynamic>> commonWorkouts = [
    {
      'name': 'Chạy bộ',
      'type': 'Cardio',
      'caloriesPerMinute': 10,
      'image': 'assets/images/walk.gif',
    },
    {
      'name': 'Đạp xe',
      'type': 'Cardio',
      'caloriesPerMinute': 8,
      'image': 'assets/images/cycling.gif',
    },
    {
      'name': 'Bơi lội',
      'type': 'Cardio',
      'caloriesPerMinute': 12,
      'image': 'assets/images/swimming.png',
    },
    {
      'name': 'Hít đất',
      'type': 'Sức mạnh',
      'caloriesPerMinute': 7,
      'image': 'assets/images/pushup.png',
    },
    {
      'name': 'Gánh tạ',
      'type': 'Sức mạnh',
      'caloriesPerMinute': 9,
      'image': 'assets/images/weightlifting.png',
    },
    {
      'name': 'Yoga',
      'type': 'Linh hoạt',
      'caloriesPerMinute': 5,
      'image': 'assets/images/yoga.png',
    },
    {
      'name': 'Đi bộ',
      'type': 'Cardio',
      'caloriesPerMinute': 6,
      'image': 'assets/images/walking.png',
    },
    {
      'name': 'Nhảy dây',
      'type': 'Cardio',
      'caloriesPerMinute': 13,
      'image': 'assets/images/jumprope.png',
    },
  ];

  // Danh sách bài tập được lọc theo loại
  List<Map<String, dynamic>> get filteredWorkouts {
    if (selectedWorkoutType == 'Tất cả') {
      return commonWorkouts;
    }
    return commonWorkouts
        .where((workout) => workout['type'] == selectedWorkoutType)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    selectedWorkoutType = 'Tất cả';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm bài tập'),
        backgroundColor: Color(0xFF30C9B7),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Thanh tìm kiếm (Chức năng tìm kiếm chưa được triển khai trong đoạn mã gốc)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              // controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm bài tập...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Bộ lọc loại bài tập
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Tất cả'), // Thêm chip 'Tất cả'
                ...workoutTypes.map((type) => _buildFilterChip(type)).toList(),
              ],
            ),
          ),

          // Tiêu đề danh mục
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                selectedWorkoutType == 'Tất cả'
                    ? 'Tất cả bài tập'
                    : 'Bài tập ${selectedWorkoutType.toLowerCase()} phổ biến',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Danh sách bài tập phổ biến
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.8, // Điều chỉnh tỷ lệ cho phù hợp với nội dung card
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredWorkouts.length,
              itemBuilder: (context, index) {
                final workout = filteredWorkouts[index];
                return _buildWorkoutCard(workout);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddManualWorkoutDialog(context);
        },
        backgroundColor: Color(0xFF30C9B7), // Thêm màu cho icon
        tooltip: 'Thêm thủ công',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String type) {
    // bool isSelected = type == selectedWorkoutType || (type == 'Tất cả' && selectedWorkoutType == 'Tất cả');
    bool isSelected = type == selectedWorkoutType;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(type),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedWorkoutType = type;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Color(0xFF30C9B7).withOpacity(0.3), // Tăng độ đậm 1 chút
        checkmarkColor: Color(0xFF30C9B7),
        labelStyle: TextStyle(
          color: isSelected ? Color(0xFF30C9B7) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    return InkWell(
      onTap: () {
        if (workout['type'] == 'Sức mạnh') {
          _showStrengthWorkoutDialog(workout);
        } else {
          // Cardio, Linh hoạt, Khác
          _showCardioWorkoutDialog(workout);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child:
                      workout['image'] != null &&
                              (workout['image'] as String).isNotEmpty
                          ? Image.asset(
                            workout['image'],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.fitness_center,
                                size: 50,
                                color: Color(0xFF30C9B7),
                              );
                            },
                          )
                          : Icon(
                            Icons.fitness_center,
                            size: 50,
                            color: Color(0xFF30C9B7),
                          ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                workout['name'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                '${workout['caloriesPerMinute']} kcal/phút',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                workout['type'],
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCardioWorkoutDialog(Map<String, dynamic> workout) {
    int durationMinutes = 30;
    String selectedIntensity = 'Trung bình';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Dùng StatefulBuilder để cập nhật UI bên trong dialog
          builder: (context, setStateDialog) {
            double intensityMultiplier = 1.0;
            if (selectedIntensity == 'Nhẹ') intensityMultiplier = 0.8;
            if (selectedIntensity == 'Cao') intensityMultiplier = 1.3;

            double estimatedCalories =
                (workout['caloriesPerMinute'] as num) *
                durationMinutes *
                intensityMultiplier;

            return AlertDialog(
              title: Text(workout['name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thời gian (phút): $durationMinutes phút'),
                  Slider(
                    value: durationMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions:
                        (120 - 5) ~/ 5, // Tính số lượng divisions chính xác
                    label: durationMinutes.round().toString(),
                    onChanged: (value) {
                      setStateDialog(() {
                        // Cập nhật UI của dialog
                        durationMinutes = value.round();
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text('Cường độ:'),
                  DropdownButton<String>(
                    value: selectedIntensity,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setStateDialog(() {
                          // Cập nhật UI của dialog
                          selectedIntensity = newValue;
                        });
                      }
                    },
                    items:
                        intensityLevels.map<DropdownMenuItem<String>>((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Ước tính: ${estimatedCalories.toInt()} kcal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF30C9B7),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _addWorkoutToLog(
                        workout['name'],
                        workout['type'],
                        durationMinutes,
                        estimatedCalories.toDouble(),
                        selectedIntensity,
                        null,
                      );
                    });
                  },
                  child: Text('Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStrengthWorkoutDialog(Map<String, dynamic> workout) {
    List<Map<String, dynamic>> sets = [
      {'reps': 10, 'weight': 0.0},
    ];
    int durationMinutes = 30; // Thời gian mặc định cho bài tập sức mạnh

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            double estimatedCalories =
                ((workout['caloriesPerMinute'] as num) * durationMinutes)
                    .toDouble();

            return AlertDialog(
              title: Text(workout['name']),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thời gian (phút): $durationMinutes phút'),
                    Slider(
                      value: durationMinutes.toDouble(),
                      min: 5,
                      max: 120,
                      divisions: (120 - 5) ~/ 5,
                      label: durationMinutes.round().toString(),
                      onChanged: (value) {
                        setStateDialog(() {
                          durationMinutes = value.round();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sets:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...List.generate(sets.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text('Set ${index + 1}: '),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Số lần (reps): ${sets[index]['reps']}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                        ),
                                        onPressed:
                                            (sets[index]['reps'] as num) > 1
                                                ? () => setStateDialog(
                                                  () =>
                                                      sets[index]['reps'] =
                                                          (sets[index]['reps']
                                                              as num) -
                                                          1,
                                                )
                                                : null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => setStateDialog(
                                              () =>
                                                  sets[index]['reps'] =
                                                      (sets[index]['reps']
                                                          as num) +
                                                      1,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text('Tạ (kg): ${sets[index]['weight']}'),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          size: 20,
                                        ),
                                        onPressed:
                                            (sets[index]['weight'] as num) > 0
                                                ? () => setStateDialog(() {
                                                  sets[index]['weight'] =
                                                      (sets[index]['weight']
                                                          as num) -
                                                      2.5;
                                                  if ((sets[index]['weight']
                                                          as num) <
                                                      0)
                                                    sets[index]['weight'] = 0.0;
                                                })
                                                : null,
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          size: 20,
                                        ),
                                        onPressed:
                                            () => setStateDialog(
                                              () =>
                                                  sets[index]['weight'] =
                                                      (sets[index]['weight']
                                                          as num) +
                                                      2.5,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed:
                                  sets.length > 1
                                      ? () => setStateDialog(
                                        () => sets.removeAt(index),
                                      )
                                      : null, // Không cho xóa nếu chỉ còn 1 set
                            ),
                          ],
                        ),
                      );
                    }),
                    Center(
                      // Đặt nút "Thêm set" ở giữa
                      child: TextButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Thêm set'),
                        onPressed: () {
                          setStateDialog(() {
                            sets.add({'reps': 10, 'weight': 0.0});
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Ước tính: ${estimatedCalories.toInt()} kcal',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF30C9B7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _addWorkoutToLog(
                        workout['name'],
                        workout['type'],
                        durationMinutes,
                        estimatedCalories.toDouble(),
                        null,
                        sets,
                      );
                    });
                  },
                  child: Text('Thêm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddManualWorkoutDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Thêm GlobalKey cho Form
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final durationController = TextEditingController(text: '30');
    String selectedType = 'Cardio'; // Giá trị mặc định
    String selectedIntensityForManual = 'Trung bình'; // Giá trị mặc định

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm bài tập thủ công'),
          content: SingleChildScrollView(
            child: Form(
              // Sử dụng Form để validation
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    // Sử dụng TextFormField để validation
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Tên bài tập'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên bài tập';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Loại bài tập'),
                    value: selectedType,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        // Không cần setState vì dialog sẽ rebuild khi chọn
                        selectedType = newValue;
                      }
                    },
                    items:
                        workoutTypes.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: durationController,
                    decoration: InputDecoration(labelText: 'Thời gian (phút)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập thời gian';
                      }
                      if (int.tryParse(value) == null ||
                          int.parse(value) <= 0) {
                        return 'Thời gian không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: caloriesController,
                    decoration: InputDecoration(
                      labelText: 'Calories đã đốt cháy',
                      suffixText: 'kcal',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      // Cho phép để trống nếu người dùng không biết chính xác
                      if (value != null &&
                          value.isNotEmpty &&
                          (double.tryParse(value) == null ||
                              double.parse(value) < 0)) {
                        return 'Số calories không hợp lệ';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Cường độ (nếu có)'),
                    value: selectedIntensityForManual,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        selectedIntensityForManual = newValue;
                      }
                    },
                    items:
                        intensityLevels.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF30C9B7),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Kiểm tra validation
                  _addWorkoutToLog(
                    nameController.text,
                    selectedType,
                    int.tryParse(durationController.text) ?? 30,
                    double.tryParse(caloriesController.text) ??
                        0, // Mặc định là 0 nếu không nhập
                    selectedIntensityForManual,
                    null, // Không có sets cho thêm thủ công (trừ khi bạn muốn thêm)
                  );
                  Navigator.pop(context);
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  // *** PHẦN ĐƯỢC HOÀN THIỆN VÀ CẬP NHẬT ***
  void _addWorkoutToLog(
    String name,
    String type,
    int durationMinutes,
    double caloriesBurned,
    String? intensity, [ // intensity có thể null
    List<Map<String, dynamic>>?
    sets, // sets là tùy chọn, dùng cho bài tập sức mạnh
  ]) {
    final healthProvider = Provider.of<HealthDataProvider>(
      context,
      listen: false,
    );
    final dateProvider = Provider.of<SelectedDateProvider>(
      context,
      listen: false,
    );

    // Gọi healthProvider.addWorkoutEntry với đầy đủ tham số, không bao gồm sets
    healthProvider
        .addWorkoutEntry(
          name,
          type,
          durationMinutes,
          caloriesBurned,
          intensity,
          dateProvider.selectedDate,
        )
        .then((success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm "$name" vào nhật ký'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
            // Thông thường, dialog đã được đóng bởi Navigator.pop(context) trong hàm gọi nó.
            // Nếu bạn muốn thực hiện hành động nào khác sau khi thêm thành công, bạn có thể thêm ở đây.
          } else {
            // Xử lý trường hợp thêm thất bại (ví dụ: server từ chối, dữ liệu không hợp lệ từ phía server)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi: Không thể thêm "$name". Vui lòng thử lại.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        })
        .catchError((error) {
          // Xử lý các lỗi không mong muốn khác trong quá trình gọi (ví dụ: lỗi mạng)
          print('Lỗi khi thêm bài tập: $error'); // Log lỗi để debug
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xảy ra lỗi hệ thống khi thêm bài tập. $error'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        });
  } // Kết thúc hàm _addWorkoutToLog
} // Kết thúc class _AddWorkoutScreenState
