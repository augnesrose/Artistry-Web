import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<String> statusList = ['Pending', 'Approved', 'Packed', 'Shipped', 'Cancelled'];
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final url = Uri.parse("http://localhost:3000/order/getAllOrders");
      final headers = {
        "Content-Type": "application/json"
      };

      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('orders')) {
          setState(() {
            orders = List<Map<String, dynamic>>.from(jsonResponse['orders']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "No orders found";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch orders. Status code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch orders: $e';
        isLoading = false;
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy - HH:mm').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchOrders,
          ),
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator())
        : errorMessage != null
          ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
          : orders.isEmpty
            ? Center(child: Text("No orders found"))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: _dataColumns(),
                    rows: _dataRows(),
                  ),
                ),
              ),
    );
  }

  List<DataColumn> _dataColumns() {
    return [
      DataColumn(label: Text('SI. No.', style: _textStyle())),
      DataColumn(label: Text('Order ID', style: _textStyle())),
      DataColumn(label: Text('Product Name', style: _textStyle())),
      DataColumn(label: Text('Customer Name', style: _textStyle())),
      DataColumn(label: Text('Price', style: _textStyle())),
      DataColumn(label: Text('Status', style: _textStyle())),
      DataColumn(label: Text('Payment Status', style: _textStyle())),
      DataColumn(label: Text('Cancellation Request', style: _textStyle())),
      DataColumn(label: Text('Actions', style: _textStyle())),
    ];
  }

  TextStyle _textStyle() {
    return TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  }

  Color _getColorStatus(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Approved':
        return Colors.blue;
      case 'Packed':
        return Colors.purple;
      case 'Shipped':
        return Colors.amber;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Color _getPaymentStatusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<DataRow> _dataRows() {
    List<DataRow> rows = [];
    
    for (int i = 0; i < orders.length; i++) {
      final order = orders[i];
      
   
      String productName = order['productId']?['name'] ?? 'Unknown Product';
      
     
      String customerName = order['userId']?['name'] ?? 'Unknown User';
      
      final paymentStatus = order['paymentDetails']?['paymentStatus'] ?? 'Pending';
      
      rows.add(_createDataRow(
        (i + 1).toString(),
        order['orderId'] ?? '',
        productName,
        customerName,
        '₹${order['amount']?.toString() ?? '0.00'}',
        order['status'] ?? 'Pending',
        paymentStatus,
        order,
      ));
    }
    
    return rows;
  }

  DataRow _createDataRow(
    String sNo, 
    String orderId, 
    String productName, 
    String customerName, 
    String price, 
    String initialStatus,
    String paymentStatus,
    Map<String, dynamic> orderData,
  ) {
    ValueNotifier<String> statusNotifier = ValueNotifier<String>(initialStatus);
    
    return DataRow(cells: [
      DataCell(Text(sNo, style: _textStyle())),
      DataCell(Text(orderId, style: _textStyle())),
      DataCell(Text(productName, style: _textStyle())),
      DataCell(Text(customerName, style: _textStyle())),
      DataCell(Text(price, style: _textStyle())),
      DataCell(ValueListenableBuilder<String>(
        valueListenable: statusNotifier,
        builder: (context, status, child) {
          return Text(status, 
            style: TextStyle(
              color: _getColorStatus(status), 
              fontSize: 15, 
              fontWeight: FontWeight.bold
            )
          );
        },
      )),
      DataCell(Text(
        paymentStatus,
        style: TextStyle(
          color: _getPaymentStatusColor(paymentStatus),
          fontSize: 15,
          fontWeight: FontWeight.bold
        ),
      )),
      DataCell(MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(Icons.request_page),
          color: Colors.orange,
          tooltip: "View Cancellation Requests",
          onPressed: () {
            
          },
        ),
      )),
      DataCell(MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(Icons.visibility),
          color: Colors.black,
          tooltip: "View Details",
          onPressed: () => _showOrderDetailsDialog(
            context,
            orderData,
            statusNotifier,
          ),
        ),
      )),
    ]);
  }

  void _showOrderDetailsDialog(
    BuildContext context, 
    Map<String, dynamic> order,
    ValueNotifier<String> statusNotifier,
  ) {
 
    String currentStatus = statusNotifier.value;
    
    
    String productName = order['productId']?['name'] ?? 'Unknown Product';
    String productCategory = order['productId']?['category'] ?? 'N/A';
    String productPrice = order['productId']?['price']?.toString() ?? 'N/A';
    
   
    String customerName = order['addressId']?['name'] ?? 'N/A';
    String customerEmail = order['userId']?['email'] ?? 'N/A';
    String customerPhone = order['addressId']?['phone'] ?? 'N/A';
    
    
    String orderDate = formatDate(order['createdAt']);
    
    String addressLine1 = order['addressId']?['houseName'] ?? 'N/A';
    String addressLine2 = '';
    
    if (order['addressId'] != null) {
      final addressDetails = order['addressId'];
      addressLine2 = [
        addressDetails['locality'],
        addressDetails['district'],
        addressDetails['state'],
        addressDetails['pinCode'],
      ].where((element) => element != null && element.isNotEmpty).join(', ');
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Order Details', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    _buildDetailRow('Order ID', order['orderId'] ?? ''),
                    _buildDetailRow('Order Date', orderDate),
                    
                    // Product details
                    _buildSectionTitle('Product Details'),
                    _buildDetailRow('Product Name', productName),
                    _buildDetailRow('Category', productCategory),
                    _buildDetailRow('Base Price', '₹$productPrice'),
                    _buildDetailRow('Total Price', '₹${order['amount']?.toString() ?? '0.00'}'),
                    
                    // Customer details
                    _buildSectionTitle('Customer Details'),
                    _buildDetailRow('Name', customerName),
                    _buildDetailRow('Email', customerEmail),
                    _buildDetailRow('Phone', customerPhone),
                    
                    // Address details
                    _buildSectionTitle('Shipping Address'),
                    _buildDetailRow('Address', addressLine1),
                    _buildDetailRow('', addressLine2),

                    // Payment details
                    _buildSectionTitle('Payment Details'),
                    _buildDetailRow('Payment Status', order['paymentDetails']?['paymentStatus'] ?? 'Unknown'),
                    _buildDetailRow('Razorpay Order ID', order['paymentDetails']?['razorpayOrderId'] ?? 'N/A'),
                    _buildDetailRow('Payment ID', order['paymentDetails']?['paymentId'] ?? 'N/A'),
                    
                    // Status Dropdown
                    SizedBox(height: 20),
                    _buildSectionTitle('Order Status'),
                    Row(
                      children: [
                        Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: currentStatus,
                          items: statusList.map((String status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(
                                status, 
                                style: TextStyle(color: _getColorStatus(status)),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              currentStatus = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Update', style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    // Call your update API here
                    updateOrderStatus(order['_id'], currentStatus).then((_) {
                      // Update the status in the table
                      statusNotifier.value = currentStatus;
                      Navigator.of(context).pop();
                    });
                  },
                ),
                TextButton(
                  child: Text('Close', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isNotEmpty 
              ? Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold))
              : SizedBox(),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final url = Uri.parse("http://localhost:3000/order/updateOrderStatus/$orderId");
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"status": newStatus})
      );
      
      if (response.statusCode == 200) {
        // Update the local order data
        final index = orders.indexWhere((order) => order['_id'] == orderId);
        if (index != -1 && mounted) {
          setState(() {
            orders[index]['status'] = newStatus;
          });
          
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order status updated successfully'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        print("Failed to update order status: ${response.statusCode}");
        
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update order status'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print("Error updating order status: $e");
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}