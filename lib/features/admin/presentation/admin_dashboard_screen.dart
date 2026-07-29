import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_widgets.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int selected = 0;

  static const menu = [
    (Icons.dashboard_outlined, 'Dashboard'),
    (Icons.medical_services_outlined, 'Dokter'),
    (Icons.people_outline, 'Pasien'),
    (Icons.calendar_month_outlined, 'Appointment'),
    (Icons.payments_outlined, 'Pembayaran'),
    (Icons.analytics_outlined, 'Laporan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MediaQuery.sizeOf(context).width < 900
          ? Drawer(child: _navigation())
          : null,
      appBar: AppBar(
        title: const Text('SehatKu Operations'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Row(
        children: [
          if (MediaQuery.sizeOf(context).width >= 900)
            SizedBox(width: 240, child: _navigation()),
          Expanded(child: _dashboard()),
        ],
      ),
    );
  }

  Widget _navigation() => ColoredBox(
    color: AppTheme.navy,
    child: SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'SehatKu HMS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(menu.length, (index) {
            final item = menu[index];
            return ListTile(
              selected: selected == index,
              selectedTileColor: Colors.white.withValues(alpha: .12),
              leading: Icon(item.$1, color: Colors.white70),
              title: Text(item.$2, style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => selected = index);
                if (MediaQuery.sizeOf(context).width < 900 &&
                    Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            );
          }),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'Admin • Production environment',
              style: TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _dashboard() => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Hospital overview',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),
        const Text(
          'Ringkasan operasional hari ini, diperbarui secara real-time.',
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 1000
                ? 4
                : constraints.maxWidth > 560
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              childAspectRatio: 2.35,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: const [
                MetricCard(
                  label: 'Pasien aktif',
                  value: '2.847',
                  icon: Icons.people_outline,
                ),
                MetricCard(
                  label: 'Dokter aktif',
                  value: '86',
                  icon: Icons.medical_services_outlined,
                  color: Colors.indigo,
                ),
                MetricCard(
                  label: 'Appointment',
                  value: '142',
                  icon: Icons.calendar_month,
                  color: Colors.orange,
                ),
                MetricCard(
                  label: 'Pendapatan hari ini',
                  value: 'Rp128 jt',
                  icon: Icons.trending_up,
                  color: AppTheme.success,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final cards = [_analyticsCard(context), _appointmentCard(context)];
            return constraints.maxWidth > 850
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: cards[0]),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: cards[1]),
                    ],
                  )
                : Column(
                    children: [cards[0], const SizedBox(height: 16), cards[1]],
                  );
          },
        ),
      ],
    ),
  );

  Widget _analyticsCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kunjungan pasien',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Text('7 hari terakhir'),
          const SizedBox(height: 24),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                final values = [90.0, 130.0, 105.0, 170.0, 145.0, 190.0, 160.0];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: values[index],
                              decoration: BoxDecoration(
                                color: index == 5
                                    ? AppTheme.primary
                                    : const Color(0xFFB8DEDD),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          [
                            'Sen',
                            'Sel',
                            'Rab',
                            'Kam',
                            'Jum',
                            'Sab',
                            'Min',
                          ][index],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _appointmentCard(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment terbaru',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const _AdminRow(
            'Nadia Putri',
            'dr. Maya Pratama',
            '09:30',
            Colors.green,
          ),
          const _AdminRow(
            'Raka Mahendra',
            'dr. Bima Santoso',
            '10:00',
            Colors.orange,
          ),
          const _AdminRow(
            'Siti Aisyah',
            'drg. Rafi Akbar',
            '10:30',
            Colors.green,
          ),
          const _AdminRow(
            'Dimas Ardi',
            'dr. Anisa Rahman',
            '11:15',
            Colors.blue,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Kelola appointment'),
            ),
          ),
        ],
      ),
    ),
  );
}

class _AdminRow extends StatelessWidget {
  const _AdminRow(this.patient, this.doctor, this.time, this.color);
  final String patient;
  final String doctor;
  final String time;
  final Color color;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: color.withValues(alpha: .12),
      child: Icon(Icons.person_outline, color: color),
    ),
    title: Text(patient, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(doctor),
    trailing: Text(time),
  );
}
