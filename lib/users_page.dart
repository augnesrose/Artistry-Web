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

  @override
  void initState() {
    super.initState();
    fetchUsers();
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Text('Users Data'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : users.isEmpty
                ? Center(
                    child:
                        Text('No users found', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)))
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: DataTable(
                        horizontalMargin: 24,
                        columnSpacing: 30,
                        columns: [
                        DataColumn(label: Text('ID',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Name',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Email',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                      ], rows:users.map((user)=> DataRow(cells: [
                          DataCell(SizedBox(
                              width: 120,
                              child: Text(
                                user['_id'],
                                overflow: TextOverflow.ellipsis,
                              ))),
                          DataCell(Text(user['name'])),
                          DataCell(Text(user['email'])),
                          DataCell(IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 24,
                            ),
                            onPressed: () {},
                          ))
                        ])).toList()
                    ))));
  }
}
