# Beneath Five Moons — Technical Design Document (TDD)
## Documento de Expansão

**Versão:** 1.0.0  
**Engine:** Godot 4.x  
**Arquitetura:** orientada a sistemas, dados e estado persistente  
**Multiplayer:** server-authoritative

---

# 1. Objetivo Técnico

Este documento define a arquitetura técnica necessária para transformar o escopo de expansão em sistemas implementáveis na Godot 4, preservando separação entre dados, estado de runtime, lógica de domínio, apresentação e persistência.

Regra fundamental:

```text
Resource = definição de dados
State = estado atual
System = regra de negócio
Scene/Node = representação/runtime
```

---

# 2. Arquitetura Geral

```text
                         GAME SERVER
                              │
              ┌───────────────┼────────────────┐
              │               │                │
           WORLD           ECONOMY          POLITICS
              │               │                │
       ┌──────┼──────┐        │          ┌─────┼─────┐
       │      │      │        │          │     │     │
     NPCs   Weather Combat   Market     Laws  War  Religion
       │      │      │        │          │     │     │
       └──────┴──────┴────────┴──────────┴─────┴─────┘
                              │
                          PLAYERS
```

---

# 3. Estrutura de Cenas

```text
Main
├── World
│   ├── Regions
│   ├── Cities
│   ├── Villages
│   ├── Wilderness
│   └── DynamicEvents
├── Players
├── NPCs
├── Systems
└── UI
```

---

# 4. Organização de Código

```text
scripts/
├── core/
├── systems/
│   ├── world/
│   ├── time/
│   ├── weather/
│   ├── survival/
│   ├── inventory/
│   ├── crafting/
│   ├── professions/
│   ├── skills/
│   ├── combat/
│   ├── npc/
│   ├── relationship/
│   ├── marriage/
│   ├── religion/
│   ├── politics/
│   ├── governance/
│   ├── economy/
│   ├── market/
│   ├── diplomacy/
│   ├── war/
│   ├── territory/
│   ├── multiplayer/
│   ├── persistence/
│   └── events/
├── entities/
└── ui/
```

---

# 5. Resources Customizados

Tipos recomendados:

```text
ItemData
RecipeData
ProfessionData
SkillData
NPCData
ReligionData
CityData
BuildingData
LawData
FactionData
WeatherData
EnemyData
DropTableData
MarketData
WeaponData
ArmorData
```

Exemplo conceitual:

```gdscript
class_name ItemData
extends Resource

@export var item_id: String
@export var display_name: String
@export var base_price: int
@export var weight: float
@export var stack_size: int
```

---

# 6. Estado Persistente

Cada entidade persistente deverá possuir identificador estável:

```gdscript
var persistent_id: String
```

O ID não deve depender da posição do Node na árvore.

Estados importantes:

```text
WorldState
RegionState
CityState
VillageState
TerritoryState
PlayerState
NPCState
MarketState
ReligionState
GovernmentState
WarState
WeatherState
RelationshipState
MarriageState
```

---

# 7. Autoloads

Autoloads recomendados:

```text
GameManager
EventBus
TimeManager
DataManager
SaveManager
WorldStateManager
SettingsManager
```

Evitar transformar todo sistema em Autoload.

Sistemas de domínio devem ser instanciados conforme a necessidade do mundo.

---

# 8. NPC Architecture

```text
NPC
├── CharacterBody2D
├── Visual
├── NavigationAgent2D
├── InteractionArea
├── AIController
├── ScheduleController
└── RelationshipController
```

Estados:

```text
SLEEP
WORK
EAT
TRAVEL
SOCIALIZE
SHOP
PRAY
FLEE
FIGHT
FOLLOW
REST
```

---

# 9. NPC Simulation LOD

```text
Near Player
→ Full Simulation

Same Region
→ Reduced Simulation

Far Region
→ Statistical Simulation
```

O objetivo é permitir dezenas ou centenas de NPCs sem simular cada indivíduo com a mesma frequência.

---

# 10. CityController

```text
CityController
├── PopulationSystem
├── EconomySystem
├── GovernanceSystem
├── SecuritySystem
├── ReligionSystem
├── InfrastructureSystem
├── MarketSystem
└── EventSystem
```

---

# 11. Governance Architecture

```text
GovernmentController
├── Treasury
├── TaxSystem
├── LawSystem
├── CouncilSystem
├── ApprovalSystem
├── ElectionSystem
├── InfrastructureSystem
└── PoliticalEventSystem
```

