import org.as2lib.exceptions.*
import org.as2lib.basic.EventableElement

/**
 * Basic Class for Classes that are(should be) Visible.
 * This is to work with an Class like to work with an MovieClip.
 * If you want to use this class you should extend it.
 *
 * @author	Martin Heidegger
 * @see		org.as2lib.basic.EventableElement
 *
 * @event onData			Event when Data is loaded
 * @event onDragOut			Event when the Mouse drags Out the MovieClip
 * @event onDragOver		Event when the Mouse drags Over the MovieClip
 * @event onEnterFrame		Event when Entering the next frame
 * @event onKeyDown			Event when any Key gets up
 * @event onKeyUp			Event when any Key gets down
 * @event onKillFocus		Event when the MovieClip looses the Focus
 * @event onLoad			Event when the Complete Movieclip is loaded
 * @event onMouseDown		Event when the mouse presses down anywhere at the Stage
 * @event onMouseMove		Event when the Mouse moves at the Stage
 * @event onMouseUp			Event when the Move releases anywhere at the Stage
 * @event onPress			Event when the Mouse presses down at the MovieClip
 * @event onRelease			Event when the Mouse releases over the MovieClip
 * @event onReleaseOutside	Event when the Mouse releases outside the MovieClip
 * @event onRollOut			Event when the Mouse rolls out from the MovieClip
 * @event onRollOver		Event when the Mouse rolls over the MovieClip
 * @event onSetFocus		Event when the MovieClip gets the Focus
 * @event onUnload			Event when the MovieClip is unloaded
 */
 
class org.as2lib.basic.VisibleElement extends EventableElement{
	
	// Internal Var for the MovieClip at the Workspace
	private var mc:MovieClip;
	// Parent MovieClip
	private var parent:MovieClip;
	// Name of the MovieClip
	private var name:String;
	// Depth from the MovieClip
	private var depth:Number;
	
	/**
	 * @param parent	MovieClip where the Class should be
	 * @param name		Name of the Class
	 * @param depth		Depth of the Class
	 */
	function VisibleElement(parent:MovieClip, name:String, depth:Number) {
		this.parent = parent;
		this.depth = depth;
		this.name = name;
		
		// Creation of the MovieClip
		this.mc = parent.createEmptyMovieClip(name, depth);
		this.mc.owner = this;
		
		this.catchEvents();
	}
	
	/**
	 * X Coordinate of the MovieClip
	 */
	public function set _x(to:Number):Void {
		check();
		this.mc._x = to;
	}
	public function get _x():Number {
		check();
		return(this.mc._x);
	}
	
	/**
	 * Y Coordinate of the MovieClip
	 */
	public function set _y(to:Number):Void {
		check();
		this.mc._y = to;
	}
	public function get _y():Number {
		check();
		return(this.mc._y);
	}
	
	/**
	 * Y Position from the Mouse inside the MovieClip
	 */
	public function get _xmouse():Number {
		check();
		return(this.mc._xmouse);
	}
	
	/**
	 * X Position from the Mouse inside the MovieClip
	 */
	public function get _ymouse():Number {
		check();
		return(this.mc._ymouse);
	}
	
	
	/**
	 * X-ScaleFactor in % from the MovieClip
	 */
	public function set _xscale(to:Number) {
		check();
		this.mc._xscale = to;
	}
	public function get _xscale():Number {
		check();
		return(this.mc._xscale);
	}
	
	/**
	 * Y-ScaleFactor in % from the MovieClip
	 */
	public function set _yscale(to:Number) {
		check();
		this.mc._yscale = to;
	}
	public function get _yscale():Number {
		check();
		return(this.mc._yscale);
	}
	
	/**
	 * Total Width from the MovieClip (based by _parent)
	 */
	public function get _width():Number {
		check();
		return(this.mc._width);
	}
		
	/**
	 * Alpha Value from the MovieClip
	 */
	public function set _alpha(to:Number):Void {
		check();
		this.mc._alpha = to;
	}
	public function get _alpha():Number {
		check();
		return(this.mc._alpha);
	}
		
	/**
	 * Specifies the _root from the SWF that is loaded in this movieclip (default: undefined)
	 */
	public function set _lockroot(to:Boolean):Void {
		check();
		this.mc._lockroot = to;
	}
	public function get _lockroot():Boolean {
		check();
		return(this.mc._lockroot);
	}
	
