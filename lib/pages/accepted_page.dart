// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AcceptedPage extends StatefulWidget {
  final List orders;
  const AcceptedPage({super.key, required this.orders});

  @override
  State<AcceptedPage> createState() => _AcceptedPageState();
}

class _AcceptedPageState extends State<AcceptedPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: widget.orders.length,
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
                        Text('title: ' + widget.orders[index].title),
                        Text('no of order : ' + widget.orders[index].number),
                        Text('price: ' + widget.orders[index].price),
                        Text('table no.: ' + widget.orders[index].table),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[300],
                          ),
                          onPressed: () async {
                            final uri = Uri.parse(
                                'https://restorant-backend-i0ix.onrender.com/deleteorder');
                            var response = await http.post(uri, body: {
                              "title": widget.orders[index].title,
                              "table": widget.orders[index].table
                            });
                            setState(() {
                              widget.orders.remove(widget.orders[index]);
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
              ),
            );
          },
        ),
      ),
    );
  }
}
