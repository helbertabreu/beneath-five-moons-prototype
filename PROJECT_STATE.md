# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Este arquivo deve refletir o estado REAL do projeto e ser atualizado ao final de Sprints, mudanças arquiteturais relevantes e correções importantes.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** [PREENCHER]
- **Versão atual:** [PREENCHER]
- **Versão da Godot:** [PREENCHER]
- **Plataformas alvo:** [PREENCHER]
- **Gênero:** [PREENCHER]
- **Perspectiva:** [PREENCHER]
- **Status geral:** AUDITORIA / PROTÓTIPO / DESENVOLVIMENTO / ALPHA / BETA / POLISH
- **Última atualização:** [PREENCHER]

---

## 2. VISÃO GERAL

### Descrição

[PREENCHER]

### Core Loop

```text
[PREENCHER]
```

### Objetivo atual do projeto

[PREENCHER]

---

## 3. ESTADO DA SPRINT

- **Sprint atual:** [PREENCHER]
- **Objetivo:** [PREENCHER]
- **Início:** [PREENCHER]
- **Previsão de conclusão:** [PREENCHER]
- **Status:** PLANEJAMENTO / EM ANDAMENTO / BLOQUEADA / QA / CONCLUÍDA

### Progresso

- [ ] Tarefa 1
- [ ] Tarefa 2
- [ ] Tarefa 3

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Localização | Observações |
|---|---|---|---|---|
| Player | AUSENTE | — | — | |
| Movimento | AUSENTE | — | — | |
| Combate | AUSENTE | — | — | |
| Inimigos / IA | AUSENTE | — | — | |
| Inventário | AUSENTE | — | — | |
| Progressão | AUSENTE | — | — | |
| UI | AUSENTE | — | — | |
| Áudio | AUSENTE | — | — | |
| Save/Load | AUSENTE | — | — | |
| Settings | AUSENTE | — | — | |

### Estados possíveis

- AUSENTE
- PROTÓTIPO
- PARCIAL
- FUNCIONAL
- COMPLETO
- COM BUG
- PRECISA REFACTOR
- BLOQUEADO

---

## 5. ARQUITETURA ATUAL

### Estrutura principal

```text
res://
├── scenes/
├── scripts/
├── resources/
├── assets/
└── tests/
```

> Substitua pela estrutura real do projeto após a auditoria.

### Autoloads

| Autoload | Função | Status |
|---|---|---|
| [PREENCHER] | [PREENCHER] | [PREENCHER] |

### Principais componentes

| Componente | Responsabilidade | Utilizado por |
|---|---|---|
| [PREENCHER] | [PREENCHER] | [PREENCHER] |

---

## 6. GDD × IMPLEMENTAÇÃO

| Requisito do GDD | Implementado? | Estado | Localização | Ação |
|---|---|---|---|---|
| [PREENCHER] | [SIM/NÃO/PARCIAL] | [PREENCHER] | [PREENCHER] | [PREENCHER] |

---

## 7. BUGS CONHECIDOS

| ID | Bug | Severidade | Reprodução | Status |
|---|---|---|---|---|
| BUG-001 | [PREENCHER] | [CRÍTICA/ALTA/MÉDIA/BAIXA] | [PREENCHER] | TODO |

---

## 8. DÍVIDA TÉCNICA

| ID | Problema | Severidade | Impacto | Recomendação | Status |
|---|---|---|---|---|---|
| TECH-001 | [PREENCHER] | [PREENCHER] | [PREENCHER] | [PREENCHER] | TODO |

---

## 9. RISCOS TÉCNICOS

| ID | Risco | Probabilidade | Impacto | Mitigação | Status |
|---|---|---|---|---|---|
| RISK-001 | [PREENCHER] | [BAIXA/MÉDIA/ALTA] | [BAIXO/MÉDIO/ALTO] | [PREENCHER] | ABERTO |

---

## 10. DECISÕES IMPORTANTES

Consulte `TECHNICAL_DECISIONS.md`.

| ID | Decisão | Data | Status |
|---|---|---|---|
| ADR-001 | [PREENCHER] | [DATA] | ATIVA |

---

## 11. PRÓXIMAS TAREFAS

1. [PREENCHER]
2. [PREENCHER]
3. [PREENCHER]

---

## 12. ÚLTIMA SINCRONIZAÇÃO

### O que foi concluído

- [PREENCHER]

### O que está em andamento

- [PREENCHER]

### O que está bloqueado

- [PREENCHER]

### Próximo passo recomendado

[PREENCHER]

---

## REGRA PARA O GEMINI

Ao trabalhar neste projeto:

1. Leia este arquivo antes de assumir o estado do projeto.
2. Não invente informações ausentes.
3. Não considere uma tarefa concluída sem validação.
4. Atualize este arquivo quando uma alteração importante modificar o estado do projeto.
5. Preserve o histórico das decisões importantes em `TECHNICAL_DECISIONS.md`.
