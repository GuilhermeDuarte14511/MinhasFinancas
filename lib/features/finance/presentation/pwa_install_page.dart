import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';

class PwaInstallPage extends StatelessWidget {
  const PwaInstallPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        appBar: const BrandAppBar(
          title: 'Aplicativo instalado',
          showBack: true,
        ),
        body: const SafeArea(
          child: AppContent(
            maxWidth: 620,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 48,
                      color: AppColors.secondary,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Você já está usando o aplicativo instalado.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final steps = switch (defaultTargetPlatform) {
      TargetPlatform.iOS => const [
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
        (
          '3',
          'Adicionar à Tela de Início',
          'Role o menu e escolha essa opção.',
        ),
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
      ],
      TargetPlatform.android => const [
        (
          '1',
          'Abra no Chrome',
          'Acesse o Nossa Grana usando o navegador Chrome.',
        ),
        (
          '2',
          'Abra o menu',
          'Toque nos três pontos no canto superior da tela.',
        ),
        (
          '3',
          'Toque em “Instalar app”',
          'Em alguns aparelhos aparece “Adicionar à tela inicial”.',
        ),
        (
          '4',
          'Confirme a instalação',
          'O Nossa Grana aparecerá junto aos seus aplicativos.',
        ),
      ],
      _ => const [
        (
          '1',
          'Abra no Chrome ou Edge',
          'Use um navegador compatível com aplicativos da Web.',
        ),
        (
          '2',
          'Clique em Instalar',
          'Use o ícone de instalação na barra de endereços.',
        ),
        ('3', 'Confirme', 'O Nossa Grana abrirá em uma janela própria.'),
      ],
    };
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
                Text(
                  isIos
                      ? 'Acesse mais rápido e use como um aplicativo no iPhone.'
                      : 'Acesse mais rápido e use em uma janela própria.',
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
                            backgroundColor: step == steps.last
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
