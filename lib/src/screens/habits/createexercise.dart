import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_wellness/src/data/valuenotifier.dart';
import 'package:my_wellness/src/screens/habits/changerepeatstyle.dart';
import 'package:my_wellness/src/widget/textformfieldwidget.dart';

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

class CreateExercise extends StatefulWidget {
  const CreateExercise({super.key});

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  // Số lần thực hiện tập luyện đang chọn
  int _selectedNumberOfGlasses = 1;
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
  // Map chứa đựng trạng thái của button ở phần Repeat thuộc mục Select Days
  Map<String, bool> _weekDayToggles = {
    "Su": false,
    "Mo": false,
    "Tu": false,
    "We": false,
    "Th": false,
    "Fr": false,
    "Sa": false,
  };

  // ==============================================================================
  // Tạo một CupertinoPicker cho chọn số lượng glasses
  void _showCountNumberPicker(
    BuildContext context,
    String title,
    int quantity, // Số lượng
    String unit, // Đơn vị
  ) {
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
                      title!,
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
                    children: List<Widget>.generate(quantity, (index) {
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
                Text(unit, style: TextStyle(fontSize: 16, color: Colors.grey)),
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
    return ValueListenableBuilder(
      valueListenable: selectedRepeatNotifier,
      builder:
          (context, value, child) => Scaffold(
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
                    TextFormFieldMyWidget(initialValue: "Tập thể dục"),
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
                                          ? Color.fromARGB(255, 219, 189, 70)
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
                                          ? Color.fromARGB(255, 219, 189, 70)
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
                                  color: Color.fromARGB(255, 219, 189, 70),
                                  boxShadow: [boxShadowCustom],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    _showCountNumberPicker(
                                      context,
                                      "Số lần",
                                      10,
                                      "Lần",
                                    );
                                  },
                                  child: Text(
                                    "$_selectedNumberOfGlasses lần",
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
                                    _showCountNumberPicker(
                                      context,
                                      "Số lần",
                                      10,
                                      "Lần",
                                    );
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
                    // ==============================================================================
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        "Lặp lại",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: const Color.fromARGB(255, 142, 142, 142),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                        boxShadow: [boxShadowCustom],
                      ),
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            useSafeArea: true,
                            context: context,
                            builder: (context) {
                              return ChangeRepeatStyleBottomSheet();
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 20.0),
                            Text(
                              value == 0
                                  ? "Không lặp lại"
                                  : value == 1
                                  ? "Chọn ngày"
                                  : "Mỗi một vài ngày",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 25.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    value == 0
                        ? SizedBox.shrink()
                        : value == 1
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              _weekDayToggles.keys.map((label) {
                                bool isSelected = _weekDayToggles[label]!;

                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: FilledButton(
                                      onPressed: () {
                                        setState(() {
                                          _weekDayToggles[label] = !isSelected;
                                        });
                                      },
                                      style: FilledButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                        ),
                                        backgroundColor:
                                            isSelected
                                                ? Color.fromARGB(
                                                  255,
                                                  219,
                                                  189,
                                                  70,
                                                )
                                                : Colors.white,
                                        foregroundColor:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                      child: Text(label.substring(0, 1)),
                                    ),
                                  ),
                                );
                              }).toList(),
                        )
                        : Row(
                          spacing: 15.0,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color.fromARGB(255, 219, 189, 70),
                                  boxShadow: [boxShadowCustom],
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    _showCountNumberPicker(
                                      context,
                                      "Khoảng thời gian",
                                      30,
                                      "Ngày",
                                    );
                                  },
                                  child: Text(
                                    "Mỗi $_selectedNumberOfGlasses ngày",
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
                                    _showCountNumberPicker(
                                      context,
                                      "Khoảng thời gian",
                                      30,
                                      "Ngày",
                                    );
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
          ),
    );
  }
}
