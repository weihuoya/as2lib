/**
* The Point2D class defines a point representing a location in (x, y) coordinate space. 
* 
* @author						Michael Herrmann
* 
* @date							16.11.03
*/

import org.as2lib.basic.exceptions.MissingArgumentsException;
import org.as2lib.basic.interfaces.*;

class org.as2lib.geom.Point2D implements Classifiable, Cloneable, Comparable {
	
	/** The x coordinate*/
	public var x:Number;
	
	/** The y coordinate*/
	public var y:Number;
	
	/**
	* Constructs and initializes a point.
	* 
	* @param x					The x coordinate of the position being applied to this point
	* @param y					The y coordinate of the position being applied to this point
	* 
	* @throws					MissingArgumentsException
	*/
	public function Point2D(x:Number, y:Number) {
		if(arguments.length>1) {
			this.setPosition(x, y);
		} else {
			throw new MissingArgumentsException("Point2D instance", "Point2D", arguments, 2);
		}
	}
	

	/**
	* Sets the position of this point to the specified position.
	* 
	* @param x					The x coordinate of the position being applied to this point
	* @param y					The y coordinate of the position being applied to this point
	* 
	* @throws					MissingArgumentsException
	*/
	public function setPosition(x:Number, y:Number):Void {
		if(arguments.length>1) {
			this.x = x;
			this.y = y;
		} else {
			throw new MissingArgumentsException("Point2D instance", "setPosition", arguments, 2);
		}
	}
	
	/**
	* Translates this point, at location (x, y), by dx along the x axis and dy along the y axis so that it now represents the point (x + dx, y + dy).
	* 
	* @param dx					The distance to move this point along the x axis
	* @param dy					The distance to move this point along the y axis
	* 
	* @throws					MissingArgumentsException
	*/
	public function moveBy(dx:Number, dy:Number):Void {
		if(arguments.length>1) {
			this.x+=dx;
			this.y+=dy;
		} else {
			throw new MissingArgumentsException("Point2D instance", "moveBy", arguments, 2);
		}
	}
	
	/**
	* Returns the distance from this point to the point specified by the parameters x and y.
	*
	* @param x					The x coordinate of the point whose distance to this point is derived
	* @param y					The y coordinate of the point whose distance to this point is derived
	* 
	* @return					The distance from this point to the specified point.
	* 
	* @throws					MissingArgumentsException
	*/
	public function distanceFrom(x:Number, y:Number):Number {
		if(arguments.length>1) {
			x -= this.x;
			y -= this.y;
			return Math.sqrt(x*x+y*y);
		} else {
			throw new MissingArgumentsException("Point2D instance", "distanceFrom", arguments, 2);
		}
	}
	
	/**
	* Returns the distance from this point to the specified point.
	* 
	* @param point				The point whose distance to this point is derived
	* 
	* @return					The distance from this point to the specified point.
	* 
	* @throws					MissingArgumentsException
	*/
	public function distanceFromPoint(point:Point2D):Number {
		if(arguments.length>0) {
			return this.distanceFrom(point.x, point.y);
		} else {
			throw new MissingArgumentsException("Point2D instance", "distanceFromPoint", arguments, 1);
		}
	}
	
	/**
	* Returns the runtime class of this object.
	* 
	* @return					This object's class' constructor
	*/
	public function getClass():Function {
		return Point2D;
	}
	
	/**
	* Returns an object's class's name.
	* 
	* @return				The object's class's name
	*/
	public function getClassName():String {
		return "Point2D";
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
		return new Point2D(this.x, this.y);
	}
	
	/**
	* Compares every field of this and the specified object. 
	* 
	* @return					True if all fields have the same value, false otherwise
	*/
	public function equals(obj:Object):Boolean {
		return (obj instanceof Point2D && obj.x==this.x && obj.y==this.y);
	}
}