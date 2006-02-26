/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.NSColor;
import org.actionstep.NSNotification;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSScrollView;
import org.actionstep.NSSize;
import org.actionstep.NSView;

/**
 * This class is used by an <code>NSScrollView</code> to "clip" the document
 * view, and reflect scrolling actions.
 * 
 * @author Rich Kilmer
 */
class org.actionstep.NSClipView extends NSView {
  private var m_documentView:NSView;
  private var m_drawsBackground:Boolean;
  private var m_copiesOnScroll:Boolean;
  private var m_backgroundColor:NSColor;
  private var m_smoothScrollingEnabled:Boolean;
  
  //******************************************************
  //*                   Construction
  //******************************************************
  
  public function init():NSClipView {
    super.init();
    setAutoresizesSubviews(true);
    m_copiesOnScroll = true;
    m_drawsBackground = true;
    m_smoothScrollingEnabled = false;
    return this;
  }
  
  //******************************************************
  //*            Setting the document view
  //******************************************************
  
  public function setDocumentView(view:NSView):Void {
    var nc:NSNotificationCenter;
    if (view == m_documentView) {
      return;
    }
    nc = NSNotificationCenter.defaultCenter();
    if (m_documentView) {
      nc.removeObserverNameObject(this, null, m_documentView);
      m_documentView.removeFromSuperview();
    }
    m_documentView = view;
    if (m_documentView != null) {
      var documentFrame:NSRect;
      addSubview(m_documentView);
      documentFrame = m_documentView.frame();
      setBoundsOrigin(documentFrame.origin);
      if (typeof(m_documentView["backgroundColor"])=="function") {
        m_backgroundColor = m_documentView["backgroundColor"].call(
          m_documentView);
      }
      if (typeof(m_documentView["drawsBackground"])=="function") {
        m_drawsBackground = m_documentView["drawsBackground"].call(
          m_documentView);
      }
      m_documentView.setPostsFrameChangedNotifications(true);
      m_documentView.setPostsBoundsChangedNotifications(true);
      nc.addObserverSelectorNameObject(this, "viewFrameChanged", 
        NSView.NSViewFrameDidChangeNotification, m_documentView);
      nc.addObserverSelectorNameObject(this, "viewBoundsChanged", 
        NSView.NSViewBoundsDidChangeNotification, m_documentView);
    }
    NSScrollView(superview()).reflectScrolledClipView(this);
  }
  
  public function documentView():NSView {
    return m_documentView;
  }
  
  public function setSmoothScrollingEnabled(value:Boolean):Void {
    m_smoothScrollingEnabled = value;
  }

  public function smoothScrollingEnabled():Boolean {
    return m_smoothScrollingEnabled;
  }
  
  public function createMovieClips():Void {
    super.createMovieClips();
    if (m_mcBounds) {
      //trace("here");
      //m_mcBounds.cacheAsBitmap = true;
    }
  }
  
  //******************************************************
  //*                  Scrolling
  //******************************************************
  
  public function setCachingEnabled(value:Boolean):Void {
    //! FIXME This doesn't work properly with scrolling textfields.
    if (m_smoothScrollingEnabled) {
      m_mcBounds.cacheAsBitmap = value;
    }
  }

  public function scrollToPoint(point:NSPoint):Void {
    point = constrainScrollPoint(point);
    setBoundsOrigin(point);
  }
  
  public function constrainScrollPoint(point:NSPoint):NSPoint {
    var newPoint:NSPoint = point.clone();
    if (m_documentView == null) {
      return null;
    }
    var documentFrame:NSRect = m_documentView.frame();
    
    if (documentFrame.size.width <= m_bounds.size.width) {
      newPoint.x = documentFrame.origin.x;
    } else if (point.x <= documentFrame.origin.x) {
      newPoint.x = documentFrame.origin.x;
    } else if ((point.x + m_bounds.size.width) >= documentFrame.maxX()) {
      newPoint.x = documentFrame.maxX() - m_bounds.size.width;
    }
    
    if (documentFrame.size.height <= m_bounds.size.height) {
      newPoint.y = documentFrame.origin.y;
    } else if (point.y <= documentFrame.origin.y) {
      newPoint.y = documentFrame.origin.y;
    } else if ((point.y + m_bounds.size.height) >= documentFrame.maxY()) {
      newPoint.y = documentFrame.maxY() - m_bounds.size.height;
    }
    return newPoint;
  }

