import 'package:demo_kai_morning_210303/model/order_model.dart';
import 'package:demo_kai_morning_210303/network/order_network_func.dart';
import 'package:demo_kai_morning_210303/useful/search_engine.dart';
import 'package:demo_kai_morning_210303/widgets/my_progress_indicator.dart';
import 'package:demo_kai_morning_210303/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDoneList extends StatefulWidget {

  final DateTime selDay;
  final String selTime;

  OrderDoneList({this.selDay, this.selTime});

  @override
  _OrderDoneListState createState() => _OrderDoneListState();
}

class _OrderDoneListState extends State<OrderDoneList> {


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<OrderModel>>.value(
      value: orderNetwork.getOrdersDone(),
      child: Consumer<List<OrderModel>>(
        builder: (context, orders, _){
          if(orders == null){
            return MyProgressIndicator();
          }
          else if (orders.isEmpty){
            return Container();
          }
          else{
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index){
                if(SearchEngine.isSameDay(orders[index].orderDay, widget.selDay ) && widget.selTime == '종일' || widget.selTime == orders[index].time){
                  return OrderItem(
                    orderModel: orders[index],
                  );
                }
                else{
                  return Container();
                }
              },
            );
          }
        },
      ),
    );
  }
}
