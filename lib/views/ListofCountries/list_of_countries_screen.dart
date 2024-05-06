import 'package:covidtracker/services/country_info_service.dart';
import 'package:covidtracker/views/CountryInfo/country_info.dart';
import 'package:covidtracker/views/Home/home.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListOfCountriesScreen extends StatefulWidget {
  const ListOfCountriesScreen({super.key});

  @override
  _ListOfCountriesScreenState createState() => _ListOfCountriesScreenState();
}

class _ListOfCountriesScreenState extends State<ListOfCountriesScreen> {
  final countryList = CountryInfoService().fetchCountries();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const Home();
                })),
            child: const Icon(Icons.arrow_back)),
        title: const Text("Country List"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: textController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        hintText: "Search Country Here....",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                color: Color(0xff3366CC), width: 2.00))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: countryList,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return ListView.builder(
                              itemCount: 8,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade700,
                                  highlightColor: Colors.grey.shade100,
                                  child: ListTile(
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      color: Colors.white,
                                    ),
                                    title: Container(
                                      width: 89,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                    subtitle: Container(
                                      width: 89,
                                      height: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                String name = snapshot.data![index]["country"];
                                if (textController.text.isEmpty) {
                                  return InkWell(
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CountryInfo(
                                        title: snapshot.data![index]["country"]
                                            .toString(),
                                        todayCases: snapshot.data![index]
                                                ["todayCases"]
                                            .toString(),
                                        todayDeaths: snapshot.data![index]
                                                ["todayDeaths"]
                                            .toString(),
                                        todayRecovered: snapshot.data![index]
                                                ["todayRecovered"]
                                            .toString(),
                                        cases: snapshot.data![index]["cases"]
                                            .toString(),
                                        recovered: snapshot.data![index]
                                                ["recovered"]
                                            .toString(),
                                        deaths: snapshot.data![index]["deaths"]
                                            .toString(),
                                        active: snapshot.data![index]["active"]
                                            .toString(),
                                        flag: snapshot.data![index]
                                                ['countryInfo']["flag"]
                                            .toString(),
                                      );
                                    })),
                                    child: ListTile(
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                        .data![index]
                                                    ["countryInfo"]["flag"]))),
                                      ),
                                      title: Text(
                                        snapshot.data![index]["country"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        snapshot.data![index]["cases"]
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  );
                                } else if (name
                                    .toLowerCase()
                                    .contains(textController.text)) {
                                  return InkWell(
                                    onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CountryInfo(
                                        title: snapshot.data![index]["country"]
                                            .toString(),
                                        todayCases: snapshot.data![index]
                                                ["todayCases"]
                                            .toString(),
                                        todayDeaths: snapshot.data![index]
                                                ["todayDeaths"]
                                            .toString(),
                                        todayRecovered: snapshot.data![index]
                                                ["todayRecovered"]
                                            .toString(),
                                        cases: snapshot.data![index]["cases"]
                                            .toString(),
                                        recovered: snapshot.data![index]
                                                ["recovered"]
                                            .toString(),
                                        deaths: snapshot.data![index]["deaths"]
                                            .toString(),
                                        active: snapshot.data![index]["active"]
                                            .toString(),
                                        flag: snapshot.data![index]
                                                ['countryInfo']["flag"]
                                            .toString(),
                                      );
                                    })),
                                    child: ListTile(
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(snapshot
                                                        .data![index]
                                                    ["countryInfo"]["flag"]))),
                                      ),
                                      title: Text(
                                        snapshot.data![index]["country"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        snapshot.data![index]["cases"]
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              });
                        }
                      }),
                ],
              ),
            )),
      ),
    );
  }
}
