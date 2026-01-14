

import 'package:peyment_method/fetchdata/apiService.dart';

class AvailabilityService {
  final ApiService api = ApiService();

  // Future<List<Map<String, dynamic>>> loadAvailabilityWithImages() async {
  //   final availabilityList = await api.getAvailability();

  //   List<Map<String, dynamic>> finalList = [];

  //   for (var item in availabilityList) {
  //     final aircraft = await api.getAircraft(item.id);

  //     finalList.add({
  //       "availability": item,
  //       "image": aircraft.images.isNotEmpty ? aircraft.images.first : null,
  //     });
  //   }

  //   return finalList;
  // }


// Future<List<Map<String, dynamic>>> loadAircraftWithImages(ApiService api) async {
//   final aircraftList = await api.getCharterAircraft();

//   List<Map<String, dynamic>> finalList = [];

//   for (var aircraft in aircraftList) {
//     final details = await api.getAircraftDetails(aircraft.id);

//     String? imageUrl;
//     if (details.images.isNotEmpty) {
//       imageUrl = details.images.first.path;
//     }

//     finalList.add({
//       "aircraft": aircraft,
//       "image": imageUrl,
//     });
//   }

//   return finalList;
// }


 

}