	/**
	 * This Visibility of this MovieClip
	 */
	public function set _visible(to:Boolean):Void {
		check();
		this.mc._visible = to;
	}
	public function get _visible():Boolean {
		check();
		return(this.mc._visible);
	}
	
	/**
	 * Target path where this mc can be accessed from
	 */
	public function get _target ():String {
		check();
		return(this.mc._target);
	}
	
	/**
	 * Rotation of the MovieClip in Degree
	 */
	public function set _rotation (to:Number):Void {
		check();
		this.mc._rotation = to;
	}
	public function get _rotation ():Number {
		check();
		return(this.mc._rotation);
	}
	
	/**
	 * Name of the MovieClip
	 */
	public function get _name ():String {
		check();
		return(this.mc._name);
	}
	
	/**
	 * All Loaded Frames
	 */
	public function get _framesloaded ():Number {
		check();
		return(this.mc._framesloaded);
	}
	
	/**
	 * The Currentframe
	 */
	public function get _currentframe ():Number {
		check();
		return(this.mc._currentframe);
	}
	
	/**
	 * All Available Frames
	 */
	public function get _totalframes ():Number {
		check();
		return(this.mc._totalframes);
	}
	
	/**
	 * Location from the loaded SWF
	 */
	public function get _url ():String {
		check();
		return(this.mc._url);
	}
	
	/**
	 * Parent MovieClip
	 */
	public function get _parent ():MovieClip {
		return(this.mc._parent);
	}
	
	/**
	 * Quality Definition for this MovieClip
	 */
	public function set _quality (to:String):Void {
		check();
		this.mc._quality = to;
	}
	public function get _quality ():String {
		check();
		return(this.mc._quality);
	}
	
	/**
	 * The MovieClip where this MovieClip was dropped (Slash Separated)
	 */
	public function get _droptarget():String {
		check();
		return(this.mc._droptarget);
	}
	
	/**
	 * Shows the Focusrectangle at Focus
	 */
	public function set _focusrect(to:Boolean) {
		check();
		this.mc._focusrect = to;
	}
	public function get _focusrect():Boolean {
		check();
		return(this.mc._focusrect);
	}
	
	/**
	 * Number of secondes before the SWD File Starts to stream
	 */
	public function set _soundbuftime (to:Number) {
		check();
		this.mc._soundbuftime = to;
	}
	public function get _soundbuftime ():Number {
		check();
		return(this.mc._soundbuftime);
	}
	
	/**
	 * Sets the hitArea with which this Movieclip may not collide
	 */
	public function set hitArea(to:MovieClip) {
		this.mc.hitArea = to;
	}
	
	public function get hitArea():MovieClip {
		return(this.mc.hitArea);
	}
	
	
	/**
	 * Attaching an MovieClip to this MovieClip
	 *
	 * @param name			Identifiert of the MovieClip to Attach
	 * @param newName		Name of the Instance
	 * @param depth			Depth of the Instance
	 * @param initObject	Object that should be used at init
	 */
	public function attachMovie(name:String, newName:String, depth:Number, initObject:Object):MovieClip {
		return(this.mc.attachMovie(name, newName, depth, initObject));
	}
	
	/**
	 * Creating a new, empty MovieClip inside this MovieClip
	 * 
	 * @param instanceName	Name of the Instance
	 * @param depth			Depth of the Instance
	 */
	public function createEmptyMovieClip(instanceName:String, depth:Number):MovieClip {
		return(this.mc.createEmptyMovieClip(instanceName, depth));
	}
	
	/**
	 * Creats a new, empty Textfield inside this MovieClip
	 *
	 * @param instanceName	Name of the Textfield
	 * @param depth			Depth of the Textfield
	 * @param x				X Position of the TextField
	 * @param y				Y Position of the TextField
	 * @param width			Width of the Textfield
	 * @param height		Height of the Textfield
	 */
	public function createTextField(instanceName:String, depth:Number, x:Number, y:Number, width:Number, height:Number):Void {
		//todo: correct return
		this.mc.createTextField(instanceName, depth, x, y, width, height);
	}
	
	/**
	 * Duplicates the MovieClip inside the Parent MovieClip to a MovieClip.
	 *
	 * @param newName		Name of the Duplicate
	 * @param depth			Depth of the Duplicate
	 * @param [initObject]	Properties for the new MovieClip
	 *
	 * @return				Reference to the new MovieClip
	 */
	 
