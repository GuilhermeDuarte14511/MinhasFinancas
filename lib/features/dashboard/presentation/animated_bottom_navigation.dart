import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

final class AppBottomNavigationDestination {
  const AppBottomNavigationDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.iconSize = 25,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final double iconSize;
}

class AnimatedBottomNavigationBar extends StatelessWidget {
  const AnimatedBottomNavigationBar({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
    super.key,
  }) : assert(destinations.length > 1),
       assert(selectedIndex >= 0),
       assert(selectedIndex < destinations.length);

  static const _duration = Duration(milliseconds: 340);
  static const _curve = Curves.easeOutCubic;

  final int selectedIndex;
  final List<AppBottomNavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        theme.navigationBarTheme.backgroundColor ??
        theme.colorScheme.surfaceContainer;
    final indicatorColor =
        theme.navigationBarTheme.indicatorColor ??
        AppColors.primary.withValues(alpha: .12);

    return Material(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: Container(
          height: 84,
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.outline.withValues(alpha: .45),
              ),
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / destinations.length;
              final indicatorWidth = itemWidth - 8;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositioned(
                    duration: _duration,
                    curve: _curve,
                    left: itemWidth * selectedIndex + 4,
                    top: 0,
                    width: indicatorWidth,
                    height: 70,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: indicatorColor,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: .08),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var index = 0; index < destinations.length; index++)
                        Expanded(
                          child: _AnimatedBottomNavigationItem(
                            destination: destinations[index],
                            selected: index == selectedIndex,
                            duration: _duration,
                            curve: _curve,
                            onTap: () => onDestinationSelected(index),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedBottomNavigationItem extends StatelessWidget {
  const _AnimatedBottomNavigationItem({
    required this.destination,
    required this.selected,
    required this.duration,
    required this.curve,
    required this.onTap,
  });

  final AppBottomNavigationDestination destination;
  final bool selected;
  final Duration duration;
  final Curve curve;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected
        ? AppColors.primary
        : AppColors.textMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: Tooltip(
        message: destination.label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSlide(
                  duration: duration,
                  curve: curve,
                  offset: selected ? const Offset(0, -.08) : Offset.zero,
                  child: AnimatedScale(
                    duration: duration,
                    curve: curve,
                    scale: selected ? 1.13 : 1,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutBack,
                      switchOutCurve: Curves.easeIn,
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        selected
                            ? destination.selectedIcon
                            : destination.icon,
                        key: ValueKey(selected),
                        size: destination.iconSize,
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: curve,
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: selected ? 12.5 : 11.5,
                    height: 1,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      destination.label,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  width: selected ? 18 : 0,
                  height: 3,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(99),
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
