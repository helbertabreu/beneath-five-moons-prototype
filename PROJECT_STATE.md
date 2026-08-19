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
```[cite: 1]

### Objetivo atual do projeto

Concluir a transição da fundação temporal e de sobrevivência da Sprint 01 e preparar a execução da Sprint 02 (Data-Driven Drop & Resource Nodes).[cite: 1, 6]

---

## 3. ESTADO DA SPRINT

- **Sprint atual:** Sprint 01 (Action System & Survival Foundation)[cite: 1, 6]
- **Objetivo:** Implementar arquitetura de Action Time, desacoplar custos de Fome/Energia e criar suíte de testes unitários.[cite: 1, 6]
- **Início:** 19/08/2026[cite: 1, 6]
- **Previsão de conclusão:** 19/08/2026[cite: 1, 6]
- **Status:** CONCLUÍDA[cite: 6]

### Progresso

- [x] Criação da classe `GameAction` para encapsular custos atômicos.[cite: 1, 6]
- [x] Implementação do `ActionValidator` para checagem de precondições biológicas.[cite: 1, 6]
- [x] Implementação do `ActionSystem` com busca dinâmica agnóstica de nós por tipo.[cite: 1, 6]
- [x] Refatoração do `TimeManager` para operar sob o padrão Action Time.[cite: 1, 6]
- [x] Atualização do `SurvivalComponent` com as 5 faixas de fome e penalidades noturnas.[cite: 1, 6]
- [x] Atualização do `PlayerController` com suporte ao ActionSystem e depuração.[cite: 1, 6]
- [x] Criação e execução da suíte de testes `test_action_system.gd`.[cite: 1, 6]

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Localização | Observações |
|---|---|---|---|---|
| Action System | FUNCIONAL | ALTA | `src/scripts/core/action_system.gd` | Implementado com validação atômica e busca agnóstica de nós.[cite: 1, 6] |
| Time System | FUNCIONAL | ALTA | `autoload/time_manager.gd` | Convertido com sucesso para Action Time System.[cite: 1, 6] |
| Survival System | FUNCIONAL | ALTA | `src/components/survival_component.gd` | Integrado ao GDD Seção 8 (5 faixas de fome e exaustão).[cite: 1, 6] |
| Drop System | PARCIAL | PRECISA REFACTOR | `src/components/loot_table_component.gd` | Próximo alvo (Sprint 02) para migração Data-Driven.[cite: 1, 6] |
| Player | FUNCIONAL | ALTA | `src/entities/player/player_controller.gd` | Atualizado e integrado ao ActionSystem.[cite: 6] |
| Combate | PARCIAL | PROTÓTIPO | `src/components/hitbox_component.gd` | Lógica básica operante; aguardando FSM.[cite: 1, 6] |
| Inimigos / IA | PROTÓTIPO | PRECISA REFACTOR | `src/entities/enemies/` | Polling denso no `_process`; requer StateMachine na Sprint 03.[cite: 1, 6] |
| Inventário | PARCIAL | FUNCIONAL | `src/components/inventory_component.gd` | Funcionalidade básica operante.[cite: 1, 6] |
| Profissões & Crafting| PARCIAL | PROTÓTIPO | `src/components/profession_component.gd` | Aguardando reestruturação de bancadas passivas.[cite: 1, 6] |
| Economia | PARCIAL | PROTÓTIPO | `src/entities/npcs/npc_vendor.gd` | Falta PriceCalculator dinâmico.[cite: 1, 6] |
| Save/Load | PARCIAL | COM BUG | `autoload/save_manager.gd` | Requer versionamento e migração de schema.[cite: 1, 6] |

---

## 5. ARQUITETURA ATUAL

### Estrutura principal

```text
res://
├── autoload/          # Autoloads globais (EventBus, TimeManager, SaveManager)
├── data/              # Instâncias de Resource (.tres)
├── docs/              # GDD, TDD e Especificações Técnicas
├── src/
│   ├── components/    # Componentes reutilizáveis (Survival, Health, Inventory)
│   ├── entities/      # Entidades do jogo (Player, NPCs, Enemies, Nodes)
│   ├── resources/     # Custom Resources
│   ├── scenes/        # Cenas do jogo
│   ├── scripts/       # Lógica central e sistemas (core/)
│   └── ui/            # Cenas e controllers de interface
└── tests/             # Suítes de testes unitários e de integração
```[cite: 6]

### Autoloads

| Autoload | Função | Status |
|---|---|---|
| `EventBus` | Barramento central de sinais desacoplados | FUNCIONAL[cite: 6] |
| `TimeManager` | Gestor do tempo de jogo (Action Time) | FUNCIONAL[cite: 1, 6] |
| `SaveManager` | Persistência de dados | PRECISA REFACTOR[cite: 1, 6] |
| `QuestManager` | Gerenciamento de missões | PARCIAL[cite: 6] |
| `ReputationManager`| Gerenciamento de reputação | PARCIAL[cite: 6] |

---

## 6. GDD × IMPLEMENTAÇÃO

| Requisito do GDD | Implementado? | Estado | Localização | Ação |
|---|---|---|---|---|
| Action Time System | SIM | FUNCIONAL | `src/scripts/core/` | Concluído na Sprint 01.[cite: 1, 6] |
| Faixas de Fome & Penalidades | SIM | FUNCIONAL | `survival_component.gd` | Ajustado conforme GDD Seção 8.[cite: 1, 6] |
| Tabela de Drops Data-Driven | PARCIAL | INCOMPLETO | `loot_table_component.gd` | Criar `DropTableData` e `DropSystem` na Sprint 02.[cite: 1, 6] |
| Inimigos ENM-001 e ENM-002 | SIM | PROTÓTIPO | `src/entities/enemies/` | Refatorar IA com `StateMachine` na Sprint 03.[cite: 1, 6] |

---

## 7. BUGS CONHECIDOS

| ID | Bug | Severidade | Reprodução | Status |
|---|---|---|---|---|
| BUG-001 | Desmaio por fadiga às 06:00 não redefine o horário corretamente para o meio-dia | ALTA | Permanecer acordado até 06:00 | RESOLVIDO (Sprint 01)[cite: 6] |
| BUG-002 | Busca de componente por String falhava em atores genéricos de teste | ALTA | Executar `test_action_system.gd` | RESOLVIDO (Sprint 01)[cite: 1] |

---

## 8. DÍVIDA TÉCNICA

| ID | Problema | Severidade | Impacto | Recomendação | Status |
|---|---|---|---|---|---|
| TECH-001 | Ausência do `ActionSystem` central | ALTA | Inconsistência no consumo de tempo/status | RESOLVIDO (Sprint 01)[cite: 1, 6] |
| TECH-002 | Drops sem Resources customizados | ALTA | Impossibilita balanceamento por data-driven | Criar `DropTableData` e `DropSystem` (Sprint 02) | TODO[cite: 1, 6] |
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

---

## 11. PRÓXIMAS TAREFAS

1. Aguardar aprovação do Checkpoint da Sprint 02 (Data-Driven Drop & Resource Nodes).
2. Executar a implementação do `DropSystem`, `DropTableData` e `DropEntryData`.
3. Validar a nova suíte de testes `test_drop_system.gd`.

---

## 12. ÚLTIMA SINCRONIZAÇÃO

### O que foi concluído
- Finalização, correção e validação total da Sprint 01 (Action System & Sobrevivência).[cite: 1, 6]
- Correção da busca de componentes em `ActionSystem` de String rígida para iteração por tipo.[cite: 1]

### O que está em andamento
- Apresentação do Checkpoint da Sprint 02.[cite: 6]

### O que está bloqueado
- Qualquer modificação de código/cena para a Sprint 02 até autorização explícita do produtor.[cite: 6]

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
