# Meu Setup de IA 🧠⚙️

Repositório central para documentação, configuração e portabilidade do meu ambiente de desenvolvimento integrado com Inteligência Artificial. O objetivo é manter o contexto do projeto sincronizado entre múltiplos editores, padronizar o acesso a ferramentas locais e garantir alta disponibilidade de uso (tokens) através do roteamento dinâmico de modelos de IA.

---

## 🏗 Arquitetura do Setup

| Componente | Função | Endereço / Info |
|---|---|---|
| **AI Memory** (`akitaonrails/ai-memory`) | Servidor de contexto persistente entre editores/LLMs | `127.0.0.1:49374` |
| **OmniRoute** (`diegosouzapw/OmniRoute`) | Gateway/balanceador de carga com fallback automático | `localhost:20128` |
| **Agent Skills** (`addyosmani/agent-skills`) | Ferramentas estendidas para agentes de IA | Hooks locais |
| **Ponytail 4.10.0 / Codex** | Orquestração de tarefas e hooks locais | Habilitado |
| **Ollama** | Motor de execução local (API OpenAI-compatible) | `localhost:11434` |
| **Aider** (`aider-chat`) | Agente CLI agnóstico (diffs + commits automáticos) | Terminal |
| **MCP** (Model Context Protocol) | Protocolo de contexto para fontes de dados locais (Docker, Git, DBs) | Configurável |
| **Playwright MCP** (`@playwright/mcp`) | Validação autônoma de telas, fluxos visuais e testes E2E | MCP local |
| **AI Harness & Sensores** | Trilhos determinísticos e sensores (unitários, integração, linter) | Test suite / CI |
| **Esteira de Engenharia & Spec-Driven** | RFC humana, cards atômicos, micro-PRs (<500 linhas) e observabilidade first | Metodologia |
| **direnv / 1Password CLI** | Gerenciamento seguro de chaves de API (sem `.env` commitado) | Shell hook |
| **Homebrew Bundle** (`Brewfile`) | Automação de instalação de binários em novo Mac | `brew bundle` |
| **Graphify** (`Graphify-Labs/graphify`) | Transforma o codebase em knowledge graph consultável (AST parsing, sem vector store) | Skill local |

---

## 🔌 Ecossistema de Editores Suportados

| Editor | Integração | Notas |
|---|---|---|
| **VS Code** | GitHub Copilot + extensões MCP | Editor principal |
| **IntelliJ IDEA** | AI Assistant + plugins | JVM / Android |
| **Cursor** | Claude / GPT nativo | Foco em AI-first |
| **Antigravity IDE/CLI** | Gemini nativo + skills | Google ecosystem |
| **Aider** (terminal) | Qualquer modelo via API | Agnóstico, commits auto |

---

## 🔄 Estratégia de Continuidade — Roteamento OmniRoute

O OmniRoute gerencia a cascata de modelos automaticamente. Se o Tier 1 esgotar tokens ou ficar indisponível, o tráfego é redirecionado para o próximo nível.

```
Requisição → OmniRoute (localhost:20128)
               │
               ├── Tier 1 (Main) ──────────→ OpenAI GPT-4o / GPT Pro
               │                              Google Gemini 1.5 Pro
               │                              Anthropic Claude Code
               │
               ├── Tier 2 (Fallback) ──────→ DeepSeek Coder
               │
               └── Tier 3 (Local / $0) ───→ Llama 3 via Ollama
```

### Prioridades por Tier

| Tier | Provedor(es) | Custo | Latência | Quando usar |
|---|---|---|---|---|
| **1** | GPT-4o, Gemini Pro, Claude Code | Plano Pro | Baixa | Disponibilidade normal |
| **2** | DeepSeek Coder | Baixo | Média | Tokens Tier 1 esgotados |
| **3** | Llama 3 (Ollama local) | Zero | Variável | Offline / fallback total |

---

## 🔐 Gerenciamento de Secrets

