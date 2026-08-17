-- ==============================================================================
-- SehatKu HMS Initial Seed Data
-- ==============================================================================

-- 1. Default Hospital
INSERT INTO hospitals (id, code, name, timezone, address, phone, email, status)
VALUES (
    'hosp-001',
    'SEHATKU-JKT',
    'SehatKu Medical Center Jakarta',
    'Asia/Jakarta',
    'Jl. Jenderal Sudirman Kav. 52-53, Jakarta Selatan',
    '+62-21-555-8900',
    'info@sehatku-hospital.id',
    'active'
) ON CONFLICT (code) DO NOTHING;

-- 2. Default Roles
INSERT INTO roles (id, code, name, description)
VALUES 
    ('role-super-admin', 'super_admin', 'Super Administrator', 'Akses penuh seluruh konfigurasi sistem lintas hospital'),
    ('role-hospital-admin', 'hospital_admin', 'Hospital Administrator', 'Manajemen operasional dan master data rumah sakit'),
    ('role-doctor', 'doctor', 'Dokter Spesialis / Umum', 'Akses rekam medis, antrean poli, dan peresepan'),
    ('role-receptionist', 'receptionist', 'Resepsionis & Admisi', 'Pendaftaran pasien, verifikasi appointment, dan check-in antrean'),
    ('role-cashier', 'cashier', 'Kasir & Billing', 'Penerbitan invoice dan verifikasi pembayaran'),
    ('role-patient', 'patient', 'Pasien', 'Akses portal pasien, riwayat medis, dan booking slot')
ON CONFLICT (code) DO NOTHING;

-- 3. Default Users (Passwords hashed for demo: 'password123')
-- Hash generated via bcrypt: $2a$10$wN9rI.hD2v61f5L8C9M6E.8l5vR/U3Jt0pQ7Z.Qy3R8i5sW7X8mXW
INSERT INTO users (id, email, phone, password_hash, full_name, status)
VALUES 
    ('usr-admin', 'admin@sehatku.id', '0811-0000-0001', '$2a$10$wN9rI.hD2v61f5L8C9M6E.8l5vR/U3Jt0pQ7Z.Qy3R8i5sW7X8mXW', 'Budi Santoso (Admin)', 'active'),
    ('usr-doctor-maya', 'doctor@sehatku.id', '0812-3456-7890', '$2a$10$wN9rI.hD2v61f5L8C9M6E.8l5vR/U3Jt0pQ7Z.Qy3R8i5sW7X8mXW', 'dr. Maya Pratama, Sp.JP', 'active'),
    ('usr-doctor-rafi', 'rafi@sehatku.id', '0813-9876-5432', '$2a$10$wN9rI.hD2v61f5L8C9M6E.8l5vR/U3Jt0pQ7Z.Qy3R8i5sW7X8mXW', 'drg. Rafi Akbar, Sp.KG', 'active'),
    ('usr-patient-nadia', 'patient@sehatku.id', '0812-9988-7766', '$2a$10$wN9rI.hD2v61f5L8C9M6E.8l5vR/U3Jt0pQ7Z.Qy3R8i5sW7X8mXW', 'Nadia Putri', 'active')
ON CONFLICT (email) DO NOTHING;

-- 4. User Role Mapping
INSERT INTO user_roles (id, user_id, role_id, hospital_id)
VALUES
    ('ur-1', 'usr-admin', 'role-hospital-admin', 'hosp-001'),
    ('ur-2', 'usr-doctor-maya', 'role-doctor', 'hosp-001'),
    ('ur-3', 'usr-doctor-rafi', 'role-doctor', 'hosp-001'),
    ('ur-4', 'usr-patient-nadia', 'role-patient', 'hosp-001')
ON CONFLICT (user_id, role_id, hospital_id) DO NOTHING;

