/* See LICENSE for copyright and terms of use */

import org.actionstep.ASTheme;
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.constants.NSCellImagePosition;
import org.actionstep.constants.NSControlSize;
import org.actionstep.constants.NSScrollArrowPosition;
import org.actionstep.constants.NSScrollerPart;
import org.actionstep.constants.NSUsableScrollerParts;
import org.actionstep.NSApplication;
import org.actionstep.NSButtonCell;
import org.actionstep.NSCell;
import org.actionstep.NSControl;
import org.actionstep.NSEvent;
import org.actionstep.NSImage;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSSize;

/**
 * <p>A horizontal or vertical scrollbar.</p>
 * 
 * <p>Used internally by an {@link org.actionstep.NSScrollView}.</p>
 * 
 * <p>For an example of this class' usage, please see
 * {@link org.actionstep.test.ASTestScrollers}.</p>
 * 
 * @author Richard Kilmer
 */
class org.actionstep.NSScroller extends NSControl {
  
  //******************************************************
  //*                   Constants
  //******************************************************
    
  private static var g_upCell:NSButtonCell;
  private static var g_downCell:NSButtonCell;
  private static var g_leftCell:NSButtonCell;
  private static var g_rightCell:NSButtonCell;

  //******************************************************
  //*                   Members
  //******************************************************
  
  private var m_upCell:NSButtonCell;
  private var m_downCell:NSButtonCell;
  private var m_leftCell:NSButtonCell;
  private var m_rightCell:NSButtonCell;
  
  private var m_hitPart:NSScrollerPart;
  private var m_arrowsPosition:NSScrollArrowPosition;
  private var m_floatValue:Number;
  private var m_usableParts:NSUsableScrollerParts;
  private var m_knobProportion:Number;
  private var m_pendingKnobProportion:Number;
  private var m_target:Object;
  private var m_action:String;
  private var m_enabled:Boolean;
  private var m_cellTrackingRect:NSRect;
  private var m_horizontal:Boolean;
  private var m_scrollerKnobClip:MovieClip;
  private var m_scrollerKnobClipRect:NSRect;
  private var m_delegate:Object;
  
  //TODO hackariffica - need better API for this, obviously
  public var m_borderAlphas:Array;
  
  //******************************************************
  //*                   Construction
  //******************************************************
  
  /**
   * Creates a new instance of the <code>NSScroller</code> class. 
   */
  public function NSScroller() {
    m_enabled = true;
    m_pendingKnobProportion = 0;
    m_scrollerKnobClipRect = new NSRect(0,0,0,0);
    m_borderAlphas = [100,100,100,100];
  }
  
  public function init():NSScroller {
    return initWithFrame(NSRect.ZeroRect);
  }
  
  public function initWithFrame(rect:NSRect):NSScroller {
    if (rect.size.width > rect.size.height) {
      m_horizontal = true;
      rect.size.height = scrollerWidth();
    } else {
      m_horizontal = false;
      rect.size.width = scrollerWidth();
    }
    super.initWithFrame(rect);
    m_arrowsPosition = NSScrollArrowPosition.NSScrollerArrowsDefaultSetting;
    if (m_horizontal) {
      m_floatValue = 0.0;
    } else {
      m_floatValue = 1.0;
    }
    m_knobProportion = .5;
    m_hitPart = NSScrollerPart.NSScrollerNoPart;    
    drawParts();
    setEnabled(true);
    checkSpaceForParts();
    return this;
  }
  
  //******************************************************
  //*            Determining NSScroller size
  //******************************************************
  
  /**
   * Returns the width of “normal-sized” instances.
   */
  public static function scrollerWidth():Number {
    return scrollerWidthForControlSize(NSControlSize.NSRegularControlSize);
  }

  /**
   * Returns the width of the scroller based on <code>size</code>.
   */
  public static function scrollerWidthForControlSize(size:NSControlSize):Number {
    return ASTheme.current().scrollerWidth();
  }
  
  /**
   * Sets the size of the scroller to <code>size</code>.
   */
  public function setControlSize(size:NSControlSize):Void {
    //! FIXME How to adjust to this?
  }
  
  /**
   * Returns the size of the scroller.
   */
  public function controlSize():NSControlSize {
    //! FIXME How to adjust to this?
    return NSControlSize.NSRegularControlSize;
  }
  
  //******************************************************
  //*             Laying out an NSScroller
  //******************************************************
  
