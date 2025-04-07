import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample data
  final List<int> monthlySales = [5, 4, 8, 10, 6, 3, 5, 0, 0, 0, 0, 0];
  final Map<String, double> categoryData = {
    'Paintings': 35,
    'Sculpture': 15,
    'Photography': 20,
    'Poster': 10,
    'Abstract': 12,
    'Collage': 5,
    'Digital Art': 3,
  };
  final double totalIncome = 24850;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background to white
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header and total income
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Dashboard Overview",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 167, 4, 42),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildIncomeCircle(),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Info cards row
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: Row(
                  children: [
                    _buildDashboardCard(
                      title: "Total Users",
                      value: 100,
                      icon: Icons.person,
                      color: const Color(0xFFc5a64c),
                    ),
                    _buildDashboardCard(
                      title: "Products Sold",
                      value: 21,
                      icon: Icons.shopping_cart,
                      color: const Color(0xFF4c61c5),
                    ),
                    _buildDashboardCard(
                      title: "Total Products",
                      value: 100,
                      icon: Icons.edit,
                      color: const Color(0xFFc54c4c),
                    ),
                    _buildDashboardCard(
                      title: "New Joinees",
                      value: 15,
                      icon: Icons.group,
                      color: const Color(0xFF4c8a52),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Charts row
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bar chart
                    Expanded(
                      flex: 3,
                      child: MonthlySalesChart(salesData: monthlySales),
                    ),
                    
                    // Pie chart
                    Expanded(
                      flex: 2,
                      child: CategoryPieChart(categoryData: categoryData),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomeCircle() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Total Income",
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: totalIncome),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Text(
                  "\u20B9${value.toInt().toString()}",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    // Create gradient with the provided color
    final Color lighterColor = Color.lerp(color, Colors.white, 0.3) ?? color;
    final Color darkerColor = Color.lerp(color, Colors.black, 0.2) ?? color;
    
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: darkerColor.withOpacity(0.5),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [lighterColor, darkerColor],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: value),
                duration: const Duration(seconds: 2),
                builder: (context, val, child) {
                  return Text(
                    val.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Monthly Sales Chart Component
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
      duration: const Duration(milliseconds: 1500),
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
      color: Colors.white, // Set card background to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Monthly Sales Analysis",
              style: TextStyle(
                fontSize: 16, 
                color: Color.fromARGB(255, 167, 4, 42),
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return BarChart(
                      BarChartData(
                        backgroundColor: Colors.white, // Set chart background to white
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
                          horizontalInterval: 2,
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
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    months[value.toInt()],
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              },
                              reservedSize: 25,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              getTitlesWidget: (value, _) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 10,
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
            width: 10,
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

// Category Pie Chart Component
class CategoryPieChart extends StatefulWidget {
  final Map<String, double> categoryData;
  
  const CategoryPieChart({super.key, required this.categoryData});

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
      color: Colors.white, // Set card background to white
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Categories",
              style: TextStyle(
                fontSize: 16, 
                color: Color.fromARGB(255, 167, 4, 42),
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  // Pie chart
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, _) {
                        return PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            startDegreeOffset: 180,
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 2,
                            centerSpaceRadius: 25,
                            sections: _showingSections(_animation.value),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Legend
                  SizedBox(
                    width: 100,
                    child: _buildLegend(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections(double animValue) {
    final List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];
    
    return List.generate(widget.categoryData.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 18 : 14;
      final double radius = isTouched ? 80 : 70;
      
      String key = widget.categoryData.keys.elementAt(i);
      double value = widget.categoryData[key]! * animValue;
      
      return PieChartSectionData(
        color: colors[i % colors.length],
        value: value,
        title: '',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildLegend() {
    final List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
    ];
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.categoryData.keys.map((category) {
          int index = widget.categoryData.keys.toList().indexOf(category);
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index % colors.length],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}