# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Atualizado após a correção dos bugs BUG-002 e BUG-003.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons
- **Versão atual:** 0.1.2-alpha
- **Versão da Godot:** Godot 4.x (4.7 GL Compatibility)
- **Plataformas alvo:** PC (Windows, Linux, macOS)
- **Gênero:** RPG Sandbox 2D / Survival Leve / Simulação Social
- **Perspectiva:** 2D Isométrica
- **Status geral:** PROTÓTIPO FUNCIONAL / ESTÁVEL
- **Última atualização:** 17/08/2026

---

## 2. ESTADO DA SPRINT

- **Sprint atual:** Sprint 1 — Ajuste de Reputação, Fixes de Save/UI e Base de Combate
- **Status:** EM ANDAMENTO

### Progresso
- [x] TASK-001: Refatoração do `ReputationManager` (0 - 10.000) [CONCLUÍDO].
- [x] BUG-002: Corrigida trava de movimentação e UI ao carregar o jogo em `save_manager.gd` [CONCLUÍDO].
- [x] BUG-003: Removido vazamento de textos no Minimapa via mascara de visibilidade em `minimap.gd` e `hud_controller.gd` [CONCLUÍDO].
- [ ] TASK-002: Isolar atalhos de debug do `PlayerController`.
- [ ] TASK-003: Criar `HealthComponent` e infraestrutura de Dano para Combate.

---

## 3. BUGS CONHECIDOS

| ID | Bug | Severidade | Localização | Status |
|---|---|---|---|---|
| BUG-001 | Teclas de debug ativas no `PlayerController` em jogo normal | BAIXA | `src/entities/player/player_controller.gd` | TODO |
| BUG-002 | Personagem não se movimenta e não abre UI após efetuar LOAD | ALTA | `autoload/save_manager.gd` | **FIXED** |
| BUG-003 | Textos flutuantes e rótulos do mapa vazando para o Minimapa | MÉDIA | `src/ui/minimap.gd` | **FIXED** |
---

## REGRA PARA O GEMINI

Ao trabalhar neste projeto:

1. Leia este arquivo antes de assumir o estado do projeto.
2. Não invente informações ausentes.
3. Não considere uma tarefa concluída sem validação.
4. Atualize este arquivo quando uma alteração importante modificar o estado do projeto.
5. Preserve o histórico das decisões importantes em `TECHNICAL_DECISIONS.md`.
