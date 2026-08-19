class_name State
extends Node
## Classe base abstrata para todos os estados da Finite State Machine (FSM).
##
## Gerencia o ciclo de vida de um estado individual (entrada, saída, atualização e física).

## Referência estática para a EnemyStateMachine que gerencia este estado.
var state_machine: StateMachine = null

## Método chamado imediatamente ao transicionar para este estado.
## [param msg] Dicionário opcional para passar parâmetros adicionais de transição.
func enter(_msg: Dictionary = {}) -> void:
	pass

## Método chamado imediatamente antes de sair deste estado.
func exit() -> void:
	pass

## Processamento de quadro virtual (substitui o _process do Node).
func update(_delta: float) -> void:
	pass

## Processamento de física virtual (substitui o _physics_process do Node).
func physics_update(_delta: float) -> void:
	pass
