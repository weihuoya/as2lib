﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.ASColor;
import org.aswing.border.Border;
import org.aswing.border.DecorateBorder;
import org.aswing.Component;
import org.aswing.geom.Rectangle;
import org.aswing.graphics.AdvancedPen;
import org.aswing.graphics.Graphics;
import org.aswing.Insets;

/**
 * A class which implements a simple 2 line bevel border.
 * @author iiley
 */
class org.aswing.border.BevelBorder extends DecorateBorder {
	
    /** Raised bevel type. */
    public static var RAISED:Number  = 0;
    /** Lowered bevel type. */
    public static var LOWERED:Number = 1;

    private var bevelType:Number;
    private var highlightOuter:ASColor;
    private var highlightInner:ASColor;
    private var shadowInner:ASColor;
    private var shadowOuter:ASColor;

    /**
     * BevelBorder()<br> default bevelType to LOWERED<br>
     * BevelBorder(interior:Border, bevelType:Number)<br>
     * Creates a bevel border with the specified type and whose
     * colors will be derived from the background color of the
     * component passed into the paintBorder method.
     * <p>
     * BevelBorder(interior:Border, bevelType:Number, highlight:ASColor, shadow:ASColor)<br>
     * Creates a bevel border with the specified type, highlight and
     * shadow colors.
     * <p>
     * BevelBorder(interior:Border, bevelType:Number, highlightOuterColor:ASColor, highlightInnerColor:ASColor, shadowOuterColor:ASColor, shadowInnerColor:ASColor)<br>
     * Creates a bevel border with the specified type, specified four colors.
     * @param interior the border in this border
     * @param bevelType the type of bevel for the border
     * @param highlightOuterColor the color to use for the bevel outer highlight
     * @param highlightInnerColor the color to use for the bevel inner highlight
     * @param shadowOuterColor the color to use for the bevel outer shadow
     * @param shadowInnerColor the color to use for the bevel inner shadow
     */
    public function BevelBorder(interior:Border, bevelType:Number, highlightOuterColor:ASColor, 
                       highlightInnerColor:ASColor, shadowOuterColor:ASColor, 
                       shadowInnerColor:ASColor) {
        super(interior);
        this.bevelType = bevelType;
        if(highlightInnerColor != undefined && shadowOuterColor == undefined){
        	this.highlightOuter = highlightOuterColor.brighter();
        	this.highlightInner = highlightOuterColor;
        	this.shadowOuter = shadowOuterColor;
        	this.shadowInner = shadowOuterColor.brighter();
        }else{
        	this.highlightOuter = highlightOuterColor;
        	this.highlightInner = highlightInnerColor;
        	this.shadowOuter = shadowOuterColor;
        	this.shadowInner = shadowInnerColor;
        }
    }


    public function paintBorderImp(c:Component, g:Graphics, b:Rectangle):Void{
        if (bevelType == RAISED) {
             paintRaisedBevel(c, g, b.x, b.y, b.width, b.height);
        }else{
             paintLoweredBevel(c, g, b.x, b.y, b.width, b.height);
        }
    }
    
    public function getBorderInsetsImp(c:Component, bounds:Rectangle):Insets{
    	return new Insets(2, 2, 2, 2);
    }

    /**
     * Returns the outer highlight color of the bevel border
     * when rendered on the specified component.  If no highlight
     * color was specified at instantiation, the highlight color
     * is derived from the specified component's background color.
     * @param c the component for which the highlight may be derived
     */
    public function getHighlightOuterColorWith(c:Component):ASColor{
        var highlight:ASColor = getHighlightOuterColor();
        if(highlight == undefined){
        	highlight = c.getBackground().brighter().brighter();
        }
        return highlight;
    }

    /**
     * Returns the inner highlight color of the bevel border
     * when rendered on the specified component.  If no highlight
     * color was specified at instantiation, the highlight color
     * is derived from the specified component's background color.
     * @param c the component for which the highlight may be derived
     */
    public function getHighlightInnerColorWith(c:Component):ASColor{
        var highlight:ASColor = getHighlightInnerColor();
        if(highlight == undefined){
        	highlight = c.getBackground().brighter();
        }
        return highlight;
    }

