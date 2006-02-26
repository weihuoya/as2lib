/* See LICENSE for copyright and terms of use */

import org.actionstep.NSDictionary;

/**
 * This class represents a formatted string.
 * 
 * It is not yet used extensively.
 * 
 * @author Richard Kilmer
 */
class org.actionstep.NSAttributedString extends org.actionstep.NSObject {
  
  private var m_string:String;
  private var m_htmlString:String;
  
  public static function attributedStringWithHTML(html:String):NSAttributedString {
    var result:NSAttributedString = new NSAttributedString();
    result.initWithHTMLDocumentAttributes(html, null);
    return result;
  }
  
  public function NSAttributedString() {
    m_string = null;
    m_htmlString = null;
  }
  
  public function initWithString(string:String):NSAttributedString {
    m_string = string;
    return this;
  }
  
  public function initWithHTMLDocumentAttributes(html:String, docAttributes:NSDictionary):NSDictionary {
    m_htmlString = html;
    return null;
  }
  
  public function string():String {
    if (m_string == null) {
      return getNonHTMLText();
    }
    return m_string;
  }
  
  public function htmlString():String {
    if (m_string==null) {
      return m_htmlString;
    } else {
      return m_string;
    }
  }
  
  public function isFormatted():Boolean {
    return m_htmlString != null ? true : false;
  }
  
  public function length():Number {
    return m_string.length;
  }
  
  public function description():String {
    var result:String = "NSAttributedString(value='"+htmlString()+"', formatted='"+isFormatted()+"')";
    return result;
  } 
  
  private function getNonHTMLText():String
  {
    var control:TextField = _root.m_attributedString;

    if (control == undefined)
    {
      _root.createTextField("m_attributedString", -16383, 0, 0, 1000, 100);
      control = _root.m_attributedString;
      control._visible = false;
      control.html = true;
    }
    
    control.htmlText = m_htmlString;
    return control.text;
  }

}