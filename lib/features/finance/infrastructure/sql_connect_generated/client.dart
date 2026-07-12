library nossa_grana_sql_connect;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

part 'get_my_profile.dart';

part 'create_my_profile.dart';

part 'update_my_profile.dart';

part 'list_my_spaces.dart';

part 'get_workspace_snapshot.dart';

part 'get_cash_flow_summary.dart';

part 'get_agenda_entries.dart';

part 'create_financial_space.dart';

part 'list_space_invitations.dart';

part 'create_space_invitation.dart';

part 'accept_space_invitation.dart';

part 'create_category.dart';

part 'create_income_entry.dart';

part 'create_scheduled_income_entry.dart';

part 'create_expense_entry.dart';

part 'create_planned_expense_entry.dart';

part 'create_cash_flow_recurrence_series.dart';

part 'create_recurring_cash_flow_occurrence.dart';

part 'mark_income_entry_received.dart';

part 'mark_expense_entry_paid.dart';

part 'update_cash_flow_occurrence.dart';

part 'update_cash_flow_series_from.dart';

part 'update_entire_cash_flow_series.dart';

part 'delete_standalone_cash_flow_entry.dart';

part 'delete_cash_flow_occurrence.dart';

part 'delete_cash_flow_series_from.dart';

part 'delete_entire_cash_flow_series.dart';

part 'cancel_cash_flow_entry.dart';

part 'create_credit_card.dart';

part 'create_purchase.dart';

part 'find_credit_card_invoice.dart';

part 'create_credit_card_invoice.dart';

part 'add_purchase_installment.dart';

part 'update_purchase_details.dart';

part 'get_purchase_installments_for_cancellation.dart';

part 'cancel_purchase_installment.dart';

part 'cancel_purchase.dart';

part 'register_invoice_payment.dart';

part 'register_full_invoice_payment.dart';

part 'create_loan.dart';

part 'add_loan_installment.dart';

part 'register_loan_payment.dart';

part 'cancel_loan.dart';

part 'update_notification_preference.dart';

part 'update_notification_rules.dart';

part 'register_device_subscription.dart';

part 'update_financial_space.dart';

part 'archive_financial_space.dart';

part 'revoke_space_invitation.dart';

part 'update_member_role.dart';

part 'remove_space_member.dart';

part 'update_category.dart';

part 'archive_category.dart';

part 'update_credit_card.dart';

part 'archive_credit_card.dart';

part 'delete_credit_card_cascade.dart';


String? bigIntToJson(BigInt? value) {
  return value?.toString();
}

