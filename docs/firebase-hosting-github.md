# Firebase com GitHub Actions

Este projeto Flutter usa o Firebase Data Connect como backend e publica o conteúdo de `build/web` no Firebase Hosting do projeto `minhasfinancasofc`.

## Workflows

- `firebase-hosting-preview.yml`: cria uma URL temporária do Flutter Web para cada pull request, sem alterar o Data Connect de produção.
- `firebase-hosting-live.yml`: publica a aplicação quando uma alteração entra na branch `main` ou quando o workflow é executado manualmente.

## Ordem da publicação em produção

O workflow de produção executa as etapas nesta ordem:

1. autentica no Google Cloud;
2. publica schema e conectores do Firebase Data Connect;
3. executa `flutter build web --release`;
4. publica o resultado no canal `live` do Firebase Hosting.

Se a publicação do Data Connect falhar, o Hosting não é atualizado. Isso evita publicar uma versão do aplicativo que dependa de um backend ainda não implantado.

## Credencial obrigatória

Os workflows esperam o secret abaixo no repositório:

```text
FIREBASE_SERVICE_ACCOUNT_MINHASFINANCASOFC
```

O valor deve ser o JSON completo de uma conta de serviço com permissão para publicar o Firebase Data Connect e o Firebase Hosting.

A forma recomendada pelo Firebase para criar a conta de serviço e enviar a chave criptografada ao GitHub é executar, em um ambiente autenticado com acesso ao projeto:

```bash
firebase init hosting:github
```

Ao configurar pelo assistente, use:

- projeto: `minhasfinancasofc`;
- repositório: `GuilhermeDuarte14511/MinhasFinancas`;
- comando de build: `flutter build web --release`;
- branch de produção: `main`.

A chave JSON nunca deve ser adicionada diretamente ao repositório. Enquanto o secret não existir, os workflows exibem um aviso e ignoram a publicação sem marcar a execução como falha.
