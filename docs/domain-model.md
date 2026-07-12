# Modelo de domínio

## Agregados

- `FinancialSpace`: tenant, membros, papéis e categorias.
- `CreditCard`: dados não sensíveis, limite e ciclos.
- `Purchase`: total exato e parcelas geradas atomicamente.
- `CreditCardInvoice`: parcelas, pagamentos e status.
- `CashFlowEntry`: entradas e saídas manuais/recorrentes, previstas ou
  realizadas, fora dos agregados de cartão e empréstimo.
- `CashFlowRecurrenceSeries`: regra compartilhada e identidade das ocorrências.
- `Loan`: contrato e cronograma de amortização.
- `NotificationPreference`: regras por usuário e espaço.

## Invariantes implementadas

- dinheiro é inteiro em centavos, nunca `double` nas regras;
- parcelamento aceita de 1 a 24 parcelas;
- a soma das parcelas sempre equivale ao total da compra;
- o resto em centavos é distribuído a partir da primeira parcela;
- meses de referência são normalizados para o primeiro dia;
- compra antes ou no fechamento entra no ciclo atual; depois, no próximo;
- dias de fechamento, vencimento e recorrência inexistentes são limitados ao
  último dia válido do mês;
- pagamento é limitado ao saldo pendente e libera o mesmo valor no limite;
- somente os últimos quatro dígitos do cartão são aceitos.
- movimentações têm valor positivo; a direção define entrada ou saída;
- salário, 13º, férias, bônus, contas e compras à vista usam o mesmo livro-caixa;
- tipo da conta e meio de pagamento são conceitos separados;
- cada fatura contribui no mês de referência somente com as parcelas daquele
  ciclo; uma compra parcelada não reduz o mês atual pelo valor integral;
- pagamentos de empréstimo confirmados contribuem no mês em que foram pagos;
- quitar a fatura não gera uma segunda despesa;
- totais mensal, anual e histórico combinam essas fontes no servidor.
- receitas futuras não entram no realizado antes da confirmação;
- exclusão recorrente respeita ocorrência, futuras ou série completa;
- série + índice e idempotency key impedem ocorrências duplicadas;
- exclusão de cartão remove dependências em uma única transação.

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
