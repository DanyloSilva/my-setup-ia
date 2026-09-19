# 🛡️ AI Harness, Spec-Driven Development & Gestão de Contexto

> **Referência:** Baseado nas técnicas e benchmark apresentados por **Waldemar Neto (Dev Lab)** no laboratório *App do Zero com IA: Harness, Sub Agents, Spec-Driven, Novas Skills e Workflows* ([Vídeo](https://youtu.be/yKLedmyUDMA)).

---

## 🧭 Os 4 Níveis de Maturidade com IA

Ao desenvolver software assistido por modelos de fronteira (frontier models), a dinâmica evolui em quatro níveis bem definidos:

```
[ Nível 0: Vibe Coding ]
       │ "implemente isso" sem plano, sem testes, sem ler código → quebra em produção
       ▼
[ Nível 1: Plan Mode + Subagents ]
       │ Ciclo: Research → Plan → Implement → Verify
       ▼
[ Nível 2: Skills Customizadas Auto-verificáveis ]
       │ Scripts determinísticos locais + prompts focados que rodam verificações
       ▼
[ Nível 3: Spec-Driven Moderno ]
       │ Especificações lean em Given-When-Then + checklists verificáveis (sem burocracia)
       ▼
[ Nível 4: AI Harness Completo ]
       │ Trilhos determinísticos (Rails) + Sensores de feedback (Playwright MCP, Testes, Linters)
```

---

## 1. O Conceito de AI Harness: Guias e Sensores

O **Harness** é o ambiente de contenção, direcionamento e validação no qual o modelo opera. Ele resolve a natureza **não determinística** dos LLMs cercando o agente com **mecanismos 100% determinísticos**.

### Os Dois Componentes do Harness
1. **Guias (Rails):**
   - Regras mínimas e indiscutíveis de arquitetura.
   - Comandos padronizados de build e execução de testes.
   - Padrões de escopo atômico (limite do que o agente pode alterar por vez).

2. **Sensores (Feedback Loops):**
   - **Testes Unitários:** Testam lógica de domínio e services.
   - **Testes de Integração:** Testam rotas e queries ao banco de dados.
   - **Playwright MCP:** Valida navegação, cliques, formulários e renderização de telas reais.
   - **Linters & Typecheck:** `tsc`, `eslint`, `ruff`, etc.
   - **Mutation Testing & Security Scan:** Valida a robustez dos testes gerados e descarta vulnerabilidades.

> 💡 **Princípio Central:** *"Faça a IA provar o que fez"*. O agente nunca deve considerar uma tarefa pronta baseando-se apenas na sua própria afirmação textual. Ele é obrigado a disparar os sensores e demonstrar a saída verde dos testes.

---

## 2. Playwright MCP: Fechando o Loop no Frontend

Para aplicações com interface gráfica ou web, testes estáticos muitas vezes não capturam quebras sutis de layout, renderização reativa ou fluxo do usuário.

### Configuração do Playwright MCP
No seu arquivo de configuração de MCP (ex: Cursor, Claude Desktop, Antigravity IDE):

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    }
  }
}
```

### Regra de Ouro no Frontend
Sempre que uma alteração tocar em componentes de tela, rotas ou estilos, o agente deve:
1. Subir o servidor local de desenvolvimento (ex: `npm run dev` ou container).
2. Usar o Playwright MCP para abrir o navegador, navegar até a rota afetada, interagir com os elementos alterados e tirar um screenshot ou inspecionar o DOM.
3. Confirmar que nenhuma mensagem de erro no console ou quebra visual ocorreu.

---

## 3. Gestão de Janela de Contexto: A Regra dos 60% e o Perigo do `/compact`

### Como os Modelos Operam
LLMs são estritamente **stateless**. Elas não "lembram" das coisas dinamicamente. A cada rodada (turn), o cliente reenvia **toda a conversa e arquivos anexados** para o modelo. Conforme a conversa avança, a janela de contexto vai se enchendo.

### A Regra dos 60%
- Quando o consumo de contexto atinge entre **60% e 70%** da capacidade recomendada, a atenção do modelo começa a degradar sensivelmente.
- O modelo começa a ignorar regras sutis, esquecer restrições de arquitetura e cometer erros bobos de sintaxe ou imports.

### O Perigo do `/compact`
- Muitos ambientes oferecem um botão ou comando automático `/compact` (resumo de contexto).
- **Cuidado:** O compact comprime a história removendo justamente as nuances de domínio e restrições técnicas específicas que foram alinhadas anteriormente.
- **Estratégia Recomendada:**
  1. Use sessões amplas e subagents dedicados na fase de **Research** e **Plan**.
  2. Ao finalizar o plano e aprová-lo, **salve o plano em um arquivo (ex: `docs/plans/feature-x.md`)**.
  3. **Abra uma sessão nova e limpa** com o contexto em 0%, referencie apenas o plano aprovado e os arquivos alvo, e execute a implementação.

---

## 4. O Ciclo Infalível: Research → Plan → Implement → Verify

Todo trabalho de engenharia assistido por IA deve seguir rigidamente este ciclo:

```
┌──────────────┐     ┌───────────┐     ┌───────────────┐     ┌────────────┐
│   Research   │ ──> │   Plan    │ ──> │   Implement   │ ──> │   Verify   │
└──────────────┘     └───────────┘     └───────────────┘     └────────────┘
  Subagents para       Plano lean        Execução direta       Sensores &
  ler código e docs    em arquivo        com contexto limpo    Playwright
