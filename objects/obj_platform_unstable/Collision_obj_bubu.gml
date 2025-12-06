///// @desc Checagem de Velocidade e Quebra

//// 1. Checa se o jogador está sobre a plataforma (caindo)
//if (other.vsp >= 0 && other.bbox_bottom <= bbox_top + 5) 
//{
//    // 2. Checa a velocidade horizontal do jogador (módulo)
//    if (abs(other.hsp) > max_safe_speed) 
//    {
//        // Se estiver estável e a velocidade for muito alta, começa a quebrar.
//        if (break_timer == -1)
//        {
//            break_timer = 30; // Quebra em 0.5 segundo
//        }
//    }
//    else
//    {
//        // Se a velocidade for segura, mantém a plataforma estável.
//        break_timer = -1;
//    }
//}