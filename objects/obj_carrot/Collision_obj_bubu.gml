/// @desc Coleta da Cenoura (Ativa o Modo Seguir)

if (!is_following)
{
    // 1. Configurar o estado para seguir
    is_following = true;
    
    // 2. Definir a quem seguir
    player_id = other.id; 
    
    // 3. Notificar o jogador que tem mais uma cenoura utilizável
    other.carrots_collected += 1; 
}
// NOTA: A cenoura não é destruída aqui, ela continua a existir e a seguir.