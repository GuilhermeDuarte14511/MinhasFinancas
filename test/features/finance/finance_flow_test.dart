import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/application/finance_controller.dart';
import 'package:nossa_grana/features/finance/application/finance_repository.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';

void main() {
  test('creating a persisted space unlocks the application', () async {
    final repository = _FakeFinanceRepository();
    final container = ProviderContainer.test(
      overrides: [financeRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    expect(
      container.read(financeControllerProvider).hasFinancialSpace,
      isFalse,
    );

    await container
        .read(financeControllerProvider.notifier)
        .createSpace('Casa Nova', colorValue: 0xFF006A63);
    final created = container.read(financeControllerProvider);

    expect(created.hasFinancialSpace, isTrue);
    expect(created.spaceName, 'Casa Nova');
    expect(created.spaceColorValue, 0xFF006A63);
  });

  test(
    'invitation flow persists the selected role and returns a link',
    () async {
      final repository = _FakeFinanceRepository();
      final container = ProviderContainer.test(
        overrides: [financeRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final controller = container.read(financeControllerProvider.notifier);

      await controller.createSpace('Família Silva');
      final link = await controller.inviteMember(
        'bia@example.com',
        role: MembershipRole.viewer,
      );

      expect(link, contains('invite-token'));
      expect(repository.invitedRole, MembershipRole.viewer);
      expect(repository.invitedEmail, 'bia@example.com');
    },
  );

  test(
    'viewer is blocked before a financial mutation reaches the backend',
    () async {
      final repository = _FakeFinanceRepository();
      final container = ProviderContainer.test(
        overrides: [financeRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      final controller = container.read(financeControllerProvider.notifier);

      await controller.createSpace('Família Silva');
      repository.currentRole = MembershipRole.viewer;
      await controller.refresh();

      await expectLater(controller.addCategory('Viagens'), throwsStateError);
    },
  );
}

final class _FakeFinanceRepository implements FinanceRepository {
  WorkspaceSummary? _space;
  String? invitedEmail;
  MembershipRole? invitedRole;
  MembershipRole currentRole = MembershipRole.owner;

  @override
  Future<List<WorkspaceSummary>> listMySpaces() async =>
      _space == null ? const [] : [_space!];

  @override
  Future<WorkspaceSnapshot> loadWorkspace(String spaceId) async {
    final space = _space!;
    return WorkspaceSnapshot(
      id: space.id,
      name: space.name,
      colorValue: space.colorValue,
      cards: const [],
      purchases: const [],
      invoices: const [],
      loans: const [],
      purchaseInstallments: const [],
      loanInstallments: const [],
      activities: const [],
      categories: const ['Outros'],
      categoryIdsByName: const {'Outros': 'category-other'},
      members: [
        MemberRecord(
          id: 'member-1',
          name: 'Guilherme',
          email: 'gui@example.com',
          role: currentRole,
          status: MembershipStatus.active,
          isCurrentUser: true,
        ),
      ],
      invitations: const [],
      currentRole: currentRole,
      notificationSettings: const NotificationSettings(
        enabled: true,
        pushEnabled: false,
        inAppEnabled: true,
        preferredTime: '09:00',
        invoiceClosing: true,
        invoiceDue: true,
        loanDue: true,
        daysBefore: 3,
      ),
    );
  }

  @override
  Future<String> createSpace({
    required String name,
    required int colorValue,
  }) async {
    _space = WorkspaceSummary(
      id: 'space-1',
      name: name,
      colorValue: colorValue,
      role: MembershipRole.owner,
    );
    return _space!.id;
  }

  @override
  Future<String> createInvitation({
    required String spaceId,
    required String email,
    required MembershipRole role,
  }) async {
    invitedEmail = email;
    invitedRole = role;
    return 'https://example.test/join-space?invite=invite-token';
  }

  @override
  Future<String> acceptInvitation(String tokenOrLink) async => 'member-1';

  @override
  Future<void> updateSpace({
    required String spaceId,
    required String name,
    required int colorValue,
  }) async {}

  @override
  Future<void> archiveSpace({required String spaceId}) async {}

  @override
  Future<void> revokeInvitation({
    required String spaceId,
    required String invitationId,
  }) async {}

  @override
  Future<void> updateMemberRole({
    required String spaceId,
    required String memberId,
    required MembershipRole role,
  }) async {}

  @override
  Future<void> removeMember({
    required String spaceId,
    required String memberId,
  }) async {}

  @override
  Future<void> createCategory({
    required String spaceId,
    required String name,
  }) async {}

  @override
  Future<void> updateCategory({
    required String spaceId,
    required String categoryId,
    required String name,
  }) async {}

  @override
  Future<void> archiveCategory({
    required String spaceId,
    required String categoryId,
  }) async {}

  @override
  Future<void> createCard({
    required String spaceId,
    required String nickname,
    required String lastFourDigits,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {}

  @override
  Future<void> updateCard({
    required String spaceId,
    required String cardId,
    required String nickname,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {}

  @override
  Future<void> archiveCard({
    required String spaceId,
    required String cardId,
  }) async {}

  @override
  Future<void> createPurchase({
    required String spaceId,
    required String description,
    required String categoryId,
    required String cardId,
    required Money total,
    required int installmentCount,
    required DateTime purchaseDate,
    required int cardClosingDay,
    required int cardDueDay,
  }) async {}

  @override
  Future<void> updatePurchase({
    required String spaceId,
    required String purchaseId,
    required String description,
    required String categoryId,
  }) async {}

  @override
  Future<void> cancelPurchase({
    required String spaceId,
    required String purchaseId,
  }) async {}

  @override
  Future<void> registerInvoicePayment({
    required String spaceId,
    required String invoiceId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
  }) async {}

  @override
  Future<void> createLoan({
    required String spaceId,
    required String lender,
    required String description,
    required Money amount,
    required Money installmentAmount,
    required int installmentCount,
    required int dueDay,
  }) async {}

  @override
  Future<void> registerLoanPayment({
    required String spaceId,
    required String loanId,
    required String installmentId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
  }) async {}

  @override
  Future<void> updateNotificationPreference({
    required String spaceId,
    required NotificationSettings settings,
  }) async {}

  @override
  Future<void> registerNotificationDevice({
    required String token,
    required bool isWeb,
    required String deviceName,
  }) async {}
}
