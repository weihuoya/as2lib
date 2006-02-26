/* See LICENSE for copyright and terms of use */

import org.actionstep.NSObject;
import org.actionstep.NSCopying;
import org.actionstep.ASColors;

/**
 * An NSColor object represents a color, which is defined in a color space,
 * each point of which has a set of components (such as red, green, and blue)
 * that uniquely define a color.
 *
 * For examples of this class' usage, please see
 * <code>org.actionstep.test.ASTestColor</code>.
 *
 * @author Scott Hyndman
 */
class org.actionstep.NSColor extends NSObject implements NSCopying
{
	private static var MODE_RGB:Number	= 0;
	private static var MODE_HSB:Number	= 1;
	private static var MODE_CMYK:Number	= 2;

	private var m_mode:Number;

	/** The opacity of the color. (0.0 to 1.0) */
	private var m_alpha:Number;

	//
	// Red Green Blue RGB Color Space (all values between 0.0 and 1.0)
	//
	private var m_red:Number;
	private var m_green:Number;
	private var m_blue:Number;

	//
	// Hue Saturation Brightness (HSB) color space (all values between 0.0 and 1.0)
	//
	private var m_hue:Number;
	private var m_saturation:Number;
	private var m_brightness:Number;

	public var value:Number; // set to hex
	public var alphaValue:Number; // this is the alpha value from 0 to 100 based on m_alpha

	//
	// System colors
	//
	private static var g_systemFontColor:NSColor;

	//
	// Control colors
	//
	private static var g_controlBackgroundColor:NSColor = new NSColor(0xEEEEEE);

	//
	// Menu colors
	//
	private static var g_selectedMenuItemColor:NSColor = new NSColor(0x227CE8);
	private static var g_selectedMenuItemTextColor:NSColor = new NSColor(0xFFFFFF);

	//
	// Text colors
	//
	private static var g_textColor:NSColor = new NSColor(0x000000);

	/**
	 * Creates a new instance of NSColor with an alpha of 1.0 and a color value
	 * of <code>value</code>.
	 *
	 * If <code>value</code> is not specified, the color will be black.
	 */
	public function NSColor(value:Number)
	{
		//
		// Range checks.
		//
		if (value > 0xFFFFFF) {
			value = 0xFFFFFF;
		}
		else if (null == value || value < 0x000000) {
			value = 0x000000;
		}

		this.value = value;

		init();
	}

	/**
	 * Initializes the color.
	 */
	private function init():Void
	{
		m_alpha = 1;
		alphaValue = m_alpha*100;
		calculateRGBAFromValue();
		calculateHSBFromRGB();
	}

	//******************************************************
	//*                    Properties
	//******************************************************

	/**
	 * Returns the receiver's alpha (opacity) component. Returns 1.0 (opaque)
	 * if the receiver has no alpha component.
	 */
	public function alphaComponent():Number
	{
		return m_alpha;
	}


	/**
	 * @see org.actionstep.NSObject#description()
	 */
	public function description():String
	{
		return "NSColor(" +
			"value=" + value + ", " +
			"red=" + m_red + ", " +
			"green=" + m_green + ", " +
			"blue=" + m_blue + ", " +
			"alpha=" + m_alpha + ", " +
			"hue=" + m_hue + ", " +
			"saturation=" + m_saturation + ", " +
			"brightness=" + m_brightness +
			")";
	}

	//******************************************************
	//*                 RGB Properties
	//******************************************************

	/**
	 * Returns the receiver's blue component. Raises an exception if the
	 * receiver isn't an RGB color.
	 */
	public function blueComponent():Number
	{
		return m_blue;
	}


	/**
	 * Returns the receiver's green component. Raises an exception if the
	 * receiver isn't an RGB color.
	 */
	public function greenComponent():Number
	{
		return m_green;
	}


	/**
	 * Returns the receiver's red component. Raises an exception if the
	 * receiver isn't an RGB color.
	 */
	public function redComponent():Number
	{
		return m_red;
	}

