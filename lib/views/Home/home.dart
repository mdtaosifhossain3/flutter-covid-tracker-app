import 'package:covidtracker/constants/colors.dart';
import 'package:covidtracker/models/data_model.dart';
import 'package:covidtracker/services/all_data_service.dart';
import 'package:covidtracker/views/ListofCountries/list_of_countries_screen.dart';
import 'package:covidtracker/views/globalWidgets/modern_reusable_row.dart';
import 'package:covidtracker/views/globalWidgets/row.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final alldata = AllData().fetchAllData();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final colorList = <Color>[
    const Color(0xffFF6B6B), // Modern red
    const Color(0xff4ECDC4), // Teal
    const Color(0xffFFE66D), // Yellow
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff667eea),
                      Color(0xff764ba2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "COVID-19",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Global Statistics",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: FutureBuilder(
                  future: alldata,
                  builder: (context, AsyncSnapshot<DataModel> snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xff667eea)),
                                strokeWidth: 3,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Loading global data...",
                                style: TextStyle(
                                  color: Color(0xff64748B),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Statistics Overview Cards
                            _buildOverviewCards(snapshot.data!),

                            const SizedBox(height: 24),

                            // Pie Chart Section
                            _buildChartSection(snapshot.data!),

                            const SizedBox(height: 24),

                            // Detailed Statistics
                            _buildDetailedStats(snapshot.data!),

                            const SizedBox(height: 24),

                            // Action Button
                            _buildActionButton(),

                            const SizedBox(height: 20),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(DataModel data) {
    return Row(
      children: [
        Expanded(
          child: _buildOverviewCard(
            "Total Cases",
            data.cases.toString(),
            const Color(0xffFF6B6B),
            Icons.coronavirus_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            "Recovered",
            data.recovered.toString(),
            const Color(0xff4ECDC4),
            Icons.health_and_safety_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildOverviewCard(
            "Deaths",
            data.deaths.toString(),
            const Color(0xffFFE66D),
            Icons.warning_amber_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
      String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff64748B),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(DataModel data) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Global Distribution",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: PieChart(
              dataMap: {
                "Total": double.parse(data.cases!.toString()),
                "Recovered": double.parse(data.recovered!.toString()),
                "Deaths": double.parse(data.deaths!.toString()),
              },
              chartValuesOptions: const ChartValuesOptions(
                showChartValuesInPercentage: true,
                showChartValueBackground: true,
                showChartValues: true,
                chartValueStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black38,
                  fontSize: 12,
                ),
              ),
              colorList: colorList,
              animationDuration: const Duration(milliseconds: 1500),
              legendOptions: const LegendOptions(
                showLegendsInRow: false,
                //legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xff1E293B),
                ),
              ),
              chartRadius: MediaQuery.of(context).size.width / 2.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStats(DataModel data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Detailed Statistics",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff1E293B),
            ),
          ),
          const SizedBox(height: 16),
          ModernReusableRow(
            title: "Active Cases",
            value: data.active!.toString(),
            icon: Icons.person_outline,
            color: const Color(0xffF59E0B),
          ),
          ModernReusableRow(
            title: "Critical Cases",
            value: data.critical!.toString(),
            icon: Icons.local_hospital_outlined,
            color: const Color(0xffEF4444),
          ),
          ModernReusableRow(
            title: "Today's Cases",
            value: data.todayCases!.toString(),
            icon: Icons.trending_up_outlined,
            color: const Color(0xff8B5CF6),
          ),
          ModernReusableRow(
            title: "Today's Deaths",
            value: data.todayDeaths!.toString(),
            icon: Icons.trending_down_outlined,
            color: const Color(0xff6B7280),
          ),
          ModernReusableRow(
            title: "Today's Recovered",
            value: data.todayRecovered!.toString(),
            icon: Icons.favorite_outline,
            color: const Color(0xff10B981),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xff667eea),
            Color(0xff764ba2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff667eea).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ListOfCountriesScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.public,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Explore Countries",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatNumber(String number) {
    final num = int.tryParse(number) ?? 0;
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return number;
  }
}
