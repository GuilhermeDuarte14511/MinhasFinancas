# Nossa Grana

Aplicativo Flutter de gestão financeira compartilhada para casais e famílias.
O mesmo código gera um APK Android e uma PWA para Safari no iPhone.

## Estado atual

Esta entrega implementa um MVP demonstrável com dados locais em memória:

- login, criação de conta e onboarding;
- criação de espaço financeiro;
- dashboard com faturas, limites, vencimentos e atividades;
- cartões, compras à vista/parceladas e atualização de limite;
- detalhes da fatura e pagamento parcial/total;
- agenda, empréstimos, categorias, membros e convites;
- preferências de lembretes e instruções de instalação PWA;
- schema inicial das 18 tabelas do SQL Connect;
- testes unitários das regras de dinheiro e parcelamento.

Os formulários são funcionais durante a sessão, mas ainda não persistem no
Firebase. Esse comportamento é explícito na tela de login. A autenticação,
sincronização entre usuários, push e SDK gerado entram após a definição do
projeto Firebase e da instância PostgreSQL.

## Stack e arquitetura

- Flutter estável e Material Design 3;
- Riverpod para estado e composição;
- GoRouter para rotas e URLs diretas;
- Intl em `pt_BR`;
- monólito modular com Domain, Application, Infrastructure e Presentation;
- Firebase Authentication e SQL Connect como infraestrutura planejada.

Decisões e dependências estão em [docs/architecture.md](docs/architecture.md).

## Pré-requisitos

- Flutter 3.44 ou compatível;
- Dart fornecido pelo Flutter;
- Chrome para desenvolvimento Web;
- Android SDK 36/JDK 17 para Android;
- Firebase CLI e FlutterFire CLI somente para integrar o backend.

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

## Firebase e SQL Connect

As CLIs não estão instaladas neste workspace e não há credenciais do projeto.
Quando os IDs reais estiverem disponíveis:

```bash
dart pub global activate flutterfire_cli
flutterfire configure --platforms=android,web
firebase init dataconnect:sdk
firebase dataconnect:sdk:generate
firebase emulators:start --only auth,dataconnect,hosting
```

Copie `.firebaserc.example` para `.firebaserc` e preencha o project ID. Faça o
mesmo com os YAMLs em `dataconnect/`. O SDK gerado deve permanecer na camada
`infrastructure`; DTOs gerados não devem chegar aos widgets ou ao domínio.

O deploy é manual e não foi executado:

```bash
firebase deploy --only hosting
firebase deploy --only dataconnect
```

Revise custo e autorização antes do segundo comando. Consulte
[dataconnect/README.md](dataconnect/README.md).

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
