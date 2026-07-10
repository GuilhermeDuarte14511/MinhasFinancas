# Modelo de domínio

## Agregados

- `FinancialSpace`: tenant, membros, papéis e categorias.
- `CreditCard`: dados não sensíveis, limite e ciclos.
- `Purchase`: total exato e parcelas geradas atomicamente.
- `CreditCardInvoice`: parcelas, pagamentos e status.
- `Loan`: contrato e cronograma de amortização.
- `NotificationPreference`: regras por usuário e espaço.

## Invariantes implementadas

- dinheiro é inteiro em centavos, nunca `double` nas regras;
- parcelamento aceita de 1 a 24 parcelas;
- a soma das parcelas sempre equivale ao total da compra;
- o resto em centavos é distribuído a partir da primeira parcela;
- meses de referência são normalizados para o primeiro dia;
- pagamento é limitado ao saldo pendente e libera o mesmo valor no limite;
- somente os últimos quatro dígitos do cartão são aceitos.

## Próximas invariantes de backend

- membership ativa e papel permitido em cada operação;
- ao menos um Owner por espaço;
- isolamento obrigatório por `financial_space_id`;
- convite vinculado ao e-mail verificado e token com hash/expiração;
- idempotência em pagamentos;
- versão otimista em agregados mutáveis;
- cancelamentos e reversões sem apagar histórico.

As datas de auditoria serão UTC; vencimentos permanecem datas civis e são
exibidos/agendados em `America/Sao_Paulo`.
