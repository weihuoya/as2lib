/* See LICENSE for copyright and terms of use */

import org.actionstep.NSApplication;
import org.actionstep.NSCursor;
import org.actionstep.NSDictionary;
import org.actionstep.NSEvent;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSPoint;
import org.actionstep.NSSize;
import org.actionstep.NSView;

/**
 * Monitors keyboard, mouse and stage events, and handles dispatching them
 * to the NSApplication instance.
 *
 * @author Rich Kilmer
 * @author Scott Hyndman
 */
class org.actionstep.events.ASEventMonitor {

  private static var g_instance:ASEventMonitor;

  private var m_app:NSApplication;
  private var m_mouseTrackingClip:MovieClip;
  private var m_eventCounter:Number;
  private var m_filter:Object;
  private var m_index:Number;
  private var m_multiClickSpeed:Number;
  private var m_isMouseDown:Boolean;
  private var m_lastMouseDownTime:Number;
  private var m_lastMouseDownEvent:NSEvent;
  private var m_wasMiddleMouseDown:Boolean;
  private var m_keyTracker:Object;
  private var m_tabClip1:MovieClip;
  private var m_tabClip2:MovieClip;
  private var m_tabClip3:MovieClip;
  private var m_lastKeyDown:Number;
  private var m_timeOffset:Number;
  private var m_stageTracker:Object;
  private var m_stageSize:NSSize;
  private var m_lastTargetView:NSView;
  private var m_lastTarget:Object;
  private var m_eventLock:Boolean;

  /**
   * Returns the ASEventMonitor singleton.
   */
  public static function instance():ASEventMonitor {
    if (g_instance == null) {
      g_instance = new ASEventMonitor();
    }
    return g_instance;
  }

  /**
   * Creates a new instance of ASEventMonitor. This is called by
   * <code>ASEventMonitor#instance</code> to create the singleton.
   */
  private function ASEventMonitor() {
    m_app = NSApplication.sharedApplication();
    m_eventLock = false;
    m_multiClickSpeed = 500; // OS X default
    m_mouseTrackingClip = null;
    m_eventCounter = 1;
    m_filter = null;
    m_wasMiddleMouseDown = false;
    m_isMouseDown = false;
    m_index = _root._target.length;
    if (_root._actionStep_target != undefined) {
	   m_index = _root._actionStep_target.length;
	 }
    if (m_index == 1) m_index = 0;
    m_lastMouseDownTime = 0;
    m_timeOffset = (new Date()).getTime() - getTimer();
    
    NSEvent.initializeEvents();
  }

  //******************************************************
  //*                  Properties
  //******************************************************

  public function setRootPathLength(number:Number) {
    m_index = number;
  }

  /**
   * Returns the clip used to track mouse movement.
   */
  public function mouseTrackingClip():MovieClip {
    return m_mouseTrackingClip;
  }

  /**
   * Returns the clip upon which objects currently being dragged are drawn.
   *
   * You shouldn't use this method to access the cursor clip. Use
   * NSApplication.draggingClip instead.
   */
  public function draggingClip():MovieClip {
    return m_mouseTrackingClip.draggingClip;
  }

  /**
   * Returns the clip upon which cursors are drawn.
   *
   * You shouldn't use this method to access the cursor clip. Use
   * NSApplication.cursorClip instead.
   */
  public function cursorClip():MovieClip {
    return m_mouseTrackingClip.cursorClip;
  }

  /**
   * Returns the last view the mouse was over.
   */
  public function lastTargetView():NSView {
    return m_lastTargetView;
  }

  public function setMouseEventFilter(filter:Object) {
    m_filter = filter;
  }
  
  public function setEventLock(value:Boolean) {
    trace("Event lock set to "+value);
    m_eventLock = value;
  }
  
  public function eventLock():Boolean {
    return m_eventLock;
  }

