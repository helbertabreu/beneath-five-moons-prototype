## 4. Refatoração: `autoload/event_bus.gd`
# Adição de sinais globais desacoplados para escuta do Action System[cite: 1, 6].

extends Node
## EventBus global para comunicação descentralizada entre sistemas.

# Sinais de Tempo e Ciclo
signal time_advanced(minutes: int)
signal day_started(day: int)
signal hour_changed(hour: int)

# Sinais de Sobrevivência
signal hunger_changed(current: float, max_val: float)
signal energy_changed(current: float, max_val: float)
signal hunger_state_changed(state_name: String)
signal fatigue_penalty_applied(penalty_percentage: float)
signal player_fainted()

# Sinais do Action System
signal action_executed(action_id: String, time_cost: int)
signal action_failed(action_id: String, reason: String)

# Sinais de Gameplay Geral
signal resource_depleted(resource_id: String)
signal item_obtained(item_id: String, amount: int)
# [cite: 1, 6]
