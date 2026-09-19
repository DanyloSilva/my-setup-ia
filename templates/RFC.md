# RFC-000: [Título da Decisão de Arquitetura]

- **Autor(es):** [Nome / Squad]
- **Data:** [AAAA-MM-DD]
- **Status:** [Proposta | Em Revisão | Aprovada | Rejeitada]

---

## 1. Contexto & Problema
Qual é a dor ou gargalo atual? Por que precisamos dessa mudança na arquitetura ou introdução de novo componente?

## 2. Solução Proposta (System Design)
- **Diagrama de Blocos / Fluxo:** (Ex: link para Excalidraw, diagrama Mermaid)
- **Componentes Envolvidos:** (Filas, bancos, caches, microsserviços, integrações externas)
- **Modelagem de Dados:** Novas tabelas, alterações de schemas ou índices essenciais para evitar full-table scans.
- **Contratos de API:** Novas rotas, payloads de requisição/resposta e códigos de erro.

## 3. Observabilidade & Resiliência
- **Eventos e Métricas a Instrumentar:** Quais métricas de negócio e performance serão acompanhadas?
- **Alertas Críticos:** Condições para disparar alertas (ex: fast burning de taxas de erro).
- **Critérios Fail-Safe vs Fail-Fast:** O que deve falhar imediatamente vs o que deve degradar graciosamente.

## 4. Estratégia de Rollout & Rollback
- **Feature Flags:** A funcionalidade será protegida por chave de feature flag?
- **Compatibilidade de Banco:** As migrações são retrocompatíveis (*expand and contract*)?
- **Plano de Rollback:** Como reverter a alteração caso ocorra instabilidade em produção?

## 5. Trade-offs & Alternativas Rejeitadas
Quais outras abordagens foram consideradas e por que foram descartadas?
