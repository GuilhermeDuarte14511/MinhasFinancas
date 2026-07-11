# Handoff para continuar no Codex

Atualizado em 11/07/2026. Este documento é autocontido e não contém códigos de
autorização, tokens ou segredos.

## Estado do repositório

- Branch: `main`.
- Commit atual: `422ac0a` (`ajustes`).
- `main` está sincronizada com `origin/main`.
- Worktree estava limpo no momento da criação deste handoff.
- Projeto Firebase: `minhasfinancasofc`.
- Região Data Connect: `southamerica-east1`.
- Serviço: `minhasfinancasofc-service`.
- Connector: `client`.
- Hosting: <https://minhasfinancasofc.web.app>.
- Console: <https://console.firebase.google.com/project/minhasfinancasofc/overview>.

## Onde paramos exatamente

A implementação do app, as novas telas, o SDK Data Connect e a última correção
de quitação de fatura estão no repositório. A correção final adicionou a
mutation `RegisterFullInvoicePayment`, que atualiza atomicamente a fatura, o
pagamento, a auditoria e todas as parcelas daquela fatura.

A sessão foi interrompida durante a confirmação final do build. O arquivo
`build/web/main.dart.js` foi gerado às 16:31, mas, para não depender de um
processo interrompido, a próxima sessão deve repetir análise, testes e build.

Importante: o Data Connect e o Hosting foram publicados antes da última
correção `RegisterFullInvoicePayment`. Portanto, os dois primeiros resultados a
garantir na próxima sessão são:

1. Validar novamente o projeto local.
2. Republicar `dataconnect` e `hosting` com o commit atual.

## Comandos para começar a próxima sessão

Execute na raiz do projeto:

```bash
git status
git log -1 --oneline
firebase login
firebase use minhasfinancasofc
flutter pub get
firebase dataconnect:sdk:generate --project minhasfinancasofc
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web --release
firebase deploy --only dataconnect --project minhasfinancasofc
firebase deploy --only hosting --project minhasfinancasofc
curl -I https://minhasfinancasofc.web.app
```

Resultado esperado do `curl`:

- HTTP 200.
- `cache-control: no-cache, no-store, must-revalidate` na rota inicial.
- `x-content-type-options: nosniff`.
- `referrer-policy: strict-origin-when-cross-origin`.

Se o SDK gerado mudar, rode `dart format lib test` e repita análise/testes antes
dos deploys.

## O que foi implementado

### Autenticação e onboarding

- Login por e-mail/senha e Google.
- Recuperação de senha.
- Criação de conta com confirmação de senha e aceite de termos.
- Verificação de e-mail.
- Perfil Firebase vinculado ao `UserProfile` do Data Connect.
- Gate inicial que resolve perfil e workspaces.
- Boas-vindas quando não existe workspace.
- Criar workspace com cor e categorias padrão.
- Aceitar convite por link preservando o redirect durante login/verificação.
- Convidar membro como EDITOR ou VIEWER e copiar link seguro.

### Workspaces, membros e permissões

- Criar, editar, arquivar, listar, selecionar e trocar workspace.
- OWNER, EDITOR e VIEWER carregados do banco.
- UI bloqueia operações de escrita para VIEWER antes da requisição.
- Backend também valida membership e papel em cada operação.
- Listar membros com papel real e indicação do usuário atual.
- Alterar papel, remover membro e proteger o último OWNER.
- Listar e revogar convites pendentes.
- Tela de configuração do workspace.
- Atualização automática do snapshot a cada 30 segundos, além do pull-to-refresh.

### Cartões

- Criar cartão com apelido, últimos quatro dígitos, limite, fechamento,
  vencimento e cor.
- Listar cartões e limites.
- Detalhe do cartão e suas faturas.
- Editar e arquivar cartão.
- Nenhuma tela solicita número completo, CVV ou senha.

### Compras, parcelas e faturas

- Compra à vista ou parcelada de 1 a 24 vezes.
- Prévia de parcelas e impacto no limite.
- Primeira fatura calculada considerando o dia de fechamento.
- Criação de compra, faturas e parcelas com transações por etapa e compensação
  automática caso o cronograma falhe no meio.
- Detalhe da compra usa parcelas reais do banco; não inventa mais estados.
- Editar descrição/categoria e cancelar compra.
- Cancelamento atualiza parcelas e totais das faturas.
- Detalhe da fatura usa a relação real
  `fatura -> parcelas -> compras`, em vez de mostrar todas as compras do cartão.
- Pagamento parcial transacional e idempotente.
- Quitação total com `RegisterFullInvoicePayment`, marcando as parcelas como
  pagas na mesma transação.
- Dashboard usa apenas faturas do mês atual e não possui rótulos de julho fixos.

### Empréstimos

- Criar empréstimo e cronograma.
- Compensação automática cancela o empréstimo se a criação das parcelas falhar.
- Lista e detalhe do contrato.
- Pagamento parcial ou total da próxima parcela pendente.
- Saldo devedor considera pagamentos parciais.
- Agenda usa parcelas/datas financeiras em vez de textos fixos.

