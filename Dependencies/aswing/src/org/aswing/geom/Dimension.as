/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.geom.Point;
import org.aswing.geom.Rectangle;

/**
 * The Dimension class encapsulates the width and height of a componentin a single object.
 * @author iiley
 */
class org.aswing.geom.Dimension{
	public var width:Number;
	public var height:Number;
	
	/**
	 * Dimension(width:Number, height:Number)<br>
	 * Dimension(dim:Dimension)<br>
	 * Dimension()<br>
	 */
	public function Dimension(width, height:Number){
		setSize(width, height);
	}
	
	/**
	 * <br>
	 * setSize(width:Number, height:Number)<br>
	 * setSize(dim:Dimension)<br>
	 */
	public function setSize(width, height:Number):Void{
		if(width instanceof Dimension){
			this.width = width.width;
			this.height = width.height;
		}else{
			if(width == undefined) width = 0;
			if(height == undefined) height = 0;
			this.width = width;
			this.height = height;
		}
	}
	
	/**
	 * Increases the size by s and return its self(<code>this</code>).
	 * @return <code>this</code>.
	 */
	public function increaseSize(s:Dimension):Dimension{
		width += s.width;
		height += s.height;
		return this;
	}
	
	/**
	 * Decreases the size by s and return its self(<code>this</code>).
	 * @return <code>this</code>.
	 */
	public function decreaseSize(s:Dimension):Dimension{
		width -= s.width;
		height -= s.height;
		return this;
	}
	
	/**
	 * modify the size and return itself. 
	 * <br>
	 * change(d:Number)<br>
	 * change(dw:Number, dh:Number)<br>
	 */
	public function change(d:Number, h:Number):Dimension{
		width += d;
		h = (h==undefined ? d:h);
		height += h;
		return this;
	}
	
	/**
	 * return a new size with this size with a change
	 * <br>
	 * changedSize(d:Number)<br>
	 * changedSize(dw:Number, dh:Number)<br>
	 */
	public function changedSize(d:Number, h:Number):Dimension{
		var s:Dimension = new Dimension(width, height);
		return s.change(d, h);
	}
	
	/**
	 * return a new bounds with this size with a pos
	 * <br>
	 * getBounds(x:Number, y:Number)<br>
	 * getBounds(p:Point)<br>
	 * getBounds() pos (0,0)<br> 
	 */
	public function getBounds(x, y:Number):Rectangle{
		var p:Point = new Point(x, y);
		var r:Rectangle = new Rectangle();
		r.setLocation(p);
		r.setSize(width, height);
		return r;
	}
	
	public function equals(o:Object):Boolean{
		var d:Dimension = Dimension(o);
		return width===d.width && height===d.height;
	}	
	
	public function toString():String{
		return "Dimension("+width+","+height+")";
	}
}
