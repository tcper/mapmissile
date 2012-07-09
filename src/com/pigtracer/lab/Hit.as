package com.pigtracer.lab {
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  import flash.net.URLRequest;
  import baidu.map.basetype.LngLat;
  /**
   * @author loki
   */
  public class Hit {
    public static function hit(value:LngLat):void {
      var request:URLRequest = new URLRequest();
      request.url = "http://2.neverbesame.sinaapp.com/service.php?action=hit";
      request.method = URLRequestMethod.POST;
      
      var data:URLVariables = new URLVariables();
      data.lat = value.lat;
      data.lng = value.lng;
      
      request.data = data;
      
      var l:URLLoader = new URLLoader();
      l.addEventListener(Event.COMPLETE, hitCompleteHandler);
      l.load(request);
      
      function hitCompleteHandler(event:Event):void {
        
      }
    }
  }
}
