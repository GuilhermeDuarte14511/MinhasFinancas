import '../../../core/money/money.dart';

enum InvoiceStatus { open, closed, partiallyPaid, paid, overdue, cancelled }

enum MembershipRole { owner, editor, viewer }

final class CreditCardAccount {
  const CreditCardAccount({
    required this.id,
    required this.nickname,
    required this.lastFourDigits,
    required this.cardholder,
    required this.limit,
    required this.committed,
    required this.closingDay,
    required this.dueDay,
    required this.colorValue,
  });

  final String id;
  final String nickname;
  final String lastFourDigits;
  final String cardholder;
  final Money limit;
  final Money committed;
  final int closingDay;
  final int dueDay;
  final int colorValue;

  Money get available => limit - committed;

  CreditCardAccount copyWith({Money? committed}) => CreditCardAccount(
    id: id,
    nickname: nickname,
    lastFourDigits: lastFourDigits,
    cardholder: cardholder,
    limit: limit,
    committed: committed ?? this.committed,
    closingDay: closingDay,
    dueDay: dueDay,
    colorValue: colorValue,
  );
}

final class PurchaseRecord {
  const PurchaseRecord({
    required this.id,
    required this.description,
    required this.category,
    required this.cardId,
    required this.total,
    required this.installmentCount,
    required this.purchaseDate,
    required this.createdBy,
  });

  final String id;
  final String description;
  final String category;
  final String cardId;
  final Money total;
  final int installmentCount;
  final DateTime purchaseDate;
  final String createdBy;
}

final class InvoiceSummary {
  const InvoiceSummary({
    required this.id,
    required this.cardId,
    required this.cardName,
    required this.referenceMonth,
    required this.dueDate,
    required this.total,
    required this.paid,
    required this.status,
  });

  final String id;
  final String cardId;
  final String cardName;
  final DateTime referenceMonth;
  final DateTime dueDate;
  final Money total;
  final Money paid;
  final InvoiceStatus status;

  Money get pending => total - paid;

  InvoiceSummary copyWith({Money? paid, InvoiceStatus? status}) =>
      InvoiceSummary(
        id: id,
        cardId: cardId,
        cardName: cardName,
        referenceMonth: referenceMonth,
        dueDate: dueDate,
        total: total,
        paid: paid ?? this.paid,
        status: status ?? this.status,
      );
}

final class LoanContract {
  const LoanContract({
    required this.id,
    required this.lender,
    required this.description,
    required this.originalAmount,
    required this.outstandingBalance,
    required this.installmentAmount,
    required this.paidInstallments,
    required this.installmentCount,
    required this.dueDay,
  });

  final String id;
  final String lender;
  final String description;
  final Money originalAmount;
  final Money outstandingBalance;
  final Money installmentAmount;
  final int paidInstallments;
  final int installmentCount;
  final int dueDay;
}

final class DueItem {
  const DueItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.dueDate,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final Money amount;
  final DateTime dueDate;
  final String kind;
}

final class ActivityEntry {
  const ActivityEntry({
    required this.person,
    required this.description,
    required this.whenLabel,
  });

  final String person;
  final String description;
  final String whenLabel;
}
