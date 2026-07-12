# Firebase Hosting com GitHub Actions

Este projeto Flutter publica o conteúdo de `build/web` no Firebase Hosting do projeto `minhasfinancasofc`.

## Workflows

- `firebase-hosting-preview.yml`: cria uma URL temporária para cada pull request.
- `firebase-hosting-live.yml`: publica no canal `live` quando uma alteração entra na branch `main` ou quando o workflow é executado manualmente.

O workflow de produção publica somente o Flutter Web no Firebase Hosting. Alterações do Firebase Data Connect devem ser implantadas separadamente quando realmente existirem.

## Credencial obrigatória

Os workflows esperam o secret abaixo no repositório:

```text
FIREBASE_SERVICE_ACCOUNT_MINHASFINANCASOFC
```

O valor deve ser o JSON completo de uma conta de serviço com permissão para publicar no Firebase Hosting.

A forma recomendada pelo Firebase para criar a conta de serviço e enviar a chave criptografada ao GitHub é executar, em um ambiente autenticado com acesso ao projeto:

```bash
firebase init hosting:github
```

Ao configurar pelo assistente, use:

- projeto: `minhasfinancasofc`;
- repositório: `GuilhermeDuarte14511/MinhasFinancas`;
- comando de build: `flutter build web --release`;
- branch de produção: `main`.

A chave JSON nunca deve ser adicionada diretamente ao repositório. Enquanto o secret não existir, os workflows exibem um aviso e ignoram o deploy sem marcar a execução como falha.
