import 'dart:async';

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';


import 'package:json_annotation/json_annotation.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: MyHomePage(title: 'Web Sockets Example'),
    );
  }
}



class MyHomePage extends StatefulWidget {

  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// class Stock {
//   final DateTime time;
//   final int stockValue;
//
//   Stock(this.time, this.stockValue);
// }


class _MyHomePageState extends State<MyHomePage> {

  String objText ="";
  String x2 = "";
  StreamController<String> channel = StreamController<String>();
  String _stream ="";
  Stream? _stream1;
  Stream? _stream2;
  dynamic price;
    // Listen for all incoming data
    // channel.stream.listen(
    //       (data) {
    //         print(data);
    //           _stream = data;
    //
    //     //return _stream;
    //   },
    //   onError: (error) => print(error),
    // );

  @override
  void initState(){

    // _series = [
    //   charts.Series(
    //       id: "Stock",
    //       domainFn: (Stock stockValues, _) => stockValues.time,
    //       measureFn: (Stock stockValues, _) => stockValues.stockValue,
    //       data: _data
    //   )
    // ];
    //
    // _textValue = formatDatetime(_data[0].time.toString())+' : '+_data[0].stockValue.toString();
    final channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://ws.twelvedata.com/v1/quotes/price?apikey=dd5b9e704aae4593abe6346b12e4291d'),
    );
    print("Hello");
    channel.sink.add(
      jsonEncode(
          {
            "action": "subscribe",
            "params": {
              "symbols": "BTC/USD"
            }
          }
      ),
    );

    channel.stream.listen((event) {
      Map<String, dynamic> map = json.decode(event);
      print(map["event"]);
      var data = map["event"];
      if(data == "subscribe-status")
      {

      }
      else
      {
        setState(() {
          price = map["price"];
        });
        print(price);
      }
      // List<dynamic> data = map["event"];
      // print(data[0]["event"]);
      //

    });




    super.initState();
    if(price != "")
      {
        _stream1 = price;
      }



  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body:

        Container(
          child:
          Column(
            children: [
              price == null?
              Card(
                child: CircularProgressIndicator(),
              ):Text('${price}'),
              /*StreamBuilder(stream: _stream1, builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(!snapshot.hasData)
                  {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                else if(snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  print("connected");
                  return Center(
                    child: Text(
                      '${snapshot.data!}',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return Container();
              },),*/

            ],
          ),
        ),
        // SingleChildScrollView(
        //
        //   padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //         margin: EdgeInsets.symmetric(vertical: 8),
        //         child: Text(_textValue, style: TextStyle(
        //             fontSize: 20,
        //             fontWeight: FontWeight.bold
        //         )),
        //       ),
        //       Container(
        //         margin: EdgeInsets.symmetric(vertical: 8),
        //         child: SizedBox(
        //           height: 400,
        //           child: charts.TimeSeriesChart(
        //             _series,
        //             dateTimeFactory: charts.LocalDateTimeFactory(),
        //             behaviors: [
        //               charts.LinePointHighlighter(
        //                 showHorizontalFollowLine: charts.LinePointHighlighterFollowLineType.none,
        //                 showVerticalFollowLine: charts.LinePointHighlighterFollowLineType.nearest,
        //               ),
        //               charts.SelectNearest(eventTrigger: charts.SelectionTrigger.tapAndDrag),
        //             ],
        //             selectionModels: [
        //               charts.SelectionModelConfig(
        //                   changedListener: (charts.SelectionModel model) {
        //                     if(model.hasDatumSelection) {
        //                       setState(() {
        //                         _textValue = formatDatetime(model.selectedSeries[0].domainFn(model.selectedDatum[0].index).toString())+' : '+model.selectedSeries[0].measureFn(model.selectedDatum[0].index).toString();
        //                       });
        //                     }
        //                   }
        //               )
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ));
    );
  }
}
