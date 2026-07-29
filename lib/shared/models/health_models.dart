enum UserRole {
  patient('Pasien'),
  doctor('Dokter'),
  admin('Admin');

  const UserRole(this.label);
  final String label;
}

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialist,
    required this.hospital,
    required this.experience,
    required this.rating,
    required this.availableToday,
  });

  final String id;
  final String name;
  final String specialist;
  final String hospital;
  final int experience;
  final double rating;
  final bool availableToday;
}

class Patient {
  const Patient({
    required this.id,
    required this.medicalRecordNumber,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.status,
    this.bloodType,
    this.insuranceProvider,
  });

  final String id;
  final String medicalRecordNumber;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String status;
  final String? bloodType;
  final String? insuranceProvider;
}

class Appointment {
  const Appointment({
    required this.id,
    required this.doctorName,
    required this.patientName,
    required this.dateLabel,
    required this.time,
    required this.status,
    required this.queueNumber,
  });

  final String id;
  final String doctorName;
  final String patientName;
  final String dateLabel;
  final String time;
  final String status;
  final String queueNumber;
}

class MedicalRecord {
  const MedicalRecord({
    required this.date,
    required this.doctor,
    required this.diagnosis,
    required this.medicine,
  });

  final String date;
  final String doctor;
  final String diagnosis;
  final String medicine;
}
