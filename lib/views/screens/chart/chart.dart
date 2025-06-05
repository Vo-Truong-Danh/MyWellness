import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  _ChartState createState() => _ChartState();
}

enum TimeRange { week, month, year }

class _ChartState extends State<Chart> with SingleTickerProviderStateMixin {
  TimeRange _selectedRange = TimeRange.week;
  TabController? _tabController;

  // Dữ liệu demo cho trường hợp chưa có dữ liệu từ Firestore
  final List<Map<String, dynamic>> _demoWeightData = [
    {'date': DateTime.now().subtract(Duration(days: 6)), 'value': 70.0},
    {'date': DateTime.now().subtract(Duration(days: 5)), 'value': 69.8},
    {'date': DateTime.now().subtract(Duration(days: 4)), 'value': 69.5},
    {'date': DateTime.now().subtract(Duration(days: 3)), 'value': 69.7},
    {'date': DateTime.now().subtract(Duration(days: 2)), 'value': 69.3},
    {'date': DateTime.now().subtract(Duration(days: 1)), 'value': 69.0},
    {'date': DateTime.now(), 'value': 69.0},
  ];

  final List<Map<String, dynamic>> _demoCaloriesData = [
    {'date': DateTime.now().subtract(Duration(days: 6)), 'value': 1850.0},
    {'date': DateTime.now().subtract(Duration(days: 5)), 'value': 1720.0},
    {'date': DateTime.now().subtract(Duration(days: 4)), 'value': 2100.0},
    {'date': DateTime.now().subtract(Duration(days: 3)), 'value': 1950.0},
    {'date': DateTime.now().subtract(Duration(days: 2)), 'value': 1800.0},
    {'date': DateTime.now().subtract(Duration(days: 1)), 'value': 1650.0},
    {'date': DateTime.now(), 'value': 720.0},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF30C9B7),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicator: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: 3.0)),
          ),
          tabs: [
            Tab(text: 'Cân nặng'),
            Tab(text: 'Calories'),
            Tab(text: 'Nhịp tim'),
            Tab(text: 'Tiến độ'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTimeRangeSelector(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildWeightChart(),
                _buildCaloriesChart(),
                _buildHeartRateChart(),
                _buildProgressChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildRangeChip(TimeRange.week, 'Tuần'),
          SizedBox(width: 12),
          _buildRangeChip(TimeRange.month, 'Tháng'),
          SizedBox(width: 12),
          _buildRangeChip(TimeRange.year, 'Năm'),
        ],
      ),
    );
  }

  Widget _buildRangeChip(TimeRange range, String label) {
    final isSelected = _selectedRange == range;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: Color(0xFF30C9B7),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedRange = range;
          });
        }
      },
    );
  }

  Widget _buildWeightChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Biến động cân nặng',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= _demoWeightData.length) {
                          return SizedBox();
                        }
                        final date =
                            _demoWeightData[value.toInt()]['date'] as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(1),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minY: _getMinValue(_demoWeightData) - 0.5,
                maxY: _getMaxValue(_demoWeightData) + 0.5,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(_demoWeightData.length, (index) {
                      return FlSpot(
                        index.toDouble(),
                        _demoWeightData[index]['value'],
                      );
                    }),
                    isCurved: true,
                    color: Color(0xFF30C9B7),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Color(0xFF30C9B7),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF30C9B7).withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          _buildWeekSummaryTable(_demoWeightData),
        ],
      ),
    );
  }

  Widget _buildCaloriesChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lượng calories tiêu thụ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${rod.toY.round()} kcal',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= _demoCaloriesData.length) {
                          return SizedBox();
                        }
                        final date =
                            _demoCaloriesData[value.toInt()]['date']
                                as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 500 != 0) return SizedBox();
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                barGroups: _buildCalorieBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildCalorieBarGroups() {
    final calorieTarget = 2000.0;

    return List.generate(_demoCaloriesData.length, (index) {
      final currentValue =
          (_demoCaloriesData[index]['value'] as num).toDouble();
      final color =
          currentValue >= calorieTarget ? Colors.red : Color(0xFF30C9B7);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: currentValue,
            color: color,
            width: 16,
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildHeartRateChart() {
    // Giả lập dữ liệu nhịp tim
    final heartRateData = [
      {
        'date': DateTime.now().subtract(Duration(days: 6)),
        'avg': 72,
        'max': 110,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 5)),
        'avg': 75,
        'max': 125,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 4)),
        'avg': 71,
        'max': 118,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 3)),
        'avg': 74,
        'max': 130,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 2)),
        'avg': 73,
        'max': 122,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 1)),
        'avg': 76,
        'max': 135,
      },
      {'date': DateTime.now(), 'avg': 75, 'max': 119},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nhịp tim',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= heartRateData.length) {
                          return SizedBox();
                        }
                        final date =
                            heartRateData[value.toInt()]['date'] as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 10 != 0) return SizedBox();
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                minY: 60,
                maxY: 140,
                lineBarsData: [
                  // Đường nhịp tim trung bình
                  LineChartBarData(
                    spots: List.generate(heartRateData.length, (index) {
                      final dynamic avgValue = heartRateData[index]['avg'];
                      double doubleValue;
                      if (avgValue == null) {
                        doubleValue = 0.0;
                      } else if (avgValue is int) {
                        doubleValue = avgValue.toDouble();
                      } else if (avgValue is double) {
                        doubleValue = avgValue;
                      } else {
                        doubleValue = 0.0;
                      }
                      return FlSpot(index.toDouble(), doubleValue);
                    }),
                    isCurved: true,
                    color: Color(0xFF30C9B7),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF30C9B7).withOpacity(0.2),
                    ),
                  ),
                  // Đường nhịp tim tối đa
                  LineChartBarData(
                    spots: List.generate(heartRateData.length, (index) {
                      final dynamic maxValue = heartRateData[index]['max'];
                      double doubleValue;
                      if (maxValue == null) {
                        doubleValue = 0.0;
                      } else if (maxValue is int) {
                        doubleValue = maxValue.toDouble();
                      } else if (maxValue is double) {
                        doubleValue = maxValue;
                      } else {
                        doubleValue = 0.0;
                      }
                      return FlSpot(index.toDouble(), doubleValue);
                    }),
                    isCurved: true,
                    color: Colors.redAccent,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Trung bình", Color(0xFF30C9B7)),
              SizedBox(width: 20),
              _buildLegendItem("Cao nhất", Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
    // Giả lập dữ liệu tiến độ
    final progressData = [
      {
        'date': DateTime.now().subtract(Duration(days: 6)),
        'water': 0.8,
        'steps': 0.6,
        'habits': 0.5,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 5)),
        'water': 0.9,
        'steps': 0.7,
        'habits': 0.75,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 4)),
        'water': 0.7,
        'steps': 0.5,
        'habits': 0.5,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 3)),
        'water': 1.0,
        'steps': 0.8,
        'habits': 1.0,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 2)),
        'water': 0.85,
        'steps': 0.9,
        'habits': 0.75,
      },
      {
        'date': DateTime.now().subtract(Duration(days: 1)),
        'water': 0.75,
        'steps': 0.6,
        'habits': 0.5,
      },
      {'date': DateTime.now(), 'water': 0.4, 'steps': 0.3, 'habits': 0.25},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tiến độ hoàn thành mục tiêu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceEvenly,
                maxY: 1.0,
                groupsSpace: 12,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.grey.shade800,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String title = '';
                      switch (rodIndex) {
                        case 0:
                          title = 'Nước';
                          break;
                        case 1:
                          title = 'Bước chân';
                          break;
                        case 2:
                          title = 'Thói quen';
                          break;
                      }
                      return BarTooltipItem(
                        '$title: ${(rod.toY * 100).round()}%',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= progressData.length) {
                          return SizedBox();
                        }
                        final date =
                            progressData[value.toInt()]['date'] as DateTime;
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('dd/MM').format(date),
                            style: TextStyle(fontSize: 10),
                          ),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value % 0.2 != 0) return SizedBox();
                        return Text(
                          '${(value * 100).toInt()}%',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: const Color(0xff37434d), width: 1),
                ),
                barGroups: List.generate(progressData.length, (index) {
                  final item = progressData[index];
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (item['water'] as num).toDouble(),
                        color: Colors.blue,
                        width: 8,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: (item['steps'] as num).toDouble(),
                        color: Colors.orange,
                        width: 8,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                      BarChartRodData(
                        toY: (item['habits'] as num).toDouble(),
                        color: Colors.purple,
                        width: 8,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Nước", Colors.blue),
              SizedBox(width: 20),
              _buildLegendItem("Bước chân", Colors.orange),
              SizedBox(width: 20),
              _buildLegendItem("Thói quen", Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildWeekSummaryTable(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng kết',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Cao nhất',
                '${_getMaxValue(data).toStringAsFixed(1)} kg',
              ),
              _buildSummaryItem(
                'Thấp nhất',
                '${_getMinValue(data).toStringAsFixed(1)} kg',
              ),
              _buildSummaryItem(
                'Trung bình',
                '${_getAvgValue(data).toStringAsFixed(1)} kg',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  double _getMaxValue(List<Map<String, dynamic>> data) {
    double max = data[0]['value'];
    for (var item in data) {
      if (item['value'] > max) max = item['value'];
    }
    return max;
  }

  double _getMinValue(List<Map<String, dynamic>> data) {
    double min = data[0]['value'];
    for (var item in data) {
      if (item['value'] < min) min = item['value'];
    }
    return min;
  }

  double _getAvgValue(List<Map<String, dynamic>> data) {
    double sum = 0;
    for (var item in data) {
      sum += item['value'];
    }
    return sum / data.length;
  }
}
