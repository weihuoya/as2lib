/* See LICENSE for copyright and terms of use */

import org.actionstep.ASTheme;
import org.actionstep.ASThemeProtocol;
import org.actionstep.constants.NSSliderType;
import org.actionstep.constants.NSTickMarkPosition;
import org.actionstep.NSActionCell;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSImage;
import org.actionstep.NSNumber;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSView;
import flash.filters.DropShadowFilter;
import org.actionstep.images.ASSliderLinearThumbRep;

/**
 * @author Scott Hyndman
 */
class org.actionstep.NSSliderCell extends NSActionCell {

	//******************************************************															 
	//*                Member variables
	//******************************************************
	
	private var m_altIncValue:Number;
	private var m_knobThickness:Number;
	private var m_sliderType:NSSliderType;
	private var m_maxVal:Number;
	private var m_minVal:Number;
	private var m_tickMarkValuesOnly:Boolean;
	private var m_numTickMarks:Number;
	private var m_tickMarkPosition:NSTickMarkPosition;
	private var m_knobClip:MovieClip;
	private var m_isDraggingKnob:Boolean;
	private var m_sliderRect:NSRect;
	private var m_isVertical:Number;
	
	//******************************************************															 
	//*                 Construction
	//******************************************************
	
	/**
	 * Constructs a new instance of the <code>NSSliderCell</code> class.
	 */
	public function NSSliderCell() {
		m_altIncValue = 10;
		m_knobThickness = 10;
		m_sliderType = NSSliderType.NSLinearSlider;
		m_minVal = 0;
		m_maxVal = 100;
		m_numTickMarks = 11;
		m_tickMarkValuesOnly = false;
		m_isVertical = -1;
		m_tickMarkPosition = NSTickMarkPosition.NSTickMarkBelow;
		setFloatValue(0);
	}
	
	//******************************************************															 
	//*                  Destruction
	//******************************************************
	
	public function release():Void {
		super.release();
		m_knobClip.removeMovieClip();
	}
	
	//******************************************************															 
	//*        Asking about the cell’s behavior
	//******************************************************
	
	/**
	 * By default, this method returns <code>true</code>, so an 
	 * <code>NSSliderCell</code> continues to track the cursor even after the 
	 * cursor leaves the cell’s tracking rectangle.
	 */
	public static function prefersTrackingUntilMouseUp():Boolean {
		return true;
	}
	
	/**
	 * Returns the amount the slider will change its value by when the user
	 * drags the knob with the option key held.
	 */
	public function altIncrementValue():Number {
		return m_altIncValue;
	}
	
	/**
	 * Returns the rectangle within which the cell tracks the cursor while the 
	 * mouse button is down.
	 */
	public function trackRect():NSRect {
		return m_controlView.bounds();
	}
	
	//******************************************************															 
	//*             Setting the slider type
	//******************************************************
	
	/**
	 * Sets the type of this slider to <code>type</code>.
	 * 
	 * @see #sliderType()
	 */
	public function setSliderType(type:NSSliderType):Void {
		m_sliderType = type;
	}
	
	/**
	 * Returns the type of slider.
	 */
	public function sliderType():NSSliderType {
		return m_sliderType;
	}

	//******************************************************															 
	//*          Changing the cell’s behavior
	//******************************************************
	
	/**
	 * Sets the amount by which the slider changes its value when the user
	 * drags the knob with the option key held.
	 */
	public function setAltIncrementValue(value:Number):Void {
		m_altIncValue = value;
	}
		
	//******************************************************															 
	//*               Displaying the cell
	//******************************************************
	
	/**
	 * Returns the rectangle in which the knob will be drawn.
	 * 
	 * <code>flipped</code> indicates whether the coordinate system is flipped.
	 */
	public function knobRectFlipped(flipped:Boolean):NSRect {
		if (m_sliderType == NSSliderType.NSLinearSlider) {
			return linearKnobRectFlipped(flipped);
		} else {
			return circularKnobRectFlipped(flipped);
		}
	}
	
	/**
	 * Returns the knob rect for a circular slider.
	 */
	private function circularKnobRectFlipped(flipped:Boolean):NSRect {
		return m_sliderRect.clone();
	}
	
