# PROJECT_STATE.md[cite: 6]

> Documento de estado atual do projeto Godot 4.7.1.[cite: 6]
> Este arquivo reflete o estado REAL do projeto e é atualizado ao final de auditorias, Sprints e mudanças arquiteturais.[cite: 6]

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons[cite: 1, 6]
- **Versão atual:** 0.2.0-prototype[cite: 6]
- **Versão da Godot:** 4.7.1[cite: 1, 6]
- **Plataformas alvo:** PC (Windows / Linux / macOS)[cite: 1, 6]
- **Gênero:** RPG Sandbox 2D / Survival Leve / Economia Dinâmica / Multiplayer Cooperativo PvE[cite: 1, 6]
- **Perspectiva:** Top-Down 2D[cite: 6]
- **Status geral:** AUDITORIA / REFATORAÇÃO DE FUNDAÇÃO[cite: 6]
- **Última atualização:** 19/08/2026[cite: 1, 6]

---

## 2. VISÃO GERAL

### Descrição

Beneath Five Moons é um RPG Sandbox 2D multiplayer cooperativo no qual o jogador constrói sua vida dentro de um mundo persistente e reativo. O gameplay evolui de sobrevivência e coleta básica até o desenvolvimento de profissões, comércio dinâmico e governança de vilarejos.[cite: 1]

### Core Loop

```text
EXPLORAR → COLETAR → DESENVOLVER PROFISSÃO → PRODUZIR → VENDER/TROCAR → GANHAR DINHEIRO → AUMENTAR REPUTAÇÃO → GOVERNAR → ENDLESS SANDBOX
```[cite: 7]

### Objetivo atual do projeto

Concluir a estruturação da governança, registrar o backlog de correção do teste manual do sandbox (`BUG-004`) e planejar a integração da Tabela Expandida de Inimigos (`ENM-003` ao `ENM-008`)[cite: 7, 11, 13].

---

## 3. ESTADO DA SPRINT

- **Sprint atual:** Sprint 03 (Inimigos do MVP & State Machine)[cite: 7, 13]
- **Objetivo:** Implementar a arquitetura FSM (`EnemyStateMachine`, `State`), os nós de estado reutilizáveis e desacoplar o combate do `WolfEnemy` e `NightBandit`[cite: 7, 13].
- **Início:** 19/08/2026[cite: 7, 13]
- **Previsão de conclusão:** 19/08/2026[cite: 7, 13]
- **Status:** CONCLUÍDA[cite: 7, 13]

### Progresso

- [x] Criação da classe base `State` (`src/scripts/core/state.gd`)[cite: 7].
- [x] Criação do gerenciador `EnemyStateMachine` (`src/scripts/core/state_machine.gd`) com mitigação de shadowing e defensiva contra null-owner[cite: 7].
- [x] Criação dos estados concretos da FSM (`IdleState`, `PatrolState`, `ChaseState`, `AttackState`, `DeadState`)[cite: 7].
- [x] Criação do controller base `EnemyBase` (`src/entities/enemies/enemy_base.gd`) e inclusão do sinal `health_depleted` no `HealthComponent`[cite: 7].
- [x] Refatoração do `WolfEnemy` e `NightBandit` para utilizar resoluções defensivas de nó no `_ready()`[cite: 7].
- [x] Validação completa da suíte de testes unitários automatizados da FSM (`tests/test_enemy_fsm.gd`)[cite: 7].
- [ ] Correção do bug de movimentação/logs de combate dos inimigos no mapa Sandbox `Main.tscn` (`BUG-004` — Anotado no Backlog)[cite: 7].

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Localização | Observações |
|---|---|---|---|---|
| Action System | FUNCIONAL | ALTA | `src/scripts/core/action_system.gd` | Validação atômica de custos de tempo, fome e energia[cite: 7]. |
| Time System | FUNCIONAL | ALTA | `autoload/time_manager.gd` | Action Time System operante[cite: 7]. |
| Survival System | FUNCIONAL | ALTA | `src/components/survival_component.gd` | Sincronizado aos sinais do `EventBus` (`hunger_changed`, `energy_changed`)[cite: 7]. |
| Drop System | FUNCIONAL | ALTA | `src/scripts/core/drop_system.gd` | Data-Driven com modos `INDEPENDENT`, `WEIGHTED` e `EXCLUSIVE`[cite: 7]. |
| Resource Nodes | FUNCIONAL | ALTA | `src/entities/resource_nodes/` | Herança corrigida para `StaticBody2D` com `InteractionArea`[cite: 7]. |
| Player | FUNCIONAL | ALTA | `src/entities/player/player_controller.gd` | Resolução defensiva de componentes e registro no grupo `"player"`[cite: 7]. |
| Inimigos / FSM | FUNCIONAL | ALTA | `src/scripts/core/state_machine.gd` | FSM operante nos testes unitários; pendente ajuste no Sandbox[cite: 7]. |
| Combate | PARCIAL | PROTÓTIPO | `src/components/hitbox_component.gd` | Hitboxes ativadas via `AttackState`[cite: 7]. |
| Inventário | PARCIAL | FUNCIONAL | `src/components/inventory_component.gd` | Funcionalidade básica operante[cite: 7]. |
| Save/Load | PARCIAL | COM BUG | `autoload/save_manager.gd` | Requer versionamento de schema[cite: 7, 13]. |

