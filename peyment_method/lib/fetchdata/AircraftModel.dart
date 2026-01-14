class AircraftItem {
  final int id;
  final String registration;
  final String aircraftType;

  AircraftItem({
    required this.id,
    required this.registration,
    required this.aircraftType,
  });

  factory AircraftItem.fromJson(Map<String, dynamic> json) {
    return AircraftItem(
      id: json['id'],
      registration: json['registration_number'] ?? '',
      aircraftType: json['aircraft_type'] ?? '',
    );
  }
}


class AircraftDetails {
  final List<AircraftImage> images;

  AircraftDetails({required this.images});

  factory AircraftDetails.fromJson(Map<String, dynamic> json) {
    final List list = json['images'] ?? [];

    return AircraftDetails(
      images: list.map((e) => AircraftImage.fromJson(e)).toList(),
    );
  }
}

class AircraftImage {
  final String path;
  final String tag;

  AircraftImage({required this.path, required this.tag});

  factory AircraftImage.fromJson(Map<String, dynamic> json) {
    return AircraftImage(
      path: json['media']['path'],
      tag: json['tag']['value'],
    );
  }
}
