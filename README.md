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
| **direnv / 1Password CLI** | Gerenciamento seguro de chaves de API (sem `.env` commitado) | Shell hook |
| **Homebrew Bundle** (`Brewfile`) | Automação de instalação de binários em novo Mac | `brew bundle` |

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

---

## 📁 Estrutura do Repositório

```
my-setup-ia/
├── README.md              ← Este arquivo
├── Brewfile               ← Dependências Homebrew
├── .envrc.example         ← Template de variáveis de ambiente
├── .gitignore             ← Proteção de secrets
└── scripts/
    └── Ativar-servicos-IA.command  ← Script de ativação
```

---

## 📝 Licença

Uso pessoal — Kleber / Danylo Silva
