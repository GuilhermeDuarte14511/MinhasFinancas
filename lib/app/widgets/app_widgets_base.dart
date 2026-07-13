import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/money/money.dart';
import '../navigation/workspace_history_navigation.dart';
import '../theme/app_theme.dart';

class AppContent extends StatelessWidget {
  const AppContent({
    required this.child,
    this.maxWidth = 720,
    this.padding = const EdgeInsets.fromLTRB(20, 24, 20, 32),
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width <= 360;
    final resolvedPadding = compact
        ? padding.copyWith(
            left: padding.left.clamp(0, 16),
            right: padding.right.clamp(0, 16),
          )
        : padding;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 0, maxWidth: maxWidth),
        child: SizedBox(
          width: double.infinity,
          child: Padding(padding: resolvedPadding, child: child),
        ),
      ),
    );
  }
}

class AnimatedPageEntry extends StatefulWidget {
  const AnimatedPageEntry({
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 520),
    this.offset = const Offset(0, 0.08),
    super.key,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset offset;

  @override
  State<AnimatedPageEntry> createState() => _AnimatedPageEntryState();
}

class _AnimatedPageEntryState extends State<AnimatedPageEntry>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _slide = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future<void>.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

class StaggeredColumn extends StatelessWidget {
  const StaggeredColumn({
    required this.children,
    this.initialDelay = Duration.zero,
    this.step = const Duration(milliseconds: 80),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.spacing = 0,
    super.key,
  });

  final List<Widget> children;
  final Duration initialDelay;
  final Duration step;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          AnimatedPageEntry(
            delay: initialDelay + step * index,
            child: children[index],
          ),
          if (index < children.length - 1) SizedBox(height: spacing),
        ],
      ],
    );
  }
}

class AnimatedPageSwitcher extends StatelessWidget {
  const AnimatedPageSwitcher({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    return AnimatedSwitcher(
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => disableAnimations
          ? child
          : FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.02, 0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
      child: KeyedSubtree(key: ValueKey(child.runtimeType), child: child),
    );
  }
}

class ShakeOnError extends StatefulWidget {
  const ShakeOnError({
    required this.trigger,
    required this.child,
    this.duration = const Duration(milliseconds: 420),
    this.amplitude = 10,
    super.key,
  });

  final int trigger;
  final Widget child;
  final Duration duration;
  final double amplitude;

  @override
  State<ShakeOnError> createState() => _ShakeOnErrorState();
}

class _ShakeOnErrorState extends State<ShakeOnError>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _offset;
  int _seenTrigger = 0;

  @override
  void initState() {
    super.initState();
    _seenTrigger = widget.trigger;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _offset = _buildAnimation();
    if (widget.trigger > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward(from: 0);
      });
    }
  }

  Animation<double> _buildAnimation() {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -widget.amplitude,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -widget.amplitude,
          end: widget.amplitude,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: widget.amplitude,
          end: -widget.amplitude / 2,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -widget.amplitude / 2,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 20,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant ShakeOnError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger != _seenTrigger) {
      _seenTrigger = widget.trigger;
      _controller
        ..duration = widget.duration
        ..reset()
        ..forward();
      _offset = _buildAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) =>
          Transform.translate(offset: Offset(_offset.value, 0), child: child),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({this.size = 64, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(size * .28),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        Icons.price_check_rounded,
        color: AppColors.primary,
        size: size * .52,
      ),
    );
  }
}

class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BrandAppBar({
    this.title = 'Nossa Grana',
    this.showBack = false,
    this.actions,
    super.key,
  });

  final String title;
  final bool showBack;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      automaticallyImplyLeading: showBack,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (!showBack) ...[
            const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(Icons.people_alt_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      actions: actions,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final historyDestination = switch (title) {
      'Movimentações recentes' => WorkspaceHistoryDestination.movements,
      'Atividades do espaço' => WorkspaceHistoryDestination.activities,
      _ => null,
    };
    final resolvedActionLabel =
        actionLabel ?? (historyDestination == null ? null : 'Ver mais');
    final resolvedOnAction =
        onAction ??
        (historyDestination == null
            ? null
            : () {
                openWorkspaceHistory(context, historyDestination);
              });

    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (resolvedActionLabel != null)
          TextButton(
            onPressed: resolvedOnAction,
            child: Text(resolvedActionLabel),
          ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.color = AppColors.secondary,
    super.key,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrencyField extends StatefulWidget {
  const CurrencyField({
    required this.label,
    required this.onChanged,
    this.initialCents = 0,
    this.large = false,
    super.key,
  });

  final String label;
  final ValueChanged<Money> onChanged;
  final int initialCents;
  final bool large;

  @override
  State<CurrencyField> createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: CurrencyInputFormatter.formatCents(widget.initialCents),
    );
  }

  @override
  void didUpdateWidget(covariant CurrencyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCents == oldWidget.initialCents) return;
    final formatted = CurrencyInputFormatter.formatCents(widget.initialCents);
    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: const [CurrencyInputFormatter()],
      textAlign: widget.large ? TextAlign.center : TextAlign.start,
      style: widget.large
          ? const TextStyle(
              color: AppColors.primary,
              fontSize: 36,
              fontWeight: FontWeight.w700,
            )
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '0,00',
        prefixText: 'R\$ ',
        prefixStyle: widget.large
            ? const TextStyle(
                color: AppColors.primary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              )
            : null,
      ),
      validator: (value) {
        final cents = CurrencyInputFormatter.centsFromText(value ?? '');
        return cents <= 0 ? 'Informe um valor maior que zero.' : null;
      },
      onChanged: (value) {
        final cents = CurrencyInputFormatter.centsFromText(value);
        widget.onChanged(Money.fromCents(cents));
      },
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  const CurrencyInputFormatter();

  static int centsFromText(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  static String formatCents(int cents) {
    if (cents == 0) return '';
    return Money.fromCents(cents).format().replaceFirst('R\$ ', '');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final cents = centsFromText(newValue.text);
    final formatted = formatCents(cents);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class AnimatedMoneyText extends StatelessWidget {
  const AnimatedMoneyText({
    required this.value,
    required this.style,
    this.duration = const Duration(milliseconds: 520),
    this.textAlign,
    super.key,
  });

  final Money value;
  final TextStyle? style;
  final Duration duration;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final effectiveDuration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : duration;
    return TweenAnimationBuilder<int>(
      tween: IntTween(end: value.cents),
      duration: effectiveDuration,
      curve: Curves.easeOutCubic,
      builder: (context, cents, _) => Text(
        Money.fromCents(cents).format(),
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

void showSuccessMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: AppColors.secondary,
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
}