```bash
# Usando direnv (.envrc por projeto, nunca commitado)
export OPENAI_API_KEY=sk-...
export GOOGLE_API_KEY=AIza...
export ANTHROPIC_API_KEY=sk-ant-...
export DEEPSEEK_API_KEY=sk-...
```

> ⚠️ **Nunca commitar `.env` ou chaves.** O `.gitignore` já bloqueia esses arquivos.

---

## 📦 Brewfile — Dependências de Sistema

```ruby
# Brewfile
brew "ollama"
brew "aider-chat"
brew "direnv"
brew "git"
brew "node"
brew "python"
cask "visual-studio-code"
cask "cursor"
```

---

## 🚀 Restauração Completa em Novo Mac

```bash
# 1. Clonar o repositório
git clone https://github.com/DanyloSilva/my-setup-ia.git ~/.meu-setup-ia
cd ~/.meu-setup-ia

# 2. Instalar dependências de sistema
brew bundle --file=Brewfile

# 3. Configurar variáveis de ambiente
cp .envrc.example .envrc
direnv allow

# 4. Ativar serviços (AI Memory, OmniRoute, Ollama)
zsh scripts/Ativar-servicos-IA.command

# 5. Autorizar hooks no Codex
# (manual — abrir painel Codex → /hooks → autorizar)
```

---

## 🚀 Inicialização em Novos Projetos (Onboarding & Scan)

Ao iniciar em um novo projeto ou empresa, **não clone este repositório dentro da base de código do projeto**. Mantenha o `my-setup-ia` centralizado em sua máquina e use o script de bootstrap para inspecionar a arquitetura e gerar a base de conhecimento (`CLAUDE.md`) sob medida.

### 1. Script de Escaneamento (`scripts/init-project.sh`)

Crie o script abaixo em seu setup (`chmod +x scripts/init-project.sh`):

```bash
#!/usr/bin/env bash
set -e

PROJECT_DIR="${1:-.}"
cd "$PROJECT_DIR"

echo "🔍 Escaneando arquitetura do projeto em: $(pwd)..."

claude "Você é um arquiteto especialista em Java e microsserviços. 
Analise este repositório focando em:
1. Build & Runtime:
   - Versão do Java/JDK, build tool (Maven com pom.xml ou Gradle com build.gradle/settings.gradle).
   - Comandos exatos: build sem testes, rodar testes unitários, testes de integração e subida local (Spring Boot bootRun/spring-boot:run, Quarkus, Micronaut, etc.).
2. Arquitetura & Dependências:
   - Framework web, mensageria/eventos (Kafka, RabbitMQ, SQS), banco de dados e migrações (Flyway/Liquibase).
   - Comunicação entre microsserviços (OpenFeign, WebClient, gRPC).
3. Docker & Localstack:
   - Mapeamento de serviços no docker-compose e portas de dependências externas.
4. Padrões & Regras de Código:
   - Padrão arquitetural (Hexagonal, Clean Architecture, MVC tradicional), mapeamento (MapStruct), validação e tratamento de exceções.
   - Padrão de branches, conventional commits e formato de PRs.

Gere um arquivo 'CLAUDE.md' limpo, direto e operacional na raiz deste projeto com essas diretrizes."

echo "✅ CLAUDE.md gerado com sucesso!"
```

### 2. Fluxo de Uso no Dia a Dia

Ao clonar um novo repositório corporativo:

```bash
# 1. Acesse a pasta do projeto da empresa
cd ~/workspace/servico-de-faturamento

# 2. Execute o scan a partir do seu setup central
~/my-setup-ia/scripts/init-project.sh

# 3. Escolha como manter o arquivo:
# Opção A: Uso individual (não commitar no repo do time)
echo "CLAUDE.md" >> .git/info/exclude

# Opção B: Compartilhar as diretrizes com a equipe
git add CLAUDE.md && git commit -m "docs: adiciona CLAUDE.md para assistentes de IA"
```

