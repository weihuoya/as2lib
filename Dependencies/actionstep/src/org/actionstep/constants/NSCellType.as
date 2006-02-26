/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.ASConstantValue;
 
class org.actionstep.constants.NSCellType extends ASConstantValue {
  
  static var NSNullCellType:NSCellType = new NSCellType(0);
  static var NSTextCellType:NSCellType = new NSCellType(1);
  static var NSImageCellType:NSCellType = new NSCellType(2);
  
  private function NSCellType(num:Number) {
    super(value);
  }
}

