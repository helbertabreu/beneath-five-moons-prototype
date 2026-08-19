# Beneath Five Moons — Balance Database
## Planilha de Balanceamento em Markdown

**Versão:** 1.0.0  
**Status:** Base inicial de balanceamento  
**Fonte:** GDD existente + parâmetros propostos para expansão  
**Observação:** valores marcados como `TBD` ou `PLACEHOLDER` não são requisitos definitivos.

---

# 1. Controle de Versão

| Versão | Data | Autor | Alterações |
|---|---|---|---|
| 1.0.0 | 2026-08-18 | Equipe de Desenvolvimento | Base inicial para expansão |

---

# 2. Itens

| ID | Nome | Tipo | Custo Base | Atributo | Multiplicador Resource | Status |
|---|---|---|---:|---|---:|---|
| ITEM-001 | Minério de Cobre | Material | 10 | Refinável | 1.00 | MVP |
| ITEM-002 | Minério de Ferro | Material | 20 | Refinável | 1.00 | MVP |
| ITEM-003 | Lingote de Cobre | Material Refinado | 35 | Crafting | 1.00 | MVP |
| ITEM-004 | Lingote de Ferro | Material Refinado | 70 | Crafting | 1.00 | MVP |
| ITEM-005 | Cobalto | Material | 120 | Raro | 1.00 | MVP/Expand |
| ITEM-006 | Mithril | Material | 500 | Muito Raro | 1.00 | MVP/Expand |
| ITEM-007 | Adamantita | Material | 750 | Muito Raro | 1.00 | MVP/Expand |
| ITEM-008 | Peixe Comum | Food | 12 | Fome | 1.00 | MVP |
| ITEM-009 | Erva Comum | Alchemy | 8 | Ingrediente | 1.00 | MVP |
| ITEM-010 | Lótus do Setor Escuro | Alchemy | 300 | Ingrediente Raro | 1.00 | Expand |
| ITEM-011 | Carvão | Fuel | 15 | Forja | 1.00 | MVP |
| ITEM-012 | Poção de Energia | Consumable | 80 | +30 Energia | 1.00 | MVP |

---

# 3. Reputação

O GDD define reputação local de 0 a 10.000.

| Pontuação | Rank | Desconto | Multiplicador |
|---:|---|---:|---:|
| 0–999 | Desconhecido | 0% | 1.00 |
| 1.000–2.999 | Reconhecido | 5% | 0.95 |
| 3.000–5.999 | Respeitado | 10% | 0.90 |
| 6.000–8.999 | Ilustre | 15% | 0.85 |
| 9.000–10.000 | Elegível (Líder) | 20% | 0.80 |

---

# 4. Monstros

| ID | Nome | HP | Dano | Velocidade | XP | Drops | Status |
|---|---|---:|---:|---:|---:|---|---|
| ENM-001 | Lobo Esfomeado | 40 | 12 | 110 | TBD | Carne, Couro | MVP |
| ENM-002 | Salteador da Noite | 60 | 15 | 120 | TBD | Moedas, Equipamento | MVP |
| ENM-003 | Goblin | 80 | 18 | 95 | TBD | Moedas, Material | Expand |
| ENM-004 | Orc | 180 | 30 | 70 | TBD | Arma, Couro | Expand |
| ENM-005 | Troll | 450 | 55 | 45 | TBD | Material Raro | Expand |
| ENM-006 | Wraith | 250 | 40 | 100 | TBD | Essência Sombria | Expand |
| ENM-007 | Basilisk | 700 | 65 | 55 | TBD | Veneno, Escama | Expand |
| ENM-008 | Warlord | 2.500 | 100 | 65 | TBD | Artefato | Boss |

---

# 5. Balanceamento de Drop

## 5.1 Raridade

| Raridade | Chance Base | Multiplicador de Valor |
|---|---:|---:|
| Common | 60.00% | 1.00 |
| Uncommon | 25.00% | 1.50 |
| Rare | 10.00% | 3.00 |
| Epic | 4.00% | 7.50 |
| Legendary | 1.00% | 20.00 |

## 5.2 Drop Tables

