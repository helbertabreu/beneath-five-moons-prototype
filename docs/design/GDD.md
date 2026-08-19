# GDD & TDD — Beneath Five Moons

---

## PARTE I — GAME DESIGN DOCUMENT (GDD)

**Beneath Five Moons**  
**Documento:** Game Design Document  
**Versão:** 0.2.0  
**Status:** Pré-produção / MVP  
**Plataforma inicial:** PC  
**Engine:** Godot 4.7.1  
**Gênero:** RPG Sandbox 2D / Mundo Aberto / Survival Leve / Simulação Social / Economia Dinâmica / Multiplayer Cooperativo PvE

---

### 1. Visão do Projeto

Beneath Five Moons é um RPG Sandbox 2D multiplayer cooperativo no qual o jogador constrói uma vida dentro de um mundo persistente e reativo.  
O jogador começa sem recursos e precisa sobreviver, trabalhar, desenvolver uma profissão, estabelecer relações, acumular patrimônio e reputação e, eventualmente, conquistar a possibilidade de governar um vilarejo.

O mundo reage às ações dos jogadores por meio de:

- Economia;
- Escassez de recursos;
- Clima;
- Estações;
- Eventos naturais;
- Reputação;
- Relações sociais;
- Governança.

---

### 2. Objetivo do Jogador

#### 2.1 MVP

O jogador deve conseguir:

1. Sobreviver.
2. Explorar.
3. Coletar recursos.
4. Escolher uma profissão.
5. Desenvolver a profissão.
6. Produzir itens.
7. Comprar ou alugar uma casa.
8. Desenvolver reputação.
9. Prosperar economicamente.
10. Tornar-se elegível para governar.
11. Governar um vilarejo.
12. Manter a governança por 30 dias.
13. Desbloquear o Endless Sandbox.

---

### 3. Público-Alvo

- Jogadores de RPG.
- Jogadores de Sandbox.
- Jogadores de Survival.
- Jogadores de Role Play.
- Jogadores cooperativos.
- Jogadores interessados em Crafting.
- Jogadores interessados em Economia.

---

### 4. Pilares de Design

#### 4.1 Mundo Vivo e Reativo

O mundo deve mudar em função das ações dos jogadores.

#### 4.2 Escolhas Definem o Personagem

Não existem classes rígidas. A identidade do personagem emerge de:

- Profissão;
- Especializações;
- Habilidades;
- Armas;
- Equipamentos;
- Comportamento;
- Reputação.

#### 4.3 Cooperação

As profissões devem possuir dependências e complementaridades.

#### 4.4 Economia Dinâmica

Oferta, demanda, estoque e reputação devem influenciar o comércio.

#### 4.5 Role Play Acima do Combate

Combate é uma ferramenta do gameplay, não o centro da experiência.

---

### 5. Core Loop

```
EXPLORAR
  ↓
COLETAR
  ↓
DESENVOLVER PROFISSÃO
  ↓
PRODUZIR
  ↓
VENDER / TROCAR
  ↓
GANHAR DINHEIRO
  ↓
MELHORAR EQUIPAMENTOS
  ↓
AUMENTAR REPUTAÇÃO
  ↓
DESBLOQUEAR OPORTUNIDADES
  ↓
PROSPERAR
  ↓
GOVERNAR
  ↓
MANTER O VILAREJO
  ↓
ENDLESS SANDBOX
```

---

### 6. Mundo

O mundo é:

- Aberto;
- Persistente;
- Dividido em territórios;
- Sujeito a alterações temporárias e permanentes;
- Afetado por degradação;
- Afetado por regeneração.

#### MVP

| Tipo         | Quantidade |
| :----------- | :--------- |
| Cidades      | 2          |
| Vilarejos    | 2          |
| Floresta     | 1          |
| Mina         | 1          |
| Lago         | 1          |
| Estrada      | 1          |
| Ruína antiga | 1          |

---

### 7. Sistema de Tempo

O jogo utiliza **Action Time System**.  
O dia possui o ciclo de `06:00 → 06:00`.  
O tempo não avança continuamente durante movimentação normal ou conversas. Ações relevantes consomem tempo.

| Ação                | Tempo                     |
| :------------------ | :------------------------ |
| Coleta              | 15 min                    |
| Crafting ativo      | Conforme receita          |
| Viagem              | 1 h                       |
| Viagem com montaria | 30 min                    |
| Descanso            | 1 h                       |
| Combate             | Conforme regra do sistema |

---

### 8. Fome

A Fome possui escala de `0` a `100`.

#### Faixa de Fome

| Faixa  | Estado     | Efeito                   |
| :----- | :--------- | :----------------------- |
| 81–100 | Alimentado | +10% eficiência          |
| 31–80  | Normal     | Sem modificador          |
| 11–30  | Com Fome   | +50% tempo de trabalho   |
| 1–10   | Faminto    | +100% tempo / 2× Energia |
| 0      | Crítico    | Bloqueia esforço físico  |

#### Consumos

| Ação               | Fome |
| :----------------- | :--- |
| Coleta             | -2   |
| Viagem             | -5   |
| Combate finalizado | -3   |
| Sono               | -20  |

---

### 9. Energia

Energia máxima: `100 pontos/dia`.

