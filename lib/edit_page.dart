import 'dart:io';
import 'package:artistry_admin_web/adminAddProduct.dart';
import 'package:artistry_admin_web/adminproducts_page.dart';
import 'package:artistry_admin_web/product_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProduct({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _mediumController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _hmeasureController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _wmeasureController = TextEditingController();
  final TextEditingController _artistNameController = TextEditingController();
  final TextEditingController _artistDescriptionController = TextEditingController();

  XFile? _productImage;
  XFile? _artistImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.product['name'] ?? '';
    _priceController.text = widget.product['price']?.toString() ?? '';
    _productDescriptionController.text = widget.product['productDescription'] ?? '';
    _categoryController.text = widget.product['category'] ?? '';
    print('Category value after init: ${_categoryController.text}');
    _mediumController.text = widget.product['medium'] ?? '';
    print('Medium value after init: ${_mediumController.text}');
    _materialController.text = widget.product['material'] ?? '';
    _heightController.text = widget.product['height']?.toString() ?? '';
    _hmeasureController.text = widget.product['h_measure'] ?? '';
    _widthController.text = widget.product['width']?.toString() ?? '';
    _wmeasureController.text = widget.product['w_measure'] ?? '';
    _artistNameController.text = widget.product['artistName'] ?? '';
    _artistDescriptionController.text = widget.product['artistDescription'] ?? '';

    // Use the actual image URLs from the product data
    //If the images are stored as URLs, no need to convert to XFile in initState.
    //  _productImage = XFile(widget.product['productImage'] ?? '');
    // _artistImage = XFile(widget.product['artistImage'] ?? '');
  }

  // Future<void> updateProduct() async {
  //   final Uri url = Uri.parse("http://192.168.85.52:3000/admin/updateProduct/${widget.product['_id']}");

  //   try {
  //     print("Updating product with ID: ${widget.product['_id']}");

  //     var request = http.MultipartRequest('PUT', url);

  //     if (_productNameController.text.isNotEmpty) request.fields['name'] = _productNameController.text;
  //     if (_priceController.text.isNotEmpty) request.fields['price'] = _priceController.text;
  //     if (_productDescriptionController.text.isNotEmpty) request.fields['productDescription'] = _productDescriptionController.text;
  //     if (_categoryController.text.isNotEmpty) request.fields['category'] = _categoryController.text;
  //     if (_mediumController.text.isNotEmpty) request.fields['medium'] = _mediumController.text;
  //     if (_materialController.text.isNotEmpty) request.fields['material'] = _materialController.text;
  //     if (_heightController.text.isNotEmpty) request.fields['height'] = _heightController.text;
  //     if (_hmeasureController.text.isNotEmpty) request.fields['h_measure'] = _hmeasureController.text;
  //     if (_widthController.text.isNotEmpty) request.fields['width'] = _widthController.text;
  //     if (_wmeasureController.text.isNotEmpty) request.fields['w_measure'] = _wmeasureController.text;
  //     if (_artistNameController.text.isNotEmpty) request.fields['artistName'] = _artistNameController.text;
  //     if (_artistDescriptionController.text.isNotEmpty) request.fields['artistDescription'] = _artistDescriptionController.text;

  //     print("Request fields: ${request.fields}");

  //     if (_productImage != null) {
  //       final mimeTypeData = lookupMimeType(_productImage!.path) ?? 'image/jpeg';
  //       final mimeTypeParts = mimeTypeData.split('/');
  //       request.files.add(
  //         http.MultipartFile.fromBytes(
  //           'productImage',
  //           await _productImage!.readAsBytes(),
  //           filename: _productImage!.name,
  //           contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
  //         ),
  //       );
  //     }

  //     if (_artistImage != null) {
  //       final mimeTypeData = lookupMimeType(_artistImage!.path) ?? 'image/jpeg';
  //       final mimeTypeParts = mimeTypeData.split('/');
  //       request.files.add(
  //         http.MultipartFile.fromBytes(
  //           'artistImage',
  //           await _artistImage!.readAsBytes(),
  //           filename: _artistImage!.name,
  //           contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
  //         ),
  //       );
  //     }

  //     final response = await request.send();
  //     final responseBody = await response.stream.bytesToString();

  //     print('Response status: ${response.statusCode}');
  //     print('Full response: $responseBody');

  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Updated")));
  //       Navigator.push(context, MaterialPageRoute(builder: (context) => AdminProducts()));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Failed: $responseBody")));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
  //   }
  // }

  Future<void> updateProduct() async {
  final Uri url = Uri.parse("http://localhost:3000/admin/updateProduct/${widget.product['_id']}");

  try {
    print("Updating product with ID: ${widget.product['_id']}");

    var request = http.MultipartRequest('PUT', url);

    print("Product Name: ${_productNameController.text}");
    print("Price: ${_priceController.text}");
    print("Product Description: ${_productDescriptionController.text}");

    if (_productNameController.text.isNotEmpty) request.fields['name'] = _productNameController.text;
    if (_priceController.text.isNotEmpty) request.fields['price'] = _priceController.text;
    if (_productDescriptionController.text.isNotEmpty) request.fields['productDescription'] = _productDescriptionController.text;
    if (_categoryController.text.isNotEmpty) request.fields['category'] = _categoryController.text;
    if (_mediumController.text.isNotEmpty) request.fields['medium'] = _mediumController.text;
    if (_materialController.text.isNotEmpty) request.fields['material'] = _materialController.text;
    if (_heightController.text.isNotEmpty) request.fields['height'] = _heightController.text;
    if (_hmeasureController.text.isNotEmpty) request.fields['h_measure'] = _hmeasureController.text;
    if (_widthController.text.isNotEmpty) request.fields['width'] = _widthController.text;
    if (_wmeasureController.text.isNotEmpty) request.fields['w_measure'] = _wmeasureController.text;
    if (_artistNameController.text.isNotEmpty) request.fields['artistName'] = _artistNameController.text;
    if (_artistDescriptionController.text.isNotEmpty) request.fields['artistDescription'] = _artistDescriptionController.text;

    print("Request fields: ${request.fields}");

    if (_productImage != null) {
      final mimeTypeData = lookupMimeType(_productImage!.path) ?? 'image/jpeg';
      final mimeTypeParts = mimeTypeData.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'productImage',
          await _productImage!.readAsBytes(),
          filename: _productImage!.name,
          contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
        ),
      );
    }

    if (_artistImage != null) {
      final mimeTypeData = lookupMimeType(_artistImage!.path) ?? 'image/jpeg';
      final mimeTypeParts = mimeTypeData.split('/');
      request.files.add(
        http.MultipartFile.fromBytes(
          'artistImage',
          await _artistImage!.readAsBytes(),
          filename: _artistImage!.name,
          contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    print('Response status: ${response.statusCode}');
    print('Full response: $responseBody');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Updated")));
      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminProducts()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Failed: $responseBody")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
  }
}

  Future<void> selectProductImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = pickedFile;
      });
    }
  }

  Future<void> selectArtistImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _artistImage = pickedFile;
      });
    }
  }

  Widget buildImagePreview(XFile? image, String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8.h),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxWidth * 0.75,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: image == null
                  ? imageUrl.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 40.sp,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Error loading image',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(
                              image.path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Error loading image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            )
                          : Image.file(
                              File(image.path),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text(
                                    'Error loading image',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              },
                            ),
                    ),
            );
          },
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Edit Product'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField('Product Name', controller: _productNameController),
                  SizedBox(height: 20.h),
                  buildTextField('Price', controller: _priceController),
                  SizedBox(height: 20.h),
                  buildTextField('Product Description', maxLines: 5, controller: _productDescriptionController),
                  SizedBox(height: 20.h),
                  CategoryDropdown(controller: _categoryController),
                  SizedBox(height: 20.h),
                  buildTextField('Material', controller: _materialController),
                  SizedBox(height: 20.h),
                  MediumDropdown(controller: _mediumController),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(child: buildTextField("Height", controller: _heightController)),
                      SizedBox(width: 5.w),
                      Expanded(child: SizeDropdown(controller: _hmeasureController)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(child: buildTextField("Width", controller: _widthController)),
                      SizedBox(width: 5.w),
                      Expanded(child: SizeDropdown(controller: _wmeasureController)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  buildTextField('Artist Name', controller: _artistNameController),
                  SizedBox(height: 20.h),
                  buildTextField('Artist Description', maxLines: 5, controller: _artistDescriptionController),
                  SizedBox(height: 30.h),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
                      ),
                      onPressed: () {
                        updateProduct();
                        print("Update button pressed");
                      },
                      child: const Text('Update Product', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: VerticalDivider(
              width: 1.w,
              thickness: 1,
              color: Colors.grey[300],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
              padding: EdgeInsets.all(8.w),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: selectProductImage,
                      child: buildImagePreview(_productImage, 'Product Image Preview', widget.product['productImage'] ?? ''),
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: selectArtistImage,
                      child: buildImagePreview(_artistImage, 'Artist Image Preview', widget.product['artistImage'] ?? ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(String hint, {int maxLines = 1, required TextEditingController controller}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.black),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide            .none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
      ),
    );
  }
}