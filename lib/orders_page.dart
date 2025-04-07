import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
 final List<String> statusList = ['Pending', 'Delivered', 'Cancelled'];
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
    try{

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
    }
    catch(e){
      setState(() {
        errorMessage = 'Failed to fetch orders: $e';
        isLoading = false;
      });
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
      DataColumn(label: Text('Cancellation Request', style: _textStyle())),
      DataColumn(label: Text('Actions', style: _textStyle())),
    ];
  }

  TextStyle _textStyle() {
    return TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
  }

  Color _getColorStatus(String status) {
    if (status == 'Pending') {
      return Colors.orange;
    } else if (status == 'Delivered') {
      return Colors.green;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  List<DataRow> _dataRows() {
    List<DataRow> rows = [];
    
    for (int i = 0; i < orders.length; i++) {
      final order = orders[i];
      rows.add(_createDataRow(
        (i + 1).toString(),
        order['_id'] ?? '',
        order['productDetails']?['name'] ?? 'Unknown Product',
        order['customerDetails']?['name'] ?? 'Unknown Customer',
        '₹${order['amount']?.toString() ?? '0.00'}',
        order['status'] ?? 'Pending',
        order['cancellationRequested'] == true,
        order['customerDetails'] ?? {},
        order['orderDate'] ?? '',
        order['expectedDeliveryDate'] ?? '',
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
    bool hasCancellationRequest,
    Map<String, dynamic> customerDetails,
    String orderDate,
    String deliveryDate,
  ) {
    ValueNotifier<String> statusNotifier = ValueNotifier<String>(initialStatus);
    ValueNotifier<bool> cancellationRequestNotifier = ValueNotifier<bool>(hasCancellationRequest);
    
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
      DataCell(ValueListenableBuilder<bool>(
        valueListenable: cancellationRequestNotifier,
        builder: (context, hasRequest, child) {
          return Text(
            hasRequest ? 'Requested' : 'None',
            style: TextStyle(
              color: hasRequest ? Colors.red : Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          );
        },
      )),
      DataCell(MouseRegion(
        cursor: SystemMouseCursors.click,
        child: IconButton(
          icon: Icon(Icons.visibility),
          color: Colors.black,
          tooltip: "View Details",
          onPressed: () => _showOrderDetailsDialog(
            context, 
            orderId, 
            productName, 
            customerName,
            price,
            customerDetails['customerId'] ?? '',
            customerDetails['address'] ?? '',
            customerDetails['email'] ?? '',
            customerDetails['phone'] ?? '',
            orderDate,
            deliveryDate,
            statusNotifier,
            cancellationRequestNotifier
          ),
        ),
      )),
    ]);
  }

  void _showOrderDetailsDialog(
    BuildContext context, 
    String orderId, 
    String productName, 
    String customerName, 
    String price,
    String customerId,
    String address,
    String email,
    String phone,
    String orderDate,
    String deliveryDate,
    ValueNotifier<String> statusNotifier,
    ValueNotifier<bool> cancellationRequestNotifier
  ) {
    // Current status value
    String currentStatus = statusNotifier.value;
    bool hasCancellationRequest = cancellationRequestNotifier.value;

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
                    _buildDetailRow('Order ID', orderId),
                    _buildDetailRow('Product Name', productName),
                    _buildDetailRow('Customer Name', customerName),
                    _buildDetailRow('Price', price),
                    _buildDetailRow('Order Date', orderDate),
                    _buildDetailRow('Delivery Date', deliveryDate),
                    _buildDetailRow('Customer ID', customerId),
                    _buildDetailRow('Address', address),
                    _buildDetailRow('Email', email),
                    _buildDetailRow('Phone', phone),

                    // Cancellation request section
                    Row(
                      children: [
                        Text('Cancellation Request:',
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        SizedBox(width: 10),
                        Text(
                          hasCancellationRequest ? 'Requested' : 'None',
                          style: TextStyle(
                            color: hasCancellationRequest ? Colors.red : Colors.grey
                          ),
                        ),
                        if (hasCancellationRequest) ...[
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text('Approve'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[100],
                              foregroundColor: Colors.red[900],
                            ),
                            onPressed: () {
                              
                            },
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text('Reject'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              
                            },
                          ),
                        ]
                      ],
                    ),
                    
                    // Status Dropdown
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
                    // Update order status through API
                    // updateOrderStatus(orderId, currentStatus).then((_) {
                    //   // Update the status in the table
                    //   statusNotifier.value = currentStatus;
                    //   cancellationRequestNotifier.value = hasCancellationRequest;
                    //   Navigator.of(context).pop();
                    // });
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}