import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


Widget buildDashboardCard({
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
      margin: EdgeInsets.symmetric(horizontal:6),
      elevation: 4, // Increased elevation for more pronounced shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: darkerColor.withOpacity(0.5), // Shadow color based on main color
      child: Container(
        padding: EdgeInsets.all(10), // Equal padding on all sides
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
              size: 35.r,
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 5.sp,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            TweenAnimationBuilder<int>(
              key: ValueKey(value),
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



//---------------------------------------------******************----------------------------------
//Bar chart implementation
//--------------------------------------------*******************------------------------------------