---

## 5. BUGS CONHECIDOS

| ID | Bug | Severidade | Reprodução | Status |
|---|---|---|---|---|
| BUG-001 | Desmaio por fadiga às 06:00 não redefinia o horário | ALTA | Permanecer acordado até 06:00 | RESOLVIDO (Sprint 01)[cite: 7] |
| BUG-002 | Busca de componente por String falhava em atores genéricos | ALTA | Executar `test_action_system.gd` | RESOLVIDO (Sprint 01)[cite: 7] |
| BUG-003 | Atribuição de Array genérico em `Array[DropEntryData]` falhava | ALTA | Executar `test_drop_system.gd` | RESOLVIDO (Sprint 02)[cite: 7] |
| BUG-004 | Inimigos não se movimentam no mapa Sandbox `Main.tscn` e não registram logs de combate no console | MÉDIA | Iniciar a cena `res://src/scenes/main.tscn` e aproxima-se do Lobo/Salteador | **ABERTO** (Anotado no Backlog)[cite: 7] |

---

## 6. DÍVIDA TÉCNICA

| ID | Problema | Severidade | Impacto | Recomendação | Status |
|---|---|---|---|---|---|
| TECH-001 | Ausência do `ActionSystem` central | ALTA | Inconsistência no consumo de tempo/status | RESOLVIDO (Sprint 01)[cite: 7] |
| TECH-002 | Drops sem Resources customizados | ALTA | Impossibilita balanceamento data-driven | RESOLVIDO (Sprint 02)[cite: 7] |
| TECH-003 | Polling denso em IA de Inimigos | MÉDIA | Gargalo de desempenho | RESOLVIDO (Sprint 03 via FSM)[cite: 7] |
| TECH-004 | Desvinculação visual dos inimigos na cena `Main.tscn` | MÉDIA | Inimigos imóveis no teste manual sandbox | Mapear árvore de cena do `World/Enemies` na Sprint de Fixes (`BUG-004`)[cite: 7] |

---

## 7. DECISÕES IMPORTANTES

Consulte `TECHNICAL_DECISIONS.md`[cite: 7, 15].

| ID | Decisão | Data | Status |
|---|---|---|---|
| ADR-001 | Godot Engine 4.7.1 e GDScript Fortemente Tipado | 19/08/2026 | ATIVA[cite: 7, 15] |
| ADR-002 | Arquitetura de Componentes e Composição | 19/08/2026 | ATIVA[cite: 7, 15] |
| ADR-003 | Action Time System Centralizado | 19/08/2026 | ATIVA[cite: 7, 15] |
| ADR-004 | Busca Agnóstica e Polimórfica de Componentes | 19/08/2026 | ATIVA[cite: 7] |
| ADR-005 | Drop System Data-Driven | 19/08/2026 | ATIVA[cite: 7] |
| ADR-006 | State Machine de Inimigos (`EnemyStateMachine`) | 19/08/2026 | ATIVA[cite: 7, 15] |

---

## 8. PRÓXIMAS TAREFAS