| Ação                  | Custo     |
| :-------------------- | :-------- |
| Ferramenta em recurso | -10       |
| Ataques/esquivas      | -5 a -15  |
| Alimentação           | +15 a +40 |
| Descanso de 1h        | +30       |

---

### 10. Fadiga

A Fadiga representa a consequência de trabalhar até tarde.

| Horário     | Resultado                                                       |
| :---------- | :-------------------------------------------------------------- |
| 06:00–22:00 | Sem penalidade                                                  |
| 22:00–02:00 | -20% Energia Máxima no dia seguinte                             |
| Até 06:00   | Desmaio (Acorda ao meio-dia e perde 50% da Energia do novo dia) |

---

### 11. Temperatura

A temperatura funciona como modificador de custo de ação (não utiliza barra contínua).

- **Frio / Neve:**
  - +50% Energia em ações de coleta;
  - Roupas adequadas podem anular o efeito;
  - Alimento quente também pode atuar como proteção.
- **Calor extremo / Tempestade:**
  - +25% consumo de Fome.

---

### 12. Estações

Cada estação dura **7 dias de jogo**.

| Estação   | Características                      |
| :-------- | :----------------------------------- |
| Primavera | Ervas, flores e peixes de superfície |
| Verão     | Frutos e especiarias; calor          |
| Outono    | Cogumelos, raízes e migração animal  |
| Inverno   | Frio, neve e lagos congelados        |

---

### 13. Clima

Tipos de clima:

- Céu limpo
- Chuva
- Tempestade
- Ventania
- Neve
- Nevasca

O clima é determinado às **06:00** de cada dia.

- **Chuva:** +20% chance de surgimento imediato de nós botânicos; maior presença de peixes raros; viagens +15 minutos; fogueiras descobertas podem apagar.
- **Ventania:** acelera disseminação de sementes; coleta de precisão possui 10% de chance de falha ou rendimento reduzido.
- **Nevasca:** reduz visibilidade; aumenta Fadiga; exige proteção contra frio.

---

### 14. Recursos Naturais

Cada Node de recurso possui estado ecológico:

```
INTACTO → DEGRADADO → EXAUSTO → REGENERACIÓN → RECUPERADO
```

Se todos os nós de uma mina forem explorados no mesmo dia:

1. A mina entra em **Exaustão**.
2. No dia seguinte produz recursos inferiores.
3. Após 3 dias sem exploração, os veios profundos se recuperam.

---

### 15. Sistema de Drops

#### 15.1 Objetivo

O sistema de Drop determina quais itens são obtidos a partir de:

- Monstros;
- Recursos naturais;
- Pesca;
- Eventos;
- Caixas;
- Atividades específicas.

---

### 16. Tabela de Balanceamento de Drops _(Proposta Inicial)_

#### 16.1 Drop de Inimigos

| Drop ID | Fonte       | Item              | Tipo        | Chance | Quantidade | Condição          | Tier     |
| :------ | :---------- | :---------------- | :---------- | :----- | :--------- | :---------------- | :------- |
| DRP-001 | ENM-001     | Carne de Lobo     | Material    | 65%    | 1–2        | Sempre            | Comum    |
| DRP-002 | ENM-001     | Pele de Lobo      | Material    | 35%    | 1          | Sempre            | Comum    |
| DRP-003 | ENM-001     | Presa de Lobo     | Material    | 15%    | 1–2        | Sempre            | Incomum  |
| DRP-004 | ENM-001     | Moedas            | Currency    | 25%    | 2–8        | Sempre            | Comum    |
| DRP-005 | ENM-002     | Moedas            | Currency    | 75%    | 8–20       | Sempre            | Comum    |
| DRP-006 | ENM-002     | Adaga Danificada  | Equipamento | 12%    | 1          | Roll independente | Incomum  |
| DRP-007 | ENM-002     | Couro             | Material    | 45%    | 1–3        | Sempre            | Comum    |
| DRP-008 | ENM-002     | Poção Leve        | Consumível  | 8%     | 1          | Roll independente | Raro     |
| DRP-009 | ENM-002     | Chave Enferrujada | Quest       | 3%     | 1          | Evento/quest      | Raro     |
| DRP-010 | `[INIMIGO]` | `[ITEM]`          | `[TIPO]`    | `[X]%` | `[QTD]`    | `[COND.]`         | `[TIER]` |

> **Regra Importante:** As chances acima são rolls independentes, salvo quando o `DropTable` definir explicitamente um grupo exclusivo. Isso evita somar todas as porcentagens e tratá-las incorretamente como uma única tabela de distribuição.

---

### 17. Drop de Recursos Naturais _(Proposta Inicial)_