```

1. **Research (Pesquisa):**
   - Ler os arquivos existentes, dependências e requisitos de produto.
   - Delegar buscas pesadas para subagents a fim de manter a janela principal preservada.
2. **Plan (Planejamento):**
   - Produzir uma especificação enxuta com decisões de arquitetura e Given-When-Then.
   - Definir a lista de arquivos a criar/modificar e os critérios de validação.
3. **Implement (Implementação):**
   - O modelo implementa a mudança em etapas atômicas.
4. **Verify (Verificação):**
   - Rodar sensores determinísticos (testes, linters, Playwright MCP).
   - O próprio agente ou um subagente de auditoria compara a implementação com o checklist do plano.

---

## 5. Spec-Driven Moderno vs Frameworks Antigos

Frameworks tradicionais de Spec-Driven com IA pecam pelo excesso: dezenas de passos burocráticos, dezenas de arquivos intermediários e necessidade constante de babysitting humano.

### A Nova Abordagem Spec-Driven:
- **Enxuta e Direta:** Uma spec contendo apenas o objetivo, as regras de domínio no formato **Given-When-Then** e o checklist técnico.
- **Tasks Atômicas:** Tarefas pequenas o bastante para o modelo executar sem se perder e sem gerar PRs gigantescos.
- **Prevenção de Spec Drift:** A especificação deve ser o espelho da verdade. Se durante a implementação uma decisão técnica mudar, a spec deve ser atualizada imediatamente para evitar desalinhamento.

---

## 6. Por que Menos é Mais no `AGENTS.md`

- Encher o `AGENTS.md` ou regras de projeto (`.cursorrules`, `GEMINI.md`, etc.) com dezenas de páginas de "boas práticas genéricas" de programação atrapalha modelos frontier.
- Modelos avançados já foram pré-treinados com as melhores práticas de código limpo. Sobrecarregá-los causa:
  - Consumo desnecessário de tokens a cada mensagem.
  - Conflito entre regras customizadas prolixas e as capacidades nativas de raciocínio do modelo.
  - Alucinações e respostas engessadas.

### O que REALMENTE deve estar no `AGENTS.md`:
- Comandos exatos para rodar o build, testes e linters do projeto.
- Informações sobre convenções não convencionais exclusivas daquele projeto.
- Instrução explícita para rodar sensores determinísticos (ex: Playwright MCP e suites de teste) antes de concluir tarefas.
- Limite estrito de tamanho de tarefa/PR (ex: < 500 linhas).
