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

// 1. Variável local para cálculo (SÓ EXISTE NO EVENTO CREATE)
var _fps_rate = 60; 
var _drain_per_sec = 10; 
var _regen_per_sec = 5;  

// 2. FORÇAR A DECLARAÇÃO COMO VARIÁVEL DE INSTÂNCIA USANDO OBJETO.VARIÁVEL
// O GML agora é forçado a declarar estas como variáveis de INSTÂNCIA.
obj_bubu.stamina_drain_sprint = 0;     
obj_bubu.stamina_regen_constancy = 0;      
obj_bubu.stamina_drain_walljump = 0;     

// 3. Atribuição dos valores calculados (SEM USAR OBJ_BUBU. OU VAR)
stamina_drain_sprint = (_drain_per_sec / _fps_rate);
stamina_regen_constancy = (_regen_per_sec / _fps_rate);
stamina_drain_walljump = (5 / _fps_rate); 

// Outras variáveis dependentes
constancy_time_req = 1.5 * _fps_rate;

// --- VARIÁVEIS DE ESTADO ---
is_exhausted = false; // O coelho está no "cochilo" (Exaustão)? [cite: 29]
is_in_constancy = false; // Está no ritmo constante para regenerar?
constancy_timer = 0;
constancy_time_req = 1.5 * fps; // 1.5 segundos de constância para ganhar o boost/regen