/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.NSTextAlignment;
import org.actionstep.NSException;
import org.actionstep.NSSize;

/**
 * <p>This class represents a font. It provides methods to access and modify
 * a font's characteristics, calculates font metrics and can convert itself
 * into a <code>TextFormat</code> object.</p>
 * 
 * <p>This class differs extensively from the spec.</p> 
 * 
 * @author Scott Hyndman
 * @author Richard Kilmer
 */
class org.actionstep.NSFont extends org.actionstep.NSObject {
  
  //******************************************************															 
  //*                   Constants
  //******************************************************
  
  public static var ASDefaultSystemFontName:String = "Arial";
  
  //******************************************************															 
  //*                  Class members
  //******************************************************
  
  private static var g_system_font_name:String;
  private static var g_system_font_embedded:Boolean = false;
  private static var g_system_font_size:Number = 12;
  
  //******************************************************															 
  //*                 Member variables
  //******************************************************
  
  private var m_pointSize:Number;
  private var m_fontName:String;
  private var m_isBold:Boolean;
  private var m_isEmbedded:Boolean;
  
  //******************************************************															 
  //*                   Construction
  //******************************************************
  
  /**
   * Creates a new instance of the <code>NSFont</code> class.
   */
  public function NSFont() {
    m_isBold = false;
    m_isEmbedded = false;
    m_fontName = g_system_font_name == null ? ASDefaultSystemFontName :
      g_system_font_name;
    m_pointSize = g_system_font_size;
  }
  
  //******************************************************															 
  //*               Describing the object
  //******************************************************
  
  /**
   * Returns a string representation of the font.
   */
  public function description():String {
    return "NSFont(fontName=" + m_fontName + ", pointSize=" + m_pointSize 
      + ", bold=" + m_isBold + ")";
  }
  
  //******************************************************															 
  //*               Comparing the object
  //******************************************************
  
  /**
   * Returns <code>true</code> if this font is equal to <code>other</code>,
   * otherwise returns <code>false</code>.
   */
  public function isEqual(other:NSFont):Boolean {
    return m_fontName == other.fontName()
      && m_isBold == other.isBold()
      && m_pointSize == other.pointSize()
      && m_isEmbedded == other.isEmbedded();
  }
  
  //******************************************************															 
  //*          Setting / getting font names
  //******************************************************
  
  /**
   * Sets the name of the font to <code>value</code>.
   */
  public function setFontName(value:String) {
    m_fontName = value;
  }
  
  /**
   * Returns the name of the font.
   */
  public function fontName():String {
    return m_fontName;
  }
  
  //******************************************************															 
  //*     Setting / getting display characteristics
  //******************************************************
  
  /**
   * Sets the point size of the font to <code>value</code>.
   */
  public function setPointSize(value:Number) {
    m_pointSize = value;
  }
  
  /**
   * Returns the point size of the font.
   */
  public function pointSize():Number {
    return m_pointSize;
  }
  
  /**
   * <p>Returns <code>true</code> if the font is bold, or <code>false</code> if it
   * is not.</p>
   * 
   * <p>This is an ActionStep specific function.</p> 
   */  
  public function isBold():Boolean {
    return m_isBold;    
  }
  
  /**
   * <p>Sets the bold property of the font. If <code>value</code> is 
   * <code>true</code>, the font will be bold. If <code>false</code>, the font
   * will be normal.</p>
   * 
   * <p>This is an ActionStep specific function.</p> 
   */  
  public function setBold(value:Boolean) {
    m_isBold = value;
  }
  
  //******************************************************															 
  //*                 Embedded fonts
  //******************************************************
  
  /**
   * <p>Returns if this font is based on an embedded font (must be a symbol in the 
   * Library)</p>
   * 
   * <p>This method is ActionStep-only.</p>
   */
  public function isEmbedded():Boolean {
    return m_isEmbedded;
  }

  /**
   * <p>Sets if this is based on an embedded font (must be a symbol in the 
   * Library).</p>
   * 
   * <p>This method is ActionStep-only.</p>
   */
  public function setEmbedded(value:Boolean) {
    m_isEmbedded = value;
  }
  
  //******************************************************															 
  //*            Getting a fonts text format
  //******************************************************
  
  /**
   * <p>Returns the TextFormat object corresponding to this font's properties.</p>
   *
   * <p>This is an ActionStep specific function.</p> 
   */  
  public function textFormat():TextFormat {
    var tf:TextFormat = new TextFormat();
    tf.size = m_pointSize;
    tf.font = m_fontName;
    tf.bold = m_isBold;
    return tf;
  }
  
