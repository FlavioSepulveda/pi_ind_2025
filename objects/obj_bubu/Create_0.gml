/// @desc Variáveis de Controle
// Variáveis de física
grav = 0.3;      // Valor da Gravidade (aceleração para baixo)
max_vsp = 8;     // Velocidade vertical máxima de queda
walk_spd = 4;    // Velocidade de movimento horizontal
jump_force = -8; // Força de pulo (valor negativo, pois y aumenta para baixo)

// Variáveis de movimento
hsp = 0; // Velocidade horizontal atual (horizontal speed)
vsp = 0; // Velocidade vertical atual (vertical speed)

// Variáveis de controle de input
key_left = 0;
key_right = 0;
key_jump = 0;/// @desc Variáveis de Controles de Ritmo, Movimento e Estamina

// --- VARIÁVEIS DE FÍSICA BÁSICA ---
grav = 0.3;      // Gravidade padrão
max_vsp = 8;     // Velocidade vertical máxima de queda
vsp = 0;         // Velocidade vertical atual
hsp = 0;         // Velocidade horizontal atual

// --- VARIÁVEIS DE RITMO (Definidas pelo GDD) ---
spd_base = 4;    // Velocidade de "Andar Constante" 
spd_boost = spd_base * 1.15; // Velocidade de "Ritmo Firme" (115% do padrão) [cite: 44, 57]
spd_sprint = spd_base * 1.50; // Velocidade de "Sprint" (150% do padrão) 
spd_exhaust = spd_base * 0.10; // Velocidade de "Exaustão" (10% do padrão) 

jump_force = -8; // Força de pulo
can_jump = true; // Flag para controlar se pode pular

// --- VARIÁVEIS DE ESTAMINA (FOCO) ---
stamina_max = 100;
stamina = stamina_max; 
stamina_min_recovery = 10; 

// --- INICIALIZAÇÃO DE TAXAS GARANTIDAS ---

// --- CÓDIGO DE CRIAÇÃO PARA DEFINIÇÃO DE TAXAS (Executa ANTES do Evento Create) ---

var _fps_rate = 60; 
var _drain_per_sec = 10; 
var _regen_per_sec = 5;  

// Definição das taxas por frame (usando 'self.' para clareza)
self.stamina_drain_sprint = (_drain_per_sec / _fps_rate);
self.stamina_regen_constancy = (_regen_per_sec / _fps_rate);
self.stamina_drain_walljump = (5 / _fps_rate);

// Constante de tempo
self.constancy_time_req = 1.5 * _fps_rate;