  /**
   * Sets the location of the scroll buttons to <code>position</code>.
   */
  public function setArrowsPosition(position:NSScrollArrowPosition):Void {
    if (m_arrowsPosition == position) {
      return;
    }
    m_arrowsPosition = position;
    setNeedsDisplay(true);
  }
  
  /**
   * Returns the position of the scroll buttons.
   */
  public function arrowsPosition():NSScrollArrowPosition {
    return m_arrowsPosition;
  }
    
  //******************************************************
  //*            Setting the knob position
  //******************************************************
  
  public function setFloatValue(value:Number):Void {
  	//! TODO Figure out if this is right. What about the other value setters.
    if (m_floatValue == value) {
      return;
    }
    if (value < 0) {
      value = 0;
    }
    if (value > 1) {
      value = 1;
    }
    m_floatValue = value;
    drawKnob();
  }
  
  public function setFloatValueKnobProportion(value:Number, 
      knobProportion:Number):Void {
    if (m_floatValue == value && m_knobProportion == knobProportion) {
      return;
    }
    if (knobProportion < 0) {
      m_pendingKnobProportion = 0;
    } else if (knobProportion > 1) {
      m_pendingKnobProportion = 1;
    } else {
      m_pendingKnobProportion = knobProportion;
    }
    if (m_hitPart == NSScrollerPart.NSScrollerNoPart) {
      m_knobProportion = m_pendingKnobProportion;
      m_pendingKnobProportion = 0;
    }
    if (m_knobProportion == 1) {
      setEnabled(false);
    } else {
      setEnabled(true);
    }
    if (m_hitPart != NSScrollerPart.NSScrollerKnobSlot 
        && m_hitPart != NSScrollerPart.NSScrollerKnob) {
      m_floatValue = -1;
      setFloatValue(value);
    } 
  }
  
  public function floatValue():Number {
    return m_floatValue;
  }
  
  public function knobProportion():Number {
    return m_knobProportion;
  }
  
  //******************************************************
  //*               Calculating layout
  //******************************************************
  
  public function rectForPart(part:NSScrollerPart):NSRect {
    var scrollerFrame:NSRect = m_frame.clone();
    var x:Number, y:Number, width:Number, height:Number;
    var buttonWidth:Number = ASTheme.current().scrollerButtonWidth();
    x = y = width = height = 0;
    
    var buttonsSize:Number = 2*ASTheme.current().scrollerButtonWidth();
    var usableParts:NSUsableScrollerParts;
    
    if (!m_enabled) {
      usableParts = NSUsableScrollerParts.NSNoScrollerParts;
    } else {
      usableParts = m_usableParts;
    }
    
    // reverse width/height based on orientation
    if (m_horizontal) {
      width = scrollerFrame.size.height - 2;
      height = scrollerFrame.size.width - 2;
    } else {
      width = scrollerFrame.size.width - 2;
      height = scrollerFrame.size.height - 2;
    }
    
    switch(part) {
      case NSScrollerPart.NSScrollerKnob:
        if (usableParts == NSUsableScrollerParts.NSNoScrollerParts ||
            m_arrowsPosition == NSUsableScrollerParts.NSOnlyScrollerArrows) {
          return NSRect.ZeroRect;
        }
        var slotHeight:Number = height - 
          (m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone ? 0 
            : buttonsSize);
        var knobHeight:Number = Math.floor(m_knobProportion * slotHeight);
        if (knobHeight < buttonWidth) {
          knobHeight = buttonWidth;
        }
        var knobPosition:Number = Math.floor(m_floatValue * (slotHeight 
          - knobHeight));
        if (m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone) {
          y += knobPosition;
        } else {
          y += knobPosition + buttonWidth;
        }
        height = knobHeight;
        width = buttonWidth;
        x += 1;
        y += 1;
        break;
      case NSScrollerPart.NSScrollerKnobSlot:
        if (usableParts == NSUsableScrollerParts.NSNoScrollerParts ||
            m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone) {
          break;
        }
        height -= buttonsSize;
        y += buttonWidth+1;
        break;
      case NSScrollerPart.NSScrollerDecrementLine:
      case NSScrollerPart.NSScrollerDecrementPage:
        if (usableParts == NSUsableScrollerParts.NSNoScrollerParts ||
            m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone) {
          return NSRect.ZeroRect;
        }
        x += 1;
        y += 1;
        width = buttonWidth;
        height = buttonWidth;
        break;
      case NSScrollerPart.NSScrollerIncrementLine:
      case NSScrollerPart.NSScrollerIncrementPage:
        if (usableParts == NSUsableScrollerParts.NSNoScrollerParts ||
            m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone) {
          return NSRect.ZeroRect;
        }
        x += 1;
        y += (height - buttonWidth+1);
        width = buttonWidth;
        height = buttonWidth;
        break;
      case NSScrollerPart.NSScrollerNoPart:
        return NSRect.ZeroRect;
    }
    // Reverse y/x & height/width based on orientation
    if (m_horizontal) {
      return new NSRect(y,x,height,width);
    } else {
      return new NSRect(x,y,width,height);
    }
  }
  