| Drop Table ID | Inimigo/Origem | Item | Quantidade Min | Quantidade Max | Chance | Peso | Condição |
|---|---|---|---:|---:|---:|---:|---|
| DROP-WOLF-01 | ENM-001 | Carne | 1 | 3 | 75% | 75 | Sempre |
| DROP-WOLF-02 | ENM-001 | Couro | 1 | 2 | 40% | 40 | Sempre |
| DROP-WOLF-03 | ENM-001 | Presa | 1 | 2 | 15% | 15 | Sempre |
| DROP-BANDIT-01 | ENM-002 | Gold | 5 | 20 | 80% | 80 | Sempre |
| DROP-BANDIT-02 | ENM-002 | Consumable | 1 | 1 | 25% | 25 | Sempre |
| DROP-BANDIT-03 | ENM-002 | Equipment | 1 | 1 | 8% | 8 | Elite/variante |
| DROP-GOBLIN-01 | ENM-003 | Material | 1 | 4 | 70% | 70 | Sempre |
| DROP-GOBLIN-02 | ENM-003 | Gold | 5 | 30 | 45% | 45 | Sempre |
| DROP-TROLL-01 | ENM-005 | Rare Material | 1 | 2 | 20% | 20 | Sempre |
| DROP-BOSS-01 | ENM-008 | Epic Item | 1 | 1 | 25% | 25 | Boss |
| DROP-BOSS-02 | ENM-008 | Legendary Item | 1 | 1 | 5% | 5 | Boss |

**Nota:** o modelo final de `DropTableData` deverá definir se as chances são independentes, mutuamente exclusivas ou ponderadas.

---

# 6. Economia Básica

| Parâmetro | Valor Inicial | Limite Mínimo | Limite Máximo | Status |
|---|---:|---:|---:|---|
| Base Price Multiplier | 1.00 | 0.25 | 3.00 | Proposto |
| Reputation Multiplier | 1.00 | 0.80 | 1.00 | GDD |
| Supply Modifier | 1.00 | 0.30 | 2.50 | Proposto |
| Demand Modifier | 1.00 | 0.50 | 3.00 | Proposto |
| Tax Rate | 0% | 0% | 25% | GDD |
| Transport Modifier | 1.00 | 0.50 | 3.00 | Proposto |
| Event Modifier | 1.00 | 0.25 | 4.00 | Proposto |

---

# 7. Fórmula de Preço

Fórmula preliminar presente no GDD:

```text
Preço Final =
Preço Base
× Multiplicador de Reputação
× (1 + (Demanda - Estoque) / Estoque Mínimo)
```

**Estado:** `NEEDS VALIDATION`

A fórmula deverá ser testada contra valores extremos antes de ser implementada como regra definitiva.

---

# 8. Economia de Mercado

| Mercado | Escopo | Atualização | Fonte de Dados |
|---|---|---|---|
| Local | Cidade/Vilarejo | Diário | Estoque + Demanda |
| Regional | Região | Diário/Semanal | Produção + Comércio |
| Global | Mundo | Semanal | Comércio + Logística |
| Black Market | Local/Regional | Diário | Risco + Oferta |
| Auction | Regional/Global | Evento | Lances |

---

# 9. Classes de Herói

O GDD original **não utiliza classes fixas**. A identidade do personagem é definida pelas ações do jogador.

Portanto, esta tabela é uma camada futura de **arquétipos derivados**, e não classes obrigatórias.

| Arquétipo | HP Base | Mana/Energia Base | Atributo Primário | Modificadores de Status | Status |
|---|---:|---:|---|---|---|
| Warrior | 120 | 100 | Força | +10% HP, +5% Defesa | PLACEHOLDER |
| Ranger | 100 | 110 | Agilidade | +10% Precisão, +5% Velocidade | PLACEHOLDER |
| Alchemist | 90 | 120 | Inteligência | +10% Alquimia, +5% Eficiência | PLACEHOLDER |
| Crafter | 100 | 110 | Técnica | +10% Crafting, +5% Durabilidade | PLACEHOLDER |
| Leader | 105 | 110 | Influência | +10% Reputação, +5% Aprovação | PLACEHOLDER |

**Decisão recomendada:** não implementar estes arquétipos como `Class` rígida até que o design confirme que eles não conflitam com a filosofia de classes emergentes do GDD.

---

# 10. Profissões

