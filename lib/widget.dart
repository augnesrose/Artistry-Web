import 'package:flutter/material.dart';

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