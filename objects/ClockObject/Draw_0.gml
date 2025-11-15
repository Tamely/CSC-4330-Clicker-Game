draw_self() //Make sure sprite is on the screen
draw_set_font(StatUIFont);

var time = "8:30";
var text = "Time: " + string(time);
var textWidth = string_width(text);
draw_set_color(c_white);
draw_text(x + 10 - textWidth / 2, y + sprite_height/2,text);