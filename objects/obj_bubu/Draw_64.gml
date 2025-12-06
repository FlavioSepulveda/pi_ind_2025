/// @desc Desenha o Contador de Cenouras (Canto Superior Direito)

// DIMENSÕES DA TELA GUI: 630x500
var _gui_width = 630; 

// 2. Configurações de Posição
var _icon_size = 48; // Tamanho do ícone (ajuste se for diferente)
var _margin = 30;    // Margem da borda

// POSIÇÃO X do ÍCONE (Canto Direito)
// A posição 'X' é calculada para que o ícone fique 30px longe da borda direita.
var _icon_x = _gui_width - _margin - _icon_size; 
var _icon_y = _margin; 

// 3. Desenhar o Ícone da Cenoura
// Desenha a cenoura no canto superior direito.
draw_sprite(spr_carrot, 0, _icon_x, _icon_y);


// 4. Desenhar a Quantidade (Contagem) - LATERAL
// Posição X do Texto: Começa à direita do ícone (+ 5px de espaço)
var _text_x = _icon_x + _icon_size - 10; 
// Posição Y do Texto: Centraliza verticalmente no centro do ícone
var _text_y = _icon_y - (_icon_size/15.5); 

draw_set_color(c_white);
draw_set_font(-1); // Usando a fonte padrão
draw_set_halign(fa_left); // O texto cresce da esquerda para a direita (longe do ícone)
draw_set_valign(fa_middle); // Alinha o texto ao meio vertical do ícone

draw_text(_text_x, _text_y, "x" + string(carrots_collected));