BigInt bigIntFromJson(dynamic value) {
  return BigInt.parse(value);
}


  enum CashFlowDirection {
    
      INCOME,
    
      EXPENSE,
    
  }
  
  String cashFlowDirectionSerializer(EnumValue<CashFlowDirection> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowDirection> cashFlowDirectionDeserializer(dynamic data) {
    switch (data) {
      
      case 'INCOME':
        return const Known(CashFlowDirection.INCOME);
      
      case 'EXPENSE':
        return const Known(CashFlowDirection.EXPENSE);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowKind {
    
      SALARY,
    
      THIRTEENTH_SALARY,
    
      VACATION_PAY,
    
      BONUS,
    
      REFUND,
    
      BILL,
    
      CASH_PURCHASE,
    
      CARD_PURCHASE,
    
      SUBSCRIPTION,
    
      TAX,
    
      LOAN_PAYMENT,
    
      OTHER_INCOME,
    
      OTHER_EXPENSE,
    
  }
  
  String cashFlowKindSerializer(EnumValue<CashFlowKind> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowKind> cashFlowKindDeserializer(dynamic data) {
    switch (data) {
      
      case 'SALARY':
        return const Known(CashFlowKind.SALARY);
      
      case 'THIRTEENTH_SALARY':
        return const Known(CashFlowKind.THIRTEENTH_SALARY);
      
      case 'VACATION_PAY':
        return const Known(CashFlowKind.VACATION_PAY);
      
      case 'BONUS':
        return const Known(CashFlowKind.BONUS);
      
      case 'REFUND':
        return const Known(CashFlowKind.REFUND);
      
      case 'BILL':
        return const Known(CashFlowKind.BILL);
      
      case 'CASH_PURCHASE':
        return const Known(CashFlowKind.CASH_PURCHASE);
      
      case 'CARD_PURCHASE':
        return const Known(CashFlowKind.CARD_PURCHASE);
      
      case 'SUBSCRIPTION':
        return const Known(CashFlowKind.SUBSCRIPTION);
      
      case 'TAX':
        return const Known(CashFlowKind.TAX);
      
      case 'LOAN_PAYMENT':
        return const Known(CashFlowKind.LOAN_PAYMENT);
      
      case 'OTHER_INCOME':
        return const Known(CashFlowKind.OTHER_INCOME);
      
      case 'OTHER_EXPENSE':
        return const Known(CashFlowKind.OTHER_EXPENSE);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowMutationScope {
    
      ONLY_THIS,
    
      THIS_AND_FUTURE,
    
      ENTIRE_SERIES,
    
  }
  
  String cashFlowMutationScopeSerializer(EnumValue<CashFlowMutationScope> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowMutationScope> cashFlowMutationScopeDeserializer(dynamic data) {
    switch (data) {
      
      case 'ONLY_THIS':
        return const Known(CashFlowMutationScope.ONLY_THIS);
      
      case 'THIS_AND_FUTURE':
        return const Known(CashFlowMutationScope.THIS_AND_FUTURE);
      
      case 'ENTIRE_SERIES':
        return const Known(CashFlowMutationScope.ENTIRE_SERIES);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowPaymentMethod {
    
      PIX,
    
      CASH,
    
      BANK_TRANSFER,
    
      DEBIT_CARD,
    
      CREDIT_CARD,
    
      OTHER,
    
  }
  
  String cashFlowPaymentMethodSerializer(EnumValue<CashFlowPaymentMethod> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowPaymentMethod> cashFlowPaymentMethodDeserializer(dynamic data) {
    switch (data) {
      
      case 'PIX':
        return const Known(CashFlowPaymentMethod.PIX);
      
      case 'CASH':
        return const Known(CashFlowPaymentMethod.CASH);
      
      case 'BANK_TRANSFER':
        return const Known(CashFlowPaymentMethod.BANK_TRANSFER);
      
      case 'DEBIT_CARD':
        return const Known(CashFlowPaymentMethod.DEBIT_CARD);
      
      case 'CREDIT_CARD':
        return const Known(CashFlowPaymentMethod.CREDIT_CARD);
      
      case 'OTHER':
        return const Known(CashFlowPaymentMethod.OTHER);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowRecurrenceFrequency {
    
      WEEKLY,
    
      BIWEEKLY,
    
      MONTHLY,
    
      ANNUAL,
    
  }
  
  String cashFlowRecurrenceFrequencySerializer(EnumValue<CashFlowRecurrenceFrequency> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowRecurrenceFrequency> cashFlowRecurrenceFrequencyDeserializer(dynamic data) {
    switch (data) {
      
      case 'WEEKLY':
        return const Known(CashFlowRecurrenceFrequency.WEEKLY);
      
      case 'BIWEEKLY':
        return const Known(CashFlowRecurrenceFrequency.BIWEEKLY);
      
      case 'MONTHLY':
        return const Known(CashFlowRecurrenceFrequency.MONTHLY);
      
      case 'ANNUAL':
        return const Known(CashFlowRecurrenceFrequency.ANNUAL);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowRecurrenceSeriesStatus {
    
      ACTIVE,
    
      COMPLETED,
    
      CANCELLED,
    
  }
  
  String cashFlowRecurrenceSeriesStatusSerializer(EnumValue<CashFlowRecurrenceSeriesStatus> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowRecurrenceSeriesStatus> cashFlowRecurrenceSeriesStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'ACTIVE':
        return const Known(CashFlowRecurrenceSeriesStatus.ACTIVE);
      
      case 'COMPLETED':
        return const Known(CashFlowRecurrenceSeriesStatus.COMPLETED);
      
      case 'CANCELLED':
        return const Known(CashFlowRecurrenceSeriesStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CashFlowStatus {
    
      PLANNED,
    
      CONFIRMED,
    
      RECEIVED,
    
      PAID,
    
      CANCELLED,
    
  }
  
  String cashFlowStatusSerializer(EnumValue<CashFlowStatus> e) {
    return e.stringValue;
  }
  EnumValue<CashFlowStatus> cashFlowStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PLANNED':
        return const Known(CashFlowStatus.PLANNED);
      
      case 'CONFIRMED':
        return const Known(CashFlowStatus.CONFIRMED);
      
      case 'RECEIVED':
        return const Known(CashFlowStatus.RECEIVED);
      
      case 'PAID':
        return const Known(CashFlowStatus.PAID);
      
      case 'CANCELLED':
        return const Known(CashFlowStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum CreditCardStatus {
    
      ACTIVE,
    
      ARCHIVED,
    
  }
  
  String creditCardStatusSerializer(EnumValue<CreditCardStatus> e) {
    return e.stringValue;
  }
  EnumValue<CreditCardStatus> creditCardStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'ACTIVE':
        return const Known(CreditCardStatus.ACTIVE);
      
      case 'ARCHIVED':
        return const Known(CreditCardStatus.ARCHIVED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum InstallmentStatus {
    
      PLANNED,
    
      OPEN,
    
      PAID,
    
      CANCELLED,
    
  }
  
  String installmentStatusSerializer(EnumValue<InstallmentStatus> e) {
    return e.stringValue;
  }
  EnumValue<InstallmentStatus> installmentStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PLANNED':
        return const Known(InstallmentStatus.PLANNED);
      
      case 'OPEN':
        return const Known(InstallmentStatus.OPEN);
      
      case 'PAID':
        return const Known(InstallmentStatus.PAID);
      
      case 'CANCELLED':
        return const Known(InstallmentStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum InvoiceStatus {
    
      OPEN,
    
      CLOSED,
    
      PARTIALLY_PAID,
    
      PAID,
    
      OVERDUE,
    
      CANCELLED,
    
  }
  
  String invoiceStatusSerializer(EnumValue<InvoiceStatus> e) {
    return e.stringValue;
  }
  EnumValue<InvoiceStatus> invoiceStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'OPEN':
        return const Known(InvoiceStatus.OPEN);
      
      case 'CLOSED':
        return const Known(InvoiceStatus.CLOSED);
      
      case 'PARTIALLY_PAID':
        return const Known(InvoiceStatus.PARTIALLY_PAID);
      
      case 'PAID':
        return const Known(InvoiceStatus.PAID);
      
      case 'OVERDUE':
        return const Known(InvoiceStatus.OVERDUE);
      
      case 'CANCELLED':
        return const Known(InvoiceStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum LoanAmortizationMethod {
    
      PRICE,
    
      SAC,
    
      MANUAL,
    
  }
  
  String loanAmortizationMethodSerializer(EnumValue<LoanAmortizationMethod> e) {
    return e.stringValue;
  }
  EnumValue<LoanAmortizationMethod> loanAmortizationMethodDeserializer(dynamic data) {
    switch (data) {
      
      case 'PRICE':
        return const Known(LoanAmortizationMethod.PRICE);
      
      case 'SAC':
        return const Known(LoanAmortizationMethod.SAC);
      
      case 'MANUAL':
        return const Known(LoanAmortizationMethod.MANUAL);
      
      default:
        return Unknown(data);
    }
  }
  

  enum LoanInstallmentStatus {
    
      PLANNED,
    
      OPEN,
    
      PARTIALLY_PAID,
    
      PAID,
    
      OVERDUE,
    
      CANCELLED,
    
  }
  
  String loanInstallmentStatusSerializer(EnumValue<LoanInstallmentStatus> e) {
    return e.stringValue;
  }
  EnumValue<LoanInstallmentStatus> loanInstallmentStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'PLANNED':
        return const Known(LoanInstallmentStatus.PLANNED);
      
      case 'OPEN':
        return const Known(LoanInstallmentStatus.OPEN);
      
      case 'PARTIALLY_PAID':
        return const Known(LoanInstallmentStatus.PARTIALLY_PAID);
      
      case 'PAID':
        return const Known(LoanInstallmentStatus.PAID);
      
      case 'OVERDUE':
        return const Known(LoanInstallmentStatus.OVERDUE);
      
      case 'CANCELLED':
        return const Known(LoanInstallmentStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum LoanStatus {
    
      ACTIVE,
    
      PAID_OFF,
    
      OVERDUE,
    
      CANCELLED,
    
  }
  
  String loanStatusSerializer(EnumValue<LoanStatus> e) {
    return e.stringValue;
  }
  EnumValue<LoanStatus> loanStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'ACTIVE':
        return const Known(LoanStatus.ACTIVE);
      
      case 'PAID_OFF':
        return const Known(LoanStatus.PAID_OFF);
      
      case 'OVERDUE':
        return const Known(LoanStatus.OVERDUE);
      
      case 'CANCELLED':
        return const Known(LoanStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum MembershipRole {
    
      OWNER,
    
      EDITOR,
    
      VIEWER,
    
  }
  
  String membershipRoleSerializer(EnumValue<MembershipRole> e) {
    return e.stringValue;
  }
  EnumValue<MembershipRole> membershipRoleDeserializer(dynamic data) {
    switch (data) {
      
      case 'OWNER':
        return const Known(MembershipRole.OWNER);
      
      case 'EDITOR':
        return const Known(MembershipRole.EDITOR);
      
      case 'VIEWER':
        return const Known(MembershipRole.VIEWER);
      
      default:
        return Unknown(data);
    }
  }
  

  enum MembershipStatus {
    
      INVITED,
    
      ACTIVE,
    
      SUSPENDED,
    
      REMOVED,
    
  }
  
  String membershipStatusSerializer(EnumValue<MembershipStatus> e) {
    return e.stringValue;
  }
  EnumValue<MembershipStatus> membershipStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'INVITED':
        return const Known(MembershipStatus.INVITED);
      
      case 'ACTIVE':
        return const Known(MembershipStatus.ACTIVE);
      
      case 'SUSPENDED':
        return const Known(MembershipStatus.SUSPENDED);
      
      case 'REMOVED':
        return const Known(MembershipStatus.REMOVED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum NotificationEventType {
    
      INVOICE_CLOSING,
    
      INVOICE_DUE,
    
      LOAN_INSTALLMENT_DUE,
    
  }
  
  String notificationEventTypeSerializer(EnumValue<NotificationEventType> e) {
    return e.stringValue;
  }
  EnumValue<NotificationEventType> notificationEventTypeDeserializer(dynamic data) {
    switch (data) {
      
      case 'INVOICE_CLOSING':
        return const Known(NotificationEventType.INVOICE_CLOSING);
      
      case 'INVOICE_DUE':
        return const Known(NotificationEventType.INVOICE_DUE);
      
      case 'LOAN_INSTALLMENT_DUE':
        return const Known(NotificationEventType.LOAN_INSTALLMENT_DUE);
      
      default:
        return Unknown(data);
    }
  }
  

  enum NotificationPlatform {
    
      ANDROID,
    
      WEB,
    
  }
  
  String notificationPlatformSerializer(EnumValue<NotificationPlatform> e) {
    return e.stringValue;
  }
  EnumValue<NotificationPlatform> notificationPlatformDeserializer(dynamic data) {
    switch (data) {
      
      case 'ANDROID':
        return const Known(NotificationPlatform.ANDROID);
      
      case 'WEB':
        return const Known(NotificationPlatform.WEB);
      
      default:
        return Unknown(data);
    }
  }
  

  enum PaymentStatus {
    
      CONFIRMED,
    
      REVERSED,
    
  }
  
  String paymentStatusSerializer(EnumValue<PaymentStatus> e) {
    return e.stringValue;
  }
  EnumValue<PaymentStatus> paymentStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'CONFIRMED':
        return const Known(PaymentStatus.CONFIRMED);
      
      case 'REVERSED':
        return const Known(PaymentStatus.REVERSED);
      
      default:
        return Unknown(data);
    }
  }
  

  enum PurchaseStatus {
    
      ACTIVE,
    
      CANCELLED,
    
  }
  
  String purchaseStatusSerializer(EnumValue<PurchaseStatus> e) {
    return e.stringValue;
  }
  EnumValue<PurchaseStatus> purchaseStatusDeserializer(dynamic data) {
    switch (data) {
      
      case 'ACTIVE':
        return const Known(PurchaseStatus.ACTIVE);
      
      case 'CANCELLED':
        return const Known(PurchaseStatus.CANCELLED);
      
      default:
        return Unknown(data);
    }
  }
  



String enumSerializer(Enum e) {
  return e.name;
}



/// A sealed class representing either a known enum value or an unknown string value.
@immutable
sealed class EnumValue<T extends Enum> {
  const EnumValue();

  

  /// The string representation of the value.
  String get stringValue;
  @override
  String toString() {
    return "EnumValue($stringValue)";
  }
}

/// Represents a known, valid enum value.
class Known<T extends Enum> extends EnumValue<T> {
  /// The actual enum value.
  final T value;

  const Known(this.value);

  @override
  String get stringValue => value.name;

  @override
  String toString() {
    return "Known($stringValue)";
  }
}
/// Represents an unknown or unrecognized enum value.
class Unknown extends EnumValue<Never> {
  /// The raw string value that couldn't be mapped to a known enum.
  @override
  final String stringValue;

  const Unknown(this.stringValue);
  @override
  String toString() {
    return "Unknown($stringValue)";
  }
}

class ClientConnector {
  
  
  GetMyProfileVariablesBuilder getMyProfile () {
    return GetMyProfileVariablesBuilder(dataConnect, );
  }
  
  
  CreateMyProfileVariablesBuilder createMyProfile ({required String displayName, }) {
    return CreateMyProfileVariablesBuilder(dataConnect, displayName: displayName,);
  }
  
  
  UpdateMyProfileVariablesBuilder updateMyProfile ({required String displayName, }) {
    return UpdateMyProfileVariablesBuilder(dataConnect, displayName: displayName,);
  }
  
  
  ListMySpacesVariablesBuilder listMySpaces () {
    return ListMySpacesVariablesBuilder(dataConnect, );
  }
  
  
  GetWorkspaceSnapshotVariablesBuilder getWorkspaceSnapshot ({required String spaceId, }) {
    return GetWorkspaceSnapshotVariablesBuilder(dataConnect, spaceId: spaceId,);
  }
  
  
  GetCashFlowSummaryVariablesBuilder getCashFlowSummary ({required String spaceId, required DateTime monthStart, required DateTime yearStart, required DateTime nextYearStart, required Timestamp monthStartedAt, required Timestamp nextMonthStartedAt, required Timestamp yearStartedAt, required Timestamp nextYearStartedAt, }) {
    return GetCashFlowSummaryVariablesBuilder(dataConnect, spaceId: spaceId,monthStart: monthStart,yearStart: yearStart,nextYearStart: nextYearStart,monthStartedAt: monthStartedAt,nextMonthStartedAt: nextMonthStartedAt,yearStartedAt: yearStartedAt,nextYearStartedAt: nextYearStartedAt,);
  }
  
  
  GetAgendaEntriesVariablesBuilder getAgendaEntries ({required String spaceId, required Timestamp rangeStart, required Timestamp rangeEnd, required DateTime rangeStartDate, required DateTime rangeEndDate, }) {
    return GetAgendaEntriesVariablesBuilder(dataConnect, spaceId: spaceId,rangeStart: rangeStart,rangeEnd: rangeEnd,rangeStartDate: rangeStartDate,rangeEndDate: rangeEndDate,);
  }
  
  
  CreateFinancialSpaceVariablesBuilder createFinancialSpace ({required String name, required String colorHex, }) {
    return CreateFinancialSpaceVariablesBuilder(dataConnect, name: name,colorHex: colorHex,);
  }
  
  
  ListSpaceInvitationsVariablesBuilder listSpaceInvitations ({required String spaceId, }) {
    return ListSpaceInvitationsVariablesBuilder(dataConnect, spaceId: spaceId,);
  }
  
  
  CreateSpaceInvitationVariablesBuilder createSpaceInvitation ({required String spaceId, required String email, required String normalizedEmail, required MembershipRole role, required String tokenHash, required Timestamp expiresAt, }) {
    return CreateSpaceInvitationVariablesBuilder(dataConnect, spaceId: spaceId,email: email,normalizedEmail: normalizedEmail,role: role,tokenHash: tokenHash,expiresAt: expiresAt,);
  }
  
  
  AcceptSpaceInvitationVariablesBuilder acceptSpaceInvitation ({required String tokenHash, }) {
    return AcceptSpaceInvitationVariablesBuilder(dataConnect, tokenHash: tokenHash,);
  }
  
  
  CreateCategoryVariablesBuilder createCategory ({required String spaceId, required String name, required String normalizedName, required String icon, required String colorHex, }) {
    return CreateCategoryVariablesBuilder(dataConnect, spaceId: spaceId,name: name,normalizedName: normalizedName,icon: icon,colorHex: colorHex,);
  }
  
  
  CreateIncomeEntryVariablesBuilder createIncomeEntry ({required String spaceId, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required Timestamp occurredAt, required DateTime competenceMonth, required String idempotencyKey, }) {
    return CreateIncomeEntryVariablesBuilder(dataConnect, spaceId: spaceId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,idempotencyKey: idempotencyKey,);
  }
  
  
  CreateScheduledIncomeEntryVariablesBuilder createScheduledIncomeEntry ({required String spaceId, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required Timestamp occurredAt, required DateTime competenceMonth, required String idempotencyKey, }) {
    return CreateScheduledIncomeEntryVariablesBuilder(dataConnect, spaceId: spaceId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,idempotencyKey: idempotencyKey,);
  }
  
  
  CreateExpenseEntryVariablesBuilder createExpenseEntry ({required String spaceId, required String categoryId, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required Timestamp occurredAt, required DateTime competenceMonth, required String idempotencyKey, }) {
    return CreateExpenseEntryVariablesBuilder(dataConnect, spaceId: spaceId,categoryId: categoryId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,idempotencyKey: idempotencyKey,);
  }
  
  
  CreatePlannedExpenseEntryVariablesBuilder createPlannedExpenseEntry ({required String spaceId, required String categoryId, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required Timestamp occurredAt, required DateTime competenceMonth, required String idempotencyKey, }) {
    return CreatePlannedExpenseEntryVariablesBuilder(dataConnect, spaceId: spaceId,categoryId: categoryId,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,idempotencyKey: idempotencyKey,);
  }
  
  
  CreateCashFlowRecurrenceSeriesVariablesBuilder createCashFlowRecurrenceSeries ({required String spaceId, required CashFlowDirection direction, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required String description, required BigInt amountCents, required CashFlowRecurrenceFrequency frequency, required DateTime startDate, required String idempotencyKey, }) {
    return CreateCashFlowRecurrenceSeriesVariablesBuilder(dataConnect, spaceId: spaceId,direction: direction,kind: kind,paymentMethod: paymentMethod,description: description,amountCents: amountCents,frequency: frequency,startDate: startDate,idempotencyKey: idempotencyKey,);
  }
  
  
  CreateRecurringCashFlowOccurrenceVariablesBuilder createRecurringCashFlowOccurrence ({required String spaceId, required String seriesId, required int occurrenceIndex, required Timestamp occurredAt, required DateTime competenceMonth, required CashFlowStatus status, required String idempotencyKey, }) {
    return CreateRecurringCashFlowOccurrenceVariablesBuilder(dataConnect, spaceId: spaceId,seriesId: seriesId,occurrenceIndex: occurrenceIndex,occurredAt: occurredAt,competenceMonth: competenceMonth,status: status,idempotencyKey: idempotencyKey,);
  }
  
  
  MarkIncomeEntryReceivedVariablesBuilder markIncomeEntryReceived ({required String spaceId, required String entryId, required Timestamp receivedAt, }) {
    return MarkIncomeEntryReceivedVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,receivedAt: receivedAt,);
  }
  
  
  MarkExpenseEntryPaidVariablesBuilder markExpenseEntryPaid ({required String spaceId, required String entryId, required Timestamp paidAt, }) {
    return MarkExpenseEntryPaidVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,paidAt: paidAt,);
  }
  
  
  UpdateCashFlowOccurrenceVariablesBuilder updateCashFlowOccurrence ({required String spaceId, required String entryId, required CashFlowMutationScope scope, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required Timestamp occurredAt, required DateTime competenceMonth, required CashFlowStatus status, }) {
    return UpdateCashFlowOccurrenceVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,scope: scope,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,occurredAt: occurredAt,competenceMonth: competenceMonth,status: status,);
  }
  
  
  UpdateCashFlowSeriesFromVariablesBuilder updateCashFlowSeriesFrom ({required String spaceId, required String seriesId, required CashFlowMutationScope scope, required Timestamp cutoffAt, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required CashFlowStatus entryStatus, }) {
    return UpdateCashFlowSeriesFromVariablesBuilder(dataConnect, spaceId: spaceId,seriesId: seriesId,scope: scope,cutoffAt: cutoffAt,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,entryStatus: entryStatus,);
  }
  
  
  UpdateEntireCashFlowSeriesVariablesBuilder updateEntireCashFlowSeries ({required String spaceId, required String seriesId, required CashFlowMutationScope scope, required String description, required CashFlowKind kind, required CashFlowPaymentMethod paymentMethod, required BigInt amountCents, required CashFlowStatus entryStatus, }) {
    return UpdateEntireCashFlowSeriesVariablesBuilder(dataConnect, spaceId: spaceId,seriesId: seriesId,scope: scope,description: description,kind: kind,paymentMethod: paymentMethod,amountCents: amountCents,entryStatus: entryStatus,);
  }
  
  
  DeleteStandaloneCashFlowEntryVariablesBuilder deleteStandaloneCashFlowEntry ({required String spaceId, required String entryId, required CashFlowMutationScope scope, }) {
    return DeleteStandaloneCashFlowEntryVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,scope: scope,);
  }
  
  
  DeleteCashFlowOccurrenceVariablesBuilder deleteCashFlowOccurrence ({required String spaceId, required String entryId, required CashFlowMutationScope scope, required String reason, }) {
    return DeleteCashFlowOccurrenceVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,scope: scope,reason: reason,);
  }
  
  
  DeleteCashFlowSeriesFromVariablesBuilder deleteCashFlowSeriesFrom ({required String spaceId, required String seriesId, required CashFlowMutationScope scope, required Timestamp cutoffAt, required String reason, }) {
    return DeleteCashFlowSeriesFromVariablesBuilder(dataConnect, spaceId: spaceId,seriesId: seriesId,scope: scope,cutoffAt: cutoffAt,reason: reason,);
  }
  
  
  DeleteEntireCashFlowSeriesVariablesBuilder deleteEntireCashFlowSeries ({required String spaceId, required String seriesId, required CashFlowMutationScope scope, required String reason, }) {
    return DeleteEntireCashFlowSeriesVariablesBuilder(dataConnect, spaceId: spaceId,seriesId: seriesId,scope: scope,reason: reason,);
  }
  
  
  CancelCashFlowEntryVariablesBuilder cancelCashFlowEntry ({required String spaceId, required String entryId, required String reason, }) {
    return CancelCashFlowEntryVariablesBuilder(dataConnect, spaceId: spaceId,entryId: entryId,reason: reason,);
  }
  
  
  CreateCreditCardVariablesBuilder createCreditCard ({required String spaceId, required String nickname, required String lastFourDigits, required BigInt creditLimitCents, required int closingDay, required int dueDay, required String colorHex, }) {
    return CreateCreditCardVariablesBuilder(dataConnect, spaceId: spaceId,nickname: nickname,lastFourDigits: lastFourDigits,creditLimitCents: creditLimitCents,closingDay: closingDay,dueDay: dueDay,colorHex: colorHex,);
  }
  
  
  CreatePurchaseVariablesBuilder createPurchase ({required String spaceId, required String cardId, required String categoryId, required String description, required BigInt totalAmountCents, required DateTime purchaseDate, required int installmentCount, required DateTime firstInvoiceReference, }) {
    return CreatePurchaseVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,categoryId: categoryId,description: description,totalAmountCents: totalAmountCents,purchaseDate: purchaseDate,installmentCount: installmentCount,firstInvoiceReference: firstInvoiceReference,);
  }
  
  
  FindCreditCardInvoiceVariablesBuilder findCreditCardInvoice ({required String spaceId, required String cardId, required DateTime referenceMonth, }) {
    return FindCreditCardInvoiceVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,referenceMonth: referenceMonth,);
  }
  
  
  CreateCreditCardInvoiceVariablesBuilder createCreditCardInvoice ({required String spaceId, required String cardId, required DateTime referenceMonth, required DateTime closingDate, required DateTime dueDate, }) {
    return CreateCreditCardInvoiceVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,referenceMonth: referenceMonth,closingDate: closingDate,dueDate: dueDate,);
  }
  
  
  AddPurchaseInstallmentVariablesBuilder addPurchaseInstallment ({required String spaceId, required String purchaseId, required String invoiceId, required int installmentNumber, required int installmentCount, required BigInt amountCents, required DateTime dueDate, }) {
    return AddPurchaseInstallmentVariablesBuilder(dataConnect, spaceId: spaceId,purchaseId: purchaseId,invoiceId: invoiceId,installmentNumber: installmentNumber,installmentCount: installmentCount,amountCents: amountCents,dueDate: dueDate,);
  }
  
  
  UpdatePurchaseDetailsVariablesBuilder updatePurchaseDetails ({required String spaceId, required String purchaseId, required String description, required String categoryId, }) {
    return UpdatePurchaseDetailsVariablesBuilder(dataConnect, spaceId: spaceId,purchaseId: purchaseId,description: description,categoryId: categoryId,);
  }
  
  
  GetPurchaseInstallmentsForCancellationVariablesBuilder getPurchaseInstallmentsForCancellation ({required String spaceId, required String purchaseId, }) {
    return GetPurchaseInstallmentsForCancellationVariablesBuilder(dataConnect, spaceId: spaceId,purchaseId: purchaseId,);
  }
  
  
  CancelPurchaseInstallmentVariablesBuilder cancelPurchaseInstallment ({required String spaceId, required String installmentId, required String invoiceId, required BigInt amountCents, }) {
    return CancelPurchaseInstallmentVariablesBuilder(dataConnect, spaceId: spaceId,installmentId: installmentId,invoiceId: invoiceId,amountCents: amountCents,);
  }
  
  
  CancelPurchaseVariablesBuilder cancelPurchase ({required String spaceId, required String purchaseId, required String reason, }) {
    return CancelPurchaseVariablesBuilder(dataConnect, spaceId: spaceId,purchaseId: purchaseId,reason: reason,);
  }
  
  
  RegisterInvoicePaymentVariablesBuilder registerInvoicePayment ({required String spaceId, required String invoiceId, required BigInt amountCents, required Timestamp paidAt, required String idempotencyKey, required InvoiceStatus resultingStatus, }) {
    return RegisterInvoicePaymentVariablesBuilder(dataConnect, spaceId: spaceId,invoiceId: invoiceId,amountCents: amountCents,paidAt: paidAt,idempotencyKey: idempotencyKey,resultingStatus: resultingStatus,);
  }
  
  
  RegisterFullInvoicePaymentVariablesBuilder registerFullInvoicePayment ({required String spaceId, required String invoiceId, required BigInt amountCents, required Timestamp paidAt, required String idempotencyKey, }) {
    return RegisterFullInvoicePaymentVariablesBuilder(dataConnect, spaceId: spaceId,invoiceId: invoiceId,amountCents: amountCents,paidAt: paidAt,idempotencyKey: idempotencyKey,);
  }
  
  
  CreateLoanVariablesBuilder createLoan ({required String spaceId, required String name, required BigInt principalAmountCents, required BigInt monthlyInterestRateMicros, required LoanAmortizationMethod amortizationMethod, required int installmentCount, required DateTime firstDueDate, }) {
    return CreateLoanVariablesBuilder(dataConnect, spaceId: spaceId,name: name,principalAmountCents: principalAmountCents,monthlyInterestRateMicros: monthlyInterestRateMicros,amortizationMethod: amortizationMethod,installmentCount: installmentCount,firstDueDate: firstDueDate,);
  }
  
  
  AddLoanInstallmentVariablesBuilder addLoanInstallment ({required String spaceId, required String loanId, required int installmentNumber, required DateTime dueDate, required BigInt openingBalanceCents, required BigInt principalAmountCents, required BigInt interestAmountCents, required BigInt totalAmountCents, }) {
    return AddLoanInstallmentVariablesBuilder(dataConnect, spaceId: spaceId,loanId: loanId,installmentNumber: installmentNumber,dueDate: dueDate,openingBalanceCents: openingBalanceCents,principalAmountCents: principalAmountCents,interestAmountCents: interestAmountCents,totalAmountCents: totalAmountCents,);
  }
  
  
  RegisterLoanPaymentVariablesBuilder registerLoanPayment ({required String spaceId, required String loanId, required String loanInstallmentId, required BigInt amountCents, required Timestamp paidAt, required String idempotencyKey, required LoanInstallmentStatus resultingStatus, }) {
    return RegisterLoanPaymentVariablesBuilder(dataConnect, spaceId: spaceId,loanId: loanId,loanInstallmentId: loanInstallmentId,amountCents: amountCents,paidAt: paidAt,idempotencyKey: idempotencyKey,resultingStatus: resultingStatus,);
  }
  
  
  CancelLoanVariablesBuilder cancelLoan ({required String spaceId, required String loanId, }) {
    return CancelLoanVariablesBuilder(dataConnect, spaceId: spaceId,loanId: loanId,);
  }
  
  
  UpdateNotificationPreferenceVariablesBuilder updateNotificationPreference ({required String spaceId, required bool enabled, required bool pushEnabled, required bool inAppEnabled, required String preferredTime, }) {
    return UpdateNotificationPreferenceVariablesBuilder(dataConnect, spaceId: spaceId,enabled: enabled,pushEnabled: pushEnabled,inAppEnabled: inAppEnabled,preferredTime: preferredTime,);
  }
  
  
  UpdateNotificationRulesVariablesBuilder updateNotificationRules ({required String spaceId, required bool invoiceClosing, required bool invoiceDue, required bool loanDue, required int daysBefore, }) {
    return UpdateNotificationRulesVariablesBuilder(dataConnect, spaceId: spaceId,invoiceClosing: invoiceClosing,invoiceDue: invoiceDue,loanDue: loanDue,daysBefore: daysBefore,);
  }
  
  
  RegisterDeviceSubscriptionVariablesBuilder registerDeviceSubscription ({required String id, required NotificationPlatform platform, required String tokenOrEndpoint, required String tokenHash, }) {
    return RegisterDeviceSubscriptionVariablesBuilder(dataConnect, id: id,platform: platform,tokenOrEndpoint: tokenOrEndpoint,tokenHash: tokenHash,);
  }
  
  
  UpdateFinancialSpaceVariablesBuilder updateFinancialSpace ({required String spaceId, required String name, required String colorHex, }) {
    return UpdateFinancialSpaceVariablesBuilder(dataConnect, spaceId: spaceId,name: name,colorHex: colorHex,);
  }
  
  
  ArchiveFinancialSpaceVariablesBuilder archiveFinancialSpace ({required String spaceId, }) {
    return ArchiveFinancialSpaceVariablesBuilder(dataConnect, spaceId: spaceId,);
  }
  
  
  RevokeSpaceInvitationVariablesBuilder revokeSpaceInvitation ({required String spaceId, required String invitationId, }) {
    return RevokeSpaceInvitationVariablesBuilder(dataConnect, spaceId: spaceId,invitationId: invitationId,);
  }
  
  
  UpdateMemberRoleVariablesBuilder updateMemberRole ({required String spaceId, required String memberId, required MembershipRole role, }) {
    return UpdateMemberRoleVariablesBuilder(dataConnect, spaceId: spaceId,memberId: memberId,role: role,);
  }
  
  
  RemoveSpaceMemberVariablesBuilder removeSpaceMember ({required String spaceId, required String memberId, }) {
    return RemoveSpaceMemberVariablesBuilder(dataConnect, spaceId: spaceId,memberId: memberId,);
  }
  
  
  UpdateCategoryVariablesBuilder updateCategory ({required String spaceId, required String categoryId, required String name, required String normalizedName, }) {
    return UpdateCategoryVariablesBuilder(dataConnect, spaceId: spaceId,categoryId: categoryId,name: name,normalizedName: normalizedName,);
  }
  
  
  ArchiveCategoryVariablesBuilder archiveCategory ({required String spaceId, required String categoryId, }) {
    return ArchiveCategoryVariablesBuilder(dataConnect, spaceId: spaceId,categoryId: categoryId,);
  }
  
  
  UpdateCreditCardVariablesBuilder updateCreditCard ({required String spaceId, required String cardId, required String nickname, required BigInt creditLimitCents, required int closingDay, required int dueDay, required String colorHex, }) {
    return UpdateCreditCardVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,nickname: nickname,creditLimitCents: creditLimitCents,closingDay: closingDay,dueDay: dueDay,colorHex: colorHex,);
  }
  
  
  ArchiveCreditCardVariablesBuilder archiveCreditCard ({required String spaceId, required String cardId, }) {
    return ArchiveCreditCardVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,);
  }
  
  
  DeleteCreditCardCascadeVariablesBuilder deleteCreditCardCascade ({required String spaceId, required String cardId, }) {
    return DeleteCreditCardCascadeVariablesBuilder(dataConnect, spaceId: spaceId,cardId: cardId,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'southamerica-east1',
    'client',
    'minhasfinancasofc-service',
  );

  ClientConnector({required this.dataConnect});
  static ClientConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:30000),
      storage: CacheStorage.persistent,
    );
    
    return ClientConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}
