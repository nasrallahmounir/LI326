

unsigned char is_stylus_on_sprite(sprite2D* sprite, touchPosition touch){
  if( (touch.px < sprite->x) || (touch.px > ((sprite->x)+64)) ){
    return 0;
  }
  if( (touch.py <sprite->y) ||(touch.py > ((sprite->y)+64)) ){
    return 0;
  }
  return 1;
}


