/**
* The Dimension2D class is to encapsulate a width and a height dimension. 
* 
* @author						Michael Herrmann
* 
* @date							18.11.03
*/

import org.as2lib.basic.exceptions.MissingArgumentsException;
import org.as2lib.basic.interfaces.*;

class org.as2lib.geom.Dimension2D implements Classifiable, Cloneable, Comparable {
	
	/** The width; negative values can be used.*/
	public var width:Number;
	
	/** The height; negative values can be used.*/
	public var height:Number;
	
	/**
	* Constructs and initializes a dimension.
	*
	* @param width				The width which is applied to this dimension
	* @param height				The height which is applied to this dimension
	* 
	* @throws					MissingArgumentsException
	*/	
	function Dimension2D(width:Number, height:Number) {
		if(arguments.length>1) {
			this.setSize(width, height);
		} else {
			throw new MissingArgumentsException("Dimension2D Instance", "Dimension2D", arguments, 2);
		}
	}
	
	/**
	* Sets the size of this dimension to the specified size
	* 
	* @param width				The width which is applied to this dimension
	* @param height				The height wich is applied to this dimension
	* 
	* @throws					MissingArgumentsException
	*/
	public function setSize(width:Number, height:Number):Void {
		if(arguments.length>1) {
			this.width = width;
			this.height = height;
		} else {
			throw new MissingArgumentsException("Dimension2D Instance", "setSize", arguments, 2);
		}
	}
	
	/**
	* Returns the runtime class of this object.
	* 
	* @return					This object's class' constructor
	*/
	public function getClass():Function {
		return Dimension2D;
	}
	
	/**
	* Returns an object's class's name.
	* 
	* @return				The object's class's name
	*/
	public function getClassName():String {
		return "Dimension2D";
	}
	
	/**
	* Returns an object's class's path.
	* 
	* @return				The object's class's path
	*/
	public function getClassPath():String {
		return "org.as2lib.geom";
	}
	
	/**
	* Creates a new object of the same class and with the same contents as this object.
	* 
	* @return					A clone of this instance
	*/
	public function clone():Object {
		return new Dimension2D(this.width, this.height);
	}
	
	/**
	* Compares every field of this and the specified object. 
	* 
	* @return				True if all fields have the same value, false otherwise
	*/
	public function equals(obj:Object):Boolean {
		return (obj instanceof Dimension2D && obj.width==this.width && obj.height==this.height);
	}
}