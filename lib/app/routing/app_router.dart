import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/create_account_page.dart';
import '../../features/auth/presentation/email_verification_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/dashboard/presentation/app_shell.dart';
import '../../features/finance/presentation/add_card_page.dart';
import '../../features/finance/presentation/add_loan_page.dart';
import '../../features/finance/presentation/add_purchase_page.dart';
import '../../features/finance/presentation/categories_page.dart';
import '../../features/finance/presentation/invoice_detail_page.dart';
import '../../features/finance/presentation/loans_page.dart';
import '../../features/finance/presentation/members_page.dart';
import '../../features/finance/presentation/notifications_page.dart';
import '../../features/finance/presentation/payment_page.dart';
import '../../features/finance/presentation/pwa_install_page.dart';
import '../../features/finance/presentation/purchase_detail_page.dart';
import '../../features/onboarding/presentation/create_space_page.dart';
import '../../features/onboarding/presentation/entry_gate_page.dart';
import '../../features/onboarding/presentation/invite_member_page.dart';
import '../../features/onboarding/presentation/join_space_page.dart';
import '../../features/onboarding/presentation/welcome_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _authRefreshNotifier = _AuthRefreshNotifier();

final appRouter = GoRouter(
  initialLocation: '/gate',
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final location = state.matchedLocation;
    final isAuthRoute = location == '/login' || location == '/create-account';
    final requestedRedirect = state.uri.queryParameters['redirect'];
    final safeRedirect = requestedRedirect?.startsWith('/') == true
        ? requestedRedirect
        : null;

    if (user == null) {
      if (isAuthRoute) return null;
      return '/login?redirect=${Uri.encodeComponent(state.uri.toString())}';
    }
    if (!user.emailVerified) {
      if (location == '/verify-email') return null;
      final destination = safeRedirect ?? state.uri.toString();
      return '/verify-email?redirect=${Uri.encodeComponent(destination)}';
    }
    if (isAuthRoute || location == '/verify-email') {
      return safeRedirect ?? '/gate';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/gate',
      pageBuilder: (context, state) => _animatedPage(
        state,
        const EntryGatePage(),
        offset: const Offset(0, .02),
      ),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _animatedPage(state, const LoginPage()),
    ),
    GoRoute(
      path: '/create-account',
      pageBuilder: (context, state) =>
          _animatedPage(state, const CreateAccountPage()),
    ),
    GoRoute(
      path: '/verify-email',
      pageBuilder: (context, state) =>
          _animatedPage(state, const EmailVerificationPage()),
    ),
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) =>
          _animatedPage(state, const WelcomePage()),
    ),
    GoRoute(
      path: '/create-space',
      pageBuilder: (context, state) =>
          _animatedPage(state, const CreateSpacePage()),
    ),
    GoRoute(
      path: '/join-space',
      pageBuilder: (context, state) => _animatedPage(
        state,
        JoinSpacePage(initialInvite: state.uri.queryParameters['invite']),
      ),
    ),
    GoRoute(
      path: '/invite-member',
      pageBuilder: (context, state) => _animatedPage(
        state,
        InviteMemberPage(
          onboarding: state.uri.queryParameters['onboarding'] == 'true',
        ),
      ),
    ),
    GoRoute(
      path: '/app/:section',
      pageBuilder: (context, state) => NoTransitionPage(
        child: AppShell(section: state.pathParameters['section'] ?? 'home'),
      ),
    ),
    GoRoute(
      path: '/new-purchase',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _animatedPage(state, const AddPurchasePage()),
    ),
    GoRoute(
      path: '/new-card',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _animatedPage(state, const AddCardPage()),
    ),
    GoRoute(
      path: '/new-loan',
      pageBuilder: (context, state) =>
          _animatedPage(state, const AddLoanPage()),
    ),
    GoRoute(
      path: '/invoice/:invoiceId',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _animatedPage(
        state,
        InvoiceDetailPage(invoiceId: state.pathParameters['invoiceId']!),
      ),
    ),
    GoRoute(
      path: '/invoice/:invoiceId/payment',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _animatedPage(
        state,
        PaymentPage(invoiceId: state.pathParameters['invoiceId']!),
      ),
    ),
    GoRoute(
      path: '/purchase/:purchaseId',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _animatedPage(
        state,
        PurchaseDetailPage(purchaseId: state.pathParameters['purchaseId']!),
      ),
    ),
    GoRoute(
      path: '/loans',
      pageBuilder: (context, state) => _animatedPage(state, const LoansPage()),
    ),
    GoRoute(
      path: '/categories',
      pageBuilder: (context, state) =>
          _animatedPage(state, const CategoriesPage()),
    ),
    GoRoute(
      path: '/members',
      pageBuilder: (context, state) =>
          _animatedPage(state, const MembersPage()),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) =>
          _animatedPage(state, const NotificationsPage()),
    ),
    GoRoute(
      path: '/install',
      pageBuilder: (context, state) =>
          _animatedPage(state, const PwaInstallPage()),
    ),
  ],
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 16),
            Text('Não foi possível abrir esta página: ${state.uri.path}'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => context.go('/app/home'),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  ),
);

CustomTransitionPage<void> _animatedPage(
  GoRouterState state,
  Widget child, {
  Offset offset = const Offset(.035, 0),
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: offset,
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
