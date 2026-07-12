# Schema de dados

O arquivo executável inicial é `dataconnect/schema/schema.gql` e contém:

1. `user_profile`
2. `financial_space`
3. `space_member`
4. `space_invitation`
5. `category`
6. `credit_card`
7. `purchase`
8. `credit_card_invoice`
9. `purchase_installment`
10. `invoice_payment`
11. `cash_flow_recurrence_series`
12. `cash_flow_entry`
13. `loan`
14. `loan_installment`
15. `loan_payment`
16. `notification_preference`
17. `notification_rule`
18. `device_subscription`
19. `notification_delivery`
20. `audit_event`

Todas as tabelas financeiras referenciam `FinancialSpace`. UUID é a chave
primária, valores monetários usam `Int64` em centavos e timestamps usam
`Timestamp`/`timestamptz`.

`cash_flow_entry` é o livro de movimentações manuais e recorrentes. Ele separa
direção, tipo, meio de pagamento, competência e status previsto/realizado. A
série guarda frequência, limites e próximo materializável; cada ocorrência tem
índice único, vínculo opcional e marca de exceção. O relatório também agrega
diretamente `credit_card_invoice.total_amount_cents` por mês de referência e
`loan_payment.amount_cents` por data de pagamento. Essas tabelas canônicas
preservam o histórico anterior à evolução e evitam dupla contagem: pagamento de
fatura não é outra despesa.

O schema publicado inclui:

- unique composto de membership, categoria, fatura e parcelas;
- checks de valores positivos e intervalos de dias/parcelas;
- índices por tenant, status, vencimento e referência mensal;
- idempotency key única por tenant;
- proteção append-only para `audit_event`;
- unicidade de token/endpoint por hash.

Esses detalhes não são duplicados em arquivos SQL separados. Em 12/07/2026 a
migration aditiva de recorrência/status foi aplicada e o schema foi publicado.
