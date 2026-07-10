# Custos de infraestrutura

Meta: até R$ 50–60/mês. Nenhum recurso pago foi criado nesta entrega.

Firebase Hosting oferece camada inicial sem custo para uma PWA pequena. Auth
por e-mail e Google costuma caber na faixa gratuita em um uso familiar. O item
de maior risco é Cloud SQL, cujo custo fixo pode ultrapassar a meta conforme
região, máquina, disco e alta disponibilidade.

Antes de provisionar:

1. verificar projeto GCP/Firebase e instância PostgreSQL existente;
2. confirmar região próxima aos usuários e ao serviço SQL Connect;
3. avaliar database/schema isolado na instância existente;
4. evitar alta disponibilidade durante o piloto, se o risco for aceito;
5. configurar orçamento e alertas antes da criação;
6. medir queries, usar paginação, índices e poucos listeners permanentes.

Não há estimativa numérica confiável sem projeto, região, moeda de cobrança e
instância escolhida. A decisão deve ser aprovada antes de criar Cloud SQL.
