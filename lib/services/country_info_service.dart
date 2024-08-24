import 'dart:convert';
import 'package:covidtracker/utils/api_links.dart';
import 'package:http/http.dart' as http;

class CountryInfoService {
  Future<List<dynamic>> fetchCountries() async {
    final response = await http.get(Uri.parse(ApiLinks.countryList));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Error");
    }
  }
}