| Drop ID | Fonte    | Item             | Chance Base | Qtd. Base | Primavera    | Verão  | Outono | Inverno   |
| :------ | :------- | :--------------- | :---------- | :-------- | :----------- | :----- | :----- | :-------- |
| NAT-001 | Ervas    | Erva Comum       | 100%        | 1–3       | +30% respawn | Normal | Normal | -50%      |
| NAT-002 | Ervas    | Raiz             | 45%         | 1–2       | +10%         | Normal | +25%   | -30%      |
| NAT-003 | Floresta | Cogumelo         | 35%         | 1–2       | Normal       | -30%   | +50%   | -50%      |
| NAT-004 | Floresta | Cogumelo Raro    | 8%          | 1         | +5%          | -20%   | +50%   | -50%      |
| NAT-005 | Mina     | Minério de Ferro | 75%         | 1–3       | Normal       | Normal | Normal | Normal    |
| NAT-006 | Mina     | Gema             | 5%          | 1         | Normal       | Normal | +10%   | +10%      |
| NAT-007 | Lago     | Peixe Comum      | 85%         | 1         | +10%         | Normal | Normal | `[REGRA]` |
| NAT-008 | Lago     | Peixe Raro       | 10%         | 1         | +20%         | +10%   | Normal | `[REGRA]` |

---

### 18. Drop Table — Estrutura de Dados

Cada fonte deve possuir:

```text
DropTable
├── drop_id
├── source_id
├── entries[]
│   ├── item_id
│   ├── chance
│   ├── min_quantity
│   ├── max_quantity
│   ├── condition
│   └── guaranteed
├── modifiers[]
└── roll_mode
```

**Opções de `roll_mode`:**

- `INDEPENDENT`
- `WEIGHTED`
- `EXCLUSIVE`
- `GUARANTEED_PLUS_RANDOM`

---

### 19. Profissões

O jogador possui uma profissão principal.  
**Profissões do MVP:**

- Mineração
- Ferraria
- Herborismo
- Alquimia
- Pescaria
- Culinária

---

### 20. Progressão Profissional

A progressão utiliza:

- XP
- Níveis
- Ranks
- Mentores
- Quests
- Centros de treinamento
- Propriedades
- Equipamentos
- Receitas

> Existe dependência direta entre as profissões.

---

### 21. Mineração

| Nível | Ação               | Ferramenta        | Tempo | Energia | Fadiga |
| :---- | :----------------- | :---------------- | :---- | :------ | :----- |
| 1     | Cobre              | Picareta de Pedra | 15m   | -10     | +1     |
| 10    | Ferro              | Picareta de Cobre | 15m   | -12     | +1,2   |
| 25    | Gemas              | Picareta de Ferro | 30m   | -20     | +2     |
| 50    | Cobalto            | Ferro/Aço         | 15m   | -15     | +1,5   |
| 75    | Mithril/Adamantita | Cobalto           | 20m   | -25     | +2,5   |

> **Bônus:** No nível 75+, existe 20% de chance de extrair lote duplo sem custo adicional de tempo ou Energia.

---

### 22. Ferraria

A Ferraria transforma minerais em:

- Lingotes;
- Ferramentas;
- Armas;
- Armaduras;
- Componentes.

> As bancadas passivas processam materiais sem consumir Energia ou Fadiga do jogador durante o processamento.

---

### 23. Herborismo

Responsável pela coleta e processamento de:

- Ervas;
- Raízes;
- Cogumelos;
- Especiarias;
- Recursos do Setor Escuro.

---

### 24. Alquimia

Produz:

- Poções;
- Tônicos;
- Solventes;
- Fertilizantes.

---

### 25. Pescaria

| Nível | Atividade                | Ferramenta      | Tempo      | Energia         |
| :---- | :----------------------- | :-------------- | :--------- | :-------------- |
| 1     | Peixes comuns            | Vara de Madeira | 15m        | -8              |
| 20    | Trutas/peixes grandes    | Vara de Cobre   | 20m        | -12             |
| 35    | Óleo de peixe            | Prensa          | 2h passivo | -5 carregamento |
| 60    | Águas profundas          | Vara de Ferro   | 30m        | -18             |
| 85    | Peixes raros/peçonhentos | Vara de Mithril | 45m        | -25             |

---

### 26. Culinária

| Nível | Item                  | Tempo | Energia | Fadiga |
| :---- | :-------------------- | :---- | :------ | :----- |
| 1     | Peixe Grelhado        | 10m   | -5      | +0,5   |
| 15    | Pão de Ervas          | 30m   | -10     | +1     |
| 35    | Ensopado do Minerador | 45m   | -15     | +1,5   |
| 60    | Ração de Viagem       | 1h    | -20     | +2     |
| 80    | Banquete da Vila      | 4h    | -50     | +5     |

---

### 27. Personagem

Não existem classes fixas. A progressão utiliza:

- Nível (máximo: 100);
- Atributos;
- Especializações;
- Habilidades (máximo: 3 principais);
- Profissão;
- Armas;
- Equipamentos.

---

### 28. Especializações

Máximo de **2 especializações**.

**Arquétipos Emergentes:**

- Guerreiro
- Druida
- Arqueiro
- Espadachim

---

### 29. Combate

O MVP utiliza combate em tempo real.

- **Armas:** Espada, Machado, Adaga, Cajado.
- **Estatísticas:** Ataque, Chance Crítica, Ataque Crítico, Peso, Velocidade, Durabilidade.

---

### 30. Inimigos do MVP

#### ENM-001 — Lobo Esfomeado

- **HP:** 40
- **Dano:** 12
- **Cooldown de Ataque:** 1,5 s
- **Velocidade de Patrulha:** 50 px/s
- **Velocidade de Perseguição:** 110 px/s
- **Detecção:** 180 px
- **Alcance de Ataque:** 35 px

