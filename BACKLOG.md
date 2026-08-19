# BACKLOG.md — Beneath Five Moons

> Documento de controle de tarefas, débitos técnicos e funcionalidades do projeto.
> Organizado por prioridades, domínios técnicos e histórico de Sprints.

---

## 1. TAREFAS CRÍTICAS (P0 — BLOQUEANTES DO MVP)

- [x] **BACKLOG-P0-001:** Implementar arquitetura do `ActionSystem` (`GameAction`, `ActionValidator`) para centralizar os custos de tempo, energia e fome[cite: 4].
- [x] **BACKLOG-P0-002:** Refatorar `TimeManager` para operar em modo Action Time System, eliminando a degradação contínua em tempo real[cite: 4].
- [x] **BACKLOG-P0-003:** Criar os Resources customizados `DropTableData` e `DropEntryData` com suporte a rolagens `INDEPENDENT`, `WEIGHTED` e `EXCLUSIVE`[cite: 4].
- [ ] **BACKLOG-P0-004:** Reformular o `SaveManager` adicionando o campo obrigatório `save_version` e pipelines de migração de schema[cite: 4].

---

## 2. BUGS (P1 — PRIORIDADE ALTA)

- [x] **BUG-001:** Corrigir penalidade noturna de sono (22:00–02:00) e a rotina de desmaio às 06:00 no `SurvivalComponent`[cite: 4].
- [x] **BUG-002:** Resolver falha de busca de componente em nós instanciados dinamicamente no `ActionSystem`[cite: 4].
- [x] **BUG-003:** Corrigir erro de atribuição de literal untyped em `Array[DropEntryData]` no GDScript 4.7.1[cite: 4].
- [ ] **BUG-004:** Inimigos (`WolfEnemy` e `NightBandit`) ficam imóveis na cena Sandbox `Main.tscn` e não registram logs de combate no console.
- [ ] **BUG-010:** **Inimigos parados:** Os inimigos não estão se movimentando ao executar a cena principal ou de teste.
- [ ] **BUG-011:** **HUD/Sobrevivência zerada:** A barra de energia e afins do jogador iniciam ou permanecem zeradas.
- [ ] **BUG-012:** **Falha de Input/Ações:** As teclas de ação para minerar, abrir inventário e interagir não respondem corretamente.
- [ ] **BUG-013:** **Falha na FSM de Inimigos:** Erro de asserção na transição para o estado de morte (`TestEnemyFSM.test_health_depleted_transition: Assertion failed: O estado atual da FSM deveria ser de morte (DeadState)`).

---

## 3. REFATORAÇÕES & ARQUITETURA (P2 — MÉDIA)

- [x] **REFACT-001:** Implementar `EnemyStateMachine` e nó `State` desacoplados para os inimigos `ENM-001` (Lobo) e `ENM-002` (Salteador).
- [ ] **REFACT-002:** Padronizar nomenclatura de arquivos `.tres` e `.gd` para o idioma Inglês em todo o repositório[cite: 4].
- [ ] **REFACT-003:** Desacoplar `ReputationManager` e `QuestManager` de Autoloads globais[cite: 4].

---

## 4. GAMEPLAY & SISTEMAS (MVP)

- [ ] **GAMEPLAY-001:** Implementar `PriceCalculator` dinâmico levando em conta estoque local, demanda mínima e reputação[cite: 4].
- [ ] **GAMEPLAY-002:** Garantir que bancadas de trabalho de processamento passivo operem sem consumir energia do jogador durante a execução[cite: 4].
- [ ] **GAMEPLAY-003:** Implementar modificadores de drop baseados na Estação (`SeasonSystem`) e no Clima (`WeatherSystem`)[cite: 4].
- [ ] **GAMEPLAY-004:** Implementar Inimigos Expandidos do Banco de Balanceamento (`ENM-003 Goblin`, `ENM-004 Orc`, `ENM-005 Troll`, `ENM-006 Wraith`, `ENM-007 Basilisk` e `ENM-008 Warlord Boss`)[cite: 8, 9].

---

## 5. INTERFACE DE USUÁRIO (UI)

- [ ] **UI-001:** Atualizar a HUD para exibir feedbacks claros sobre as 5 faixas de Fome[cite: 4].
- [ ] **UI-002:** Exibir tempo estimado de execução e consumo de energia na interface de Crafting[cite: 4].

---

## 6. TESTES & QA (OBRIGATÓRIO)