    /**
     * Returns the inner shadow color of the bevel border
     * when rendered on the specified component.  If no shadow
     * color was specified at instantiation, the shadow color
     * is derived from the specified component's background color.
     * @param c the component for which the shadow may be derived
     */
    public function getShadowInnerColorWith(c:Component):ASColor{
        var shadow:ASColor = getShadowInnerColor();
        if(shadow == undefined){
        	shadow = c.getBackground().darker();
        }
        return shadow ;
                                    
    }

    /**
     * Returns the outer shadow color of the bevel border
     * when rendered on the specified component.  If no shadow
     * color was specified at instantiation, the shadow color
     * is derived from the specified component's background color.
     * @param c the component for which the shadow may be derived
     */
    public function getShadowOuterColorWith(c:Component):ASColor{
        var shadow:ASColor = getShadowOuterColor();
        if(shadow == undefined){
        	shadow = c.getBackground().darker().darker();
        }
        return shadow ;
    }

    /**
     * Returns the outer highlight color of the bevel border.
     * Will return null if no highlight color was specified
     * at instantiation.
     */
    public function getHighlightOuterColor():ASColor{
        return highlightOuter;
    }

    /**
     * Returns the inner highlight color of the bevel border.
     * Will return null if no highlight color was specified
     * at instantiation.
     */
    public function getHighlightInnerColor():ASColor{
        return highlightInner;
    }

    /**
     * Returns the inner shadow color of the bevel border.
     * Will return null if no shadow color was specified
     * at instantiation.
     */
    public function getShadowInnerColor():ASColor{
        return shadowInner;
    }

    /**
     * Returns the outer shadow color of the bevel border.
     * Will return null if no shadow color was specified
     * at instantiation.
     */
    public function getShadowOuterColor():ASColor{
        return shadowOuter;
    }

    /**
     * Returns the type of the bevel border.
     */
    public function getBevelType():Number{
        return bevelType;
    }

    private function paintRaisedBevel(c:Component, g:Graphics, x:Number, y:Number,
                                    width:Number, height:Number):Void  {
        var h:Number = height;
        var w:Number = width;
        x += 0.5;
        y += 0.5;
        w -= 1;
        h -= 1;
        var pen:AdvancedPen = new AdvancedPen(getHighlightOuterColorWith(c), 1, undefined, "normal", "square", "miter");
        g.drawLine(pen, x, y, x, y+h-2);
        g.drawLine(pen, x+1, y, x+w-2, y);
		
		pen.setASColor(getHighlightInnerColorWith(c));
        g.drawLine(pen, x+1, y+1, x+1, y+h-3);
        g.drawLine(pen, x+2, y+1, x+w-3, y+1);

		pen.setASColor(getShadowOuterColorWith(c));
        g.drawLine(pen, x, y+h-1, x+w-1, y+h-1);
        g.drawLine(pen, x+w-1, y, x+w-1, y+h-2);

		pen.setASColor(getShadowInnerColorWith(c));
        g.drawLine(pen, x+1, y+h-2, x+w-2, y+h-2);
        g.drawLine(pen, x+w-2, y+1, x+w-2, y+h-3);

    }

    private function paintLoweredBevel(c:Component, g:Graphics, x:Number, y:Number,
                                    width:Number, height:Number):Void  {
        var h:Number = height;
        var w:Number = width;
        x += 0.5;
        y += 0.5;
        w -= 1;
        h -= 1;
        var pen:AdvancedPen = new AdvancedPen(getShadowInnerColorWith(c), 1, undefined, "normal", "square", "miter");
        g.drawLine(pen, x, y, x, y+h-1);
        g.drawLine(pen, x+1, y, x+w-1, y);

       	pen.setASColor(getShadowOuterColorWith(c));
        g.drawLine(pen, x+1, y+1, x+1, y+h-2);
        g.drawLine(pen, x+2, y+1, x+w-2, y+1);

        pen.setASColor(getHighlightOuterColorWith(c));
        g.drawLine(pen, x+1, y+h-1, x+w-1, y+h-1);
        g.drawLine(pen, x+w-1, y+1, x+w-1, y+h-2);

        pen.setASColor(getHighlightInnerColorWith(c));
        g.drawLine(pen, x+2, y+h-2, x+w-2, y+h-2);
        g.drawLine(pen, x+w-2, y+2, x+w-2, y+h-3);
    }

}