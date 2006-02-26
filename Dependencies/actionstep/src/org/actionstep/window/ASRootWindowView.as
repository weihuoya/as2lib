/* See LICENSE for copyright and terms of use */

import org.actionstep.ASTheme;
import org.actionstep.constants.NSCellImagePosition;
import org.actionstep.constants.NSLineBreakMode;
import org.actionstep.NSApplication;
import org.actionstep.NSButton;
import org.actionstep.NSColor;
import org.actionstep.NSCursor;
import org.actionstep.NSEvent;
import org.actionstep.NSFont;
import org.actionstep.NSImage;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSTextFieldCell;
import org.actionstep.NSView;
import org.actionstep.NSWindow;

import flash.filters.DropShadowFilter;

class org.actionstep.window.ASRootWindowView extends NSView {

  //******************************************************
  //*                    Constants
  //******************************************************

  private static var WINDOW_CLIP:MovieClip = _root;
  private static var BUTTON_SIDE_LENGTH:Number = 16;
  private static var BUTTON_SPACING:Number = 4;
  public static var TITLE_BAR_HEIGHT:Number = 22;

  //******************************************************
  //*                  Class members
  //******************************************************

  private static var g_lowestView:ASRootWindowView = null;

  //******************************************************
  //*                Member variables
  //******************************************************

  private var m_contentRect:NSRect;
  private var m_swfLoading:Boolean;
  private var m_swfLoaded:Boolean;
  private var m_window:NSWindow;
  private var m_titleRect:NSRect;
  private var m_resizeRect:NSRect;
  private var m_trackingData:Object;

  private var m_lowerView:ASRootWindowView;
  private var m_higherView:ASRootWindowView;
  private var m_targetDepth:Number;

  private var m_titleCell:NSTextFieldCell;
  private var m_titleToolTipTag:Number;
  private var m_titleFont:NSFont;
  private var m_titleKeyFontColor:NSColor;
  private var m_titleFontColor:NSColor;

  private var m_childTree:NSView;
  private var m_isResizing:Boolean;
  private var m_resizeClip:MovieClip;
  private var m_showsResizeIndicator:Boolean;
  private var m_hasShadow:Boolean;

  //******************************************************
  //*                      Buttons
  //******************************************************

  private var m_closeBtn:NSButton;
  private var m_miniBtn:NSButton;

  //
  // For Flash 8
  //
  private var m_mcBase:MovieClip;

  /** IF Flash8 */
  private var m_shadowFilter:DropShadowFilter;
  /** ENDIF */

  public function ASRootWindowView() {
    m_hasShadow = false;
    m_swfLoading = false;
    m_swfLoaded = false;
    m_showsResizeIndicator = true;
    m_titleRect = new NSRect(0,0,0,TITLE_BAR_HEIGHT);
    m_resizeRect = new NSRect(-11,-11,11,11);
    m_isResizing = false;

    //
    // Create title cell
    //
  	m_titleCell = new NSTextFieldCell();
  	m_titleCell.initTextCell("");
  	m_titleCell.setDrawsBackground(false);
  	m_titleCell.setSelectable(false);
  	m_titleCell.setEditable(false);
  	m_titleCell.setLineBreakMode(NSLineBreakMode.NSLineBreakByTruncatingTail);

    //
    // Create buttons
    //
    m_closeBtn = new NSButton();
  	m_closeBtn.initWithFrame(new NSRect(0, 0, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH));
  	m_closeBtn.setImage(NSImage.imageNamed("NSWindowCloseIconRep"));
  	m_closeBtn.setToolTip("Close");
  	m_closeBtn.setImagePosition(NSCellImagePosition.NSImageOnly);
  	m_closeBtn.setAutoresizingMask(NSView.MinXMargin);
  	m_closeBtn.setTarget(this);
  	m_closeBtn.setAction("closeWindow");

      m_miniBtn = new NSButton();
  	m_miniBtn.initWithFrame(new NSRect(0, 0, BUTTON_SIDE_LENGTH, BUTTON_SIDE_LENGTH));
  	m_miniBtn.setImage(NSImage.imageNamed("NSWindowMiniaturizeIconRep"));
  	m_miniBtn.setToolTip("Miniaturize");
  	m_miniBtn.setImagePosition(NSCellImagePosition.NSImageOnly);
  	m_miniBtn.setAutoresizingMask(NSView.MinXMargin);
  	m_miniBtn.setTarget(this);
  	m_miniBtn.setAction("miniaturizeWindow");
  }

