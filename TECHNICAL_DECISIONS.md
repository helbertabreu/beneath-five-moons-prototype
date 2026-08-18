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

# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais do projeto BeneathFiveMoons_Prototype.

---

# TECHNICAL_DECISIONS.md

> Registro permanente das decisões técnicas e arquiteturais do projeto Beneath Five Moons.

---

# DECISÕES ATIVAS

## ADR-001 — Composição Modular por Componentes no Player

**Data:** 17/08/2026  
**Status:** ATIVA

### Contexto
Sistemas de Sobrevivência, Inventário e Profissão precisam coexistir no personagem principal mantendo responsabilidades bem separadas e desacopladas.

### Decisão
Manter a arquitetura de componentes em nós filhos (`SurvivalComponent`, `InventoryComponent`, `ProfessionComponent`), onde o `PlayerController` serve apenas como agregador de entrada e comunicação.

### Consequências
- Alta facilidade de teste e baixa propagação de erros.
- Permite reutilizar componentes semelhantes em outras entidades do mundo.

---

## ADR-002 — Action Time System (ATS) Desacoplado da Física

**Data:** 17/08/2026  
**Status:** ATIVA

### Contexto
A passagem do tempo e o desgaste físico (Fome/Energia/Fadiga) devem ocorrer pelo volume de trabalho ativo realizado pelo jogador, e não pelo tempo real decorrido na tela.

### Decisão
O `TimeManager` atua como relógio central e o tempo avança exclusivamente quando o jogador executa ações ativas (minerar, fabricar, viajar). O movimento simples no mapa não consome relógio.

### Consequências
- Experiência tática onde o jogador planeja o consumo do tempo do dia.

---

## ADR-003 — Persistência JSON Centralizada por SubSistemas

**Data:** 17/08/2026  
**Status:** ATIVA

### Decisão
O `SaveManager` salva todas as seções do estado do jogo no arquivo `user://savegame.json`, delegando a cada componente a responsabilidade de ler e gerar seu próprio dicionário de salvamento.

### Consequências
- Inspeção transparente dos dados salvos durante o desenvolvimento.

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
