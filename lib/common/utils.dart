 import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

final currency = NumberFormat("#,##0", 'en-UK');

Future<List<dynamic>> getData(String endpoint) async {
  // final url = Uri.http('localhost:5000', '/api$endpoint');
  final url = Uri.http('lever.family', '/api$endpoint');
  final response = await get(url);
  return json.decode(response.body) as List<dynamic>;
}