  /**
   * Returns the maximum amount of time between clicks before they are
   * recognized as independent clicks.
   */
  public function multiClickSpeed():Number {
    return m_multiClickSpeed;
  }

  /**
   * Sets the maximum amount of time between clicks before they are
   * recognized as independent clicks to <code>value</code>.
   */
  public function setMultiClickSpeed(value:Number) {
    m_multiClickSpeed = value;
  }

  //******************************************************
  //               Event tracking setup
  //******************************************************

  /**
   * Begins tracking mouse events.
   */
  public function trackMouseEvents():Void {
    if (m_mouseTrackingClip != null) { //Already tracking
      return;
    }
    var self:ASEventMonitor = this;
    var mouseTrackingClip:MovieClip = _root.createEmptyMovieClip(
      "mouseTrackingClip", 10000);
    m_mouseTrackingClip = mouseTrackingClip;
    m_mouseTrackingClip._x = _root._xmouse;
    m_mouseTrackingClip._y = _root._ymouse;
    m_mouseTrackingClip.startDrag(false);
    m_mouseTrackingClip.onMouseDown = function() {
      self.mouseDown( mouseTrackingClip._droptarget );
    };
    m_mouseTrackingClip.onMouseUp = function() {
      self.mouseUp( mouseTrackingClip._droptarget );
    };
    m_mouseTrackingClip.onMouseMove = function() {
      self.mouseMove( mouseTrackingClip._droptarget );
    };
    m_mouseTrackingClip.onEnterFrame = function() {
      self.checkMiddleMouse(mouseTrackingClip._droptarget);	
    };
    
    //
    // For scroll wheel
    //
    var scrollListener:Object = {};
    scrollListener.onMouseWheel = function(delta:Number) {
      self.scrollWheel(mouseTrackingClip._droptarget, delta);
    };
    Mouse.addListener(scrollListener);

    //
    // Create the cursor clip. This is set at a high depth because lower depths
    // will be used for items that are being dragged.
    //
    mouseTrackingClip.createEmptyMovieClip("cursorClip", 3);

    //
    // Create the dragging cilp.
    //
  	var dc:MovieClip = mouseTrackingClip.createEmptyMovieClip("draggingClip",
  	  2);
  	dc._alpha = 60;
  }

  /**
   * Begins tracking keyboard events.
   */
  public function trackKeyboardEvents():Void {
    if (m_keyTracker != null) { //Already tracking
      return;
    }

    //
    // Create two _root level movie clips that increment tab indices so that
    // the app never gives up focus.
    //
    /*
    m_tabClip1 = _root.createEmptyMovieClip("__tabClip1", 10002);
    m_tabClip2 = _root.createEmptyMovieClip("__tabClip2", 10003);
    m_tabClip3 = _root.createEmptyMovieClip("__tabClip3", 10004);
    m_tabClip1.tabEnabled = m_tabClip2.tabEnabled
    	= m_tabClip3.tabEnabled = true;
    m_tabClip1.tabIndex = 0;
    m_tabClip2.tabIndex = 1;
    m_tabClip3.tabIndex = 3;
    Selection.setFocus(m_tabClip1);
    */
    //
    // Create key observer
    //
    var self:ASEventMonitor = this;
    m_keyTracker = new Object();
    m_keyTracker.onKeyDown = function() {
      self.keyDown();
    };
    m_keyTracker.onKeyUp = function() {
      self.keyUp();
    };

    Key.addListener(m_keyTracker);
  }

  /**
   * Begins tracking stage resize events.
   */
  public function trackStageEvents():Void {
  	if (m_stageTracker != null) { // Already tracking
  	  return;
  	}

  	m_stageSize = new NSSize(Stage.width, Stage.height);

  	var self:ASEventMonitor = this;
  	m_stageTracker = {};
  	m_stageTracker.onResize = function() {
  	  self.stageResize();
  	};

    Stage.addListener(m_stageTracker);
  }

  //******************************************************
  //*                 Handling events
  //******************************************************

