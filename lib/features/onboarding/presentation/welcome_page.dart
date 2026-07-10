import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: StaggeredColumn(
              initialDelay: const Duration(milliseconds: 60),
              step: const Duration(milliseconds: 90),
              children: [
                Container(
                  height: 190,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 70,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: AppColors.secondaryContainer,
                          child: Icon(Icons.person_rounded, size: 48),
                        ),
                      ),
                      Positioned(
                        right: 70,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Color(0xFFE2DFFF),
                          child: Icon(Icons.person_rounded, size: 48),
                        ),
                      ),
                      BrandMark(size: 56),
                    ],
                  ),
                ),
                Text(
                  'Bem-vindo(a)!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text(
                  'Um espaço financeiro reúne cartões, compras, faturas e membros em um ambiente compartilhado.',
                  textAlign: TextAlign.center,
                ),
                _WelcomeAction(
                  icon: Icons.add_home_rounded,
                  color: AppColors.primary,
                  title: 'Criar um espaço financeiro',
                  subtitle: 'Comece um novo ambiente para vocês.',
                  onTap: () => context.push('/create-space'),
                ),
                const SizedBox(height: 16),
                _WelcomeAction(
                  icon: Icons.mail_rounded,
                  color: AppColors.secondary,
                  title: 'Entrar em um espaço por convite',
                  subtitle: 'Use um código ou link recebido.',
                  onTap: () => context.push('/join-space'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeAction extends StatelessWidget {
  const _WelcomeAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.withValues(alpha: .12),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
