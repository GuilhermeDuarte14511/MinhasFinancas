# Handoff para continuar no Codex

Atualizado em 12/07/2026. Este documento é autocontido e não contém códigos de
autorização, tokens ou segredos.

## Estado do repositório

- Branch: `main`.
- Commit atual: `422ac0a` (`ajustes`).
- `main` está sincronizada com `origin/main`.
- Worktree contém alterações locais ainda não commitadas da evolução para
  controle financeiro geral e dos ajustes responsivos. Não descartar nem
  sobrescrever essas alterações.
- Projeto Firebase: `minhasfinancasofc`.
- Região Data Connect: `southamerica-east1`.
- Serviço: `minhasfinancasofc-service`.
- Connector: `client`.
- Hosting: <https://minhasfinancasofc.web.app>.
- Console: <https://console.firebase.google.com/project/minhasfinancasofc/overview>.

## Onde paramos exatamente

Foi concluída e publicada a evolução para um controle financeiro geral, com
receitas/despesas previstas, recorrência, Agenda canônica, exclusões por escopo
e exclusão transacional de cartão em cascata.

Em 12/07/2026 a versão foi validada e publicada com sucesso:

- `dart analyze`: sem problemas;
- `flutter test`: 56 testes aprovados;
- `flutter build web --release`: aprovado e gerou `build/web`;
- migration aditiva do Data Connect aplicada;
- schema e connector `client` publicados em `southamerica-east1`;
- Hosting publicado em <https://minhasfinancasofc.web.app>;
- raiz, rotas SPA, manifesto, runtime e service worker responderam HTTP 200;
- arquivos estáveis do runtime usam revalidação e imagens/fontes mantêm cache
  longo.

## Comandos para começar a próxima sessão

Execute na raiz do projeto:

```bash
git status
git log -1 --oneline
firebase login
firebase use minhasfinancasofc
flutter pub get
dart format --output=none --set-exit-if-changed lib test
dart analyze
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

O SDK já foi regenerado e está nas alterações locais. Se for necessário gerar
novamente, confira em `sql_connect_generated/client.dart` que
`bigIntToJson(BigInt? value)` continua aceitando nulo; a versão atual do gerador
produziu assinatura não anulável incompatível com agregações opcionais. Depois,
rode `dart format lib test` e repita análise/testes antes dos deploys.

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

### Fluxo de caixa e visão financeira geral

- Lançamentos de entrada: salário, 13º, férias, bônus, reembolso e outras
  entradas.
- Lançamentos de saída: boleto/conta, compra em dinheiro, assinatura, imposto e
  outras despesas.
- Formas de pagamento: Pix, dinheiro, transferência, débito e outra.
- Valores persistidos em centavos inteiros, sem ponto flutuante.
- `CashFlowEntry` funciona como livro financeiro com competência mensal,
  origem, idempotência, auditoria, status previsto/realizado e série opcional.
- Receitas futuras ficam `PLANNED` e só entram no realizado após confirmação;
  a Home separa realizado, previsto e projeção do mês.
- Recorrências semanal, quinzenal, mensal e anual preservam o dia preferencial,
  inclusive dias 30/31, fevereiro e virada do ano.
- Edição/exclusão recorrente aceita somente a ocorrência, esta e as próximas ou
  toda a série. Ocorrências excluídas mantêm tombstone para não reaparecerem.
- A Agenda projeta os próprios registros de fluxo, faturas, parcelas e
  empréstimos; não existe cópia desconectada.
- Cartões entram pelo total de cada fatura no seu mês de referência; uma compra
  de R$ 1.200 em 12x não reduz o resultado de um único mês em R$ 1.200.
- Empréstimos entram pelos pagamentos confirmados e preservam o histórico
  anterior à evolução do fluxo de caixa.
- Pagamento de fatura não vira nova despesa, evitando dupla contagem.
- Home prioriza resultado do mês, total que entrou, total que saiu, sobra ou
  falta, gráfico anual, totais históricos, lançamentos recentes e compromissos.
- A seção de cartões foi mantida, mas deslocada para baixo na rolagem.
- Agregações mensal/anual/histórica são obtidas no Data Connect; existe fallback
  local temporário para a janela de atualização entre backend e cliente.

### Compras, parcelas e faturas

- Compra à vista ou parcelada de 1 a 24 vezes.
- Prévia de parcelas e impacto no limite.
- Primeira fatura calculada considerando o dia de fechamento.
- Compra antes ou no fechamento permanece no ciclo atual; compra posterior vai
  ao próximo. Vencimentos inexistentes são limitados ao último dia do mês.
- Criação de compra, faturas e parcelas com transações por etapa e compensação
  automática caso o cronograma falhe no meio.
- Detalhe da compra usa parcelas reais do banco; não inventa mais estados.
- Editar descrição/categoria e cancelar compra.
- Cartão pode ser excluído permanentemente em uma mutation transacional que
  remove pagamentos, parcelas, faturas e compras dependentes.
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
/new-income
/new-expense
/cash-flow/:entryId
```

