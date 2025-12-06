/// @desc Arremesso do Jogador

// Só ativa se o jogador estiver caindo ou parado em cima
if (other.vsp >= 0) 
{ 
    // Mola/Booster
    other.vsp = 0; // Zera a velocidade vertical
    other.vsp = boost_force; // Aplica o arremesso forte
    
    // (Opcional: Tocar som e mudar sprite para mostrar que a mola foi comprimida)
}