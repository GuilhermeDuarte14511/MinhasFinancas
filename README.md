# Nossa Grana

Aplicativo Flutter de gestão financeira compartilhada para casais e famílias.
O mesmo código gera um APK Android e uma PWA para Safari no iPhone.

## Estado atual

Esta entrega implementa o fluxo funcional do aplicativo com autenticação
Firebase e persistência no Firebase Data Connect:

- login, criação de conta e onboarding;
- criação, edição, arquivamento e troca de espaço financeiro;
- dashboard com faturas, limites, vencimentos e atividades;
- cartões com detalhe/edição, compras à vista/parceladas e atualização de limite;
- detalhes da fatura e pagamento parcial/total;
- agenda, empréstimos/pagamentos, categorias, membros, papéis e convites;
- preferências detalhadas, registro FCM/Web e instalação PWA;
- schema relacional, operações seguras e SDK Flutter gerado pelo Data Connect;
- testes unitários das regras de dinheiro e parcelamento.

Usuários, espaços, membros, convites, categorias, cartões, compras, parcelas,
faturas, pagamentos, empréstimos e preferências de notificação são persistidos
no projeto `minhasfinancasofc`. Convites geram um link seguro compartilhável;
o envio automático por e-mail e push ainda depende de um serviço de entrega.

## Stack e arquitetura

- Flutter estável e Material Design 3;
- Riverpod para estado e composição;
- GoRouter para rotas e URLs diretas;
- Intl em `pt_BR`;
- monólito modular com Domain, Application, Infrastructure e Presentation;
- Firebase Authentication e Data Connect como infraestrutura de produção.

Decisões e dependências estão em [docs/architecture.md](docs/architecture.md).
O fluxo completo de telas e navegação está em
[docs/workflow-do-app.md](docs/workflow-do-app.md).

## Pré-requisitos

- Flutter 3.44 ou compatível;
- Dart fornecido pelo Flutter;
- Chrome para desenvolvimento Web;
- Android SDK 36/JDK 17 para Android;
- Firebase CLI e FlutterFire CLI para gerar SDKs e publicar o backend.

## Instalação e execução

```bash
flutter pub get
flutter run -d chrome
```

Para listar dispositivos Android:

```bash
flutter devices
flutter run -d ID_DO_DISPOSITIVO
```

## Qualidade

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

## Build Android

```bash
flutter build apk --debug
```

Saída: `build/app/outputs/flutter-apk/app-debug.apk`.

Instalação por USB:

```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

O build release está intencionalmente sem chave de assinatura. Crie uma
keystore privada fora do repositório, configure credenciais via arquivo local
ignorado e só então execute `flutter build apk --release`. Nunca versione a
keystore ou suas senhas.

O identificador provisório é `br.com.nossagrana.app`. Para alterá-lo, atualize
`namespace`, `applicationId`, o pacote de `MainActivity` e refaça a configuração
FlutterFire do aplicativo Android.

## Build Web/PWA

```bash
flutter build web --release
```

Saída: `build/web`. O `firebase.json` publica somente esse diretório e reescreve
rotas inexistentes para `index.html`.

No iPhone, abra a URL no Safari, toque em Compartilhar, escolha **Adicionar à
Tela de Início**, ative **Abrir como App da Web** e confirme em **Adicionar**.

## Firebase Data Connect

O projeto está configurado para `minhasfinancasofc`, com o serviço Data Connect
em `southamerica-east1`. Para atualizar o SDK após alterar schema ou operações:

```bash
firebase dataconnect:sdk:generate --project minhasfinancasofc
firebase emulators:start --only auth,dataconnect,hosting
```

O SDK gerado permanece em
`lib/features/finance/infrastructure/sql_connect_generated`; o repositório da
camada de infraestrutura converte os DTOs antes de entregá-los à aplicação.

Publicação manual:

```bash
firebase deploy --only hosting
firebase deploy --only dataconnect
```

Consulte [dataconnect/README.md](dataconnect/README.md) para detalhes do modelo.

Referências oficiais: [SDK Flutter do SQL Connect](https://firebase.google.com/docs/sql-connect/flutter-sdk)
e [configuração do Firebase Hosting](https://firebase.google.com/docs/hosting/full-config).

## Segurança

O app nunca solicita ou armazena número completo do cartão, CVV, senha do cartão
ou senha do usuário. Cartões guardam apenas apelido, titular, limite, datas e os
últimos quatro dígitos. Leia [docs/security.md](docs/security.md).

## Troubleshooting

- Se o Dart tentar escrever em uma pasta pessoal somente leitura, use uma HOME
  temporária: `HOME=/tmp flutter analyze`.
- Se `pt_BR` falhar em datas, confirme que `flutter_localizations` e a chamada a
  `initializeDateFormatting('pt_BR')` permanecem configuradas.
- Se uma URL direta da PWA retornar 404, sirva com o rewrite do `firebase.json`,
  não com um servidor estático sem fallback.
- Se `flutter test` falhar ao abrir `127.0.0.1`, o sandbox precisa permitir um
  socket local para o runner do Flutter.
