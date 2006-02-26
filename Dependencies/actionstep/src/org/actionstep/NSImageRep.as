/* See LICENSE for copyright and terms of use */

import org.actionstep.ASBitmapImageRep;
import org.actionstep.ASUtils;
import org.actionstep.NSDictionary;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSObject;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSSize;

/**
 * <code>NSImageRep</code> is a semiabstract superclass (“semi” because it 
 * has some instance variables and implementation of its own); each of its 
 * subclasses knows how to draw an image from a particular kind of source data. 
 * While an NSImageRep subclass can be used directly, it’s typically used 
 * through an <code>NSImage</code> object.
 * 
 * @author Scott Hyndman
 * @author Richard Kilmer
 */
class org.actionstep.NSImageRep extends NSObject {

  private var m_drawPoint:NSPoint;
  private var m_drawRect:NSRect;
  private var m_drawClip:MovieClip;
  private var m_size:NSSize;
  private var m_defaultRect:NSRect;

  public function NSImageRep() {
    m_drawPoint = NSPoint.ZeroPoint;
    m_drawRect = null;
  }

  //******************************************************
  //           Setting the size of an image
  //******************************************************

  /**
   * Sets the size of the image to <code>value</code>, which is a size
   * represented in the base coordinate system.
   */
  public function setSize(value:NSSize) {
    m_size = value;
  }

  /**
   * Returns the size of the image.
   */
  public function size():NSSize {
    return m_size;
  }


  //******************************************************
  //*   Specifying information about the representation
  //******************************************************

  /**
   * Returns the height of the image.
   */
  public function pixelsHigh():Number
  {
    return m_size.height;
  }

  /**
   * Sets the height of the image to <code>pixels</code>.
   */
  public function setPixelsHigh(pixels:Number):Void
  {
    m_size.height = pixels;
  }

  /**
   * Returns the width of the image.
   */
  public function pixelsWide():Number
  {
    return m_size.width;
  }

  /**
   * Sets the width of the image to <code>pixels</code>.
   */
  public function setPixelsWide(pixels:Number):Void
  {
    m_size.width = pixels;
  }

  //******************************************************
  //*                     Drawing
  //******************************************************

  /**
   * Draws the image at location (0,0). This method returns <code>true</code>
   * if the image was successfully drawn, or <code>false</code> if it
   * wasn't.
   */
  public function draw():Boolean {
    return true;
  }

  /**
   * Draws the image so that it fits inside the rectangle <code>rect</code>.
   *
   * This method sets the drawing point to be <code>rect.origin</code> and
   * will scale the image to fit within <code>rect.size</code>.
   *
   * After drawing is complete, the scaling settings are restored to their
   * original values.
   */
  public function drawInRect(rect:NSRect):Boolean {
  	if (null == m_drawClip || null == rect) {
  	  return false;
  	}

  	m_drawPoint = rect.origin;
  	var oSz:NSSize = size();

  	setSize(rect.size);
    draw();
    setSize(oSz);

    return true;
  }

  /**
   * Sets the image reps base coordinates to <code>point</code>, then invokes
   * draw to draw the image.
   *
   * After the image has been drawn, the base coordinates are restored to
   * their original values.
   */
  public function drawAtPoint(point:NSPoint):Boolean {
  	if (null == m_drawClip || null == point) {
  	  return false;
  	}

    m_drawPoint = point;
    draw();
    m_drawPoint = null;

    return true;
  }

  public function setFocus(clip:MovieClip) {
    m_drawClip = clip;
    m_drawPoint = NSPoint.ZeroPoint;
    if (m_defaultRect == null) {
      m_defaultRect = new NSRect(0,0,size().width, size().height);
    }
    m_drawRect = m_defaultRect;
  }


  /**
   * Replaces the draw clip's clear() method with a new method that will also
   * cover the removal of MovieClip based image representations.
   *
   * For internal use only.
   */
  private function decorateDrawClipIfNeeded():Void {
    if (m_drawClip == null || m_drawClip.__oldClear != null) {
      return;
    }

    var dc:MovieClip = m_drawClip;
    m_drawClip.__imageReferences = new Array();
    m_drawClip.__oldClear = m_drawClip.clear;
    m_drawClip.__unusedDepths = {length:0};
    _global.ASSetPropFlags(m_drawClip, 
      ["__imageReferences", "__oldClear", "__unusedDepths"], 1);
    _global.ASSetPropFlags(m_drawClip.__unusedDepths, ["length"], 1);

    m_drawClip.clear = function() {
      var refs:Array = dc.__imageReferences;
      var len:Number = refs.length;
      var obj:Object = this.__unusedDepths;

      for (var i:Number = 0; i < len; i++) {
      	obj[MovieClip(refs[i]).getDepth()] = true;
      	obj.length++;

        refs[i].removeMovieClip();
      }

      dc.__imageReferences = new Array();
      dc.__oldClear();
    };
  }