Ticks:

```text
Daily
Weekly
Monthly
Yearly
```

---

# 12. Religion Architecture

```text
ReligionSystem
├── ReligionRegistry
├── FaithState
├── DoctrineSystem
├── RitualSystem
├── ClergySystem
├── HolySiteSystem
└── ReligiousConflictSystem
```

---

# 13. Marriage Architecture

```text
RelationshipSystem
→ RomanceSystem
→ MarriageSystem
→ FamilySystem
→ Property / Inheritance
```

---

# 14. War Architecture

```text
WarSystem
├── FactionSystem
├── TerritorySystem
├── MilitarySystem
├── SupplySystem
├── SiegeSystem
├── DiplomacySystem
├── WarState
└── PeaceTreatySystem
```

---

# 15. Economy Architecture

```text
EconomySystem
├── LocalMarket
├── RegionalMarket
├── GlobalMarket
├── ProductionSystem
├── ConsumptionSystem
├── TradeSystem
├── LogisticsSystem
├── PriceSystem
├── TaxSystem
└── AuctionSystem
```

---

# 16. Dynamic Price Engine

Modelo configurável:

```text
FinalPrice =
BasePrice
× ReputationMultiplier
× SupplyDemandModifier
× TransportModifier
× TaxModifier
× EventModifier
```

A fórmula final deverá ser parametrizada em `Resource` e validada durante balanceamento.

O GDD original possui uma fórmula preliminar de preço dinâmico, mas ela é explicitamente marcada para conferência; portanto não deve ser codificada como regra definitiva sem validação.

---

# 17. Weather Architecture

```text
WeatherSystem
├── RegionalWeather
├── ForecastSystem
├── ClimateSimulation
├── SeasonalSystem
├── NaturalDisasterSystem
└── EnvironmentalEffects
```

O estado climático é determinado pelo servidor no multiplayer.

---

# 18. EventBus

Os sistemas deverão comunicar eventos sem acoplamento excessivo.

Exemplo:

```gdscript
signal world_event_started(event_id)
signal world_event_finished(event_id)
signal economy_changed(region_id)
signal war_started(war_id)
signal law_changed(law_id)
```

---

# 19. Multiplayer

Princípio:

> O servidor é autoridade sobre o estado do mundo.

Fluxo:

```text
Client Input
→ Request
→ Server Validation
→ Execute
→ Update State
→ Replicate
```

Nunca aceitar do cliente diretamente:

- dinheiro;
- inventário;
- XP;
- posição autoritativa;
- propriedade;
- território;
- resultado de combate;
- resultado de transação.

---

# 20. Persistência

O Save System deverá armazenar:

```text
World
Players
NPCs
Cities
Markets
Politics
Religion
Wars
Territories
Weather
Resources
Buildings
Relationships
Marriages
Skills
Professions
```

O formato deverá ser versionado para permitir migrações de save.

---

# 21. Endless Sandbox

Tecnicamente:

```text
NarrativeCompletion = true
```

não deverá iniciar uma segunda simulação. O mesmo mundo continua.

---

# 22. Performance

Requisitos arquiteturais:

- simulação por distância;
- atualização por ticks;
- cache de dados;
- processamento em lote;
- evitar `_process()` indiscriminado em centenas de entidades;
- reduzir frequência de NPCs distantes;
- separar estado lógico de representação visual.

---

# 23. Segurança Multiplayer

Todas as operações econômicas e de progressão deverão ser validadas no servidor.

Exemplos:

```text
BuyItem
SellItem
CraftItem
CollectResource
AwardXP
ChangeMoney
ChangeProperty
ClaimTerritory
StartWar
```

---

# 24. Persistência e Transações

Transações críticas devem ser idempotentes.

Exemplo:

```text
Transaction ID
→ Validate
→ Execute
→ Commit
→ Replicate
```

Se a mesma requisição for recebida duas vezes, o resultado não deve duplicar a operação.

---

# 25. Critério de Pronto Técnico

Um sistema só deve ser considerado pronto quando:

- possui dados separados da lógica;
- possui estado persistente;
- possui validação;
- possui testes;
- possui tratamento de erro;
- funciona em save/load;
- não depende de Nodes que não deveriam existir;
- funciona em multiplayer quando aplicável;
- está documentado;
- está integrado ao `EventBus` quando necessário.
