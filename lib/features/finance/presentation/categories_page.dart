import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(financeControllerProvider).categories;
    return Scaffold(
      appBar: const BrandAppBar(title: 'Categorias', showBack: true),
      body: SafeArea(
        child: AppContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Organize os gastos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              const Text(
                'As categorias são compartilhadas com todos do espaço.',
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Card(
                  child: ListView.separated(
                    itemCount: categories.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) => ListTile(
                      minTileHeight: 66,
                      leading: CircleAvatar(
                        backgroundColor: index.isEven
                            ? const Color(0xFFE2DFFF)
                            : AppColors.secondaryContainer,
                        child: Icon(
                          _categoryIcon(categories[index]),
                          color: index.isEven
                              ? AppColors.primary
                              : AppColors.secondary,
                        ),
                      ),
                      title: Text(categories[index]),
                      trailing: const Icon(Icons.drag_handle_rounded),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => _showAddCategory(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Nova categoria'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddCategory(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final category = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova categoria'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (category != null && category.length >= 2) {
      try {
        await ref
            .read(financeControllerProvider.notifier)
            .addCategory(category);
        if (context.mounted) {
          showSuccessMessage(context, 'Categoria adicionada.');
        }
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(financeControllerProvider).errorMessage ??
                    'Não foi possível criar a categoria.',
              ),
            ),
          );
        }
      }
    }
  }
}

IconData _categoryIcon(String category) => switch (category) {
  'Mercado' => Icons.shopping_cart_outlined,
  'Casa' => Icons.home_outlined,
  'Alimentação' => Icons.restaurant_outlined,
  'Transporte' => Icons.directions_car_outlined,
  'Saúde' => Icons.health_and_safety_outlined,
  'Lazer' => Icons.movie_outlined,
  'Assinaturas' => Icons.subscriptions_outlined,
  'Educação' => Icons.school_outlined,
  _ => Icons.category_outlined,
};
