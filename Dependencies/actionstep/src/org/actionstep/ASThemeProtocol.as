﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.constants.NSBorderType;
import org.actionstep.constants.NSControlSize;
import org.actionstep.constants.NSImageFrameStyle;
import org.actionstep.NSButtonCell;
import org.actionstep.NSColor;
import org.actionstep.NSColorList;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSTabViewItem;
import org.actionstep.NSView;

/**
 * <p>Describes methods that should be implemented by any "Theme" object, the core
 * object for theming, as all control drawing is done through classes that 
 * implement this protocol.</p>
 * 
 * <p>To set the current theme, use {@link org.actionstep.ASTheme#setCurrent()}.
 * </p>
 *
 * @author Scott Hyndman
 */
interface org.actionstep.ASThemeProtocol 
{	
	/**
	 * First responder color
	 */
	function firstResponderColor():NSColor;

	/**
 	 * Sets this theme to the be active theme
 	 */
	function setActive(value:Boolean):Void;
  
	/**
	 * Draws a filled rectangle with the color aColor in the view inView.
	 */
	function drawFillWithRectColorInView(aRect:NSRect, aColor:NSColor, 
	  inView:NSView):Void;
	  
	/**
	 * Draws a button border of the provided type and style
	 */
	function drawButtonCellBorderInRectOfView(cell:NSButtonCell, rect:NSRect, view:NSView):Void;

	/**
	 * Draws a button interior of the provided color, type and style
	 */
	function drawButtonCellInteriorInRectOfView(cell:NSButtonCell, rect:NSRect, view:NSView):Void;
	
	/**
	 * Draws the border around the button when it has key focus
	 */
	function drawFirstResponderWithRectInView(rect:NSRect, 
	  view:NSView):Void;

	/**
	 * Draws the border around the button when it has key focus
	 */
	function drawFirstResponderWithRectInClip(rect:NSRect, 
	  clip:MovieClip):Void;

	/**
	 * Draws the the ASList background
	 */
	function drawListWithRectInView(rect:NSRect, view:NSView):Void;
	
	/**
	 * Draws a list's selected item.
	 */
	function drawListSelectionWithRectInView(rect:NSRect, aView:NSView):Void;
	
	/**
	 * Draws the ASToolTip background.
	 */
	function drawToolTipWithRectInView(rect:NSRect, view:NSView):Void;
	
	/**
	 * Returns the CSS style string that will be used by tooltips in the
	 * application.
	 * 
	 * Please not that the style the tooltip uses is called "tipText". The
	 * "tipText" tag is automatically inserted by the tooltip when its text is 
	 * set.
	 */
	function toolTipStyleCss():String;
	
	/**
	 * The amount of time (in seconds) a tooltip will wait (without the mouse 
	 * moving) before displaying.
	 */
	function toolTipInitialDelay():Number;
	
	/**
	 * The amount of time (in seconds) a tooltip will remain shown.
	 */
	function toolTipAutoPopDelay():Number;
	
	/**
	 * <p>The URL of the swf loaded into the tooltip window. The swf can contain
	 * assets for the tooltips to use.</p>
	 * 
	 * <p>If <code>null</code>, no external swf is used.</p>
	 */
	function toolTipSwf():String;
	
	/**
	 * <p>Draws the drawer.</p>
	 */
	function drawDrawerWithRectInView(aRect:NSRect, view:NSView):Void;

	/**
	 * Returns the amount of time (in milliseconds) the drawer takes to open.
	 */	
	function drawerOpenDuration():Number;
	
	/**
	 * Returns the amount of time (in milliseconds) the drawer takes to close.
	 */
	function drawerCloseDuration():Number;
	
	/**
	 * Returns the function the drawer uses to ease open.
	 */
	function drawerEaseOpenFunction():Function;
	
	/**
	 * Returns the function the drawer uses to ease close.
	 */
	function drawerEaseCloseFunction():Function;
	
	/**
	 * Returns the width of the drawer's borders.
	 */
	function drawerBorderWidth():Number;
	
	/**
	 * Draws the window as it should appear while resizing.
	 */
	function drawResizingWindowWithRectInView(aRect:NSRect, 
	  view:NSView):Void;
	
	/**
	 * Draws a windows title bar.
	 */
	function drawWindowTitleBarWithRectInViewIsKey(aRect:NSRect, 
	  view:NSView, isKey:Boolean):Void;
	
	/**
	 * Draws an NSTextFieldCell in the view.
	 */
	function drawTextFieldWithRectInView(rect:NSRect, view:NSView):Void;
	
	/**
	 * Draws the border of an <code>NSBox</code> in the area defined by 
	 * <code>rect</code> inside <code>view</code> (which is typically an 
	 * <code>NSBox</code>).
	 * 
	 * The method takes an exclude rectangle <code>exclude</code>, which is the
	 * title area. If <code>exclude</code> is <code>null</code>, no exclusion
	 * is necessary.
	 */
	function drawBoxBorderWithRectInViewExcludeRectBorderType(rect:NSRect, 
		view:NSView, exclude:NSRect, border:NSBorderType):Void;
	
	/**
	 * Draws an NSScroller slot in the view.
	 */
	function drawScrollerSlotWithRectInView(rect:NSRect, 
	  view:NSView):Void;

	/**
	 * Draws an NSScroller slot in the view.
	 */
	function drawScrollerWithRectInClip(rect:NSRect, 
	  clip:MovieClip):Void;

	/**
	 * Returns this theme's scroller width.
	 */
	function scrollerWidth():Number;
	
