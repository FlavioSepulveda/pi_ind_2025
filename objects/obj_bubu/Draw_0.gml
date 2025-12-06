draw_self();

/// @desc Desenha a Barra de Estamina (Foco)

// --- CONFIGURAÇÃO DA BARRA ---
var bar_width = 200;  // Largura da barra de estamina (em pixels)
var bar_height = 20; // Altura da barra de estamina (em pixels)
var bar_x = 30;      // Posição X inicial na tela (canto superior esquerdo)
var bar_y = 30;      // Posição Y inicial na tela
var bar_padding = 4; // Espaçamento entre o fundo e a barra

// --- CÁLCULO DA ESTAMINA ---
// Calcula a porcentagem atual de estamina (0 a 1)
var _stamina_percent = stamina / stamina_max;

// Calcula a largura da barra de foco preenchida
var _fill_width = (_stamina_percent * (bar_width - (bar_padding * 2)));


// --- 1. DESENHAR O FUNDO DA BARRA (Cinza Escuro) ---
draw_set_color(c_black);
// draw_rectangle(x1, y1, x2, y2, outline)
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, false);


// --- 2. DESENHAR A BARRA DE FOCO (Preenchimento) ---
var _fill_color = c_green;

// Punição Visual: Se estiver em Exaustão, a barra deve ficar vermelha
if (is_exhausted)
{
    _fill_color = c_red; // Sinal claro de punição/cochilo
}
else if (stamina < (stamina_max / 3)) // Aviso: Abaixo de 33% de foco
{
    _fill_color = c_yellow;
}

draw_set_color(_fill_color);

// Desenha o retângulo de preenchimento, considerando o padding
draw_rectangle(bar_x + bar_padding, 
               bar_y + bar_padding, 
               bar_x + bar_padding + _fill_width, 
               bar_y + bar_height - bar_padding, 
               false);
               
               
// --- 3. DESENHAR A BORDA DA BARRA (Para destacar) ---
draw_set_color(c_white);
draw_rectangle(bar_x, bar_y, bar_x + bar_width, bar_y + bar_height, true); // true = apenas a borda


// --- 4. TEXTO (Opcional: Exibir valor) ---
draw_set_color(c_white);
draw_set_halign(fa_left); // Alinhamento horizontal à esquerda
draw_set_valign(fa_top);  // Alinhamento vertical ao topo
draw_text(bar_x, bar_y + bar_height + 5, "Foco: " + string(round(stamina)) + " / " + string(stamina_max));