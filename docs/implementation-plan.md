# Plano de implementação

## Concluído

- Fundação Android/Web, tema, router, Riverpod, Result, Failure e Money.
- Fluxos de acesso/onboarding em modo de demonstração.
- Dashboard, cartões, compras, faturas, pagamentos e agenda.
- Empréstimos, categorias, membros, lembretes e instalação PWA.
- Schema inicial das 18 tabelas e exemplos de operação autenticada.
- Testes de Money, parcelamento e validação do login.
- Firebase Hosting, manifest PWA e CI sem deploy.

## Próxima fase

- escolher projeto Firebase e estratégia de Cloud SQL;
- executar FlutterFire e gerar o SDK Dart do SQL Connect;
- substituir o controller de sessão por use cases/repositórios reais;
- implementar mutações atômicas, autorização e isolamento;
- integrar Authentication Emulator e SQL Connect Emulator.

## Fases posteriores

- cronogramas Price/SAC e pagamentos/reversões completos;
- FCM Android, Web Push e fallback interno persistente;
- App Check, acessibilidade, testes de integração e performance;
- assinatura privada de APK e deploy manual aprovado.
