# ADR 0004 — Firebase SQL Connect

O backend relacional usa Firebase SQL Connect e PostgreSQL. O SDK Dart é gerado
a partir do schema/operações e fica isolado na Infrastructure. Firestore não é
adicionado como segunda fonte de dados.
