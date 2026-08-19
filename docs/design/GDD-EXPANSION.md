# Beneath Five Moons — Game Design Document (GDD)
## Documento de Expansão

**Versão:** 1.0.0  
**Status:** Draft de produção / Expansão  
**Engine:** Godot 4.x  
**Plataforma inicial:** PC  
**Gênero:** RPG Sandbox 2D, Mundo Aberto, Survival Leve, Simulação Social, Economia Dinâmica, Multiplayer

---

## 1. Visão da Expansão

A expansão transforma *Beneath Five Moons* de um RPG Sandbox centrado em sobrevivência, profissões, economia local e governança de vilarejo em um **Sandbox social, econômico, político e territorial persistente**.

O princípio central permanece:

> **O jogador não apenas vive no mundo. O mundo reage ao que o jogador faz.**

A expansão amplia os sistemas originalmente previstos como pós-MVP: economia global, mercado negro, leilões, PvP, guerras territoriais, religiões completas, domínio de cidades, construção avançada, novas profissões, novos biomas, novos continentes, sistema político, grandes eventos e Sandbox sem objetivo final.

---

# 2. Pilares

1. Mundo persistente e reativo.
2. Liberdade de desenvolvimento do personagem.
3. Cooperação entre jogadores.
4. Economia dinâmica.
5. Role Play acima do combate.
6. Política emergente.
7. Consequências permanentes.
8. Sociedade simulada.
9. Conflitos territoriais.
10. Sandbox sem encerramento obrigatório.

---

# 3. Mundo Expandido

```text
Mundo
├── Continentes
│   ├── Regiões
│   │   ├── Territórios
│   │   │   ├── Cidades
│   │   │   ├── Vilarejos
│   │   │   ├── Outposts
│   │   │   └── Áreas Selvagens
│   │   └── Recursos Naturais
│   └── Fronteiras
└── Setor Escuro
```

O mundo deverá manter ciclo dia/noite, quatro estações, clima, recursos regeneráveis/degradáveis, eventos naturais e mundo persistente.

---

# 4. Cidades Completas

Cada cidade deverá possuir:

- população;
- bairros;
- comércio;
- governo;
- religião;
- segurança;
- infraestrutura;
- produção;
- impostos;
- facções;
- mercado;
- conflitos;
- NPCs;
- propriedades;
- serviços;
- muralhas;
- guarnição;
- relações diplomáticas.

## 4.1 Distritos

```text
CITY
├── Government District
├── Residential District
├── Commercial District
├── Industrial District
├── Religious District
├── Military District
├── Agricultural District
├── Port / Transport
└── Slums / Fringe
```

Nem todas as cidades precisam possuir todos os distritos.

---

# 5. População e NPCs

A expansão deverá suportar dezenas de NPCs únicos por cidade, além de população simulada abstratamente.

Categorias:

| Categoria | Função |
|---|---|
| Farmer | Produção de alimentos |
| Miner | Recursos |
| Blacksmith | Equipamentos |
| Merchant | Comércio |
| Guard | Segurança |
| Soldier | Guerra |
| Priest | Religião |
| Scholar | Conhecimento |
| Doctor | Saúde |
| Fisher | Pesca |
| Artisan | Produção especializada |
| Politician | Governo |
| Noble | Poder econômico/político |
| Worker | Serviços |
| Criminal | Mercado ilegal |

Cada NPC importante poderá possuir:

- identidade;
- profissão;
- idade;
- personalidade;
- objetivos;
- necessidades;
- relacionamentos;
- religião;
- reputação;
- riqueza;
- residência;
- rotina;
- opiniões políticas;
- relações familiares;
- histórico.

---

# 6. Relacionamentos

Estados-base:

`HATE`, `NEUTRAL`, `LIKE`, `LOVE`

Estados avançados:

`TRUST`, `RESPECT`, `FEAR`, `JEALOUSY`, `LOYALTY`

Cada relação deverá ser multidimensional.

Exemplo:

```text
LIKE = 80
TRUST = 30
RESPECT = 90
FEAR = 5
LOYALTY = 75
```

---

# 7. Casamento e Família

Fluxo:

```text
Known
→ Friend
→ Close Friend
→ Romance
→ Partner
→ Engaged
→ Married
```

Requisitos podem envolver:

- relacionamento;
- confiança;
- compatibilidade;
- reputação;
- aprovação familiar;
- residência;
- estabilidade econômica;
- eventos sociais.

O casamento poderá fornecer:

- residência compartilhada;
- armazenamento compartilhado;
- benefícios sociais;
- propriedade conjunta;
- contratos;
- participação política;
- herança.

No multiplayer, dois jogadores poderão estabelecer uma união social dentro do mundo.

---

# 8. Religião

Estrutura:

```text
Religion
├── Doctrine
├── Values
├── Rituals
├── Holy Sites
├── Clergy
├── Followers
├── Political Influence
├── Economic Influence
└── Relations
```

Cada religião possuirá:

- doutrina;
- valores;
- rituais;
- tolerância;
- riqueza;
- influência;
- seguidores;
- locais sagrados.

Conflitos:

```text
Dispute
→ Social Conflict
→ Severe Conflict
```

Possíveis consequências:

- boicotes;
- protestos;
- perda de reputação;
- violência;
- migração;
- conflitos políticos;
- guerras.

---

# 9. Governança

A governança expande o sistema do MVP para:

- conselho;
- partidos;
- leis;
- orçamento;
- diplomacia;
- eleições;
- cargos;
- administração urbana;
- política externa.

