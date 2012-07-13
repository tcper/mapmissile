package com.pigtracer.lab.panel {
  import com.liquid.controls.LiquidButton;
  import com.liquid.containers.LiquidScrollPane;
  import flash.display.Sprite;

  /**
   * @author loki
   */
  public class RegisterPanel extends Sprite {
    public function RegisterPanel() {
      init();
    }
    //==========================================================================
    //  Variables
    //==========================================================================
    private var container:LiquidScrollPane;
    //==========================================================================
    //  Private methods
    //==========================================================================
    private function init():void {
      container = new LiquidScrollPane();
      container.width = 300;
      container.height = 300;

      addChild(container);

      var button:LiquidButton = new LiquidButton();
      container.addChild(button);
    }
  }
}