### Categorias

- Categorias padrão criadas junto com o workspace.
- Criar, editar e arquivar categorias personalizadas.
- Categorias padrão não podem ser arquivadas.

### Notificações

- Preferência principal persistida.
- Tipos: fechamento de fatura, vencimento de fatura e empréstimo.
- Antecedência e horário persistidos.
- Permissão solicitada somente após ação explícita.
- Token FCM/Web registrado em `DeviceSubscription` com hash e ID determinístico.
- Item de instalação PWA aparece somente na Web.

### Navegação e telas

Rotas existentes:

```text
/gate
/login
/create-account
/verify-email
/welcome
/create-space
/join-space
/invite-member
/app/:section
/new-purchase
/new-card
/card/:cardId
/card/:cardId/edit
/new-loan
/invoice/:invoiceId
/invoice/:invoiceId/payment
/purchase/:purchaseId
/loans
/loans/:loanId
/loans/:loanId/payment
/categories
/members
/workspace-settings
/pending-invitations
/notifications
/install
/profile
/security
/help
/offline
```

O botão central `Novo` abre uma bottom sheet com compra, cartão e empréstimo. A
compra fica bloqueada e explicada quando não há cartão ou o usuário é VIEWER.

Foram criadas telas adicionais para:

- detalhe/edição de cartão;
- convites pendentes;
- detalhe/pagamento de empréstimo;
- perfil;
- segurança;
- ajuda;
- offline;
- configuração do workspace.

## Data Connect implementado

Arquivo principal:
`dataconnect/connectors/client/operations.gql`.

Operações disponíveis incluem:

- perfil: get/create/update;
- workspace: list/snapshot/create/update/archive;
- convite: list/create/accept/revoke;
- membros: update role/remove;
- categorias: create/update/archive;
- cartões: create/update/archive;
- compras: create/update/cancel;
- faturas/parcelas: find/create/add/cancel;
- pagamentos: parcial e quitação total;
- empréstimos: create/add installment/pay/cancel;
- notificações: preference/rules/device subscription.

O SDK fica em:
`lib/features/finance/infrastructure/sql_connect_generated`.

O adapter principal fica em:
`lib/features/finance/infrastructure/sql_connect_finance_repository.dart`.

## Validações já executadas

Antes da última interrupção:

- `firebase dataconnect:sdk:generate`: aprovado, incluindo
  `RegisterFullInvoicePayment`.
- `flutter analyze`: sem problemas após a correção final.
- suíte completa anterior: 12 testes aprovados.
- teste específico de permissão VIEWER incluído e aprovado.
- build Web anterior aprovado; um novo artefato também foi gerado às 16:31, mas
  deve ser repetido por segurança.
- Hosting respondeu HTTP 200.
- Política de cache da rota inicial foi corrigida e confirmada.

## Arquivos importantes

- `promptInicial.txt`: requisitos completos.
- `prototipo_telas/stitch_nossa_grana_pwa_design_system`: protótipos.
- `docs/workflow-do-app.md`: workflow consolidado.
- `docs/architecture.md`: arquitetura atualizada.
- `lib/app/routing/app_router.dart`: todas as rotas.
- `lib/features/finance/application/finance_controller.dart`: estado e fluxo.
- `lib/features/finance/application/finance_repository.dart`: contrato de dados.
- `lib/features/finance/domain/finance_models.dart`: modelos financeiros.
- `dataconnect/schema/schema.gql`: schema relacional.
- `dataconnect/connectors/client/operations.gql`: queries/mutations.
- `firebase.json`: Hosting, rewrites e headers.

## Pendências externas reais

Estas partes não podem ser concluídas apenas com o código cliente atual:

1. Envio automático de convite por e-mail. O link e o registro seguro existem,
   mas é necessário escolher/configurar um provedor como Resend, SendGrid ou
   SMTP e guardar a credencial em Secret Manager.
2. Worker agendado para efetivamente enviar push nos horários das regras. O app
   registra preferências e tokens, mas falta uma Cloud Function/Cloud Scheduler
   que produza e envie as notificações.
3. Teste E2E real com dois usuários Firebase. Os testes atuais cobrem domínio,
   controller, permissões e widgets com repositório falso; ainda é recomendado
   automatizar usuário A/B no Auth + Data Connect Emulator.

Ao continuar, não declare essas três partes concluídas sem configurar o serviço
externo e executar o teste correspondente.

## Prompt sugerido para a nova sessão

```text
Leia integralmente CONTINUAR_CODEX.md, promptInicial.txt e
docs/workflow-do-app.md. Continue exatamente do handoff: valide o commit atual,
regenere o SDK, rode analyze/test/build e publique a versão final no Data
Connect e Hosting. Depois confirme a URL pública. Não refaça o que já está
implementado e não apague alterações existentes. Se houver tempo, prepare o
worker de push e o envio de convites, mas pare antes de escolher um provedor ou
criar segredo sem minha autorização.
```