	//******************************************************
	//*                   HSB Properties
	//******************************************************

	/**
	 * Returns the receiver's brightness component. Raises an exception if the
	 * receiver isn't an HSB color.
	 */
	public function brightnessComponent():Number
	{
		return m_brightness;
	}


	/**
	 * Returns the receiver's hue component. Raises an exception if the
	 * receiver isn't an HSB color.
	 */
	public function hueComponent():Number
	{
		return m_hue;
	}


	/**
	 * Returns the receiver's red component. Raises an exception if the
	 * receiver isn't an HSB color.
	 */
	public function saturationComponent():Number
	{
		return m_saturation;
	}

	//******************************************************
	//*                 Public Methods
	//******************************************************

	/**
	 * Creates a complete copy of this colour.
	 */
	public function copyWithZone():NSObject
	{
		return NSColor(memberwiseClone());
	}

	/**
	 * Returns this color's hex representation as a string in the following
	 * format: "ABCDEF"
	 *
	 * This can be useful for generating colors for HTML or CSS.
	 */
	public function hexString():String
	{
		//
		// Get the hexidecimal string values for each component.
		//
		var r:String = m_red.toString(16);
		var g:String = m_green.toString(16);
		var b:String = m_blue.toString(16);

		//
		// Concatenate a leading 0 if necessary.
		//
		r = (r.length < 2) ? "0" + r : r;
		g = (g.length < 2) ? "0" + g : g;
		b = (b.length < 2) ? "0" + b : b;

		return (r + g + b).toUpperCase();
	}

	//******************************************************
	//*                   Operations
	//******************************************************

	/**
	 * Creates and returns a new color who's brightness has been adjusted by
	 * the amount of <code>delta</code>. <code>delta</code> should be between
	 * 0.0 and 1.0.
	 *
	 * This method can have the effect of darkening or brightening a color. If
	 * <code>delta</code> is negative, the color will be darkened. If
	 * <code>delta</code> is positive, the color will be brightened.
	 */
	public function adjustColorBrightnessByDelta(delta:Number):NSColor
	{
		return NSColor.colorWithCalibratedHueSaturationBrightnessAlpha(
			m_hue, m_saturation, m_brightness + delta, m_alpha);
	}

	/**
	 * Creates and returns a new color who's brightness has been adjusted by
	 * a factor of <code>factor</code>, which means this color's
	 * brightness is multiplied by <code>factor</code> to yield the new
	 * color's brightness.
	 *
	 * This method can have the effect of darkening or brightening a color. If
	 * <code>factor</code> is between 0.0 and 1.0, the color will be darkened.
	 * If <code>factor</code> is greater than 1.0, the color will be brightened.
	 */
	public function adjustColorBrightnessByFactor(factor:Number):NSColor
	{
		return NSColor.colorWithCalibratedHueSaturationBrightnessAlpha(
			m_hue, m_saturation, m_brightness * factor, m_alpha);
	}

	/**
	 * Returns <code>true</code> if the color value and alpha of
	 * <code>color</code> are the same as this color's.
	 */
	public function isEqual(color:NSObject):Boolean
	{
		var c:NSColor = NSColor(color);
		return this.value == c.value
			&& this.alphaComponent() == c.alphaComponent();
	}

	//******************************************************
	//*                 Private Methods
	//******************************************************

	/**
	 * Returns a hexidecimal representation of the color.
	 */
	private function calculateValueFromRGB():Void
	{
		value = ((m_red * 255) << 16 | (m_green * 255) << 8 | (m_blue * 255));
	}

	/**
	 * Calculates the RGB values from a single number.
	 */
	private function calculateRGBAFromValue():Void
	{
		m_red 	= ((value & 0xFF0000) >> 16) / 255;
		m_green = ((value & 0x00FF00) >> 8) / 255;
		m_blue 	= (value & 0x0000FF) / 255;
	}

