/// @desc Variáveis de Estado e Ataque

state = "PATROL";  // Estado inicial: Patrulhando
attack_speed = 6;  
target_x = 0;      
target_y = 0;      
attack_range = 300; // Raio de alcance para ataque

// NOVO: Variáveis de Patrulha
patrol_speed = 1.0; // Velocidade de voo lateral (lento)
patrol_dir = 1;     // 1 para direita, -1 para esquerda
patrol_dist = 64;   // Distância que ele voa antes de mudar de direção
start_x = x;        // Posição X inicialaio de alcance para ataque