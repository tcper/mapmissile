package com.pigtracer.lab.data {
  /**
   * @author loki
   */
  public class IDData {
    public var icon:String = "";
    public var name:String = "";
    public function encode():Object {
      return {"icon":icon,
              "name":name};
    }
  }
}
