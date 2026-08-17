-- ==============================================================================
-- SehatKu Hospital Management System (HMS) Database Schema
-- Target: PostgreSQL 15 / 16
-- Compliance: UUID Primary Keys, Scoped RBAC, Audit Logging, Optimistic Concurrency
-- ==============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Function to automatically update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------
-- 1. IDENTITY & RBAC
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS hospitals (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    timezone VARCHAR(50) DEFAULT 'Asia/Jakarta',
    address TEXT,
    phone VARCHAR(50),
    email VARCHAR(100),
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(50),
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'deactivated')),
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS roles (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_roles (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id VARCHAR(50) NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id VARCHAR(50) NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    hospital_id VARCHAR(50) REFERENCES hospitals(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, role_id, hospital_id)
);

-- ------------------------------------------------------------------------------
-- 2. MASTER DATA (DEPARTMENTS, DOCTORS, PATIENTS)
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS departments (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    hospital_id VARCHAR(50) NOT NULL REFERENCES hospitals(id) ON DELETE RESTRICT,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1,
    UNIQUE (hospital_id, code)
);

CREATE TABLE IF NOT EXISTS doctors (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id VARCHAR(50) REFERENCES users(id) ON DELETE SET NULL,
    hospital_id VARCHAR(50) NOT NULL REFERENCES hospitals(id) ON DELETE RESTRICT,
    department_id VARCHAR(50) NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    license_number VARCHAR(100) NOT NULL, -- SIP / STR
    name VARCHAR(255) NOT NULL,
    specialist VARCHAR(100) NOT NULL,
    biography TEXT,
    experience_years INT DEFAULT 0,
    rating NUMERIC(3, 2) DEFAULT 5.00,
    available_today BOOLEAN DEFAULT true,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'on_leave')),
    phone VARCHAR(50),
    email VARCHAR(100),
    schedule_days TEXT[] DEFAULT ARRAY['Senin', 'Rabu', 'Jumat'],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1,
    UNIQUE (hospital_id, license_number)
);