  /**
   * <p>Returns the TextFormat object corresponding to this font's properties and
   * an alignment object.</p>
   *
   * <p>This is an ActionStep specific function.</p>
   */  
  public function textFormatWithAlignment(alignment:NSTextAlignment):TextFormat
  {
  	var tf:TextFormat = textFormat();
  	var setting:String;
  	
    switch (alignment.value)
    {
      case 0:
        setting = "left";
        break;
    		
      case 1:
        setting = "right";
        break;

      case 2:
        setting = "center";
        break;

      case 4:
      	setting = "left"; //! should be set to localized setting...
      	break;
      	
      default:
		var e:NSException = NSException.exceptionWithNameReasonUserInfo(
			"UnsupportedOperationException", 
			"NSTextAlignment.NSNaturalTextAlignment" +
			" is not supported.", 
			null);
		trace(e);
		throw e;
        break;
      
    }
    
    tf.align = setting;
    
    return tf;
  }
  
  //******************************************************															 
  //*              Font metric information
  //******************************************************
  
  /**
   * <p>Returns the size of <code>aString</code> when rendered in this font on a 
   * single line.</p>
   *
   * <p>This is an ActionStep specific function.</p> 
   */
  public function getTextExtent(aString:String):NSSize
  {
    var measure:TextField = _root.m_textMeasurer;
    if (measure == undefined)
    {
      _root.createTextField("m_textMeasurer", -16384, 0, 0, 1000, 100);
      measure = _root.m_textMeasurer;
      measure._visible = false;
      measure.multiline = true;
    }
    
    var tf:TextFormat = this.textFormat();
    tf.align = "left";
    measure.text = aString;
    measure.setTextFormat(tf);
    
    return new NSSize(measure.textWidth + 4, measure.textHeight + 4);
  }

  /**
   * <p>Returns the size of <code>aString</code> when rendered in this font on a 
   * in an HTML text field.</p>
   *
   * <p>This is an ActionStep specific function.</p> 
   */
  public function getHTMLTextExtent(aString:String):NSSize
  {
    var measure:TextField = _root.m_htmlTextMeasurer;

    if (measure == undefined)
    {
      _root.createTextField("m_htmlTextMeasurer", -16383, 0, 0, 1000, 100);
      measure = _root.m_htmlTextMeasurer;
      measure._visible = false;
      measure.multiline = true;
      measure.html = true;
    }
    
    var tf:TextFormat = this.textFormat();
    tf.align = "left";
    measure.htmlText = aString;
    measure.setTextFormat(tf);
    
    return new NSSize(measure.textWidth + 4, measure.textHeight + 4);
  }
  
  //******************************************************															 
  //*                 Creating a font
  //******************************************************
  
  /**
   * Sets the system font defaults to a font called <code>name</code> with a
   * pointsize of <code>size</code>. If <code>embedded</code> is 
   * <code>true</code>, the default font should be embedded into the swf.
   */
  public static function setDefaultSystemFontNameSizeEmbedded(name:String, 
      size:Number, embedded:Boolean):Void {
    g_system_font_size = size;
    g_system_font_name = name;
    g_system_font_embedded = embedded;
  }

  /**
   * Returns the font with the name <code>name</code> and a pointsize of
   * <code>size</code>. If <code>embedded</code> is <code>true</code>, the
   * swf should contain font outline information. If <code>embedded</code> is
   * <code>false</code> the computer's font is used.
   */
  public static function fontWithNameSizeEmbedded(name:String, size:Number, 
      embedded:Boolean):NSFont {
    //! Implement correctly
    var font:NSFont = new NSFont();
    font.setFontName(name);
    font.setPointSize(size);
    font.setEmbedded(embedded);
    return font;
  }
  
  /**
   * Returns the font with the name <code>name</code> and a pointsize of
   * <code>size</code>.
   */
  public static function fontWithNameSize(name:String, size:Number):NSFont {
    return fontWithNameSizeEmbedded(name, size, false);
  }
  
  /**
   * Returns a system font with a size of <code>size</code>.
   */
  public static function systemFontOfSize(size:Number):NSFont {
    if (size <= 0) {
      size = g_system_font_size;
    }
    if (g_system_font_name == undefined) {
      g_system_font_name = ASDefaultSystemFontName;
    }
    return fontWithNameSizeEmbedded(g_system_font_name, size, g_system_font_embedded);
  }
  
  /**
   * Returns the a bold version of the system font with a size of 
   * <code>size</code>.
   */
  public static function boldSystemFontOfSize(size:Number):NSFont {
    var font:NSFont = systemFontOfSize(size);
    font.setBold(true);
    return font;
  }

  /**
   * Returns the font used for menus with the size <code>size</code>.
   */
  public static function menuFontOfSize(size:Number):NSFont {
    //! FIXME
    return systemFontOfSize(size);
  }
  
  /**
   * Returns the font used for tooltips with the size <code>size</code>.
   * 
   * Not used
   */
  public static function toolTipsFontOfSize(size:Number):NSFont {
    return systemFontOfSize(size);
  }
  
  /*
  + controlContentFontOfSize:
  + labelFontOfSize:
  + menuBarFontOfSize:
  + messageFontOfSize:
  + paletteFontOfSize:
  + titleBarFontOfSize:
  */
}