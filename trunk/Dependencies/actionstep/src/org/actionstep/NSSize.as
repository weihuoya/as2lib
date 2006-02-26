/* See LICENSE for copyright and terms of use */

import org.actionstep.NSObject;
import org.actionstep.NSCopying;

/**
 * Represents a width height pair.
 * 
 * @author Richard Kilmer
 */
class org.actionstep.NSSize extends NSObject implements NSCopying {
	
  /** The size's width */
  public var width:Number;
  
  /** The size's height */
  public var height:Number;
  
  /**
   * Creates a new instance of the <code>NSSize</code> class with a width of
   * <code>width</code> and a height of <code>height</code>.
   */
  public function NSSize(width:Number, height:Number) {
    this.width = width;
    this.height = height;
  }
  
  /**
   * Returns a clone of the size.
   */
  public function clone():NSSize {
    return new NSSize(width, height);
  }
  
  /**
   * Returns a clone of the size.
   */
  public function copyWithZone():NSObject {
    return new NSSize(width, height);
  }

  /**
   * Returns a string representation of the object.
   */
  public function description():String {
    return "NSSize(width="+width+", height="+height+")";
  }

  /**
   * Subtracts <code>aSize</code> from this one and returns the result.
   */  
  public function subtractSize(aSize:NSSize):NSSize {
    return new NSSize(width - aSize.width, height - aSize.height);
  }
  
  /**
   * Returns <code>true</code> if the size is equal to <code>other</code>, or
   * <code>false</code> if it is not.
   */
  public function isEqual(other:Object):Boolean {
    return width == other.width && height == other.height;
  }

  /**
   * Returns a size with a width and height of 0.
   */
  public static function get ZeroSize():NSSize {
    return new NSSize(0, 0);
  }
}
