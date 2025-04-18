import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:artistry_admin_web/product_page.dart';

class  AdminProducts extends StatefulWidget {
  const AdminProducts({super.key});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  List<dynamic> products =[];
  bool isLoading = true;
  Timer? _refreshTimer;
  final int refreshInterval = 20;

  @override

   void initState(){
    super.initState();
    fetchProducts();

    _refreshTimer = Timer.periodic(Duration(seconds: refreshInterval), (timer) {
      fetchProducts();
    });
  }

  @override
  void dispose(){
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchProducts() async{
    try{
      var url= Uri.parse("http://localhost:3000/admin/getProducts");
      var response = await http.get(url);

      if(response.statusCode==201){
      //  print ('response body : ${response.body}');
        setState(() {
          products = json.decode(response.body);
          isLoading=false;
         
          
        });
      }
      else{
        throw Exception('Failed to load products');
      }
    }
    catch(e){
      print('Error fetching products:$e');
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Admin Products'),
        actions:[
          IconButton(
            onPressed: (){
              setState(() {
                isLoading = true;
              });
              fetchProducts();
            }, 
            icon: Icon(Icons.refresh),
            ),
        ]
      ),
      body:isLoading
      ?Center(child:CircularProgressIndicator()):
      SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:4,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.70,
              ),
              itemCount: products.length,
              itemBuilder:(context, index){
                var product = products[index];
                bool isSoldOut= product['quantity'] != null && product['quantity']==0;
                return Stack(
                  children: [
                    Container(
                      decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color:Colors.white,
                        border:Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0,2),
                            ),
                          ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child:Column(
                          children:[
                            Expanded(
                              flex:5,
                                 child: Container(
                                    decoration: BoxDecoration(
                                      border:Border(
                                        bottom: BorderSide(
                                          color:Colors.grey.withOpacity(0.2),
                                          width: 1
                                        )
                                      )
                                    ),
                                    child: Image.network(
                                      "http://localhost:3000/uploads/${product['productImage']}", 
                                      fit:BoxFit.cover,
                                      height: 100.h,
                                      width: double.infinity,
                                       errorBuilder: (context, error, stackTrace) => 
                                      Icon(Icons.image_not_supported),
                                      ),
                                    ),    
                              ),
                              Padding(
                                padding:EdgeInsets.all(8),
                                child: Column(
                                  children:[
                                    Text(
                                      product['name'],
                                      style:TextStyle(
                                        fontSize: 5.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.h,),
                                  Text(
                                    '\u20B9${product['price']}',
                                    style: TextStyle(
                                      fontSize: 5.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isSoldOut ?Colors.black: Colors.grey[800],
                                    ),
                                  )
                                  ]
                                ),
                                ),
                              TextButton(
                                onPressed: isSoldOut ? null :() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(product['_id']),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Select',
                                  style:TextStyle(
                                    color: isSoldOut ? Colors.grey: const Color.fromARGB(255, 1, 171, 232),
                                     fontWeight: FontWeight.bold,
                                ) ,
                              ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    if(isSoldOut)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                            child: Text(
                              'Sold Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 6.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
          ),
        ),
      ),
    );
  }
}

      
    