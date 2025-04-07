import 'dart:io';
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

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});
  @override
  State<AddProduct> createState() => _AddProductState();
}
class _AddProductState extends State<AddProduct> {
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
  final TextEditingController _artistDescriptionController =TextEditingController();
  final TextEditingController _shippingFeeController=TextEditingController();
      
  XFile? _productImage;
  XFile? _artistImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> addProduct() async {
    final Uri url = Uri.parse("http://localhost:3000/admin/addProduct");

    try {
      var request = http.MultipartRequest('POST', url);

      // Add text fields
      request.fields['name'] = _productNameController.text;
      request.fields['price'] = _priceController.text;
      request.fields['productDescription'] = _productDescriptionController.text;
      request.fields['category'] = _categoryController.text;
      request.fields['medium'] = _mediumController.text;
      request.fields['material'] = _materialController.text;
      request.fields['height'] = _heightController.text;
      request.fields['h_measure'] = _hmeasureController.text;
      request.fields['width'] = _widthController.text;
      request.fields['w_measure'] = _wmeasureController.text;
      request.fields['artistName'] = _artistNameController.text;
      request.fields['artistDescription'] = _artistDescriptionController.text;
      request.fields['shippingFee']=_shippingFeeController.text;
      // Add product image
      if (_productImage != null) {
        final mimeTypeData = lookupMimeType(_productImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
        request.files.add(
          http.MultipartFile.fromBytes(
            'productImage',
            await _productImage!.readAsBytes(),
            filename: _productImage!.name,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
          ),
        );
      }

      // Add artist image
      if (_artistImage != null) {
        final mimeTypeData = lookupMimeType(_artistImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
        request.files.add(
          http.MultipartFile.fromBytes(
            'artistImage',
            await _artistImage!.readAsBytes(),
            filename: _artistImage!.name,
            contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
          ),
        );
      }

      final response = await request.send();

      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');
      if (response.statusCode == 201) {
        _productNameController.text='';
        _priceController.text='';
        _productDescriptionController.text='';
        _categoryController.text='';
        _mediumController.text='';
        _materialController.text='';
        _heightController.text='';
        _hmeasureController.text='';
        _widthController.text='';
        _wmeasureController.text='';
        _artistNameController.text='';
        _artistDescriptionController.text='';
        _shippingFeeController.text='';
        _productImage=null;
        _artistImage=null;
        
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Product Added")));
      } else {
        final errorMessage = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload Failed: $errorMessage")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("An error occurred: $e")));
    }
  }
  
  
  Future<void> selectProductImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _productImage = pickedFile;
      });
    }
  }
  Future<void> selectArtistImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _artistImage = pickedFile;
      });
    }
  }
  Widget buildImagePreview(XFile? image, String title) {
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
                  ? Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 40.sp,
                        color: Colors.grey.shade600,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network( // Display image from path
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
        title: Text('Admin Products'),
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
                  buildTextField('Product Name',
                      controller: _productNameController),
                  SizedBox(height: 20.h),
                  buildTextField('Price', controller: _priceController),
                  SizedBox(height: 20.h),
                  buildTextField('Product Description',
                      maxLines: 5, controller: _productDescriptionController),
                  SizedBox(height: 20.h),
                  CategoryDropdown(
                    controller: _categoryController,
                  ),
                  SizedBox(height: 20.h),
                  buildTextField('Material',
                      controller: _materialController),
                  SizedBox(height: 20.h),
                  MediumDropdown(
                    controller: _mediumController,
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                          child: buildTextField("Height",
                              controller: _heightController)),
                      SizedBox(width: 5.w),
                      Expanded(
                          child: SizeDropdown(
                        controller: _hmeasureController,
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: buildTextField("Width",
                              controller: _widthController)),
                      SizedBox(width: 5.w),
                      Expanded(
                          child: SizeDropdown(
                        controller: _wmeasureController,
                      )),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  buildTextField('Artist Name',
                      controller: _artistNameController),
                  SizedBox(height: 20.h),
                  buildTextField('Artist Description',
                      maxLines: 5, controller: _artistDescriptionController),
                  SizedBox(height: 20.h),
                  buildTextField('Shipping Fee',
                      controller: _shippingFeeController),
                  SizedBox(height: 30.h),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 15.h),
                      ),
                      onPressed: () {
                        addProduct();
                      },
                      child: const Text('Add product'),
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
          // Replace the existing right side Flexible widget with this:
          Flexible(
            flex: 2,
            child: Container(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
              padding: EdgeInsets.all(8.w), // Reduced padding
              child: SingleChildScrollView(
                // Add SingleChildScrollView here too
                padding: EdgeInsets.all(8.w), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: selectProductImage,
                      child: buildImagePreview(_productImage, 'Product Image Preview'),
                    ),
                    SizedBox(height: 20.h), // Reduced SizedBox height
                    GestureDetector(
                      onTap: selectArtistImage,
                      child: buildImagePreview(_artistImage, 'Artist Image Preview'),
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
  Widget buildTextField(String hint,
      {int maxLines = 1, required TextEditingController controller}) {
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
        style: TextStyle(
          color: Colors.black,
        ),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[600],
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
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
class CategoryDropdown extends StatefulWidget {
  final TextEditingController controller;
  CategoryDropdown({Key? key, required this.controller}) : super(key: key);
  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}
class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedCategory; // State variable to store selected category
  final List<String> categories = [
    "Paintings",
    "Photography",
    "Collage",
    "Abstract",
    "Sketches",
    "Digital Art",
    "Poster",
    "Sculpture"
  ]; // Category options
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: InputDecoration(
              hintText: "Select a Category",
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
                widget.controller.text = value ?? '';
              });
            },
          ),
        ),
        SizedBox(height: 16),
        // Display selected category
        Text(
          "Selected Category: ${selectedCategory ?? 'None'}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
class MediumDropdown extends StatefulWidget {
  final TextEditingController controller;
  MediumDropdown({Key? key, required this.controller}) : super(key: key);
  @override
  _MediumDropdownState createState() => _MediumDropdownState();
}
class _MediumDropdownState extends State<MediumDropdown> {
  String? selectedMedium;
  final List<String> mediums = [
    "Oil",
    "Acrylic",
    "Watercolor",
    "Pastel",
    "Ink",
    "Graphite",
    "Charcoal",
    "Digital",
    "Others"
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: DropdownButtonFormField<String>(
            value: selectedMedium,
            decoration: InputDecoration(
              hintText: "Select a Medium",
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
            items: mediums.map((medium) {
              return DropdownMenuItem(
                value: medium,
                child: Text(
                  medium,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedMedium = value;
                widget.controller.text = value ?? '';
              });
            },
          ),
        ),
        SizedBox(height: 16),
        // Display selected category
        Text(
          "Selected Medium: ${selectedMedium ?? 'None'}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
class SizeDropdown extends StatefulWidget {
  final TextEditingController controller;
  SizeDropdown({Key? key, required this.controller}) : super(key: key);
  @override
  _SizeDropdownState createState() => _SizeDropdownState();
}
class _SizeDropdownState extends State<SizeDropdown> {
  String? selectedSize;
  final List<String> sizes = ["cm", "inches"];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: DropdownButtonFormField<String>(
            value: selectedSize,
            decoration: InputDecoration(
              hintText: "Select a Size",
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
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
            items: sizes.map((size) {
              return DropdownMenuItem(
                value: size,
                child: Text(
                  size,
                  style: TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSize = value;
                widget.controller.text = value ?? '';
              });
            },
          ),
        ),
        SizedBox(height: 16),
        // Display selected category
        Text(
          "Selected Size: ${selectedSize ?? 'None'}",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
