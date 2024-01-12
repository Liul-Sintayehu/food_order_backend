// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order/component/order.dart';
import 'package:order/pages/accepted_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  List orders = [];
  List acceptedOrders = [];
  List file = [];

  @override
  void initState() {
    getOrders();

    // TODO: implement initState
    super.initState();
  }

  // Future myFuture() async {
  //   return Future.delayed(Duration(seconds: 5), () {
  //     setState(() {
  //       isLoading = false;
  //       orders = ['data0', 'data1', 'data2'];
  //     });
  //   });
  // }
  getOrders() async {
    file = [];
    // 'https://restorant-backend-i0ix.onrender.com/';
    // http://10.0.2.2:3003
    final uri =
        Uri.parse('https://restorant-backend-i0ix.onrender.com/getorders');
    var response = await http.get(uri);
    var responseData = json.decode(response.body);
    for (var ord in responseData) {
      Order order = Order(
          title: ord['title'],
          number: ord['amount'],
          price: ord['price'],
          table: ord['table']);
      file.add(order);
    }
    setState(() {
      isLoading = false;
      orders = file;
    });
    print(orders);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isLoading = true;
        });
        getOrders();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Page'),
        ),
        body: isLoading
            ? Container(
                margin: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade200,
                        highlightColor: Colors.white,
                        child: Container(
                          height: size.height * 0.3,
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 20),
                          color: Colors.red,
                          child: Text('data'),
                        ),
                      );
                    }),
              )
            : Container(
                margin: EdgeInsets.all(16),
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: size.height * 0.3,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Card(
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('title: ' + orders[index].title),
                                Text('no of order : ' + orders[index].number),
                                Text('price: ' + orders[index].price),
                                Text('table no.: ' + orders[index].table),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green[300],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          acceptedOrders.add(orders[index]);
                                          orders.remove(orders[index]);
                                        });
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[300],
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          orders.remove(orders[index]);
                                        });
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AcceptedPage(orders: acceptedOrders)));
          },
          child: Icon(Icons.food_bank_sharp),
        ),
      ),
    );
  }
}