#### ENM-002 — Salteador da Noite

- **HP:** 60
- **Dano:** 15
- **Velocidade de Perseguição:** 120 px/s
- **Atividade:** Preferencialmente noturna

---

### 31. Tabela de Balanceamento de Itens

| ID      | Nome              | Tipo       | Custo     | Atributo     | Resource Multiplier |
| :------ | :---------------- | :--------- | :-------- | :----------- | :------------------ |
| ITM-001 | Minério de Cobre  | Material   | 10        | Refinável    | 1.00                |
| ITM-002 | Lingote de Cobre  | Material   | 35        | Refinado     | 1.00                |
| ITM-003 | Picareta de Pedra | Ferramenta | 50        | Mineração    | 1.00                |
| ITM-004 | Pão de Ervas      | Consumível | 25        | Fome/Energia | 1.00                |
| ITM-005 | Poção de Energia  | Consumível | 60        | +30 Energia  | 1.00                |
| ITM-006 | Espada de Ferro   | Arma       | 250       | Ataque       | 1.00                |
| ITM-007 | Armadura de Ferro | Armadura   | 400       | Defesa       | 1.00                |
| ITM-008 | `[ITEM]`          | `[TIPO]`   | `[CUSTO]` | `[ATRIBUTO]` | `[MULT]`            |

---

### 32. Tabela de Balanceamento de Monstros

| ID      | Nome               | HP     | Dano     | Velocidade | XP     | Drop Table |
| :------ | :----------------- | :----- | :------- | :--------- | :----- | :--------- |
| ENM-001 | Lobo Esfomeado     | 40     | 12       | 110        | `[XP]` | DT-001     |
| ENM-002 | Salteador da Noite | 60     | 15       | 120        | `[XP]` | DT-002     |
| ENM-003 | `[MONSTRO]`        | `[HP]` | `[DANO]` | `[SPEED]`  | `[XP]` | `[DT]`     |

---

### 33. Tabela de Balanceamento de Economia

| Sistema       | Valor Base | Escalonamento | Compra   | Venda    | Taxa     |
| :------------ | :--------- | :------------ | :------- | :------- | :------- |
| Item comum    | 10         | 1.00×         | 100%     | 50%      | `[TAXA]` |
| Item refinado | 35         | 1.05×         | 100%     | 55%      | `[TAXA]` |
| Item raro     | 100        | 1.10×         | 100%     | 60%      | `[TAXA]` |
| Escassez      | `[BASE]`   | até +150%     | `[MULT]` | `[MULT]` | `[TAXA]` |
| Saturação     | `[BASE]`   | até -70%      | `[MULT]` | `[MULT]` | `[TAXA]` |

---

### 34. Tabela de Classes / Arquétipos

| Arquétipo     | HP Base | Energia Base | Atributo Primário | Modificadores     |
| :------------ | :------ | :----------- | :---------------- | :---------------- |
| Guerreiro     | 120     | 100          | Força             | +HP / +Defesa     |
| Espadachim    | 100     | 110          | Agilidade         | +Velocidade       |
| Arqueiro      | 90      | 120          | Agilidade         | +Crítico          |
| Druida        | 85      | 140          | `[ATRIBUTO]`      | +Efeitos naturais |
| `[ARQUÉTIPO]` | `[HP]`  | `[ENERGIA]`  | `[ATRIBUTO]`      | `[MOD]`           |

---

### 35. Tabela de Controle de Versão

| Versão | Data       | Autor               | Alterações                    |
| :----- | :--------- | :------------------ | :---------------------------- |
| 0.1.0  | `[DATA]`   | Helbert             | Rascunho original             |
| 0.2.0  | 18/08/2026 | Helbert / Tech Lead | GDD estruturado + Drop System |
| 0.3.0  | `[DATA]`   | `[AUTOR]`           | Balanceamento                 |
| 1.0.0  | `[DATA]`   | `[AUTOR]`           | GDD aprovado                  |

---

### 36. QA — Requisitos Pendentes

Antes da produção completa, ainda precisam ser definidos:

- Arquitetura multiplayer.
- Fórmula final da economia.
- Curva de XP.
- Inventário.
- Sistema de peso/stack.
- Regras completas de combate.
- Durabilidade.
- Reparação.
- Sistema de morte.
- Respawn.
- Fórmula de governança.
- Persistência.
- Sistema completo de Drop.
- Número máximo de jogadores.
- Autoridade do servidor.

---

### 37. Test Cases Essenciais