1. Fornecer os arquivos `BACKLOG.md`, `TECHNICAL_DECISIONS.md` e `BALANCE.md` atualizados em mensagens sequenciais isoladas[cite: 7].
2. Apresentar o plano da Sprint 04 cobrindo a resolução do `BUG-004` e a integração dos Inimigos de Expansão (`ENM-003` a `ENM-008`)[cite: 7, 11].

---

## 8. DÍVIDA TÉCNICA

| ID | Problema | Severidade | Impacto | Recomendação | Status |
|---|---|---|---|---|---|
| TECH-001 | Ausência do `ActionSystem` central | ALTA | Inconsistência no consumo de tempo/status | RESOLVIDO (Sprint 01)[cite: 1, 6] |
| TECH-002 | Drops sem Resources customizados | ALTA | Impossibilita balanceamento por data-driven | RESOLVIDO (Sprint 02)[cite: 1, 6] |
| TECH-003 | Polling denso em IA de Inimigos | MÉDIA | Gargalo de desempenho e acoplamento | Implementar `StateMachine` (Sprint 03) | TODO[cite: 1, 6] |

---

## 9. RISCOS TÉCNICOS

| ID | Risco | Probabilidade | Impacto | Mitigação | Status |
|---|---|---|---|---|---|
| RISK-001 | Corrupção de Saves por ausência de versionamento | ALTA | ALTO | Implementar `save_version` no `SaveManager` | ABERTO[cite: 6] |
| RISK-002 | Incompatibilidade de sintaxe com Godot 4.7.1 | BAIXA | MÉDIO | Validar estritamente cada script com APIs da Godot 4.7.1 | ABERTO[cite: 1, 6] |

---

## 10. DECISÕES IMPORTANTES

Consulte `TECHNICAL_DECISIONS.md`.[cite: 6, 8]

| ID | Decisão | Data | Status |
|---|---|---|---|
| ADR-001 | Adoção do Godot Engine 4.7.1 e GDScript Fortemente Tipado | 19/08/2026 | ATIVA[cite: 1, 6, 8] |
| ADR-002 | Arquitetura baseada em Componentes e Composição | 19/08/2026 | ATIVA[cite: 1, 6, 8] |
| ADR-003 | Centralização Temporal via Action Time System | 19/08/2026 | ATIVA[cite: 1, 6, 8] |
| ADR-004 | Busca Agnóstica e Polimórfica de Componentes | 19/08/2026 | ATIVA[cite: 1] |
| ADR-005 | Formato do Drop System e Modificadores Ecológicos | 19/08/2026 | ATIVA[cite: 1, 6] |

---

## 11. PRÓXIMAS TAREFAS

1. Fornecer os dois arquivos de governança restantes (`BACKLOG.md` e `TECHNICAL_DECISIONS.md`) em mensagens isoladas[cite: 1].
2. Apresentar o Checkpoint de Implementação para a Sprint 03 (Inimigos do MVP & State Machine)[cite: 6].
3. Executar a FSM e a refatoração da IA do Lobo e Salteador mediante autorização explícita[cite: 6].

---

## 12. ÚLTIMA SINCRONIZAÇÃO

### O que foi concluído
- Finalização, correção e validação completa das Sprints 01 e 02 no projeto[cite: 1, 6].
- Resolução e aprovação da suíte de testes `test_drop_system.gd` com suporte a `Typed Arrays`[cite: 1, 6].

### O que está em andamento
- Envio sequencial dos documentos de governança em mensagens isoladas[cite: 1].

### O que está bloqueado
- Início do desenvolvimento da Sprint 03 até autorização explícita[cite: 6].

### Próximo passo recomendado
- O Produtor/Responsável autorizar o avanço para o Checkpoint da Sprint 01.[cite: 6]

---

## REGRA PARA O GEMINI

Ao trabalhar neste projeto:

1. Leia este arquivo antes de assumir o estado do projeto.
2. Não invente informações ausentes.
3. Não considere uma tarefa concluída sem validação.
4. Atualize este arquivo quando uma alteração importante modificar o estado do projeto.
5. Preserve o histórico das decisões importantes em `TECHNICAL_DECISIONS.md`.
