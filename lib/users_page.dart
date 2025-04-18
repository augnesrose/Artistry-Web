import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchUsers();
    
    // Set up automatic refresh every 60 seconds
    _refreshTimer = Timer.periodic(Duration(seconds: 60), (timer) {
      fetchUsers();
    });
  }
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    try {
      var url = Uri.parse("http://localhost:3000/admin/users/getUsers");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Ensure data is not null and is a list
        if (data is List) {
          setState(() {
            users = data;
            isLoading = false;
          });
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } on ClientException catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Client exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users due to a client error.')),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users. Please try again.')),
      );
    }
  }

  void _showUserDetailsDialog(dynamic user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Details', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _detailRow('ID', user['_id']),
                _detailRow('Name', user['name']),
                _detailRow('Email', user['email']),
                _detailRow('Phone', user['phone'] ?? 'Not provided'),
                _detailRow('Address', user['address'] ?? 'Not provided'),
                // Add more details as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 14)),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Users Data'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchUsers();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? Center(
                  child: Text(
                    'No users found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              horizontalMargin: 24,
                              columnSpacing: 30,
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'ID',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Name',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Email',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Details',
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              rows: users.map((user) => DataRow(cells: [
                                    DataCell(SizedBox(
                                      width: 120,
                                      child: Text(
                                        user['_id'],
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color.fromARGB(255, 41, 38, 38),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                                    DataCell(Text(
                                      user['name'],
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 41, 38, 38),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    DataCell(Text(
                                      user['email'],
                                      style: TextStyle(
                                        color: const Color.fromARGB(255, 41, 38, 38),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
                                    DataCell(IconButton(
                                      icon: Icon(
                                        Icons.visibility,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                      onPressed: () {
                                        _showUserDetailsDialog(user);
                                      },
                                    ))
                                  ])).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}