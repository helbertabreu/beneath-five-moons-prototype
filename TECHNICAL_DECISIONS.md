# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto Beneath Five Moons.[cite: 1, 8]
> Preserva o histórico de decisões e impede alterações não justificadas.[cite: 8]

---

# STATUS POSSÍVEIS

- PROPOSTA[cite: 8]
- ATIVA[cite: 8]
- SUPERADA[cite: 8]
- CANCELADA[cite: 8]

---

# DECISÕES ATIVAS

## ADR-001 — Padronização em Godot Engine 4.7.1 e GDScript Fortemente Tipado[cite: 1, 8]
**Data:** 19/08/2026[cite: 1, 8]  
**Status:** ATIVA[cite: 8]

### Contexto
O projeto é desenvolvido na Godot Engine 4.7.1 utilizando GDScript fortemente tipado para garantir integridade, desempenho e detecção de erros em tempo de compilação.[cite: 1, 8]

### Decisão
Todo o código, chamadas de API e estruturação de nós devem ser estritamente compatíveis com a versão 4.7.1 da Godot Engine.[cite: 1, 8]

---

## ADR-002 — Arquitetura de Componentes e Composição[cite: 8]
**Data:** 19/08/2026[cite: 1, 8]  
**Status:** ATIVA[cite: 8]

### Contexto
O projeto precisa manter sistemas flexíveis, desacoplados e testáveis para entidades como jogador, NPCs, inimigos e recursos.[cite: 8]

### Decisão
Priorizar composição por Nodes/Components (`HealthComponent`, `SurvivalComponent`, `InventoryComponent`) e emissão de sinais em vez de hierarquias profundas de herança.[cite: 8]

---

## ADR-003 — Centralização Temporal via Action Time System[cite: 8]
**Data:** 19/08/2026[cite: 1, 8]  
**Status:** ATIVA[cite: 8]

### Contexto
O GDD especifica um *Action Time System*, no qual o tempo avança primariamente quando o jogador executa ações intencionais (coleta, viagem, crafting, descanso).[cite: 1, 8]

### Decisão
O `TimeManager` avança o tempo de forma discreta através da execução de instâncias de `GameAction` coordenadas pelo `ActionSystem`.[cite: 1, 6]

---

## ADR-004 — Busca Agnóstica e Polimórfica de Componentes[cite: 1]
**Data:** 19/08/2026[cite: 1, 8]  
**Status:** ATIVA[cite: 8]

### Contexto
Componentes acessados por sistemas centrais (como o `ActionSystem` acessando o `SurvivalComponent`) podem possuir nomes de nó variados na árvore de cena ou serem instanciados dinamicamente em testes.[cite: 1]

### Decisão
Sistemas de serviços não devem depender estritamente de Strings de nome de nós (`get_node("SurvivalComponent")`). Devem utilizar iteradores e verificações por tipo de classe (`child is SurvivalComponent`) como fallback resiliente.[cite: 1]

---

# DECISÕES EM AVALIAÇÃO / PROPOSTAS

## ADR-005 — Versionamento e Migração de Saves[cite: 8]
**Data:** 19/08/2026[cite: 1, 8]  
**Status:** PROPOSTA[cite: 8]

### Contexto
O `SaveManager` legado salva dicionários de estado sem gravar a versão da estrutura do Save.[cite: 1, 8]

### Decisão Proposta
Inserir a chave `save_version` em todos os arquivos de save e criar pipeline de migração dentro de `SaveManager`.[cite: 1, 8]

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
