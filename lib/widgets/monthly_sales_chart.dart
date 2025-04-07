import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlySalesChart extends StatefulWidget {
  final List<int> salesData;
  const MonthlySalesChart({super.key, required this.salesData});

  @override
  State<MonthlySalesChart> createState() => _MonthlySalesChartState();
}

class _MonthlySalesChartState extends State<MonthlySalesChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 13000),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Monthly Sales Analysis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return BarChart(
                      BarChartData(
                        backgroundColor: Colors.white,
                        barGroups: _generateBarGroups(_animation.value),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            bottom: BorderSide(color: Colors.black12, width: 1),
                            left: BorderSide(color: Colors.black12, width: 1),
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 10,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.black12,
                              strokeWidth: 1,
                              dashArray: [5],
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                const months = [
                                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                                ];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    months[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 35,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            //tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${widget.salesData[group.x.toInt()]}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(double animationValue) {
    return List.generate(widget.salesData.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.salesData[index].toDouble() * animationValue,
            color: Colors.blue.shade600,
            width: 12,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: widget.salesData.reduce((a, b) => a > b ? a : b).toDouble(),
              color: Colors.grey.withOpacity(0.05),
            ),
          ),
        ],
      );
    });
  }
}