| ID     | Teste                    | Resultado Esperado                                      |
| :----- | :----------------------- | :------------------------------------------------------ |
| TC-001 | Energia insuficiente     | Ação bloqueada                                          |
| TC-002 | Fome = 10                | Estado Faminto                                          |
| TC-003 | Fome = 0                 | Ação física bloqueada                                   |
| TC-004 | 05:45 + 30min            | Novo dia corretamente iniciado                          |
| TC-005 | Bancada passiva          | Não consome Energia/Fadiga                              |
| TC-006 | Estoque = 0              | Economia não gera NaN/INF                               |
| TC-007 | Recurso exaurido         | Drop inferior no dia seguinte                           |
| TC-008 | Recurso após 3 dias      | Regeneração                                             |
| TC-009 | Reputação = 9000         | Elegibilidade ativada                                   |
| TC-010 | Drop 100%                | Item sempre obtido                                      |
| TC-011 | Drop 0%                  | Item nunca obtido                                       |
| TC-012 | Dois drops independentes | Ambos podem cair                                        |
| TC-013 | Quantidade min/max       | Resultado sempre dentro do intervalo                    |
| TC-014 | Modificador de estação   | Chance final respeita limites                           |
| TC-015 | Drop raro                | Probabilidade estatística converge ao valor configurado |

---

## PARTE II — TECHNICAL DESIGN DOCUMENT (TDD)

**Beneath Five Moons**  
**Technical Design Document — TDD**  
**Versão:** 0.1.0  
**Engine:** Godot 4.x  
**Linguagem:** GDScript  
**Plataforma inicial:** PC  
**Arquitetura:** Data-Driven + Event-Driven  
**Multiplayer:** Cooperativo PvE — arquitetura preparada para autoridade de servidor

---

### 1. Objetivo do TDD

O TDD transforma as regras do GDD em uma especificação técnica implementável.

- **GDD responde:** O que o jogo deve fazer?
- **TDD responde:** Como o sistema será implementado na Godot 4?

---

### 2. Princípios Arquiteturais

#### 2.1 Data Driven

Valores de gameplay não devem estar hardcoded. Exemplo:

- `ItemData.tres`
- `MonsterData.tres`
- `DropTable.tres`
- `RecipeData.tres`
- `ProfessionData.tres`
- `WeatherData.tres`

---

### 3. Estrutura de Diretórios

```text
res://
│
├── assets/
│   ├── art/
│   ├── audio/
│   ├── fonts/
│   └── ui/
│
├── data/
│   ├── items/
│   ├── monsters/
│   ├── drops/
│   ├── professions/
│   ├── recipes/
│   ├── weapons/
│   ├── armor/
│   ├── weather/
│   ├── seasons/
│   └── quests/
│
├── scenes/
│   ├── main/
│   ├── player/
│   ├── world/
│   ├── enemies/
│   ├── npcs/
│   ├── interactables/
│   └── ui/
│
├── scripts/
│   ├── core/
│   ├── systems/
│   ├── player/
│   ├── combat/
│   ├── world/
│   ├── economy/
│   ├── drops/
│   ├── professions/
│   ├── quests/
│   ├── multiplayer/
│   └── ui/
│
└── tests/
    ├── unit/
    ├── integration/
    └── gameplay/
```

---

### 4. Cena Principal (`Main.tscn`)

```text
Main.tscn
└── GameRoot
    │
    ├── World
    │   ├── CurrentRegion
    │   ├── ResourceNodes
    │   ├── NPCs
    │   ├── Enemies
    │   └── InteractiveObjects
    │
    ├── PlayerContainer
    │
    ├── Systems
    │   ├── TimeSystem
    │   ├── WeatherSystem
    │   ├── SeasonSystem
    │   ├── SurvivalSystem
    │   ├── ResourceSystem
    │   ├── EconomySystem
    │   ├── DropSystem
    │   ├── ProfessionSystem
    │   ├── ReputationSystem
    │   ├── QuestSystem
    │   ├── CombatSystem
    │   └── GovernanceSystem
    │
    └── UI
        ├── HUD
        ├── InventoryUI
        ├── CharacterUI
        ├── ProfessionUI
        ├── QuestUI
        ├── EconomyUI
        └── NotificationUI
```

---

### 5. Autoloads

Somente sistemas realmente globais devem utilizar Autoload.

| Autoload         | Responsabilidade          |
| :--------------- | :------------------------ |
| `GameManager`    | Estado global da sessão   |
| `TimeManager`    | Relógio                   |
| `SaveManager`    | Persistência              |
| `EventBus`       | Signals globais           |
| `DataManager`    | Carregamento de Resources |
| `NetworkManager` | Rede                      |
| `AudioManager`   | Áudio                     |

---

### 6. GameManager

Responsável pelo estado macro.

```gdscript
class_name GameManager
extends Node

var current_world: Node
var game_mode: String
var is_paused: bool
```

> **Aviso:** Não deve possuir lógica específica de combate, economia, crafting ou drops.

---

### 7. TimeManager

O TimeManager é a única autoridade sobre o tempo.

```gdscript
class_name TimeManager
extends Node

signal time_advanced(minutes: int)
signal day_started(day: int)
signal season_changed(season_id: String)

var day: int = 1
var hour: int = 6
var minute: int = 0
```

**API:**

- `func advance_time(minutes: int) -> void`
- `func get_total_minutes() -> int`
- `func is_late_night() -> bool`
- `func get_time_string() -> String`

---

### 8. Action System

Todas as ações relevantes devem passar por um sistema central:

```text
Action Request → ActionValidator → Cost Calculator → ActionExecutor → Apply Result → TimeManager.advance_time() → Signals
```

```gdscript
class_name GameAction
extends RefCounted

var action_id: String
var time_cost: int
var energy_cost: float
var hunger_cost: float
var fatigue_cost: float
```

