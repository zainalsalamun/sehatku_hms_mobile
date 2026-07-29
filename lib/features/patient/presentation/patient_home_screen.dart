import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';
import '../../appointment/presentation/booking_sheet.dart';
import '../../doctor/presentation/doctor_detail_sheet.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(hmsRepositoryProvider);
    final appointment = repository.upcomingAppointment;
    final doctors = repository.doctors;
    return Scaffold(
      appBar: const DashboardAppBar(
        title: 'Halo, Nadia 👋',
        subtitle: 'Bagaimana kesehatanmu hari ini?',
      ),
      body: RefreshIndicator(
        onRefresh: () async =>
            Future<void>.delayed(const Duration(milliseconds: 600)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF32AA9F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Janji temu berikutnya',
                    style: TextStyle(color: Colors.white.withValues(alpha: .8)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appointment.doctorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${appointment.dateLabel} • ${appointment.time}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _pill(
                        Icons.confirmation_number_outlined,
                        'Antrean ${appointment.queueNumber}',
                      ),
                      const SizedBox(width: 8),
                      _pill(Icons.verified_outlined, appointment.status),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionHeader('Akses cepat'),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _QuickAction(
                  Icons.search,
                  'Cari dokter',
                  () => _showDoctors(context, doctors),
                ),
                _QuickAction(
                  Icons.calendar_month_outlined,
                  'Buat janji',
                  () => showBookingSheet(context, doctors.first),
                ),
                _QuickAction(
                  Icons.qr_code_2,
                  'Check-in',
                  () => _showQr(context),
                ),
                _QuickAction(
                  Icons.chat_bubble_outline,
                  'Chat',
                  () => _showChat(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const SectionHeader('Dokter tersedia', action: 'Lihat semua'),
            const SizedBox(height: 10),
            ...doctors
                .take(3)
                .map(
                  (doctor) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        radius: 27,
                        backgroundColor: const Color(0xFFE0F4F2),
                        child: Text(
                          doctor.name.split(' ')[1][0],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        doctor.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${doctor.specialist} • ⭐ ${doctor.rating}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showDoctorDetailSheet(context, doctor),
                    ),
                  ),
                ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4DE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFFD992),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: Color(0xFF9A6411),
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Minum air secara berkala. Tubuh yang terhidrasi membantu menjaga fokus dan energi.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .16),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    ),
  );

  void _showDoctors(BuildContext context, List doctors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .72,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Cari dokter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Nama atau spesialisasi',
              ),
            ),
            const SizedBox(height: 16),
            ...doctors.map(
              (doctor) => ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(doctor.name),
                subtitle: Text(doctor.specialist),
                trailing: Text('⭐ ${doctor.rating}'),
                onTap: () {
                  Navigator.pop(context);
                  showDoctorDetailSheet(context, doctor);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQr(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Check-in'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 190,
              height: 190,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.navy),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.qr_code_2, size: 145),
            ),
            const SizedBox(height: 16),
            const Text(
              'A-032 • Tunjukkan kode ini di kiosk rumah sakit.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SizedBox(
          height: 430,
          child: Column(
            children: [
              Text(
                'dr. Maya Pratama',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(height: 28),
              const Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('Halo Nadia, ada yang bisa saya bantu?'),
                ),
              ),
              const Spacer(),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Tulis pesan...',
                  suffixIcon: Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppTheme.primary, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
