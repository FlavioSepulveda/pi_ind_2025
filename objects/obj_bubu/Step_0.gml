#region 1
// 1. INPUT E CÁLCULO DE MOVIMENTO HORIZONTAL (hsp)

// --- DECLARAÇÃO DE VARIÁVEIS LOCAIS NO ESCOPO MAIS ALTO ---
var 
    _target_speed = spd_sprint, 
    _key_h = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A"))),
    _key_grab = keyboard_check(vk_lshift), // Shift é o botão de Agarrar
    _key_jump = keyboard_check_pressed(vk_space), 
    _stamina_low_threshold = stamina_max * 0.30, 
    _current_jump_force = jump_force, 
    _is_touching_wall, 
    _is_on_ground, 
    _wall_jump_dir; 

// --- Lógica de Velocidade baseada na Estamina ---
if (stamina <= 0)
{
    _target_speed = spd_exhaust; 
}
else if (stamina <= _stamina_low_threshold)
{
    var _stamina_norm = stamina / _stamina_low_threshold;
    _target_speed = lerp(spd_exhaust, spd_sprint, _stamina_norm);
}

// --- CÁLCULO DE HSP (Com Aceleração) ---
if (_key_h != 0) 
{
    hsp = lerp(hsp, _key_h * _target_speed, 0.15); 
}
else 
{
    hsp = lerp(hsp, 0, 0.2); 
}
#endregion

#region 2
// 2. LÓGICA DE ESTAMINA E ESTADOS DE RITMO

// A. Gerenciamento de Drenagem/Recuperação

if (_key_h != 0) // Se o coelho está CORRENDO
{
    // Drenagem: Correr DRENA rapidamente a Estamina (USANDO GLOBAL!)
    stamina -= global.stamina_drain_sprint; 
    
    constancy_timer = 0;
    is_in_constancy = false;
}
else // O coelho está PARADO
{
    // Recuperação: Parar RECARREGA a Estamina (USANDO GLOBAL!)
    stamina += global.stamina_regen_constancy * 2; 
    
    constancy_timer = 0;
    is_in_constancy = false;
}

// B. Limites e Transições de Estado

stamina = clamp(stamina, 0, stamina_max); 

if (stamina <= 0)
{
    is_exhausted = true;
}
else if (stamina >= stamina_min_recovery) 
{
    is_exhausted = false;
}
#endregion

#region 3
// 3. GRAVIDADE E SALTO

vsp = vsp + grav;
vsp = clamp(vsp, -max_vsp, max_vsp);

// --- Lógica de Pulo e Pulo de Parede ---
if (is_exhausted) 
{
    // Punição: Pulo desabilitado e sem agarre de parede
} 
else 
{
    _is_touching_wall = place_meeting(x + _key_h, y, obj_wall);
    _is_on_ground = place_meeting(x, y + 1, obj_wall);

    // Pulo de Parede (Agarrar/Wall Slide ATIVADO POR BOTÃO)
    if (_is_touching_wall && !_is_on_ground && _key_grab)
    {
        // CUSTO CONTÍNUO: Agarrar drena Estamina (USANDO GLOBAL!)
        stamina -= global.stamina_regen_constancy * 0.5; 
        vsp = 0.5; // Wall Slide

        // Se pular durante o agarre
        if (_key_jump)
        {
            _wall_jump_dir = sign(_key_h); 
            
            vsp = _current_jump_force * 1.5; 
            hsp = -_wall_jump_dir * spd_sprint; 
            stamina -= global.stamina_drain_walljump * 2; // Custo ALTO (USANDO GLOBAL!)
        }
    }
    // Pulo Básico (só se estiver no chão E não em Wall Grab)
    else if (_key_jump && _is_on_ground) 
    {
        vsp = _current_jump_force; 
        stamina -= global.stamina_drain_walljump; // Custo do Pulo Básico (USANDO GLOBAL!)
    }
}
#endregion

#region 4
// 4. COLISÃO ROBUSTA

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

#region 5
/// @desc Consumo de Cenouras para Recuperar Estamina

var _key_consume = keyboard_check_pressed(vk_lcontrol); 

if (_key_consume)
{
    // 1. Verificar se o jogador tem cenouras
    if (carrots_collected > 0)
    {
        // 2. Encontrar e Consumir/Destruir uma instância de Cenoura que está a seguir
        // Procura a primeira instância de obj_carrot que está no modo 'is_following' e a destruir.
        var _carrot_to_destroy = instance_find(obj_carrot, 0); 
        
        // Precisa de ter a certeza de que a cenoura encontrada está a seguir ESTE jogador
        if (instance_exists(_carrot_to_destroy) && _carrot_to_destroy.player_id == id)
        {
            instance_destroy(_carrot_to_destroy);
        
            // 3. Remover do Inventário (o mais importante!)
            carrots_collected -= 1;
            
            // 4. Recuperar Estamina (+10)
            stamina += 10;
            
            // 5. Garantir o limite
            stamina = clamp(stamina, 0, stamina_max);
        }
        // Se o jogo tivesse vários jogadores, a lógica de procura (instance_find) teria que ser mais complexa.
    }
}
#endregion