	//todo: check if this implementation works by practice
	public function duplicateMovieClip(newName:String, depth:Number, initObject:Object):MovieClip {
		return(this.mc.duplicateMovieClip(newName, depth, initObject));
	}
	
	/**
	 * Function to get The true Bounds of this Object based on a targetCoordinateSpace
	 *
	 * @param targetCoordinateSpace		MovieClip 
	 *
	 * @return	Object with values xMin, yMin / xMax, yMax
	 */
	 
	//todo: Create a new Class that should be thrown back (an Object is a very bad way)
	public function getBounds(targetCoordinateSpace:MovieClip):Object {
		return(this.mc.getBounds(targetCoordinateSpace));
	}
	
	/**
	 * Gets the Bytes of the MovieClip loaded by loadMovie
	 *
	 * @see #loadMovie
	 * @see #loadMovieNum
	 * @see #getBytesLoaded
	 * 
	 * @return	Number of Bytes Loaded
	 */
	public function getBytesLoaded():Number {
		return(this.mc.getBytesLoaded());
	}
	
	/**
	 * Total Bytes of this MovieClip
	 *
	 * @see #loadMovie
	 * @see #loadMovieNum
	 * @see #unloadMovie
	 * 
	 * @return	Number of Bytes Loaded
	 */
	public function getBytesTotal():Number {
		return(this.mc.getBytesTotal());
	}
	
	/**
	 * Gets the Depth from this Object inside the Parent
	 *
	 * @see #getInstanceAtDepth
	 * @see #getNextHighestDepth
	 * @see #swapDepths
	 *
	 * @return	Number of Depth where this MovieClip is
	 */
	public function getDepth():Number {
		return(this.mc.getDepth());
	}
	
	/**
	 * Gets the instance from the MovieClip inside this MovieClip found at <depth>
	 *
	 * @see #getDepth
	 * @see #getNextHighestDepth
	 * @see #swapDepths
	 *
	 * @param depth		Depth where to get the MovieClip
	 * @return			Returns the MovieClip at this depth
	 */
	public function getInstanceAtDepth(depth:Number):MovieClip {
		return(this.mc.getInstanceAtDepth(depth));
	}
	
	
	/**
	 * Returns the next highest Depth starting with this Object
	 *
	 * @see #getDepth
	 * @see #getInstanceAtDepth
	 * @see #swapDepths
	 *
	 * @return	the nextHighest Depth
	 */
	public function getNextHighestDepth():Number {
		return(this.mc.getNextHighestDepth());
	}
	
	/**
	 * Getter for the SWFVersion of the Loaded MovieClip
	 *
	 * @see #loadMovie
	 * @see #loadMovieNum
	 * @see #unloadMovie
	 *
	 * @return	Natural Number of the String
	 */
	public function getSWFVersion():Number {
		return(this.mc.getSWFVersion);
	}
	
	/**
	 * Getter for a TextSnapshot of the actually Selected Text inside this MovieClip
	 * 
	 * @see TextSnapshot*Macromedia
	 * 
	 * @return	A Snapshot from the actually selected Text (even if its only selectable)
	 */	
	public function getTextSnapshot():TextSnapshot {
		return(this.mc.getTextSnapshot());
	}
	
	/**
	 * Basic Method to open an Url in a Browser window
	 *
	 * @param url		URL from the Location to load
	 * @param [window]	Window where the Url should be loaded (Usually _parent, _top, _self, _blank or the name of a frame or a window, allready opened with this name)
	 * @param [method]	Method how "Vars" should be used, "POST" or "GET" available
	 */
	public function getURL(url:String, window:String, method:String):Void {
		this.mc.getURL(url, window, method);
	}
	
	/**
	 * Converts Coorinates based on the top MovieClip viewed by this MovieClip
	 * 
	 * @see	#localToGlobal
	 * 
	 * @param point		Object with values x & y based by this Object
	 *
	 * @return	Object with value x & y based by the Root Object
	 */
	 
	//todo: Check if there's a better possiblity than "Object" as Type!
	//todo: If it stayes thisway you should use Exceptions
	public function globalToLocal(point:Object):Object {
		return(this.mc.globalToLocal(point));
	}
	