Hierarquia:

```text
Vilarejo
→ Cidade
→ Região
→ Reino/Estado
→ Aliança/Confederação
```

Cargos:

```text
Citizen
→ Representative
→ Council Member
→ Mayor
→ Governor
→ Regional Leader
```

Leis possíveis:

- Tax Law;
- Trade Law;
- Property Law;
- Immigration Law;
- Military Law;
- Religious Law;
- Environmental Law;
- Crime Law.

---

# 10. Guerra

## 10.1 Causas

- território;
- recursos;
- religião;
- política;
- vingança;
- comércio;
- independência;
- eventos narrativos.

## 10.2 Estados

```text
Peace
→ Tension
→ Hostility
→ Mobilization
→ War
→ Occupation
→ Treaty
→ Peace
```

Cada território possui:

- Owner;
- Claim;
- Military Power;
- Defense;
- Supply;
- Morale;
- Population;
- Infrastructure.

A guerra deverá depender de economia e logística.

```text
Profissões
→ Economia
→ Indústria
→ Logística
→ Guerra
```

---

# 11. Inimigos

Famílias propostas para a expansão:

### Fauna
- Wolf
- Bear
- Boar
- Giant Spider
- Crocodile
- Dire Wolf

### Monstros
- Goblin
- Orc
- Troll
- Ghoul
- Wraith
- Harpy
- Basilisk

### Criaturas mágicas
- Elemental
- Forest Guardian
- Moon Beast
- Shadow Beast

### Humanoides
- Bandit
- Raider
- Cultist
- Mercenary
- Enemy Soldier

### Bosses
- Ancient Guardian
- Warlord
- Religious Champion
- Dark Sector Creature

**Observação:** essa lista é proposta de expansão e não deve ser tratada como roster canônico já fechado.

---

# 12. Árvore Completa de Habilidades

Árvores:

```text
Character
├── Survival
├── Combat
├── Stealth
├── Exploration
├── Social
├── Leadership
├── Crafting
├── Economy
└── Religion
```

Estrutura:

```text
Core
→ Branch
→ Advanced
→ Mastery
```

O sistema deverá preservar nível máximo 100, pontos de atributos, especializações e habilidades.

---

# 13. Profissões

Profissões do MVP:

- Mineração;
- Ferraria;
- Alquimia;
- Culinária;
- Pescaria;
- Herborismo.

Profissões previstas/expandidas:

- Couraria;
- Esfolamento;
- Joalheria;
- Carpintaria;
- Engenharia;
- Agricultura;
- Construção;
- Tecelagem;
- Encantamento;
- Comércio;
- Medicina;
- Navegação;
- Arquitetura;
- Diplomacia;
- Estratégia Militar.

Especializações permanecem limitadas a duas por personagem.

---

# 14. Economia Dinâmica

Hierarquia:

```text
Local Market
→ Regional Market
→ Global Market
```

Variáveis:

- estoque;
- demanda;
- produção;
- consumo;
- importação;
- exportação;
- preço;
- inflação;
- transporte;
- risco;
- impostos;
- disponibilidade.

Sistemas:

- comércio entre cidades;
- caravanas;
- exportação;
- importação;
- mercado negro;
- leilões;
- contratos;
- escassez regional;
- Player Shops.

---

# 15. Clima Avançado

Variáveis:

```text
Temperature
Humidity
Wind
Pressure
Cloud Cover
Precipitation
Visibility
Season
Region
```

Eventos:

- seca;
- nevasca;
- onda de calor;
- tempestade severa;
- tempestade elétrica;
- geada;
- tornado/evento de vento extremo;
- neblina densa;
- enchentes;
- incêndios;
- deslizamentos.

O clima deverá afetar economia, deslocamento, agricultura, recursos, combate e infraestrutura.

Exemplo:

```text
Heavy Rain
→ River Level ↑
→ Flood
→ Road Damage
→ Travel Time ↑
→ Trade ↓
→ Food Price ↑
→ Approval ↓
```

---

# 16. Multiplayer

Primeira etapa:

**Cooperative PvE**

Etapa posterior:

**PvP territorial**

Jogadores poderão:

- explorar;
- coletar;
- construir;
- produzir;
- comerciar;
- governar;
- combater;
- defender cidades;
- administrar propriedades.

O servidor será autoridade sobre o estado compartilhado.

---

# 17. Endless Sandbox

O Endless Sandbox não deverá ser um modo isolado. Será a continuação do mundo após a conclusão do conteúdo principal.

O mundo continuará gerando:

- governos;
- guerras;
- cidades;
- famílias;
- mercados;
- alianças;
- crises;
- eventos;
- mudanças climáticas;
- conflitos religiosos.

**Não existe Game Over convencional.**

---

# 18. Princípio de Design Sistêmico

Os sistemas devem interagir.

```text
Clima
→ Agricultura
→ Alimentos
→ Mercado
→ Preços
→ Aprovação
→ Política
→ Leis
→ Comércio
→ Diplomacia
→ Guerra
→ Destruição
→ Reconstrução
→ Profissões
→ Economia
→ Novo equilíbrio mundial
```

---

# 19. Limites do Documento

Os seguintes pontos ainda exigem definição específica antes de produção:

- número máximo de jogadores simultâneos;
- mapa final;
- lista definitiva de religiões;
- roster definitivo de inimigos;
- fórmula econômica final;
- quantidade final de cidades;
- regras finais de PvP;
- regras de herança;
- infraestrutura de servidor;
- conteúdo narrativo completo.

