/**
* The Rectangle2D class describes a rectangle defined by a location (x, y) and dimension (w x h). 
* 
* @author		Michael Herrmann
* 
* @date			18.11.03
*/
import org.as2lib.geom.Dimension2D;
import org.as2lib.geom.Point2D;
import org.as2lib.basic.exceptions.MissingArgumentsException;
import org.as2lib.basic.interfaces.*;

class org.as2lib.geom.Rectangle2D implements Classifiable, Cloneable, Comparable {
	
	/** The x coordinate*/
	public var x:Number;
	
	/** The y coordinate*/
	public var y:Number;
	
	/** The width; negative values can be used.*/
	public var width:Number;
	
	/** The height; negative values can be used.*/
	public var height:Number;
	
	/**
	* Constructs and initializes a rectangle
	* 
	* @param x					The x coordinate which is applied to the rectangle
	* @param y					The y coordinate which is applied to the rectangle
	* @param width				The width wich is applied to the rectangle
	* @param height				The height which is applied to the rectangle
	*
	* @throws					MissingArgumentsException
	*/
	function Rectangle2D(x:Number, y:Number, width:Number, height:Number) {
		if(arguments.length>3) {
			this.setRect(x, y, width, height);
		} else {
			throw new MissingArgumentsException("Rectangle2D instance", "Rectangle2D", arguments, 4);
		}
	}
	
	/**
	* Sets this rectangle's position and size
	* 
	* @param x					The x coordinate which is applied to the rectangle
	* @param y					The y coordinate which is applied to the rectangle
	* @param width				The width wich is applied to the rectangle
	* @param height				The height which is applied to the rectangle
	*
	* @throws					MissingArgumentsException
	*/
	public function setRect(x:Number, y:Number, width:Number, height:Number) {
		if(arguments.length>3) {
			this.setPosition(x, y);
			this.setSize(width, height);
		} else {
			throw new MissingArgumentsException("Rectangle2D instance", "setRect", arguments, 4);
		}
	}
	
	/**
	* Sets the position of this rectangle to the specified position.
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
	* Sets the position of this rectangle to the given point's position.
	* 
	* @param x					The x coordinate of the position being applied to this point
	* @param y					The y coordinate of the position being applied to this point
	* 
	* @throws					MissingArgumentsException
	*/
	public function setPositionToPoint(point:Point2D) {
		if(arguments.length>0) {
			this.setPosition(point.x, point.y);
		} else {
			throw new MissingArgumentsException("Point2D instance", "setPositionToPoint", arguments, 1);
		}
	}
	