CREATE TABLE IF NOT EXISTS doctor_schedules (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    doctor_id VARCHAR(50) NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_minutes INT DEFAULT 30,
    max_patients INT DEFAULT 20,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS patients (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    user_id VARCHAR(50) REFERENCES users(id) ON DELETE SET NULL,
    hospital_id VARCHAR(50) NOT NULL REFERENCES hospitals(id) ON DELETE RESTRICT,
    medical_record_number VARCHAR(50) NOT NULL, -- MRN
    nik VARCHAR(20),
    name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(20) NOT NULL CHECK (gender IN ('Laki-laki', 'Perempuan')),
    blood_type VARCHAR(10),
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(100),
    address TEXT,
    emergency_contact TEXT,
    status VARCHAR(20) DEFAULT 'Aktif' CHECK (status IN ('Aktif', 'Nonaktif')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1,
    UNIQUE (hospital_id, medical_record_number)
);

-- ------------------------------------------------------------------------------
-- 3. OPERATIONS (APPOINTMENTS, QUEUES)
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS appointments (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    hospital_id VARCHAR(50) NOT NULL REFERENCES hospitals(id) ON DELETE RESTRICT,
    doctor_id VARCHAR(50) NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    patient_id VARCHAR(50) NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    date_label VARCHAR(50) NOT NULL,
    appointment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    appointment_time VARCHAR(20) NOT NULL,
    queue_number VARCHAR(20) NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    reason TEXT,
    cancellation_reason TEXT,
    status VARCHAR(30) DEFAULT 'Menunggu' CHECK (
        status IN ('Terkonfirmasi', 'Checked-in', 'Menunggu', 'Sedang Konsultasi', 'Selesai', 'Dibatalkan', 'No-show')
    ),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS queue_tickets (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    appointment_id VARCHAR(50) UNIQUE REFERENCES appointments(id) ON DELETE CASCADE,
    service_date DATE NOT NULL DEFAULT CURRENT_DATE,
    prefix VARCHAR(10) NOT NULL,
    sequence INT NOT NULL,
    queue_number VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'waiting' CHECK (status IN ('waiting', 'called', 'in_room', 'completed', 'skipped', 'void')),
    called_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

-- ------------------------------------------------------------------------------
-- 4. CLINICAL WORKFLOW & ELECTRONIC MEDICAL RECORDS (EMR)
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS encounters (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    appointment_id VARCHAR(50) REFERENCES appointments(id) ON DELETE SET NULL,
    patient_id VARCHAR(50) NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    doctor_id VARCHAR(50) NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP WITH TIME ZONE,
    anamnesis TEXT,
    physical_exam TEXT,
    diagnosis_summary TEXT,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'signed', 'revised')),
    signed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

CREATE TABLE IF NOT EXISTS diagnoses (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    encounter_id VARCHAR(50) NOT NULL REFERENCES encounters(id) ON DELETE CASCADE,
    icd10_code VARCHAR(20),
    description TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'primary' CHECK (type IN ('primary', 'secondary')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS prescriptions (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    encounter_id VARCHAR(50) NOT NULL REFERENCES encounters(id) ON DELETE CASCADE,
    patient_id VARCHAR(50) NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    doctor_id VARCHAR(50) NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    notes TEXT,
    status VARCHAR(20) DEFAULT 'issued' CHECK (status IN ('issued', 'dispensed', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS prescription_items (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    prescription_id VARCHAR(50) NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
    medicine_name VARCHAR(255) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    route VARCHAR(50) DEFAULT 'oral',
    duration_days INT DEFAULT 3,
    instruction TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 5. BILLING & INVOICES
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS invoices (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    invoice_number VARCHAR(100) UNIQUE NOT NULL,
    hospital_id VARCHAR(50) NOT NULL REFERENCES hospitals(id) ON DELETE RESTRICT,
    appointment_id VARCHAR(50) REFERENCES appointments(id) ON DELETE SET NULL,
    patient_id VARCHAR(50) NOT NULL REFERENCES patients(id) ON DELETE RESTRICT,
    patient_name VARCHAR(255) NOT NULL,
    doctor_name VARCHAR(255) NOT NULL,
    service_name VARCHAR(255) NOT NULL,
    amount NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (amount >= 0),
    status VARCHAR(20) DEFAULT 'Menunggu' CHECK (status IN ('Lunas', 'Menunggu', 'Dibatalkan', 'Refund')),
    payment_method VARCHAR(100) NOT NULL DEFAULT 'Tunai',
    paid_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    version INT DEFAULT 1
);

-- ------------------------------------------------------------------------------
-- 6. IMMUTABLE AUDIT LOGS
-- ------------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS audit_logs (
    id VARCHAR(50) PRIMARY KEY DEFAULT gen_random_uuid()::text,
    hospital_id VARCHAR(50) REFERENCES hospitals(id) ON DELETE SET NULL,
    actor_id VARCHAR(50),
    actor_name VARCHAR(255) NOT NULL,
    actor_role VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL, -- CREATE, UPDATE, ACTIVATE, DEACTIVATE, CANCEL, LOGIN, CHECK_IN, PAYMENT_SETTLE
    resource_type VARCHAR(100) NOT NULL, -- Doctor, Patient, Appointment, Invoice, User
    resource_id VARCHAR(100) NOT NULL,
    details TEXT NOT NULL,
    ip_address VARCHAR(50) DEFAULT '127.0.0.1',
    user_agent TEXT,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- INDEXES & PERFORMANCE OPTIMIZATIONS
-- ------------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_patients_mrn ON patients(medical_record_number);
CREATE INDEX IF NOT EXISTS idx_patients_nik ON patients(nik);
CREATE INDEX IF NOT EXISTS idx_doctors_license ON doctors(license_number);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date, doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);
CREATE INDEX IF NOT EXISTS idx_invoices_number ON invoices(invoice_number);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_resource ON audit_logs(resource_type, resource_id);

-- ------------------------------------------------------------------------------
-- TRIGGERS FOR AUTO-UPDATING TIMESTAMPS
-- ------------------------------------------------------------------------------

CREATE OR REPLACE TRIGGER trg_hospitals_update BEFORE UPDATE ON hospitals FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_users_update BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_departments_update BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_doctors_update BEFORE UPDATE ON doctors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_patients_update BEFORE UPDATE ON patients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_appointments_update BEFORE UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE OR REPLACE TRIGGER trg_invoices_update BEFORE UPDATE ON invoices FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
