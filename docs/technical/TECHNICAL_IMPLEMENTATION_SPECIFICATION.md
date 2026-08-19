# Beneath Five Moons — Technical Implementation Specification
## Especificação Técnica de Implementação da Expansão

**Versão:** 1.0.0  
**Engine:** Godot 4.x  
**Documento de execução:** sim  
**Pré-requisito:** TDD aprovado

---

# 1. Objetivo

Transformar o TDD em unidades concretas de implementação, definindo ordem de desenvolvimento, estruturas de dados, sistemas, dependências, validações e critérios de aceite.

---

# 2. Ordem de Implementação

```text
P0 Multiplayer Foundation
↓
P1 World Persistence
↓
P2 Cities + NPC Simulation
↓
P3 Economy
↓
P4 Governance
↓
P5 Religion + Relationships
↓
P6 Marriage + Family
↓
P7 Skills + Professions
↓
P8 Advanced Weather
↓
P9 War
↓
P10 PvP
↓
P11 Endless Sandbox
```

---

# 3. P0 — Multiplayer Foundation

Criar:

```text
scripts/multiplayer/
├── network_manager.gd
├── network_player.gd
├── server_authority.gd
├── replication_manager.gd
└── network_message.gd
```

## Critérios de aceite

- servidor inicia;
- cliente conecta;
- player é replicado;
- desconexão é tratada;
- estado básico é autoritativo;
- cliente não pode alterar recursos diretamente.

---

# 4. P1 — World Persistence

Criar:

```text
WorldState
RegionState
CityState
VillageState
TerritoryState
```

Cada entidade persistente:

```gdscript
var persistent_id: String
```

## Critérios de aceite

- salvar;
- carregar;
- validar versão;
- migrar versão antiga;
- preservar IDs;
- recuperar estado após reinício.

---

# 5. P2 — NPC Simulation

Criar:

```text
NPCData
NPCState
NPCSchedule
NPCRelationship
NPCController
PopulationSimulation
```

Implementar primeiro:

```text
SLEEP
WORK
EAT
TRAVEL
SOCIALIZE
SHOP
PRAY
REST
```

Depois:

```text
FLEE
FIGHT
FOLLOW
```

## LOD

```text
Near → Full
Region → Reduced
Far → Statistical
```

---

# 6. P3 — Economy

Implementação:

```text
Item
→ Production
→ Consumption
→ Inventory
→ Local Market
→ Regional Market
→ Global Market
→ Trade Routes
→ Auction
```

Criar:

```text
MarketState
PriceCalculator
SupplyDemandModel
TradeRoute
Transaction
Auction
```

## Regras

Todas as transações precisam de:

- ID;
- timestamp;
- source;
- destination;
- quantidade;
- preço;
- validação;
- resultado.

---

# 7. P4 — Governance

Criar:

```text
GovernmentData
GovernmentState
LawData
LawState
CouncilMemberData
CouncilMemberState
ElectionData
ElectionState
```

## Ticks

### Daily
- comida;
- aprovação;
- segurança.

### Weekly
- economia;
- crime;
- pressão política.

### Monthly
- população;
- infraestrutura;
- eventos políticos.

### Yearly
- eleições;
- reformas;
- reivindicações territoriais.

---

# 8. P5 — Religion + Relationships

Criar:

```text
ReligionData
ReligionState
DoctrineData
RitualData
HolySiteData
FaithState

RelationshipState
```

A influência religiosa deverá atuar por modificadores e eventos, evitando dependência direta entre sistemas.

---

# 9. P6 — Marriage + Family

Criar:

```text
RomanceState
MarriageState
FamilyState
InheritanceState
```

Validações:

```text
Relationship Requirement
Trust Requirement
Compatibility
Existing Marriage
Legal Restriction
Social Restriction
```

---

# 10. P7 — Skills + Professions

Criar:

```text
SkillTreeData
SkillNodeData
SkillState
SkillModifier
ProfessionData
ProfessionState
```

Estrutura:

```text
SkillTree
├── Root
├── Branch A
├── Branch B
└── Mastery
```

O sistema deve preservar a identidade emergente do personagem, sem classes fixas obrigatórias.

---

# 11. P8 — Advanced Weather

Criar:

```text
WeatherState
ClimateRegion
WeatherForecast
WeatherEvent
NaturalDisaster
```

Pipeline:

```text
Season
→ Regional Climate
→ Weather Roll
→ Forecast
→ Active Weather
→ Environmental Effects
→ World Events
```

---

# 12. P9 — War

Implementar nesta ordem:

```text
Faction
→ Territory
→ MilitaryPower
→ Supply
→ Diplomacy
→ WarState
→ Siege
→ Army AI
```

O sistema deve impedir guerra sem recursos/logística quando as regras configuradas exigirem esses requisitos.

