# ADR 0006 — Concorrência e Hosting

Escritas financeiras críticas serão mutações atômicas com idempotência e versão
otimista. A PWA é uma SPA hospedada em Firebase Hosting, com rewrite para
`index.html`, cache curto do shell e cache maior de assets.
