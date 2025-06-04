import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_wellness/src/data/providers/health_data_provider.dart';
import 'package:my_wellness/src/data/providers/selected_date_provider.dart';

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  // Danh sách các loại bữa ăn
  final List<String> mealTypes = ['Bữa sáng', 'Bữa trưa', 'Bữa tối', 'Bữa phụ'];
  String selectedMealType = 'Bữa sáng';

  // Danh mục món ăn phổ biến
  final List<Map<String, dynamic>> commonFoods = [
    {
      'name': 'Cơm trắng',
      'calories': 130, // Đã là int, sẽ được chuyển đổi sang double khi sử dụng
      'portion': '1 chén',
      'image': 'assets/images/rice.png'
    },
    {
      'name': 'Bánh mì',
      'calories': 265,
      'portion': '1 ổ',
      'image': 'assets/images/bread.png'
    },
    {
      'name': 'Trứng chiên',
      'calories': 90,
      'portion': '1 quả',
      'image': 'assets/images/egg.png'
    },
    {
      'name': 'Bún phở',
      'calories': 400,
      'portion': '1 tô',
      'image': 'assets/images/noodle.png'
    },
    {
      'name': 'Thịt gà',
      'calories': 165,
      'portion': '100g',
      'image': 'assets/images/chicken.png'
    },
    {
      'name': 'Cá',
      'calories': 206,
      'portion': '100g',
      'image': 'assets/images/fish.png'
    },
    {
      'name': 'Rau xanh',
      'calories': 30,
      'portion': '100g',
      'image': 'assets/images/vegetables.png'
    },
    {
      'name': 'Trái cây',
      'calories': 60,
      'portion': '100g',
      'image': 'assets/images/fruit.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm món ăn'),
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
                hintText: 'Tìm kiếm món ăn...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Loại bữa ăn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text('Bữa ăn:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedMealType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedMealType = newValue!;
                      });
                    },
                    items: mealTypes.map<DropdownMenuItem<String>>((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Tiêu đề danh mục
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Món ăn phổ biến',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Danh sách món ăn phổ biến
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: commonFoods.length,
              itemBuilder: (context, index) {
                final food = commonFoods[index];
                return _buildFoodCard(food);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddManualFoodDialog(context);
        },
        backgroundColor: Color(0xFF30C9B7),
        child: Icon(Icons.add),
        tooltip: 'Thêm thủ công',
      ),
    );
  }

  Widget _buildFoodCard(Map<String, dynamic> food) {
    return InkWell(
      onTap: () {
        _showFoodDetailDialog(food);
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
                    Icons.restaurant,
                    size: 60,
                    color: Color(0xFF30C9B7),
                  ),
                ),
              ),
              Text(
                food['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '${food['calories']} kcal / ${food['portion']}',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFoodDetailDialog(Map<String, dynamic> food) {
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(food['name'], style: TextStyle(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${food['calories']} kcal / ${food['portion']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[100],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline, color: Color(0xFF30C9B7)),
                          onPressed: quantity > 1 ? () {
                            setState(() {
                              quantity--;
                            });
                          } : null,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Color(0xFF30C9B7), width: 1),
                          ),
                          child: Text(
                            '$quantity',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Color(0xFF30C9B7)),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy', style: TextStyle(color: Colors.grey[700])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF30C9B7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    // Thêm món ăn vào nhật ký
                    Navigator.pop(context); // Đóng dialog trước

                    _addFoodToLog(
                      food['name'],
                      // Xử lý an toàn cho các kiểu dữ liệu calories
                      (() {
                        dynamic calories = food['calories'];
                        double caloriesValue = 0.0;
                        if (calories == null) {
                          caloriesValue = 0.0;
                        } else if (calories is int) {
                          caloriesValue = calories.toDouble();
                        } else if (calories is double) {
                          caloriesValue = calories;
                        } else {
                          try {
                            caloriesValue = double.parse(calories.toString());
                          } catch (e) {
                            caloriesValue = 0.0;
                          }
                        }
                        // Xử lý an toàn cho biến quantity
                        double quantityValue;
                        if (quantity == null) {
                          quantityValue = 1.0; // Giá trị mặc định
                        } else if (quantity is int) {
                          quantityValue = quantity.toDouble();
                        } else if (quantity is double) {
                          quantityValue = quantity as double;
                        } else {
                          try {
                            quantityValue = double.parse(quantity.toString());
                          } catch (e) {
                            quantityValue = 1.0; // Giá trị mặc định nếu parse lỗi
                          }
                        }
                        return caloriesValue * quantityValue;
                      })(),
                      selectedMealType,
                    );
                  },
                  child: Text('Thêm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddManualFoodDialog(BuildContext context) {
    final nameController = TextEditingController();
    final caloriesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Thêm món ăn thủ công'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên món ăn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(
                    labelText: 'Calories',
                    suffixText: 'kcal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Bữa ăn',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  value: selectedMealType,
                  onChanged: (newValue) {
                    setState(() {
                      selectedMealType = newValue!;
                    });
                  },
                  items: mealTypes.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF30C9B7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && caloriesController.text.isNotEmpty) {
                  Navigator.pop(context); // Đóng dialog trước

                  // Thêm món ăn vào nhật ký
                  _addFoodToLog(
                    nameController.text,
                    double.tryParse(caloriesController.text) ?? 0.0, // Đảm bảo là double
                    selectedMealType,
                  );
                }
              },
              child: Text('Thêm', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _addFoodToLog(String name, double calories, String mealType) {
    final healthProvider = Provider.of<HealthDataProvider>(context, listen: false);
    final dateProvider = Provider.of<SelectedDateProvider>(context, listen: false);

    // Hiển thị thông báo loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF30C9B7)),
                ),
                SizedBox(width: 20),
                Text('Đang thêm món ăn...'),
              ],
            ),
          ),
        );
      },
    );

    healthProvider.addFoodEntry(
      name,
      calories,
      mealType,
      null, // macros
      dateProvider.selectedDate,
    ).then((success) async {
      // Đóng hộp thoại loading
      Navigator.pop(context);

      if (success) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã thêm $name vào nhật ký'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Chờ một chút để đảm bảo dữ liệu được lưu đầy đủ
        await Future.delayed(Duration(milliseconds: 300));

        // Sau khi thêm thành công, làm mới dữ liệu cho ngày đã chọn
        await healthProvider.loadDailyLog(dateProvider.selectedDate);

        // Quay lại màn hình trước đó và truyền kết quả thành công
        Navigator.of(context).pop(true);
      } else {
        // Hiển thị thông báo lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã xảy ra lỗi khi thêm món ăn'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }).catchError((error) {
      // Đóng hộp thoại loading nếu có lỗi
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã xảy ra lỗi: $error'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
