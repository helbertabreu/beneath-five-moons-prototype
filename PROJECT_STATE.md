# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Atualizado após a conclusão do Teste da TASK-001 e reporte de novos bugs.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons
- **Versão atual:** 0.1.1-alpha
- **Versão da Godot:** Godot 4.x (4.7 GL Compatibility)
- **Plataformas alvo:** PC (Windows, Linux, macOS)
- **Gênero:** RPG Sandbox 2D / Survival Leve / Simulação Social
- **Perspectiva:** 2D Isométrica
- **Status geral:** PROTÓTIPO FUNCIONAL / CORREÇÃO DE BUGS (QA)
- **Última atualização:** 17/08/2026

---

## 2. ESTADO DA SPRINT

- **Sprint atual:** Sprint 1 — Ajuste de Reputação, Fixes de Save/UI e Base de Combate
- **Status:** EM ANDAMENTO

### Progresso
- [x] TASK-001: Refatoração do `ReputationManager` e `FactionData` para a escala 0 - 10.000 (VALIDADO VIA TESTE).
- [ ] BUG-001: Isolar e organizar comandos de debug do `PlayerController`.
- [ ] BUG-002: Corrigir trava de movimentação e UI ao carregar o jogo (`save_manager.gd`).
- [ ] BUG-003: Corrigir visibilidade de textos e labels dentro da SubViewport do Minimapa (`minimap.gd`).
- [ ] TASK-003: Criar `HealthComponent` e infraestrutura de Dano para Combate.

---

## 3. BUGS CONHECIDOS

| ID | Bug | Severidade | Localização | Status |
|---|---|---|---|---|
| BUG-001 | Teclas de debug ativas no `PlayerController` em jogo normal | BAIXA | `src/entities/player/player_controller.gd` | TODO |
| BUG-002 | Personagem não se movimenta e não abre UI após efetuar LOAD | ALTA | `autoload/save_manager.gd` / `player_controller.gd` | TODO |
| BUG-003 | Textos flutuantes e rótulos do mapa vazando para o Minimapa | MÉDIA | `src/ui/minimap.gd` | TODO |
---

## REGRA PARA O GEMINI

Ao trabalhar neste projeto:

1. Leia este arquivo antes de assumir o estado do projeto.
2. Não invente informações ausentes.
3. Não considere uma tarefa concluída sem validação.
4. Atualize este arquivo quando uma alteração importante modificar o estado do projeto.
5. Preserve o histórico das decisões importantes em `TECHNICAL_DECISIONS.md`.
