import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/models/health_models.dart';

void showBookingSheet(BuildContext context, Doctor doctor) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _BookingSheet(doctor: doctor),
  );
}

class _BookingSheet extends StatefulWidget {
  const _BookingSheet({required this.doctor});
  final Doctor doctor;

  @override
  State<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends State<_BookingSheet> {
  int selectedDay = 1;
  int selectedTime = 1;
  final times = ['08:30', '09:30', '10:30', '13:00', '14:00', '15:30'];

  @override
  Widget build(BuildContext context) {
    final dates = List.generate(
      5,
      (index) => DateTime.now().add(Duration(days: index + 1)),
    );
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Buat janji temu',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(widget.doctor.name),
            const SizedBox(height: 24),
            Text(
              'Pilih tanggal',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: dates.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final selected = selectedDay == index;
                  return ChoiceChip(
                    selected: selected,
                    onSelected: (_) => setState(() => selectedDay = index),
                    label: SizedBox(
                      width: 44,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('EEE').format(dates[index])),
                          Text(
                            '${dates[index].day}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            Text('Pilih waktu', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                times.length,
                (index) => ChoiceChip(
                  selected: selectedTime == index,
                  label: Text(times[index]),
                  onSelected: (_) => setState(() => selectedTime = index),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Keluhan / alasan kunjungan',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppTheme.primary),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Data medis Anda dilindungi dan hanya dapat diakses petugas berwenang.',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    icon: const Icon(
                      Icons.check_circle,
                      color: AppTheme.success,
                      size: 54,
                    ),
                    title: const Text('Janji temu berhasil'),
                    content: Text(
                      'Booking dengan ${widget.doctor.name} telah dikonfirmasi. Nomor antrean Anda A-032.',
                    ),
                    actions: [
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Selesai'),
                      ),
                    ],
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text('Konfirmasi janji temu'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
