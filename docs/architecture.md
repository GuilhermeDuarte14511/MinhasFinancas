# Arquitetura

O Nossa Grana é um monólito modular. A aplicação Flutter compartilha domínio,
casos de uso e apresentação entre Android e Web.

## Camadas

- `core`: falhas tipadas, `Result` e `Money`.
- `features/*/domain`: entidades, value objects e políticas sem Flutter ou Firebase.
- `features/*/application`: estado e orquestração; depende do domínio.
- `features/*/infrastructure`: SDK gerado pelo Data Connect e adaptadores de plataforma.
- `features/*/presentation`: páginas e componentes Flutter.
- `app`: tema, router e composição no limite da aplicação.

O fluxo de dependências é `Presentation -> Application -> Domain`. A
Infrastructure implementa portas definidas pela Application. Riverpod faz a
composição; widgets não calculam parcelas nem saldos.

## Contextos

1. Identity and Access.
2. Financial Spaces and Membership.
3. Credit Cards and Purchases.
4. Billing and Payments.
5. Loans.
6. Reminders and Notifications.
7. Dashboard and Reporting.

## Fluxo atual

`FinanceController` mantém uma projeção imutável do workspace e coordena o
`FinanceRepository`. O repositório Data Connect executa consultas `serverOnly`,
mutations autorizadas e recarrega a projeção após gravações. Compras e
empréstimos usam operações transacionais por etapa com compensação automática
se a criação do cronograma falhar. Pagamentos são transacionais e idempotentes.
O SDK tipado fica em `features/finance/infrastructure/sql_connect_generated`.

## Plataformas

O domínio não contém `kIsWeb`. Diferenças ficam nas bordas. A opção de instalar
a PWA só aparece no Web. O cliente solicita permissão de notificação após ação
explícita, registra tokens FCM/Web e mantém avisos internos como fallback.