---

# 13. P10 — PvP

Antes de permitir combate entre players:

```text
PvP Enabled?
Territory Contested?
Player Protected?
Combat Legal?
Faction Hostile?
War Zone?
```

Todas as respostas devem ser verificadas no servidor.

---

# 14. P11 — Endless Sandbox

Não criar um segundo Game Loop.

Usar:

```text
NarrativeCompletion = true
```

e continuar a simulação normal.

---

# 15. Procedural World Events

Criar:

```gdscript
class_name WorldEventGenerator
extends RefCounted
```

Categorias:

```text
Economic
Political
Religious
Military
Environmental
Social
Exploration
```

Inputs:

```text
WorldState
Season
Weather
Economy
Population
Politics
Religion
War
PlayerActions
```

Exemplo:

```text
Winter
+
Poor Harvest
+
Food Shortage
=
Famine
```

---

# 16. Estrutura de Recursos

```text
resources/
├── items/
├── enemies/
├── skills/
├── professions/
├── npcs/
├── cities/
├── religions/
├── factions/
├── economy/
├── weather/
└── drops/
```

---

# 17. Estrutura de Scripts

```text
scripts/
├── core/
├── systems/
├── entities/
├── multiplayer/
└── ui/
```

---

# 18. Testes Obrigatórios

## MP-001 — Duplicação de Item

Dois clientes coletam o mesmo recurso simultaneamente.

**Esperado:** apenas uma operação válida.

## MP-002 — Dupla Venda

Cliente envia a mesma venda duas vezes.

**Esperado:** uma única transação.

## MP-003 — Desconexão

Cliente desconecta durante uma compra.

**Esperado:** estado consistente após reconexão.

## ECON-001 — Mercado Saturado

Adicionar grande quantidade do mesmo item.

**Esperado:** preço converge para os limites configurados.

## GOV-001 — Imposto Máximo

Tentar ultrapassar limite legal.

**Esperado:** operação recusada.

## REL-001 — Casamento Inválido

Tentar casamento sem requisitos.

**Esperado:** operação recusada.

## WAR-001 — Conflito Territorial

Duas facções disputam o mesmo território.

**Esperado:** servidor resolve conforme regras.

## WEATHER-001 — Tempestade

Tempestade severa atinge cidade.

**Esperado:** efeitos configurados são aplicados.

## SAVE-001 — Persistência Complexa

Salvar durante guerra + tempestade + transação + relacionamento.

**Esperado:** estado integral após load.

---

# 19. Teste de Estresse

Meta inicial de QA:

```text
100+ NPCs
50+ players
1000+ market transactions
100+ active resources
20+ simultaneous world events
```

Os números finais dependem do alvo de infraestrutura e ainda precisam ser validados por profiling.

---

# 20. Backlog de Implementação

| ID | Sistema | Prioridade | Dependência |
|---|---|---:|---|
| EXP-001 | Multiplayer Foundation | P0 | Core |
| EXP-002 | Server Authority | P0 | EXP-001 |
| EXP-003 | World Persistence | P1 | Core |
| EXP-004 | City Simulation | P2 | EXP-003 |
| EXP-005 | NPC Simulation | P2 | EXP-004 |
| EXP-006 | Advanced Economy | P3 | EXP-005 |
| EXP-007 | Global Market | P3 | EXP-006 |
| EXP-008 | Governance 2.0 | P4 | EXP-004 |
| EXP-009 | Political System | P4 | EXP-008 |
| EXP-010 | Religion | P5 | EXP-005 |
| EXP-011 | Relationship 2.0 | P5 | EXP-005 |
| EXP-012 | Marriage | P6 | EXP-011 |
| EXP-013 | Family | P6 | EXP-012 |
| EXP-014 | Skill Tree | P7 | Core |
| EXP-015 | Complete Professions | P7 | EXP-014 |
| EXP-016 | Advanced Weather | P8 | EXP-003 |
| EXP-017 | Natural Disasters | P8 | EXP-016 |
| EXP-018 | Faction System | P9 | EXP-008 |
| EXP-019 | Territory System | P9 | EXP-018 |
| EXP-020 | War System | P9 | EXP-019 |
| EXP-021 | PvP | P10 | EXP-020 |
| EXP-022 | Endless Simulation | P11 | All |
| EXP-023 | Procedural Events | P11 | EXP-022 |

---

# 21. Definition of Done

Uma tarefa só poderá ser marcada como concluída quando:

- código implementado;
- dados configuráveis em `Resource`;
- validações implementadas;
- save/load funcionando;
- testes relevantes passando;
- multiplayer validado quando aplicável;
- erros tratados;
- documentação atualizada;
- `PROJECT_STATE.md` atualizado;
- `BACKLOG.md` atualizado.

