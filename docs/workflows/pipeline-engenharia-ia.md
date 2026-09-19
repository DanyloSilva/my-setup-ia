# 🏭 Esteira de Engenharia de Software com IA & Observabilidade First

> **Referência:** Baseado nos padrões de engenharia e cultura de produto discutidos por **Augusto Galego** e **Samuel (Sam)** no painel *Fluxos de Desenvolvimento com IA* ([Vídeo](https://www.youtube.com/live/F5IliRRcIck)).

---

## 🎯 Visão Geral da Esteira

Integrar IA no ciclo de desenvolvimento não significa terceirizar o pensamento crítico da engenharia. A esteira divide o trabalho de forma inteligente entre **decisão humana** (estratégia, arquitetura, critérios) e **execução de IA** (implementação acelerada, geração de boilerplate, testes guiados).

```
[ 1. RFC & System Design ] ──> [ 2. Product Card ] ──> [ 3. Technical Card ] ──> [ 4. Execução IA ] ──> [ 5. Review & Deploy ]
     Decisão Humana               Problema/Regra de          Endpoints, Schema,          TDD Guiado,             Review Humano
     (Arquitetura/Design)         Negócio (Dor real)         Observabilidade, Flags      Micro-PR <500 lin       (<15 min)
```

---

## 1. Rito de Arquitetura Humana: A RFC (Request for Comments)

Antes de abrir qualquer editor com IA ou mandar prompts para gerar código, decisões arquiteturais devem ser tomadas e documentadas por humanos.

### Por que manter a decisão humana na arquitetura?
- **Preservação de Ownership:** Quando o desenvolvedor perde o input na tomada de decisão arquitetural, ele perde o domínio sobre a base de código e a motivação do projeto.
- **Evitar Débito Invisível:** Modelos de IA tomam atalhos arquiteturais (ex: omitir índices em bancos, queries N+1, acoplamento indevido, ausência de paginação) que causam falhas graves em escala.
- **Formato Prático:**
  - Discussão técnica no time (usando ferramentas visuais como Excalidraw ou Miro para System Design: filas, tabelas, contratos de API).
  - Documento simples de RFC versionado no repositório (ex: `docs/rfcs/RFC-001-nome.md`) ou aberto como Pull Request para alinhamento da equipe.

---

## 2. Separação de Cards: Produto vs Técnico

Uma das principais causas de falha e perda de contexto de agentes de IA é misturar discussão de negócio com detalhes de infraestrutura no mesmo prompt.

### 📌 Card de Produto (Product Card)
- **Foco:** Dor do usuário, valor de negócio, jornadas e critérios de aceitação funcionais.
- **Quem escreve/refina:** Product Manager / Tech Lead / Dev com apoio de IA.
- **Conteúdo:** Problema a ser resolvido, persona afetada, cenários de negócio e regras de validação.

### ⚙️ Card Técnico (Technical Card)
- **Foco:** Como o sistema vai atender ao requisito tecnicamente.
- **Alimentação:** Lê o Card de Produto + a RFC de Arquitetura + o Codebase.
- **Conteúdo Obrigatório:**
  1. Contratos de API / Endpoints (rotas, payloads, códigos HTTP).
  2. Modelagem de dados e migrações (tabelas, colunas, índices essenciais).
  3. Estratégia de **Observabilidade** (logs, métricas, eventos).
  4. Estratégia de **Rollout/Rollback** (feature flags, migrações compatíveis).
  5. Checklist de testes automatizados esperados.

---

## 3. Métricas de Engenharia e Prevenção de Gargalos

### Cycle Time Saudável
- **Referência de Mercado:** Um bom cycle time para fechar um card técnico é de **~24 horas** (ou 14 a 16 horas em equipes de alta performance).
- **O Paradoxo da Delegação Cega:** Equipes que apenas jogam requisitos soltos para a IA sem cards atômicos acabam sofrendo com PRs gigantescos, revisões infinitas, regressões constantes e um cycle time que dispara para vários dias.

### A Regra dos Micro-PRs (< 500 linhas)
- O tamanho do PR deve ser mantido estritamente em **menos de 500 linhas de código** (excluindo testes e documentação).
- **Vantagens:**
  1. **Menor Alucinação:** Menor escopo de arquivos significa menor probabilidade de o agente se perder ou gerar código colateral.
  2. **Code Review Veloz:** Um PR de tamanho reduzido com testes claros pode ser revisado com segurança por um humano em **10 a 15 minutos**.
  3. **Rollback Simples:** Em caso de anomalia em produção, reverter uma alteração pequena e isolada é trivial.

---

## 4. Observabilidade First & Debugging via MCP

### O Princípio Fail-Safe vs Fail-Fast
- **Fail-Safe (Seguro contra falhas):**
  - Tudo o que não for estritamente vital para a sobrevivência do fluxo principal deve ser desenhado para ser tolerante a falhas.
  - Notificações secundárias, envio de emails não impeditivos, enriquecimento de analytics e logs assíncronos não podem derrubar uma transação de produção.
- **Fail-Fast (Falhe rápido):**
  - Regras de domínio e validações de integridade crítica (ex: saldo insuficiente, transação duplicada, assinatura inválida) devem interromper a execução imediatamente e registrar erro explícito.

### Instrumentação e Alertas
- Instrumentar eventos de negócio e runtime (ex: contadores de erro, latência por rota, alertas do tipo *fast burning* que indicam esgotamento rápido de taxa de erro).
- **Uso de MCPs de Observabilidade (ex: New Relic, Datadog, CloudWatch):**
  - Ao invés de tentar reproduzir bugs complexos manualmente no ambiente local, conecte o agente aos logs e traces reais via MCP.
  - O agente inspeciona o stack trace real, analisa o payload que gerou a exceção em produção e propõe a correção pontual no código.

---

## 5. Disciplina de Testes e Combate ao Débito Cognitivo

### "Escreva o Critério e LEIA o Teste"
- **O Mito de Não Ler Código:** A promessa de nunca mais precisar ler código é uma armadilha que acumula dívida técnica invisível.
- Nunca aprove testes gerados automaticamente por IA sem abrir o arquivo e **ler as asserções (`expect`, `assert`)**. É frequente agentes gerarem testes "tautológicos" (testes que sempre passam sem validar o comportamento real).

### TDD Assistido por IA
- O fluxo mais robusto de engenharia com IA:
  1. O desenvolvedor escreve o teste unitário/integração com os cenários de sucesso e falha (ou fornece as asserções exatas).
  2. O teste é executado e falha (Red).
  3. O agente de IA implementa o código de produção com o objetivo de fazer o teste passar (Green).
  4. O código é refatorado com segurança (Refactor).

### Combate ao "AI Slop" na Documentação
- Evite encher a base de código com dezenas de arquivos markdown longos e superficiais gerados por IA que ninguém na equipe lê.
- O excesso de documentação prolixa gera **débito cognitivo** e satura o contexto de ferramentas de busca e agentes subsequentes.
- Toda documentação mantida no repositório deve ser enxuta, intencional e revisada por humanos.