	/**
	 * Playes the Content MovieClip to a frame and play on
	 *
	 * @param frame		Frame where the MovieClip should be played to
	 */
	public function gotoAndPlay(frame:Number):Void {
		this.mc.gotoAndPlay(frame);
	}
	
	/**
	 * Changes the Content MovieClip to a frame and stops playing
	 *
	 * @param frame		Frame where the MovieClip should stop
	 */
	public function gotoAndStop(frame:Number):Void {
		this.mc.gotoAndStop(frame);
	}
	
	/**
	 * Tests if a MovieClip or a Coordinate hits this Object
	 *
	 * { @param x{MovieClip}
	 *     @param x		MovieClip to test if it hits this Object
	 * }
	 * { @param x{Number}
	 *     @param x				X Coordinate of the Point to Check
	 *     @param y				Y Coordinate of the Point to Check
	 *     @param shapeFlag		Flag if only the Bounds (fast)/false or the Real Outline (slow)/true 
	 * }
	 * 
	 * @return	true if the MovieClip/Point hits the Object
	 */
	public function hitTest(x,y:Number, shapeFlag:Boolean):Boolean {
		// Special Implementation for "MovieClip" as Argument 1
		if(typeof x == "movieclip") {
			return(this.mc.hitTest(x));
		} else if(typeof x == "number"){
			return(this.mc.hitTest(x, y, shapeFlag));
		} else {
			throw new WrongArgumentException("There must be at least a MovieClip or a Number as first element", "de.flashforum.basic.VisibleElement", "hitTest", arguments);
		}
	}
	
	/**
	 * Loads a .swf Movie from an Location into this Objects MovieClip.
	 *
	 * @see #getBytesLoaded
	 * @see #getBytesTotal
	 * @see #loadMovieNum
	 * @see #unloadMovie
	 * @see	MovieClipLoader*Macromedia
	 * 
	 * @param url		Location from the MovieClip that should be loaded
	 * @param method	Method to Submit Variables to the URL (can be "POST" or "GET")
	 */
	public function loadMovie(url:String, method:String):Void {
		this.mc.loadMovie.apply(this.mc, arguments);
	}
	
	/**
	 * Loads a .swf int A specific level
	 *
	 * @see #getBytesLoaded
	 * @see #getBytesTotal
	 * @see #loadMovie
	 * 
	 * @param url		Location of the .swf
	 * @param depth		Depth of the loaded MovieClip inside this MovieClip
	 * @param [vars]	Unlimited Vars used by initalizing the new MovieClip
	 */
	public function loadMovieNum(url:String, depth:Number, vars):Void {
		this.mc.loadMovieNum.apply(this.mc, arguments);
	}
	
	/**
	 * Converts Coorinates based on this MovieClip viewed by the Top MovieClip
	 * 
	 * @see	#globalToLocal
	 * 
	 * @param point		Object with values x & y based by this Object
	 *
	 * @return	Object with value x & y based by the Root Object
	 */
	 
	//todo: Check if there's a better possiblity than "Object" as Type!
	//todo: If it stayes thisway you should use Exceptions
	public function localToGlobal(point:Object):Object {
		return(this.mc.localToGlobal(point));
	}
	
	/**
	 * Jumps to the Next Frame inside this MovieClip
	 * 
	 * @see #gotoAndPlay
	 * @see #gotoAndStop
	 * @see #_currentframe
	 * @see #_totalframes
	 */
	public function nextFrame():Void {
		this.mc.nextFrame();
	}
	
	/**
	 * Starts playing the MovieClip
	 * 
	 * @see #stop
	 * @see #gotoAndPlay
	 */
	public function play():Void {
		this.mc.play();
	}
	
	/**
	 * Jumps to the Previous Frame inside this MovieClip
	 * 
	 * @see #gotoAndPlay
	 * @see #gotoAndStop
	 * @see #_currentframe
	 * @see #_totalframes
	 */
	public function prevFrame():Void {
		this.mc.prevFrame();
	}
	
	/**
	 * Removes the MovieClip
	 */
	 
	//todo: Check if this Function is practially useable
	public function removeMovieClip():Void {
		this.mc.removeMovieClip();
	}
	
	/**
	 * Sets a Mask MovieClip, outside the MovieClip, this MovieClip will never have a visible element.
	 *
	 * @param maskMovieClip		MovieClip that should be used as Mask
	 */
	public function setMask(maskMovieClip:MovieClip):Void {
		this.mc.setMask(maskMovieClip);
	}
	
