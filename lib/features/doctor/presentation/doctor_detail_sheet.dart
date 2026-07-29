import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/health_models.dart';
import '../../appointment/presentation/booking_sheet.dart';

void showDoctorDetailSheet(BuildContext context, Doctor doctor) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: .82,
      maxChildSize: .94,
      expand: false,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 30),
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: const Color(0xFFE0F4F2),
            child: Text(
              doctor.name.split(' ')[1][0],
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            doctor.name,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(doctor.specialist, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            children: [
              _Info('${doctor.experience} th', 'Pengalaman'),
              _Info('${doctor.rating}', 'Rating'),
              _Info(doctor.availableToday ? 'Hari ini' : 'Besok', 'Tersedia'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Tentang dokter', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${doctor.name} adalah dokter ${doctor.specialist.toLowerCase()} berpengalaman di ${doctor.hospital}. Berkomitmen pada perawatan yang aman, transparan, dan berpusat pada pasien.',
          ),
          const SizedBox(height: 22),
          Text('Jadwal praktik', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Sen • 09:00–13:00')),
              Chip(label: Text('Rab • 09:00–15:00')),
              Chip(label: Text('Jum • 13:00–17:00')),
            ],
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              showBookingSheet(context, doctor);
            },
            icon: const Icon(Icons.calendar_month),
            label: const Padding(
              padding: EdgeInsets.symmetric(vertical: 14),
              child: Text('Buat janji temu'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Info extends StatelessWidget {
  const _Info(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppTheme.navy,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}
