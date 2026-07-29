import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.action, super.key});
  final String title;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (action != null) TextButton(onPressed: () {}, child: Text(action!)),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppTheme.primary,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: .12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: Theme.of(context).textTheme.titleLarge),
                  Text(label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({required this.title, this.subtitle, super.key});
  final String title;
  final String? subtitle;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 72,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          if (subtitle != null)
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Badge(child: Icon(Icons.notifications_outlined)),
        ),
        PopupMenuButton(
          icon: const CircleAvatar(
            backgroundColor: Color(0xFFE0F4F2),
            child: Icon(Icons.person, color: AppTheme.primary),
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              onTap: () => context.go('/login'),
              child: const ListTile(
                leading: Icon(Icons.logout),
                title: Text('Keluar'),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
