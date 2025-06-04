import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';

class AddWorkoutScreen extends StatefulWidget {
  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  // Các loại bài tập
  final List<String> workoutTypes = ['Cardio', 'Sức mạnh', 'Linh hoạt', 'Khác'];
  String selectedWorkoutType = 'Cardio';

  // Các mức độ cường độ
  final List<String> intensityLevels = ['Nhẹ', 'Trung bình', 'Cao'];
  String selectedIntensity = 'Trung bình';

  // Danh sách bài tập phổ biến
  final List<Map<String, dynamic>> commonWorkouts = [
    {
      'name': 'Chạy bộ',
      'type': 'Cardio',
      'caloriesPerMinute': 10,
      'image': 'assets/images/running.png'
    },
    {
      'name': 'Đạp xe',
      'type': 'Cardio',
      'caloriesPerMinute': 8,
      'image': 'assets/images/cycling.png'
    },
    {
      'name': 'Bơi lội',
      'type': 'Cardio',
      'caloriesPerMinute': 12,
      'image': 'assets/images/swimming.png'
    },
    {
      'name': 'Hít đất',
      'type': 'Sức mạnh',
      'caloriesPerMinute': 7,
      'image': 'assets/images/pushup.png'
    },
    {
      'name': 'Gánh tạ',
      'type': 'Sức mạnh',
      'caloriesPerMinute': 9,
      'image': 'assets/images/weightlifting.png'
    },
    {
      'name': 'Yoga',
      'type': 'Linh hoạt',
      'caloriesPerMinute': 5,
      'image': 'assets/images/yoga.png'
    },
    {
      'name': 'Đi bộ',
      'type': 'Cardio',
      'caloriesPerMinute': 6,
      'image': 'assets/images/walking.png'
    },
    {
      'name': 'Nhảy dây',
      'type': 'Cardio',
      'caloriesPerMinute': 13,
      'image': 'assets/images/jumprope.png'
    },
  ];

