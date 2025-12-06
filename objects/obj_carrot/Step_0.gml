/// @desc Lógica de Flutuação / Seguimento

if (!is_following)
{
    // MODO PADRÃO: Flutuação Suave
    y = start_y + sin(current_time * speed_v) * amplitude; 
}
else
{
    // MODO SEGUIR (PET)
    if (instance_exists(player_id))
    {
        // Posição alvo (um pouco atrás/acima do jogador)
        var _target_x = player_id.x - (sign(player_id.image_xscale) * follow_dist);
        var _target_y = player_id.y - follow_dist / 2;
        
        // Move a cenoura suavemente em direção ao alvo (usa lerp para suavidade)
        x = lerp(x, _target_x, follow_speed);
        y = lerp(y, _target_y, follow_speed);
    }
    else
    {
        // Se o jogador desaparecer (morte/transição), a cenoura volta ao estado Flutuação
        is_following = false;
        start_y = y; // Reseta o ponto de flutuação
    }
}