	/**
	 * Returns the knob rect for a linear slider.
	 */
	private function linearKnobRectFlipped(flipped:Boolean):NSRect {
		var min:Number = minValue();
		var max:Number = maxValue();
		var percentage:Number = (floatValue() - min) / (max - min);
		var tickPos:NSTickMarkPosition = tickMarkPosition();
		var tickOffset:Number = ASTheme.current().sliderTickLength() * 4 / 5;
		var tickCnt:Number = numberOfTickMarks();
		var vert:Boolean = isVertical() == 1;
		var img:NSImage = NSImage.imageNamed(vert ? 
			"NSSliderLinearVerticalThumbRep" : "NSSliderLinearHorizontalThumbRep");
		var sz:NSSize = img.size();
		var rect:NSRect = m_sliderRect.clone();
		var x:Number;
		var y:Number;
		
		if (vert) {
			var oldY:Number = rect.origin.y;
			rect = rect.insetRect(0, sz.height / 2);
			y = oldY + percentage * rect.size.height + (1 - percentage) * 6 - 3;
			x = rect.midX() - sz.width / 2;
			
			if (tickCnt > 0) {
				if (tickPos == NSTickMarkPosition.NSTickMarkLeft) {
					x += tickOffset;
				} else {
					x -= tickOffset;
				}
			}
		} else {
			var oldX:Number = rect.origin.x;
			rect = rect.insetRect(sz.width / 2, 0);
			x = oldX + percentage * rect.size.width + (1 - percentage) * 6 - 3;
			y = rect.midY() - sz.height / 2;
			
			if (tickCnt > 0) {
				if (tickPos == NSTickMarkPosition.NSTickMarkAbove) {
					y += tickOffset;
				} else {
					y -= tickOffset;
				}
			}
		}
				
		return new NSRect(x, y, sz.width, sz.height);
	}
	
	/**
	 * Draws the slider’s bar—but not its bezel or knob—inside 
	 * <code>aRect</code>.
	 * 
	 * <code>flipped</code> indicates whether the coordinate system is flipped.
	 */
	public function drawBarInsideFlipped(aRect:NSRect, flipped:Boolean):Void {
		ASTheme.current().drawSliderTrackWithRectInView(aRect,
			m_controlView);
	}
	
	/**
	 * Calculates where the knob should be drawn, then uses
	 * <code>#drawKnobInRect</code> to perform the drawing.
	 */
	public function drawKnob():Void {
		drawKnobInRect(knobRectFlipped(
			tickMarkPosition() == NSTickMarkPosition.NSTickMarkBelow
			|| tickMarkPosition() == NSTickMarkPosition.NSTickMarkLeft));
	}
	
	/**
	 * Draws the knob into the area defined by <code>aRect</code>.
	 */
	public function drawKnobInRect(aRect:NSRect):Void {
		var flipped:Boolean = tickMarkPosition() == NSTickMarkPosition.NSTickMarkBelow
			|| tickMarkPosition() == NSTickMarkPosition.NSTickMarkLeft;
		
		m_knobClip._rotation = 0;
		m_knobClip.clear();
		
		//
		// Get the correct image
		//
		var img:NSImage;
		if (numberOfTickMarks() == 0) {
			img = NSImage.imageNamed("NSSliderRoundThumbRep");
		}
		else if (m_sliderType == NSSliderType.NSLinearSlider) {
			if (isVertical() == 1) {
				img = NSImage.imageNamed("NSSliderLinearVerticalThumbRep");
			} else {
				img = NSImage.imageNamed("NSSliderLinearHorizontalThumbRep");
			}
		} else {
			img = NSImage.imageNamed("NSSliderCircularThumbRep");
		}
		
		//
		// Draw the image
		//
		img.lockFocus(m_knobClip);
		if (m_sliderType == NSSliderType.NSLinearSlider) {
			ASSliderLinearThumbRep(img.bestRepresentationForDevice()).setFlipped(
				flipped);
			m_knobClip._x = aRect.origin.x;
			m_knobClip._y = aRect.origin.y;
			img.drawInRect(NSRect.withOriginSize(NSPoint.ZeroPoint, aRect.size));
		} else {
			var min:Number = minValue();
			var max:Number = maxValue();
			var percentage:Number = (floatValue() - min) / (max - min);
			var angle:Number = 360 * percentage;
			
			m_knobClip._x = aRect.origin.x + aRect.size.width / 2;
			m_knobClip._y = aRect.origin.y + aRect.size.width / 2;
			img.drawAtPoint(new NSPoint(aRect.size.width / 2, 
				aRect.size.height / 2));
			m_knobClip._rotation = angle;
		}
		
		img.unlockFocus();
	}
	
	/**
	 * Overwritten to create the knob clip.
	 */
	public function drawWithFrameInView(cellFrame:NSRect, inView:NSView):Void {
		if (m_controlView != inView) {
			m_knobClip = inView.createBoundsMovieClip();
			m_knobClip.view = inView;
			
			//
			// Create inner dropshadow filter
			//
			var ds:DropShadowFilter = new DropShadowFilter();
			ds.inner = true;
			ds.strength = 1;
			ds.color = 0x444444;
			ds.angle = 90;
			ds.blurX = 3;
			ds.blurY = 8;
			ds.distance = 1;
			ds.quality = 2;
			
			m_knobClip.filters = [ds];
		}
		
		super.drawWithFrameInView(cellFrame, inView);
	}
  