  public function initWithFrameWindow(frame:NSRect, window:NSWindow):ASRootWindowView {
    initWithFrame(frame);

    m_titleKeyFontColor = NSColor.systemFontColor();
    m_titleFontColor = new NSColor(0x666666);
    m_titleFont = NSFont.systemFontOfSize(12);
    m_titleFont.setBold(true);
    m_titleCell.setTextColor(m_titleKeyFontColor);

    m_window = window;
    setLowerView(highestViewOfLevel());
    return this;
  }

  public function createMovieClips() {
    super.createMovieClips();
    if (m_mcBounds != null) {
      if (m_window.styleMask() & NSWindow.NSResizableWindowMask) {

        m_resizeClip = m_mcBounds.createEmptyMovieClip("ResizeClip", 1000000);
        drawResizeClip();
        m_resizeClip.view = this;
        m_resizeClip._x = m_frame.size.width-12;
        m_resizeClip._y = m_frame.size.height-12;
        m_resizeRect.origin.x = m_resizeClip._x;
        m_resizeRect.origin.y = m_resizeClip._y;
      }
    }
  }

  private function drawResizeClip() {
    with(m_resizeClip) {
      clear();
      beginFill(0xFFFFFF, 1);
      lineStyle(0, 0xFFFFFF, 1);
      moveTo(0,0);
      lineTo(10,0);
      lineTo(10,10);
      lineTo(0,10);
      lineTo(0,0);
      endFill();
    }
    if (m_showsResizeIndicator) {
      with(m_resizeClip) {
        //da 87 e8 ff
        lineStyle(1.5, 0xdadada, 100);
        moveTo(0,10);
        lineTo(10,0);
        lineStyle(1.5, 0x878787, 100);
        moveTo(1,10);
        lineTo(10,1);
        lineStyle(1.5, 0xe8e8e8, 100);
        moveTo(2,10);
        lineTo(10,2);

        lineStyle(1.5, 0xdadada, 100);
        moveTo(4,10);
        lineTo(10,4);
        lineStyle(1.5, 0x878787, 100);
        moveTo(5,10);
        lineTo(10,5);
        lineStyle(1.5, 0xe8e8e8, 100);
        moveTo(6,10);
        lineTo(10,6);

        lineStyle(1.5, 0xdadada, 100);
        moveTo(8,10);
        lineTo(10,8);
        lineStyle(1.5, 0x878787, 100);
        moveTo(9,10);
        lineTo(10,9);
        lineStyle(1.5, 0xe8e8e8, 100);
        moveTo(10,10);
        lineTo(10,10);
      }
    }
  }

  public function removeFromSuperview() {
    removeMovieClips();
  }

  public function removeMovieClips():Void {
    super.removeMovieClips();
    m_mcBase.removeMovieClip();
    m_mcBase = null;
  }
  
  public function setHasShadow(value:Boolean) {
    m_hasShadow = value;
    if (m_hasShadow) {
      m_shadowFilter = new DropShadowFilter();
      m_shadowFilter.blurX = 20;
      m_shadowFilter.blurY = 20;
      m_shadowFilter.alpha = .6;
      m_shadowFilter.strength = .7;
      m_shadowFilter.angle = 90;
      m_mcBase.filters = [m_shadowFilter];
    } else {
      m_shadowFilter = null;
      m_mcBase.filters = [];
    }
  }

  public function setWindowTransparency(level:Number) {
    m_mcBase._alpha = level;
  }

  private function updateFrameMovieClipSize():Void {
    super.updateFrameMovieClipSize();
    if (m_mcBase != null) {
      m_resizeClip._x = m_frame.size.width-12;
      m_resizeClip._y = m_frame.size.height-12;
      m_resizeRect.origin.x = m_resizeClip._x;
      m_resizeRect.origin.y = m_resizeClip._y;
      //m_titleTextField._x = (m_frame.size.width - (m_titleTextField.textWidth+2))/2;
    }
  }

  private function updateFrameMovieClipPosition():Void {
    if (m_mcBase == null) {
      return;
    }
    m_mcBase._x = m_frame.origin.x;
    m_mcBase._y = m_frame.origin.y;
  }

