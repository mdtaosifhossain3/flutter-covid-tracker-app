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

class _CountryInfoState extends State<CountryInfo>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> statCards = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
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
    final Color mainColor1 = const Color(0xff667eea);
    final Color mainColor2 = const Color(0xff764ba2);
    final Color cardColor = Colors.white;
    final Color textColor = const Color(0xff1E293B);
    final Color subTextColor = const Color(0xff64748B);
    final Color borderColor = Colors.black.withOpacity(0.05);
    final double flagRadius = 44;

    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Gradient App Bar with flag and country name
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [mainColor1, mainColor2],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 16),
                        CircleAvatar(
                          radius: flagRadius,
                          backgroundImage: NetworkImage(widget.flag ?? ''),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.title ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
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
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Stat Cards Row
                      Row(
                        children: [
                          _buildStatCard(
                            title: "Cases",
                            value: widget.cases ?? '-',
                            color: const Color(0xffFF6B6B),
                            icon: Icons.coronavirus_outlined,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            title: "Recovered",
                            value: widget.recovered ?? '-',
                            color: const Color(0xff4ECDC4),
                            icon: Icons.health_and_safety_outlined,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            title: "Deaths",
                            value: widget.deaths ?? '-',
                            color: const Color(0xffFFE66D),
                            icon: Icons.warning_amber_outlined,
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Details Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: borderColor,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's & Active Stats",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff1E293B),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow("Active Cases", widget.active,
                                Icons.person_outline, const Color(0xffF59E0B)),
                            _buildDetailRow(
                                "Today's Cases",
                                widget.todayCases,
                                Icons.trending_up_outlined,
                                const Color(0xff8B5CF6)),
                            _buildDetailRow(
                                "Today's Deaths",
                                widget.todayDeaths,
                                Icons.trending_down_outlined,
                                const Color(0xff6B7280)),
                            _buildDetailRow(
                                "Today's Recovered",
                                widget.todayRecovered,
                                Icons.favorite_outline,
                                const Color(0xff10B981),
                                isLast: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
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
      ),
    );
  }

  Widget _buildDetailRow(
      String title, String? value, IconData icon, Color color,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xff1E293B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            _formatNumber(value ?? '-'),
            style: TextStyle(
              fontSize: 15,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(String? number) {
    final numValue = int.tryParse(number ?? '') ?? 0;
    if (numValue >= 1000000) {
      return '${(numValue / 1000000).toStringAsFixed(1)}M';
    } else if (numValue >= 1000) {
      return '${(numValue / 1000).toStringAsFixed(1)}K';
    }
    return number ?? '-';
  }
}
