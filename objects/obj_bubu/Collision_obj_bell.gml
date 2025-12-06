/// @desc Conclusão da Fase (Acertar o Sino Escolar)

// 1. Ação de Conclusão: Tenta carregar a próxima sala.
var _next_room = room_next(room);

if (_next_room != -1) // Verifica se há uma próxima sala na ordem
{
    // Se houver, carrega a próxima sala.
    room_goto(_next_room);
}
else
{
    // Se for a última sala, o jogo reinicia ou exibe a tela de vitória.
    // Para o protótipo, vamos reiniciar a fase atual.
    room_restart(); 
    
    // Se quiser reiniciar o jogo todo, use game_restart();
}

// Opcional: Tocar som de vitória/sino
// audio_play_sound(snd_bell, 1, false);