  private function updateFrameMovieClipPerspective():Void {
    if (m_mcBase == null) {
      return;
    }
    m_mcBase._rotation = m_frameRotation;
    if (m_mcBase._visible != !m_hidden) {
      m_mcBase._visible = !m_hidden;
      if (m_hidden) {
        m_mcBase._x = 4000;
        m_mcBase._y = 4000;
      } else {
        m_mcBase._x = m_frame.origin.x;
        m_mcBase._y = m_frame.origin.y;
      }
    }
  }

  public static function lowestView():ASRootWindowView {
    return g_lowestView;
  }

  public function dump(view:ASRootWindowView) {
    if(view == null) view = g_lowestView;
    trace(view.lowerView().window().windowNumber()+" - "+view.window().windowNumber()+" - "+view.higherView().window().windowNumber());
    if(view.higherView() != null) {
      dump(view.higherView());
    } else {
      trace("---");
    }
  }

  public function highestViewOfLevel():ASRootWindowView {
    var view:ASRootWindowView = g_lowestView;
    while(view.higherView() != null && view.higherView().level()<=level()) {
      view = view.higherView();
    }
    if (view.level() > level()) {
      view = null;
    }
    return view;
  }

  public function lowestViewOfLevel():ASRootWindowView {
    var view:ASRootWindowView = g_lowestView;
    while(view != null && view.level()>=level()) {
      view = view.higherView();
    }
    return view;
  }

  public function level():Number {
    return m_window.level();
  }

  public function setHigherView(view:ASRootWindowView) {
    m_higherView = view;
  }

  public function higherView():ASRootWindowView {
    return m_higherView;
  }

  public function setLowerView(view:ASRootWindowView) {
    if (view == null) {
      if (g_lowestView != null) {
        g_lowestView.setLowerView(this);
      }
      m_lowerView = view;
      g_lowestView = this;
    } else {
      if (view != m_lowerView) {
        m_lowerView = view;
        view.higherView().setLowerView(this);
        view.setHigherView(this);
      }
    }
    setTargetDepths();
  }

  public function setTargetDepths() {
    var view:ASRootWindowView = g_lowestView;
    var i:Number = 100;
    view.setTargetDepth(i++);
    while(view.higherView() != null) {
      view.higherView().setTargetDepth(i++);
      view = view.higherView();
    }
  }

  public function setTargetDepth(depth:Number) {
    m_targetDepth = depth;
  }

  public function extractView() {
    var lower:ASRootWindowView = m_lowerView;
    var higher:ASRootWindowView = m_higherView;
    m_higherView = null;
    m_lowerView = null;
    if (g_lowestView == this) {
      g_lowestView = higher;
      higher.m_lowerView = null;
      return;
    }
    higher.m_lowerView = lower;
    lower.m_higherView = higher;
  }

  public function lowerView():ASRootWindowView {
    return m_lowerView;
  }

  public function matchDepth() {
    if (m_mcBase == null) {
      return;
    }
    var oldDepth:Number = m_mcBase.getDepth();
    if (m_targetDepth != oldDepth) {
      m_mcBase.swapDepths(m_targetDepth);
      WINDOW_CLIP.getInstanceAtDepth(oldDepth).view.matchDepth();
    }
  }

  private function createFrameMovieClip():MovieClip {
    var self:ASRootWindowView = this;
    var depth:Number = m_targetDepth;
    if (WINDOW_CLIP.getInstanceAtDepth(depth) != null) {
      depth = m_window.windowNumber()+100;
    }
    m_mcBase  = WINDOW_CLIP.createEmptyMovieClip("ASRootWindowView"+m_window.windowNumber(), depth);
    m_mcBase.view = this;
    WINDOW_CLIP["ASRootWindowView"+m_window.windowNumber()].window = m_window;
    m_mcFrame = m_mcBase.createEmptyMovieClip("MCFRAME", 1);
    m_mcFrame.window = m_window;
    matchDepth();

    //
    // This is what actually causes views to update if they are marked as
    // needing it.
    //
    m_mcFrame.onEnterFrame = function() {
      self.window().displayIfNeeded();
    };
    return m_mcFrame;
  }

  private function loadSwf() {
    m_mcBounds = m_mcFrame.createEmptyMovieClip("m_mcBounds", 2);
    var image_mcl:MovieClipLoader = new MovieClipLoader();
    image_mcl.addListener(this);
    m_mcBounds._lockroot = true;
    image_mcl.loadClip(m_window.swf(), m_mcBounds);
  }

