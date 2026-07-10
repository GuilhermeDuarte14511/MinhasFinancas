import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';

class PwaInstallPage extends StatelessWidget {
  const PwaInstallPage({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      (
        '1',
        'Abra no Safari',
        'A instalação pelo iPhone funciona diretamente no Safari.',
      ),
      (
        '2',
        'Toque em Compartilhar',
        'Use o ícone de quadrado com uma seta para cima.',
      ),
      ('3', 'Adicionar à Tela de Início', 'Role o menu e escolha essa opção.'),
      (
        '4',
        'Ative “Abrir como App da Web”',
        'Isso deixa a experiência em tela cheia.',
      ),
      (
        '5',
        'Toque em Adicionar',
        'O Nossa Grana aparecerá junto aos seus aplicativos.',
      ),
    ];
    return Scaffold(
      appBar: const BrandAppBar(title: 'Instalar aplicativo', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const BrandMark(size: 78),
                const SizedBox(height: 24),
                Text(
                  'Nossa Grana na tela inicial',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Acesse mais rápido e use como um aplicativo no iPhone.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                for (final step in steps) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: step.$1 == '5'
                                ? AppColors.secondary
                                : AppColors.primaryContainer,
                            foregroundColor: Colors.white,
                            child: Text(step.$1),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.$2,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 3),
                                Text(step.$3),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
