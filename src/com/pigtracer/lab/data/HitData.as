package com.pigtracer.lab.data {
  /**
   * @author loki
   */
  public class HitData {
    public var latest_id:uint = 0;
    public var msg:String = "";
    public var chances:uint = 1;
    public function encode():Object {
      return {"latest_id":latest_id,
              "msg":msg,
              "chances":chances};
    }
  }
}