  public function onLoadInit(target_mc:MovieClip) {
    m_swfLoading = false;
    m_swfLoaded = true;
    m_mcBounds.view = this;
    updateBoundsMovieClip();
    for(var i:Number=0;i<m_subviews.length;i++) {
      m_subviews[i].createMovieClips();
    }
    display();
  }

  public function setContentView(view:NSView) {
    var contentView:NSView = subviews()[0];
    if (contentView != null) {
      replaceSubviewWith(contentView, view);
    } else {
      addSubview(view);
    }
  }

  public function acceptsFirstMouse(event:NSEvent):Boolean {
    return true;
  }

  private function initializeBoundsMovieClip() {
    if (m_window.swf() != null) {
      if(m_swfLoading) {
        return;
      } else {
        m_swfLoading = true;
        loadSwf();
        return;
      }
    }
    super.initializeBoundsMovieClip();
  }

  public function display() {
    if(m_mcBase == undefined) {
      createMovieClips();
    }
    if(m_mcBounds.view != undefined) {
      super.display();
      m_window.windowDidDisplay();
    }
  }

  public function displayIfNeeded() {
    if(m_mcBase == undefined) {
      createMovieClips();
    }
    if (m_mcBounds.view != undefined) {
      super.displayIfNeeded();
    }
  }

  //******************************************************
  //*                    Buttons
  //******************************************************

  /**
   * Returns this window's close button.
   */
  public function closeButton():NSButton {
    return m_closeBtn;
  }

  /**
   * Returns this window's miniaturize button.
   */
  public function miniaturizeButton():NSButton {
    return m_miniBtn;
  }

  //******************************************************
  //*                     Cursors
  //******************************************************

  public function resetCursorRects():Void {
    if (m_window.styleMask() & NSWindow.NSResizableWindowMask) {
      addCursorRectCursor(new NSRect(m_resizeClip._x, m_resizeClip._y,
        m_resizeClip._width, m_resizeClip._height),
        NSCursor.resizeDiagonalDownCursor());
    }
  }

  //******************************************************
  //*                  Event handling
  //******************************************************

  public function mouseDown(event:NSEvent) {
    if (m_window.styleMask() == NSWindow.NSBorderlessWindowMask) {
      return;
    }

    var location:NSPoint = event.mouseLocation;
    location = convertPointFromView(location);

    if(m_titleRect.pointInRect(location)
    	&& m_window.styleMask() & NSWindow.NSTitledWindowMask
    	&& (m_window.styleMask() & NSWindow.NSNotDraggableWindowMask == 0)) {
      dragWindow(event);
    }
    else if(m_resizeRect.pointInRect(location)
    	&& m_window.styleMask() & NSWindow.NSResizableWindowMask) {
      resizeWindow(event);
    }
  }

  private function dragWindow(event:NSEvent) {
    m_mcBase.cacheAsBitmap=true;
    var point:NSPoint = convertPointFromView(event.mouseLocation, null);
    m_trackingData = {
      offsetX: point.x,
      offsetY: point.y,
      mouseDown: true,
      eventMask: NSEvent.NSLeftMouseDownMask | NSEvent.NSLeftMouseUpMask | NSEvent.NSLeftMouseDraggedMask
        | NSEvent.NSMouseMovedMask  | NSEvent.NSOtherMouseDraggedMask | NSEvent.NSRightMouseDraggedMask,
      complete: false
    };
    //m_mcBase._alpha = 80;
    dragWindowCallback(event);
  }

  public function dragWindowCallback(event:NSEvent) {
    if (event.type == NSEvent.NSLeftMouseUp) {
      //m_mcBase._alpha = 100;
      m_mcBase.cacheAsBitmap=false;
      return;
    }
    m_window.setFrameOrigin(new NSPoint(event.mouseLocation.x - m_trackingData.offsetX, event.mouseLocation.y - m_trackingData.offsetY));
    NSApplication.sharedApplication().callObjectSelectorWithNextEventMatchingMaskDequeue(this, "dragWindowCallback", m_trackingData.eventMask, true);
  }

  //******************************************************
  //*                    Resizing
  //******************************************************

  /**
   * Returns <code>true</code> if the root view is resizing, or
   * <code>false</code> otherwise.
   */
  public function isResizing():Boolean {
    return m_isResizing;
  }

