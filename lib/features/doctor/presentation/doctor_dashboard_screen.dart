import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  final queue = [
    'A-028 • Raka Mahendra',
    'A-029 • Siti Aisyah',
    'A-030 • Dimas Ardi',
  ];
  int current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DashboardAppBar(
        title: 'Selamat pagi, dr. Maya',
        subtitle: 'Rabu, 28 Juli 2026',
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;
          final content = [
            _overview(context),
            const SizedBox(width: 18, height: 18),
            _queuePanel(context),
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: content[0]),
                      content[1],
                      Expanded(flex: 2, child: content[2]),
                    ],
                  )
                : Column(children: [content[0], content[1], content[2]]),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'Pasien',
          ),
          NavigationDestination(icon: Icon(Icons.chat_outlined), label: 'Chat'),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _overview(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      GridView.count(
        crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 3 : 1,
        childAspectRatio: 2.6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: const [
          MetricCard(
            label: 'Janji hari ini',
            value: '12',
            icon: Icons.calendar_month_outlined,
          ),
          MetricCard(
            label: 'Menunggu',
            value: '5',
            icon: Icons.hourglass_bottom,
            color: Colors.orange,
          ),
          MetricCard(
            label: 'Selesai',
            value: '7',
            icon: Icons.task_alt,
            color: AppTheme.success,
          ),
        ],
      ),
      const SizedBox(height: 22),
      const SectionHeader('Jadwal hari ini', action: 'Lihat kalender'),
      Card(
        child: Column(
          children: [
            _ScheduleTile('08:00', 'Raka Mahendra', 'Kontrol jantung', 'A-028'),
            const Divider(height: 1),
            _ScheduleTile('08:30', 'Siti Aisyah', 'Konsultasi awal', 'A-029'),
            const Divider(height: 1),
            _ScheduleTile('09:00', 'Dimas Ardi', 'Hasil laboratorium', 'A-030'),
          ],
        ),
      ),
      const SizedBox(height: 22),
      const SectionHeader('Catatan cepat'),
      const TextField(
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Tulis catatan klinis atau pengingat pribadi...',
        ),
      ),
    ],
  );

  Widget _queuePanel(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const SectionHeader('Antrean berjalan'),
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.navy,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          children: [
            const Text(
              'PASIEN SAAT INI',
              style: TextStyle(color: Colors.white60, letterSpacing: 1.4),
            ),
            const SizedBox(height: 12),
            Text(
              queue[current].split(' • ').first,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 42,
              ),
            ),
            Text(
              queue[current].split(' • ').last,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Panggil lagi'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: _next,
                    child: const Text('Selesai & lanjut'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      ...queue
          .skip(current + 1)
          .map(
            (item) => Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(item.split(' • ').last),
                trailing: Text(item.split(' • ').first),
              ),
            ),
          ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: () => _diagnosisDialog(context),
        icon: const Icon(Icons.edit_note),
        label: const Text('Buat diagnosis & resep'),
      ),
    ],
  );

  void _next() =>
      setState(() => current = current < queue.length - 1 ? current + 1 : 0);

  void _diagnosisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Diagnosis pasien'),
        content: const SizedBox(
          width: 460,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Gejala')),
              SizedBox(height: 12),
              TextField(decoration: InputDecoration(labelText: 'Diagnosis')),
              SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(labelText: 'Resep & dosis'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Simpan rekam medis'),
          ),
        ],
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile(this.time, this.name, this.reason, this.queue);
  final String time;
  final String name;
  final String reason;
  final String queue;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
    leading: Text(
      time,
      style: const TextStyle(
        fontWeight: FontWeight.w800,
        color: AppTheme.primary,
      ),
    ),
    title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(reason),
    trailing: Chip(label: Text(queue)),
  );
}
