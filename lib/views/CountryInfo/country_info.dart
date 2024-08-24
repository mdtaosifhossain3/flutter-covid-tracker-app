import 'package:covidtracker/constants/colors.dart';
import 'package:covidtracker/views/ListofCountries/list_of_countries_screen.dart';
import 'package:covidtracker/views/globalWidgets/row.dart';
import 'package:flutter/material.dart';

class CountryInfo extends StatefulWidget {
  final String? title;
  final String? flag;
  final String? cases;
  final String? deaths;
  final String? recovered;
  final String? active;
  final String? todayCases;
  final String? todayDeaths;
  final String? todayRecovered;
  const CountryInfo(
      {super.key,
      this.active,
      this.cases,
      this.deaths,
      this.flag,
      this.recovered,
      this.title,
      this.todayCases,
      this.todayDeaths,
      this.todayRecovered});

  @override
  _CountryInfoState createState() => _CountryInfoState();
}

class _CountryInfoState extends State<CountryInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ListOfCountriesScreen();
                })),
            child: const Icon(Icons.arrow_back)),
        title: Text(widget.title!),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(top: 50.00, left: 18, right: 18),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: 10,
                        right: 10,
                        bottom: 10),
                    decoration: BoxDecoration(
                        color: AppColors.midWhiteColor,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
                        ),
                        ReusableRow(
                          title: "Total",
                          value: widget.cases!.toString(),
                        ),
                        ReusableRow(
                          title: "Deaths",
                          value: widget.deaths!.toString(),
                        ),
                        ReusableRow(
                          title: "Recovered",
                          value: widget.recovered!.toString(),
                        ),
                        ReusableRow(
                          title: "Active",
                          value: widget.active!.toString(),
                        ),
                        ReusableRow(
                          title: "Today Cases",
                          value: widget.todayCases!.toString(),
                        ),
                        ReusableRow(
                          title: "Today Deaths",
                          value: widget.todayDeaths!.toString(),
                        ),
                        ReusableRow(
                          title: "Today Recovered",
                          value: widget.todayRecovered!.toString(),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.flag!),
                  )
                ],
              ),
            ]),
      ),
    );
  }
}
