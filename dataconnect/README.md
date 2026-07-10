# SQL Connect

O schema inicial está em `schema/schema.gql`. Os arquivos YAML permanecem como
`.example` porque o projeto Firebase, a região, a instância Cloud SQL e o nome do
banco ainda não foram informados. Nenhum recurso externo deve ser criado apenas
para preencher esses campos.

Antes de habilitar o conector:

1. Decida se uma instância Cloud SQL existente pode ser reutilizada.
2. Copie os dois arquivos `.example` removendo o sufixo e preencha os IDs reais.
3. Execute `firebase init dataconnect:sdk` e valide o schema no emulador.
4. Gere o SDK Dart com `firebase dataconnect:sdk:generate`.
5. Revise todas as operações com `@auth(level: USER)` e filtros de membership.
6. Adicione constraints compostas e checks na migração revisada antes do deploy.

O schema não armazena senha, número completo de cartão, CVV ou token de convite
em texto puro. Valores monetários usam `Int64` em centavos e a taxa de juros usa
micros inteiros para evitar ponto flutuante binário.
