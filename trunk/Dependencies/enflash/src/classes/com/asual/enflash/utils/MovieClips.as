class com.asual.enflash.utils.MovieClips {
	
	/**
	 * Draws a simple rectangle.<br />
	 * Example:<br />
	 * <code>
	 * mc.clear();<br />
	 * mc.beginFill(0xFF0000);<br />
	 * MovieClips.simpleRect(mc, 10, 10, 100, 100);<br />
	 * </code>
	 * 
	 * @param mc The movieclip in which the rectangle will be drawn
	 * @param x The x coordinate where the rectangle starts
	 * @param y The y coordinate where the rectangle starts
	 * @param w The width of the rectangle
	 * @param h The height of the rectangle
	 */
	public static function simpleRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number):Void {
		
		mc.moveTo(x, y);
		mc.lineTo(x + w, y);
		mc.lineTo(x + w, y + h);
		mc.lineTo(x, y + h);
		mc.lineTo(x, y);
	}

	/**
	 * Draws a rectangle with rounded corners.<br />
	 * Example:<br />
	 * <code>
	 * mc.clear();<br />
	 * mc.lineStyle(1, 0x000000);<br />
	 * MovieClips.simpleRect(mc, 10, 10, 100, 100, 3);<br />
	 * </code>
	 * 
	 * @param mc The movieclip in which the rectangle will be drawn
	 * @param x The x coordinate where the rectangle starts
	 * @param y The y coordinate where the rectangle starts
	 * @param w The width of the rectangle
	 * @param h The height of the rectangle
	 * @param r Rounding parameter
	 */	
	public static function roundRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number, r:Number):Void {
		
		if (r == undefined) r = 3;
		
		mc.moveTo(x + r, y);
		//top line
		mc.lineTo(x + w - r, y);
		//tr corner
		mc.curveTo(x + w, y, x + w, y + r);
		//right line
		mc.lineTo(x + w, y + h - r);
		//br corner
		mc.curveTo(x + w, y + h, x + w - r, y + h);
		// bottom line
		mc.lineTo(x + r, y + h);
		//bl corner
		mc.curveTo(x, y + h, x, y + h - r);
		// left line
		mc.lineTo(x, y + r);
		//tl corner
		mc.curveTo(x, y, x + r, y);
	}
	
}