	/**
	* Translates this rectangle, at location (x, y), by dx along the x axis and dy along the y axis so that it now represents the point (x + dx, y + dy).
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
	* Sets the size of this rectangle to the specified size
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
			throw new MissingArgumentsException("Rectangle2D Instance", "setSize", arguments, 2);
		}
	}
	/**
	* Sets the size of this rectangle do the specified dimension. 
	* 
	* @param dimension			The dimension whose width and height are applied to this Rectangle
	* 
	* @throws					MissingArgumentsException
	*/
	public function setSizeToDimension(dimension:Dimension2D):Void {
		if(arguments.length>0) {
			this.setSize(dimension.width, dimension.height);
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "setSizeToDimension", arguments, 1);
		}
	}
	
	/**
	* Adds a point, specified by the arguments x and y, to this rectangle.
	* The resulting rectangle is the smallest rectangle that contains both the original Rectangle and the specified point. 
	* 
	* @param x					The point's x coordinate
	* @param y					The point's y coordinate
	* 
	* @throws					MissingArgumentsException
	*/
	public function addPointByCoords(x:Number, y:Number):Void {
		if(arguments.length>1) {
			var xCoords:Array = new Array(this.x, this.x+this.width, x).sort(Array.NUMERIC);
			var yCoords:Array = new Array(this.y, this.y+this.height, y).sort(Array.NUMERIC);
			this.setRect(xCoords[0], yCoords[0], xCoords[2]-xCoords[0], yCoords[2]-yCoords[0]);
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "addPointByCoords", arguments, 2);
		}
	}
	
	/**
	* Adds the point to this rectangle. The resulting rectangle is the smallest rectangle
	* that contains both the original Rectangle and the specified point. 
	* 
	* @param point				The point which is added to this rectangle
	* 
	* @throws					MissingArgumentsException
	*/
	public function addPoint(point:Point2D):Void {
		if(arguments.length>0) {
			this.addPointByCoords(point.x, point.y);
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "addPoint", arguments, 1);
		}
	}
	
	/**
	* Adds a rectangle to this rectangle. The resulting rectangle is the union of the two rectangles.
	* 
	* @param rect				The rectangle to add to this rectangle
	* 
	* @throws					MissingArgumentsException
	*/	
	public function addRect(rect:Rectangle2D):Void {
		if(arguments.length>0) {
			this.addPointByCoords(rect.x, rect.y);
			this.addPointByCoords(rect.x+rect.width, rect.y+rect.height);
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "addRect", arguments, 1);
		}
	}
	
	/**
	* Tests whether a point, specified by the arguments x and y, is inside this rectangle.
	* 
	* @param x					The point's x coordinate
	* @param y					The point's y coordinate
	* 
	* @throws					MissingArgumentsException
	*/
	public function contains(x:Number, y:Number):Boolean {
		if(arguments.length>1) {
			var thisBounds:Rectangle2D = this.getBounds();
			return x>=thisBounds.x && x<=thisBounds.x+thisBounds.width && y>=thisBounds.y && y<=thisBounds.y+thisBounds.height;
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "contains", arguments, 2);
		}
	}
	
	/**
	* Tests whether a point is inside this rectangle.
	* 
	* @param point				The point
	* 
	* @throws					MissingArgumentsException
	*/
	public function containsPoint(point:Point2D):Boolean {
		if(arguments.length>0) {
			return this.contains(point.x, point.y);
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "containsPoint", arguments, 1);
		}
	}
	
	/**
	* Returns the x coordinate of the center of this rectangle
	*/
	public function getCenterX():Number {
		return this.x+this.width/2;
	}
	
	/**
	* Returns the x coordinate of the center of this rectangle
	*/
	public function getCenterY():Number {
		return this.y+this.height/2;
	}
	
	/**
	* Returns whether the specified rectangle intersects this rectangle
	* 
	* @param rect				The rectangle
	* 
	* @throws					MissingArgumentsException
	*/
	public function intersects(rect:Rectangle2D):Boolean {
		if(arguments.length>0) {
			var a, b, c, d, e, f, g, h, i:Boolean;
			var x, y, width, height:Number;
			var tempRect, rectBounds, thisBounds:Rectangle2D;
			rectBounds = rect.getBounds();
			thisBounds = this.getBounds();
			a = rect.contains(this.x, this.y);
			b = rect.contains(this.x+this.width, this.y);
			c = rect.contains(this.x+this.width, this.y+this.height);
			d = rect.contains(this.x, this.y+this.height);
			e = this.contains(rect.x, rect.y);
			f = this.contains(rect.x+rect.width, rect.y);
			g = this.contains(rect.x+rect.width, rect.y+rect.height);
			h = this.contains(rect.x, rect.y+rect.height);
			
			x = thisBounds.x < rectBounds.x ? thisBounds.x : rectBounds.x;
			y = thisBounds.y < rectBounds.y ? thisBounds.y : rectBounds.y;
			width = rectBounds.width<thisBounds.width ? thisBounds.width : rectBounds.width;
			height = rectBounds.height<thisBounds.height ? thisBounds.height : rectBounds.height;
			tempRect = new Rectangle2D(x, y, width, height);
			i = tempRect.equals(this.union(rect));
			
			return a or b or c or d or e or f or g or h or i;
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "intersects", arguments, 1);
		}
	}
	
	/**
	* Computes the intersection of this rectangle with the specified rectangle.
	* 
	* @param rect				The rectangle
	* 
	* @throws					MissingArgumentsException
	* 
	* @return					The largest rectangle contained in both the specified rectangle and in this rectangle;
	*							or if the rectangles do not intersect, an empty rectangle.
	* 
	* @throws					MissingArgumentsException
	*/
	public function intersection(rect:Rectangle2D):Rectangle2D {
		if(arguments.length>0) {
			if(!this.intersects(rect)) {
				return new Rectangle2D(0, 0, 0, 0);
			} else {
				var thisBounds:Rectangle2D = this.getBounds();
				var rectBounds:Rectangle2D = rect.getBounds();
				var x, y, width, w1, w2, height, h1, h2:Number;
				w1 = thisBounds.x+thisBounds.width-rectBounds.x;
				w2 = rectBounds.width-thisBounds.x+rectBounds.x;
				if(thisBounds.x<rectBounds.x) {
					x = rectBounds.x;
					if(rectBounds.x<thisBounds.x+thisBounds.width) {
						if(rectBounds.x+rectBounds.width<thisBounds.x+thisBounds.width) {
							width = rectBounds.width;
						} else {
							width = thisBounds.x+thisBounds.width-rectBounds.x;
						}
					}
				} else if(rectBounds.x<thisBounds.x) {
					x = thisBounds.x;
					if(thisBounds.x<rectBounds.x+rectBounds.width) {
						if(thisBounds.x+thisBounds.width<rectBounds.x+rectBounds.width) {
							width = thisBounds.width;
						} else {
							width = rectBounds.x+rectBounds.width-thisBounds.x;
						}
					}
				}
				if(thisBounds.y<rectBounds.y) {
					y = rectBounds.y;
					if(rectBounds.y<thisBounds.y+thisBounds.height) {
						if(rectBounds.y+rectBounds.height<thisBounds.y+thisBounds.height) {
							height = rectBounds.height;
						} else {
							height = thisBounds.y+thisBounds.height-rectBounds.y;
						}
					}
				} else if(rectBounds.y<thisBounds.y) {
					y = thisBounds.y;
					if(thisBounds.y<rectBounds.y+rectBounds.height) {
						if(thisBounds.y+thisBounds.height<rectBounds.y+rectBounds.height) {
							height = thisBounds.height;
						} else {
							height = rectBounds.y+rectBounds.height-thisBounds.y;
						}
					}
				}
				return new Rectangle2D(x, y, width, height);
			}
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "intersection", arguments, 1);
		}
	}
	/**
	* Computes the union of this Rectangle with the specified Rectangle. Returns a new Rectangle that represents the union of the two rectangles. 
	* 
	* @param rect				The rectangle to add to this rectangle
	* 
	* @throws					MissingArgumentsException
	* 
	* @return					The smallest rectangle containing both the specified rectangle and this rectangle
	*/
	public function union(rect:Rectangle2D):Rectangle2D {
		if(arguments.length>0) {
			var result:Rectangle2D = Rectangle2D(rect.clone());
			result.addRect(this);
			return result;
		} else {
			throw new MissingArgumentsException("Rectangle2D Instance", "union", arguments, 1);
		}
	}
	
	/**
	* Returns the bounding box of this rectangle. If this rectangle's width or height are empty, 
	* the bounding box is restructured so that it represents the same rectangle but with positive
	* width and height.
	* 
	* @return					The Bounding box of this rectangle
	*/
	public function getBounds():Rectangle2D {
		return new Rectangle2D((this.width<0 ? this.x+this.width : this.x), (this.height<0 ? this.y+this.height : this.y), Math.abs(this.width), Math.abs(this.height));
	}
	
	/**
	* Determines whether or not this rectangle is empty. A rectangle is empty if its width or its height is less than or equal to zero. 
	*/
	public function isEmpty():Boolean {
		return this.width<=0 or this.height <= 0;
	}
	
	/**
	* Returns the runtime class of this object.
	* 
	* @return					This object's class' constructor
	*/
	public function getClass():Function {
		return Rectangle2D;
	}
	
	/**
	* Returns an object's class's name.
	* 
	* @return				The object's class's name
	*/
	public function getClassName():String {
		return "Rectangle2D";
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
		return Object(new Rectangle2D(this.x, this.y, this.width, this.height));
	}
	
	/**
	* Compares every field of this and the specified object. 
	* 
	* @return					True if all fields have the same value, false otherwise
	*/
	public function equals(obj:Object):Boolean {
		return (obj instanceof Rectangle2D && obj.x==this.x && obj.y==this.y && obj.width==this.width && obj.height==this.height);
	}
}