---

### 9. SurvivalSystem

Responsável por Fome, Energia, Fadiga e modificadores ambientais.

**API:**

- `func consume_hunger(amount: float) -> void`
- `func consume_energy(amount: float) -> void`
- `func restore_energy(amount: float) -> void`
- `func restore_hunger(amount: float) -> void`
- `func calculate_action_modifier() -> Dictionary`

> Nunca permitir `hunger < 0` ou `energy < 0`, salvo quando uma mecânica explicitamente exigir outro comportamento.

---

### 10. Resource System

Cada recurso natural será uma cena baseada em um componente de recurso.

```text
ResourceNode
├── Visual
├── CollisionShape2D
├── InteractionArea
└── ResourceController
```

**Estados:**

```gdscript
enum ResourceState {
    INTACT,
    DEGRADED,
    EXHAUSTED,
    REGENERATING
}
```

---

### 11. Resource Data

```gdscript
class_name ResourceNodeData
extends Resource

@export var resource_id: String
@export var display_name: String
@export var base_yield: int
@export var depletion_threshold: int
@export var regeneration_days: int = 3
@export var drop_table: DropTableData
```

---

### 12. Drop System

```text
DropSource → DropSystem → Load DropTable → Apply Conditions → Apply Modifiers → Roll → Generate Loot → InventorySystem
```

---

### 13. DropTable Resource

```gdscript
class_name DropTableData
extends Resource

@export var drop_table_id: String
@export var roll_mode: RollMode
@export var entries: Array[DropEntryData]
```

---

### 14. DropEntry Resource

```gdscript
class_name DropEntryData
extends Resource

@export var item_id: String
@export_range(0.0, 1.0) var chance: float
@export var min_quantity: int = 1
@export var max_quantity: int = 1
@export var guaranteed: bool = false
@export var condition_id: String
```

---

### 15. Roll Independente

Para um drop de 35%:

```gdscript
func roll_entry(entry: DropEntryData) -> bool:
    return randf() <= entry.chance
```

Para quantidade:

```gdscript
var amount := randi_range(
    entry.min_quantity,
    entry.max_quantity
)
```

---

### 16. Drop Modifiers

O resultado final deverá ser:
$$ ext{Final Chance} = ext{Base Chance} imes ext{Season Modifier} imes ext{Weather Modifier} imes ext{Profession Modifier} imes ext{World Modifier}$$

Limitação por clamp:

```gdscript
final_chance = clamp(
    calculated_chance,
    0.0,
    MAX_DROP_CHANCE
)
```

---

### 17. Importante — Não Confundir Drop com Respawn

São sistemas totalmente diferentes:

- **Respawn:** Determina _quando_ um recurso volta ao mundo.
- **Drop:** Determina _o que_ o jogador recebe ao interagir/derrotar/coletar.

```text
ResourceNode → RespawnSystem → Node disponível → Player coleta → DropSystem → Loot
```

---

### 18. Monster Architecture

```text
Enemy.tscn
└── CharacterBody2D
    ├── Visual
    ├── CollisionShape2D
    ├── DetectionArea
    ├── AttackArea
    ├── Hurtbox
    ├── NavigationAgent2D
    └── StateMachine
```

**Estados:** `IDLE`, `PATROL`, `CHASE`, `ATTACK`, `HURT`, `FLEE`, `DEAD`.

---

### 19. MonsterData

```gdscript
class_name MonsterData
extends Resource

@export var monster_id: String
@export var display_name: String
@export var max_hp: float
@export var attack_damage: float
@export var movement_speed: float
@export var detection_radius: float
@export var attack_range: float
@export var attack_cooldown: float
@export var xp_reward: int
@export var drop_table: DropTableData
```

---

### 20. Exemplo — Lobo

```gdscript
monster_id = "ENM-001"
max_hp = 40
attack_damage = 12
patrol_speed = 50
chase_speed = 110
detection_radius = 180
attack_range = 35
attack_cooldown = 1.5
drop_table = DT-001
```

---

### 21. Exemplo — Salteador

```gdscript
monster_id = "ENM-002"
max_hp = 60
attack_damage = 15
chase_speed = 120
night_preference = true
drop_table = DT-002
```

---

### 22. InventorySystem

Responsável por adicionar/remover itens, stack, verificar quantidades, equipamentos, containers, peso e persistência.

**API Mínima:**

- `func add_item(item_id: String, amount: int) -> bool`
- `func remove_item(item_id: String, amount: int) -> bool`
- `func has_item(item_id: String, amount: int) -> bool`
- `func get_item_count(item_id: String) -> int`

---

### 23. ItemData

```gdscript
class_name ItemData
extends Resource

@export var item_id: String
@export var display_name: String
@export var item_type: String
@export var base_price: int
@export var max_stack: int
@export var weight: float
@export var durability_max: float
```

---

### 24. ProfessionSystem

```text
ProfessionState
├── profession_id
├── level
├── xp
├── unlocked_recipes
└── specializations
```

> Impede duas profissões principais simultâneas.

---

### 25. RecipeData

