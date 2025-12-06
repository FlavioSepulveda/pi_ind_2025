/// @desc Perseguir o Jogador

if (instance_exists(obj_bubu))
{
    // 1. Cálculo da Direção do Jogador
    var _dir = point_direction(x, y, obj_bubu.x, obj_bubu.y);
    
    // 2. Movimento DIRETO (sem lerp)
    x += lengthdir_x(chase_speed, _dir); 
    y += lengthdir_y(chase_speed, _dir); 
}