	/**
	 * Returns the width of the <code>NSScroller</code>'s buttons.
	 */
	function scrollerButtonWidth():Number;
	
	/**
	 * Draws the scroll view's borders in the view.
	 */
	function drawScrollViewBorderInRectWithViewBorderType(rect:NSRect, 
		view:NSView, border:NSBorderType):Void;
	
	/**
	 * Draws a table header in the view. If highlighted is TRUE, it means the
	 * column header should be drawn selected.
	 */
	function drawTableHeaderWithRectInViewHighlighted(rect:NSRect, 
	  view:NSView, highlighted:Boolean):Void;
	
	/**
	 * Draws an image frame in the view <code>view</code>, bounded by the 
	 * rectangle <code>rect</code> with a frame style of <code>style</code>.
	 */
	function drawImageFrameWithRectInViewStyle(rect:NSRect, view:NSView,
      style:NSImageFrameStyle):Void;
    
    /**
     * Returns the thickness of the status bar.
     */  	
    function statusBarThickness():Number;
    
    /**
     * Draws the background of a status bar in the area defined by 
     * <code>rect</code>, onto <code>aView</code>.
     * 
     * If <code>highlight</code> is <code>true</code>, the background should
     * appear as it would if the status item was clicked. If <code>false</code>,
     * it should appear as it ordinarily would.
     */
    function drawStatusBarBackgroundInRectWithViewHighlight(rect:NSRect,
      aView:NSView, highlight:Boolean):Void;
    
    /**
     * Returns the size of the progress indicator based on the size constant
     * <code>size</code>. 
     */    
    function progressIndicatorSizeForSize(size:NSControlSize):NSSize;
        
    /**
     * Draws a progress bar in <code>aView</code> constrained by
     * <code>rect</code>. If <code>bezeled</code> is <code>true</code> the
     * progress bar should have a 3-dimension border. <code>progress</code> is
     * a value from 0 to 100 specifying the progress the bar should display. If
     * <code>progress</code> is outside of the valid range, no progress bar is
     * drawn.
     */
    function drawProgressBarInRectWithViewBezeledProgress(
      rect:NSRect, aView:NSView, bezeled:Boolean, progress:Number):Void;

    function drawProgressBarBorderInRectWithClipBezeledProgress(
      rect:NSRect, mc:MovieClip, bezeled:Boolean, progress:Number):Void;

    public function drawProgressBarPatternInRectWithClipIndeterminate(rect:NSRect, mc:MovieClip, indeterminate:Boolean):Void;

    public function drawProgressBarSpinnerInRectWithClip(rect:NSRect, mc:MovieClip):Void;
    
    /**
     * Returns the width of the track used by an <code>NSSlider</code>.
     */
    function sliderTrackWidth():Number;
    
    /**
     * Returns the length of a tick used by a bar <code>NSSlider</code>.
     */
    function sliderTickLength():Number;
    
    /**
     * Draws the slider track in <code>view</code> constrained by
     * <code>rect</code>.
     */
    function drawSliderTrackWithRectInView(rect:NSRect, view:NSView):Void;
    
    /**
     * Draws the background of a circular slider in <code>view</code> 
     * constrained by <code>rect</code>.
     */
    function drawCircularSliderWithRectInView(aRect:NSRect, view:NSView):Void;
    
    /**
     * Draws a slider tick in <code>view</code> constrained by 
     * <code>rect</code>.
     * 
     * <code>vertical</code> specifies the orientation of the tick.
     */
    function drawLinearSliderTickWithRectInViewVertical(aRect:NSRect, 
      view:NSView, vertical:Boolean):Void;
    
    /**
     * Draws a circular slider tick with a length of <code>length</code> and an
     * angle of <code>angle</code> in <code>view</code>.
     */
    function drawCircularSliderTickWithRectLengthAngleInView(rect:NSRect, 
      length:Number, angle:Number, view:NSView):Void;
    
    /**
     * Returns the height used when drawing tabs in an <code>NSTabView</code>.
     */  
    function tabHeight():Number;
    
    /**
     * Draws the <code>NSTabViewItem</code> represented by <code>item</code> 
     * onto <code>view</code> inside the rectangle defined by <code>rect</code>.
     */
    function drawTabViewItemInRectWithView(item:NSTabViewItem, rect:NSRect,
      view:NSView):Void;
    
	/**
	 * <p>Returns the list of colors used by the application.</p>
	 * 
	 * <p>The names of colors used in the theme can be found by looking at the
	 * {@link org.actionstep.themes.ASThemeColorNames} class.</p>
	 * 	
	 * @see #setColors
	 * @see #addColorWithName
	 */
	function colors():NSColorList;
	
	/**
	 * Returns the color with the name <code>name</code>, or <code>null</code>
	 * if no such color exists.
	 * 
	 * @see #colors
	 */
	function colorWithName(name:String):NSColor;
	
	/**
	 * Sets the list of colors used by the theme.
	 * 
	 * @see #colors
	 * @see #addColorWithName
	 */
	function setColors(aColorList:NSColorList):Void;
	
	/**
	 * Adds the color <code>aColor</code> named <code>name</code> to the theme's 
	 * color list.
	 * 
	 * @see #colors
	 */
	function setColorForName(aColor:NSColor, name:String):Void;
	
	/**
	 * Registers the default named colors in the theme. Check the comment of
	 * <code>#colors</code> for specifics on what colors are named.
	 * 
	 * @see #colors
	 */
	function registerDefaultColors():Void;
	
	/**
	 * Registers the default image representations for buttons and other 
	 * controls.
	 */
	function registerDefaultImages():Void;

}