	/**
	* Draws the "inside" of the cell. No border is drawn.
	*/
	public function drawInteriorWithFrameInView(rect:NSRect, view:NSView):Void {
		if (m_sliderType == NSSliderType.NSLinearSlider) {
			drawLinearSliderWithFrameInView(rect, view);
		} else {
			drawCircularSliderWithFrameInView(rect, view);
		}
			
		//
		// Draw knob
		//
		drawKnob();
	}
	
	private function drawCircularSliderWithFrameInView(rect:NSRect,
			view:NSView):Void {
		var theme:ASThemeProtocol = ASTheme.current();
		theme.drawCircularSliderWithRectInView(rect, view);
		
		var tickLength:Number = theme.sliderTickLength();
		var ticks:Number = numberOfTickMarks();
		for (var i:Number = 0; i < ticks; i++) {
			
		}
	}
	
	/**
	 * Draws a linear slider.
	 */
	private function drawLinearSliderWithFrameInView(rect:NSRect, 
			view:NSView):Void {
		var theme:ASThemeProtocol = ASTheme.current();
		var vertical:Boolean = rect.size.height >= rect.size.width;
		m_sliderRect = drawingRectForBounds(rect);
		var trackRect:NSRect = m_sliderRect.clone();
		var ticks:Number = numberOfTickMarks();
		var trackWidth:Number = theme.sliderTrackWidth();
		var tickLen:Number = theme.sliderTickLength();
		
		//
		// Inset track rect on non-long axis
		//
		if (vertical) {
			trackRect.size.height -= 1;
			trackRect = trackRect.insetRect((trackRect.size.width 
				- trackWidth) / 2, 0);
		} else {
			trackRect.size.width -= 1;
			trackRect = trackRect.insetRect(0, 
				(trackRect.size.height - trackWidth) / 2);
		}
		
		m_isVertical = vertical ? 1 : 0;
		
		//
		// Offset the track rectangle further if we have ticks
		//
		if (ticks != 0) {
			var tickPos:NSTickMarkPosition = tickMarkPosition();
			
			if (vertical && tickPos == NSTickMarkPosition.NSTickMarkLeft) {
				trackRect = trackRect.translateRect(tickLen, 0);
			}
			else if (vertical && tickPos == NSTickMarkPosition.NSTickMarkRight) {
				trackRect = trackRect.translateRect(-tickLen, 0);
			}
			else if (!vertical && tickPos == NSTickMarkPosition.NSTickMarkAbove) {
				trackRect = trackRect.translateRect(0, tickLen);
			}
			else if (!vertical && tickPos == NSTickMarkPosition.NSTickMarkBelow) {
				trackRect = trackRect.translateRect(0, -tickLen);
			}
		}
		
		//
		// Draw bar
		//
		drawBarInsideFlipped(trackRect, false);
		
		//
		// Draw ticks
		//
		for (var i:Number = 0; i < ticks; i++) {
			var tickRect:NSRect = rectOfTickMarkAtIndex(i);
			theme.drawLinearSliderTickWithRectInViewVertical(tickRect, 
				view, vertical);
		}
	}
	
	//******************************************************															 
	//*        Asking about the cell’s appearance
	//******************************************************
	
	/**
	 * Returns the knob's thickness in pixels.
	 * 
	 * A knob's thickness is the length of the knob along the slider's long 
	 * dimension.
	 */
	public function knobThickness():Number {
		return m_knobThickness;
	}
	
	/**
	 * Returns 1 if the slider is vertical, 0 if it is horizontal and -1 if the
	 * orientation cannot be determined.
	 * 
	 * A slider is vertical if its height is greater than its width.
	 */
	public function isVertical():Number {
		return m_isVertical;
	}
	
	//******************************************************															 
	//*             Modifying value limits
	//******************************************************
	
	/**
	 * Returns the minimum value of the slider.
	 */
	public function minValue():Number {
		return m_minVal;
	}
	
	/**
	 * Sets the minimum value of the slider to <code>value</code>.
	 */
	public function setMinValue(value:Number):Void {
		m_minVal = value;
	}
	
	/**
	 * Returns the maximum value of the slider.
	 */
	public function maxValue():Number {
		return m_maxVal;
	}
	
