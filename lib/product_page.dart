import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:artistry_admin_web/edit_page.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  const ProductPage(this.productId, {super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    try {
      var url = Uri.parse(
          "http://localhost:3000/admin/getProduct/${widget.productId}");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var decodedProduct = jsonDecode(response.body);
        print('Decoded Product: $decodedProduct');

        setState(() {
          product = decodedProduct['product']; // Access the nested product map
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load product');
      }
    } catch (e) {
      print('Error fetching product: $e');
      setState(() {
        isLoading = false; // Ensure UI updates even on error
      });
    }
  }

  Future<void> deleteProduct() async {
    try{
      var url = Uri.parse('http://localhost:3000/admin/deleteProduct/${widget.productId}');
      var response = await http.delete(url);

      if(response.statusCode == 200){
        print('Product deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted successfully'),backgroundColor: Colors.green,));
        Navigator.pop(context);
      }
      else{
        print('Failed to delete product');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete product'),backgroundColor: Colors.red,)); 
      }
    }
    catch(e){
      print('Error deleting product: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Product Details'),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : product == null
              ? Center(child: Text('Product Not Found'))
              : Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          product?['productImage'] != null
                              ? 'http://localhost:3000/uploads/${product?['productImage']}'
                              : 'http://default_image_url_here.jpg',
                          // width: double.infinity,
                          // height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${product?['name'] ?? 'Unknown Product'}',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                '\u20B9${product?['price'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 8.sp,
                                    color:
                                        const Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                '${product?['productDescription'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 3.sp,
                                    color:
                                        const Color.fromARGB(255, 40, 37, 37)),
                              ),
                              SizedBox(height: 10.h),
                              Text('About The Artist',
                                  style: TextStyle(
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 192, 15, 3))),
                              SizedBox(height: 10.h),
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  'http://localhost:3000/uploads/${product?['artistImage'] ?? 'default_artist_image.jpg'}',
                                ),
                                radius: 50.r,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                '${product?['artistName'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 4.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                '${product?['artistDescription'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 3.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 10.h),
                              Text('Product Details',
                                  style: TextStyle(
                                      fontSize: 5.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.h),
                              Text(
                                'Category: ${product?['category'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 3.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Material: ${product?['material'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 3.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Medium: ${product?['medium'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontSize: 3.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    'Height: ${product?['height'] ?? 'N/A'}',
                                    style: TextStyle(
                                        fontSize: 3.sp,
                                        color: Color.fromARGB(255, 40, 37, 37),
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text('${product?['w_measure']??'N/A'}',
                                      style: TextStyle(
                                          fontSize: 3.sp,
                                          color: Color.fromARGB(255, 40, 37, 37),
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    'Width: ${product?['width'] ?? 'N/A'}',
                                    style: TextStyle(
                                        fontSize: 3.sp,
                                        color: Color.fromARGB(255, 40, 37, 37),
                                        fontWeight: FontWeight.w300),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text('${product?['w_measure']??'N/A'}',
                                      style: TextStyle(
                                          fontSize: 3.sp,
                                          color: Color.fromARGB(255, 40, 37, 37),
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Shipping fee: \u20B9${product?['shippingFee'] ?? 'N/A'} ',
                                style: TextStyle(
                                    fontSize: 5.sp,
                                    color: Color.fromARGB(255, 40, 37, 37),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                    if (product != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProduct( product: {
        ...product!,
        'productImage': 'http://localhost:3000/uploads/${product?['productImage']}',
        'artistImage': 'http://localhost:3000/uploads/${product?['artistImage']}',
      },)),
          );
        } else {
          // Handle the case when product is null, e.g., show a message to the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product data is not available')),
          );
        }
      },
                                    child: Text('Edit'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation: 5,
                                      backgroundColor: Colors.orange,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 10.h),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  ElevatedButton(
                                    onPressed: () {
                                      _deleteConfirmation(context);
                                    },
                                    child: Text('Delete'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      elevation: 5,
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w, vertical: 10.h),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  void _deleteConfirmation(BuildContext context){
    showDialog(context: context, builder:(context)=>AlertDialog(
      title: Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this product?'),
      actions: [
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
            deleteProduct();
          },
          child: Text('Yes',style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          child: Text('No',style: TextStyle(color: Colors.green)),
        )
      ],
    ));
  }
}