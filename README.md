# Maternar Frontend

Aplicativo Flutter do projeto Maternar, com foco em acompanhamento gestacional preventivo e jornada de cuidado para gestantes.

## Visao geral

O app foi construido com Flutter e Material 3, com interface mobile-first, identidade visual personalizada e navegacao por rotas para fluxos principais de onboarding, cadastro e acompanhamento.

## Funcionalidades atuais

- Tela de boas-vindas com entrada para criacao de conta e acesso de usuaria ja cadastrada.
- Fluxo de cadastro com validacoes de formulario.
- Regras de senha com medidor de forca.
- Mascara de telefone em tempo real.
- Navegacao para telas de questionario, resultados, registro diario e conteudo educativo.
- Estrutura de dashboard com fonte de dados local para prototipacao.

## Stack

- Flutter SDK 3.8+
- Dart 3.8+
- Material 3
- google_fonts

## Estrutura principal

- `lib/main.dart`: ponto de entrada e composicao principal da interface.
- `lib/home_dashboard_data_source.dart`: dados/fonte local para dashboard e conteudos.
- `assets/images/`: imagens utilizadas no app.
- `src/images/`: imagens complementares do projeto.
- `test/widget_test.dart`: testes iniciais de widget.

## Requisitos

- Flutter instalado e configurado no PATH.
- Um dispositivo/emulador Android, iOS, Web ou Desktop disponivel.

Para validar o ambiente:

```bash
flutter doctor
```

## Como executar localmente

1. Instale dependencias:

```bash
flutter pub get
```

2. Liste os dispositivos disponiveis:

```bash
flutter devices
```

3. Rode o app no dispositivo desejado:

```bash
flutter run -d <device_id>
```

Exemplo:

```bash
flutter run -d emulator-5554
```

## Comandos uteis

```bash
flutter analyze
flutter test
flutter clean
```

## Rotas principais da aplicacao

- `/`: tela inicial (boas-vindas).
- `/signup`: cadastro de usuaria.
- `/home`: area principal do app.
- `/questionnaire`: questionario de triagem.
- `/processing`: processamento de perfil.
- `/safe-path`: resultado de risco controlado.
- `/high-alert`: resultado de alerta elevado.
- `/daily-log`: registro diario.
- `/education`: artigos educativos.
- `/baby-week`: planejamento por semana.
- `/nutrition`: dicas nutricionais.
- `/notifications`: central de notificacoes.

## Status do projeto

Frontend em desenvolvimento ativo, com base visual e fluxos principais implementados.

## Contribuicao

1. Crie uma branch a partir da `main` (ou use a branch de desenvolvimento definida pelo time).
2. Faca commits pequenos e descritivos.
3. Abra Pull Request com resumo claro das alteracoes.

## Licenca

Definir conforme a estrategia do projeto.
