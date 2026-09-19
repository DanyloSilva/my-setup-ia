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
