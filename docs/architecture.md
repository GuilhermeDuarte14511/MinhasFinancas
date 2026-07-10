# Arquitetura

O Nossa Grana é um monólito modular. A aplicação Flutter compartilha domínio,
casos de uso e apresentação entre Android e Web.

## Camadas

- `core`: falhas tipadas, `Result` e `Money`.
- `features/*/domain`: entidades, value objects e políticas sem Flutter ou Firebase.
- `features/*/application`: estado e orquestração; depende do domínio.
- `features/*/infrastructure`: futuro SDK gerado pelo SQL Connect e adaptadores de plataforma.
- `features/*/presentation`: páginas e componentes Flutter.
- `app`: tema, router e composição no limite da aplicação.

O fluxo de dependências é `Presentation -> Application -> Domain`. A
Infrastructure implementará portas definidas pela Application. Riverpod faz a
composição; widgets não calculam parcelas nem saldos.

## Contextos

1. Identity and Access.
2. Financial Spaces and Membership.
3. Credit Cards and Purchases.
4. Billing and Payments.
5. Loans.
6. Reminders and Notifications.
7. Dashboard and Reporting.

## Fluxo atual e futuro

Na demonstração, `FinanceController` mantém uma projeção imutável da sessão. Uma
compra chama `InstallmentScheduleGenerator`, atualiza o cartão/fatura e adiciona
auditoria visual. Um pagamento atualiza a fatura e libera limite.

Com SQL Connect, o controller será dividido em casos de uso e repositórios. Cada
mutação crítica será uma operação server-side única e idempotente; o cliente
receberá apenas o resultado tipado. O SDK gerado ficará em
`features/*/infrastructure/sql_connect_generated`.

## Plataformas

O domínio não contém `kIsWeb`. Diferenças ficam nas bordas. A opção de instalar
a PWA só aparece no Web; notificações usarão FCM no Android, Web Push quando
suportado e avisos internos como fallback.
