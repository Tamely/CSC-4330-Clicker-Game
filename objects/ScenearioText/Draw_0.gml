text = @"You stop by the Student Union.
There, you spot the convenience store
with an array of food and drink.
What do you do?";

draw_self();   // draw the card sprite

draw_set_font(SceneFont); // your new font
var tw = string_width(text);
var th = string_height(text);

// Find the true center of the sprite regardless of origin
var cx = x - sprite_xoffset + sprite_width  / 2;
var cy = y - sprite_yoffset + sprite_height / 2;

draw_set_color(c_white);
draw_text(cx - tw/2, cy - th/2, text);