	/**
	 * Starts dragging the Object with the Mouse a base Target
	 *
	 * @see #stopDrag
	 * 
	 * @param lockCenter	Sets if Object locks at the Mousecenter or not
	 * @param l				Relative Coordinate (left) that never may be exceeded
	 * @param t				Relative Coordinate (top) that never may be exceeded
	 * @param r				Relative Coordinate (right) that never may be exceeded
	 * @param b				Relative Coordinate (bottom) that never may be exceeded
	 */
	public function startDrag(lockCenter:Boolean, l:Number, t:Number, r:Number, b:Number):Void {
		this.mc.startDrag(lockCenter, l, t, r, b);
	}
	
	/**
	 * Stops the Playing of the MovieClip
	 * 
	 * @see play
	 */
	public function stop():Void {
		this.mc.stop();
	}
	
	/**
	 * Stops the Dragging of the Object.
	 * 
	 * @see #startDrag
	 */
	public function stopDrag() {
		this.mc.stopDrag();
	}
	
	/**
	 * Swaps the Depth from this MovieClip with the Depth form the Target
	 * 
	 * @see #getDepth
	 * @see #getNextHighestDepth
	 * @see #getInstanceAtDepth
	 * 
	 * { @param target{Number}
	 *    @param target		Targetdepth where to swich
	 * }
	 * { @param target{MovieClip}
	 *    @param target		Target as MovieClip to switch
	 * }
	 */
	public function swapDepths(target) {
		this.mc.swapDepths(target);
	}
	
	/**
	 * Unloads the Loaded MovieClip inside this MovieClip
	 * 
	 * @see #loadMovie
	 * @see #loadMovieNum
	 */
	public function unloadMovie() {
		this.mc.unloadMovie();
	}
	
	/**
	 * Sets the Flag that the actually drawing of the Line should be filled with an color
	 *
	 * @see #beginGradientFill
	 * @see #clear
	 * 
	 * @param rgb		Value from the Color that should fill (0x000000 for example)
	 * @param alpha		Alphavalue from the Color
	 */
	public function beginFill(rgb:Number, alpha:Number):Void {
		this.mc.beginFill(rgb, alpha);
	}
	
	/**
	 * Begins Gradient Filling at the actual Array
	 * 
	 * @see #beginGradientFill
	 * @see #clear
	 * 
	 * @param fillType	String how it should be filled with ("linear", "radial")
	 * @param colors	All Colors of the Gradient
	 * @param alphas	Alpha Values of all Colors (0-100)
	 * @param ratios	Ratios of all Colors (0-255)
	 * @param matrix	3x3 TransformationMatrix where a Dimension can be defined
	 */
	public function beginGradientFill(fillType:String, colors:Array, alphas:Array, ratios:Array, matrix:Object):Void {
		this.mc.beginGradientFill(fillType, colors, alphas, ratios, matrix);
	}
	
	/** 
	 * Clears the complete Filling and all Lines
	 */
	public function clear():Void {
		this.mc.clear();
	}
	
	/**
	 * Draws a curve point
	 * 
	 * @param controlX	X-Center of the CurvePoint
	 * @param controlY	Y-Center of the CurvePoint
	 * @param anchorX	Anchor Registerpoint from X-Center of the MovieClip
	 * @param anchorY	Anchor Registerpoint from Y-Center of the MovieClip
	 */
	public function curveTo(controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):Void {
		this.mc.curveTo(controlX, controlY, anchorX, anchorY);
	}
	
	/**
	 * Closes the Started Fill.
	 * 
	 * @see #beginFill
	 * @see #beginGradientFill
	 */
	public function endFill():Void {
		this.mc.endFill();
	}
	
	/**
	 * Sets the LineStyle of the Line to Draw
	 * 
	 * @see #lineTo
	 * @see #moveTo
	 * @see #curveTo
	 * 
	 * @param thickness		Thickness of the Line
	 * @param rgb			Color of the Line (0x000000)
	 * @param alpha			Alphavalue from the color of the Line
	 */
	public function lineStyle(thickness:Number, rgb:Number, alpha:Number):Void {
		this.mc.lineStyle(thickness, rgb, alpha);
	}
	
