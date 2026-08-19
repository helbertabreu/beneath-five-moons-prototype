# BACKLOG.md — Beneath Five Moons

> Documento de controle de tarefas, débitos técnicos e funcionalidades do projeto.
> Organizado por prioridades e domínios técnicos.

---

## 1. TAREFAS CRÍTICAS (P0 — BLOQUEANTES DO MVP)

- [x] **BACKLOG-P0-001:** Implementar arquitetura do `ActionSystem` (`GameAction`, `ActionValidator`) para centralizar os custos de tempo, energia e fome.
- [x] **BACKLOG-P0-002:** Refatorar `TimeManager` para operar em modo Action Time System, eliminando a degradação contínua em tempo real.
- [x] **BACKLOG-P0-003:** Criar os Resources customizados `DropTableData` e `DropEntryData` com suporte a rolagens `INDEPENDENT`, `WEIGHTED` e `EXCLUSIVE`.
- [ ] **BACKLOG-P0-004:** Reformular o `SaveManager` adicionando o campo obrigatório `save_version` e pipelines de migração de schema.

---

## 2. BUGS (P1 — PRIORIDADE ALTA)

- [x] **BUG-001:** Corrigir penalidade noturna de sono (22:00–02:00) e a rotina de desmaio às 06:00 no `SurvivalComponent`.
- [x] **BUG-002:** Resolver falha de busca de componente em nós instanciados dinamicamente no `ActionSystem`.
- [x] **BUG-003:** Corrigir erro de atribuição de literal untyped em `Array[DropEntryData]` no GDScript 4.7.1.

---

## 3. REFATORAÇÕES & ARQUITETURA (P2 — MÉDIA)

- [ ] **REFACT-001:** Implementar `StateMachine` hierárquica para os inimigos `ENM-001` (Lobo) e `ENM-002` (Salteador).
- [ ] **REFACT-002:** Padronizar nomenclatura de arquivos `.tres` e `.gd` para o idioma Inglês em todo o repositório.
- [ ] **REFACT-003:** Desacoplar `ReputationManager` e `QuestManager` de Autoloads globais.

---

## 4. GAMEPLAY & SISTEMAS (MVP)

- [ ] **GAMEPLAY-001:** Implementar `PriceCalculator` dinâmico levando em conta estoque local, demanda mínima e reputação.
- [ ] **GAMEPLAY-002:** Garantir que bancadas de trabalho de processamento passivo operem sem consumir energia do jogador durante a execução.
- [ ] **GAMEPLAY-003:** Implementar modificadores de drop baseados na Estação (`SeasonSystem`) e no Clima (`WeatherSystem`).

---

## 5. INTERFACE DE USUÁRIO (UI)

- [ ] **UI-001:** Atualizar a HUD para exibir feedbacks claros sobre as 5 faixas de Fome.
- [ ] **UI-002:** Exibir tempo estimado de execução e consumo de energia na interface de Crafting.

---

## 6. TESTES & QA

- [x] **TEST-001:** Criar suíte de testes unitários para o `ActionSystem` (`test_action_system.gd`).
- [x] **TEST-002:** Criar suíte de testes unitários para a distribuição estatística e margem de erro do `DropSystem` (`test_drop_system.gd`).

---

## 7. VISÃO FUTURA (PÓS-MVP / EXPANSÃO)

- [ ] **EXP-001:** Arquitetura de Servidor Autoritativo para Multiplayer PvE.
- [ ] **EXP-002:** Simulação demográfica e LOD de NPCs para grandes cidades.
- [ ] **EXP-003:** Guerras territoriais e leis municipais avançadas.

---

# 8. REGRAS DO BACKLOG

1. Não criar tarefas duplicadas.
2. Antes de criar uma tarefa, verificar se ela já existe.
3. Não marcar tarefas como DONE sem validação.
4. Dependências devem ser registradas.
5. Bugs críticos têm prioridade sobre polish.
6. O backlog deve refletir o estado real do projeto.
7. Funcionalidades fora do MVP devem ser claramente identificadas.
8. Quando uma tarefa crescer demais, dividi-la em tarefas menores.
9. Ao alterar significativamente o escopo, atualizar o backlog.
10. Manter IDs únicos.

---

# 9. HISTÓRICO DE SPRINTS

## Sprint 0 — Auditoria

**Objetivo:** compreender o estado atual do projeto.

**Resultado:** [PREENCHER]

## Sprint 1

**Objetivo:** [PREENCHER]

**Resultado:** [PREENCHER]

## Sprint 2

**Objetivo:** [PREENCHER]

**Resultado:** [PREENCHER]

---

# 10. PRÓXIMA TAREFA

**ID:** [PREENCHER]

**Tarefa:** [PREENCHER]

**Motivo da prioridade:** [PREENCHER]
