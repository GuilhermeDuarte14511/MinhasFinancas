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
11. `loan`
12. `loan_installment`
13. `loan_payment`
14. `notification_preference`
15. `notification_rule`
16. `device_subscription`
17. `notification_delivery`
18. `audit_event`

Todas as tabelas financeiras referenciam `FinancialSpace`. UUID é a chave
primária, valores monetários usam `Int64` em centavos e timestamps usam
`Timestamp`/`timestamptz`.

Antes de migrar, o diff gerado pelo CLI deve receber constraints adicionais:

- unique composto de membership, categoria, fatura e parcelas;
- checks de valores positivos e intervalos de dias/parcelas;
- índices por tenant, status, vencimento e referência mensal;
- idempotency key única por tenant;
- proteção append-only para `audit_event`;
- unicidade de token/endpoint por hash.

Esses detalhes não foram simulados em arquivos SQL separados para evitar uma
segunda fonte de verdade. A migração proposta por `firebase dataconnect:sql:diff`
deve ser revisada antes de qualquer deploy.
