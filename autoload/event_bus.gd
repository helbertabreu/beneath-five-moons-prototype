extends Node
## Barramento central de sinais desacoplados para o projeto Beneath Five Moons.
##
## Instanciado automaticamente como Autoload global (Singleton).
## Permite a comunicação assíncrona entre sistemas (Tempo, Sobrevivência,
## Combate, Economia e Interface) sem acoplamento direto de referências.

# --- SINAIS TEMPORAIS E AMBIENTAIS ---
signal time_advanced(minutes: int)
signal day_started(day: int)
signal day_changed(day: int)
signal season_changed(season: String)
signal weather_changed(weather: String)

# --- SINAIS DE JOGADOR E SOBREVIVÊNCIA ---
signal player_died(player_id: String)
signal survival_stats_updated(hunger: float, energy: float, fatigue: float)

# --- SINAIS DE RECURSOS E ITENS ---
signal resource_depleted(resource_id: String)
signal resource_regenerated(resource_id: String)
signal item_obtained(item_id: String, amount: int)

# --- SINAIS DE COMBATE E MONSTROS ---
signal monster_killed(monster_id: String)

# --- SINAIS DE ECONOMIA E REPUTAÇÃO ---
signal reputation_changed(target_id: String, value: int)
signal profession_level_up(profession_id: String, level: int)
signal quest_completed(quest_id: String)
signal government_changed(village_id: String)

# --- SINAIS DE UI E FEEDBACK VISUAL ---
signal floating_text_requested(text: String, position: Vector2, color: Color)
signal action_executed(action_id: String, time_cost: int)
signal action_failed(action_id: String, reason: String)
