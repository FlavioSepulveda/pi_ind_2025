/// @desc Variáveis de Controles de Ritmo, Movimento e Estamina

// --- VARIÁVEIS DE FÍSICA BÁSICA ---
grav	= 0.3;      // Gravidade padrão
max_vsp = 8;     // Velocidade vertical máxima de queda
vsp		= 0;         // Velocidade vertical atual
hsp		= 0;         // Velocidade horizontal atual

// --- VARIÁVEIS DE RITMO (Definidas pelo GDD) ---
spd_base	= 3;    // Velocidade de "Andar Constante"
spd_boost	= spd_base * 1.10; // Velocidade de "Ritmo Firme" (110% do padrão)
spd_sprint	= spd_base * 1.25; // Velocidade de "Sprint" (125% do padrão)
spd_exhaust = spd_base * 0.10; // Velocidade de "Exaustão" (10% do padrão)
spd_slow	= spd_base * 0.3; // NOVO: Velocidade de Andar Lento (30% da base)

// Variaveis de pulo -
jump_force			= -6; // Força de pulo
can_jump			= true; // Flag para controlar se pode pular
air_jumps_max		= 1;      // NOVO: Número máximo de pulos aéreos (1 para pulo duplo)
air_jumps_available = air_jumps_max; // NOVO: Contagem atual

// --- VARIÁVEIS DE ESTAMINA (FOCO) ---
stamina_max				= 100;
stamina					= stamina_max; // Começa com 100% de Foco
stamina_min_recovery	= 10; // Mínimo para sair da Exaustão Total

// --- VARIÁVEIS DE ESTADO ---
is_exhausted	= false; // O coelho está no "cochilo" (Exaustão Total)?
is_in_constancy = false; 
constancy_timer = 0;

// --- VARIÁVEIS DE COLETÁVEIS ---
carrots_collected = 0; // Quantidade de cenouras coletadas. ESTA LINHA É ESSENCIAL.