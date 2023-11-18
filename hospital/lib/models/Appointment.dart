class Appointment {
  final String date;
  final String time;
  final String status;
  final String Id;
  final String doctorId;
  final String patientId;

  Appointment({
    required this.date,
    required this.time,
    required this.status,
    required this.doctorId,
    required this.patientId,
    required this.Id,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'status': status,
      'doctorId': doctorId,
      'patientId': patientId,
      'Id': Id,
    };
  }
}
