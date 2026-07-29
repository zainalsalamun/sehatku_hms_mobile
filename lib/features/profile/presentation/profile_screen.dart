import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(title: 'Profil'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 46,
            backgroundColor: Color(0xFFE0F4F2),
            child: Text(
              'NP',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Nadia Putri',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text('MRN 2026-00182', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          const _ProfileTile(
            Icons.badge_outlined,
            'Data pribadi',
            'Tanggal lahir, jenis kelamin, alamat',
          ),
          const _ProfileTile(
            Icons.health_and_safety_outlined,
            'Informasi medis',
            'Golongan darah, alergi, kondisi',
          ),
          const _ProfileTile(
            Icons.verified_user_outlined,
            'Asuransi',
            'BPJS Kesehatan • Aktif',
          ),
          const _ProfileTile(
            Icons.contact_emergency_outlined,
            'Kontak darurat',
            'Budi Putra • Keluarga',
          ),
          const _ProfileTile(
            Icons.fingerprint,
            'Keamanan',
            'Biometrik dan perangkat',
          ),
          const _ProfileTile(
            Icons.settings_outlined,
            'Pengaturan',
            'Bahasa, tema, notifikasi',
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    ),
  );
}
