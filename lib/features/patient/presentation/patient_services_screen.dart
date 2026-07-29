import 'package:flutter/material.dart';

import '../../../shared/widgets/app_widgets.dart';

class PatientServicesScreen extends StatelessWidget {
  const PatientServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const services = [
      (Icons.medication_outlined, 'Resep', 'Lihat dan unduh resep obat'),
      (
        Icons.receipt_long_outlined,
        'Pembayaran',
        'Tagihan dan riwayat transaksi',
      ),
      (
        Icons.confirmation_number_outlined,
        'Antrean',
        'A-032 • estimasi 15 menit',
      ),
      (Icons.chat_bubble_outline, 'Chat dokter', '1 percakapan aktif'),
      (Icons.notifications_outlined, 'Notifikasi', '3 informasi terbaru'),
      (Icons.video_call_outlined, 'Telekonsultasi', 'Konsultasi dari rumah'),
      (Icons.science_outlined, 'Hasil lab', 'Unduh hasil pemeriksaan'),
      (Icons.emergency_outlined, 'Darurat', 'Hubungi IGD terdekat'),
    ];
    return Scaffold(
      appBar: const DashboardAppBar(
        title: 'Layanan kesehatan',
        subtitle: 'Semua kebutuhan dalam satu tempat',
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.sizeOf(context).width > 700 ? 4 : 2,
          childAspectRatio: 1.15,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: services.length,
        itemBuilder: (_, index) {
          final service = services[index];
          return Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${service.$2} siap diintegrasikan dengan backend.',
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      service.$1,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Spacer(),
                    Text(
                      service.$2,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      service.$3,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
