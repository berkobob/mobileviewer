import 'package:flutter/material.dart';
import 'package:port_viewer/common/utils.dart';
import 'package:port_viewer/screens/stocks_screen.dart';

class PortfoliosScreen extends StatefulWidget {
  @override
  _PortfoliosScreenState createState() => _PortfoliosScreenState();
}

class _PortfoliosScreenState extends State<PortfoliosScreen> {
  Future _ports;

  @override
  void initState() {
    super.initState();
    _ports = getData('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Portfolios')),
        body: FutureBuilder(
          future: _ports,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i]['name']),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Stocks:${snapshot.data[i]['stocks']}'),
                            Text('Positions:${snapshot.data[i]['positions']}'),
                            Text('Open:${snapshot.data[i]['open']}'),
                          ],
                        ),
                        trailing: Text(
                            '\$${currency.format(snapshot.data[i]['proceeds'])}'),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StocksScreen(snapshot.data[i]['name']))),
                      );
                    })
                : Center(child: CircularProgressIndicator());
          },
        ));
  }
}
