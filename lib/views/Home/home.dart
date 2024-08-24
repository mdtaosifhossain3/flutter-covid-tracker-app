import 'package:covidtracker/constants/colors.dart';
import 'package:covidtracker/models/data_model.dart';
import 'package:covidtracker/services/all_data_service.dart';

import 'package:covidtracker/views/ListofCountries/list_of_countries_screen.dart';
import 'package:covidtracker/views/globalWidgets/row.dart';

import 'package:flutter/material.dart';

import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final alldata = AllData().fetchAllData();
  final colorList = <Color>[
    const Color(0xffff9900),
    const Color(0xff3366CC),
    const Color(0xffde5246)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Covid Tracker",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.jadeColor),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: alldata,
                  builder: (context, AsyncSnapshot<DataModel> snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          PieChart(
                            dataMap: {
                              "Total": double.parse(
                                  snapshot.data!.cases!.toString()),
                              "Recovered": double.parse(
                                  snapshot.data!.recovered!.toString()),
                              "Deaths": double.parse(
                                  snapshot.data!.deaths!.toString())
                            },
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true),
                            colorList: colorList,
                            animationDuration:
                                const Duration(milliseconds: 1300),
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left),
                            chartRadius: MediaQuery.of(context).size.width / 3,
                          ),
                          Container(
                              margin: const EdgeInsets.all(18.00),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffe4e4e4),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                children: [
                                  ReusableRow(
                                    title: "Total",
                                    value: snapshot.data!.cases!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Deaths",
                                    value: snapshot.data!.deaths!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Recovered",
                                    value: snapshot.data!.recovered!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Active",
                                    value: snapshot.data!.active!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Critical",
                                    value: snapshot.data!.critical!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Today Cases",
                                    value:
                                        snapshot.data!.todayCases!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Today Deaths",
                                    value:
                                        snapshot.data!.todayDeaths!.toString(),
                                  ),
                                  ReusableRow(
                                    title: "Today Recovered",
                                    value: snapshot.data!.todayRecovered!
                                        .toString(),
                                  ),
                                ],
                              )),
                          Container(
                              margin: const EdgeInsets.all(15),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColors.jadeColor,
                                  borderRadius: BorderRadius.circular(4)),
                              child: InkWell(
                                onTap: () => Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const ListOfCountriesScreen();
                                })),
                                child: const Center(
                                    child: Text(
                                  "Track Countries",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                              ))
                        ],
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
