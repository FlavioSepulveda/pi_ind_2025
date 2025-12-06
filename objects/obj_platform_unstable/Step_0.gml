/// @desc Lógica de Quebra e Inicialização Segura

// 1. CÁLCULO SEGURO (Executa Apenas uma Vez)
// Checa se o cálculo NUNCA foi feito (max_safe_speed == -1) E se o obj_bubu existe.
if (max_safe_speed == -1 && instance_exists(obj_bubu))
{
    // O obj_bubu existe, podemos ler a variável com segurança.
    max_safe_speed = obj_bubu.spd_slow * 1.5; 
}


// 2. Gerenciar o Timer de Quebra (Mantido)
if (break_timer > 0) 
{
    break_timer--;
} 
else if (break_timer == 0) 
{
    instance_destroy(); // Quebra e desaparece
}

// 3. Checar o Jogador (Apenas se a plataforma estiver estável e o cálculo tiver sido feito)

// Apenas executa se o cálculo da velocidade foi feito e a plataforma está estável.
if (max_safe_speed != -1 && break_timer == -1) 
{
    var _player = instance_place(x, y-1, obj_bubu); // Checa se o jogador está 1px acima

    if (_player != noone) // Se há um jogador em cima
    {
        // Apenas considera a checagem se o jogador está pousado ou a cair
        if (_player.vsp >= 0)
        {
            // Checa a velocidade horizontal do jogador (módulo)
            if (abs(_player.hsp) > max_safe_speed) 
            {
                break_timer = 30; // 0.5 segundo para quebrar
                // (Opcional: Mudar sprite para dar feedback visual)
            }
        }
    }
}