### Por que esse formato resolve seu caso?
* **Especializado em Java:** O prompt força a IA a procurar especificamente gerenciadores de dependência (`pom.xml`/`build.gradle`), profiles de ambiente do Spring, brokers de mensageria e `docker-compose`.
* **Zero impacto no Git:** Você roda a CLI externamente e isola o arquivo via `.git/info/exclude`, sem risco de subir arquivos pessoais ou acidentalmente criar conflitos de subrepositório.

📄 **Template de Fallback para Java/Spring:** [templates/CLAUDE-java-spring.md.example](templates/CLAUDE-java-spring.md.example)

---

## 🧪 Plano de Testes

### Teste 1 — OmniRoute (Gateway)
```bash
curl http://localhost:20128/api/v1/models
curl http://localhost:20128/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"model":"auto","messages":[{"role":"user","content":"ping"}]}'
```
Validar no painel (`localhost:20128`) se a requisição passou pelo Tier correto.

### Teste 2 — AI Memory (Contexto Persistente)
```bash
curl -X POST http://127.0.0.1:49374/memories \
  -H "Content-Type: application/json" \
  -d '{"content":"O projeto usa React 18 com TypeScript"}'

curl http://127.0.0.1:49374/memories?query=React
```

### Teste 3 — Ollama (Modelo Local)
```bash
ollama run llama3 "Explique o padrão MVC em uma frase"
```

### Teste 4 — Aider (Agente CLI)
```bash
aider --model ollama/llama3 --yes
```

### Teste 5 — Playwright MCP (Sensores de UI)
```bash
# Validar disponibilidade do servidor Playwright MCP
npx -y @playwright/mcp@latest --help
```

---

## 🛡️ AI Harness, Spec-Driven & Gestão de Contexto

Baseado nos ensinamentos e benchmarks práticos de **Waldemar Neto (Dev Lab)**:

- **Evolução dos 4 Níveis:**
  1. *Nível 0 (Vibe Coding):* Prompts soltos sem plano, sem testes e sem ler código → quebra em produção.
  2. *Nível 1 (Plan Mode + Subagents):* Ciclo rigoroso de `Research` → `Plan` → `Implement` → `Verify`.
  3. *Nível 2 (Skills Customizadas Auto-verificáveis):* Substituição de agentes customizados engessados por skills locais determinísticas.
  4. *Nível 3 (Spec-Driven Moderno):* Especificações lean em **Given-When-Then** com tasks atômicas e checklist de validação.
  5. *Nível 4 (AI Harness Completo):* Trilhos determinísticos (Rails) + Sensores de feedback para **fazer a IA provar o que fez**.
- **A Regra dos 60% e o Perigo do `/compact`:**
  - A atenção de LLMs degrada fortemente após 60-70% de ocupação da janela de contexto.
  - O comando `/compact` descarta regras sutis de domínio e gera alucinações. **Solução:** Planejar em arquivo, resetar a sessão e implementar com contexto zerado.
- **Playwright MCP como Sensor de Telas:** O agente não apenas gera o código, mas sobe o app e navega autonomamente para validar visualmente o fluxo antes de entregar.
- **`AGENTS.md` Enxuto:** "Menos é mais". Evite manuais prolixos; forneça apenas os comandos exatos de verificação e regras indiscutíveis do projeto.

📖 **Guia detalhado:** [docs/workflows/harness-spec-driven.md](docs/workflows/harness-spec-driven.md)  
📄 **Template:** [templates/AGENTS.md.example](templates/AGENTS.md.example) | [templates/SPEC.md](templates/SPEC.md)

---

## 🏭 Esteira de Engenharia de Software & Observabilidade First

Baseado nas discussões e práticas de produção de **Augusto Galego & Samuel (Sam)**:

