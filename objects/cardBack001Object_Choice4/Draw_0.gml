draw_self();   // draw the card sprite

draw_set_font(ChoiceFont); // your new font

text = @"Leave without 
buying anything"
var tw = string_width(text);
var th = string_height(text);

// Find the true center of the sprite regardless of origin
var cx = x - sprite_xoffset + sprite_width  / 2;
var cy = y - sprite_yoffset + sprite_height / 2;

draw_set_color(c_black);
draw_text(cx - tw/2, cy - th/2, text);