	/**
	 * Calculates and sets HSB values based on the color's RGB values.
	 */
	private function calculateHSBFromRGB():Void
	{
		var h:Number = 0, s:Number, b:Number, min:Number;
		var r:Number = m_red * 255, g:Number = m_green * 255,
			bl:Number = m_blue * 255;

		//
		// Calculate brightness and saturation
		//
		min = Math.min(Math.min(r, g), bl);
		b = Math.max(Math.max(r, g), bl);
		s = (b <= 0) ? 0 : Math.round(100 * (b - min) / b);
		b = Math.round((b / 255) * 100);

		//
		// Calculate hue
		//
		if ((r == g) && (g == bl))
			h = 0;
		else if (r >= g && g >= bl)
			h = 60 * (g - bl) / (r - bl);
		else if (g >= r && r >= bl)
			h = 60 + 60 * (g - r) / (g - bl);
		else if (g >= bl && bl >= r)
			h = 120 + 60 * (bl - r) / (g - r);
		else if (bl >= g && g >= r)
			h = 180 + 60 * (bl - g) / (bl - r);
		else if (bl >= r && r >= g)
			h = 240 + 60 * (r - g) / (bl - g);
		else if (r >= bl && bl >= g)
			h = 300 + 60 * (r - bl) / (r - g);
		else
			h = 0;

		h = Math.round(h);

		//
		// Set values
		//
		m_hue = h / 360;
		m_saturation = s / 100;
		m_brightness = b / 100;
	}

	/**
	 * Calculates and sets the RGB values of this color based on its HSB values.
	 */
	private function calculateRGBFromHSB():Void
	{
		var h:Number = m_hue * 255;
		var s:Number = m_saturation * 255;
		var v:Number = m_brightness * 255;

		var r:Number = v * 255;
		var g:Number = v * 255;
		var b:Number = v * 255;

		var max:Number = v;
		var dif:Number = v * s / 255;
		var min:Number = v - dif;

		h = h * 360 / 255;

		if (h < 60)
		{
			r = max;
			g = h * dif / 60 + min;
			b = min;
		}
		else if (h < 120)
		{
			r = -(h - 120) * dif / 60 + min;
			g = max;
			b = min;
		}
		else if (h < 180)
		{
			r = min;
			g = max;
			b = (h - 120) * dif / 60 + min;
		}
		else if (h < 240)
		{
			r = min;
			g = -(h - 240) * dif / 60 + min;
			b = max;
		}
		else if (h < 300)
		{
			r = (h - 240) * dif / 60 + min;
			g = min;
			b = max;
		}
		else if (h <= 360)
		{
			r = max;
			g = min;
			b = -(h - 360) * dif / 60 + min;
		}
		else
		{
			r = 0;
			g = 0;
			b = 0;
		}

		m_red = Math.max(r / 255, 0);
		m_green = Math.max(g / 255, 0);
		m_blue = Math.max(b / 255, 0);
	}

	//******************************************************
	//*                   System Colors
	//******************************************************

	public static function systemFontColor():NSColor {
		if (g_systemFontColor == undefined) {
			return ASColors.blackColor();
		}
		return g_systemFontColor;
	}

	public static function setSystemFontColor(color:NSColor) {
		g_systemFontColor = color;
	}

	public static function controlBackgroundColor():NSColor {
		return NSColor(g_controlBackgroundColor.copyWithZone());
	}

	public static function selectedMenuItemColor():NSColor {
		return NSColor(g_selectedMenuItemColor.copyWithZone());
	}

	public static function selectedMenuItemTextColor():NSColor {
		return NSColor(g_selectedMenuItemTextColor.copyWithZone());
	}

	public static function textColor():NSColor {
		return NSColor(g_textColor.copyWithZone());
	}


	//******************************************************
	//*                 Class Constructors
	//******************************************************

