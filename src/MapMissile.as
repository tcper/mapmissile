package    {
  import flash.ui.Keyboard;
  import uk.co.soulwire.gui.SimpleGUI;
  import flash.geom.Point;
  import baidu.map.event.MapEvent;
  import baidu.map.config.MarkerLayout;
  import baidu.map.overlay.Marker;
  import flash.text.TextFormat;
  import baidu.map.overlay.Label;
  import baidu.map.overlay.geometry.Circle;
  import baidu.map.control.base.Scaler;
  import baidu.map.overlay.geometry.Polygon;
  import baidu.map.layer.Layer;
  import baidu.map.layer.RasterLayer;
  import baidu.map.basetype.LngLat;
  import baidu.map.basetype.Size;
  import baidu.map.core.Map;

  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.display.Sprite;
  import com.pigtracer.lab.BoomIcon;
  import com.pigtracer.lab.Explode;
  import com.pigtracer.lab.Hit;
  import com.pigtracer.lab.HitList;

  [SWF(width="800", height="600", backgroundColor="0xFFFFFF", frameRate="60")]
  public class MapMissile extends Sprite {
    public function MapMissile() {
      if (stage) {
        init();
      } else {
        this.addEventListener(Event.ADDED_TO_STAGE, init);
      }
    }
    //==========================================================================
    //  Properties
    //==========================================================================
    //----------------------------------
    //  isMouseHit
    //----------------------------------
    private var _isMouseHit:Boolean;
    public function get isMouseHit():Boolean {
      return _isMouseHit;
    }
    public function set isMouseHit(value:Boolean):void {
      _isMouseHit = value;
    }
    //==========================================================================
    //  Variables
    //==========================================================================
    private var map:Map;
    private var explode:Explode;
    //==========================================================================
    //  Event handlers
    //==========================================================================
    
    private function init(event:Event = null):void {
      this.removeEventListener(Event.ADDED_TO_STAGE, init);

      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      
      initMap();
//      initGUI();
    }

    private function initGUI():void {
      var gui:SimpleGUI;
      //gui = new SimpleGUI(this, "GUI", Keyboard.SPACE);      
      gui = new SimpleGUI(this, "GUI");      
      
      //gui.addColumn("Instructions");
      var instr:String = "Click button to hit the city.";
      gui.addLabel(instr);
      
      gui.addButton("Hit", {callback:hitHandler});
      
      gui.show();
    }
    
    private function hitHandler():void {
      isMouseHit = true;
    }
    
    private function initMap():void {

      // 创建一个大小为600*400的Map对象
      map = new Map(new Size(800, 600));
      addChild(map);
      // 初始化Map的中心点和显示级别
      map.centerAndZoom(new LngLat(116.404, 39.915), 15);

      // 添加底图
      var layer:Layer = new RasterLayer("BaiduMap", map);
      map.addLayer(layer);
      
      var scaler:Scaler = new Scaler(map);
      map.addControl(scaler);
      
      HitList.getList(listHandler);
      
      map.addEventListener(MapEvent.CLICK, mapClickHandler);
      
      explode = new Explode();
      addChild(explode);
    }

    private function mapClickHandler(event:MapEvent):void {
      
      if (!isMouseHit) {
        return;
      }
      isMouseHit = false;
      
      trace("[MapMissile/mapClickHandler]");
      explode.th();
      
      //var lnglat:LngLat = event.data;
      var point:Point = new Point(mouseX, mouseY);
      var lnglat:LngLat = map.pixelToLngLat(point);
      var marker:Marker = new Marker(new BoomIcon(), MarkerLayout.TOP, "被打击数：" + 1, new TextFormat("Courier", 12, 0xFF0000));
      marker.position = lnglat;
      
      map.addOverlay(marker);
      
      Hit.hit(lnglat);
    }
    
    private function listHandler(event:Event):void {
      var source:String = event.target.data;
      var sourceObject = JSON.parse(source);
      
      var lnglatList:Vector.<LngLat> = new Vector.<LngLat>();
      
      for (var key:String in sourceObject) {
        var hitChances:int = sourceObject[key];
        
        var locSource:Array = key.split(",");
        var lng:Number = Number(locSource[0]);
        var lat:Number = Number(locSource[1]);
        
        var lnglat:LngLat = new LngLat(lng, lat);
        
        /*var label:Label = new Label("this", new TextFormat("Courier", 20, 0xFF0000));
        label.position = lnglat;
        label.background = new BoomIcon();
        map.addOverlay(label);*/
        
        var marker:Marker = new Marker(new BoomIcon(), MarkerLayout.TOP, "被打击数：" + hitChances, new TextFormat("Courier", 12, 0xFF0000));
        marker.position = lnglat;
        map.addOverlay(marker);
      }
      
      //var polygon:Polygon = new Polygon(lnglatList, new BoomIcon());
      //map.addOverlay(polygon);
      
    }
  }
}
