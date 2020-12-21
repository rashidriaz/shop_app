import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:shop_app/providers/order_provider.dart';

class OrderScreenItem extends StatefulWidget {
  final OrderItem item;

  const OrderScreenItem(this.item);


  @override
  State createState() {
    return _OrderScreenItemState(item);
  }
}

class _OrderScreenItemState extends State<OrderScreenItem> {
  final OrderItem item;
  bool _expanded = false;

  _OrderScreenItemState(this.item);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded? min(widget.item.products.length * 20.0 + 110, 200): 95,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${item.amount.round()}"),
            subtitle: Text(
              DateFormat('dd/MM/yyyy').format(item.time),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),

              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded? min(widget.item.products.length * 20.0 + 10, 100) : 0,
              child: ListView.builder(
                  itemCount: item.products.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.products[index].title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${item.products[index].quantity} x \$${item.products[index].pricePerProduct.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )),
            )
        ],
      ),
    );
  }
}
