# PROJECT_STATE.md

> Documento de estado atual do projeto Godot 4.
> Atualizado após a conclusão da Sprint 1 com testes automatizados.

---

## 1. IDENTIFICAÇÃO DO PROJETO

- **Nome do projeto:** Beneath Five Moons
- **Versão atual:** 0.1.6-alpha
- **Versão da Godot:** Godot 4.x (4.7 GL Compatibility)
- **Status geral:** PROTÓTIPO FUNCIONAL / INFRAESTRUTURA TESTADA
- **Última atualização:** 17/08/2026

---

## 2. ESTADO DA SPRINT

- **Sprint atual:** Sprint 1 — Reputação, Atalhos, ATS, Combate e Testes Automatizados
- **Status:** CONCLUÍDA

### Progresso
- [x] TASK-001: Refatoração do `ReputationManager` (0 - 10.000) [CONCLUÍDO].
- [x] BUG-003: Removida poluição de texto no Minimapa [CONCLUÍDO].
- [x] TASK-002: Padronização de atalhos (E, I/TAB, J, C, F5, F9) e isolamento de comandos de debug [CONCLUÍDO].
- [x] BUG-004: Corrigido laço de Fast-Forward no `TimeManager` para múltiplos dias [CONCLUÍDO].
- [x] TASK-003: Implementados `HealthComponent`, `HurtboxComponent` e `HitboxComponent` [CONCLUÍDO].
- [x] TASK-004: Implementada a Suíte de Testes Automatizados da Sprint 1 em `tests/test_sprint1_combat_and_systems.gd` [CONCLUÍDO].
- [ ] BUG-002: Investigar trava de movimentação/UI após carregar o jogo (PAUSADO / BACKLOG).
---

## REGRA PARA O GEMINI

Ao trabalhar neste projeto:

1. Leia este arquivo antes de assumir o estado do projeto.
2. Não invente informações ausentes.
3. Não considere uma tarefa concluída sem validação.
4. Atualize este arquivo quando uma alteração importante modificar o estado do projeto.
5. Preserve o histórico das decisões importantes em `TECHNICAL_DECISIONS.md`.
