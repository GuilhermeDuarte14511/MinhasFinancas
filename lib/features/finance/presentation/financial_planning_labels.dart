import 'package:flutter/material.dart';

import '../domain/financial_planning.dart';

String financialAccountTypeLabel(FinancialAccountType type) => switch (type) {
  FinancialAccountType.checking => 'Conta corrente',
  FinancialAccountType.savings => 'Poupança',
  FinancialAccountType.cash => 'Dinheiro',
  FinancialAccountType.investment => 'Investimentos',
  FinancialAccountType.other => 'Outra conta',
};

IconData financialAccountTypeIcon(FinancialAccountType type) => switch (type) {
  FinancialAccountType.checking => Icons.account_balance_outlined,
  FinancialAccountType.savings => Icons.savings_outlined,
  FinancialAccountType.cash => Icons.account_balance_wallet_outlined,
  FinancialAccountType.investment => Icons.trending_up_rounded,
  FinancialAccountType.other => Icons.wallet_outlined,
};