  /**
   * Begins resizing the window.
   */
  private function resizeWindow(event:NSEvent) {
  	m_isResizing = true;
  	NSView(subviews()[0]).setHidden(true);
  	m_mcBase.filters = [];
    var frame:NSRect = frame();
    m_trackingData = {
      origin: frame.origin,
      offsetX: frame.origin.x + frame.size.width - event.mouseLocation.x,
      offsetY: frame.origin.y + frame.size.height - event.mouseLocation.y,
      mouseDown: true,
      eventMask: NSEvent.NSLeftMouseDownMask | NSEvent.NSLeftMouseUpMask | NSEvent.NSLeftMouseDraggedMask
        | NSEvent.NSMouseMovedMask  | NSEvent.NSOtherMouseDraggedMask | NSEvent.NSRightMouseDraggedMask,
      complete: false
    };
    resizeWindowCallback(event);
  }

  /**
   * Called on every matching event during the resize.
   */
  public function resizeWindowCallback(event:NSEvent) {
    var width:Number = event.mouseLocation.x - m_trackingData.origin.x + m_trackingData.offsetX;
    var height:Number = event.mouseLocation.y - m_trackingData.origin.y + m_trackingData.offsetY;

    m_isResizing = event.type != NSEvent.NSLeftMouseUp;

    var frmRect:NSRect = new NSRect(m_trackingData.origin.x, m_trackingData.origin.y, width, height);
    m_window.setFrame(frmRect);

    if (!m_isResizing) {
      var content:NSView = NSView(subviews()[0]);
      content.setHidden(false);
      content.setFrameSize(m_window.contentRectForFrameRect().size);
      content.setNeedsDisplay(true);
      setNeedsDisplay(true);
      NSCursor.pop();
      return;
    }

    NSApplication.sharedApplication().callObjectSelectorWithNextEventMatchingMaskDequeue(this, "resizeWindowCallback", m_trackingData.eventMask, true);
  }

  /**
   * Closes the window. This is the handler for a "close" button click.
   */
  private function closeWindow(sender:Object):Void {
    m_window.performClose(sender);
  }

  /**
   * Miniaturizes the window. This is the handler for a "mini" button click.
   */
  private function miniaturizeWindow(sender:Object):Void {
    m_window.performMiniaturize(sender);
    m_miniBtn.setImage(NSImage.imageNamed("NSWindowRestoreIconRep"));
    m_miniBtn.setToolTip("Restore");
    m_miniBtn.setAction("deminiaturizeWindow");
  }

  /**
   * Deminiaturizes the window. This is the handler for a "restore" button
   * click.
   */
  private function deminiaturizeWindow(sender:Object):Void {
    m_window.deminiaturize(sender);
    m_miniBtn.setImage(NSImage.imageNamed("NSWindowMiniaturizeIconRep"));
    m_miniBtn.setToolTip("Miniaturize");
    m_miniBtn.setAction("miniaturizeWindow");
  }

  public function showsResizeIndicator():Boolean {
    return m_showsResizeIndicator;
  }

  public function setShowsResizeIndicator(value:Boolean) {
    if (m_showsResizeIndicator != value) {
      m_showsResizeIndicator = value;
      drawResizeClip();
    }
  }