	/**
	 * Sets the maximum value of the slider to <code>value</code>.
	 */
	public function setMaxValue(value:Number):Void {
		m_maxVal = value;
	}
	
	//******************************************************															 
	//*              Managing tick marks
	//******************************************************
	
	/**
	 * Returns <code>true</code> if the slider can only be set to values
	 * associated with tick marks, and nothing in between.
	 * 
	 * @see #setAllowsTickMarkValuesOnly()
	 */
	public function allowsTickMarkValuesOnly():Boolean {
		return m_tickMarkValuesOnly;
	}
	
	/**
	 * Sets whether the receiver’s values are fixed to the values represented 
	 * by the tick marks to <code>flag</code>.
	 */
	public function setAllowsTickMarkValuesOnly(flag:Boolean):Void {
		m_tickMarkValuesOnly = flag;
	}
	
	/**
	 * Returns the value of the tick mark closest to <code>value</code>.
	 * 
	 * If value is outside of the minimum and maximum values, an 
	 * <code>NSException</code> is raised.
	 */
	public function closestTickMarkValueToValue(value:Number):Number {
		if (value < minValue() || value > maxValue()) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSRange,
				value + " is out of range.",
				null);
			trace(e);
			throw e;
		}
		
		var min:Number = minValue();
		value -= min;
		var inc:Number = (maxValue() - minValue()) / (numberOfTickMarks() - 1);
		var tickBelow:Number = Math.floor(value / inc);
		var tickAbove:Number = tickBelow + 1;
		
		if (value - (tickBelow * inc) > (tickAbove * inc) - value) {
			return min + (tickAbove * inc);
		} else {
			return min + (tickBelow * inc);
		}
	}
	
	/**
	 * Returns the value associated with the point <code>point</code>.
	 * 
	 * <code>point</code> should be expressed in the coordinate system of this
	 * view.
	 */
	public function valueForPoint(point:NSPoint):Number {
		var vert:Boolean = isVertical() == 1;
		var indexer:Number;
		var frm:NSRect = m_controlView.bounds();
		var imgSz:NSSize = NSImage.imageNamed("NSSliderLinearHorizontalThumbRep").size();
		var minVal:Number = minValue();
		var maxVal:Number = maxValue();
		var valRange:Number = maxVal - minVal;
		var minCoord:Number;
		var maxCoord:Number;
		
		if (vert) {
			indexer = point.y;
			minCoord = frm.origin.y + imgSz.height;
			maxCoord = frm.maxY() - imgSz.height / 2;
		} else {
			indexer = point.x;
			minCoord = frm.origin.x + imgSz.width;
			maxCoord = frm.maxX() - imgSz.width / 2;
		}
		
		indexer -= minCoord;
		var percentage:Number = indexer / (maxCoord - minCoord);

		return minVal + percentage * valRange;
	}
	
	/**
	 * Returns the index of the tick mark closest to the location specified
	 * by <code>point</code>.
	 * 
	 * If point is not within the bounding rectangle of any tick, this method
	 * returns <code>NSNotFound</code>.
	 */
	public function indexOfTickMarkAtPoint(point:NSPoint):Number {
		var len:Number = numberOfTickMarks();
		
		for (var i:Number = 0; i < len; i++) {
			var rect:NSRect = rectOfTickMarkAtIndex(i);
			if (rect.pointInRect(point)) {
				return i;
			}
		}
		
		return NSNotFound;
	}
	
	/**
	 * Returns the number of tick marks in the slider.
	 * 
	 * @see #setNumberOfTickMarks()
	 */
	public function numberOfTickMarks():Number {
		return m_numTickMarks;
	}
	
	/**
	 * Sets the number of tick marks in the slider to <code>count</code>.
	 * 
	 * @see #numberOfTickMarks()
	 */
	public function setNumberOfTickMarks(count:Number):Void {
		m_numTickMarks = count;
	}
	
	/**
	 * Returns the bounding rectangle of the tick identified by
	 * <code>index</code>.
	 * 
	 * If no tick mark is associated with <code>index</code>, the method raises 
	 * an <code>NSException</code>.
	 */
	public function rectOfTickMarkAtIndex(index:Number):NSRect {
		if (index < 0 || index >= numberOfTickMarks()) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSRange,
				"There is no tick mark associated with " + index,
				null);
			trace(e);
			throw e;
		}
		
		var ret:NSRect;
		var imgSz:NSSize = NSImage.imageNamed("NSSliderLinearHorizontalThumbRep").size();
		var frm:NSRect = m_sliderRect.clone();
		frm = frm.insetRect(3, 3);
		var tickLen:Number = ASTheme.current().sliderTickLength();
		var vert:Boolean = isVertical() == 1;
		var tickPos:NSTickMarkPosition = tickMarkPosition();
		
		var x:Number;
		var y:Number;
		var w:Number;
		var h:Number;
		
		if (vert) {
			var tickWidth:Number = (frm.size.height - imgSz.height) 
				/ (numberOfTickMarks() - 1);
			y = frm.origin.y + imgSz.height / 2 + tickWidth * index;
			w = tickLen;
			h = tickWidth;
			y -= h / 2;
			x = frm.origin.x + (frm.size.width / 2);
			
			if (tickPos == NSTickMarkPosition.NSTickMarkLeft) {
				x -= tickLen;
			}
		} else {
			var tickWidth:Number = (frm.size.width - imgSz.width) 
				/ (numberOfTickMarks() - 1);
			x = frm.origin.x + imgSz.width / 2 + tickWidth * index;
			h = tickLen;
			w = tickWidth;
			x -= w / 2;
			y = frm.origin.y + (frm.size.height / 2);
			
			if (tickPos == NSTickMarkPosition.NSTickMarkAbove) {
				y -= tickLen;
			}
		}
		
		return new NSRect(x, y, w, h);
	}
	
	/**
	 * Returns the position of the tick marks on the slider.
	 */
	public function tickMarkPosition():NSTickMarkPosition {
		return m_tickMarkPosition;
	}
	
	/**
	 * Sets how tick marks are aligned with the slider to <code>position</code>.
	 */
	public function setTickMarkPosition(position:NSTickMarkPosition):Void {
		m_tickMarkPosition = position;
	}
	
	/**
	 * Returns the value of the tick mark associated with <code>index</code>.
	 * 
	 * If no tick mark is associated with <code>index</code>, the method raises 
	 * an <code>NSException</code>.
	 */
	public function tickMarkValueAtIndex(index:Number):Number {
		if (index < 0 || index >= numberOfTickMarks()) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo(
				NSException.NSRange,
				"There is no tick mark associated with " + index,
				null);
			trace(e);
			throw e;
		}
		
		var range:Number = maxValue() - minValue();
		return minValue() + index * (range / (numberOfTickMarks() - 1));
	}
	
	//******************************************************                               
	//*         Setting and getting cell values
	//******************************************************
	
	/**
	 * Will round <code>value</code> to the closest tick marker value if
	 * <code>#allowsTickMarkValuesOnly</code> is <code>true</code>.
	 */
	public function setObjectValue(object:Object):Void {
		if (object instanceof NSNumber) {
			var num:NSNumber = NSNumber(object);
			var val:Number = num.floatValue();
			
			if (val > maxValue()) {
				val = maxValue();
			}
			else if (val < minValue()) {
				val = minValue();
			}
			
			if (allowsTickMarkValuesOnly()) {
				val = closestTickMarkValueToValue(val);
			}
			
			object = NSNumber.numberWithFloat(val);
		}
		
		super.setObjectValue(object);
	}
	
	//******************************************************															 
	//*                  Mouse events
	//******************************************************
	
	/**
	 * Overridden to begin dragging the knob, or to set the cell's value by
	 * clicking on the track.
	 */
	public function trackMouseInRectOfViewUntilMouseUp(event:NSEvent, 
			rect:NSRect, view:NSView, untilMouseUp:Boolean):Void { 

		//
		// Begin dragging the knob or set the value to the point where the
		// click was made.
		//
		switch (event.type) {
			case NSEvent.NSLeftMouseDown:
				if (event.flashObject == m_knobClip) {
					m_isDraggingKnob = true;
				} else {
					var val:Number = valueForPoint(
						m_controlView.convertPointToView(event.mouseLocation, 
						m_controlView));
					setFloatValue(val);
					m_isDraggingKnob = true;
				}
				
				break;
		}
		
		super.trackMouseInRectOfViewUntilMouseUp(event, rect, view, 
			untilMouseUp);
	}
	
	/**
	 * Overridden to drag the knob.
	 */
	public function mouseTrackingCallback(event:NSEvent):Void {		
		switch (event.type) {				
			case NSEvent.NSLeftMouseDragged:
				if (m_isDraggingKnob) {
					var val:Number;
					
					if (m_sliderType == NSSliderType.NSLinearSlider) {
						val = valueForPoint(
							m_controlView.convertPointToView(event.mouseLocation, 
							m_controlView));
					} else {
						//! TODO Calculate val
					}
					
					setFloatValue(val);
				}
				
				break;
				
			case NSEvent.NSLeftMouseUp:
				m_isDraggingKnob = false;
				break;
		}
		
		super.mouseTrackingCallback(event);
	}
}