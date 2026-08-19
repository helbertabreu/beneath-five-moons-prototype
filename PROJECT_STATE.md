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
Entendido perfeitamente. Como Tech Lead e Arquiteto de Software, atendo à sua solicitação e realizo a verificação, sincronização e entrega dos três documentos de governança (PROJECT_STATE.md, BACKLOG.md e TECHNICAL_DECISIONS.md).Analisando a estrutura do repositório legado e sincronizando-o com os avanços reais e correções que executamos nas Sprints 01 e 02:Sprint 01 (Concluída): GameAction, ActionValidator, ActionSystem (com busca por tipo de nó em fallback), TimeManager (migrado para Action Time) e SurvivalComponent (faixas de fome e exaustão diária).  Sprint 02 (Concluída): DropEntryData, DropTableData, DropSystem (data-driven com suporte a modos INDEPENDENT, EXCLUSIVE e WEIGHTED), LootTableComponent e ResourceNode integrados ao consumo de tempo/energia.  Regras de Entrega: Respeito estritamente a regra de enviar cada arquivo de governança .md isoladamente em sua própria mensagem, totalmente formatado em Markdown completo e sem dados incompletos ou marcadores de omissão.  Abaixo entrego o conteúdo COMPLETO E ÍNTEGRO do primeiro arquivo: PROJECT_STATE.md.  PROJECT_STATE.mdDocumento de estado atual do projeto Godot 4.7.1.
Este arquivo reflete o estado REAL do projeto e é atualizado ao final de auditorias, Sprints e mudanças arquiteturais.  1. IDENTIFICAÇÃO DO PROJETONome do projeto: Beneath Five Moons  Versão atual: 0.4.0-prototype  Versão da Godot: 4.7.1  Plataformas alvo: PC (Windows / Linux / macOS)  Gênero: RPG Sandbox 2D / Survival Leve / Economia Dinâmica / Multiplayer Cooperativo PvE  Perspectiva: Top-Down 2D  Status geral: DESENVOLVIMENTO / SPRINT 02 CONCLUÍDA  Última atualização: 19/08/2026  2. VISÃO GERALDescriçãoBeneath Five Moons é um RPG Sandbox 2D multiplayer cooperativo no qual o jogador constrói sua vida dentro de um mundo persistente e reativo. O gameplay evolui de sobrevivência e coleta básica até o desenvolvimento de profissões, comércio dinâmico e governança de vilarejos.  Core LoopPlaintextEXPLORAR → COLETAR → DESENVOLVER PROFISSÃO → PRODUZIR → VENDER/TROCAR → GANHAR DINHEIRO → AUMENTAR REPUTAÇÃO → GOVERNAR → ENDLESS SANDBOX
```[cite: 1]

### Objetivo atual do projeto

Concluir a transição da arquitetura Data-Driven de Drops e Coleta da Sprint 02 e preparar a execução da Sprint 03 (Inimigos do MVP & State Machine).[cite: 1, 6]

---

## 3. ESTADO DA SPRINT

- **Sprint atual:** Sprint 02 (Data-Driven Drop & Resource Nodes)[cite: 1, 6]
- **Objetivo:** Implementar os Custom Resources `DropTableData` e `DropEntryData`, o serviço desacoplado `DropSystem` com suporte aos modos de rolagem (`INDEPENDENT`, `WEIGHTED`, `EXCLUSIVE`) e refatorar `ResourceNode` e `LootTableComponent`.[cite: 1, 6]
- **Início:** 19/08/2026[cite: 1, 6]
- **Previsão de conclusão:** 19/08/2026[cite: 1, 6]
- **Status:** CONCLUÍDA[cite: 6]

### Progresso

- [x] Criação da classe `GameAction` para encapsular custos atômicos (Sprint 01).[cite: 1, 6]
- [x] Implementação do `ActionValidator` e `ActionSystem` com busca resiliente por tipo (Sprint 01).[cite: 1, 6]
- [x] Refatoração do `TimeManager` para Action Time System (Sprint 01).[cite: 1, 6]
- [x] Atualização do `SurvivalComponent` com as 5 faixas de fome e exaustão (Sprint 01).[cite: 1, 6]
- [x] Criação do Custom Resource `DropEntryData` (`src/resources/drop_entry_data.gd`).[cite: 1, 6]
- [x] Criação do Custom Resource `DropTableData` (`src/resources/drop_table_data.gd`).[cite: 1, 6]
- [x] Implementação do serviço `DropSystem` (`src/scripts/core/drop_system.gd`) com multiplicadores ecológicos.[cite: 1, 6]
- [x] Refatoração do `LootTableComponent` e do `ResourceNode` para consumir `DropSystem` e `ActionSystem`.[cite: 1, 6]
- [x] Validação das suítes de testes automatizados `test_action_system.gd` e `test_drop_system.gd`.[cite: 1, 6]

---

## 4. SISTEMAS DO JOGO

| Sistema | Estado | Qualidade | Localização | Observações |
|---|---|---|---|---|
| Action System | FUNCIONAL | ALTA | `src/scripts/core/action_system.gd` | Validação atômica e busca desacoplada de nós por tipo.[cite: 1, 6] |
| Time System | FUNCIONAL | ALTA | `autoload/time_manager.gd` | Convertido com sucesso para Action Time System.[cite: 1, 6] |
| Survival System | FUNCIONAL | ALTA | `src/components/survival_component.gd` | Integrado ao GDD Seção 8 (5 faixas de fome e exaustão).[cite: 1, 6] |
| Drop System | FUNCIONAL | ALTA | `src/scripts/core/drop_system.gd` | Concluído em arquitetura Data-Driven na Sprint 02.[cite: 1, 6] |
| Resource Nodes | FUNCIONAL | ALTA | `src/entities/resource_nodes/` | Integrado ao ActionSystem e ao DropSystem.[cite: 1, 6] |
| Player | FUNCIONAL | ALTA | `src/entities/player/player_controller.gd` | Integrado ao ActionSystem para testes de coleta.[cite: 6] |
| Combate | PARCIAL | PROTÓTIPO | `src/components/hitbox_component.gd` | Lógica básica operante; aguardando FSM na Sprint 03.[cite: 1, 6] |
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
│   ├── components/    # Componentes reutilizáveis (Survival, Health, Inventory, Loot)
│   ├── entities/      # Entidades do jogo (Player, NPCs, Enemies, ResourceNodes)
│   ├── resources/     # Custom Resources (DropTableData, DropEntryData, ItemData)
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
| Tabela de Drops Data-Driven | SIM | FUNCIONAL | `src/resources/`, `src/scripts/core/` | Concluído na Sprint 02.[cite: 1, 6] |
| Inimigos ENM-001 e ENM-002 | SIM | PROTÓTIPO | `src/entities/enemies/` | Refatorar IA com `StateMachine` na Sprint 03.[cite: 1, 6] |

---

## 7. BUGS CONHECIDOS

| ID | Bug | Severidade | Reprodução | Status |
|---|---|---|---|---|
| BUG-001 | Desmaio por fadiga às 06:00 não redefine o horário corretamente para o meio-dia | ALTA | Permanecer acordado até 06:00 | RESOLVIDO (Sprint 01)[cite: 6] |
| BUG-002 | Busca de componente por String falhava em atores genéricos de teste | ALTA | Executar `test_action_system.gd` | RESOLVIDO (Sprint 01)[cite: 1] |
| BUG-003 | Atribuição direta de literal de Array em `Array[DropEntryData]` gerava erro no GDScript 4.7.1 | ALTA | Executar `test_drop_system.gd` | RESOLVIDO (Sprint 02) |

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
