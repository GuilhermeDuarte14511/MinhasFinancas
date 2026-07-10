# Segurança

## Identidade e autorização

Firebase Authentication será a fonte de identidade. O UID autenticado cria o
vínculo com `UserProfile`; IDs de ator nunca serão aceitos do cliente. Toda query
e mutation deverá usar `@auth(level: USER)` e verificar membership ativa no
espaço solicitado.

Papéis:

- Owner administra dados, membros e propriedade;
- Editor altera dados financeiros, sem remover o último Owner;
- Viewer possui leitura e preferências próprias.

## Dados proibidos

Não armazenar senha, número completo de cartão, CVV, senha de cartão, keystore,
service account, chave privada, token de deploy ou convite puro. Logs não devem
conter token/endpoint completo.

## Operações críticas

Criação de espaço, aceite de convite, compra/parcelas/faturas, pagamentos,
reversões, empréstimos e transferência de propriedade devem ser mutações
atômicas no servidor. Use idempotency keys e versionamento otimista.

Antes da produção: habilitar e validar e-mail, App Check, menor privilégio IAM,
headers de Hosting, orçamento, alertas e testes de isolamento entre tenants.
