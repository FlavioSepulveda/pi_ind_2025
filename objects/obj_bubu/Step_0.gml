#region 1
// 1. INPUT E CÁLCULO DE MOVIMENTO HORIZONTAL (hsp)

// --- DECLARAÇÃO DE VARIÁVEIS LOCAIS NO ESCOPO MAIS ALTO ---
var 
    _target_speed = spd_sprint, 
    _key_h = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A"))),
    _key_grab = keyboard_check(vk_lshift), // Shift é o botão de Agarrar
	_key_up = keyboard_check(vk_up) || keyboard_check(ord("W")), // NOVO: Input vertical para cima
    _key_down = keyboard_check(vk_down) || keyboard_check(ord("S")), // NOVO: Input vertical para baixo
    _key_jump = keyboard_check_pressed(vk_space), 
    _stamina_low_threshold = stamina_max * 0.30, 
    _current_jump_force = jump_force, 
    _is_touching_wall, 
    _is_on_ground, 
    _wall_jump_dir; 
var _key_slow = keyboard_check(vk_alt) // NOVO: Usar ALT Esquerdo para Lentidão

// NOVO: Diminuir Velocidade (Para Plataformas Instáveis)
if (_key_slow) {
    _target_speed = spd_slow; // AGORA SPD_SLOW ESTÁ DEFINIDA NO CREATE
}
// ...
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
    // Punição: Pulo desabilitado
} 
else 
{
    // --- 1. DEFINIÇÃO DE CONDIÇÕES DE CHÃO, PAREDE E RESET ---
    
    // Checa se está tocando uma parede (obj_wall) usando o input horizontal
    _is_touching_wall = place_meeting(x + _key_h, y, obj_wall);
    
    // Checa se está no chão
	_is_on_ground = place_meeting(x, y + 1, obj_wall) || place_meeting(x, y + 1, obj_platform_pass) || place_meeting(x, y + 1, obj_platform_unstable);
	
    // NOVO: Reseta a contagem de pulos aéreos ao tocar o chão
    if (_is_on_ground) {
        air_jumps_available = air_jumps_max;
    }
    
    // 2. Pulo de Parede (Agarrar/Wall Slide ATIVADO POR BOTÃO)
    // Se estiver tocando uma parede, no ar, e pressionando o botão de agarrar
    if (_is_touching_wall && !_is_on_ground && _key_grab)
    {
        // --- ESCALADA DE PAREDE (Wall Climb) ---
        if (_key_up) {
            vsp = -2; // Velocidade de subida (negativa)
            stamina -= 0.1; // Custo extra por esforço
        }
        // Wall Slide Padrão
        else {
            vsp = 0.5; // Wall Slide lento
        }
        
        // CUSTO CONTÍNUO: Drena 0.05 de Estamina por frame (Valor Seguro)
        stamina -= 0.05;

        // SE PULAR DURANTE O AGARRE (Wall Jump)
        if (_key_jump)
        {
            _wall_jump_dir = sign(_key_h); 
            vsp = _current_jump_force * 1.5;
            hsp = -_wall_jump_dir * spd_sprint; 
            stamina -= global.stamina_drain_walljump * 2; // Custo ALTO
            air_jumps_available = air_jumps_max; // Reset total após Wall Jump
        }
    }
    
else if (_key_jump) 
{
    if (_is_on_ground) {
        // Pulo do Chão
        vsp = _current_jump_force;
        stamina -= global.stamina_drain_walljump;
        air_jumps_available = air_jumps_max; // Garante o reset
    }
    else if (air_jumps_available > 0) {
        // CORREÇÃO CRÍTICA: Pulo Duplo (Air Jump)
        vsp = 0; // Zera a velocidade vertical para garantir o impulso
        vsp = _current_jump_force;
        stamina -= global.stamina_drain_walljump * 0.75; // Custo menor
        
        air_jumps_available -= 1; // <<--- ESTA LINHA GASTA O PULO!
    }
}
    
    // REGENERAÇÃO (só se não estiver agarrando ou em exaustão)
    else if (!is_exhausted && !_is_touching_wall)
    {
        // Se não estiver correndo, regenera o foco lentamente.
        stamina = min(100, stamina + global.stamina_regen_constancy);
    }
}
#endregion

#region 4
// 4. COLISÃO ROBUSTA

// Colisão Horizontal (Mantenha o Código Anterior)
if (place_meeting(x + hsp, y, obj_wall))
{
    while (!place_meeting(x + sign(hsp), y, obj_wall))
    {
        x = x + sign(hsp);
    }
    hsp = 0;
}
x = x + hsp;

// -----------------------------------------------------------------
// Colisão Vertical (CÓDIGO FINAL E ROBUSTO)
// -----------------------------------------------------------------

var _collision_target = noone; 
var _inst_instable = noone; // Variável para armazenar a plataforma instável


// 1. TRATAMENTO DA PLATAFORMA PASS-THROUGH
if (vsp > 0) 
{
    var _inst_pass = instance_place(x, y + vsp, obj_platform_pass);

    if (_inst_pass != noone && bbox_bottom <= _inst_pass.y) 
    {
        _collision_target = _inst_pass; // Colide com o pass-through específico.
    }
}


// 2. DEFINIÇÃO DO ALVO FINAL (Priorizando Pass-Through, depois Sólidos)

// Checa colisão com plataformas sólidas (obj_wall ou obj_platform_unstable)
if (_collision_target == noone)
{
    // A. Checagem de Plataforma Instável
    _inst_instable = instance_place(x, y + vsp, obj_platform_unstable);

    if (_inst_instable != noone)
    {
        _collision_target = _inst_instable; 
    }
    // B. Checagem de Plataforma Padrão
    else if (place_meeting(x, y + vsp, obj_wall))
    {
        _collision_target = obj_wall;
    }
}


// 3. RESOLUÇÃO DE COLISÃO COM O ALVO FINAL E LÓGICA DE QUEBRA

// Se _collision_target for um objeto ou uma instância válida:
if (_collision_target != noone)
{
    // Lógica de resulução robusta
    while (!place_meeting(x, y + sign(vsp), _collision_target))
    {
        y = y + sign(vsp);
    }
    vsp = 0;
    
    // --- ATIVAÇÃO DA QUEBRA (Mantido) ---
    // Se colidimos com uma plataforma instável e ela está estável:
    if (_collision_target == _inst_instable && _inst_instable.break_timer == -1)
    {
        // Checa a velocidade horizontal do jogador (módulo)
        if (abs(hsp) > _inst_instable.max_safe_speed) 
        {
            _inst_instable.break_timer = 30; // 0.5 segundo para quebrar
        }
    }
    
    // -----------------------------------------------------------------
    // NOVO: DESLIZAMENTO RÁPIDO DA PLATAFORMA PASS-THROUGH
    // -----------------------------------------------------------------
    // Checamos a plataforma pass-through NO CHÃO após a colisão ser resolvida
    var _inst_pass_landing = instance_place(x, y + 1, obj_platform_pass);
    
    // Se o jogador está no chão E pressionou a tecla para baixo
    if (_inst_pass_landing != noone && _key_down) 
    {
        y += 1; // Move o jogador 1 pixel para baixo
        vsp = 1; // Força uma pequena velocidade de queda para sair da colisão no próximo frame
    }
}

y = y + vsp; // Movimento final
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

// Debug
if keyboard_check(ord("R")){
	game_restart();
}