import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting Comprehensive SehatKu HMS Database Seeding...');

  // 1. Hospital
  const hospital = await prisma.hospital.upsert({
    where: { code: 'SEHATKU-JKT' },
    update: {},
    create: {
      id: 'hosp-001',
      code: 'SEHATKU-JKT',
      name: 'SehatKu Medical Center Jakarta',
      timezone: 'Asia/Jakarta',
      address: 'Jl. Jenderal Sudirman Kav. 52-53, Jakarta Selatan',
      phone: '+62-21-555-8900',
      email: 'info@sehatku-hospital.id',
      status: 'active',
    },
  });

  // 2. Roles
  const roles = [
    { id: 'role-super-admin', code: 'super_admin', name: 'Super Administrator' },
    { id: 'role-hospital-admin', code: 'hospital_admin', name: 'Hospital Administrator' },
    { id: 'role-doctor', code: 'doctor', name: 'Dokter' },
    { id: 'role-receptionist', code: 'receptionist', name: 'Resepsionis' },
    { id: 'role-cashier', code: 'cashier', name: 'Kasir' },
    { id: 'role-patient', code: 'patient', name: 'Pasien' },
  ];

  for (const r of roles) {
    await prisma.role.upsert({
      where: { code: r.code },
      update: {},
      create: r,
    });
  }

  // 3. Users
  const passwordHash = await bcrypt.hash('password123', 10);
  const users = [
    {
      id: 'usr-admin',
      email: 'admin@sehatku.id',
      fullName: 'Budi Santoso (Admin)',
      phone: '0811-0000-0001',
      roleCode: 'hospital_admin',
    },
    {
      id: 'usr-doctor-maya',
      email: 'doctor@sehatku.id',
      fullName: 'dr. Maya Pratama, Sp.JP',
      phone: '0812-3456-7890',
      roleCode: 'doctor',
    },
    {
      id: 'usr-doctor-rafi',
      email: 'rafi@sehatku.id',
      fullName: 'drg. Rafi Akbar, Sp.KG',
      phone: '0813-9876-5432',
      roleCode: 'doctor',
    },
    {
      id: 'usr-patient-nadia',
      email: 'patient@sehatku.id',
      fullName: 'Nadia Putri',
      phone: '0812-9988-7766',
      roleCode: 'patient',
    },
  ];

  for (const u of users) {
    const user = await prisma.user.upsert({
      where: { email: u.email },
      update: {},
      create: {
        id: u.id,
        email: u.email,
        fullName: u.fullName,
        phone: u.phone,
        passwordHash,
      },
    });

    const role = await prisma.role.findUnique({ where: { code: u.roleCode } });
    if (role) {
      await prisma.userRole.upsert({
        where: {
          userId_roleId_hospitalId: {
            userId: user.id,
            roleId: role.id,
            hospitalId: hospital.id,
          },
        },
        update: {},
        create: {
          userId: user.id,
          roleId: role.id,
          hospitalId: hospital.id,
        },
      });
    }
  }

  // 4. Departments
  const departments = [
    { id: 'dept-1', code: 'KARDIO', name: 'Kardiologi & Vaskular' },
    { id: 'dept-2', code: 'DENTAL', name: 'Kesehatan Gigi & Mulut' },
    { id: 'dept-3', code: 'PEDIATRI', name: 'Pediatri & Tumbuh Kembang' },
    { id: 'dept-4', code: 'NEURO', name: 'Neurologi & Saraf' },
    { id: 'dept-5', code: 'INTERNA', name: 'Penyakit Dalam' },
    { id: 'dept-6', code: 'MATA', name: 'Mata (Oftalmologi)' },
  ];

  for (const d of departments) {
    await prisma.department.upsert({
      where: {
        hospitalId_code: {
          hospitalId: hospital.id,
          code: d.code,
        },
      },
      update: {},
      create: {
        id: d.id,
        hospitalId: hospital.id,
        code: d.code,
        name: d.name,
      },
    });
  }

  // 5. Doctors
  const doctors = [
    {
      id: 'd1',
      userId: 'usr-doctor-maya',
      departmentId: 'dept-1',
      licenseNumber: 'SIP.449.1/092/2021',
      name: 'dr. Maya Pratama, Sp.JP',
      specialist: 'Kardiologi',
      experienceYears: 12,
      rating: 4.9,
      scheduleDays: ['Senin', 'Rabu', 'Jumat'],
      email: 'maya.pratama@sehatku-hospital.id',
      phone: '0812-3456-7890',
      availableToday: true,
      status: 'active',
    },
    {
      id: 'd2',
      userId: 'usr-doctor-rafi',
      departmentId: 'dept-2',
      licenseNumber: 'SIP.449.1/104/2022',
      name: 'drg. Rafi Akbar, Sp.KG',
      specialist: 'Dokter Gigi',
      experienceYears: 8,
      rating: 4.8,
      scheduleDays: ['Selasa', 'Kamis', 'Sabtu'],
      email: 'rafi.akbar@sehatku-hospital.id',
      phone: '0813-9876-5432',
      availableToday: true,
      status: 'active',
    },
    {
      id: 'd3',
      departmentId: 'dept-3',
      licenseNumber: 'SIP.449.1/088/2020',
      name: 'dr. Anisa Rahman, Sp.A',
      specialist: 'Pediatri',
      experienceYears: 10,
      rating: 4.9,
      scheduleDays: ['Senin', 'Selasa', 'Kamis'],
      email: 'anisa.rahman@sehatku-hospital.id',
      phone: '0811-2233-4455',
      availableToday: false,
      status: 'active',
    },
    {
      id: 'd4',
      departmentId: 'dept-4',
      licenseNumber: 'SIP.449.1/055/2018',
      name: 'dr. Bima Santoso, Sp.N',
      specialist: 'Neurologi',
      experienceYears: 15,
      rating: 4.7,
      scheduleDays: ['Rabu', 'Kamis', 'Jumat'],
      email: 'bima.santoso@sehatku-hospital.id',
      phone: '0815-6677-8899',
      availableToday: true,
      status: 'active',
    },
    {
      id: 'd5',
      departmentId: 'dept-5',
      licenseNumber: 'SIP.449.1/077/2019',
      name: 'dr. Hendra Wijaya, Sp.PD',
      specialist: 'Penyakit Dalam',
      experienceYears: 14,
      rating: 4.85,
      scheduleDays: ['Senin', 'Selasa', 'Rabu', 'Kamis'],
      email: 'hendra.wijaya@sehatku-hospital.id',
      phone: '0817-1122-3344',
      availableToday: true,
      status: 'inactive',
    },
  ];

  for (const doc of doctors) {
    await prisma.doctor.upsert({
      where: {
        hospitalId_licenseNumber: {
          hospitalId: hospital.id,
          licenseNumber: doc.licenseNumber,
        },
      },
      update: {},
      create: {
        ...doc,
        hospitalId: hospital.id,
      },
    });
  }

  // 6. Patients
  const patients = [
    {
      id: 'p1',
      userId: 'usr-patient-nadia',
      medicalRecordNumber: 'MRN-2026-001',
      nik: '3201123456780001',
      name: 'Nadia Putri',
      birthDate: new Date('1995-04-12'),
      gender: 'Perempuan',
      bloodType: 'O+',
      insuranceProvider: 'BPJS Kesehatan Mandiri',
      phone: '0812-9988-7766',
      email: 'nadia.putri@gmail.com',
      address: 'Jl. Melati No. 14, Jakarta Selatan',
      emergencyContact: 'Dimas (Suami) - 0812-9988-7700',
    },
    {
      id: 'p2',
      medicalRecordNumber: 'MRN-2026-002',
      nik: '3201123456780002',
      name: 'Raka Mahendra',
      birthDate: new Date('1988-11-23'),
      gender: 'Laki-laki',
      bloodType: 'A+',
      insuranceProvider: 'Prudential Corporate',
      phone: '0813-1122-3344',
      email: 'raka.mahendra@gmail.com',
      address: 'Jl. Cempaka Putih No. 8, Jakarta Pusat',
      emergencyContact: 'Ratna (Istri) - 0813-1122-3300',
    },
    {
      id: 'p3',
      medicalRecordNumber: 'MRN-2026-003',
      nik: '3201123456780003',
      name: 'Siti Aisyah',
      birthDate: new Date('2001-07-05'),
      gender: 'Perempuan',
      bloodType: 'B+',
      insuranceProvider: 'BPJS PBI',
      phone: '0857-4433-2211',
      email: 'siti.aisyah@gmail.com',
      address: 'Jl. Tebet Barat Raya No. 45, Jakarta Selatan',
      emergencyContact: 'Aisyah (Ibu) - 0857-4433-2200',
    },
    {
      id: 'p4',
      medicalRecordNumber: 'MRN-2026-004',
      nik: '3201123456780004',
      name: 'Dimas Ardi',
      birthDate: new Date('1976-02-19'),
      gender: 'Laki-laki',
      bloodType: 'AB+',
      insuranceProvider: 'Allianz Private',
      phone: '0818-7766-5544',
      email: 'dimas.ardi@gmail.com',
      address: 'Jl. Kemang Timur No. 22, Jakarta Selatan',
      emergencyContact: 'Dewi (Istri) - 0818-7766-5500',
    },
  ];

  for (const pat of patients) {
    await prisma.patient.upsert({
      where: {
        hospitalId_medicalRecordNumber: {
          hospitalId: hospital.id,
          medicalRecordNumber: pat.medicalRecordNumber,
        },
      },
      update: {},
      create: {
        ...pat,
        hospitalId: hospital.id,
      },
    });
  }

  // 7. Appointments
  const appointments = [
    {
      id: 'a1',
      doctorId: 'd1',
      patientId: 'p1',
      dateLabel: 'Hari ini',
      appointmentTime: '09:30 WIB',
      status: 'Checked-in',
      queueNumber: 'A-032',
      departmentName: 'Kardiologi & Vaskular',
      reason: 'Pemeriksaan EKG & Tekanan Darah',
    },
    {
      id: 'a2',
      doctorId: 'd1',
      patientId: 'p2',
      dateLabel: 'Hari ini',
      appointmentTime: '10:00 WIB',
      status: 'Menunggu',
      queueNumber: 'A-033',
      departmentName: 'Kardiologi & Vaskular',
      reason: 'Konsultasi Nyeri Dada',
    },
    {
      id: 'a3',
      doctorId: 'd2',
      patientId: 'p3',
      dateLabel: 'Hari ini',
      appointmentTime: '10:30 WIB',
      status: 'Menunggu',
      queueNumber: 'B-015',
      departmentName: 'Kesehatan Gigi & Mulut',
      reason: 'Pembersihan Karang Gigi & Tambal',
    },
    {
      id: 'a4',
      doctorId: 'd4',
      patientId: 'p4',
      dateLabel: 'Hari ini',
      appointmentTime: '11:15 WIB',
      status: 'Selesai',
      queueNumber: 'C-008',
      departmentName: 'Neurologi & Saraf',
      reason: 'Kontrol Migrain Kronis',
    },
  ];

  for (const appt of appointments) {
    await prisma.appointment.upsert({
      where: { id: appt.id },
      update: {},
      create: {
        ...appt,
        hospitalId: hospital.id,
      },
    });
  }

  // 8. Invoices
  const invoices = [
    {
      id: 'inv-101',
      invoiceNumber: 'INV/20260815/001',
      patientId: 'p1',
      patientName: 'Nadia Putri',
      doctorName: 'dr. Maya Pratama, Sp.JP',
      serviceName: 'Konsultasi Spesialis + EKG',
      amount: 450000,
      status: 'Lunas',
      paymentMethod: 'QRIS Dinamis',
    },
    {
      id: 'inv-102',
      invoiceNumber: 'INV/20260815/002',
      patientId: 'p2',
      patientName: 'Raka Mahendra',
      doctorName: 'dr. Maya Pratama, Sp.JP',
      serviceName: 'Konsultasi Spesialis Jantung',
      amount: 300000,
      status: 'Menunggu',
      paymentMethod: 'Transfer Bank (BCA VA)',
    },
    {
      id: 'inv-103',
      invoiceNumber: 'INV/20260815/003',
      patientId: 'p3',
      patientName: 'Siti Aisyah',
      doctorName: 'drg. Rafi Akbar, Sp.KG',
      serviceName: 'Scaling Gigi Dewasa',
      amount: 350000,
      status: 'Lunas',
      paymentMethod: 'BPJS Kesehatan',
    },
    {
      id: 'inv-104',
      invoiceNumber: 'INV/20260815/004',
      patientId: 'p4',
      patientName: 'Dimas Ardi',
      doctorName: 'dr. Bima Santoso, Sp.N',
      serviceName: 'Konsultasi Saraf + Resep Obat',
      amount: 620000,
      status: 'Lunas',
      paymentMethod: 'Asuransi Swasta (Allianz)',
    },
  ];

  for (const inv of invoices) {
    await prisma.invoice.upsert({
      where: { invoiceNumber: inv.invoiceNumber },
      update: {},
      create: {
        ...inv,
        hospitalId: hospital.id,
      },
    });
  }

  // 9. Encounters & Medical Records
  const encounter = await prisma.encounter.upsert({
    where: { id: 'enc-001' },
    update: {},
    create: {
      id: 'enc-001',
      patientId: 'p1',
      doctorId: 'd1',
      startedAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
      anamnesis: 'Pasien mengeluh berdebar ringan setelah berolahraga berat. Tidak ada sesak nafas.',
      physicalExam: 'TD: 125/82 mmHg, Nadi: 78x/mnt reguler, Suhu: 36.6 C, SpO2: 99%',
      diagnosisSummary: 'Hipertensi Primer Terkontrol (ICD-10: I10)',
      status: 'signed',
      diagnoses: {
        create: [
          {
            description: 'Essential (primary) hypertension',
            icd10Code: 'I10',
            type: 'primary',
          },
        ],
      },
      prescriptions: {
        create: [
          {
            patientId: 'p1',
            doctorId: 'd1',
            status: 'dispensed',
            items: {
              create: [
                {
                  medicineName: 'Amlodipine Besylate 5mg',
                  dosage: '5 mg',
                  frequency: '1x sehari pagi',
                  durationDays: 30,
                  instruction: 'Diminum sesudah makan pagi',
                },
                {
                  medicineName: 'Coenzyme Q10 100mg',
                  dosage: '100 mg',
                  frequency: '1x sehari',
                  durationDays: 30,
                  instruction: 'Suplemen jantung',
                },
              ],
            },
          },
        ],
      },
    },
  });

  // 10. Audit Logs
  const auditLogs = [
    {
      id: 'log-1',
      actorName: 'Budi Santoso',
      actorRole: 'hospital_admin',
      action: 'LOGIN',
      resourceType: 'Session',
      resourceId: 'sess-8812',
      details: 'Berhasil login dari IP 192.168.1.45',
    },
    {
      id: 'log-2',
      actorName: 'Budi Santoso',
      actorRole: 'hospital_admin',
      action: 'UPDATE',
      resourceType: 'Doctor',
      resourceId: 'd1',
      details: 'Memperbarui kuota slot dr. Maya Pratama, Sp.JP',
    },
    {
      id: 'log-3',
      actorName: 'Siti Rahma',
      actorRole: 'receptionist',
      action: 'CREATE',
      resourceType: 'Patient',
      resourceId: 'p1',
      details: 'Pendaftaran pasien baru MRN-2026-001 (Nadia Putri)',
    },
    {
      id: 'log-4',
      actorName: 'Siti Rahma',
      actorRole: 'receptionist',
      action: 'CHECK_IN',
      resourceType: 'Appointment',
      resourceId: 'a1',
      details: 'Pasien Nadia Putri melakukan check-in antrean A-032',
    },
  ];

  for (const log of auditLogs) {
    await prisma.auditLog.upsert({
      where: { id: log.id },
      update: {},
      create: {
        ...log,
        hospitalId: hospital.id,
      },
    });
  }

  // 12. Initial Notifications
  const notifications = [
    {
      id: 'notif-1',
      role: 'patient',
      userId: 'usr-patient-nadia',
      title: 'Reservasi Poli Kardiologi Terkonfirmasi',
      message: 'Reservasi Anda dengan dr. Maya Pratama, Sp.JP pada pukul 09:30 WIB telah terdaftar dengan Nomor Antrean A-001.',
      type: 'appointment',
      targetId: 'a1',
      isRead: false,
    },
    {
      id: 'notif-2',
      role: 'patient',
      userId: 'usr-patient-nadia',
      title: 'Kwitansi Pembayaran Resmi Terbit',
      message: 'Pembayaran tagihan invoice INV-2026-101 telah lunas via QRIS Dinamis sebesar Rp 350.000.',
      type: 'billing',
      targetId: 'inv-1',
      isRead: false,
    },
    {
      id: 'notif-3',
      role: 'doctor',
      userId: 'usr-doctor-maya',
      title: 'Jadwal Praktek & Antrean Pasien Hari Ini',
      message: 'Anda memiliki antrean pasien terdaftar di Poli Kardiologi. Antrean pertama: Nadia Putri (A-001).',
      type: 'appointment',
      targetId: 'a1',
      isRead: false,
    },
    {
      id: 'notif-4',
      role: 'admin',
      userId: 'usr-admin-siti',
      title: 'Peringatan Stok Obat Farmasi',
      message: 'Stok Omeprazole 20mg tersisa 25 strip (di bawah batas minimum 80 strip). Harap segera lakukan restock.',
      type: 'prescription',
      targetId: 'med-4',
      isRead: false,
    },
    {
      id: 'notif-5',
      role: 'admin',
      userId: 'usr-admin-siti',
      title: 'Pelunasan Kasir POS Berhasil',
      message: 'Tagihan INV-2026-101 atas nama Nadia Putri telah diselesaikan via QRIS Dinamis sebesar Rp 350.000.',
      type: 'billing',
      targetId: 'inv-1',
      isRead: true,
    },
  ];

  for (const notif of notifications) {
    await prisma.notification.upsert({
      where: { id: notif.id },
      update: {},
      create: notif,
    });
  }

  console.log('✅ Comprehensive SehatKu HMS Database Seeding Completed Successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
