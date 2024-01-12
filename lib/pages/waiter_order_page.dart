import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order/component/waiterorder.dart';

class WaiterOrder extends StatefulWidget {
  WaiterOrder({super.key});

  @override
  State<WaiterOrder> createState() => _WaiterOrderState();
}

class _WaiterOrderState extends State<WaiterOrder> {
  @override
  void initState() {
    getWaiterOrders();
    // TODO: implement initState
    super.initState();
  }

  List waiterorders = [];

  getWaiterOrders() async {
    var file = [];
    // 'https://restorant-backend-i0ix.onrender.com/';
    // http://10.0.2.2:3003
    final uri =
        Uri.parse('https://restorant-backend-i0ix.onrender.com/getwaiterorder');
    var response = await http.get(uri);
    var responseData = json.decode(response.body);
    for (var ord in responseData) {
      WaiterOrderModel order =
          WaiterOrderModel(table: ord['table'], reason: ord['reason']);
      file.add(order);
    }
    setState(() {
      waiterorders = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        getWaiterOrders();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          margin: EdgeInsets.all(16),
          child: ListView.builder(
              itemCount: waiterorders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Column(
                        children: [
                          Text('table no. : ' + waiterorders[index].table),
                          Text('reason : ' + waiterorders[index].reason),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[300],
                            ),
                            onPressed: () async {
                              final uri = Uri.parse(
                                  'https://restorant-backend-i0ix.onrender.com/deletewaiterorder');
                              var response = await http.post(uri, body: {
                                "table": waiterorders[index].table,
                                "reason": waiterorders[index].reason
                              });

                              setState(() {
                                waiterorders.remove(waiterorders[index]);
                              });
                            },
                            child: Text(
                              'Completed',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