  public function drawRect(rect:NSRect) {
    m_mcBounds.clear();

    var bgcolor:NSColor = m_window.backgroundColor();
    var styleMask:Number = m_window.styleMask();
    var isKey:Boolean = m_window.isKeyWindow();
    if (m_hasShadow) {
      if (isKey) {
        /** IF Flash8 */
        m_shadowFilter.blurX = 20;
        m_shadowFilter.blurY = 15;
        m_shadowFilter.alpha = .6;
        m_shadowFilter.strength = .7;
        m_shadowFilter.angle = 90;
        m_mcBase.filters = [m_shadowFilter];
        /** ENDIF */
      } else {
        /** IF Flash8 */
        m_shadowFilter.blurX = 10;
        m_shadowFilter.blurY = 4;
        m_shadowFilter.alpha = .4;
        m_shadowFilter.strength = .3;
        m_shadowFilter.angle = 90;
        m_mcBase.filters = [m_shadowFilter];
        /** ENDIF */
      }
    }
    
    var x:Number = rect.origin.x;
    var y:Number = rect.origin.y;
    var width:Number = rect.size.width-1;
    var height:Number = m_titleRect.size.height;
    m_titleRect.size.width = width;
    var totalHeight:Number = rect.size.height-1;

    //
    // Only draw title and icon if the styleMask says we should.
    //
    var icon:NSImage = m_window.icon();
    var iconRect:NSRect;
    var hasIcon:Boolean = false;
    
    if (styleMask & NSWindow.NSTitledWindowMask) {
      ASTheme.current().drawWindowTitleBarWithRectInViewIsKey(
        new NSRect(x, y, width, height, isKey), this);
      if (icon != null) {
        iconRect = new NSRect(2, 2, height - 4, height - 4);
        icon.bestRepresentationForDevice("").setSize(iconRect.size);
        icon.lockFocus(m_mcBounds);
        icon.drawAtPoint(iconRect.origin);
        icon.unlockFocus();
        hasIcon = true;
      }
    } else {
      height = 0;
    }


    //
    // If we have no background color and the window is being resized, we'll
    // draw a filler rect instead.
    //
    if (m_isResizing && bgcolor == null) {
      ASTheme.current().drawResizingWindowWithRectInView(
        new NSRect(x, y + height, width, totalHeight - height), this);
      return;
    }

    with (m_mcBounds) {
      if (null != bgcolor) {
        beginFill(bgcolor.value, bgcolor.alphaComponent() * 100);
      }

      lineStyle(1.5, 0x8E8E8E,
      (styleMask == NSWindow.NSBorderlessWindowMask) ? 0 : 100);
      moveTo(x, y+height);
      lineTo(x, y+totalHeight);
      lineTo(x+width, y+totalHeight);
      lineTo(x+width, y+height);

      if (null != bgcolor) {
        endFill();
      }
    }

    //
    // If we're borderless, stop now.
    //
    if (styleMask == NSWindow.NSBorderlessWindowMask) {
      return;
    }

    //
    // Button stuff
    //
    var btnx:Number = x + width - 4 / 2 - BUTTON_SIDE_LENGTH;
    var btny:Number = y + (height - BUTTON_SIDE_LENGTH) / 2 + 1;
    var btnCnt:Number = 0;
    var lastButton:NSButton = null; // used for title sizing

    //
    // Close button
    //
    if (styleMask & NSWindow.NSTitledWindowMask
        && styleMask & NSWindow.NSClosableWindowMask) {
      if (m_closeBtn.superview() == null) {
        addSubview(m_closeBtn);
        m_closeBtn.setFrameOrigin(new NSPoint(btnx, btny));
      }

      lastButton = m_closeBtn;
      btnCnt++;
      btnx -= (BUTTON_SIDE_LENGTH + BUTTON_SPACING);
    } else {
      m_closeBtn.removeFromSuperview();
    }

    //
    // Miniaturize button
    //
    if (styleMask & NSWindow.NSTitledWindowMask
        && styleMask & NSWindow.NSMiniaturizableWindowMask) {
      if (m_miniBtn.superview() == null) {
        addSubview(m_miniBtn);
        m_miniBtn.setFrameOrigin(new NSPoint(btnx, btny));
      }

      lastButton = m_miniBtn;
      btnCnt++;
    } else {
      m_miniBtn.removeFromSuperview();
    }

    //
    // Draw the title.
    //
    if (styleMask & NSWindow.NSTitledWindowMask) {
      m_titleCell.setTextColor(isKey ? m_titleKeyFontColor : m_titleFontColor);
      m_titleCell.setFont(m_titleFont);
      m_titleCell.setStringValue(m_window.title());

      var titleRect:NSRect = m_titleRect.clone();
      if (lastButton != null) {
        titleRect.size.width = lastButton.frame().origin.x;
      }

      titleRect = titleRect.insetRect(3, 2);

      if (hasIcon) {
        titleRect.origin.x = iconRect.maxX() + 1;
        titleRect.size.width -= iconRect.maxX();
      }

      m_titleCell.drawWithFrameInView(titleRect, this);

      //
      // If the cell has been truncated, set up a tooltip
      //
      removeToolTip(m_titleToolTipTag);
      if (m_titleCell.isTruncated()) {
        m_titleToolTipTag = addToolTipRectOwnerUserData(titleRect, m_window.title(), null);
      }
    } else {
      height = 0;
    }
  }

  public function titleRect():NSRect {
  	return m_titleRect.clone();
  }

}