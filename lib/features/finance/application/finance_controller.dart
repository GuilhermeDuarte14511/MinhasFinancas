import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/money/money.dart';
import '../domain/finance_models.dart';
import 'finance_repository.dart';

final financeRepositoryProvider = Provider<FinanceRepository>((ref) {
  throw UnimplementedError('FinanceRepository não foi configurado.');
});

final financeControllerProvider =
    NotifierProvider<FinanceController, FinanceState>(FinanceController.new);

final class FinanceState {
  const FinanceState({
    required this.hasFinancialSpace,
    required this.spaceId,
    required this.userName,
    required this.email,
    required this.spaceName,
    required this.spaceColorValue,
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
    required this.availableSpaces,
    required this.currentRole,
    required this.notificationSettings,
    required this.isLoading,
    required this.errorMessage,
  });

  final bool hasFinancialSpace;
  final String? spaceId;
  final String userName;
  final String email;
  final String spaceName;
  final int spaceColorValue;
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
  final List<WorkspaceSummary> availableSpaces;
  final MembershipRole currentRole;
  final NotificationSettings notificationSettings;
  final bool isLoading;
  final String? errorMessage;

  bool get notificationsEnabled => notificationSettings.enabled;
  bool get canEdit => currentRole != MembershipRole.viewer;
  bool get isOwner => currentRole == MembershipRole.owner;

  Money get totalLimit =>
      cards.fold(const Money.zero(), (total, card) => total + card.limit);

  Money get availableLimit =>
      cards.fold(const Money.zero(), (total, card) => total + card.available);

  List<InvoiceSummary> get currentInvoices {
    final now = DateTime.now();
    return invoices
        .where(
          (invoice) =>
              invoice.referenceMonth.year == now.year &&
              invoice.referenceMonth.month == now.month,
        )
        .toList();
  }

  Money get invoiceTotal => currentInvoices.fold(
    const Money.zero(),
    (total, invoice) => total + invoice.total,
  );

  Money get paidTotal => currentInvoices.fold(
    const Money.zero(),
    (total, invoice) => total + invoice.paid,
  );

  Money get pendingTotal => invoiceTotal - paidTotal;