  /**
   * Handles a keydown event.
   */
  public function keyDown():Void {
    if (m_eventLock) return;
//    if (Key.isDown(Key.TAB)) {
//      if (!Key.isDown(Key.SHIFT)) {
//        if (m_tabClip1.tabIndex < m_tabClip2.tabIndex) {
//          m_tabClip1.tabIndex += 2;
//          Selection.setFocus(m_tabClip2);
//        } else {
//          m_tabClip2.tabIndex += 2;
//          Selection.setFocus(m_tabClip1);
//        }
//      } else {
//        if (m_tabClip1.tabIndex > m_tabClip2.tabIndex) {
//          m_tabClip1.tabIndex -= 2;
//          Selection.setFocus(m_tabClip2);
//        } else {
//          m_tabClip2.tabIndex -= 2;
//          Selection.setFocus(m_tabClip1);
//        }
//      }
//    }

    var event:NSEvent = NSEvent.keyEventWithType(NSEvent.NSKeyDown,
      new NSPoint(_root._xmouse, _root._ymouse), buildModifierFlags(),
      m_timeOffset+getTimer(), null /* window */, null /*context*/,
      String.fromCharCode(Key.getAscii()), String.fromCharCode(Key.getAscii()),
      (m_lastKeyDown == Key.getCode()), Key.getCode());
    m_lastKeyDown = Key.getCode();
    m_app.sendEvent(event);
  }

  /**
   * Handles a keyup event.
   */
  public function keyUp():Void {
    if (m_eventLock) return;
    if (m_lastKeyDown == Key.getCode()) {
      m_lastKeyDown = 0;
    }
    var event:NSEvent = NSEvent.keyEventWithType(NSEvent.NSKeyUp,
      new NSPoint(_root._xmouse, _root._ymouse), buildModifierFlags(),
      m_timeOffset+getTimer(), null /* window */, null /*context*/,
      String.fromCharCode(Key.getAscii()), String.fromCharCode(Key.getAscii()),
      false, Key.getCode());

    m_app.sendEvent(event);
  }

  public function postPeriodicEvent():Void {
  	var targetPath:String = m_mouseTrackingClip._dropTarget;
  	var target:Object = eval(targetPath);
  	
	//
	// Climb tree if target no longer exists
	//
	if (target == undefined && targetPath != "") {
	  var parts:Array = targetPath.split("/");
	  target = eval(parts.slice(0, -2).join("/"));
	}
	
    var modifierFlags:Number = buildModifierFlags();
    var event:NSEvent = NSEvent.otherEventWithType(NSEvent.NSPeriodic,
      new NSPoint(_root._xmouse, _root._ymouse), modifierFlags,
      m_timeOffset+getTimer(), target.view,
      null /* context*/, 0 /*subType */, null /*data1 */, null /*data 2*/);
    m_app.sendEvent(event);
  }

  /**
   * Fired when the user rolls the mouse wheel.
   */
  public function scrollWheel(targetPath:String, delta:Number):Void {  	
    if (m_eventLock) return;
    if (m_index > 0) {
      targetPath = targetPath.slice(m_index);
    }
    
  	var target:Object = eval(targetPath);
  	
	//
	// Climb tree if target no longer exists
	//
	if (target == undefined && targetPath != "") {
	  var parts:Array = targetPath.split("/");
	  target = eval(parts.slice(0, -2).join("/"));
	}
	
    var modifierFlags:Number = buildModifierFlags();

    var event:NSEvent = NSEvent.mouseEventWithType(NSEvent.NSScrollWheel,
      new NSPoint(_root._xmouse, _root._ymouse), m_timeOffset+getTimer(),
      modifierFlags, target.view, null, m_eventCounter++, 0, 0);
    event.deltaY = delta;
    m_app.sendEvent(event);
  }

