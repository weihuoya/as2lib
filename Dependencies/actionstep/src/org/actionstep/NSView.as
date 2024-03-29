/* See LICENSE for copyright and terms of use */
 
import org.actionstep.ASUtils;
import org.actionstep.constants.NSDragOperation;
import org.actionstep.constants.NSWindowOrderingMode;
import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSClipView;
import org.actionstep.NSCursor;
import org.actionstep.NSDraggingDestination;
import org.actionstep.NSDraggingInfo;
import org.actionstep.NSDraggingSource;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSImage;
import org.actionstep.NSMenu;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSPasteboard;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSResponder;
import org.actionstep.NSScrollView;
import org.actionstep.NSSize;
import org.actionstep.NSWindow;
import org.actionstep.toolTip.ASToolTip;

/**   
 * <p>The root of all evil. This is the base class for all visual objects in 
 * ActionStep.</p>
 * 
 * <p><strong>Subclassing notes:</strong>
 * <ul>
 * <li>
 *   A view is drawn using the {@link #drawRect} method.
 * </li>
 * </ul>
 * </p>
 * 
 * @author Richard Kilmer
 * @author Scott Hyndman
 */
class org.actionstep.NSView extends NSResponder 
	implements NSDraggingDestination {
  
  //****************************************************** 
  //*                   Constants
  //******************************************************
  
  /** The receiver cannot be resized. */
  public static var NotSizable:Number = 0;
  /** The left margin between the receiver and its superview is flexible. */
  public static var MinXMargin:Number = 1;
  /** The receiver’s width is flexible. */
  public static var WidthSizable:Number = 2;
  /** The right margin between the receiver and its superview is flexible. */
  public static var MaxXMargin:Number = 4;
  /** The bottom margin between the receiver and its superview is flexible. */
  public static var MinYMargin:Number = 8; 
  /** The receiver’s height is flexible. */
  public static var HeightSizable:Number = 16;
  /** The top margin between the receiver and its superview is flexible. */
  public static var MaxYMargin:Number = 32;
  
  /** The maximum depth at which a MovieClip can exist. */
  public static var MaxClipDepth:Number = 1048575;
  /** The minimum depth at which a MovieClip can exist. */
  public static var MinClipDepth:Number = -16384;
  
  //****************************************************** 
  //*                   Notifications
  //******************************************************
  
  /**
   * Posted when a view's frame changes size or location.
   */
  public static var NSViewFrameDidChangeNotification:Number 
    = ASUtils.intern("NSViewFrameDidChangeNotification");
    
  /**
   * Posted when a view's bounds change size or location.
   */
  public static var NSViewBoundsDidChangeNotification:Number 
    = ASUtils.intern("NSViewBoundsDidChangeNotification");
  
  //****************************************************** 
  //*                  Class Members
  //******************************************************
  
  private static var g_viewCounter:Number = 0;
    
  //****************************************************** 
  //*                 Member variables
  //******************************************************
  
  private var m_viewNum:Number;
  private var m_frame:NSRect;
  private var m_frameRotation:Number;
  private var m_postsFrameChangedNotifications:Boolean;

  private var m_bounds:NSRect;
  private var m_boundsRotation:Number;
  private var m_postsBoundsChangedNotifications:Boolean;

  private var m_window:NSWindow;
  private var m_superview:NSView;
  private var m_subviews:Array;
  
  private var m_notificationCenter:NSNotificationCenter;
  
  private var m_autoresizesSubviews:Boolean;
  private var m_autoresizingMask:Number;
  
  private var m_hidden:Boolean;
  private var m_needsDisplay:Boolean;
  
  // key view loop
  private var m_nextKeyView:NSView;
  private var m_previousKeyView:NSView;
  
  // MovieClip variables
  private var m_mcFrame:MovieClip;
  private var m_mcFrameMask:MovieClip;
  private var m_mcBounds:MovieClip;
  private var m_mcDepth:Number;
  
  /**
   * An array of tracking rects for this view.
   */
  private var m_trackingRects:NSArray;
  private var m_hasTrackingRects:Boolean;
  
  /**
   * An array of cursor rects for this view.
   */
  private var m_cursorRects:NSArray;
  private var m_hasCursorRects:Boolean;
  
  /**
   * An array of tooltip rects for this view.
   */
  private var m_toolTipRects:NSArray;
  private var m_hasToolTips:Boolean;
  
  /** The tool tip tag for this view. */
  private var m_toolTipTag:Number;
  
  private var m_draggedTypes:NSArray;
  
  //****************************************************** 
  //*                  Construction
  //******************************************************
  
  /**
   * Creates a new instance of NSView. Creation of the view should be followed
   * by a call to one of the initializers.
   * 
   * @see #init
   * @see #initWithFrame
   */
  public function NSView() {
  	m_viewNum = g_viewCounter++; // unique ID
  	
    m_frame = null;
    m_frameRotation = 0;
    m_postsFrameChangedNotifications = false;
    
    m_bounds = null;
    m_boundsRotation = 0;
    m_postsBoundsChangedNotifications = false;
    
    m_window = null;
    m_superview = null;
    m_subviews = new Array();
    
    m_autoresizesSubviews = true;
    m_autoresizingMask = NotSizable;
    
    m_mcDepth = 10;
    m_hidden = false;
    m_needsDisplay = false;
    
    m_trackingRects = NSArray.array();
    m_hasTrackingRects = false;
    m_cursorRects = NSArray.array();
    m_hasCursorRects = false;
    m_toolTipRects = NSArray.array();
    m_hasToolTips = false;
    
    //
    // Default menu
    //
    setMenu(NSMenu(getClass().defaultMenu()));
  }
  
  /**
   * Default initializer. Initializes the view with a frame of 
   * {@link NSRect.ZeroRect} and returns a reference to the newly created 
   * view.
   */
  public function init():NSView {
    return initWithFrame(NSRect.ZeroRect);
  }
  
  /**
   * Initializes the view with the frame <code>newFrame</code> and returns
   * a reference to the newly created view.
   */
  public function initWithFrame(newFrame:NSRect):NSView {
    m_notificationCenter = NSNotificationCenter.defaultCenter();
    m_frame = newFrame.clone();
    m_bounds = new NSRect(0, 0, m_frame.size.width, m_frame.size.height);
    
    frameDidChange(newFrame);
    
    return this;
  }
  
  //****************************************************** 
  //*                Describing objects
  //******************************************************
  
  /**
   * Returns the unique view identifier of this view.
   * 
   * For internal use only.
   */
  public function viewNum():Number {
    return m_viewNum;
  }
  
  /**
   * Returns a string representation of the view. This method should be 
   * overridden in subclasses.
   */
  public function description():String {
    return "NSView(frame="+m_frame+", bounds="+m_bounds+" clip="+m_mcFrame+")";
  }
  
  //****************************************************** 
  //*      MovieClip methods (ActionStep specific)                       
  //******************************************************
  
  /**
   * The movieclip that "frames" the control. 
   * 
   * This method throws an exception if <code>mcBounds()</code> is undefined.
   * 
   * @see #mcBounds()
   */
  public function mcFrame():MovieClip {
    if (m_mcFrame == undefined) {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        "NSException",
        "Cannot access frame movieclip until NSView is inserted into view hierarchy.",
        null);
      trace(e);
      throw e;
    }
    return m_mcFrame;
  }
  
  /**
   * The movieclip that the control is drawn upon.
   * 
   * This method throws an exception if <code>mcBounds()</code> is undefined.
   * 
   * @see #mcFrame()
   */
  public function mcBounds():MovieClip {
    if (m_mcBounds == undefined) {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        "NSException",
        "Cannot access bounds movieclip until NSView is inserted into view hierarchy.",
        null);
      trace(e);
      throw e;
    }
    return m_mcBounds;
  }
  
  /**
   * Creates the bounds movieclip and returns it.
   * 
   * This method should rarely, if ever, be overridden.
   */
  public function createBoundsMovieClip():MovieClip {
    var bounds:MovieClip = this.mcBounds();
    var clipDepth:Number = getNextDepth();
    return bounds.createEmptyMovieClip("NSView"+clipDepth, clipDepth);
  }
  
  /**
   * Returns the next available z-depth of the frame movieclip.
   */
  public function getNextDepth():Number {
    return m_mcDepth++;
  }
  
  /**
   * Creates a textfield on the bounds movieclip, and returns it.
   * 
   * This method should rarely, if ever, be overridden.
   */
  public function createBoundsTextField():TextField {
    var bounds:MovieClip = this.mcBounds();
    var clipDepth:Number = m_mcDepth++;
    bounds.createTextField("TextField"+clipDepth, clipDepth, 0, 0, 0, 0);
    bounds["TextField"+clipDepth].view = this;
    return bounds["TextField"+clipDepth];
  }  
  
  /**
   * Creates movieclips necessary for this view.
   * 
   * This method should rarely, if ever, be overridden.
   */
  public function createMovieClips():Boolean {
    if (m_mcFrame != null)
    {
       //return if already created
       return true;
    }
    try {
      m_mcFrame = createFrameMovieClip();
    } catch (error:Error) {
      m_mcFrame = null;
      return false;
    }
    m_mcFrame.view = this;

    m_mcFrameMask = m_mcFrame.createEmptyMovieClip("m_mcFrameMask", 1);
    m_mcFrameMask._x = 0;
    m_mcFrameMask._y = 0;
    m_mcFrame.setMask(m_mcFrameMask);
    updateFrameMovieClipSize();
    updateFrameMovieClipPerspective();
    initializeBoundsMovieClip();
    
    return true;
  }
  
  /**
   * Creates the frame movie clip.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function createFrameMovieClip():MovieClip {
    return m_superview.createBoundsMovieClip();
  }
  
  /**
   * Initializes the bounds movie clip.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function initializeBoundsMovieClip():Void {
    m_mcBounds = m_mcFrame.createEmptyMovieClip("m_mcBounds", 2);
    m_mcBounds.view = this;
    updateBoundsMovieClip();
    for(var i:Number=0;i<m_subviews.length;i++) {
      m_subviews[i].createMovieClips();
    }
  }
  
  /**
   * Updates the size of the frame movieclip.
   * 
   * Called when the size of the frame changes.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function updateFrameMovieClipSize():Void {
    if (m_mcFrame == null) {
      return;
    }
    m_mcFrame.clear();
    m_mcFrame.beginFill(0x000000, 0);
    m_mcFrame.moveTo(0,0);
    m_mcFrame.lineTo(m_frame.size.width, 0);
    m_mcFrame.lineTo(m_frame.size.width, m_frame.size.height);
    m_mcFrame.lineTo(0, m_frame.size.height);
    m_mcFrame.endFill();
    m_mcFrame.lineTo(0, 0);
    updateFrameMovieClipPosition();

    m_mcFrameMask.clear();
    m_mcFrameMask.beginFill(0x000000, 100);
    m_mcFrameMask.moveTo(0,0);
    m_mcFrameMask.lineTo(m_frame.size.width, 0);
    m_mcFrameMask.lineTo(m_frame.size.width, m_frame.size.height);
    m_mcFrameMask.lineTo(0, m_frame.size.height);
    m_mcFrameMask.endFill();
    m_mcFrameMask.lineTo(0, 0);
  }
  
  /**
   * Updates the position of the frame movieclip. This is called when the origin 
   * of the frame changes.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function updateFrameMovieClipPosition():Void {
    if (m_mcFrame == null) {
      return;
    }
    m_mcFrame._x = m_frame.origin.x;
    m_mcFrame._y = m_frame.origin.y;
  }
  
  /**
   * Updates the perspective on this frame movieclip. This is called after the
   * frame is rotated or is hidden/shown.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function updateFrameMovieClipPerspective():Void {
    if (m_mcFrame == null) {
      return;
    }
    m_mcFrame._rotation = m_frameRotation;
    if (m_mcFrame._visible != !m_hidden) {
      m_mcFrame._visible = !m_hidden;
      if (m_hidden) {
        m_mcFrame._x = 4000;
        m_mcFrame._y = 4000;
      } else {
        m_mcFrame._x = m_frame.origin.x;
        m_mcFrame._y = m_frame.origin.y;
      }
    }
  }

  /**
   * Updates the location of the bounds movieclip.
   * 
   * This method should rarely, if ever, be overridden.
   */
  private function updateBoundsMovieClip():Void {
    if (m_bounds != undefined) {
      m_mcBounds._x = -m_bounds.origin.x;
      m_mcBounds._y = -m_bounds.origin.y;
    }
    
    m_mcBounds._rotation = m_boundsRotation;
  }
  
  /**
   * Removes all movieclips associated with the view.
   * 
   * This method should rarely, if ever, be overridden.
   */
  public function removeMovieClips():Void {
    for(var i:Number=0;i<m_subviews.length;i++) {
      m_subviews[i].removeMovieClips();
    }
    release();
    m_mcFrame.removeMovieClip();
    m_mcFrame = null;
    m_mcFrameMask = null;
    m_mcBounds = null;
  }

  //****************************************************** 
  //*          Managing the view hierarchy                       
  //******************************************************
      
  /**
   * Returns the parent of this view, or <code>null</code> if it has none.
   */
  public function superview():NSView {
    return m_superview;
  }
  
  /**
   * Returns an array of this view's subviews. That is, subviews that exist
   * within this view.
   */
  public function subviews():Array {
    return m_subviews;
  }
  
  /**
   * Returns the window this view exists within, or <code>null</code> if it
   * has none.
   */
  public function window():NSWindow {
    return m_window;
  }
  
  /**
   * Adds the view <code>view</code> as a subview of this view.
   * 
   * This method will throw an exception if <code>view</code> is already 
   * a descendant of this view.
   * 
   * @see #addSubviewPositionedRelativeTo
   */
  public function addSubview(view:NSView):Void {
    addSubviewPositionedRelativeTo(view, NSWindowOrderingMode.NSWindowAbove, null);    
  }
  
  /**
   * Adds the view <code>view</code> as a subview of this view. It will be 
   * displayed above or below <code>otherView</code> as specified by
   * the <code>positioned</code> argument.
   * 
   * If <code>otherView</code> is <code>null</code>, <code>view</code> is 
   * inserted relative to all the other subviews of this view. 
   * 
   * This method will throw an exception if <code>view</code> is already
   * a descendant of this view.
   *
   * @see #addSubview
   */
  public function addSubviewPositionedRelativeTo(view:NSView, 
      positioned:NSWindowOrderingMode, otherView:NSView):Void {
    if (view.isDescendantOf(this)) {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        "ViewHierarchyError", "Cannot add a view to its child", null);
      trace(e);
      e.raise();
    }
    var i:Number;
    var len:Number = m_subviews.length;

    if (positioned == null) {
      //default to placing the new view above if no ordering is given
      positioned = NSWindowOrderingMode.NSWindowAbove;
    }
    if (otherView == null) {
      switch (positioned) {
        case NSWindowOrderingMode.NSWindowBelow:
          i = 0;
          break;
        case NSWindowOrderingMode.NSWindowAbove:
        case NSWindowOrderingMode.NSWindowOut:
          //! How to handle this? (defaulting to NSWindowAbove)
        default:
          i = len;
      }
    } else {
      for(i = 0; i < len; i++) {
        if (m_subviews[i] == otherView) {
          break;
        }
      }
      switch (positioned) {
        case NSWindowOrderingMode.NSWindowBelow:
          break;
        case NSWindowOrderingMode.NSWindowAbove:
        case NSWindowOrderingMode.NSWindowOut:
          //! How to handle this? (defaulting to NSWindowAbove)
        default:
          i++;
      }
    }
    
    view.removeFromSuperview();
    view.viewWillMoveToSuperview(this);
    view.viewWillMoveToWindow(m_window);
    view.setNextResponder(this);
    m_subviews.splice(i, 0, view);
    view.resetCursorRects(); 
    view.setNeedsDisplay(true);
    view.viewDidMoveToWindow();
    view.viewDidMoveToSuperview();
    didAddSubview(view);
  }
  
  /**
   * This method should be overridden by subclasses to perform operations
   * on the newly added subview <code>view</code>.
   */
  public function didAddSubview(view:NSView):Void {
  }
  
  /**
   * Removes this view from its superview.
   * 
   * @see #removeFromSuperviewWithoutNeedingDisplay
   */
  public function removeFromSuperview():Void {
    removeFromSuperviewNeedsDisplay(true);
  }
  
  /**
   * Removes this view from its superview without invalidating cursor rectangles
   * to cause redisplay.
   * 
   * @see #removeFromSuperview
   */
  public function removeFromSuperviewWithoutNeedingDisplay():Void {
    removeFromSuperviewNeedsDisplay(false);
  }
  
  /**
   * Removes this view from the superview.
   * 
   * If <code>flag</code> is <code>true</code>, the view will be marked as 
   * needing redisplay.
   */
  private function removeFromSuperviewNeedsDisplay(flag:Boolean):Void {
    var superview:NSView = m_superview;
    var view:NSView;
    
    //
    // Don't do anything if we don't have a superview.
    //
    if (superview == null) { 
      return;
    }
    
    if (flag) {
      superview.setNeedsDisplay(true);
    }
    
    for (view = NSView(m_window.firstResponder()); 
        view != null && view["superview"] != undefined;
        view = view.superview()) {
      if (view == this) {
        m_window.makeFirstResponder(m_window);
        break;
      }
    }
    
    superview.willRemoveSubview(this);
    m_superview = null;
    viewWillMoveToWindow(null);
    m_window = null;
    viewWillMoveToSuperview(null);
    setNextResponder(null);
    discardCursorRects(); // invalidate cursor rects
    
    var i:Number;
    var parentSubviews:Array = superview.subviews();
    for(i=0;i<parentSubviews.length;i++) {
      if (parentSubviews[i] == this) {
        parentSubviews.splice(i,1);
        break;
      }
    }
    setNeedsDisplay(false);
    viewDidMoveToWindow();
    viewDidMoveToSuperview();
  }
  
  /**
   * Replaces <code>oldView</code> with <code>newView</code> in this view. If
   * <code>oldView</code> is not a subview of this view, then this method does
   * nothing.
   * 
   * @see #addSubview
   * @see #addSubviewPositionedRelativeTo
   */
  public function replaceSubviewWith(oldView:NSView, newView:NSView):Void {
    if (oldView == null || newView == null) return;
    var i:Number;
    for(i=0;i<m_subviews.length;i++) {
      if (m_subviews[i] == oldView) {
        break;
      }
    }
    if (i == m_subviews.length) {
      return; // oldview does not exist
    }
    
    newView.removeFromSuperview();
    oldView.removeFromSuperview();
    newView.viewWillMoveToWindow(m_window);
    newView.viewWillMoveToSuperview(this);
    newView.setNextResponder(this);
    m_subviews.splice(i, 0, newView);
    newView.resetCursorRects();
    newView.setNeedsDisplay(true);
    newView.viewDidMoveToWindow();
    newView.viewDidMoveToSuperview();
    didAddSubview(newView);
  }
  
  /**
   * Returns <code>true</code> if <code>view</code> is a descendant of
   * this view.
   */
  public function isDescendantOf(view:NSView):Boolean {
    var check:NSView = m_superview;
    while(check != null) {
      if (check == view) return true;
      check = check.superview();
    }
    return false;
  }
  
  /**
   * Returns this view's closest opaque ancestor (climbs up the view tree).
   */
  public function opaqueAncestor():NSView {
    if (isOpaque()) {
      return this;
    } else {
      return m_superview.opaqueAncestor();
    }
  }
  
  /**
   * Returns the first ancestor shared between this view and <code>view</code>.
   */
  public function ancestorSharedWithView(view:NSView):NSView {
    if (view == this) {
      return this;
    }
    var check:NSView = view.superview();
    while(check != null) {
      if (this.isDescendantOf(check)) return check;
      check = check.superview();
    }
    return null;
  }
  
  /**
   * Sorts the subviews array using the sort function <code>func</code>.
   * 
   * @see #subviews
   */
  public function sortSubviewsUsingFunction(func:Function):Void {
    m_subviews = m_subviews.sort(func);
  }
  
  /**
   * This method is called when this view is successfully added to a new
   * superview.
   * 
   * This method should be overridden in subclasses when additional behavior
   * is required.  
   */
  public function viewDidMoveToSuperview():Void {
  }

  /**
   * This method is called when this view is moved to a new window.
   * 
   * This method should be overridden in subclasses when additional behavior
   * is required.  
   */
  public function viewDidMoveToWindow():Void {
  }
  
  /**
   * This method is called before this view is added to the new superview,
   * <code>view</code>. The default behavior is to create or remove movieclips
   * if the superview is non-null or null respectively.
   * 
   * This method should be overridden when additional behavior is required.
   */
  public function viewWillMoveToSuperview(view:NSView):Void {
    m_superview = view;
    if (m_superview == null) {
      removeMovieClips();
    } else {
      createMovieClips();
    }
  }

  /**
   * <p>This method is called before this view is added to the new window, 
   * <code>window</code>.</p>
   * 
   * <p>This method should be overridden when additional behavior is required.</p>
   */
  public function viewWillMoveToWindow(window:NSWindow):Void {
  	if (m_window != null) {
  		m_window.unregisterDraggedTypesForView(this);
  	}
  	
    m_window = window;
    setNeedsDisplay(true);
    for(var i:Number=0;i<m_subviews.length;i++) {
      m_subviews[i].viewWillMoveToWindow(window);
    }
    
    if (null != m_draggedTypes) {
      m_window.registerViewForDraggedTypes(this, m_draggedTypes);
    }
  }
  
  /**
   * <p>This method is called before <code>view</code> is removed from the 
   * subviews array.</p>
   * 
   * <p>This method should be overridden when additional behavior is required.</p>
   */
  public function willRemoveSubview(view:NSView):Void {
  }
  
  //******************************************************
  //*                Searching by tag
  //******************************************************
  
  /**
   * Returns this view's nearest descendant with the tag <code>tagToFind</code>.
   * 
   * @see #tag
   */
  public function viewWithTag(tagToFind:Number):NSView {
    //
    // If this view is tagged with tagToFind, then go no further
    //
    if (tag() == tagToFind) {
      return this;
    }
    
	//
    // Search subviews
    //
    var i:Number;
    var view:NSView = null;
    for(i=0;i<m_subviews.length;i++) {
      if (m_subviews[i].tag() == tagToFind) {
        return m_subviews[i];
      }
    }
    
    //
    // Search subtrees.
    //
    for(i=0;i<m_subviews.length;i++) {
      view = m_subviews[i].viewWithTag(tagToFind);
      if (view != null) {
        return view;
      }
    }
    
    return null; // Not found
  }
  
  /**
   * <p>Returns the tag associated with this view. A tag is an identifier.</p> 
   * 
   * <p>By default, there is no way to set a tag. A method to do so can be added
   * in a subclass if you deem it necessary.</p>
   * 
   * @see #viewWithTag
   */
  public function tag():Number {
    return -1;
  }
  
  //****************************************************** 
  //*           Modifying the frame rectangle                       
  //******************************************************
  
  /**
   * <p>Sets the frame of this view, that is the area in which this view is
   * displayed, to <code>newFrame</code>.</p>
   * 
   * <p>Subviews will be resized using {@link #resizeSubviewsWithOldSize()}</p>
   * 
   * <p>{@link #frameDidChange()} is called by this method.</p>
   * 
   * <p>If this view posts frame notifications 
   * ({@link #postsFrameChangedNotifications()}), an
   * <code>NSViewFrameDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.</p>
   */
  public function setFrame(newFrame:NSRect):Void {
    var changedOrigin:Boolean = !m_frame.origin.isEqual(newFrame.origin);
    var changedSize:Boolean = !m_frame.size.isEqual(newFrame.size);
    if (changedSize || changedOrigin) {
      var oldFrame:NSRect = frame();
      m_frame = newFrame.clone();
                  
      updateFrameMovieClipSize();
      
      if (changedSize) {
        resizeSubviewsWithOldSize(oldFrame.size); // resize subviews
        if (m_bounds == null) {
          m_bounds = new NSRect(0,0,m_frame.size.width, m_frame.size.height);
        } else {
          m_bounds.size = m_frame.size.clone();
        }
        resetToolTips();
      }
      m_window.invalidateCursorRectsForView(this);
      
      if(m_postsFrameChangedNotifications) {
        m_notificationCenter.postNotificationWithNameObject(
          NSViewFrameDidChangeNotification, this);
      }
      
      frameDidChange(oldFrame);
    }
  }
  
  /**
   * Returns this view's frame rectangle, which is its position represented
   * in the coordinate system of its superview.
   * 
   * @see #setFrame
   * @see #bounds
   */
  public function frame():NSRect {
    return m_frame.clone();
  }
  
  /**
   * <p>Sets the origin of this views frame to <code>origin</code>.</p>
   * 
   * <p>{@link #frameDidChange()} is called by this method.</p>
   * 
   * <p>If this view posts frame notifications 
   * ({@link #postsFrameChangedNotifications()}), an
   * <code>NSViewFrameDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.</p>
   */
  public function setFrameOrigin(origin:NSPoint):Void {
  	if (m_frame.origin.isEqual(origin)) {
  	  return;
  	}
  	
  	var oldFrame:NSRect = frame();
  	
    m_frame.origin.x = origin.x;
    m_frame.origin.y = origin.y;
    updateFrameMovieClipPosition();
    m_window.invalidateCursorRectsForView(this);
    if(m_postsFrameChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewFrameDidChangeNotification, this);
    }
    
    frameDidChange(oldFrame);
  }

  /**
   * <p>Sets the size of this view's frame to <code>size</code>.</p>
   * 
   * <p>Subviews will be resized using {@link #resizeSubviewsWithOldSize()}.</p>
   * 
   * <p>{@link #frameDidChange()} is called by this method.</p>
   * 
   * <p>If this view posts frame notifications 
   * ({@link #postsFrameChangedNotifications()}), an
   * <code>NSViewFrameDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.</p>
   */
  public function setFrameSize(size:NSSize):Void {
  	if (m_frame.size.isEqual(size)) {
  	  return;
  	}
  	
    var oldFrame:NSRect = frame();
    m_frame.size = size.clone();
    m_bounds.size = size.clone();
    resizeSubviewsWithOldSize(oldFrame.size);
    updateFrameMovieClipSize();
    resetToolTips();
    m_window.invalidateCursorRectsForView(this);
    if(m_postsFrameChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewFrameDidChangeNotification, this);
    }
    
    frameDidChange(oldFrame);
  }
  
  /**
   * <p>Sets the rotation of this view's frame to <code>angle</code>.</p>
   * 
   * <p>If this view posts frame notifications 
   * ({@link #postsFrameChangedNotifications()}), an
   * <code>NSViewFrameDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.</p>
   */
  public function setFrameRotation(angle:Number):Void {
    m_frameRotation = angle;
    updateFrameMovieClipPerspective();
    if(m_postsFrameChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewFrameDidChangeNotification, this);
    }
  }
  
  /**
   * Returns the rotation of the frame in degrees.
   */
  public function frameRotation():Number {
    return m_frameRotation;
  }
  
  /**
   * <p>Invoked when the frame changes. <code>oldFrame</code> is the previous
   * frame size. </p>
   * 
   * <p>This method is intended to be overridden in subclasses.</p>
   * 
   * <p>This method is ActionStep only.</p>
   */
  private function frameDidChange(oldFrame:NSRect):Void {
  
  }
  
  //****************************************************** 
  //*           Modifying the bounds rectangle                       
  //******************************************************
  
  /**
   * <p>Sets the bounds of this view, that is the area in which this view is
   * drawn, to <code>bounds</code>.</p>
   * 
   * <p>If this view posts frame notifications 
   * ({@link #postsBoundsChangedNotifications()}), an
   * <code>NSViewBoundsDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.</p>
   */
  public function setBounds(bounds:NSRect):Void {
    m_bounds = bounds.clone();
    resetCursorRects();
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }

  /**
   * Returns this view's bounds rectangle, which is its position represented
   * in this view's coordinate system.
   * 
   * @see #frame
   * @see #setBounds
   */
  public function bounds():NSRect {
    return m_bounds.clone();
  }

  /**
   * Sets the origin of this view's bounds to <code>origin</code>.
   * 
   * If this view posts frame notifications 
   * ({@link #postsBoundsChangedNotifications()}), an
   * <code>NSViewBoundsDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.
   */
  public function setBoundsOrigin(origin:NSPoint):Void {
    m_bounds.origin = origin.clone();
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }

  /**
   * Sets the size of this view's bounds to <code>size</code>.
   * 
   * If this view posts frame notifications 
   * ({@link #postsBoundsChangedNotifications()}), an
   * <code>NSViewBoundsDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.
   */
  public function setBoundsSize(size:NSSize):Void {
    m_bounds.size = size.clone();
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }

  /**
   * Sets the rotation of this view's bounds to <code>angle</code>.
   * 
   * If this view posts frame notifications 
   * ({@link #postsBoundsChangedNotifications()}), an
   * <code>NSViewBoundsDidChangeNotification</code> notification will be 
   * dispatched to the default notification center.
   */
  public function setBoundsRotation(angle:Number):Void {
    m_boundsRotation = angle;
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }

  /**
   * Returns the rotation of the bounds rectangle in degrees.
   * 
   * @see #setBoundsRotation
   */
  public function boundsRotation():Number {
    return m_boundsRotation;
  }
  
  //****************************************************** 
  //*          Modifying the coordinate system
  //******************************************************
  
  public function translateOriginToPoint(point:NSPoint):Void {
    m_bounds.origin.x -= point.x;
    m_bounds.origin.y -= point.y;
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }
  
  public function scaleUnitSquareToSize(size:NSSize):Void {
    size = size.clone();
    if (size.width < 0) {
      size.width = 0;
    }
    if (size.height < 0) {
      size.height = 0;
    }
    m_bounds.size.width = m_bounds.size.width / size.width;
    m_bounds.size.height = m_bounds.size.height / size.height;
    updateBoundsMovieClip();
    if(m_postsBoundsChangedNotifications) {
      m_notificationCenter.postNotificationWithNameObject(
        NSViewBoundsDidChangeNotification, this);
    }
  }
  
  public function rotateByAngle(angle:Number):Void { 
   setBoundsRotation(boundsRotation() + angle);
  }
     
  //****************************************************** 
  //*      Examining coordiante system modifications
  //******************************************************
  
  //****************************************************** 
  //*              Converting Coordinates	
  //******************************************************
  
  /**
   * Converts aPoint from the coordinate system of aView to this view's
   * coordinate system.
   *
   * If aView is null, aPoint is converted from global coordinates (_root).
   */
  public function convertPointFromView(aPoint:NSPoint, aView:NSView):NSPoint {
    var pt:NSPoint = aPoint.clone();
    if (m_mcBounds != null) { // Simple case
      var from:MovieClip = (aView == null) ? _root : aView.mcBounds();
      from.localToGlobal(pt);
      mcBounds().globalToLocal(pt);
    } else { // Difficult case
    }
    return pt;
  }
  
  
  /**
   * Converts aPoint from this view's coordinate system to the coordinate
   * system of aView.
   *
   * If aView is null, aPoint is converted to global coordinates (_root).
   */
  public function convertPointToView(aPoint:NSPoint, aView:NSView):NSPoint {
    var pt:NSPoint = aPoint.clone();
    if (m_mcBounds != null) { // Simple case
      var to:MovieClip = (aView == null) ? _root : aView.mcBounds();
      mcBounds().localToGlobal(pt);
      to.globalToLocal(pt);
    } else { // Difficult case
    }
    return pt;
  }
  

  /**
   * Converts aSize from the coordinate system of aView to this view's
   * coordinate system.
   *
   * If aView is null, aSize is converted from global coordinates (_root).
   */
  public function convertSizeFromView(aSize:NSSize, aView:NSView):NSSize {
    var wdt:NSPoint = convertPointFromView(new NSPoint(aSize.width, 0), aView);
    var hgt:NSPoint = convertPointFromView(new NSPoint(0, aSize.height), aView);
  	
    return new NSSize(wdt.x, hgt.y);
  }
  
  
  /**
   * Converts aSize from this view's coordinate system to the coordinate
   * system of aView.
   *
   * If aView is null, aSize is converted to global coordinates (_root).
   */
  public function convertSizeToView(aSize:NSSize, aView:NSView):NSSize {
  	var ori:NSPoint = convertPointToView(NSPoint.ZeroPoint, aView);
    var wdt:NSPoint = convertPointToView(new NSPoint(aSize.width, 0), aView);
    var hgt:NSPoint = convertPointToView(new NSPoint(0, aSize.height), aView);
  	
    return new NSSize(wdt.x - ori.x, hgt.y - ori.y);
  }
  
  
  /**
   * Converts aRect from the coordinate system of aView to this view's
   * coordinate system.
   *
   * If aView is null, aRect is converted from global coordinates (_root).
   */
  public function convertRectFromView(aRect:NSRect, aView:NSView):NSRect {
    var pt:NSPoint = convertPointFromView(aRect.origin, aView);
    var sz:NSSize = convertSizeFromView(aRect.size, aView);
  	
    return NSRect.withOriginSize(pt, sz);
  }
  
  
  /**
   * Converts aRect from this view's coordinate system to the coordinate
   * system of aView.
   *
   * If aView is null, aRect is converted to global coordinates (_root).
   */
  public function convertRectToView(aRect:NSRect, aView:NSView):NSRect {
    var pt:NSPoint = convertPointToView(aRect.origin, aView);
    var sz:NSSize = convertSizeToView(aRect.size, aView);
  	
    return NSRect.withOriginSize(pt, sz);
  }
  
  //****************************************************** 
  //*                  Scrolling
  //******************************************************
  
  public function scrollPoint(point:NSPoint):Void {
    var view:NSView = m_superview;
    while (view != null && view.getClass()!=NSClipView) {
      view = view.superview();
    }
    if (view != null) {
      point = convertPointToView(point, view);
      if (!point.isEqual(view.bounds().origin)) {
        NSClipView(view).scrollToPoint(point);
      }
    }
  }
  
  /**
   * Scrolls this view's drawing surface the minimum distance for
   * aRect to be completely visible. 
   * 
   * Returns <code>true</code> if scrolling is performed, 
   * <code>false</code> otherwise.
   */
  public function scrollRectToVisible(aRect:NSRect):Boolean {
    var view:NSView = m_superview;
    while (view != null && view.getClass()!=NSClipView) {
      view = view.superview();
    }
    if (view != null) {
      var vRect:NSRect = visibleRect();
      var scrollPoint:NSPoint = vRect.origin.clone();
      if (vRect.size.width == 0 && vRect.size.height == 0) {
        return false;
      }
      var ldiff:Number = vRect.minX() - aRect.minX();
      var rdiff:Number = aRect.maxX() - vRect.maxX();
      var tdiff:Number = vRect.minY() - aRect.minY();
      var bdiff:Number = aRect.maxY() - vRect.maxY();
      
      if ((ldiff*rdiff) > 0) ldiff = rdiff = 0;
      if ((tdiff*bdiff) > 0) tdiff = bdiff = 0;
      scrollPoint.x += (Math.abs(ldiff) < Math.abs(rdiff)) ? (-ldiff) : rdiff;
      scrollPoint.y += (Math.abs(tdiff) < Math.abs(bdiff)) ? (-tdiff) : bdiff;
      if (!vRect.origin.isEqual(scrollPoint)) {
        scrollPoint = convertPointToView(scrollPoint, view);
        NSClipView(view).scrollToPoint(scrollPoint);
        return true;
      }
    }
    return false;
  }
  
  public function autoscroll(event:NSEvent):Boolean {
    if (m_superview) {
      return m_superview.autoscroll(event);
    } else {
      return false;
    }
  }
  
  public function adjustScroll(proposedRect:NSRect):NSRect {
    return proposedRect;
  }
  
  public function scrollRectBy(rect:NSRect, size:NSSize):Void {
    // DO NOTHING 
  }
  
  public function enclosingScrollView():NSScrollView {
    var view:NSView = m_superview;
    while (view != null && view.getClass()!=NSScrollView) {
      view = view.superview();
    }
    return view == null ? null : NSScrollView(view);
  }
  
  public function scrollClipViewToPoint(clipView:NSClipView, point:NSPoint):Void {
    //DO NOTHING
  }
  
  public function reflectScrolledClipView(clipView:NSClipView):Void {
    //DO NOTHING
  }
  
  //****************************************************** 
  //*             Context-sensitive menus
  //******************************************************
  
  /**
   * This method is meant to be overridden by subclasses to return a menu
   * specific to the event described by <code>event</code>.
   * 
   * The default behavior returns the view's {@link #menu()}.
   */
  public function menuForEvent(event:NSEvent):NSMenu {
    return menu();
  }
  
  /**
   * Overridden by subclasses to return a view's default menu.
   * 
   * @see #menu()
   */
  public static function defaultMenu():NSMenu {
    return null;
  }
  
  //****************************************************** 
  //*            Managing the key view loop
  //******************************************************
  
  public function canBecomeKeyView():Boolean {
    return acceptsFirstResponder() && !isHiddenOrHasHiddenAncestor();
  }
  
  public function needsPanelToBecomeKey():Boolean {
    return false;
  }
  
  public function setNextKeyView(view:NSView):Void {
    if (view == null || view instanceof NSView) {
      if (view == null) {
        m_nextKeyView.m_previousKeyView = null;
        m_nextKeyView = null;
      } else {
        m_nextKeyView = view;
        view.m_previousKeyView = this;
      }
    } else {
      var e:NSException = NSException.exceptionWithNameReasonUserInfo(
        "NSInternalInconsistencyException",
        "view must be non-null and an NSView instance.",
        null);
      trace(e);
      throw e;
    }
  }
  
  public function nextKeyView():NSView {
    return m_nextKeyView;
  }
  
  public function nextValidKeyView():NSView {
    var result:NSView = m_nextKeyView;
    while (true) {
      if (result == null || result == this || result.canBecomeKeyView()) {
        return result;
      }
      result = result.m_nextKeyView;
    }
  }

  public function previousKeyView():NSView {
    return m_previousKeyView;
  }

  public function previousValidKeyView():NSView {
    var result:NSView = m_previousKeyView;
    while (true) {
      if (result == null || result == this || result.canBecomeKeyView()) {
        return result;
      }
      result = result.m_previousKeyView;
    }
  }
  
  //****************************************************** 
  //*           Managing tracking rectangles
  //******************************************************
  
  /**
   * <p>Creates a new area for tracking mouse events ({@link #mouseEntered()}, 
   * {@link #mouseExisted()}) and returns a tag that identifies the tracking 
   * area (used to remove the tracking area). <code>owner</code> is the object 
   * that will receive the mouse event messages. <code>userData</code> is data 
   * that will be passed along with the event to <code>owner</code>. 
   * <code>flag</code> determines which event is sent first. If 
   * <code>true</code>, the mouse pointer is assumed to be within 
   * <code>aRect</code> and the first event to be fired will be the 
   * {@link #mouseExited()} event when the pointer leaves <code>aRect</code>. 
   * If <code>false</code>, the mouse pointer is assumed to be outside 
   * <code>aRect</code>, and the first event to be fired will be the 
   * {@link #mouseEntered()} event when the pointer enters the area defined by 
   * <code>aRect</code>.</p>
   *
   * <p>Please note that <code>rect</code> is in the view's coordinate system, and
   * must exist within the frame of the view.</p>
   *  
   * <p>If your intention is to change the cursor over an area, use
   * {@link #addCursorRectCursor()} instead.</p>
   * 
   * @see #addCursorRectCursor
   * @see #removeTrackingRect
   */
  public function addTrackingRectOwnerUserDataAssumeInside(aRect:NSRect,
      owner:Object, userData:Object, flag:Boolean):Number {
    var m:Object;
    var t:Number = 0;
    var len:Number = m_trackingRects.count();
    
    for (var i:Number = 0; i < len; i++) {
      m = m_trackingRects.objectAtIndex(i);
      
      if (m.tag > t) {
        t = m.tag;
      }
    }
    
    t++;
    
    aRect = aRect.clone();
    m = {rect: aRect, tag: t, owner: owner, userData: userData, inside: flag};
    m_trackingRects.addObject(m);
    
    m_hasTrackingRects = true;
    
    return t;
  }
  
  /**
   * Removes the tracking rectangle identified by <code>aTag</code>. 
   * <code>aTag</code> is the value returned by the call to 
   * {@link #addTrackingRectOwnerUserDataAssumeInside} that added the tracking
   * rect.
   * 
   * @see #addTrackingRectOwnerUserDataAssumeInside
   */
  public function removeTrackingRect(aTag:Number):Void {
    var idx:Number = m_trackingRects.indexOfObjectWithCompareFunction(
   	  {tag: aTag}, _compareTrackingRectsByTag);
   	
   	if (idx != -1) {
	  m_trackingRects.removeObjectAtIndex(idx);
	  
	  if (m_trackingRects.count() == 0) {
	    m_hasTrackingRects = false;
	  }
   	}
  }
  
  /**
   * Used by {@link #removeTrackingRect()} to determine what tracking rect to
   * remove.
   */
  private function _compareTrackingRectsByTag(a:Object, b:Object):Boolean {
    return a.tag == b.tag;
  }
  
  //****************************************************** 
  //*            Managing cursor rectangles
  //******************************************************

  /**
   * <p>Adds a cursor <code>cursor</code> to be shown whenever the mouse pointer is 
   * within the rectangle <code>aRect</code>.</p>
   * 
   * <p>This method is intended to be invoked only by the 
   * {@link #resetCursorRects()}</code>. If invoked in any other way, the 
   * resulting cursor rectangle will be discarded the next time the NSView’s 
   * cursor rectangles are rebuilt.</p>
   * 
   * <p>Please note that <code>rect</code> is in the view's coordinate system, and
   * must exist within the frame of the view.</p>
   */
  public function addCursorRectCursor(aRect:NSRect, cursor:NSCursor):Void {
  	if (m_window != null) { //! Why?
  	  aRect = aRect.clone();
  	  m_cursorRects.addObject(
  	    {rect: aRect, tag: 0, owner: cursor, userData: null, inside: true});
  	  m_hasCursorRects = true;
  	}
  }
  
  /**
   * Removes a cursor and it's associated rectangle from the view. The cursor
   * and rectangle passed to this method must match exactly the cursor and 
   * rectangle that were passed to {@link #addCursorRectCursor()} to create the 
   * cursor rectangle originally.
   */
  public function removeCursorRectCursor(aRect:NSRect, cursor:NSCursor):Void {
    var idx:Number = m_cursorRects.indexOfObjectWithCompareFunction(
   	  {rect: aRect, owner: cursor}, _compareCursorRects);
   	
   	if (idx != -1) {
	  m_cursorRects.removeObjectAtIndex(idx);
	  
	  if (m_cursorRects.count() == 0) {
	    m_hasCursorRects = false;
	  }
   	}
  }
  
  /**
   * Invalidates all cursor rects. This should never be called directly. It is
   * always called before resetCursorRects().
   */
  public function discardCursorRects():Void {
    if (m_hasCursorRects) {
      m_cursorRects.removeAllObjects();
    }
  }
  
  /**
   * <p>This method should be overridden to define the view's cursor rectangles.</p>
   * 
   * <p>This method should not be called directly. Use 
   * {@link NSWindow#invalidateCursorRectsForView()} to invoke this method.</p>
   * 
   * @see org.actionstep.NSWindow#invalidateCursorRectsForView
   */
  public function resetCursorRects():Void {
    // do nothing
  }
  
  /**
   * Used by {@link #removeCursorRectCursor} to compare cursor rectangles.
   */
  private function _compareCursorRects(a:Object, b:Object):Boolean {
    return a.rect.isEqual(b.rect) && a.owner == b.owner;
  }
  
  //****************************************************** 
  //*                   Tooltips
  //******************************************************
  
  /**
   * <p>Creates a tooltip to appear when the mouse cursor hovers within the area
   * defined by <code>aRect</code> and returns a tag to identify (and remove) 
   * the tooltip. The tooltip string is provided by <code>anObject</code>. If 
   * the object implements the {@link org.actionstep.NSToolTipOwner} interface, 
   * the text returned from {@link NSToolTipOwner#viewStringForToolTipPointUserData}
   * will be used. Otherwise, the tip text will be the text returned from 
   * <code>anObject</code>'s toString() method. <code>userData</code> is any 
   * additional information you wish to pass to 
   * {@link NSToolTipOwner#viewStringForToolTipPointUserData}.</p>
   * 
   * <p><code>aRect</code> should be in the view's coordinate system, and should exist within
   * the frame of the view.</p>
   * 
   * <p>The tooltip will not be hidden when the mouse moves.</p>
   * 
   * @see NSToolTipOwner#viewStringForToolTipPointUserData
   * @see #setToolTip
   * @see #toolTip
   * @see #removeToolTip
   * @see #removeAllToolTips
   */
  public function addToolTipRectOwnerUserData(aRect:NSRect, anObject:Object,
      userData:Object):Number {
    return addToolTipRectOwnerUserDataHideOnMouseMove(aRect, anObject, userData,
      false);  	
  }
  
  /**
   * <p>Creates a tooltip to appear when the mouse cursor hovers within the area
   * defined by <code>aRect</code> and returns a tag to identify (and remove) 
   * the tooltip. The tooltip string is provided by <code>anObject</code>. If 
   * the object implements the {@link org.actionstep.NSToolTipOwner} interface, 
   * the text returned from {@link NSToolTipOwner#viewStringForToolTipPointUserData}
   * will be used. Otherwise, the tip text will be the text returned from 
   * <code>anObject</code>'s toString() method. <code>userData</code> is any 
   * additional information you wish to pass to 
   * {@link NSToolTipOwner#viewStringForToolTipPointUserData}.</p>
   * 
   * <p><code>aRect</code> should be in the view's coordinate system, and should exist within
   * the frame of the view.</p>
   * 
   * <p>If <code>flag</code> is <code>true</code>, the tooltip will be hidden as
   * soon as the mouse moves. If <code>false</code>, it will remain until the
   * mouse leaves the area of <code>aRect</code>.</p>
   * 
   * @see NSToolTipOwner#viewStringForToolTipPointUserData
   * @see #setToolTip
   * @see #toolTip
   * @see #removeToolTip
   * @see #removeAllToolTips
   */
  public function addToolTipRectOwnerUserDataHideOnMouseMove(aRect:NSRect, 
      anObject:Object, userData:Object, flag:Boolean):Number {
    var ttr:Object;
    var t:Number = 0;
    var len:Number = m_toolTipRects.count();
    
    for (var i:Number = 0; i < len; i++) {
      ttr = m_toolTipRects.objectAtIndex(i);
      
      if (ttr.tag > t) {
        t = ttr.tag;
      }
    }
    
    t++;
    
    //
    // Set up user data
    //
    if (userData == null) {
      userData = {};
    }
    
    //
    // Decorate user data with some hidden properties.
    //
    userData["__tipTextProvider"] = anObject;
    userData["__hideOnMouseMove"] = flag;
    _global.ASSetPropFlags(userData, ["__tipTextProvider", "__hideOnMouseMove"], 1);
    
    //
    // Create tool tip rect
    //
    aRect = aRect.clone();
    ttr = {rect: aRect, tag: t, owner: ASToolTip.getInstance(), 
      userData: userData, inside: false};
    m_toolTipRects.addObject(ttr);
    
    //
    // Mark the view as having tool tips.
    //
    m_hasToolTips = true;
    
    return t;
  }
  
  /**
   * Removes the tool tip identified by <code>tag</code>. <code>tag</code> is 
   * the return value of the {@link #addToolTipRectOwnerUserData()} that was 
   * used to create the tool tip.
   * 
   * @see #addToolTipRectOwnerUserData
   * @see #removeAllToolTips
   */
  public function removeToolTip(tag:Number):Void {
  	if (tag == null) {
  	  return;
  	}
  	
    var idx:Number = m_toolTipRects.indexOfObjectWithCompareFunction(
      {tag: tag}, _compareTrackingRectsByTag);
      
    if (idx != -1) {
      m_toolTipRects.removeObjectAtIndex(idx);
      if (m_toolTipRects.count() == 0) {
      	m_hasToolTips = false;
      }
    }
  }
  
  /**
   * Removes all tool tips associated with this view.
   * 
   * @see #removeToolTip
   */
  public function removeAllToolTips():Void {
    m_toolTipRects.removeAllObjects();
    m_toolTipTag = null;
    m_hasToolTips = false;
  }
  
  /**
   * Returns the text for this view's tool tip. If this view doesn't have a 
   * tool tip, this method returns <code>null</code>.
   * 
   * @see #
   */
  public function toolTip():String {
  	if (null == m_toolTipTag) {
  		return null;
  	}
  	
    var idx:Number = m_toolTipRects.indexOfObjectWithCompareFunction(
      {tag: m_toolTipTag}, _compareTrackingRectsByTag);
      
    if (idx == -1) {
      return null;
    }
    
    return m_toolTipRects.objectAtIndex(idx).userData.__tipTextProvider;
  }
  
  /**
   * Sets the text for this view's tool tip. If <code>string</code> is 
   * <code>null</code>, then no tip will be shown for this view.
   */
  public function setToolTip(string:String):Void {
    if (m_toolTipTag != null) {
      removeToolTip(m_toolTipTag);
      m_toolTipTag = null;
    }

    if (string == null || string == "") {
      return;
    }
    
    //
    // Hide the tooltip if it's currently on this view.
    //
    if (m_toolTipTag != null) {
      if (ASToolTip.getInstance().currentView() == this) {
        ASToolTip.getInstance().hideToolTip();
      }
    }
    
    var frm:NSRect = frame();
    m_toolTipTag = addToolTipRectOwnerUserData(
    	new NSRect(0, 0, frm.size.width, frm.size.height), string, null);
  }
  
  private var m_lastEventNum:Number;
  
  /**
   * Resets the tooltip after a frame change.
   */
  public function resetToolTips():Void {
  	//
  	// This is to prevent the tooltip refresh from happening too often.
  	//
  	if (NSApplication.sharedApplication().currentEvent().eventNumber ==
  		m_lastEventNum) 
  	{
  		return; 
  	}
  	
  	setToolTip(toolTip());
  	
  	//
  	// Reset the subview's tooltips as well.
  	//
  	var len:Number = m_subviews.length;
  	for (var i:Number = 0; i < len; i++) {
  		NSView(m_subviews[i]).resetToolTips();
  	}
  	
  	m_lastEventNum = NSApplication.sharedApplication().currentEvent().eventNumber;
  }
  
  //****************************************************** 
  //*            Controlling Notifications
  //******************************************************
  
  public function setPostsFrameChangedNotifications(value:Boolean):Void {
    m_postsFrameChangedNotifications = value;
  }

  public function postsFrameChangedNotifications():Boolean {
    return m_postsFrameChangedNotifications;
  }

  public function setPostsBoundsChangedNotifications(value:Boolean):Void {
    m_postsBoundsChangedNotifications = value;
  }

  public function postsBoundsChangedNotifications():Boolean {
    return m_postsBoundsChangedNotifications;
  }
  
  //****************************************************** 
  //*               Resizing subviews
  //******************************************************
  
  public function resizeSubviewsWithOldSize(oldBoundsSize:NSSize):Void { 
    if (m_autoresizesSubviews) {
      var i:Number;
      for(i=0;i<m_subviews.length;i++) {
        m_subviews[i].resizeWithOldSuperviewSize(oldBoundsSize);
      }
    }
  }
  
  public function resizeWithOldSuperviewSize(oldBoundsSize:NSSize):Void {
    if (m_autoresizingMask == NSView.NotSizable) {
      return;
    }
    
    var options:Number = 0;
    var superViewFrameSize:NSSize = m_superview == null ? NSSize.ZeroSize 
      : m_superview.frame().size;
    var newFrame:NSRect = m_frame.clone();
    var changedOrigin:Boolean = false;
    var changedSize:Boolean = false;
    
    if (m_autoresizingMask & NSView.WidthSizable) {
      options++;
    }
    
    if (m_autoresizingMask & NSView.MinXMargin) {
      options++;
    }
    
    if (m_autoresizingMask & NSView.MaxXMargin) {
      options++;
    }
    
    if (options > 0) {
      var change:Number = superViewFrameSize.width - oldBoundsSize.width;
      var changePerOption:Number = change/options;

      if (m_autoresizingMask & NSView.WidthSizable) {
        newFrame.size.width += changePerOption;
        changedSize = true;
      }

      if (m_autoresizingMask & NSView.MinXMargin) {
        newFrame.origin.x += changePerOption;
        changedOrigin = true;
      }
    }

    options = 0;
    if (m_autoresizingMask & NSView.HeightSizable) {
      options++;
    }
    
    if (m_autoresizingMask & NSView.MinYMargin) {
      options++;
    }
    
    if (m_autoresizingMask & NSView.MaxYMargin) {
      options++;
    }
    
    if (options > 0) {
      var change:Number = superViewFrameSize.height - oldBoundsSize.height;
      var changePerOption:Number = change/options;
      if (m_autoresizingMask & NSView.HeightSizable) {
        newFrame.size.height += changePerOption;
        changedSize = true;
      }
      if (m_autoresizingMask & NSView.MinYMargin) {
        newFrame.origin.y += changePerOption;
        changedOrigin = true;
      }
    }

	if (changedOrigin) {
	  setFrameOrigin(newFrame.origin);
	}
	
	if (changedSize) {
      setFrameSize(newFrame.size);
      setNeedsDisplay(true); //! not sure if this should be here
	}
  }
  
  public function setAutoresizesSubviews(value:Boolean):Void {
    m_autoresizesSubviews = value;
  }
  
  public function autoresizesSubviews():Boolean {
    return m_autoresizesSubviews;
  }
  
  public function setAutoresizingMask(value:Number):Void {
    m_autoresizingMask = value;
  }
  
  public function autoresizingMask():Number {
    return m_autoresizingMask;
  }
  
  //****************************************************** 
  //*                   Focusing
  //******************************************************
  
  //! Is this type of lockfocus is needed in AS ?
  
  //****************************************************** 
  //*                 Displaying
  //******************************************************
  
  /**
   * Calls {@link #display()} if this view requires display, then calls
   * this method for all subviews.
   */
  public function displayIfNeeded():Void {
    if (m_hidden || m_mcBounds == null) {
      return;
    }
    if (m_needsDisplay) {
      drawRect(m_bounds);
      m_needsDisplay = false;
    }
    var i:Number;
    for(i=0;i<m_subviews.length;i++) {
      m_subviews[i].displayIfNeeded();
    }    
  }
  
  /**
   * If <code>value</code> is <code>true</code>, this view will be marked
   * as needing display, which will be triggered by the window at the next
   * opportunity.
   */
  public function setNeedsDisplay(value:Boolean):Void {
    m_needsDisplay = value;
    if (value) {
      m_window.setViewsNeedDisplay(true);
    }
  }
  
  /**
   * Returns <code>true</code> if this view needs display.
   */
  public function needsDisplay():Boolean {
    return m_needsDisplay;
  }
  
  /**
   * Displays the view.
   */
  public function display():Void {
    if (m_hidden || m_mcBounds == null) {
      return;
    }
    drawRect(m_bounds);
    m_needsDisplay = false;
    var i:Number;
    for(i=0;i<m_subviews.length;i++) {
      m_subviews[i].display();
    }    
  }
  
  /**
   * Returns <code>true</code> if the view is opaque, or <code>false</code>
   * otherwise.
   * 
   * The default implementation always returns <code>false</code>.
   */
  public function isOpaque():Boolean {
    return false;
  }
  
  //****************************************************** 
  //*                  Hiding views
  //******************************************************
  
  /**
   * Sets whether the receiver is hidden to <code>value</code>.
   */
  public function setHidden(value:Boolean):Void {
    m_hidden = value;
    updateFrameMovieClipPerspective();
    //! move the clip offscreen if hidden
  }
  
  /**
   * Returns <code>true</code> if the view is hidden.
   */
  public function isHidden():Boolean {
    return m_hidden;
  }
  
  /**
   * Returns <code>true</code> if this view is hidden, or an ancestor
   * (views above this one in the view hierarchy) is hidden.
   */
  public function isHiddenOrHasHiddenAncestor():Boolean {
    if (isHidden()) {
      return true;
    } else if (superview() == null) {
      return false;
    } else {
      return superview().isHiddenOrHasHiddenAncestor();
    }
  }
  
  //****************************************************** 
  //*                    Drawing
  //******************************************************
  
  /**
   * Overridden by subclasses to draw the view within <code>aRect</code>.
   */
  public function drawRect(rect:NSRect):Void {
  }
  
  public function visibleRect():NSRect {
    if (m_window == null) {
      return NSRect.ZeroRect;
    }
    if (m_superview == null) {
      return m_bounds;
    }
    return convertRectFromView(m_superview.visibleRect(), 
      m_superview).intersectionRect(m_bounds);
  }
  
  public function wantsDefaultClipping():Boolean {
    return true;
  }

  //! which other functions in the drawing group are needed?
  //  – canDraw
  //  – shouldDrawColor
  //  – getRectsBeingDrawn:count:
  //  – needsToDrawRect:
  
  // Managing live resize

  // – inLiveResize
  // – viewWillStartLiveResize
  // – viewDidEndLiveResize
  
  // Managing a graphics state

  // – allocateGState
  // – gState
  // – setUpGState
  // – renewGState
  // – releaseGState

  //****************************************************** 
  //*                 Event Handling
  //******************************************************
  
  /**
   * Returns <code>true</code> if this view should recieve a mouseDown
   * event for <code>event</code>. 
   * 
   * The default implementation always returns <code>false</code>. This method
   * should be overridden in subclasses.
   */
  public function acceptsFirstMouse(event:NSEvent):Boolean {
    return false;
  }

  /**
   * This method should be implemented in subclasses to perform key equivalents,
   * which are also known as shortcuts or hotkeys. If 
   * <code>event.charactersIgnoringModifiers</code> are the same as this view's
   * key equivalent, then the appropriate action should be performed and 
   * <code>true</code> should be returned.
   * 
   * The default implementation passes the event down the view hierarchy. If
   * any of the descendents return <code>true</code> then this method returns
   * <code>false</code>.
   */  
  public function performKeyEquivalent(event:NSEvent):Boolean {
    var i:Number;
    var result:Boolean = false;
    
    for(i=0;i<m_subviews.length;i++) {
      if (m_subviews[i].performKeyEquivalent(event)) {
        result = true;
      }
    }
    
    return !result; // returns false if any subviews do respond.
  }

  /**
   * If this view's mnemonic is the same as the characters specified in
   * <code>string</code>, then the appropriate actions should be taken and 
   * <code>true</code> should be returned.
   * 
   * The default implementation passes the string down the view hierarchy. If
   * any of the descendents return <code>true</code> then this method returns
   * <code>false</code>.
   */
  public function performMnemonic(string:String):Boolean {
    var i:Number;
    var result:Boolean = false;
    
    for(i=0;i<m_subviews.length;i++) {
      if (m_subviews[i].performMnemonic(string)) {
        result = true;
      }
    }
    
    return !result;
  }
  
  //****************************************************** 
  //*                Dragging Operations
  //******************************************************
 
  /**
   * Begins an image dragging operation for this view.
   * 
   * <code>image</code> is the image to be dragged. <code>imageLoc</code>
   * specifies the location of the image's lower right hand corner in the 
   * coordinate system of the reciever. <code>offset</code> is size specifying
   * the mouse cursor's location relative to the mouse down location. 
   * <code>event</code> is the mouse event that triggered the drag. 
   * <code>pasteboard</code> holds the data to be copied to the drag target
   * when the operation is complete. <code>source</code> is the controller
   * of the drag. <code>slideBack</code> determines whether the image should
   * slide back to its original position if it is rejected by the destination
   * object.
   */
  public function dragImageAtOffsetEventPasteboardSourceSlideBack(
      image:NSImage, imageLoc:NSPoint, offset:NSSize, event:NSEvent, 
      pasteboard:NSPasteboard, source:NSDraggingSource, slideBack:Boolean)
      :Void {
  
  	m_window.dragImageAtOffsetEventPasteboardSourceSlideBack(
  		image, convertPointToView(imageLoc, m_window.rootView()),
  		offset, event, pasteboard, source, slideBack);
  } 

  /**
   * Registers <code>pboardTypes</code> as the types this view will accept
   * as the destination of a dragging session.
   * 
   * If any other types are currently registered for this view, they will be
   * overwritten.
   * 
   * @see #unregisterDraggedTypes
   */
  public function registerForDraggedTypes(pboardTypes:NSArray):Void {
  	if (m_window != null) {
      m_window.registerViewForDraggedTypes(this, pboardTypes);
  	} else {
  	  m_draggedTypes = pboardTypes;
  	}
  }
  
  /**
   * Returns true if this view is registered for the types contained in
   * <code>pboardTypes</code>.
   */
  public function registeredDraggedTypes():NSArray {
  	return m_window.registeredDraggedTypesForView(this);
  }
  
  /**
   * Unregisters this view as a destination for dragging operations.
   * 
   * @see #registerDraggedTypes
   */
  public function unregisterDraggedTypes():Void {
    m_window.unregisterDraggedTypesForView(this);
  }

  //****************************************************** 
  //*  Default implementations of NSDraggingDestination
  //******************************************************

  /**
   * Returns none by default.
   */
  function draggingEntered(sender:NSDraggingInfo):NSDragOperation {
    return NSDragOperation.NSDragOperationNone;
  }

  /**
   * Returns none by default.
   */
  function draggingUpdated(sender:NSDraggingInfo):NSDragOperation {
  	
    return NSDragOperation.NSDragOperationNone;
  }

  /**
   * Does nothing.
   */
  function draggingEnded(sender:NSDraggingInfo):Void {
    
  }

  /**
   * Does nothing.
   */
  function draggingExited(sender:NSDraggingInfo):Void {
   
  }

  /**
   * Returns false.
   */
  function wantsPeriodicDraggingUpdates():Boolean {
    return false;
  }

  /**
   * Return false.
   */
  function prepareForDragOperation(sender:NSDraggingInfo):Boolean {
    return false;
  }

  /**
   * Returns false.
   */
  function performDragOperation(sender:NSDraggingInfo):Boolean {
    return false;
  }

  /**
   * Does nothing.
   */
  function concludeDragOperation(sender:NSDraggingInfo):Void {
    
  }
	
  //****************************************************** 
  //*        Releasing the object from memory
  //******************************************************
	
  /**
   * Override this method to provide better deconstruction logic.
   */
  public function release():Void {
    // FIXME remove all observers
  }
}
