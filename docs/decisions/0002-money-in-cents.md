# ADR 0002 — Dinheiro em centavos

Valores monetários usam `int`/`Int64` em centavos. Ponto flutuante binário é
proibido em cálculos financeiros. Parcelas distribuem o resto determinística e
exatamente.