| Profissão | Nível Máximo | Especializações | Foco |
|---|---:|---:|---|
| Mineração | 100 | 2 | Extração |
| Ferraria | 100 | 2 | Refinamento/Forja |
| Alquimia | 100 | 2 | Poções/Processamento |
| Culinária | 100 | 2 | Alimentos/Buffs |
| Pescaria | 100 | 2 | Recursos aquáticos |
| Herborismo | 100 | 2 | Plantas/Ingredientes |
| Couraria | 100 | 2 | Couro |
| Esfolamento | 100 | 2 | Materiais animais |
| Joalheria | 100 | 2 | Gemas |
| Agricultura | 100 | 2 | Alimentos |
| Carpintaria | 100 | 2 | Madeira |
| Engenharia | 100 | 2 | Infraestrutura |
| Medicina | 100 | 2 | Cura |
| Comércio | 100 | 2 | Mercado |
| Navegação | 100 | 2 | Transporte |
| Diplomacia | 100 | 2 | Relações |
| Estratégia Militar | 100 | 2 | Guerra |

---

# 11. Habilidades

| Árvore | Exemplos de Nós | Mastery |
|---|---|---|
| Survival | Fome, Energia, Resistência | Survival Master |
| Combat | Dano, Defesa, Crítico | Combat Master |
| Stealth | Furtividade, Roubo, Detecção | Shadow Master |
| Exploration | Navegação, Recursos, Mapas | Explorer Master |
| Social | Persuasão, Comércio, Relações | Social Master |
| Leadership | Governança, Impostos, Aprovação | Leadership Master |
| Crafting | Eficiência, Qualidade, Durabilidade | Craft Master |
| Economy | Mercado, Arbitragem, Comércio | Economy Master |
| Religion | Fé, Rituais, Influência | Faith Master |

---

# 12. Clima

| Variável | Escala | Efeito |
|---|---|---|
| Temperature | Configurável | Energia/Fome |
| Humidity | 0–100 | Chuva/Conforto |
| Wind | 0–100 | Precisão/Movimento |
| Pressure | Configurável | Previsão |
| Cloud Cover | 0–100 | Iluminação/Chuva |
| Precipitation | 0–100 | Lama/Recursos |
| Visibility | 0–100 | Detecção/Exploração |

---

# 13. Estações

| Estação | Duração | Efeito Principal |
|---|---:|---|
| Primavera | 7 dias | Regeneração vegetal |
| Verão | 7 dias | Calor/Frutos |
| Outono | 7 dias | Cogumelos/Migração |
| Inverno | 7 dias | Frio/Neve |

---

# 14. Sobrevivência

| Sistema | Base |
|---|---:|
| Energia Máxima | 100 |
| Fome Máxima | 100 |
| Ação de Coleta | -10 Energia |
| Viagem | -5 Fome |
| Combate | -3 Fome |
| Descanso 1h | +30 Energia |
| Madrugada | -20% Energia máxima no dia seguinte |
| Virar a noite | Desmaio + penalidade |

---

# 15. Governança

| Indicador | Escala | Efeito |
|---|---:|---|
| Prosperidade | 0–100% | Economia/População |
| Segurança | 0–100% | Crime/Proteção |
| Aprovação | 0–100% | Permanência no cargo |
| Imposto | 0–25% | Receita/Aprovação |
| Tesouro | Dinâmico | Obras/Guardas |

Regra do MVP:

```text
Approval < 20%
→ Emergency Vote
→ Loss of Governance
```

---

# 16. Guerra

| Variável | Escala | Uso |
|---|---|---|
| Military Power | 0+ | Poder militar |
| Defense | 0+ | Defesa territorial |
| Supply | 0–100% | Sustentação |
| Morale | 0–100% | Combate |
| Population | Dinâmico | Recrutamento |
| Infrastructure | 0–100% | Logística |

---

# 17. Performance Targets

| Métrica | Meta Inicial | Status |
|---|---:|---|
| NPCs simulados | 100+ | Teste |
| Players simultâneos | 50+ | TBD |
| Transações de mercado | 1000+ | Teste |
| Eventos simultâneos | 20+ | Teste |
| Recursos ativos | 100+ | Teste |

---

# 18. Convenções

- IDs em `UPPER_SNAKE_CASE`.
- Dados em `Resource`.
- Estado persistente separado de dados estáticos.
- Nenhum valor crítico deve ser hardcoded em scripts quando for balanceável.
- Valores experimentais devem ser marcados como `PLACEHOLDER` ou `TBD`.
- Fórmulas econômicas devem possuir testes de limite.
- Toda mudança de balanceamento deve gerar alteração de versão.