O botão central `Novo` abre uma bottom sheet rolável com entrada, saída, compra
no cartão, cartão e empréstimo. A compra fica bloqueada e explicada quando não
há cartão ou o usuário é VIEWER.

Foram criadas telas adicionais para:

- detalhe/edição de cartão;
- convites pendentes;
- detalhe/pagamento de empréstimo;
- perfil;
- segurança;
- ajuda;
- offline;
- configuração do workspace.

Os ajustes visuais atuais também incluem:

- Membros sem quebra de nome/e-mail em letras isoladas em celulares estreitos;
- Cartões com métricas empilhadas quando necessário e respiros consistentes;
- limite do cartão com máscara monetária brasileira durante a digitação;
- login, criação de conta e onboarding com ritmo vertical responsivo;
- animações de entrada, números e gráfico que respeitam a preferência de reduzir
  movimento do sistema.

## Data Connect implementado

Arquivo principal:
`dataconnect/connectors/client/operations.gql`.

Operações disponíveis incluem:

- perfil: get/create/update;
- workspace: list/snapshot/create/update/archive;
- convite: list/create/accept/revoke;
- membros: update role/remove;
- categorias: create/update/archive;
- cartões: create/update/archive/delete cascade;
- compras: create/update/cancel;
- faturas/parcelas: find/create/add/cancel;
- pagamentos: parcial e quitação total;
- empréstimos: create/add installment/pay/cancel;
- fluxo de caixa: criar, agendar, confirmar, editar/excluir por escopo e
  recorrência materializada;
- o resumo agrega movimentações manuais, faturas por competência e pagamentos
  de empréstimo diretamente das tabelas canônicas;
- notificações: preference/rules/device subscription.

O SDK fica em:
`lib/features/finance/infrastructure/sql_connect_generated`.

O adapter principal fica em:
`lib/features/finance/infrastructure/sql_connect_finance_repository.dart`.

## Validações já executadas

Na versão local atual:

- migration Data Connect aplicada e deploy confirmado;
- SDK Dart regenerado para as novas operações;
- `dart analyze`: sem problemas;
- `flutter test`: 56 testes aprovados;
- testes de responsividade em 320 x 800 para Membros, Cartões, Adicionar cartão
  e a nova Home financeira, além do formulário geral e seletor de espaços;
- testes de máscara BRL, inclusive colagem e valores grandes;
- testes exatos de totais mensais, anuais, históricos e competência mensal;
- `flutter build web --release`: aprovado em 12/07/2026;
- Data Connect e Hosting publicados em 12/07/2026;
- URL pública, rotas SPA, manifesto, JS principal e service worker retornaram
  HTTP 200 com cache e headers de segurança confirmados.

## Arquivos importantes

- `promptInicial.txt`: requisitos completos.
- `prototipo_telas/stitch_nossa_grana_pwa_design_system`: protótipos.
- `docs/workflow-do-app.md`: workflow consolidado.
- `docs/architecture.md`: arquitetura atualizada.
- `lib/app/routing/app_router.dart`: todas as rotas.
- `lib/features/finance/application/finance_controller.dart`: estado e fluxo.
- `lib/features/finance/application/finance_repository.dart`: contrato de dados.
- `lib/features/finance/domain/finance_models.dart`: modelos financeiros.
- `lib/features/finance/domain/cash_flow.dart`: livro e projeções financeiras.
- `lib/features/finance/presentation/add_cash_flow_entry_page.dart`: formulário
  de entrada/saída.
- `lib/features/dashboard/presentation/dashboard_page.dart`: Home financeira.
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
docs/workflow-do-app.md. Preserve o worktree local: ele contém a evolução para
fluxo de caixa geral e os ajustes responsivos. Rode analyze/test/build e
publique primeiro o Data Connect e, somente após concluir, o Hosting. Depois
confirme a PWA, headers e um lançamento de entrada/saída na URL pública. Não
regenere o SDK sem preservar a correção anulável de `bigIntToJson`. Não refaça o
que já está implementado nem apague alterações existentes. O worker que envia
push automaticamente continua sendo uma pendência separada.
```
