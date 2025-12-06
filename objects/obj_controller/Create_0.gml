/// @desc Inicializa Variáveis Globais de Jogo (incluindo Taxas de Estamina)

var _fps_rate = 60; // Taxa de quadros
var _drain_per_sec = 10; // Drenagem de 10 por segundo (Ajustado para 10s de corrida)
var _regen_per_sec = 5;  // Regeneração de 5 por segundo

// As variáveis globais são acessadas por 'global.' e são visíveis em TODO O JOGO.
global.stamina_drain_sprint = (_drain_per_sec / _fps_rate);
global.stamina_regen_constancy = (_regen_per_sec / _fps_rate);
global.stamina_drain_walljump = (5 / _fps_rate); // Custo de Pulo/Agarrar

// Constante de tempo
global.constancy_time_req = 1.5 * _fps_rate;