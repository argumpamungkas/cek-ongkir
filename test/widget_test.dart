import 'dart:convert';

import 'package:http/http.dart' as http;

void main() async {
  var url = "https://api.rajaongkir.com/starter/province";
  var apiKey = "fe3500c2f7227acd3e8bb373a8d7d8a3";
  var response = await http.get(Uri.parse(url), headers: {
    "key": apiKey,
  });

  var data = jsonDecode(response.body)["rajaongkir"]["results"];

  print(data);
}