- **Arquitetura Humana Primeiro (A RFC):**
  - Manter o *ownership* do desenvolvedor através de decisões prévias de System Design (banco, índices, filas, contratos).
  - Documentação em RFCs colaborativas no repositório antes de acionar a IA.
- **Separação de Responsabilidades:**
  - **Product Cards:** Foco na dor do usuário e regras de negócio.
  - **Technical Cards:** Detalhamento de endpoints, migrações, observabilidade, feature flags e estratégia de rollback.
- **Métricas de Engenharia:**
  - **Cycle Time Saudável:** Fechar cards técnicos em **~24 horas**.
  - **Micro-PRs (< 500 linhas):** Limitar o tamanho do PR para garantir alta precisão da IA e viabilizar code reviews humanos em **10 a 15 minutos**.
- **Observabilidade First:**
  - Princípio **Fail-Safe** (processos secundários não derrubam produção) vs **Fail-Fast** (regras de domínio críticas interrompem execução imediatamente).
  - Instrumentação ativa de logs, métricas e alertas (*fast burning*).
  - MCPs conectados à observabilidade em runtime para investigar causas-raiz sem reprodução local manual.
- **Disciplina com Testes & Combate ao AI Slop:**
  - *"Escreva o critério e LEIA o teste"*: Validação humana das asserções e prática de TDD com IA.
  - Repúdio ao acúmulo de arquivos e documentações geradas automaticamente que ninguém lê (débito cognitivo).

📖 **Guia detalhado:** [docs/workflows/pipeline-engenharia-ia.md](docs/workflows/pipeline-engenharia-ia.md)  
📄 **Template:** [templates/RFC.md](templates/RFC.md)

---

## 📁 Estrutura do Repositório

```
my-setup-ia/
├── README.md                      ← Documentação central do setup
├── Brewfile                       ← Dependências Homebrew automatizadas
├── .envrc.example                 ← Template de variáveis de ambiente
├── .gitignore                     ← Proteção de secrets e caches
├── docs/                          ← Guias aprofundados de engenharia
│   └── workflows/
│       ├── harness-spec-driven.md ← Guia de Harness, Spec-Driven e Gestão de Contexto
│       └── pipeline-engenharia-ia.md ← Guia de Esteira, RFCs e Observabilidade
├── templates/                     ← Blueprints reutilizáveis para projetos
│   ├── AGENTS.md.example          ← Template minimalista sensor-driven
│   ├── CLAUDE-java-spring.md.example ← Template de fallback para microsserviços Java/Spring
│   ├── RFC.md                     ← Template para decisões de arquitetura humana
│   └── SPEC.md                    ← Template de especificação técnica moderna
└── scripts/
    ├── Ativar-servicos-IA.command  ← Script de ativação de serviços locais
    └── init-project.sh            ← Script de scan e onboarding arquitetural (Java/Microsserviços)
```

---

## 📝 Licença

Uso pessoal — Kleber / Danylo Silva

---

## 🔗 Graphify — Knowledge Graph do Codebase

O [Graphify](https://github.com/Graphify-Labs/graphify) transforma qualquer codebase (código, docs, SQL schemas, configs, PDFs) em um **knowledge graph consultável**. Usa AST parsing local e determinístico — sem vector store, sem API externa.

### Benefícios no Setup
- LLMs entendem a **estrutura real** do projeto (dependências, imports, relações entre módulos)
- Funciona como **skill** para Claude Code, Cursor, Codex e Gemini CLI
- Cada aresta do grafo é **explicada** — não é caixa preta
- 100% local — zero custo de tokens para indexação

### Instalação
```bash
# Clonar o repositório
git clone https://github.com/Graphify-Labs/graphify.git ~/.graphify

# Usar como skill nos agentes
# Claude Code: /graphify no prompt
# Cursor: configurar como skill
# Gemini CLI: registrar como tool
```

### Teste — Graphify
```bash
cd ~/meu-projeto
graphify scan .
graphify query "quais módulos dependem do módulo auth?"
```
