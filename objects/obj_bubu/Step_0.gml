#region 1
// 1. INPUT E CÁLCULO DE MOVIMENTO HORIZONTAL (hsp)

// CORREÇÃO: Declarar e inicializar a variável local _target_speed AQUI.
var _target_speed = spd_sprint; // NOVO PADRÃO: Velocidade de Sprint por default

// Receber inputs: (A/D ou Setas)
var _key_h = (keyboard_check(vk_right) || keyboard_check(ord("D"))) 
             - (keyboard_check(vk_left) || keyboard_check(ord("A")));

// var _key_sprint = keyboard_check(vk_lshift); // REMOVIDO: Sprint é o estado padrão

var _stamina_low_threshold = stamina_max * 0.30; // 30% como limiar de "Cansaço Parcial"

// --- Lógica de Velocidade baseada na Estamina ---
if (stamina <= 0)
{
    // Exaustão Total: Velocidade mínima
    _target_speed = spd_exhaust; 
}
else if (stamina <= _stamina_low_threshold)
{
    // Cansaço Parcial: Velocidade reduzida
    // Exemplo: Usa lerp para reduzir a velocidade suavemente entre 30% e 0% de Estamina
    var _stamina_norm = stamina / _stamina_low_threshold;
    _target_speed = lerp(spd_exhaust, spd_sprint, _stamina_norm);
}


// --- CÁLCULO DE HSP (Com Aceleração) ---
if (_key_h != 0) // Se há input (o coelho corre)
{
    // Aceleração para o Sprint (Simula esforço)
    hsp = lerp(hsp, _key_h * _target_speed, 0.15); 
}
else // Se não há input (parado)
{
    hsp = lerp(hsp, 0, 0.2); // Desaceleração
}
#endregion

#region 2
// 2. LÓGICA DE ESTAMINA E ESTADOS DE RITMO

// A. Gerenciamento de Drenagem/Recuperação

if (_key_h != 0) // Se o coelho está CORRENDO
{
    // Drenagem: Correr DRENA rapidamente a Estamina
    // Usaremos a taxa de drenagem original do Sprint
    stamina -= stamina_drain_sprint; 
    
    // Zera o timer de constância (Não é mais usado, mas evita confusão)
    constancy_timer = 0;
    is_in_constancy = false;
}
else // O coelho está PARADO
{
    // Recuperação: Parar RECARREGA a Estamina
    stamina += stamina_regen_constancy * 2; // Regeneração mais rápida ao parar
    
    // Zera o timer de constância (Não é mais usado)
    constancy_timer = 0;
    is_in_constancy = false;
}

// B. Limites e Transições de Estado

// Garante que a estamina esteja entre 0 e o máximo
stamina = clamp(stamina, 0, stamina_max); 

// O estado de Exaustão Total agora é baseado em stamina <= 0
var _is_exhausted_total = (stamina <= 0);

if (_is_exhausted_total)
{
    // Entra em Exaustão (Cochilo)
    is_exhausted = true;
}
else if (stamina >= 10) // Sai da Exaustão Total rapidamente
{
    is_exhausted = false;
}
#endregion

#region 3
// 3. GRAVIDADE E SALTO

// Gravidade (mantida no topo)
vsp = vsp + grav;
vsp = clamp(vsp, -max_vsp, max_vsp);

// Controles de Pulo
var _key_jump = keyboard_check_pressed(vk_space); 
var _current_jump_force = jump_force;

// ... (Lógica de Punição de Cansaço Parcial para _current_jump_force)
if (stamina < stamina_max * 0.5) 
{
    _current_jump_force = jump_force * (stamina / (stamina_max * 0.5));
    _current_jump_force = clamp(_current_jump_force, jump_force * 0.2, jump_force);
}

// Verifica se PODE pular ou agarrar
var _can_jump = (stamina > 0); 

// --- Lógica de Pulo e Pulo de Parede ---
if (is_exhausted) // Exaustão Total (stamina <= 0)
{
    // Punição: Pulo desabilitado e sem agarre de parede
} 
else // Se NÃO está em Exaustão Total
{
    var _is_touching_wall = place_meeting(x + _key_h, y, obj_wall);
    var _is_on_ground = place_meeting(x, y + 1, obj_wall);

    // Pulo de Parede (Agarrar/Wall Slide ATIVADO POR BOTÃO)
    // Apenas agarra se estiver a tocar na parede E o jogador estiver a pressionar o botão Agarrar
    if (_is_touching_wall && !_is_on_ground && _key_grab)
    {
        // NOVO CUSTO CONTÍNUO: Agarrar drena Estamina
        stamina -= stamina_drain_constancy * 0.5; 
        
        // Zera a gravidade e impõe o Deslize Lento
        vsp = 0.5; // Wall Slide
        
        // Se pular durante o agarre
        if (_key_jump)
        {
            var _wall_jump_dir = sign(_key_h); // A direção de impulso é a direção do input.
            
            vsp = _current_jump_force * 1.5; // Pulo de Parede mais forte
            hsp = -_wall_jump_dir * spd_sprint; // Impulso oposto ao da parede
            stamina -= stamina_drain_walljump * 2; // Custo ALTO
        }
    }
    // Pulo Básico (só se estiver no chão E não em Wall Grab)
    else if (_key_jump && _is_on_ground && _can_jump) 
    {
        vsp = _current_jump_force; // Aplica a força de pulo (agora variável) 
        stamina -= stamina_drain_walljump; // Custo do Pulo Básico
    }
}
#endregion

#region 4
// Colisão Horizontal
if (place_meeting(x + hsp, y, obj_wall))
{
    while (!place_meeting(x + sign(hsp), y, obj_wall))
    {
        x = x + sign(hsp);
    }
    hsp = 0;
}
x = x + hsp;

// Colisão Vertical
if (place_meeting(x, y + vsp, obj_wall))
{
    while (!place_meeting(x, y + sign(vsp), obj_wall))
    {
        y = y + sign(vsp);
    }
    vsp = 0;
}
y = y + vsp;

// Debug

if keyboard_check(ord("R")){
	game_restart();
}
	
#endregion
