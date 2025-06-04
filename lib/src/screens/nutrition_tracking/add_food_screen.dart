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
      'calories': 130,
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
              title: Text(food['name']),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${food['calories']} kcal / ${food['portion']}'),
                  SizedBox(height: 20),
                  Text('Số lượng:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: quantity > 1 ? () {
                          setState(() {
                            quantity--;
                          });
                        } : null,
                      ),
                      Text(
                        '$quantity',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
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
                  ),
                  onPressed: () {
                    // Thêm món ăn vào nhật ký
                    _addFoodToLog(
                      food['name'],
                      food['calories'] * quantity,
                      selectedMealType,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Thêm', style: TextStyle(color: Colors.white)),
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
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: caloriesController,
                  decoration: InputDecoration(
                    labelText: 'Calories',
                    suffixText: 'kcal',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Bữa ăn',
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF30C9B7),
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && caloriesController.text.isNotEmpty) {
                  // Thêm món ăn vào nhật ký
                  _addFoodToLog(
                    nameController.text,
                    double.tryParse(caloriesController.text) ?? 0,
                    selectedMealType,
                  );
                }
                Navigator.pop(context);
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

    healthProvider.addFoodEntry(
      name,
      calories,
      mealType,
      null, // macros
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
            content: Text('Đã xảy ra lỗi khi thêm món ăn'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
