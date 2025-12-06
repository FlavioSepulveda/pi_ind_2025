/// @desc Configuração da Flutuação e Posição Inicial

start_y = y; 
amplitude = 4; 
speed_v = 0.05; 

// NOVO: Variáveis para o modo Seguir
is_following = false; // Estado inicial: Flutuando
player_id = noone;    // Referência ao jogador que a pegou
follow_dist = 32;     // Distância ideal para a cenoura flutuar atrás do jogador
follow_speed = 0.1;   // Velocidade de seguimento (suavidade)