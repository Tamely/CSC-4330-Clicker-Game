draw_set_font(StatUIFont); // your new font

var studying = 14;
var social = 14;
var energy = 14;

draw_set_color(c_white);
draw_text(x, y, "Studying: " + string(studying));
draw_text(x, y + 30, "Social: " + string(social));
draw_text(x, y + 60, "Energy: " + string(energy));