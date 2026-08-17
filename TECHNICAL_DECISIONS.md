# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais importantes do projeto.
> O objetivo é evitar que decisões previamente aprovadas sejam alteradas ou esquecidas sem justificativa.

---

# COMO REGISTRAR UMA DECISÃO

Para cada decisão importante, utilize:

```text
ID:
Data:
Título:
Status:

Contexto:
Problema:

Alternativas consideradas:

Decisão:

Motivo:

Consequências positivas:

Trade-offs / consequências negativas:

Impactos no projeto:

Arquivos ou sistemas afetados:

Plano de migração, se aplicável:

Responsável pela decisão:
```

---

# STATUS POSSÍVEIS

- PROPOSTA
- ATIVA
- SUPERADA
- CANCELADA

---

# DECISÕES ATIVAS

## ADR-001 — [PREENCHER]

**Data:** [PREENCHER]

**Status:** PROPOSTA / ATIVA

### Contexto

[PREENCHER]

### Problema

[PREENCHER]

### Alternativas consideradas

1. [PREENCHER]
2. [PREENCHER]
3. [PREENCHER]

### Decisão

[PREENCHER]

### Motivo

[PREENCHER]

### Consequências positivas

- [PREENCHER]

### Trade-offs

- [PREENCHER]

### Sistemas afetados

- [PREENCHER]

---

# DECISÕES ARQUITETURAIS

## ADR-002 — Arquitetura de Scenes e Components

**Status:** PROPOSTA

### Contexto

O projeto precisa manter sistemas modulares e reutilizáveis.

### Decisão

Priorizar composição por Nodes/Components, Scenes reutilizáveis, Resources e Signals antes de criar hierarquias profundas de herança.

### Motivo

Reduzir acoplamento e facilitar manutenção, testes e evolução do projeto.

### Consequências

O projeto deve evitar scripts monolíticos e heranças profundas quando composição resolver o problema.

---

## ADR-003 — Uso de Autoloads

**Status:** PROPOSTA

### Decisão

Autoloads serão utilizados apenas para sistemas realmente globais e persistentes entre Scenes.

### Exemplos

- GameManager
- SaveManager
- AudioManager
- SettingsManager
- SceneManager

### Regra

Não transformar componentes de gameplay comuns em Autoloads.

---

## ADR-004 — Dados Data-Driven

**Status:** PROPOSTA

### Decisão

Quando apropriado, dados configuráveis de gameplay deverão ser separados da lógica utilizando Resources.

### Exemplos

- Items
- Weapons
- Enemies
- Characters
- Skills
- Quests
- Loot Tables

### Motivo

Facilitar balanceamento, manutenção e expansão.

---

## ADR-005 — Compatibilidade Godot 4

**Status:** ATIVA

### Decisão

O projeto será desenvolvido utilizando APIs, sintaxe e práticas compatíveis com Godot 4.x.

### Regra

Não introduzir código ou APIs específicas de Godot 3.x.

---

# DECISÕES DE GAMEPLAY

Registre aqui decisões que afetem diretamente o comportamento do jogo.

## ADR-006 — [PREENCHER]

**Data:** [PREENCHER]

**Status:** PROPOSTA / ATIVA

### Contexto

[PREENCHER]

### Decisão

[PREENCHER]

### Motivo

[PREENCHER]

### Impacto no gameplay

[PREENCHER]

---

# DECISÕES DE PERFORMANCE

## ADR-007 — [PREENCHER]

**Data:** [PREENCHER]

**Status:** PROPOSTA / ATIVA

### Problema

[PREENCHER]

### Decisão

[PREENCHER]

### Motivo

[PREENCHER]

### Trade-offs

[PREENCHER]

---

# DECISÕES SUPERADAS

Quando uma decisão deixar de ser válida, NÃO apague o registro.

Mova ou marque como `SUPERADA`.

## ADR-[ID]

**Decisão original:** [PREENCHER]

**Data original:** [PREENCHER]

**Status:** SUPERADA

**Substituída por:** ADR-[ID]

**Motivo da alteração:** [PREENCHER]

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