-- 5. Departments / Poliklinik
INSERT INTO departments (id, hospital_id, code, name, description, status)
VALUES
    ('dept-1', 'hosp-001', 'KARDIO', 'Kardiologi & Vaskular', 'Pelayanan spesialis jantung dan pembuluh darah', 'active'),
    ('dept-2', 'hosp-001', 'DENTAL', 'Kesehatan Gigi & Mulut', 'Pelayanan konservasi gigi dan bedah mulut', 'active'),
    ('dept-3', 'hosp-001', 'PEDIATRI', 'Pediatri & Tumbuh Kembang', 'Pelayanan spesialis kesehatan anak dan imunisasi', 'active'),
    ('dept-4', 'hosp-001', 'NEURO', 'Neurologi & Saraf', 'Pelayanan spesialis saraf dan gangguan motorik', 'active'),
    ('dept-5', 'hosp-001', 'INTERNA', 'Penyakit Dalam', 'Pelayanan penyakit dalam dan metabolik', 'active'),
    ('dept-6', 'hosp-001', 'MATA', 'Mata (Oftalmologi)', 'Pelayanan kesehatan mata dan refraksi', 'active')
ON CONFLICT (hospital_id, code) DO NOTHING;

-- 6. Doctors
INSERT INTO doctors (id, user_id, hospital_id, department_id, license_number, name, specialist, experience_years, rating, available_today, status, phone, email, schedule_days)
VALUES
    ('d1', 'usr-doctor-maya', 'hosp-001', 'dept-1', 'SIP.449.1/092/2021', 'dr. Maya Pratama, Sp.JP', 'Kardiologi', 12, 4.90, true, 'active', '0812-3456-7890', 'maya.pratama@sehatku-hospital.id', ARRAY['Senin', 'Rabu', 'Jumat']),
    ('d2', 'usr-doctor-rafi', 'hosp-001', 'dept-2', 'SIP.449.1/104/2022', 'drg. Rafi Akbar, Sp.KG', 'Dokter Gigi', 8, 4.80, true, 'active', '0813-9876-5432', 'rafi.akbar@sehatku-hospital.id', ARRAY['Selasa', 'Kamis', 'Sabtu']),
    ('d3', NULL, 'hosp-001', 'dept-3', 'SIP.449.1/088/2020', 'dr. Anisa Rahman, Sp.A', 'Pediatri', 10, 4.90, false, 'active', '0811-2233-4455', 'anisa.rahman@sehatku-hospital.id', ARRAY['Senin', 'Selasa', 'Kamis']),
    ('d4', NULL, 'hosp-001', 'dept-4', 'SIP.449.1/055/2018', 'dr. Bima Santoso, Sp.N', 'Neurologi', 15, 4.70, true, 'active', '0815-6677-8899', 'bima.santoso@sehatku-hospital.id', ARRAY['Rabu', 'Kamis', 'Jumat']),
    ('d5', NULL, 'hosp-001', 'dept-5', 'SIP.449.1/077/2019', 'dr. Hendra Wijaya, Sp.PD', 'Penyakit Dalam', 14, 4.85, true, 'inactive', '0817-1122-3344', 'hendra.wijaya@sehatku-hospital.id', ARRAY['Senin', 'Selasa', 'Rabu', 'Kamis'])
ON CONFLICT (hospital_id, license_number) DO NOTHING;

-- 7. Patients
INSERT INTO patients (id, user_id, hospital_id, medical_record_number, nik, name, birth_date, gender, blood_type, insurance_provider, phone, email, address, emergency_contact, status)
VALUES
    ('p1', 'usr-patient-nadia', 'hosp-001', 'MRN-2026-001', '3201123456780001', 'Nadia Putri', '1995-04-12', 'Perempuan', 'O+', 'BPJS Kesehatan Mandiri', '0812-9988-7766', 'nadia.putri@gmail.com', 'Jl. Melati No. 14, Jakarta Selatan', 'Dimas (Suami) - 0812-9988-7700', 'Aktif'),
    ('p2', NULL, 'hosp-001', 'MRN-2026-002', '3201123456780002', 'Raka Mahendra', '1988-11-23', 'Laki-laki', 'A+', 'Prudential Corporate', '0813-1122-3344', 'raka.mahendra@gmail.com', 'Jl. Cempaka Putih No. 8, Jakarta Pusat', 'Ratna (Istri) - 0813-1122-3300', 'Aktif'),
    ('p3', NULL, 'hosp-001', 'MRN-2026-003', '3201123456780003', 'Siti Aisyah', '2001-07-05', 'Perempuan', 'B+', 'BPJS PBI', '0857-4433-2211', 'siti.aisyah@gmail.com', 'Jl. Tebet Barat Raya No. 45, Jakarta Selatan', 'Aisyah (Ibu) - 0857-4433-2200', 'Aktif'),
    ('p4', NULL, 'hosp-001', 'MRN-2026-004', '3201123456780004', 'Dimas Ardi', '1976-02-19', 'Laki-laki', 'AB+', 'Allianz Private', '0818-7766-5544', 'dimas.ardi@gmail.com', 'Jl. Kemang Timur No. 22, Jakarta Selatan', 'Dewi (Istri) - 0818-7766-5500', 'Aktif')