```gdscript
class_name RecipeData
extends Resource

@export var recipe_id: String
@export var profession_id: String
@export var required_level: int
@export var ingredients: Array
@export var output_item_id: String
@export var output_quantity: int
@export var action_time: int
@export var energy_cost: float
@export var fatigue_cost: float
@export var passive: bool
```

---

### 26. Bancadas Passivas

```text
ProcessingStation
├── Input
├── Output
├── Recipe
├── StartTime
├── FinishTime
└── State
```

**Estados:** `IDLE`, `LOADED`, `PROCESSING`, `READY`.  
_O carregamento custa tempo/recursos; o processamento não consome Energia/Fadiga do jogador._

---

### 27. WeatherSystem

Gera o clima diário às 06:00, consulta a estação, aplica modificadores e avisa os outros sistemas.

```gdscript
signal weather_changed(weather_id: String)
```

---

### 28. SeasonSystem

```gdscript
enum Season {
    SPRING,
    SUMMER,
    AUTUMN,
    WINTER
}
```

- Duração: `duration_days = 7`
- Expõe modificadores para respawn, drop, Energia, Fome, viagem e clima.

---

### 29. EconomySystem

```text
Player → EconomySystem → MarketState → PriceCalculator → Transaction → Inventory → Reputation
```

---

### 30. PriceCalculator

```gdscript
class_name PriceCalculator
extends RefCounted

func calculate_price(
    base_price: float,
    stock: float,
    demand: float,
    reputation_multiplier: float
) -> float:
    # Fórmula final será definida no balanceamento.
    return base_price
```

---

### 31. ReputationSystem

```text
ReputationState
├── NPC
├── Village
├── City
├── Religion
└── Faction
```

- **Faixa:** `0` a `10000`
- **Ranks:** `0–999`, `1000–2999`, `3000–5999`, `6000–8999`, `9000–10000`.

---

### 32. RelationshipSystem

```gdscript
enum RelationshipLevel {
    HATE,
    NEUTRAL,
    LIKE,
    LOVE
}
```

- Sistema totalmente independente do `ReputationSystem`.

---

### 33. QuestSystem

```text
QuestData
├── quest_id
├── title
├── description
├── objectives
├── rewards
├── reputation_changes
├── time_limit
└── requirements
```

---

### 34. GovernanceSystem

```text
VillageGovernmentState
├── governor_id
├── treasury
├── tax_rate
├── prosperity
├── security
├── approval
├── infrastructure
└── consecutive_days
```

> Todos os indicadores usam a faixa `0–100`.

---

### 35. Condição de Vitória

```gdscript
func has_completed_mvp() -> bool:
    return (
        consecutive_governance_days >= 30
        and prosperity > 70
        and approval > 80
    )
```

---

### 36. EventBus

```gdscript
signal time_advanced(minutes)
signal day_started(day)
signal season_changed(season)
signal weather_changed(weather)
signal player_died(player_id)
signal resource_depleted(resource_id)
signal resource_regenerated(resource_id)
signal item_obtained(item_id, amount)
signal monster_killed(monster_id)
signal reputation_changed(target_id, value)
signal profession_level_up(profession_id, level)
signal quest_completed(quest_id)
signal government_changed(village_id)
```

---

### 37. Save System

```text
SaveData
├── version
├── world
├── time
├── season
├── weather
├── players
├── resources
├── NPCs
├── economy
├── quests
└── villages
```

---

### 38. Save Versioning

Armazena `save_version` (ex.: `1.0.0`). Alterações de versão exigem rotinas de migração.

---

### 39. Multiplayer

```text
CLIENT → REQUEST → SERVER → VALIDATE → MODIFY STATE → REPLICATE
```

> Servidor é a única autoridade para: loot, dano, dinheiro, XP, reputação, drops, recursos e crafting.

---

### 40. Multiplayer — Exemplo de Drop

- **Incorreto:** Client faz `randf() -> Drop`
- **Correto:** Client envia `"Matei ENM-001"` $
ightarrow$ Server valida $
ightarrow$ `DropSystem` executa Roll RNG $
ightarrow$ `InventorySystem` adiciona $
ightarrow$ Recompensa replicada ao Client.

---

### 41. Sistema de Interação

```gdscript
func can_interact(actor: Node) -> bool:
    return true

func interact(actor: Node) -> void:
    pass

func get_interaction_text() -> String:
    return "Interagir"
```

---

### 42. Player Scene

```text
PlayerCharacter (CharacterBody2D)
├── Visual
├── CollisionShape2D
├── InteractionArea (Area2D)
├── Hurtbox (Area2D)
├── Camera2D
├── AnimationPlayer
├── StateMachine
└── InteractionController
```

---

### 43. Input

| Ação       | Tecla     |
| :--------- | :-------- |
| Interagir  | E / Space |
| Inventário | I / Tab   |
| Quests     | J         |
| Perfil     | C         |
| Quick Save | F5        |
| Quick Load | F9        |

---

### 44. Debug Tools (`OS.is_debug_build()`)

- `Shift + 1` → Simular coleta
- `Shift + 2` → Simular comida
- `Shift + 3` → Simular viagem
- `Shift + 4` → Simular descanso
- `Shift + H` → Restaurar Fome/Energia
- `Shift + T` → Avançar 3 dias
- `Shift + K` → +30 Reputação
- `Shift + L` → -30 Reputação
- `Shift + Q` → Aceitar quest
- `Shift + 0` → Entregar quest

