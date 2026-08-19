# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto Beneath Five Moons.
> Preserva o histórico de decisões e impede que alterações previamente aprovadas sejam modificadas sem justificativa ou autorização explícita.

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — Padronização na Godot Engine 4.7.1 e GDScript Fortemente Tipado
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
O projeto é desenvolvido na Godot Engine 4.7.1 utilizando GDScript fortemente tipado para garantir integridade, desempenho no ecossistema 2D e detecção prévia de erros de compilação.

### Decisão
Todo o código, chamadas de API, tipos estáticos de variáveis e estruturação de nós devem ser rigorosamente compatíveis com a versão 4.7.1 da Godot Engine.

### Motivo
Evitar inconsistências de versão, garantir máxima compatibilidade e evitar o uso de sintaxes obsoletas do Godot 3.x ou APIs não homologadas.

---

## ADR-002 — Arquitetura de Componentes e Composição
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
O projeto precisa manter sistemas modulares, flexíveis, desacoplados e testáveis para entidades como jogador, NPCs, inimigos e recursos do mundo.

### Decisão
Priorizar composição por Nodes/Components (`HealthComponent`, `SurvivalComponent`, `InventoryComponent`, `LootTableComponent`) e emissão de sinais em vez de hierarquias profundas de herança de scripts.

### Motivo
Reduzir acoplamento, facilitar a manutenção, permitir a reutilização de código e simplificar a criação de suítes de testes unitários isolados.

---

## ADR-003 — Centralização Temporal e de Custo via Action Time System
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
O GDD especifica um *Action Time System*, no qual o tempo avança primariamente quando o jogador realiza ações intencionais (coleta, viagem, descanso, crafting). O protótipo legado avançava o relógio continuamente em tempo real.

### Decisão
O `TimeManager` avança o tempo de forma discreta e atômica unicamente através da validação e execução de instâncias de `GameAction` coordenadas centralmente pelo `ActionSystem`.

### Motivo
Elimina a degradação involuntária de fome e fadiga sem ação direta do jogador e garante sincronia com as regras biológicas e o ciclo diário do GDD.

---

## ADR-004 — Busca Agnóstica e Polimórfica de Componentes
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
Componentes acessados por serviços e sistemas centrais (como o `ActionSystem` buscando o `SurvivalComponent`) podem possuir nomes de nó variados na árvore de cena (`PlayerSurvival`, `@Node@2`) ou serem instanciados dinamicamente em testes automatizados.

### Decisão
Sistemas de serviços não devem depender de Strings de nome de nós rígidas (`get_node("SurvivalComponent")`). Devem utilizar verificações de tipagem estática e iteradores de filhos (`child is SurvivalComponent`) como fallback resiliente.

### Motivo
Garante robustez em testes unitários automatizados, evita falsos erros no console e permite flexibilidade na montagem de cenas no editor Godot.

---

## ADR-005 — Drop System Data-Driven e Modificadores Ecológicos
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
A geração de saques e coleta de recursos naturais/inimigos não deve conter probabilidades hardcoded dentro de scripts de gameplay.

### Decisão
Implementar a separação total entre dados e lógica através dos Custom Resources `DropTableData` e `DropEntryData`, processados pelo serviço estático `DropSystem`. O sistema aplica modificadores ambientais ($Calculated = Base \times Season \times Weather \times Profession$) e suporta os modos de rolagem `INDEPENDENT`, `WEIGHTED` e `EXCLUSIVE`.

### Motivo
Permite balanceamento de loot diretamente pelo Inspetor do Godot sem alteração de código, facilita testes estatísticos e suporta a ecologia reativa do jogo.

---

## ADR-006 — Machine de Estados Finitos (`EnemyStateMachine`) para IA de Inimigos
**Data:** 19/08/2026  
**Status:** ATIVA

### Contexto
A IA dos inimigos legados (`ENM-001 Lobo` e `ENM-002 Salteador`) executava verificações densas de polling e estados misturados dentro da função `_physics_process`.

### Decisão
Adoção da classe global unívoca `EnemyStateMachine` com nós de estado desacoplados derivados de `State` (`IdleState`, `PatrolState`, `ChaseState`, `AttackState`, `DeadState`). A comunicação do ciclo de vida e das conexões de morte é feita via sinais (`health_depleted` / `died` no `HealthComponent`).

### Motivo
Elimina o polling desnecessário, melhora a modularidade, evita sombras de símbolos no registrador GDScript e facilita a criação de novos comportamentos para inimigos expandidos.

---

# DECISÕES EM AVALIAÇÃO / PROPOSTAS

## ADR-007 — Versionamento e Migração de Saves
**Data:** 19/08/2026  
**Status:** PROPOSTA

### Contexto
O `SaveManager` atual armazena dicionários de estado em disco sem registrar a versão do esquema de dados.

### Problema
Adições de propriedades em futuras Sprints causarão falhas de referência nula (*null reference exceptions*) em jogos salvos em versões anteriores.

### Decisão Proposta
Inserir a chave obrigatória `save_version` em todo arquivo salvo e criar uma pipeline de funções de migração sequenciais dentro do `SaveManager`.

---

# REGRAS DO DOCUMENTO

1. Nunca apagar decisões importantes.
2. Nunca alterar uma decisão ATIVA silenciosamente.
3. Se uma nova decisão contradizer uma decisão anterior, registrar uma nova ADR.
4. Explicar o motivo da mudança.
5. Preservar o histórico.
6. Referenciar arquivos e sistemas afetados quando relevante.
7. O documento deve representar decisões realmente aprovadas, não apenas sugestões.
8. Decisões provisórias devem ser claramente marcadas como PROPOSTA.