ON CONFLICT (hospital_id, medical_record_number) DO NOTHING;

-- 8. Appointments
INSERT INTO appointments (id, hospital_id, doctor_id, patient_id, date_label, appointment_date, appointment_time, queue_number, department_name, reason, status)
VALUES
    ('a1', 'hosp-001', 'd1', 'p1', 'Hari ini', CURRENT_DATE, '09:30 WIB', 'A-032', 'Kardiologi & Vaskular', 'Pemeriksaan EKG & Tekanan Darah', 'Checked-in'),
    ('a2', 'hosp-001', 'd1', 'p2', 'Hari ini', CURRENT_DATE, '10:00 WIB', 'A-033', 'Kardiologi & Vaskular', 'Konsultasi Nyeri Dada', 'Menunggu'),
    ('a3', 'hosp-001', 'd2', 'p3', 'Hari ini', CURRENT_DATE, '10:30 WIB', 'B-015', 'Kesehatan Gigi & Mulut', 'Pembersihan Karang Gigi & Tambal', 'Menunggu'),
    ('a4', 'hosp-001', 'd4', 'p4', 'Hari ini', CURRENT_DATE, '11:15 WIB', 'C-008', 'Neurologi & Saraf', 'Kontrol Migrain Kronis', 'Selesai')
ON CONFLICT (id) DO NOTHING;

-- 9. Invoices
INSERT INTO invoices (id, invoice_number, hospital_id, appointment_id, patient_id, patient_name, doctor_name, service_name, amount, status, payment_method)
VALUES
    ('inv-101', 'INV/20260815/001', 'hosp-001', 'a1', 'p1', 'Nadia Putri', 'dr. Maya Pratama, Sp.JP', 'Konsultasi Spesialis + EKG', 450000.00, 'Lunas', 'QRIS Dinamis'),
    ('inv-102', 'INV/20260815/002', 'hosp-001', 'a2', 'p2', 'Raka Mahendra', 'dr. Maya Pratama, Sp.JP', 'Konsultasi Spesialis Jantung', 300000.00, 'Menunggu', 'Transfer Bank (BCA VA)'),
    ('inv-103', 'INV/20260815/003', 'hosp-001', 'a3', 'p3', 'Siti Aisyah', 'drg. Rafi Akbar, Sp.KG', 'Scaling Gigi Dewasa', 350000.00, 'Lunas', 'BPJS Kesehatan'),
    ('inv-104', 'INV/20260815/004', 'hosp-001', 'a4', 'p4', 'Dimas Ardi', 'dr. Bima Santoso, Sp.N', 'Konsultasi Saraf + Resep Obat', 620000.00, 'Lunas', 'Asuransi Swasta (Allianz)')
ON CONFLICT (invoice_number) DO NOTHING;

-- 10. Audit Logs
INSERT INTO audit_logs (id, hospital_id, actor_name, actor_role, action, resource_type, resource_id, details)
VALUES
    ('log-1', 'hosp-001', 'Budi Santoso', 'hospital_admin', 'LOGIN', 'Session', 'sess-8812', 'Berhasil login dari IP 192.168.1.45'),
    ('log-2', 'hosp-001', 'Budi Santoso', 'hospital_admin', 'UPDATE', 'Doctor', 'd1', 'Memperbarui kuota slot dr. Maya Pratama, Sp.JP'),
    ('log-3', 'hosp-001', 'Siti Rahma', 'receptionist', 'CREATE', 'Patient', 'p-1004', 'Pendaftaran pasien baru MRN-2026-089 (Ahmad Fauzi)'),
    ('log-4', 'hosp-001', 'Siti Rahma', 'receptionist', 'CHECK_IN', 'Appointment', 'a1', 'Pasien Nadia Putri melakukan check-in antrean A-032')
ON CONFLICT (id) DO NOTHING;
