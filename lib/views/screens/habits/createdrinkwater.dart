import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/views/widget/textformfieldwidget.dart';

// ==============================================================================
class MySelectionItem extends StatelessWidget {
  final int title;
  final bool isForList;

  const MySelectionItem({
    super.key,
    required this.title,
    this.isForList = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child:
          isForList
              ? Padding(
                child: _buildItem(context),
                padding: EdgeInsets.all(10.0),
              )
              : Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Stack(
                  children: <Widget>[
                    _buildItem(context),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              ),
    );
  }

  _buildItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Text(title.toString()),
    );
  }
}

class CreateHabitDrinkWater extends StatefulWidget {
  const CreateHabitDrinkWater({super.key});

  @override
  State<CreateHabitDrinkWater> createState() => _CreateHabitDrinkWaterState();
}

class _CreateHabitDrinkWaterState extends State<CreateHabitDrinkWater> {
  // Số lượng ly nước đang chọn
  int _selectedNumberOfGlasses = 8;
  // Custom BoxShadow cho Container
  BoxShadow boxShadowCustom = BoxShadow(
    color: const Color.fromARGB(255, 214, 214, 214),
    blurRadius: 10.0,
    spreadRadius: 0.5,
    offset: Offset(0, 0),
  );
  // Biến theo dõi việc chuyển màu nền và màu chữ cho FillButton trong Goal
  int _selectedIndexGoal = 0;

  final _formGlobalKey = GlobalKey<FormState>();

  // ==============================================================================
  // Tạo một CupertinoPicker cho chọn số lượng glasses
  void _showCountNumberPicker(BuildContext context) {
    int selected = _selectedNumberOfGlasses;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            height: 350,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      "Số lượng",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        // Xử lý chọn xong
                        setState(() {
                          _selectedNumberOfGlasses = selected;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selected - 1,
                    ),
                    itemExtent: 50,
                    onSelectedItemChanged: (index) {
                      selected = index + 1;
                    },
                    children: List<Widget>.generate(100, (index) {
                      return Center(
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(fontSize: 22),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 10),
                Text("Ly", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==============================================================================
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, size: 30.0),
        ),
        title: Text(
          "Tạo",
          style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // ==============================================================================
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 50,
        ),
        child: Form(
          key: _formGlobalKey,
          child: Column(
            spacing: 20.0,
            children: [
              TextFormFieldMyWidget(initialValue: "Uống nước"),
              TextFormFieldMyWidget(
                initialValue: "Ghi chú",
                textAlign: TextAlign.center,
              ),
              // ==============================================================================
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  "Đích",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: const Color.fromARGB(255, 142, 142, 142),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [boxShadowCustom],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndexGoal = 0;
                            });
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            foregroundColor:
                                _selectedIndexGoal == 0
                                    ? Colors.white
                                    : Colors.black,
                            backgroundColor:
                                _selectedIndexGoal == 0
                                    ? Color.fromARGB(255, 62, 176, 230)
                                    : Colors.white,
                          ),
                          child: Text(
                            "Công việc",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndexGoal = 1;
                            });
                          },
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            foregroundColor:
                                _selectedIndexGoal == 1
                                    ? Colors.white
                                    : Colors.black,
                            backgroundColor:
                                _selectedIndexGoal == 1
                                    ? Color.fromARGB(255, 62, 176, 230)
                                    : Colors.white,
                          ),
                          child: Text(
                            "Số đếm",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ==============================================================================
              _selectedIndexGoal == 0
                  ? SizedBox.shrink()
                  : Row(
                    spacing: 15.0,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Color.fromARGB(255, 62, 176, 230),
                            boxShadow: [boxShadowCustom],
                          ),
                          child: TextButton(
                            onPressed: () {
                              _showCountNumberPicker(context);
                            },
                            child: Text(
                              "$_selectedNumberOfGlasses ly",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white,
                            boxShadow: [boxShadowCustom],
                          ),
                          child: TextButton(
                            onPressed: () {
                              _showCountNumberPicker(context);
                            },
                            child: Text(
                              "Thay đổi",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              Expanded(child: SizedBox()),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color.fromARGB(255, 141, 255, 173),
                  boxShadow: [boxShadowCustom],
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lưu",
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
