import '../../../core/money/money.dart';
import '../domain/finance_models.dart';

final class WorkspaceSummary {
  const WorkspaceSummary({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.role,
  });

  final String id;
  final String name;
  final int colorValue;
  final MembershipRole role;
}

final class WorkspaceSnapshot {
  const WorkspaceSnapshot({
    required this.id,
    required this.name,
    required this.colorValue,
    required this.cards,
    required this.purchases,
    required this.purchaseInstallments,
    required this.invoices,
    required this.loans,
    required this.loanInstallments,
    required this.activities,
    required this.categories,
    required this.categoryIdsByName,
    required this.members,
    required this.invitations,
    required this.currentRole,
    required this.notificationSettings,
  });

  final String id;
  final String name;
  final int colorValue;
  final List<CreditCardAccount> cards;
  final List<PurchaseRecord> purchases;
  final List<PurchaseInstallmentRecord> purchaseInstallments;
  final List<InvoiceSummary> invoices;
  final List<LoanContract> loans;
  final List<LoanInstallmentRecord> loanInstallments;
  final List<ActivityEntry> activities;
  final List<String> categories;
  final Map<String, String> categoryIdsByName;
  final List<MemberRecord> members;
  final List<InvitationRecord> invitations;
  final MembershipRole currentRole;
  final NotificationSettings notificationSettings;
}

abstract interface class FinanceRepository {
  Future<List<WorkspaceSummary>> listMySpaces();

  Future<WorkspaceSnapshot> loadWorkspace(String spaceId);

  Future<String> createSpace({required String name, required int colorValue});

  Future<void> updateSpace({
    required String spaceId,
    required String name,
    required int colorValue,
  });

  Future<void> archiveSpace({required String spaceId});

  Future<String> createInvitation({
    required String spaceId,
    required String email,
    required MembershipRole role,
  });

  Future<String> acceptInvitation(String tokenOrLink);

  Future<void> revokeInvitation({
    required String spaceId,
    required String invitationId,
  });

  Future<void> updateMemberRole({
    required String spaceId,
    required String memberId,
    required MembershipRole role,
  });

  Future<void> removeMember({
    required String spaceId,
    required String memberId,
  });

  Future<void> createCategory({required String spaceId, required String name});

  Future<void> updateCategory({
    required String spaceId,
    required String categoryId,
    required String name,
  });

  Future<void> archiveCategory({
    required String spaceId,
    required String categoryId,
  });

  Future<void> createCard({
    required String spaceId,
    required String nickname,
    required String lastFourDigits,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  });

  Future<void> updateCard({
    required String spaceId,
    required String cardId,
    required String nickname,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  });

  Future<void> archiveCard({required String spaceId, required String cardId});

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
  });

  Future<void> updatePurchase({
    required String spaceId,
    required String purchaseId,
    required String description,
    required String categoryId,
  });

  Future<void> cancelPurchase({
    required String spaceId,
    required String purchaseId,
  });

  Future<void> registerInvoicePayment({
    required String spaceId,
    required String invoiceId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
  });

  Future<void> createLoan({
    required String spaceId,
    required String lender,
    required String description,
    required Money amount,
    required Money installmentAmount,
    required int installmentCount,
    required int dueDay,
  });

  Future<void> registerLoanPayment({
    required String spaceId,
    required String loanId,
    required String installmentId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
  });

  Future<void> updateNotificationPreference({
    required String spaceId,
    required NotificationSettings settings,
  });

  Future<void> registerNotificationDevice({
    required String token,
    required bool isWeb,
    required String deviceName,
  });
}
