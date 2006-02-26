/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.ASConstantValue;

class org.actionstep.constants.NSTextAlignment extends ASConstantValue {
  
  static var NSLeftTextAlignment:NSTextAlignment = new NSTextAlignment(0);
  static var NSRightTextAlignment:NSTextAlignment = new NSTextAlignment(1);
  static var NSCenterTextAlignment:NSTextAlignment = new NSTextAlignment(2);
  static var NSJustifiedTextAlignment:NSTextAlignment = new NSTextAlignment(3);
  static var NSNaturalTextAlignment:NSTextAlignment = new NSTextAlignment(4);
  
  private static var STRINGS:Array = ["left", "right", "center", "left", "left"];
  
  public var string:String;
  
  private function NSTextAlignment(num:Number) {
    super(num);
    string = STRINGS[num];
  }

}