  /**
   * Adds an image rep created movieclip to a list of references held on the
   * draw clip. These references are used for clearing.
   */
  private function addImageRepToDrawClip(ref:MovieClip):Void {
    decorateDrawClipIfNeeded();
    m_drawClip.__imageReferences.push(ref);
  }

  //******************************************************
  //*             Creating an NSImageRep
  //******************************************************

  /**
   * Creates and returns a new image rep that will be filled with the
   * contents of the image at <code>url</code>.
   *
   * Since Flash loads images asynchronously, the image itself will not
   * be immediately available. An NSImageRepDidLoad <code>notification</code>
   * will be posted to the default notificaiton center when the loading
   * completes.
   */
  public static function imageRepWithContentsOfURL(url:String):NSImageRep
  {
  	if (_root.__imageHoldingArea == undefined) {
  	  _root.__imageHoldingArea = _root.createEmptyMovieClip(
  	    "__imageHoldingArea", _root.getNextHighestDepth());
  	  //_root.__imageHoldingArea._visible = false;
  	}

  	var loadingClip:MovieClip = _root.__imageHoldingArea.createEmptyMovieClip(
  	  "image" + _root.__imageHoldingArea.getNextHighestDepth(),
  	  _root.__imageHoldingArea.getNextHighestDepth());

  	//
  	// Set up our image rep
  	//
  	var rep:ASBitmapImageRep = new ASBitmapImageRep();

  	//
  	// Set up listener and MovieClipLoader
  	//
  	var listener:Object = {};
  	var mcloader:MovieClipLoader = new MovieClipLoader();
  	mcloader.loadClip(url, loadingClip);
  	mcloader.addListener(listener);

  	//
  	// Complete listener
  	//
  	listener.onLoadInit = function(target:MovieClip):Void {
	  //
	  // Give image rep its source image
	  //
	  rep.initWithMovieClip(target);

	  //
	  // Now that we've extracted the image data, remove the movieclip
	  //
	  target.removeMovieClip();

      try {
	    //
        // Post notification
        //
        NSNotificationCenter.defaultCenter()
	      .postNotificationWithNameObjectUserInfo(
	        NSImageRep.ASImageRepDidLoad,
	        rep,
	        NSDictionary.dictionaryWithObjectForKey(
	          true, "ASLoadSuccess"));
      } catch (e:Error) {
        trace(e.toString());
      }
  	};

  	//
  	// Error listener
  	//
  	listener.onLoadError = function(target:MovieClip):Void {
  	  target.removeMovieClip();
      
      //
      // TODO Consider initializing the rep with a red square, to indicate error
      //
      
	  //
	  // Post notification
	  //
	  try {
	    NSNotificationCenter.defaultCenter()
	      .postNotificationWithNameObjectUserInfo(
	        NSImageRep.ASImageRepDidLoad,
	        rep,
	        NSDictionary.dictionaryWithObjectForKey(
	          false, "ASLoadSuccess"));
      } catch (e:Error) {
        trace(e.toString());
      }
  	};

  	//
  	// Progress listener
  	//
  	listener.onLoadProgress = function(target:MovieClip,
  	    loadedBytes:Number, totalBytes:Number):Void {
  	  try {
	    //
	    // Post notification
        //
        NSNotificationCenter.defaultCenter()
	      .postNotificationWithNameObjectUserInfo(
	        NSImageRep.ASImageRepGotProgress,
	        rep,
	        NSDictionary.dictionaryWithObjectsAndKeys(
	          loadedBytes, "ASBytesLoaded",
	          totalBytes, "ASBytesTotal"));
  	  } catch (e:Error) {
  	    trace(e.toString());
  	  }
  	};

  	return rep;
  }

  //******************************************************
  //*                 Notifications
  //******************************************************

  /**
   * Posted when an image rep created using
   * <code>NSImageRep#imageRepWithContentsOfURL</code> finishes loading, or
   * encounters an error.
   *
   * The user info dictionary contains:
   *   "ASLoadSuccess": true if the image loaded successfully. (Boolean)
   */
  public static var ASImageRepDidLoad:Number = ASUtils.intern(
    "ASImageRepDidLoad");

  /**
   * Posted whenever an image rep created using
   * <code>NSImageRep#imageRepWithContentsOfURL</code> writes content to the
   * hard drive during the load process.
   *
   * The user info dictionary contains:
   *   "ASBytesLoaded": The number of bytes loaded. (Number)
   *   "ASBytesTotal": The total number of bytes in the file. (Number)
   */
  public static var ASImageRepGotProgress:Number = ASUtils.intern(
    "ASImageRepGotProgress");
}