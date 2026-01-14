class Availability {
  final int id;
  final int aircraftId;
  final String registrationNumber;
  final String aircraftType;

  Availability({
    required this.id,
    required this.aircraftId,
    required this.registrationNumber,
    required this.aircraftType,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['id'],
      aircraftId: json['aircraft_id'],   // IMPORTANT
      registrationNumber: json['registration_number'],
      aircraftType: json['aircraft_type'],
    );
  }
}