*Diretriz Permanente:* A partir de agora, **toda e qualquer implementação** (correção de bug, refatoração ou nova feature) deve obrigatoriamente incluir testes unitários/automatizados e testes manuais documentados.

- [x] **TEST-001:** Criar suíte de testes unitários para o `ActionSystem` (`test_action_system.gd`)[cite: 4].
- [x] **TEST-002:** Criar suíte de testes unitários para a distribuição estatística e margem de erro do `DropSystem` (`test_drop_system.gd`)[cite: 4].
- [x] **TEST-003:** Criar suíte de testes unitários para a FSM e transições de estado dos inimigos (`test_enemy_fsm.gd`).
- [ ] **TEST-004:** Implementar cobertura de testes manuais e de regressão para os bugs críticos de HUD, input e movimentação.

---

## 7. VISÃO FUTURA (PÓS-MVP / EXPANSÃO)

- [ ] **EXP-001:** Arquitetura de Servidor Autoritativo para Multiplayer PvE[cite: 4].
- [ ] **EXP-002:** Simulação demográfica e LOD de NPCs para grandes cidades[cite: 4].
- [ ] **EXP-003:** Guerras territoriais e leis municipais avançadas[cite: 4].

---

## 8. REGRAS DO BACKLOG

1. Não criar tarefas duplicadas[cite: 4].
2. Antes de criar uma tarefa, verificar se ela já existe[cite: 4].
3. Não marcar tarefas como DONE sem validação[cite: 4].
4. Dependências devem ser registradas[cite: 4].
5. Bugs críticos têm prioridade sobre polish[cite: 4].
6. O backlog deve refletir o estado real do projeto[cite: 4].
7. Funcionalidades fora do MVP devem ser claramente identificadas[cite: 4].
8. Quando uma tarefa crescer demais, dividi-la em tarefas menores[cite: 4].
9. Ao alterar significativamente o escopo, atualizar o backlog[cite: 4].
10. Manter IDs únicos[cite: 4].

---

## 9. HISTÓRICO DE SPRINTS

### Sprint 0 — Auditoria & Planejamento Inicial
- **Objetivo:** Compreender o estado do projeto legado, auditar arquivos e mapear dependências arquiteturais[cite: 4].
- **Resultado:** Documentação técnica criada (`PROJECT_STATE.md`, `TECHNICAL_DECISIONS.md`, `BACKLOG.md`) e plano de migração aprovado[cite: 4, 7, 13].

### Sprint 1 — Action System & Sobrevivência
- **Objetivo:** Centralizar o tempo no Action Time System e corrigir o ciclo de sobrevivência[cite: 4].
- **Resultado:** `GameAction` e `ActionSystem` criados; `TimeManager` refatorado; `BUG-001` e `BUG-002` corrigidos; `test_action_system.gd` aprovado[cite: 4].

### Sprint 2 — Drop System & Resource Nodes
- **Objetivo:** Implementar o sistema de drops data-driven e conectar aos recursos interativos[cite: 4].
- **Resultado:** Resources `DropTableData` e `DropEntryData` implementados; `DropSystem` desacoplado; `BUG-003` resolvido; `test_drop_system.gd` aprovado[cite: 4].

### Sprint 3 — State Machine & IA de Inimigos
- **Objetivo:** Implementar a arquitetura FSM (`EnemyStateMachine`, `State`) e refatorar os inimigos `WolfEnemy` e `NightBandit`[cite: 4, 7].
- **Resultado:** FSM genérica e estados (`IdleState`, `PatrolState`, `ChaseState`, `AttackState`, `DeadState`) criados; resolução defensiva de nós adicionada aos inimigos; `test_enemy_fsm.gd` aprovado com ressalvas de sincronização de cena. Anotado o `BUG-004` para resolução no mapa Sandbox[cite: 7].

---

## 10. PRÓXIMA TAREFA

- **ID:** `BUG-010`, `BUG-011`, `BUG-012` & `BUG-013` (Sprint de Estabilização de Gameplay)
- **Tarefa:** Investigação e correção sistêmica da inicialização do player, mapeamento de inputs, vinculação de componentes de sobrevivência com a HUD e alinhamento do ciclo de vida da FSM nos testes automatizados, aplicando obrigatoriamente testes manuais e unitários.
- **Motivo da prioridade:** Garantir que o protótipo executável (`Main.tscn`) recupere a jogabilidade básica e passe em todas as suítes de teste de integração.
