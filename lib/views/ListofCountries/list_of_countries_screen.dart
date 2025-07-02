import 'package:covidtracker/constants/colors.dart';
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

class _ListOfCountriesScreenState extends State<ListOfCountriesScreen>
    with TickerProviderStateMixin {
  final countryList = CountryInfoService().fetchCountries();
  final textController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _sortBy = 'name'; // name, cases, deaths, recovered
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.sort, color: Colors.white),
                  onPressed: _showSortOptions,
                ),
              ),
            ],
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
                          "Countries",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "COVID-19 Statistics by Country",
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

          // Search and Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Enhanced Search Bar
                      _buildSearchBar(),

                      const SizedBox(height: 20),

                      // Countries List
                      _buildCountriesList(),
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

  Widget _buildSearchBar() {
    return Container(
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
      child: TextFormField(
        controller: textController,
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: "Search countries...",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search,
              color: Colors.grey[400],
              size: 24,
            ),
          ),
          suffixIcon: textController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[400]),
                  onPressed: () {
                    textController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xff667eea), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCountriesList() {
    return FutureBuilder(
      future: countryList,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildLoadingShimmer();
        } else {
          final filteredData = _getFilteredAndSortedData(snapshot.data!);

          if (filteredData.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return _buildCountryCard(filteredData[index], index);
            },
          );
        }
      },
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            "No countries found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Try adjusting your search terms",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(Map<String, dynamic> country, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 100)),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _navigateToCountryInfo(country),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Flag
                        Hero(
                          tag: 'flag_${country["country"]}',
                          child: Container(
                            width: 60,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  country["countryInfo"]["flag"] ?? '',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Country Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country["country"] ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _buildStatChip(
                                    "Cases",
                                    _formatNumber(country["cases"].toString()),
                                    const Color(0xffFF6B6B),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatChip(
                                    "Deaths",
                                    _formatNumber(country["deaths"].toString()),
                                    const Color(0xffFFE66D),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Arrow
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCountryInfo(Map<String, dynamic> country) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CountryInfo(
          title: country["country"].toString(),
          todayCases: country["todayCases"].toString(),
          todayDeaths: country["todayDeaths"].toString(),
          todayRecovered: country["todayRecovered"].toString(),
          cases: country["cases"].toString(),
          recovered: country["recovered"].toString(),
          deaths: country["deaths"].toString(),
          active: country["active"].toString(),
          flag: country['countryInfo']["flag"].toString(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Sort by",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildSortOption("Country Name", "name", Icons.sort_by_alpha),
              _buildSortOption("Total Cases", "cases", Icons.coronavirus),
              _buildSortOption("Deaths", "deaths", Icons.warning),
              _buildSortOption(
                  "Recovered", "recovered", Icons.health_and_safety),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, String value, IconData icon) {
    final isSelected = _sortBy == value;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xff667eea) : Colors.grey[600],
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? const Color(0xff667eea) : Colors.black,
        ),
      ),
      trailing: isSelected
          ? Icon(
              _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
              color: const Color(0xff667eea),
            )
          : null,
      onTap: () {
        setState(() {
          if (_sortBy == value) {
            _isAscending = !_isAscending;
          } else {
            _sortBy = value;
            _isAscending = true;
          }
        });
        Navigator.pop(context);
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredAndSortedData(List<dynamic> data) {
    List<Map<String, dynamic>> filteredData = data.cast<Map<String, dynamic>>();

    // Filter by search text
    if (textController.text.isNotEmpty) {
      filteredData = filteredData.where((country) {
        return country["country"]
            .toString()
            .toLowerCase()
            .contains(textController.text.toLowerCase());
      }).toList();
    }

    // Sort data
    filteredData.sort((a, b) {
      dynamic aValue, bValue;

      switch (_sortBy) {
        case 'name':
          aValue = a["country"].toString();
          bValue = b["country"].toString();
          break;
        case 'cases':
          aValue = int.tryParse(a["cases"].toString()) ?? 0;
          bValue = int.tryParse(b["cases"].toString()) ?? 0;
          break;
        case 'deaths':
          aValue = int.tryParse(a["deaths"].toString()) ?? 0;
          bValue = int.tryParse(b["deaths"].toString()) ?? 0;
          break;
        case 'recovered':
          aValue = int.tryParse(a["recovered"].toString()) ?? 0;
          bValue = int.tryParse(b["recovered"].toString()) ?? 0;
          break;
        default:
          aValue = a["country"].toString();
          bValue = b["country"].toString();
      }

      if (_isAscending) {
        return aValue.compareTo(bValue);
      } else {
        return bValue.compareTo(aValue);
      }
    });

    return filteredData;
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