  /**
   * This is fired when the left mouse button is pressed.
   * <code>targetPath</code> is the movieclip or textfield the mouse is
   * currently over.
   */
  public function mouseDown(targetPath:String):Void {
    if (m_eventLock) return;
    if (m_index > 0) {
      targetPath = targetPath.slice(m_index);
    }

    m_isMouseDown = true;

    var x:Number = _root._xmouse;
    var y:Number = _root._ymouse;

    var target:Object = eval(targetPath);
  	//
  	// Climb tree if target no longer exists
  	//
  	if (target == undefined && targetPath != "") {
  	  var parts:Array = targetPath.split("/");
  	  target = eval(parts.slice(0, -2).join("/"));
  	}

    if (target.view == m_lastMouseDownEvent.view &&
        (getTimer() - m_lastMouseDownTime) < m_multiClickSpeed &&
        (Math.abs(x -  m_lastMouseDownEvent.mouseLocation.x)) < 10 &&
        (Math.abs(y -  m_lastMouseDownEvent.mouseLocation.y)) < 10) {
      m_lastMouseDownEvent.clickCount++;
      m_lastMouseDownTime = getTimer();
      m_app.sendEvent(m_lastMouseDownEvent);
      return;
    }

    var modifierFlags:Number = buildModifierFlags();
	
    m_lastMouseDownEvent = NSEvent.mouseEventWithType(
      NSEvent.NSLeftMouseDown, new NSPoint(x, y), modifierFlags,
      m_timeOffset+getTimer(), target.view, null /* context */,
      m_eventCounter++, 1 /*click count*/, 0).copyWithZone();
    m_lastMouseDownEvent.flashObject = target;
    m_lastMouseDownTime = getTimer();
    m_app.sendEvent(m_lastMouseDownEvent);
  }

  /**
   * This is fired when the left mouse button is released.
   * <code>targetPath</code> is the movieclip or textfield the mouse is
   * currently over.
   */
  public function mouseUp(targetPath:String):Void {
    if (m_eventLock) return;
    if (m_index > 0) {
      targetPath = targetPath.slice(m_index);
    }
    var modifierFlags:Number = buildModifierFlags();

    m_isMouseDown = false;
    var target:Object = eval(targetPath);
	
  	//
  	// Climb tree if target no longer exists
  	//
  	if (target == undefined && targetPath != "") {
  	  var parts:Array = targetPath.split("/");
  	  target = eval(parts.slice(0, -2).join("/"));
  	}
	
    var event:NSEvent = NSEvent.mouseEventWithType(NSEvent.NSLeftMouseUp,
      new NSPoint(_root._xmouse, _root._ymouse), modifierFlags,
      m_timeOffset+getTimer(), target.view,  null /* context */,
      m_eventCounter++, m_lastMouseDownEvent.clickCount /*click count*/, 0);
    event.flashObject = target;
    m_app.sendEvent(event);
  }

  /**
   * This is fired when the mouse moves. <code>targetPath</code> is the
   * movieclip or textfield the mouse is currently over.
   */
  public function mouseMove(targetPath:String):Void {
    if (m_eventLock) return;
    if (m_index > 0) {
      targetPath = targetPath.slice(m_index);
    }
	
    //
    // Build and send event.
    //
    var target:Object = eval(targetPath);
    var event:NSEvent;

	//
	// Climb tree if target no longer exists
	//
	if (target == undefined && targetPath != "") {
	  var parts:Array = targetPath.split("/");
	  target = eval(parts.slice(0, -2).join("/"));
	}
	
    event = NSEvent.mouseEventWithType(
      m_isMouseDown ? NSEvent.NSLeftMouseDragged : NSEvent.NSMouseMoved,
      new NSPoint(_root._xmouse, _root._ymouse),
      buildModifierFlags(), m_timeOffset+getTimer(), target.view,
      null /* context */, m_eventCounter++, 0/*clickCount:Number*/,
      0/*pressure:Number*/);
    event.flashObject = target;
    m_app.sendEvent(event);

    //
    // If the mouse is over an editable textfield, we should hide the mouse
    // cursor.
    //
	var tf:TextField = TextField(target);
    if (null != tf && tf.selectable) {
      NSCursor.hide();
    }
    else if (NSCursor.isHidden()) {
      NSCursor.unhide();
    }

    //
    // Set last target view.
    //
    m_lastTargetView = NSView(target.view);
    m_lastTarget = target;
  }

