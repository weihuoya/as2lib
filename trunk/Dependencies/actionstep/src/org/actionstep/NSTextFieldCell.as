/* See LICENSE for copyright and terms of use */

import org.actionstep.ASFieldEditingProtocol;
import org.actionstep.ASFieldEditor;
import org.actionstep.ASTheme;
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.constants.NSLineBreakMode;
import org.actionstep.NSActionCell;
import org.actionstep.NSColor;
import org.actionstep.NSControl;
import org.actionstep.NSEvent;
import org.actionstep.NSFont;
import org.actionstep.NSRect;
import org.actionstep.NSView;
import org.actionstep.ASDraw;

/**
 * Draws an NSTextField.
 *
 * @author Rich Kilmer
 */
class org.actionstep.NSTextFieldCell extends NSActionCell
  implements ASFieldEditingProtocol {

  private var m_bezelStyle:NSBezelStyle;
  private var m_textColor:NSColor;
  private var m_backgroundColor:NSColor;
  private var m_borderColor:NSColor;
  private var m_drawsBackground:Boolean;
  private var m_beingEditedBy:Object;

  // Flash Text Field
  private var m_textField:TextField;
  private var m_textFormat:TextFormat;
  private var m_actionMask:Number;

  public function NSTextFieldCell() {
    m_drawsBackground = false;
    m_beingEditedBy = null;
    m_textField = null;
    m_textFormat = null;
    m_textColor = NSColor.systemFontColor();
    m_actionMask = NSEvent.NSKeyUpMask | NSEvent.NSKeyDownMask;
  }

  private function init():NSTextFieldCell {
    initTextCell("");
    return this;
  }

  public function initTextCell(string:String):NSTextFieldCell {
    super.initTextCell(string);
    m_drawsBackground = false;
    return this;
  }

  // Controlling rich text behavior

  //! Not dealing with the following
  /*
  – setAllowsEditingTextAttributes:
  – allowsEditingTextAttributes
  – setImportsGraphics:
  – importsGraphics
  */

  /**
   * Returns the cell's textfield. Will build if necessary.
   */
  private function textField():TextField {
    if (m_textField == null || m_textField._parent == undefined) {
      //
      // Build the text format and textfield
      //
      m_textField = m_controlView.createBoundsTextField();
      m_textFormat = m_font.textFormatWithAlignment(m_alignment);
      m_textFormat.color = m_textColor.value;
      m_textField.self = this;
      m_textField.text = stringValue();
      m_textField.embedFonts = m_font.isEmbedded();
      m_textField.selectable = false;
      m_textField.type = "dynamic";
      //
      // Assign the textformat.
      //
      m_textField.setTextFormat(m_textFormat);
    }

    return m_textField;
  }

  public function beginEditingWithDelegate(delegate:Object):ASFieldEditor {
    if (!isSelectable()) {
      return null;
    }
    if (m_textField != null && m_textField._parent != undefined) {
      m_textField.text = stringValue();
      var editor:ASFieldEditor = ASFieldEditor.startEditing(this, delegate, m_textField);
      return editor;
    }
    return null;
  }

  public function endEditingWithDelegate(delegate:Object):Void {
    ASFieldEditor.endEditing();
    m_textField.setTextFormat(m_textFormat);
  }

  public function setEditable(value:Boolean) {
    super.setEditable(value);
  }

  public function setSelectable(value:Boolean) {
    super.setSelectable(value);
  }

  public function setTextColor(value:NSColor) {
    m_textColor = value;
    m_textFormat.color = m_textColor.value;
    if (m_controlView && (m_controlView instanceof NSControl)) {
      NSControl(m_controlView).updateCell(this);
    }
  }

  public function textColor():NSColor {
    return m_textColor;
  }

  public function setFont(font:NSFont) {
    super.setFont(font);
    m_textFormat = m_font.textFormat();
    m_textFormat.color = m_textColor.value;
    if (m_textField != null) {
      m_textField.embedFonts = m_font.isEmbedded();
    }
  }

  public function setBackgroundColor(value:NSColor) {
    m_backgroundColor = value;
    if (m_controlView && (m_controlView instanceof NSControl)) {
      NSControl(m_controlView).updateCell(this);
    }
  }

  public function backgroundColor():NSColor {
    return m_backgroundColor;
  }

  public function setBorderColor(color:NSColor) {
    m_borderColor = color;
    if (m_controlView && (m_controlView instanceof NSControl)) {
      NSControl(m_controlView).updateCell(this);
    }
  }

  public function borderColor():NSColor {
    return m_borderColor;
  }

  public function setDrawsBackground(value:Boolean) {
    m_drawsBackground = value;
    if (m_controlView && (m_controlView instanceof NSControl)) {
      NSControl(m_controlView).updateCell(this);
    }
  }

  public function drawsBackground():Boolean {
    return m_drawsBackground;
  }

  public function setBezelStyle(value:NSBezelStyle) {
    m_bezelStyle = value;
  }

  public function bezelStyle():NSBezelStyle {
    return m_bezelStyle;
  }

  public function release():Void {
    if (m_textField != null) {
      m_textField.removeTextField();
      m_textField = null;
    }

    super.release();
  }

  private function validateTextField(cellFrame:NSRect) {
    var mc:MovieClip = m_controlView.mcBounds();

    var width:Number = cellFrame.size.width - 1;
    var height:Number = cellFrame.size.height - 1;
    var x:Number = cellFrame.origin.x;
    var y:Number = cellFrame.origin.y;
    var text:String = stringValue();
    var fontHeight:Number = m_font.getTextExtent("Why").height;
    //
    // Get the textfield. Will be built if necessary.
    //
    var tf:TextField = textField();

    var drawingBackground:Boolean = m_drawsBackground;
    if (!drawingBackground) {
      if (m_backgroundColor) {
        drawingBackground = true;
      }
    }

    //
    // Position the text field.
    //
    tf._x = x+(drawingBackground ? 3 : 0);
    tf._y = y + (drawingBackground ? (height - fontHeight)/2 : 0);
    tf._width = width-1;
    tf._height = fontHeight;

    //
    // Truncate the string value if necessary.
    //
    if (m_font.getTextExtent(text).width + tf._x > cellFrame.maxX()) {
	  switch (m_lineBreakMode) {
	    case NSLineBreakMode.NSDefaultLineBreak:
	      break;

	    case NSLineBreakMode.NSLineBreakByTruncatingHead:
	      text = truncateTextWithLeadingEllipsis(text, tf._width);
	      break;

	    case NSLineBreakMode.NSLineBreakByTruncatingMiddle:
	      text = truncateTextWithMiddleEllipsis(text, tf._width);
	      break;

	    case NSLineBreakMode.NSLineBreakByTruncatingTail:
	      text = truncateTextWithTrailingEllipsis(text, tf._width);
	      break;
	  }
	  m_isTruncated = true;
    } else {
      m_isTruncated = false;
    }

    //
    // Set the font and text format if necessary.
    //
    if (tf.text != text) {
      tf.text = text;
    }

    if (tf.getTextFormat() != m_textFormat) {
      tf.setTextFormat(m_textFormat);
    }
  }

  public function drawWithFrameInView(cellFrame:NSRect, inView:NSView) {
    if (m_controlView != inView) {
      m_controlView = inView;
    }
    if (m_drawsBackground) {
      ASTheme.current().drawTextFieldWithRectInView(cellFrame, inView);
	  } else {
	    if (m_backgroundColor) {
	      ASDraw.fillRectWithRect(m_controlView.mcBounds(), cellFrame, m_backgroundColor.value, m_backgroundColor.alphaValue);
	    }
	    if (m_borderColor) {
	      ASDraw.drawRectWithRect(m_controlView.mcBounds(), cellFrame.sizeRectLeftRightTopBottom(0,1,0,1), m_borderColor.value, m_borderColor.alphaValue);
	    }
	  }
    if (m_showsFirstResponder) {
      ASTheme.current().drawFirstResponderWithRectInView(cellFrame, inView);
    }
    if (ASFieldEditor.instance().cell() != this) {
      validateTextField(cellFrame);
    }
  }
}
