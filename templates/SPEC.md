# SPEC: [Nome da Funcionalidade / Tarefa Técnica]

- **Card Técnico Relacionado:** #[ID do Card]
- **RFC de Referência:** [Link ou ID da RFC]
- **Autor / Agente:** [Nome]

---

## 🎯 Objetivo & Escopo
Descrição sucinta do que será construído e quais arquivos serão afetados (alvo: < 500 linhas de código alteradas).

---

## 📋 Cenários de Comportamento (Given-When-Then)

### Cenário 1: [Fluxo Principal de Sucesso]
- **Given (Dado que):** O usuário possui saldo suficiente e dados válidos.
- **When (Quando):** Uma requisição `POST /api/v1/checkout` for enviada.
- **Then (Então):** Retorna status `201 Created`, decrementa o saldo e grava evento de auditoria.

### Cenário 2: [Fluxo de Erro / Validação - Fail Fast]
- **Given (Dado que):** O payload da requisição contém parâmetros inválidos.
- **When (Quando):** A validação de schema for executada.
- **Then (Então):** Retorna status `400 Bad Request` com código de erro amigável sem alterar o banco de dados.

---

## 🛠️ Checklist de Execução & Tarefas Atômicas

- [ ] **1. Testes:** Escrever testes unitários e de integração cobrindo os cenários Given-When-Then acima.
- [ ] **2. Modelagem & Migração:** Criar migração compatível com índices necessários.
- [ ] **3. Service & Domínio:** Implementar regras com tratamento explícito Fail-Fast e Fail-Safe.
- [ ] **4. Endpoints / UI:** Implementar rota ou tela.
- [ ] **5. Sensores de Verificação:**
  - [ ] Rodar testes unitários/integração (`npm test` / `pytest`)
  - [ ] Rodar linter e checagem de tipos
  - [ ] Se houver alteração de interface: rodar Playwright MCP para validação visual e de fluxo
- [ ] **6. Auditoria de Escopo:** Garantir que o PR final possui menos de 500 linhas de código alteradas.