  /**
   * Fired when the root recieves an onEnterFrame event.
   */
  public function checkMiddleMouse(targetPath:String):Void {
    var isMiddleMouseDown:Boolean = Key.isDown(4);
    if (isMiddleMouseDown == m_wasMiddleMouseDown) {
      return;
    }
    
    m_wasMiddleMouseDown = isMiddleMouseDown;
    
    //
    // Build and send event.
    //
    var eventType:Number = isMiddleMouseDown ? NSEvent.NSOtherMouseDown :
      NSEvent.NSOtherMouseUp;
    var target:Object = eval(targetPath);

	//
	// Climb tree if target no longer exists
	//
	if (target == undefined && targetPath != "") {
	  var parts:Array = targetPath.split("/");
	  target = eval(parts.slice(0, -2).join("/"));
	}
    
    var event:NSEvent = NSEvent.mouseEventWithType(eventType,
      new NSPoint(_root._xmouse, _root._ymouse), buildModifierFlags(),
      m_timeOffset+getTimer(), target.view,  null /* context */,
      m_eventCounter++, m_lastMouseDownEvent.clickCount /*click count*/, 0);
    event.flashObject = target;
    m_app.sendEvent(event);
  }

  /**
   * Fired when the stage resizes.
   */
  public function stageResize():Void {
    var newSize:NSSize = new NSSize(Stage.width, Stage.height);

    //
    // Post notification
    //
    NSNotificationCenter.defaultCenter().postNotificationWithNameObjectUserInfo(
      NSApplication.ASStageDidResizeNotification,
      m_app,
      NSDictionary.dictionaryWithObjectsAndKeys(
        m_stageSize, "ASOldSize",
        newSize.clone(), "ASNewSize"));

    m_stageSize = newSize;
  }

  //******************************************************
  //*                  Helper methods
  //******************************************************

  /**
   * Builds the modifier flags for an event object based on keys pressed
   * at the time.
   */
  private function buildModifierFlags():Number {
    var flags:Number = 0;

    if (Key.isDown(Key.SHIFT)) {
      flags |= NSEvent.NSShiftKeyMask;
    }
    if (Key.isDown(Key.CONTROL)) {
      flags |= NSEvent.NSControlKeyMask;
    }
    if (Key.isDown(Key.ALT)) {
      flags |= NSEvent.NSAlternateKeyMask;
    }
    if (Key.isDown(112)) {
      flags |= NSEvent.NSHelpKeyMask;
    }
    if (Key.isDown(96) || // 0
      Key.isDown(97) ||   // 1
      Key.isDown(98) ||   // 2
      Key.isDown(99) ||   // 3
      Key.isDown(100) ||  // 4
      Key.isDown(101) ||  // 5
      Key.isDown(102) ||  // 6
      Key.isDown(103) ||  // 7
      Key.isDown(104) ||  // 8
      Key.isDown(105) ||  // 9
      Key.isDown(106) ||  // Multiply
      Key.isDown(107) ||  // Add
      Key.isDown(109) ||  // Subtract
      Key.isDown(110) ||  // Decimal
      Key.isDown(111))// ||  // Divide
      //Key.isDown(13))     // Enter  NOTE: LEAVE THIS OUT FOR NOW...CATCHES A CARRIAGE RETURN
    {
      flags |= NSEvent.NSNumericPadKeyMask;
    }

    //! FIXME I don't know what the NSAlphaShiftKeyMask or NSFunctionKeyMask
    return flags;
  }
}