  FinanceState copyWith({
    bool? hasFinancialSpace,
    String? spaceId,
    bool clearSpaceId = false,
    String? userName,
    String? email,
    String? spaceName,
    int? spaceColorValue,
    List<CreditCardAccount>? cards,
    List<PurchaseRecord>? purchases,
    List<PurchaseInstallmentRecord>? purchaseInstallments,
    List<InvoiceSummary>? invoices,
    List<LoanContract>? loans,
    List<LoanInstallmentRecord>? loanInstallments,
    List<ActivityEntry>? activities,
    List<String>? categories,
    Map<String, String>? categoryIdsByName,
    List<MemberRecord>? members,
    List<InvitationRecord>? invitations,
    List<WorkspaceSummary>? availableSpaces,
    MembershipRole? currentRole,
    NotificationSettings? notificationSettings,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) => FinanceState(
    hasFinancialSpace: hasFinancialSpace ?? this.hasFinancialSpace,
    spaceId: clearSpaceId ? null : spaceId ?? this.spaceId,
    userName: userName ?? this.userName,
    email: email ?? this.email,
    spaceName: spaceName ?? this.spaceName,
    spaceColorValue: spaceColorValue ?? this.spaceColorValue,
    cards: cards ?? this.cards,
    purchases: purchases ?? this.purchases,
    purchaseInstallments: purchaseInstallments ?? this.purchaseInstallments,
    invoices: invoices ?? this.invoices,
    loans: loans ?? this.loans,
    loanInstallments: loanInstallments ?? this.loanInstallments,
    activities: activities ?? this.activities,
    categories: categories ?? this.categories,
    categoryIdsByName: categoryIdsByName ?? this.categoryIdsByName,
    members: members ?? this.members,
    invitations: invitations ?? this.invitations,
    availableSpaces: availableSpaces ?? this.availableSpaces,
    currentRole: currentRole ?? this.currentRole,
    notificationSettings: notificationSettings ?? this.notificationSettings,
    isLoading: isLoading ?? this.isLoading,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}

final class FinanceController extends Notifier<FinanceState> {
  FinanceRepository get _repository => ref.read(financeRepositoryProvider);

  @override
  FinanceState build() {
    final timer = Timer.periodic(const Duration(seconds: 30), (_) async {
      if (state.spaceId != null && !state.isLoading) {
        try {
          await refresh();
        } catch (_) {
          // The current snapshot remains usable while connectivity recovers.
        }
      }
    });
    ref.onDispose(timer.cancel);
    return const FinanceState(
      hasFinancialSpace: false,
      spaceId: null,
      userName: 'Você',
      email: '',
      spaceName: 'Nossa Grana',
      spaceColorValue: 0xFF3525CD,
      cards: [],
      purchases: [],
      purchaseInstallments: [],
      invoices: [],
      loans: [],
      loanInstallments: [],
      activities: [],
      categories: [],
      categoryIdsByName: {},
      members: [],
      invitations: [],
      availableSpaces: [],
      currentRole: MembershipRole.viewer,
      notificationSettings: NotificationSettings(
        enabled: true,
        pushEnabled: false,
        inAppEnabled: true,
        preferredTime: '09:00',
        invoiceClosing: true,
        invoiceDue: true,
        loanDue: true,
        daysBefore: 3,
      ),
      isLoading: false,
      errorMessage: null,
    );
  }

  void updateProfile({required String name, required String email}) {
    state = state.copyWith(userName: name, email: email);
  }

  Future<bool> resolveWorkspace() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final spaces = await _repository.listMySpaces();
      if (spaces.isEmpty) {
        state = state.copyWith(
          hasFinancialSpace: false,
          clearSpaceId: true,
          isLoading: false,
          availableSpaces: spaces,
        );
        return false;
      }
      state = state.copyWith(availableSpaces: spaces);
      await _loadWorkspace(spaces.first.id);
      return true;
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> refresh() async {
    final spaceId = state.spaceId;
    if (spaceId == null) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> selectWorkspace(String spaceId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> createSpace(String name, {int colorValue = 0xFF3525CD}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final spaceId = await _repository.createSpace(
        name: name,
        colorValue: colorValue,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> updateSpace({
    required String name,
    required int colorValue,
  }) async {
    final spaceId = _requireSpaceId();
    _requireOwner();
    try {
      await _repository.updateSpace(
        spaceId: spaceId,
        name: name,
        colorValue: colorValue,
      );
      await _reloadSpacesAndWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<bool> archiveCurrentSpace() async {
    final spaceId = _requireSpaceId();
    _requireOwner();
    try {
      await _repository.archiveSpace(spaceId: spaceId);
      resetWorkspaceSelection();
      return resolveWorkspace();
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> joinSpace(String tokenOrLink) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.acceptInvitation(tokenOrLink);
      final spaces = await _repository.listMySpaces();
      if (spaces.isEmpty) {
        throw StateError('O espaço do convite não foi encontrado.');
      }
      await _loadWorkspace(spaces.first.id);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<String> inviteMember(
    String email, {
    MembershipRole role = MembershipRole.editor,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      final link = await _repository.createInvitation(
        spaceId: spaceId,
        email: email,
        role: role,
      );
      await _loadWorkspace(spaceId);
      return link;
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> revokeInvitation(String invitationId) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.revokeInvitation(
        spaceId: spaceId,
        invitationId: invitationId,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> updateMemberRole(String memberId, MembershipRole role) async {
    final spaceId = _requireSpaceId();
    _requireOwner();
    try {
      await _repository.updateMemberRole(
        spaceId: spaceId,
        memberId: memberId,
        role: role,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> removeMember(String memberId) async {
    final spaceId = _requireSpaceId();
    _requireOwner();
    try {
      await _repository.removeMember(spaceId: spaceId, memberId: memberId);
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> addCategory(String category) async {
    if (state.categories.any(
      (item) => item.toLowerCase() == category.toLowerCase(),
    )) {
      return;
    }
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.createCategory(spaceId: spaceId, name: category);
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> updateCategory(String categoryId, String name) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.updateCategory(
        spaceId: spaceId,
        categoryId: categoryId,
        name: name,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> archiveCategory(String categoryId) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.archiveCategory(
        spaceId: spaceId,
        categoryId: categoryId,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> addCard({
    required String nickname,
    required String lastFourDigits,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.createCard(
        spaceId: spaceId,
        nickname: nickname,
        lastFourDigits: lastFourDigits,
        limit: limit,
        closingDay: closingDay,
        dueDay: dueDay,
        colorValue: colorValue,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> updateCard({
    required String cardId,
    required String nickname,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.updateCard(
        spaceId: spaceId,
        cardId: cardId,
        nickname: nickname,
        limit: limit,
        closingDay: closingDay,
        dueDay: dueDay,
        colorValue: colorValue,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> archiveCard(String cardId) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.archiveCard(spaceId: spaceId, cardId: cardId);
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> addPurchase({
    required String description,
    required String category,
    required String cardId,
    required Money total,
    required int installmentCount,
    required DateTime purchaseDate,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    final categoryId = state.categoryIdsByName[category];
    if (categoryId == null) throw StateError('Categoria não encontrada.');
    final card = state.cards.firstWhere((item) => item.id == cardId);
    try {
      await _repository.createPurchase(
        spaceId: spaceId,
        description: description,
        categoryId: categoryId,
        cardId: cardId,
        total: total,
        installmentCount: installmentCount,
        purchaseDate: purchaseDate,
        cardClosingDay: card.closingDay,
        cardDueDay: card.dueDay,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> updatePurchaseDetails({
    required String purchaseId,
    required String description,
    required String category,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    final categoryId = state.categoryIdsByName[category];
    if (categoryId == null) throw StateError('Categoria não encontrada.');
    try {
      await _repository.updatePurchase(
        spaceId: spaceId,
        purchaseId: purchaseId,
        description: description,
        categoryId: categoryId,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> deletePurchase(String purchaseId) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.cancelPurchase(
        spaceId: spaceId,
        purchaseId: purchaseId,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> payInvoice({
    required String invoiceId,
    required Money amount,
    DateTime? paidAt,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    final invoice = state.invoices.firstWhere((item) => item.id == invoiceId);
    final allowed = amount.min(invoice.pending);
    if (allowed.cents <= 0) return;
    try {
      await _repository.registerInvoicePayment(
        spaceId: spaceId,
        invoiceId: invoiceId,
        amount: allowed,
        pendingBeforePayment: invoice.pending,
        paidAt: paidAt ?? DateTime.now(),
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> addLoan({
    required String lender,
    required String description,
    required Money amount,
    required Money installmentAmount,
    required int installmentCount,
    required int dueDay,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    try {
      await _repository.createLoan(
        spaceId: spaceId,
        lender: lender,
        description: description,
        amount: amount,
        installmentAmount: installmentAmount,
        installmentCount: installmentCount,
        dueDay: dueDay,
      );
      await _loadWorkspace(spaceId);
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> payLoan({
    required String loanId,
    required Money amount,
    DateTime? paidAt,
  }) async {
    final spaceId = _requireSpaceId();
    _requireEditor();
    final installments =
        state.loanInstallments
            .where((item) => item.loanId == loanId && item.pending.cents > 0)
            .toList()
          ..sort((a, b) => a.number.compareTo(b.number));
    if (installments.isEmpty) return;
    final installment = installments.first;
    final allowed = amount.min(installment.pending);
    await _repository.registerLoanPayment(
      spaceId: spaceId,
      loanId: loanId,
      installmentId: installment.id,
      amount: allowed,
      pendingBeforePayment: installment.pending,
      paidAt: paidAt ?? DateTime.now(),
    );
    await _loadWorkspace(spaceId);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await updateNotificationSettings(
      state.notificationSettings.copyWith(enabled: enabled),
    );
  }

  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    final spaceId = _requireSpaceId();
    state = state.copyWith(notificationSettings: settings);
    try {
      await _repository.updateNotificationPreference(
        spaceId: spaceId,
        settings: settings,
      );
    } catch (error) {
      _recordError(error);
      rethrow;
    }
  }

  Future<void> registerNotificationDevice({
    required String token,
    required bool isWeb,
    required String deviceName,
  }) => _repository.registerNotificationDevice(
    token: token,
    isWeb: isWeb,
    deviceName: deviceName,
  );

  void resetWorkspaceSelection() {
    state = state.copyWith(
      hasFinancialSpace: false,
      clearSpaceId: true,
      cards: const [],
      purchases: const [],
      purchaseInstallments: const [],
      invoices: const [],
      loans: const [],
      loanInstallments: const [],
      activities: const [],
      categories: const [],
      categoryIdsByName: const {},
      members: const [],
      invitations: const [],
      clearError: true,
    );
  }

  Future<void> _loadWorkspace(String spaceId) async {
    final snapshot = await _repository.loadWorkspace(spaceId);
    state = state.copyWith(
      hasFinancialSpace: true,
      spaceId: snapshot.id,
      spaceName: snapshot.name,
      spaceColorValue: snapshot.colorValue,
      cards: snapshot.cards,
      purchases: snapshot.purchases,
      purchaseInstallments: snapshot.purchaseInstallments,
      invoices: snapshot.invoices,
      loans: snapshot.loans,
      loanInstallments: snapshot.loanInstallments,
      activities: snapshot.activities,
      categories: snapshot.categories,
      categoryIdsByName: snapshot.categoryIdsByName,
      members: snapshot.members,
      invitations: snapshot.invitations,
      currentRole: snapshot.currentRole,
      notificationSettings: snapshot.notificationSettings,
      isLoading: false,
      clearError: true,
    );
  }

  Future<void> _reloadSpacesAndWorkspace(String spaceId) async {
    final spaces = await _repository.listMySpaces();
    state = state.copyWith(availableSpaces: spaces);
    await _loadWorkspace(spaceId);
  }

  void _requireEditor() {
    if (!state.canEdit) {
      throw StateError('Seu acesso é somente leitura.');
    }
  }

  void _requireOwner() {
    if (!state.isOwner) {
      throw StateError('Somente o proprietário pode realizar esta ação.');
    }
  }

  String _requireSpaceId() {
    final value = state.spaceId;
    if (value == null) {
      throw StateError('Nenhum espaço financeiro selecionado.');
    }
    return value;
  }

  void _recordError(Object error) {
    state = state.copyWith(
      isLoading: false,
      errorMessage: _friendlyDataError(error),
    );
  }
}

String _friendlyDataError(Object error) {
  final message = error.toString();
  if (message.contains('permission') || message.contains('access')) {
    return 'Você não tem permissão para realizar esta ação.';
  }
  if (message.contains('network') || message.contains('connection')) {
    return 'Não foi possível conectar ao banco. Verifique sua internet.';
  }
  if (error is StateError) return error.message;
  return 'Não foi possível sincronizar os dados. Tente novamente.';
}
