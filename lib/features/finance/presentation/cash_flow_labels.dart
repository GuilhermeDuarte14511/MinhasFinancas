import 'package:flutter/material.dart';

import '../domain/cash_flow.dart';

List<CashFlowKind> cashFlowKindsFor(CashFlowDirection direction) =>
    switch (direction) {
      CashFlowDirection.income => const [
        CashFlowKind.salary,
        CashFlowKind.thirteenthSalary,
        CashFlowKind.vacationPay,
        CashFlowKind.bonus,
        CashFlowKind.refund,
        CashFlowKind.otherIncome,
      ],
      CashFlowDirection.expense => const [
        CashFlowKind.bill,
        CashFlowKind.cashPurchase,
        CashFlowKind.subscription,
        CashFlowKind.tax,
        CashFlowKind.otherExpense,
      ],
    };

String cashFlowKindLabel(CashFlowKind kind) => switch (kind) {
  CashFlowKind.salary => 'Salário',
  CashFlowKind.thirteenthSalary => '13º salário',
  CashFlowKind.vacationPay => 'Férias',
  CashFlowKind.bonus => 'Bônus',
  CashFlowKind.refund => 'Reembolso',
  CashFlowKind.bill => 'Conta ou boleto',
  CashFlowKind.cashPurchase => 'Compra à vista',
  CashFlowKind.cardPurchase => 'Compra no cartão',
  CashFlowKind.subscription => 'Assinatura',
  CashFlowKind.tax => 'Imposto ou taxa',
  CashFlowKind.loanPayment => 'Parcela de empréstimo',
  CashFlowKind.otherIncome => 'Outra entrada',
  CashFlowKind.otherExpense => 'Outra saída',
};

String cashFlowPaymentMethodLabel(CashFlowPaymentMethod method) =>
    switch (method) {
      CashFlowPaymentMethod.pix => 'Pix',
      CashFlowPaymentMethod.cash => 'Dinheiro',
      CashFlowPaymentMethod.bankTransfer => 'Transferência',
      CashFlowPaymentMethod.debitCard => 'Cartão de débito',
      CashFlowPaymentMethod.creditCard => 'Cartão de crédito',
      CashFlowPaymentMethod.other => 'Outro',
    };

IconData cashFlowKindIcon(CashFlowKind kind) => switch (kind) {
  CashFlowKind.salary => Icons.payments_outlined,
  CashFlowKind.thirteenthSalary => Icons.redeem_outlined,
  CashFlowKind.vacationPay => Icons.beach_access_outlined,
  CashFlowKind.bonus => Icons.stars_outlined,
  CashFlowKind.refund => Icons.undo_rounded,
  CashFlowKind.bill => Icons.receipt_long_outlined,
  CashFlowKind.cashPurchase => Icons.shopping_bag_outlined,
  CashFlowKind.cardPurchase => Icons.credit_card_outlined,
  CashFlowKind.subscription => Icons.subscriptions_outlined,
  CashFlowKind.tax => Icons.account_balance_outlined,
  CashFlowKind.loanPayment => Icons.request_quote_outlined,
  CashFlowKind.otherIncome => Icons.south_west_rounded,
  CashFlowKind.otherExpense => Icons.north_east_rounded,
};

String cashFlowStatusLabel(CashFlowStatus status) => switch (status) {
  CashFlowStatus.scheduled => 'Prevista',
  CashFlowStatus.confirmed => 'Recebida',
  CashFlowStatus.cancelled => 'Cancelada',
};

String recurrenceFrequencyLabel(RecurrenceFrequency frequency) =>
    switch (frequency) {
      RecurrenceFrequency.none => 'Sem recorrência',
      RecurrenceFrequency.weekly => 'Semanal',
      RecurrenceFrequency.biweekly => 'Quinzenal',
      RecurrenceFrequency.monthly => 'Mensal',
      RecurrenceFrequency.yearly => 'Anual',
    };

String recurrenceScopeLabel(RecurrenceScope scope) => switch (scope) {
  RecurrenceScope.single => 'Somente este lançamento',
  RecurrenceScope.thisAndFuture => 'Este e os próximos',
  RecurrenceScope.entireSeries => 'Toda a série',
};
