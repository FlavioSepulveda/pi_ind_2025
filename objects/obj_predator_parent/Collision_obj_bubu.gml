/// @desc Colisão com o Jogador (Dano/Morte)

// O jogador morre ao tocar no predador.
// O jogador tem que ser capaz de acertar por cima para destruir (mecânica de plataforma padrão).

// 1. Checagem de Acerto por Cima (Player está a cair sobre o inimigo)
// Se o jogador está a cair (vsp > 0) e está um pouco acima do centro do inimigo:
if (other.vsp > 0 && other.bbox_bottom < bbox_top + 5) // 5 pixels de tolerância
{
    // Ação de Morte do Inimigo:
    instance_destroy();
 //  NOVO CÓDIGO: SALTO NO AR (PARRY JUMP)
    // -----------------------------------------------------------------
    
    // 1. Zera a velocidade vertical.
    // Isso garante que o salto comece imediatamente, sem a inércia da queda.
    other.vsp = 0; 
    
    // 2. Aplica a FORÇA TOTAL DE PULO.
    // 'other.jump_force' é um valor NEGATIVO (ex: -8), que faz o coelho subir.
    other.vsp = other.jump_force; 
    
    // 3. Se você tivesse um sistema de Double Jump, este seria o lugar
    // para resetar o contador de pulos aéreos do 'other' (o obj_bubu).
    
    // O jogador recebe um SALTO PODEROSO e ganha altura
}
else
{
    // Colisão normal (lateral ou por baixo)
    room_restart(); // Punição: Reinicia a fase
}