import 'package:flutter/material.dart';
import 'package:port_viewer/common/utils.dart';
import 'package:port_viewer/screens/positions_screen.dart';

class StocksScreen extends StatefulWidget {
  final String port;

  StocksScreen(this.port);

  @override
  _StocksScreenState createState() => _StocksScreenState();
}

class _StocksScreenState extends State<StocksScreen> {
  Future<List<dynamic>> _stocks;

  @override
  void initState() {
    super.initState();
    _stocks = getData('/port/${widget.port}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.port)),
      body: FutureBuilder(
          future: _stocks,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Text('${snapshot.data[i]['stock']}'),
                              ),
                              Flexible(
                                flex: 10,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Open: ${currency.format(snapshot.data[i]['risk'])}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                fit: FlexFit.tight,
                                child: Text(
                                  ' : ${snapshot.data[i]['open']}',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Flexible(
                                flex: 10,
                                fit: FlexFit.tight,
                                child: Text(
                                  'Closed: ${currency.format(snapshot.data[i]['proceeds'])} : ',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                fit: FlexFit.tight,
                                child: Text(
                                  '${currency.format(snapshot.data[i]['closed'])}',
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PositionsScreen(
                                      snapshot.data[i]['port'],
                                      snapshot.data[i]['stock']))),
                      );
                    },
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