	/** 
	 * Draws a line to a Point
	 * 
	 * @see #lineStyle
	 * @see #moveTo
	 * @see #curveTo
	 * 
	 * @param x		Endpoint.x from the line (Startpoint is the last x or 0)
	 * @param y		Endpoint.y from the line (Startpoint is the last y or 0)
	 */
	public function lineTo(x:Number, y:Number):Void {
		this.mc.lineTo(x, y);
	}
	
	/** 
	 * moves the drawer to A Point
	 * 
	 * @see #lineStyle
	 * @see #moveTo
	 * @see #curveTo
	 * 
	 * @param x		Target X Value
	 * @param y		Target Y Value
	 */
	public function moveTo(x:Number, y:Number):Void {
		this.mc.moveTo(x, y);
	}
	
	/**
	 * Basic function for passing all Events of the MovieClip to the Eventhandler.
	 */
	private function catchEvents ():Void {
		// Eventinitialisation
		this.addEventType("onData");
		this.mc.onData = function () {
			this.owner.dispatchEvent({type:"onData"});
		}
		this.addEventType("onDragOut");
		this.mc.onDragOut = function() {
			this.owner.dispatchEvent({type:"onDragOut"});
		}
		this.addEventType("onDragOver");
		this.mc.onDragOver = function() {
			this.owner.dispatchEvent({type:"onDragOver"});
		}
		this.addEventType("onEnterFrame");
		this.mc.onEnterFrame = function() {
			this.owner.dispatchEvent({type:"onEnterFrame"});
		}
		this.addEventType("onKeyDown");
		this.mc.onKeyDown = function() {
			this.owner.dispatchEvent({type:"onKeyDown"});
		}
		this.addEventType("onKeyUp");
		this.mc.onKeyUp = function() {
			this.owner.dispatchEvent({type:"onKeyUp"});
		}
		this.addEventType("onKillFocus");
		this.mc.onKillFocus = function(newFocus) {
			this.owner.dispatchEvent({type:"onKillFocus", data:{newFocus:newFocus}});
		}
		this.addEventType("onLoad");
		this.mc.onLoad = function() {
			this.owner.dispatchEvent({type:"onLoad"});
		}
		this.addEventType("onMouseDown");
		this.mc.onMouseDown = function() {
			this.owner.dispatchEvent({type:"onMouseDown"});
		}
		this.addEventType("onMouseMove");
		this.mc.onMouseMove = function() {
			this.owner.dispatchEvent({type:"onMouseMove"});
		}
		this.addEventType("onMouseUp");
		this.mc.onMouseUp = function() {
			this.owner.dispatchEvent({type:"onMouseUp"});
		}
		this.addEventType("onPress");
		this.mc.onPress = function() {
			this.owner.dispatchEvent({type:"onPress"});
		}
		this.addEventType("onRelease");
		this.mc.onRelease = function() {
			this.owner.dispatchEvent({type:"onRelease"});
		}
		this.addEventType("onReleaseOutside");
		this.mc.onReleaseOutside = function() {
			this.owner.dispatchEvent({type:"onReleaseOutside"});
		}
		this.addEventType("onRollOut");
		this.mc.onRollOut = function() {
			this.owner.dispatchEvent({type:"onRollOut"});
		}
		this.addEventType("onRollOver");
		this.mc.onRollOver = function() {
			this.owner.dispatchEvent({type:"onRollOver"});
		}
		this.addEventType("onSetFocus");
		this.mc.onSetFocus = function(oldFocus) {
			this.owner.dispatchEvent({type:"onSetFocus", data:{oldFocus:oldFocus}});
		}
		this.addEventType("onUnload");
		this.mc.onUnload = function() {
			this.owner.dispatchEvent({type:"onUnload"});
		}
	}
	
	/**
	 * Basic Class to check if this Class is Correct
	 *
	 * @exception de.flashforum.exceptions.ObjectNotDefinedException	It throws an Exception if something is wrong with this class
	 */
	private function check ():Void {
		if(this.parent != this.mc._parent)
			this.parent = this.mc._parent;
		if(this.name != this.mc._name)
			this.name = this.mc._name;
		if(!this.mc)
			throw new de.flashforum.exceptions.ObjectNotDefinedException("The own MovieClip isn't avaibable to set Operations", "de.flashforum.basic.VisibleElement");
		if(!this.parent)
			throw new de.flashforum.exceptions.ObjectNotDefinedException("Parent must be available, it has gone anywhere ?", "de.flashforum.basic.VisibleElement", "check");
	}
}