	/**
	 * Creates and returns an NSColor with the color <code>hexValue</code>
	 * and an alpha of <code>alpha</code>.
	 *
	 * <code>hexValue</code> should be between 0x000000 and 0xFFFFFF.
	 * <code>alpha</code> should be between 0.0 and 1.0.
	 */
	public static function colorWithHexValueAlpha(hexValue:Number,
		alpha:Number):NSColor
	{
		//
		// Deal with out of range values.
		//
		if (alpha == null || alpha > 1)
			alpha = 1;
		else if (alpha < 0)
			alpha = 0;

		//
		// Create and return the color.
		//
		var c:NSColor = new NSColor(hexValue);
		c.m_alpha = alpha;
		c.alphaValue = alpha*100;
		return c;
	}

	/**
	 * Creates and returns an NSColor whose opacity value is alpha and whose
	 * RGB components are red, green, and blue. (Values below 0.0 are
	 * interpreted as 0.0, and values above 1.0 are interpreted as 1.0.)
	 */
	public static function colorWithCalibratedRedGreenBlueAlpha(red:Number,
		green:Number, blue:Number, alpha:Number):NSColor
	{
		//
		// Deal with out of range values
		//
		if (red > 1)
			red = 1;
		else if (red < 0)
			red = 0;

		if (green > 1)
			green = 1;
		else if (green < 0)
			green = 0;

		if (blue > 1)
			blue = 1;
		else if (blue < 0)
			blue = 0;

		if (alpha == null || alpha > 1)
			alpha = 1;
		else if (alpha < 0)
			alpha = 0;

		//
		// Create an return color.
		//
		var c:NSColor = new NSColor();
		c.m_red = red;
		c.m_green = green;
		c.m_blue = blue;
		c.m_alpha = alpha;
		c.alphaValue = alpha*100;
		c.calculateValueFromRGB();
		c.calculateHSBFromRGB();

		return c;
	}


	/**
	 * Creates and returns an NSColor whose opacity value is alpha and whose
	 * grayscale value is white. (Values below 0.0 are interpreted as 0.0, and
	 * values above 1.0 are interpreted as 1.0.)
	 */
	public static function colorWithCalibratedWhiteAlpha(white:Number, alpha:Number):NSColor
	{
		//
		// Deal with out of range values.
		//
		if (white > 1)
			white = 1;
		else if (white < 0)
			white = 0;

		if (alpha == null || alpha > 1)
			alpha = 1;
		else if (alpha < 0)
			alpha = 0;

		//
		// Create an return color.
		//
		var c:NSColor = new NSColor();
		c.m_red = white;
		c.m_green = white;
		c.m_blue = white;
		c.m_alpha = alpha;
		c.alphaValue = alpha*100;
		c.calculateValueFromRGB();
		c.calculateHSBFromRGB();

		return c;
	}

	/**
	 * Creates and returns a new color with the alpha value of
	 * <code>alpha</code> and HSB values of <code>hue</code>,
	 * <code>saturation</code> and <code>brightness</code> respectively.
	 *
	 * All arguments should be between 0.0 and 1.0.
	 */
	public static function colorWithCalibratedHueSaturationBrightnessAlpha(
		hue:Number, saturation:Number, brightness:Number, alpha:Number):NSColor
	{
		//
		// Deal with out of range values
		//
		if (hue > 1)
			hue = 1;
		else if (hue < 0)
			hue = 0;

		if (saturation > 1)
			saturation = 1;
		else if (saturation < 0)
			saturation = 0;

		if (brightness > 1)
			brightness = 1;
		else if (brightness < 0)
			brightness = 0;

		if (alpha > 1)
			alpha = 1;
		else if (alpha < 0)
			alpha = 0;

		//
		// Create and return color.
		//
		var c:NSColor = new NSColor();
		c.m_hue = hue;
		c.m_saturation = saturation;
		c.m_brightness = brightness;
		c.m_alpha = alpha;
		c.alphaValue = alpha*100;
		c.calculateRGBFromHSB();
		c.calculateValueFromRGB();

		return c;
	}
}