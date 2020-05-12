
import 'package:http/http.dart';

void main() async {
final response = await get('http://localhost:5000/api');
print(response.statusCode);
}