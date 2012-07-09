package com.pigtracer.lab {
  import flash.events.Event;
  import flash.net.URLRequest;
  import flash.net.URLLoader;
  /**
   * @author loki
   */
  public class HitList {
    public static function getList(handler:Function):URLLoader {
      var loader:URLLoader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, handler);
      loader.load(new URLRequest("http://2.neverbesame.sinaapp.com/service.php?action=list"));
      return loader;
    }
  }
}
