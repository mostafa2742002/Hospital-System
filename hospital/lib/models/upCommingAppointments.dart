import 'package:hospital/models/Appointment.dart';
import 'package:hospital/models/patient.dart';

class upCommingAppointment{
  final Patient patient ;
  final Appointment appointment ;
  

  upCommingAppointment({required this.patient , required this.appointment});
}
