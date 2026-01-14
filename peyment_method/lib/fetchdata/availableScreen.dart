import 'package:flutter/material.dart';
import 'package:peyment_method/fetchdata/apiService.dart';
class AircraftScreen extends StatefulWidget {
  const AircraftScreen({super.key});

  @override
  State<AircraftScreen> createState() => _AircraftScreenState();
}

class _AircraftScreenState extends State<AircraftScreen> {
  final api = ApiService();
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = loadAircraftWithImages(api);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Charter Aircraft")),
      body: FutureBuilder(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data found"));
          }

          final list = snapshot.data!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    item['image'] != null
                        ? Image.network(item['image'], height: 200, fit: BoxFit.cover)
                        : const Icon(Icons.flight, size: 100),

                    ListTile(
                     title: Text(item['type'] != null ? item['type']['name'] : ''),
                      subtitle: Text(item['registration'] ?? ''),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
Future<List<Map<String, dynamic>>> loadAircraftWithImages(ApiService api) async {
  final aircraftList = await api.getCharterAircraftRaw();

  List<Map<String, dynamic>> finalList = [];

  for (var aircraft in aircraftList) {
    final int id = aircraft['id'];

    final details = await api.getAircraftDetailsRaw(id);

    String? imageUrl;
    if (details['images'] != null && details['images'].isNotEmpty) {
      imageUrl = details['images'][0]['media']['path'];
    }

  finalList.add({
  "id": id,
  "registration": aircraft['registration_number'],
  "type": aircraft['aircraft_type'], 
  "image": imageUrl,
});
  }

  return finalList;
}

}
