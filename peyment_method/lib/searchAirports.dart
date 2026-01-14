



import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Airport {
  final int id;
  final String? name;
  final String? icao;
  final String? iata;
  final String? cityName;
  final String? countryName;

  Airport.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        icao = json['icao'],
        iata = json['iata'],
        cityName = json['city_name'],
        countryName = json['country_name'];
}


class AirportSearchScreen extends StatefulWidget {
  const AirportSearchScreen({super.key});

  @override
  State<AirportSearchScreen> createState() => _AirportSearchScreenState();
}

class _AirportSearchScreenState extends State<AirportSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Airport> _airports = [];
  bool _isLoading = false;
  String? _error;
  Timer? _debounce;

  static const String apiToken = 'qDF50oNmO7E9wN574h5HibHRkKW1recwW8R9';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

 
  void _onSearchChanged() {
    final query = _searchController.text.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 2) {
        _searchAirports(query);
      } else {
        setState(() {
          _airports.clear();
        });
      }
    });
  }

  Future<void> _searchAirports(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final url = 'https://api.aviapages.com/v3/airports/?search=$query';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token $apiToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load airports');
      }

      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      setState(() {
        _airports = results.map((e) => Airport.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Airport'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search airport, city, ICAO or IATA',
                prefixIcon: const Icon(Icons.flight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
          ),

         
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text('Error: $_error'))
                    : _airports.isEmpty
                        ? const Center(
                            child: Text(
                              'Start typing to search airports',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _airports.length,
                            itemBuilder: (context, index) {
                              final airport = _airports[index];

                              return ListTile(
                                leading: const Icon(Icons.flight_takeoff),
                                title: Text(
                                  airport.name ?? 'Unknown Airport',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  '${airport.cityName ?? '—'}, ${airport.countryName ?? '—'}\n'
                                  '${airport.icao ?? '—'} • ${airport.iata ?? '—'}',
                                ),
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${airport.name} selected'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
