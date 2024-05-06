import 'dart:convert';

import 'package:covidtracker/models/dataModel.dart';
import 'package:covidtracker/utils/apiLinks.dart';
import 'package:http/http.dart' as http;

class AllData {
  Future<DataModel> fetchAllData() async {
    final response = await http.get(Uri.parse(ApiLinks.allData));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return DataModel.fromJson(data);
    } else {
      throw Exception("Error");
    }
  }
}