---

### 45. QA Automatizado — Estrutura

```text
tests/
├── unit/
│   ├── test_drop_system.gd
│   ├── test_economy.gd
│   ├── test_survival.gd
│   └── test_time_manager.gd
│
├── integration/
│   ├── test_mining_flow.gd
│   ├── test_crafting_flow.gd
│   └── test_market_flow.gd
│
└── gameplay/
    └── test_mvp_progression.gd
```

---

### 46. Testes do DropSystem

1. **Teste 100%:** `chance = 1.0` $
ightarrow$ 100% dos rolls devem gerar o item.
2. **Teste 0%:** `chance = 0.0` $
ightarrow$ nenhum roll deve gerar o item.
3. **Quantidade:** `min = 2`, `max = 5` $
ightarrow$ $2 \le 	ext{quantity} \le 5$.
4. **Independência:** Dois drops de 50% podem produzir: nenhum, apenas A, apenas B, ou A+B.

---

### 47. Teste Estatístico do Drop

Para 10.000 rolls com `chance = 0.10`, espera-se aproximar de 1.000 drops dentro da tolerância estatística do QA.

---

### 48. Matriz de Dependências

| Sistema    | Depende de                      | Afeta              |
| :--------- | :------------------------------ | :----------------- |
| Time       | —                               | Quase todos        |
| Survival   | Time                            | Player             |
| Weather    | Time + Season                   | Mundo              |
| Season     | Time                            | Weather / World    |
| Resource   | Time + Weather                  | Inventory          |
| Drop       | Resource / Combat               | Inventory          |
| Inventory  | ItemData                        | Economy / Crafting |
| Profession | XP + Actions                    | Recipes            |
| Crafting   | Inventory + Time                | Economy            |
| Combat     | Player + EnemyData              | Drop / XP          |
| Economy    | Inventory + Reputation          | Player             |
| Reputation | Actions                         | Governance         |
| Governance | Reputation + Economy            | World              |
| Save       | Todos os estados                | Persistência       |
| Network    | Todos os sistemas autoritativos | Multiplayer        |

---

### 49. Ordem de Implementação

```text
1. Project Foundation
   ↓
2. Data Resources
   ↓
3. TimeManager
   ↓
4. Action System
   ↓
5. Player
   ↓
6. Survival
   ↓
7. Inventory
   ↓
8. Resource Nodes
   ↓
9. Drop System
   ↓
10. Professions
   ↓
11. Crafting
   ↓
12. Economy
   ↓
13. NPCs
   ↓
14. Combat
   ↓
15. Weather / Seasons
   ↓
16. Reputation
   ↓
17. Quests
   ↓
18. Governance
   ↓
19. Save/Load
   ↓
20. Multiplayer
```

---

### 50. Critérios de Aceitação do MVP

```text
Criar personagem
  ↓
Acordar
  ↓
Comer
  ↓
Explorar
  ↓
Coletar
  ↓
Obter Drop
  ↓
Guardar no Inventário
  ↓
Escolher profissão
  ↓
Evoluir profissão
  ↓
Craftar
  ↓
Vender
  ↓
Alterar economia
  ↓
Ganhar reputação
  ↓
Comprar/alugar casa
  ↓
Atingir 9.000 reputação
  ↓
Cumprir requisitos
  ↓
Governar
  ↓
Gerenciar vilarejo
  ↓
Manter >70% Prosperidade
  ↓
Manter >80% Aprovação
  ↓
30 dias
  ↓
MVP COMPLETE
  ↓
ENDLESS SANDBOX
```

---

### 51. Principais Decisões Técnicas

| ID     | Decisão                              | Justificativa                                   |
| :----- | :----------------------------------- | :---------------------------------------------- |
| TD-001 | Usar Resource para dados             | Balanceamento sem alterar código                |
| TD-002 | TimeManager como autoridade temporal | Evitar inconsistências                          |
| TD-003 | DropSystem separado                  | Reutilização entre inimigos, natureza e eventos |
| TD-004 | Drop Table configurável              | Facilitar balanceamento                         |
| TD-005 | Signals para eventos                 | Reduz acoplamento                               |
| TD-006 | Save baseado em estado               | Independência dos Nodes                         |
| TD-007 | Server authority                     | Segurança multiplayer                           |
| TD-008 | Action System                        | Centralizar custos de tempo/energia/fome        |
| TD-009 | Respawn separado de Drop             | Separar ecologia de loot                        |
| TD-010 | Classes não rígidas                  | Preservar design emergente                      |

---

### 52. Próximo Documento de Produção

Com o GDD 0.2.0 + TDD 0.1.0, a próxima etapa é produzir uma **Especificação Técnica de Implementação**, começando pela fundação:

```text
PROJECT → Autoloads → Data Resources → TimeManager → Action System → Player → Inventory → Resource Nodes → Drop System
```

> **Observação:** As tabelas de drops fornecidas neste documento devem ser tratadas como **propostas iniciais de balanceamento**, visto que o material original conceitua as mecânicas, mas não fecha a totalidade das probabilidades matemáticas dos inimigos.
