import '../../shared/models/health_models.dart';

class MockHmsRepository {
  const MockHmsRepository();

  List<Doctor> get doctors => const [
    Doctor(
      id: 'd1',
      name: 'dr. Maya Pratama, Sp.JP',
      specialist: 'Kardiologi',
      hospital: 'SehatKu Medical Center',
      experience: 12,
      rating: 4.9,
      availableToday: true,
    ),
    Doctor(
      id: 'd2',
      name: 'drg. Rafi Akbar, Sp.KG',
      specialist: 'Dokter Gigi',
      hospital: 'SehatKu Dental Clinic',
      experience: 8,
      rating: 4.8,
      availableToday: true,
    ),
    Doctor(
      id: 'd3',
      name: 'dr. Anisa Rahman, Sp.A',
      specialist: 'Pediatri',
      hospital: 'SehatKu Women & Children',
      experience: 10,
      rating: 4.9,
      availableToday: false,
    ),
    Doctor(
      id: 'd4',
      name: 'dr. Bima Santoso, Sp.N',
      specialist: 'Neurologi',
      hospital: 'SehatKu Medical Center',
      experience: 15,
      rating: 4.7,
      availableToday: true,
    ),
  ];

  Appointment get upcomingAppointment => const Appointment(
    id: 'a1',
    doctorName: 'dr. Maya Pratama, Sp.JP',
    patientName: 'Nadia Putri',
    dateLabel: 'Rabu, 30 Juli 2026',
    time: '09:30',
    status: 'Terkonfirmasi',
    queueNumber: 'A-032',
  );

  List<MedicalRecord> get records => const [
    MedicalRecord(
      date: '18 Juli 2026',
      doctor: 'dr. Maya Pratama, Sp.JP',
      diagnosis: 'Hipertensi ringan',
      medicine: 'Amlodipine 5 mg',
    ),
    MedicalRecord(
      date: '02 Juni 2026',
      doctor: 'dr. Anisa Rahman, Sp.A',
      diagnosis: 'Infeksi saluran pernapasan',
      medicine: 'Paracetamol 500 mg',
    ),
  ];
}