  //******************************************************
  //*          Determining scrolling efficiency
  //******************************************************
  
  public function setCopiesOnScroll(value:Boolean):Void {
    m_copiesOnScroll = value;
  }
  
  public function copiesOnScroll():Boolean {
    return m_copiesOnScroll;
  }

  //******************************************************
  //*            Getting the visible portion
  //******************************************************
  
  public function documentRect():NSRect {
    if (m_documentView == null) {
      return m_bounds;
    }
    var documentFrame:NSRect = m_documentView.frame();
    return new NSRect(documentFrame.origin.x, documentFrame.origin.y, 
      Math.max(documentFrame.size.width, m_bounds.size.width), 
      Math.max(documentFrame.size.height, m_bounds.size.height));
  }
  
  public function documentVisibleRect():NSRect {
    if (m_documentView == null) {
      return NSRect.ZeroRect;
    }
    return m_documentView.bounds().intersectionRect(convertRectToView(m_bounds, m_documentView));
  }
  
  //******************************************************
  //*               Notification callbacks
  //******************************************************
  
  /**
   * This is fired when the boundary of this clip view's document view is
   * changed.
   */
  public function viewBoundsChanged(notification:NSNotification):Void {
    NSScrollView(superview()).reflectScrolledClipView(this);
  }

  /**
   * This is fired when the frame rectangle of this clip view's document view is
   * changed.
   */  
  public function viewFrameChanged(notification:NSNotification):Void {
  	//! FIXME There is a bug here.
  	var pt:NSPoint = constrainScrollPoint(m_bounds.origin);
    setBoundsOrigin(pt);
    if (!m_documentView.frame().containsRect(m_bounds)) {
      setNeedsDisplay();
    }
    NSScrollView(superview()).reflectScrolledClipView(this);
  }

  //******************************************************
  //*          Working with background color
  //******************************************************
  
  public function drawsBackground():Boolean {
    return m_drawsBackground;
  }
  
  public function setDrawsBackground(value:Boolean):Void {
    if (m_drawsBackground != value) {
      m_drawsBackground = value;
      setNeedsDisplay(true);      
    }
  }
  
  public function setBackgroundColor(color:NSColor):Void {
    m_backgroundColor = color;
    setNeedsDisplay(true);
  }
  
  public function backgroundColor():NSColor {
    return m_backgroundColor;
  }

  //******************************************************
  //*               Overridden functions
  //******************************************************
  
  public function setBoundsOrigin(point:NSPoint):Void {
    if (point.isEqual(m_bounds.origin) || m_documentView == null) {
      return;
    }
    super.setBoundsOrigin(point);
    m_documentView.setNeedsDisplay(true);
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function scaleUnitSquareToSize(size:NSSize):Void {
    super.scaleUnitSquareToSize(size);
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function setBoundsSize(size:NSSize):Void {
    super.setBoundsSize(size);
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function setFrameSize(size:NSSize):Void {
    super.setFrameSize(size);
    setBoundsOrigin(constrainScrollPoint(m_bounds.origin));
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function setFrameOrigin(origin:NSPoint):Void {
    super.setFrameOrigin(origin);
    setBoundsOrigin(constrainScrollPoint(m_bounds.origin));
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function setFrame(rect:NSRect):Void {
    super.setFrame(rect);
    setBoundsOrigin(constrainScrollPoint(m_bounds.origin));
    NSScrollView(m_superview).reflectScrolledClipView(this);
  }

  public function translateOriginToPoint(point:NSPoint):Void {
    super.translateOriginToPoint(point);
    NSScrollView(m_superview).reflectScrolledClipView(this);
  } 

  public function rotateByAngle(angle:Number):Void { 
    // IGNORE 
  } 

  public function setBoundsRotation(angle:Number):Void { 
    // IGNORE 
  } 

  public function setFrameRotation(angle:Number):Void { 
    // IGNORE 
  }

  public function acceptsFirstResponder():Boolean {
    if (m_documentView == null) {
      return false;
    } else {
      return m_documentView.acceptsFirstResponder();
    }
  }

  public function becomeFirstResponder():Boolean {
    if (m_documentView == null) {
      return false;
    } else {
      return m_window.makeFirstResponder(m_documentView);
    }
  }
  
  public function drawRect(rect:NSRect):Void {
    m_mcBounds.clear();
    if (m_drawsBackground) {
      ASDraw.fillRectWithRect(m_mcBounds, rect, m_backgroundColor.value);
    }
  }

    
}