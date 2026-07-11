import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const questions = [
      (
        'Como compartilhar meu espaço?',
        'Abra Mais, entre em Espaço financeiro e membros e toque em adicionar membro. Você poderá copiar um link de convite seguro.',
      ),
      (
        'Como funciona uma compra parcelada?',
        'Cada parcela é vinculada à fatura correta conforme o fechamento do cartão. O limite comprometido e as faturas são atualizados para todos os membros.',
      ),
      (
        'Posso registrar um pagamento parcial?',
        'Sim. Na fatura, escolha Registrar pagamento e informe qualquer valor até o saldo pendente.',
      ),
      (
        'Meus dados aparecem para todos?',
        'Somente membros do mesmo espaço financeiro acessam seus dados. As ações disponíveis dependem do papel de proprietário, editor ou visualizador.',
      ),
      (
        'O que fazer quando estiver sem internet?',
        'Confira sua conexão e tente novamente. Para evitar conflitos, novas alterações precisam ser confirmadas pelo servidor.',
      ),
    ];
    return Scaffold(
      appBar: const BrandAppBar(title: 'Ajuda', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 46,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Como podemos ajudar?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Encontre respostas rápidas sobre o Nossa Grana.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                const SectionHeading(title: 'Dúvidas frequentes'),
                const SizedBox(height: 12),
                Card(
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < questions.length;
                        index++
                      ) ...[
                        ExpansionTile(
                          leading: const Icon(
                            Icons.help_outline_rounded,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            questions[index].$1,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          childrenPadding: const EdgeInsets.fromLTRB(
                            20,
                            0,
                            20,
                            20,
                          ),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(questions[index].$2)],
                        ),
                        if (index < questions.length - 1)
                          const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Card(
                  color: AppColors.surfaceLow,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Nunca compartilhe sua senha ou códigos de acesso, nem mesmo com outros membros do espaço.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