  public function testPart(point:NSPoint):NSScrollerPart {
    var rect:NSRect;
    point = convertPointFromView(point);
    if (point.x <= 0 || point.x >=m_frame.size.width ||
        point.y <= 0 || point.y >=m_frame.size.height) {
      return NSScrollerPart.NSScrollerNoPart;
    }
    rect = rectForPart(NSScrollerPart.NSScrollerDecrementLine);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerDecrementLine;
    }

    rect = rectForPart(NSScrollerPart.NSScrollerIncrementLine);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerIncrementLine;
    }
    
    rect = rectForPart(NSScrollerPart.NSScrollerKnob);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerKnob;
    }

    rect = rectForPart(NSScrollerPart.NSScrollerIncrementPage);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerIncrementPage;
    }

    rect = rectForPart(NSScrollerPart.NSScrollerDecrementPage);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerDecrementPage;
    }

    rect = rectForPart(NSScrollerPart.NSScrollerKnobSlot);
    if (rect.pointInRect(point)) {
      return NSScrollerPart.NSScrollerKnobSlot;
    }

    return NSScrollerPart.NSScrollerNoPart;
  }
  
  public function checkSpaceForParts():Void {
    var frameSize:NSSize = m_frame.size;
    var size:Number = (m_horizontal ? frameSize.width : frameSize.height);
    var buttonWidth:Number = ASTheme.current().scrollerButtonWidth();
    
    if (m_arrowsPosition == NSScrollArrowPosition.NSScrollerArrowsNone) {
      if (size > buttonWidth + 3) {
        m_usableParts = NSUsableScrollerParts.NSAllScrollerParts;
      } else {
        m_usableParts = NSUsableScrollerParts.NSNoScrollerParts;
      }
    } else {
      if (size >= 5 + buttonWidth * 3) {
        m_usableParts = NSUsableScrollerParts.NSAllScrollerParts;
      } else if (size >= 3 + buttonWidth * 2) {
        m_usableParts = NSUsableScrollerParts.NSOnlyScrollerArrows;
      } else {
         m_usableParts = NSUsableScrollerParts.NSNoScrollerParts;
      }
    }
  }
  
  public function usableParts():NSUsableScrollerParts {
    return m_usableParts;
  }
  
  //******************************************************
  //*                Drawing the parts
  //******************************************************
  
  public function isOpaque():Boolean {
    return true;
  }
  
  public function drawParts():Void {
    if (g_upCell != null) {
      m_upCell = g_upCell;
      m_downCell = g_downCell;
      m_leftCell = g_leftCell;
      m_rightCell = g_rightCell;
    }
    g_upCell = new NSButtonCell();
    g_upCell.setHighlightsBy(NSCell.NSChangeBackgroundCellMask 
      | NSCell.NSContentsCellMask);
    g_upCell.setImage(NSImage.imageNamed("NSScrollerUpArrow"));
    g_upCell.setAlternateImage(NSImage.imageNamed("NSHightlightedScrollerUpArrow"));
    g_upCell.setImagePosition(NSCellImagePosition.NSImageOnly);
    g_upCell.setContinuous(true);
    g_upCell.sendActionOn(NSEvent.NSLeftMouseDownMask 
      | NSEvent.NSLeftMouseUpMask | NSEvent.NSPeriodicMask);
    g_upCell.setPeriodicDelayInterval(.3, .03);
    g_upCell.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
    g_upCell.setBezeled(true);
    
    g_downCell = new NSButtonCell();
    g_downCell.setHighlightsBy(NSCell.NSChangeBackgroundCellMask 
      | NSCell.NSContentsCellMask);
    g_downCell.setImage(NSImage.imageNamed("NSScrollerDownArrow"));
    g_downCell.setAlternateImage(NSImage.imageNamed(
      "NSHightlightedScrollerDownArrow"));
    g_downCell.setImagePosition(NSCellImagePosition.NSImageOnly);
    g_downCell.setContinuous(true);
    g_downCell.sendActionOn(NSEvent.NSLeftMouseDownMask 
      | NSEvent.NSLeftMouseUpMask | NSEvent.NSPeriodicMask);
    g_downCell.setPeriodicDelayInterval(.3, .03);
    g_downCell.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
    g_downCell.setBezeled(true);
    
    g_leftCell = new NSButtonCell();
    g_leftCell.setHighlightsBy(NSCell.NSChangeBackgroundCellMask 
      | NSCell.NSContentsCellMask);
    g_leftCell.setImage(NSImage.imageNamed("NSScrollerLeftArrow"));
    g_leftCell.setAlternateImage(NSImage.imageNamed(
      "NSHightlightedScrollerLeftArrow"));
    g_leftCell.setImagePosition(NSCellImagePosition.NSImageOnly);
    g_leftCell.setContinuous(true);
    g_leftCell.sendActionOn(NSEvent.NSLeftMouseDownMask 
      | NSEvent.NSLeftMouseUpMask 
      | NSEvent.NSPeriodicMask);
    g_leftCell.setPeriodicDelayInterval(.3, .03);
    g_leftCell.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
    g_leftCell.setBezeled(true);
    
    g_rightCell = new NSButtonCell();
    g_rightCell.setHighlightsBy(NSCell.NSChangeBackgroundCellMask 
      | NSCell.NSContentsCellMask);
    g_rightCell.setImage(NSImage.imageNamed("NSScrollerRightArrow"));
    g_rightCell.setAlternateImage(NSImage.imageNamed(
      "NSHightlightedScrollerRightArrow"));
    g_rightCell.setImagePosition(NSCellImagePosition.NSImageOnly);
    g_rightCell.setContinuous(true);
    g_rightCell.sendActionOn(NSEvent.NSLeftMouseDownMask 
      | NSEvent.NSLeftMouseUpMask 
      | NSEvent.NSPeriodicMask);
    g_rightCell.setPeriodicDelayInterval(.3, .03);
    g_rightCell.setBezelStyle(NSBezelStyle.NSShadowlessSquareBezelStyle);
    g_rightCell.setBezeled(true);
    
    m_upCell = g_upCell;
    m_downCell = g_downCell;
    m_leftCell = g_leftCell;
    m_rightCell = g_rightCell;
  }
  
  //******************************************************
  //*                  Event handling
  //******************************************************

  public function hitPart():NSScrollerPart {
    return m_hitPart;
  }
  
  public function acceptsFirstMouse():Boolean {
    return true;
  }

  public function acceptsFirstResponder():Boolean {
    return false;
  }

  public function action():String {
    return m_action;
  }

  public function setAction(value:String):Void {
    m_action = value;
  }

  public function target():Object {
    return m_target;
  }

  public function setTarget(target:Object):Void {
    m_target = target;
  }
  
  public function mouseDown(event:NSEvent):Void {
    if (!m_enabled) {
      return;
    }
    var location:NSPoint = event.mouseLocation;
    m_hitPart = testPart(location);
    setButtonCellTargets();
    switch(m_hitPart) {
      case NSScrollerPart.NSScrollerIncrementPage:
      case NSScrollerPart.NSScrollerIncrementLine:
        m_cell = m_horizontal ? m_rightCell : m_downCell;
        m_cellTrackingRect = rectForPart(NSScrollerPart.NSScrollerIncrementLine);
        super.mouseDown(event);
        return;
        break;
      case NSScrollerPart.NSScrollerDecrementPage:
      case NSScrollerPart.NSScrollerDecrementLine:
        m_cell = m_horizontal ? m_leftCell : m_upCell;
        m_cellTrackingRect = rectForPart(NSScrollerPart.NSScrollerDecrementLine);
        super.mouseDown(event);
        return;
        break;
      case NSScrollerPart.NSScrollerKnob:
        trackKnob(event);
        return;
      case NSScrollerPart.NSScrollerKnobSlot:
        location = convertPointFromView(location, null);
        if ((m_horizontal && location.x < m_scrollerKnobClipRect.minX()) || (!m_horizontal && location.y < m_scrollerKnobClipRect.minY())) {
          m_hitPart = NSScrollerPart.NSScrollerDecrementPage;
        } else {
          m_hitPart = NSScrollerPart.NSScrollerIncrementPage;
        }
        sendActionTo(m_action, m_target);
        return;
        //var floatValue = floatValueAtPoint(convertPointFromView(location, null));
        //if (m_floatValue != floatValue) {
        //  setFloatValue(floatValue);
        //  sendActionTo(m_action, m_target);
        //}
        //trackKnob(event);
        //return;
        break;
      case NSScrollerPart.NSScrollerNoPart:
        break;
    }
    m_hitPart = NSScrollerPart.NSScrollerNoPart;
    if (m_pendingKnobProportion != 0) {
      setFloatValueKnobProportion(m_floatValue, m_pendingKnobProportion);
    } else {
      setNeedsDisplay(true);
    }
  }

  private function trackKnob(event:NSEvent):Void {
    if (m_delegate != null) {
      m_delegate.scrollerBeginKnobScroll(this);
    }
    var rectKnob:NSRect = rectForPart(NSScrollerPart.NSScrollerKnob);
    var point:NSPoint = convertPointFromView(event.mouseLocation, null);
    m_trackingData = { 
      offsetY: point.y - rectKnob.origin.y,
      offsetX: point.x - rectKnob.origin.x,
      mouseDown: true, 
      eventMask: NSEvent.NSLeftMouseDownMask | NSEvent.NSLeftMouseUpMask | NSEvent.NSLeftMouseDraggedMask
        | NSEvent.NSMouseMovedMask  | NSEvent.NSOtherMouseDraggedMask | NSEvent.NSRightMouseDraggedMask,
      complete: false
    };
    knobTrackingCallback(event);
  }

  public function knobTrackingCallback(event:NSEvent):Void {
    if (event.type == NSEvent.NSLeftMouseUp) {
      m_hitPart = NSScrollerPart.NSScrollerNoPart;
      if (m_delegate != null) {
        m_delegate.scrollerEndKnobScroll(this);
      }
      return;
    }
    var point:NSPoint = convertPointFromView(event.mouseLocation, null);
    if (m_horizontal) {
      point.x -= m_trackingData.offsetX;
    } else {
      point.y -= m_trackingData.offsetY;
    }
    setFloatValue(floatValueAtPoint(point));
    sendActionTo(m_action, m_target);
    NSApplication.sharedApplication().callObjectSelectorWithNextEventMatchingMaskDequeue(this, "knobTrackingCallback", m_trackingData.eventMask, true);
  }
  
  public function drawRect(rect:NSRect):Void {
    m_mcBounds.clear();
    drawScrollerSlotWithRect(rect);
    if (m_enabled) {
      (m_horizontal ? m_leftCell : m_upCell).drawWithFrameInView(rectForPart(NSScrollerPart.NSScrollerDecrementLine), this);
      (m_horizontal ? m_rightCell : m_downCell).drawWithFrameInView(rectForPart(NSScrollerPart.NSScrollerIncrementLine), this);
      drawKnob();
    } else {
      if (m_scrollerKnobClip != null) {
        m_scrollerKnobClip.removeMovieClip();
        m_scrollerKnobClip = null;
        m_scrollerKnobClipRect = new NSRect(0,0,0,0);  
      }
    }
  }
  
  private function drawKnob():Void {
    if (m_mcBounds == null) return;
    if (m_scrollerKnobClip == null || m_scrollerKnobClip._parent == undefined) {
      m_scrollerKnobClip = createBoundsMovieClip();
      m_scrollerKnobClip.view = this;
      m_scrollerKnobClipRect = NSRect.ZeroRect;
    }
    var rectKnob:NSRect = rectForPart(NSScrollerPart.NSScrollerKnob);
    if (m_scrollerKnobClipRect.origin.x != rectKnob.origin.x ||
        m_scrollerKnobClipRect.origin.y != rectKnob.origin.y) {
      m_scrollerKnobClipRect.origin.x = rectKnob.origin.x;
      m_scrollerKnobClipRect.origin.y = rectKnob.origin.y;
      m_scrollerKnobClip._x = rectKnob.origin.x;
      m_scrollerKnobClip._y = rectKnob.origin.y;
    }
    if (m_scrollerKnobClipRect.size.width != rectKnob.size.width ||
        m_scrollerKnobClipRect.size.height != rectKnob.size.height) {
      m_scrollerKnobClipRect.size.width = rectKnob.size.width;
      m_scrollerKnobClipRect.size.height = rectKnob.size.height;
      m_scrollerKnobClip.clear();
      drawScrollerWithRectInClip(new NSRect(0,0,rectKnob.size.width, rectKnob.size.height), m_scrollerKnobClip);
    }
  }

  private function drawScrollerSlotWithRect(rect:NSRect):Void {
    ASTheme.current().drawScrollerSlotWithRectInView(rect, this);
  }
  
  private function drawScrollerWithRectInClip(rect:NSRect, mc:MovieClip):Void {
    ASTheme.current().drawScrollerWithRectInClip(rect, mc);
  }
  
  //******************************************************
  //*               Setting the delegate
  //******************************************************
  
  /**
   * <p>Sets the delegate of the scroller to <code>delegate</code>.</p>
   * 
   * <p>The scroll view is typically a scroller's delegate.</p>
   * 
   * @see #delegate
   */
  public function setDelegate(delegate:Object):Void {
    m_delegate = delegate;
  }
  
  /**
   * <p>Returns the delegate of the scroller.</p>
   * 
   * @see #setDelegate
   */
  public function delegate():Object {
    return m_delegate;
  }
  
  //******************************************************
  //*              Overridden functions
  //******************************************************
  
  public function setFrame(rect:NSRect):Void {
    if (rect.size.width > rect.size.height) {
      m_horizontal = true;
      rect.size.height = scrollerWidth();
    } else {
      m_horizontal = false;
      rect.size.width = scrollerWidth();
    }
    super.setFrame(rect);
    if (m_arrowsPosition !=  NSScrollArrowPosition.NSScrollerArrowsNone) {
      m_arrowsPosition = NSScrollArrowPosition.NSScrollerArrowsDefaultSetting;
    }
    m_hitPart = NSScrollerPart.NSScrollerNoPart;    
    setNeedsDisplay(true);
    checkSpaceForParts();
  }
  
  public function setFrameSize(size:NSSize):Void {
    if (size.width > size.height) {
      m_horizontal = true;
      size.height = scrollerWidth();
    } else {
      m_horizontal = false;
      size.width = scrollerWidth();
    }
    super.setFrameSize(size);
    if (m_arrowsPosition !=  NSScrollArrowPosition.NSScrollerArrowsNone) {
      m_arrowsPosition = NSScrollArrowPosition.NSScrollerArrowsDefaultSetting;
    }
    setNeedsDisplay(true);
    checkSpaceForParts();
  }
  
  public function setEnabled(value:Boolean):Void {
    m_enabled = value;
    setNeedsDisplay(true);
  }

  public function isEnabled():Boolean {
    return m_enabled;
  }  
  
  //******************************************************
  //*                 Helper methods
  //******************************************************

  private function cellTrackingRect():NSRect {
    return m_cellTrackingRect;
  }
  
  private function setButtonCellTargets():Void {
    if (m_horizontal) {
      m_leftCell.setTarget(m_target);
      m_leftCell.setAction(m_action);
      m_rightCell.setTarget(m_target);
      m_rightCell.setAction(m_action);
    } else {
      m_upCell.setTarget(m_target);
      m_upCell.setAction(m_action);
      m_downCell.setTarget(m_target);
      m_downCell.setAction(m_action);
    }
  }

  private function floatValueAtPoint(point:NSPoint):Number {
    var knobRect:NSRect = rectForPart(NSScrollerPart.NSScrollerKnob);
    var slotRect:NSRect = rectForPart(NSScrollerPart.NSScrollerKnobSlot);
    var position:Number;
    var min_pos:Number;
    var max_pos:Number;
    
    if (m_horizontal) {
      min_pos = slotRect.minX();
      max_pos = slotRect.maxX() - knobRect.size.width;
      position = point.x;
    } else {
      min_pos = slotRect.minY();
      max_pos = slotRect.maxY() - knobRect.size.height;
      position = point.y;
    }
    if (position <= min_pos) {
      return 0;
    }
    if (position >= max_pos) {
      return 1;
    }
    return (position - min_pos) / (max_pos - min_pos);
  }
  
}