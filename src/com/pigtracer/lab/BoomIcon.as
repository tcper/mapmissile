package com.pigtracer.lab {
  import flash.display.DisplayObject;
  import baidu.map.symbol.Symbol;

  import flash.display.Sprite;

  /**
   * @author loki
   */
  public class BoomIcon extends Symbol {
    
    [Embed(source="after-boom-icon.png")]
    private var embeddedClass:Class;
    
    
    public function BoomIcon() {
      var icon:DisplayObject = new embeddedClass();
      icon.scaleX = 0.3;
      icon.scaleY = 0.3;
      //icon.mouseChildren = false;
      //icon.mouseEnabled = false;
      
      //icon.x = -icon.width/2;
      icon.y = icon.height/2;
      
      addChild(icon);
    }
  }
}
