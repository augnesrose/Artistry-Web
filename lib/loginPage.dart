import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
     final url = Uri.parse("http://localhost:3000/login/admin/login");
     final header={
        'Content-Type': 'application/json',
     };
      final body = jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
      });
      try {
        final response = await http.post(url, headers: header, body: body);
        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {  
            GoRouter.of(context).go('/dashboard');
          } else {
           
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login failed')),
            );
          }
      } catch (e) {
        // Handle network error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network error')),
        );
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ARTISTRY",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "ADMIN LOGIN",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.black
                ),
              ),
              SizedBox(height: 40.h),
              Container(
                width: 0.85.sw > 400.w ? 400.w : 0.85.sw,
                padding: EdgeInsets.all(30.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.shade300,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.r,
                        backgroundColor: Colors.transparent,
                        backgroundImage: const AssetImage('image/image1.jpg'),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: 280.w,
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.grey.shade700,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    SizedBox(
                      width: 280.w,
                      child: TextField(
                        controller: _passwordController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.grey.shade700,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 18.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SizedBox(
                      width: 280.w,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () {
                          _login();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.3),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
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
}