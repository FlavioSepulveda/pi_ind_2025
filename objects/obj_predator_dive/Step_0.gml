/// @desc Lógica de Rasante e Patrulha

if (state == "PATROL")
{
    // A. Movimento de Patrulha Lateral
    x += patrol_dir * patrol_speed;
    
    // B. Mudar de Direção
    // Se o predador se afastou muito da posição inicial, inverte a direção
    if (abs(x - start_x) > patrol_dist)
    {
        patrol_dir = -patrol_dir; // Inverte 1 para -1 ou -1 para 1
        start_x = x; // Define a nova posição inicial para o próximo ciclo
    }
    
    // C. Condição de Ataque (Ativação do Rasante)
    if (instance_exists(obj_bubu) && distance_to_object(obj_bubu) < attack_range) 
    {
        // Define o alvo: Posição atual do jogador + profundidade para rasante
        target_x = obj_bubu.x;
        target_y = obj_bubu.y + 200; 
        
        state = "ATTACK";
    }
}
else if (state == "ATTACK")
{
    // 1. Cálculo da Direção do Rasante
    var _dir = point_direction(x, y, target_x, target_y);
    
    // 2. Movimento
    x += lengthdir_x(attack_speed, _dir);
    y += lengthdir_y(attack_speed, _dir);
    
    // 3. Morte ao Acertar o Chão/Parede
    if (place_meeting(x, y, obj_wall))
    {
        instance_destroy();
    }
}