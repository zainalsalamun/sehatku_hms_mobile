import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';

class MedicalRecordsScreen extends ConsumerWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(hmsRepositoryProvider).records;
    return Scaffold(
      appBar: const DashboardAppBar(
        title: 'Rekam medis',
        subtitle: 'Riwayat kesehatan tersimpan aman',
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.bloodtype_outlined, color: Colors.white, size: 38),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ringkasan pasien',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Gol. darah O+  •  Alergi Penicillin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader('Riwayat kunjungan'),
          ...records.map(
            (record) => Card(
              margin: const EdgeInsets.only(top: 10),
              child: ExpansionTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.medical_information_outlined),
                ),
                title: Text(
                  record.diagnosis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text('${record.date} • ${record.doctor}'),
                childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                children: [
                  ListTile(
                    leading: const Icon(Icons.medication_outlined),
                    title: const Text('Resep'),
                    subtitle: Text(record.medicine),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Laporan PDF'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Bagikan'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