  // Danh sách bài tập được lọc theo loại
  List<Map<String, dynamic>> get filteredWorkouts {
    if (selectedWorkoutType == 'Tất cả') {
      return commonWorkouts;
    }
    return commonWorkouts.where((workout) => workout['type'] == selectedWorkoutType).toList();
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
          // Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
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
                _buildFilterChip('Tất cả'),
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
                'Bài tập phổ biến',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Danh sách bài tập phổ biến
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
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
        backgroundColor: Color(0xFF30C9B7),
        child: Icon(Icons.add),
        tooltip: 'Thêm thủ công',
      ),
    );
  }

  Widget _buildFilterChip(String type) {
    bool isSelected = type == selectedWorkoutType || (type == 'Tất cả' && selectedWorkoutType == 'Tất cả');

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
        selectedColor: Color(0xFF30C9B7).withOpacity(0.2),
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
          _showCardioWorkoutDialog(workout);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 60,
                    color: Color(0xFF30C9B7),
                  ),
                ),
              ),
              Text(
                workout['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${workout['caloriesPerMinute']} kcal/phút',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              Text(
                workout['type'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
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
          builder: (context, setState) {
            // Tính toán lượng calo đốt cháy dựa trên thời gian và cường độ
            double intensityMultiplier = 1.0;
            if (selectedIntensity == 'Nhẹ') intensityMultiplier = 0.8;
            if (selectedIntensity == 'Cao') intensityMultiplier = 1.3;

            double estimatedCalories = workout['caloriesPerMinute'] * durationMinutes * intensityMultiplier;

            return AlertDialog(
              title: Text(workout['name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thời gian (phút):'),
                  Slider(
                    value: durationMinutes.toDouble(),
                    min: 5,
                    max: 120,
                    divisions: 23,
                    label: durationMinutes.toString(),
                    onChanged: (value) {
                      setState(() {
                        durationMinutes = value.toInt();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5 phút'),
                      Text('120 phút'),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Cường độ:'),
                  DropdownButton<String>(
                    value: selectedIntensity,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedIntensity = newValue!;
                      });
                    },
                    items: intensityLevels
                        .map<DropdownMenuItem<String>>((String value) {
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
                    // Thêm bài tập vào nhật ký
                    _addWorkoutToLog(
                      workout['name'],
                      workout['type'],
                      durationMinutes,
                      estimatedCalories.toInt().toDouble(),
                      selectedIntensity,
                    );
                    Navigator.pop(context);
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
    List<Map<String, dynamic>> sets = [{'reps': 10, 'weight': 0.0}];
    int durationMinutes = 30;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Tính toán lượng calo đốt cháy dựa trên thời gian
            double estimatedCalories = workout['caloriesPerMinute'] * durationMinutes;

            return AlertDialog(
              title: Text(workout['name']),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Thời gian (phút):'),
                    Slider(
                      value: durationMinutes.toDouble(),
                      min: 5,
                      max: 120,
                      divisions: 23,
                      label: durationMinutes.toString(),
                      onChanged: (value) {
                        setState(() {
                          durationMinutes = value.toInt();
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Text('Sets:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...List.generate(sets.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text('Set ${index + 1}:'),
                            SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Số lần lặp:'),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              onPressed: sets[index]['reps'] > 1
                                                  ? () {
                                                      setState(() {
                                                        sets[index]['reps']--;
                                                      });
                                                    }
                                                  : null,
                                            ),
                                            Text('${sets[index]['reps']}'),
                                            IconButton(
                                              icon: Icon(Icons.add, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              onPressed: () {
                                                setState(() {
                                                  sets[index]['reps']++;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Trọng lượng (kg):'),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              onPressed: sets[index]['weight'] > 0
                                                  ? () {
                                                      setState(() {
                                                        sets[index]['weight'] -= 2.5;
                                                        if (sets[index]['weight'] < 0) {
                                                          sets[index]['weight'] = 0;
                                                        }
                                                      });
                                                    }
                                                  : null,
                                            ),
                                            Text('${sets[index]['weight']}'),
                                            IconButton(
                                              icon: Icon(Icons.add, size: 18),
                                              padding: EdgeInsets.zero,
                                              constraints: BoxConstraints(),
                                              onPressed: () {
                                                setState(() {
                                                  sets[index]['weight'] += 2.5;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: sets.length > 1
                                  ? () {
                                      setState(() {
                                        sets.removeAt(index);
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Thêm set'),
                      onPressed: () {
                        setState(() {
                          sets.add({'reps': 10, 'weight': 0.0});
                        });
                      },
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
                    // Thêm bài tập vào nhật ký với thông tin về sets
                    _addWorkoutToLog(
                      workout['name'],
                      workout['type'],
                      durationMinutes,
                      estimatedCalories.toInt().toDouble(),
                      null,
                      sets,
                    );
                    Navigator.pop(context);
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
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();
    final durationController = TextEditingController(text: '30');
    String selectedType = 'Cardio';
    String selectedIntensity = 'Trung bình';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm bài tập thủ công'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên bài tập',
                  ),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Loại bài tập',
                  ),
                  value: selectedType,
                  onChanged: (newValue) {
                    selectedType = newValue!;
                  },
                  items: workoutTypes.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: durationController,
                  decoration: InputDecoration(
                    labelText: 'Thời gian (phút)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(
                    labelText: 'Calories đã đốt cháy',
                    suffixText: 'kcal',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Cường độ',
                  ),
                  value: selectedIntensity,
                  onChanged: (newValue) {
                    selectedIntensity = newValue!;
                  },
                  items: intensityLevels.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                if (nameController.text.isNotEmpty &&
                    durationController.text.isNotEmpty) {
                  // Thêm bài tập vào nhật ký
                  _addWorkoutToLog(
                    nameController.text,
                    selectedType,
                    int.tryParse(durationController.text) ?? 30,
                    double.tryParse(caloriesController.text) ?? 0,
                    selectedIntensity,
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  void _addWorkoutToLog(
    String name,
    String type,
    int durationMinutes,
    double caloriesBurned,
    String? intensity, [
    List<Map<String, dynamic>>? sets,
  ]) {
    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

    healthProvider.addWorkoutEntry(
      name,
      type,
      durationMinutes,
      caloriesBurned,
      intensity,
      dateProvider.selectedDate,
    ).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm $name vào nhật ký'),
            backgroundColor: Colors.green,
          ),
        );

        // Quay lại màn hình trước đó
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi khi thêm bài tập'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
