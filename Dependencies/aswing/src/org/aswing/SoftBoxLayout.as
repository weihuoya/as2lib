/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.geom.*;

/**
 * SoftBoxLayout layout the components to a list as same width/height but their preffered height/width.
 * 
 * @see BoxLayout
 * @author iiley
 */
class org.aswing.SoftBoxLayout extends EmptyLayout{
	
    /**
     * Specifies that components should be laid out left to right.
     */
    public static var X_AXIS:Number = 0;
    
    /**
     * Specifies that components should be laid out top to bottom.
     */
    public static var Y_AXIS:Number = 1;
    
    
    private var axis:Number;
    private var gap:Number;
    
    /**
     * <br>
     * BoxLayout(axis:Number)<br>
     * BoxLayout(axis:Number)<br>
     * @param axis the layout axis, default X_AXIS
     * @param gap the gap between each component, default 0
     * @see #X_AXIS
     * @see #X_AXIS
     */
    public function SoftBoxLayout(axis:Number, gap:Number){
    	setAxis(axis);
    	setGap(gap);
    }
    	
    /**
     * Sets new axis.
     * @param axis new axis
     */
    public function setAxis(axis:Number):Void {
    	this.axis = (axis == undefined ? X_AXIS : axis);
    }
    
    /**
     * Gets axis.
     * @return axis
     */
    public function getAxis():Number {
    	return axis;	
    }
    
    /**
     * Sets new gap.
     * @param get new gap
     */	
    public function setGap(gap:Number):Void {
    	this.gap = (gap == undefined ? 0 : gap);
    }
    
    /**
     * Gets gap.
     * @return gap
     */
    public function getGap():Number {
    	return gap;	
    }
    	
	/**
	 * return target.getSize();
	 */
    public function preferredLayoutSize(target:Container):Dimension{
    	var count:Number = target.getComponentCount();
    	var insets:Insets = target.getInsets();
    	var width:Number = 0;
    	var height:Number = 0;
    	var wTotal:Number = 0;
    	var hTotal:Number = 0;
    	for(var i:Number=0; i<count; i++){
    		var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		var size:Dimension = c.getPreferredSize();
	    		width = Math.max(width, size.width);
	    		height = Math.max(height, size.height);
	    		var g:Number = i > 0 ? gap : 0;
	    		wTotal += (size.width + g);
	    		hTotal += (size.height + g);
    		}
    	}
    	if(axis == Y_AXIS){
    		height = hTotal;
    	}else{
    		width = wTotal;
    	}
    	
    	var dim:Dimension = new Dimension(width, height);
    	return insets.roundsSize(dim);
    }

	/**
	 * target.getSize();
	 */
    public function minimumLayoutSize(target:Container):Dimension{
    	var count:Number = target.getComponentCount();
    	var insets:Insets = target.getInsets();
    	var width:Number = 0;
    	var height:Number = 0;
    	var wTotal:Number = 0;
    	var hTotal:Number = 0;
    	for(var i:Number=0; i<count; i++){
    		var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		var size:Dimension = c.getMinimumSize();
	    		width = Math.max(width, size.width);
	    		height = Math.max(height, size.height);
	    		var g:Number = i > 0 ? gap : 0;
	    		wTotal += (size.width + g);
	    		hTotal += (size.height + g);
    		}
    	}
    	if(axis == Y_AXIS){
    		height = hTotal;
    	}else{
    		width = wTotal;
    	}
    	var dim:Dimension = new Dimension(width, height);
    	return insets.roundsSize(dim);
    }
    
	/**
	 * return new Dimension(Number.MAX_VALUE, Number.MAX_VALUE);
	 */
    public function maximumLayoutSize(target:Container):Dimension{
    	var count:Number = target.getComponentCount();
    	var insets:Insets = target.getInsets();
    	var width:Number = 0;
    	var height:Number = 0;
    	var wTotal:Number = 0;
    	var hTotal:Number = 0;
    	for(var i:Number=0; i<count; i++){
	    	var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		var size:Dimension = c.getMaximumSize();
	    		width = Math.max(width, size.width);
	    		height = Math.max(height, size.height);
	    		var g:Number = i > 0 ? gap : 0;
	    		wTotal += (size.width + g);
	    		hTotal += (size.height + g);
    		}
    	}
    	if(axis == Y_AXIS){
    		height = hTotal;
    	}else{
    		width = wTotal;
    	}
    	var dim:Dimension = new Dimension(width, height);
    	return insets.roundsSize(dim);
    }    
    
    /**
     * do nothing
     */
    public function layoutContainer(target:Container):Void{
    	var count:Number = target.getComponentCount();
    	var size:Dimension = target.getSize();
    	var insets:Insets = target.getInsets();
    	var rd:Rectangle = insets.getInsideBounds(size.getBounds());
    	var ch:Number = rd.height;
    	var cw:Number = rd.width;
    	var x:Number = rd.x;
    	var y:Number = rd.y;
    	for(var i:Number=0; i<count; i++){
    		var c:Component = target.getComponent(i);
    		if(c.isVisible()){
	    		var ps:Dimension = c.getPreferredSize();
	    		if(axis == Y_AXIS){
	    			c.setBounds(x, y, cw, ps.height);
	    			y += (ps.height + gap);
	    		}else{
	    			c.setBounds(x, y, ps.width, ch);
	    			x += (ps.width + gap);
	    		}
    		}
    	}
    }
    
	/**
	 * return 0.5
	 */
    public function getLayoutAlignmentX(target:Container):Number{
    	return 0.5;
    }

	/**
	 * return 0.5
	 */
    public function getLayoutAlignmentY(target:Container):Number{
    	return 0.5;
    }
}
