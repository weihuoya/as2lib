/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.ASTheme;
import org.actionstep.NSRect;
import org.actionstep.NSView;

/**
 * @author Scott Hyndman
 */
class org.actionstep.themes.plastic.ASPlasticTheme extends ASTheme {

	//******************************************************
	//*                   Buttons
	//******************************************************

//		var bc:MovieClip = _root.createEmptyMovieClip("buttonClip", 1);
//		var matrix:Matrix = new Matrix();
//		matrix.createGradientBox(100, 21, ASDraw.getRadiansByDegrees(-103), 0, 3);
//		bc.beginGradientFill("linear", [0xB5B2AA, 0xEFEEEC], [100, 100], [0, 100], matrix);
//		ASDraw.outlineCornerRectWithRect(bc, new NSRect(0, 0, 100, 21), 3, 0x808080);
//		bc.endFill();
//
//		var glow:GlowFilter = new GlowFilter(0x999999, 30, 12, 7, .56, 2, true, false);
//		bc.filters = [glow];
//		bc._x = bc._y = 10;
//	/**
//	 * Draws a button border of the provided cell.
//	 */
//	public function drawButtonCellBorderInRectOfView(cell:NSButtonCell,
//			rect:NSRect, view:NSView):Void {
//		var mask:Number;
//		var highlighted:Boolean = cell.isHighlighted();
//		if (highlighted) {
//			mask = cell.highlightsBy();
//			if (cell.state() == 1) {
//				mask &= ~cell.showsStateBy();
//			}
//		} else if (cell.state() == 1) {
//			mask = cell.showsStateBy();
//		} else {
//			mask = NSCell.NSNoCellMask;
//		}
//
//		if (cell.isBezeled()) {
//			switch(cell.bezelStyle()) {
//				case NSBezelStyle.NSRoundedBezelStyle:
//
//
//				case NSBezelStyle.NSDisclosureBezelStyle:
//				case NSBezelStyle.NSCircularBezelStyle:
//				case NSBezelStyle.NSHelpButtonBezelStyle:
//				// ^-- above not implemented --^
//				//		 fall through to default
//				case NSBezelStyle.NSThickSquareBezelStyle:
//				case NSBezelStyle.NSThickerSquareBezelStyle:
//				case NSBezelStyle.NSRegularSquareBezelStyle:
//					//
//					// Determine the border thickness
//					//
//					var thickness:Number;
//					switch (cell.bezelStyle()) {
//						case NSBezelStyle.NSRegularSquareBezelStyle:
//							thickness = 2;
//							break;
//						case NSBezelStyle.NSThickSquareBezelStyle:
//							thickness = 3;
//							break;
//						case NSBezelStyle.NSThickerSquareBezelStyle:
//							thickness = 4;
//							break;
//					}
//
//					if (cell.isEnabled()) {
//						if (highlighted || (mask & (
//								NSCell.NSChangeGrayCellMask |
//								NSCell.NSChangeBackgroundCellMask))) {
//							drawButtonDown(view.mcBounds(), rect);
//						} else {
//							drawButtonUp(view.mcBounds(), rect);
//						}
//					} else {
//						if (highlighted || (mask & (
//								NSCell.NSChangeGrayCellMask |
//								NSCell.NSChangeBackgroundCellMask))) {
//							drawButtonDownDisabled(view.mcBounds(), rect);
//						} else {
//							drawButtonUpDisabled(view.mcBounds(), rect);
//						}
//					}
//
//					break;
//
//				case NSBezelStyle.NSShadowlessSquareBezelStyle:
//					if (cell.isEnabled()) {
//						if (highlighted || (mask & (
//								NSCell.NSChangeGrayCellMask |
//								NSCell.NSChangeBackgroundCellMask))) {
//							drawButtonDownWithoutBorder(view.mcBounds(), rect);
//						} else {
//							drawButtonUpWithoutBorder(view.mcBounds(), rect);
//						}
//					} else {
//						if (highlighted || (mask & (
//								NSCell.NSChangeGrayCellMask |
//								NSCell.NSChangeBackgroundCellMask))) {
//							drawButtonDownDisabledWithoutBorder(view.mcBounds(), rect);
//						} else {
//							drawButtonUpDisabledWithoutBorder(view.mcBounds(), rect);
//						}
//					}
//
//					break;
//			}
//		} else if (cell.isBordered()) {
//			if (cell.isEnabled()) {
//				drawBorderButtonUp(view.mcBounds(), rect);
//			} else {
//				drawBorderButtonDown(view.mcBounds(), rect);
//			}
//		}
//	}
//
//	private static var drawButtonUp_outlineColors:Array = [0x82858E, 0xD3D6DB];
//	private static var drawButtonUp_inlineColors:Array	= [0xDFE2E9, 0x858992];
//	private static var drawButtonUp_colors:Array = [0xEEF2F5, 0xC7CAD1, 0xC7CAD1, 0x858992];
//	private static var drawButtonUp_ratios:Array = [1, 5, 23, 26];
//	private function drawButtonUp(mc:MovieClip, rect:NSRect)
//	{
//		drawButtonUpWithoutBorder(mc, rect.insetRect(1,1));
//		ASDraw.outlineRectWithRect( mc, rect, drawButtonUp_outlineColors);
//	}
//
//	private function drawButtonUpWithoutBorder(mc:MovieClip, rect:NSRect)
//	{
//		ASDraw.gradientRectWithRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM, drawButtonUp_colors, drawButtonUp_ratios);
//		ASDraw.outlineRectWithRect( mc, rect, drawButtonUp_inlineColors);
//	}
//
//	private static var drawButtonDown_outlineColors:Array = [0x82858E, 0xECEDF0];
//	private static var drawButtonDown_inlineColors:Array = [0x696F79, 0xD4D6DB];
//	private static var drawButtonDown_colors:Array = [0x696F79, 0xB1B5BC, 0xB1B5BC, 0xD9DBDF, 0xC9CDD2];
//	private static var drawButtonDown_ratios:Array = [1, 5, 23, 25, 26];
//	private function drawButtonDown(mc:MovieClip, rect:NSRect,
//			thickness:Number):Void {
//		drawButtonDownWithoutBorder(mc, rect.insetRect(thickness, thickness));
//		ASDraw.outlineRectWithRect( mc, rect, drawButtonDown_outlineColors);
//	}
//
//	private static var drawButtonUpDisabled_outlineAlphas:Array = [50, 50];
//	private static var drawButtonUpDisabled_inlineAlphas:Array	= [50, 50];
//	private static var drawButtonUpDisabled_alphas:Array = [50, 50, 50, 50];
//	public function drawButtonUpDisabled(mc:MovieClip, rect:NSRect)
//	{
//		drawButtonUpDisabledWithoutBorder(mc, rect.insetRect(1,1));
//		ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonUp_outlineColors, drawButtonUpDisabled_outlineAlphas);
//	}
//
//	public function drawButtonUpDisabledWithoutBorder(mc:MovieClip, rect:NSRect)
//	{
//		ASDraw.gradientRectWithAlphaRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM,
//			drawButtonUp_colors, drawButtonUp_ratios, drawButtonUpDisabled_alphas);
//		ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonUp_inlineColors, drawButtonUpDisabled_inlineAlphas);
//	}
//
//	private function drawButtonDownWithoutBorder(mc:MovieClip, rect:NSRect)
//	{
//		ASDraw.gradientRectWithRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM, drawButtonDown_colors, drawButtonDown_ratios);
//		ASDraw.outlineRectWithRect( mc, rect, drawButtonDown_inlineColors);
//	}
//
//	private static var drawButtonDownDisabled_outlineAlphas:Array = [50,50];
//	private static var drawButtonDownDisabled_inlineAlphas:Array  = [50,50];
//	private static var drawButtonDownDisabled_alphas:Array  = [50,50, 50, 50, 50];
//	public function drawButtonDownDisabled(mc:MovieClip, rect:NSRect)
//	{
//		drawButtonDownDisabledWithoutBorder(mc, rect.insetRect(1,1));
//		ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonDown_outlineColors, drawButtonDownDisabled_outlineAlphas);
//	}
//
//	public function drawButtonDownDisabledWithoutBorder(mc:MovieClip, rect:NSRect)
//	{
//		ASDraw.gradientRectWithAlphaRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM,
// 			drawButtonDown_colors, drawButtonDown_ratios, drawButtonDownDisabled_alphas);
//		ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonDown_inlineColors, drawButtonDownDisabled_inlineAlphas);
//	}

	//******************************************************
	//*                  Text fields
	//******************************************************
	
	public function drawTextFieldWithRectInView(rect:NSRect, view:NSView):Void {
		drawTextfield(view.mcBounds(), rect);
	}
	
	private static var drawTextfield_outlineColors:Array = [0x4B4F57, 0x999999];
	private function drawTextfield(mc:MovieClip, rect:NSRect)
	{
		var insetRect:NSRect = rect.insetRect(1,1);
		ASDraw.fillRectWithRect(mc, rect, 0xFFFFFF);
		ASDraw.outlineRectWithRect(mc, rect, drawTextfield_outlineColors);
	}
	
	//******************************************************
	//*                    Lists
	//******************************************************
	
	public function drawListSelectionWithRectInView(rect:NSRect, aView:NSView):Void {
		ASDraw.solidCornerRectWithRect(aView.mcBounds(), 
			rect, 
			0,
			0x0000A0); 
	}
	
	//******************************************************
	//*                  Scrollers
	//******************************************************
	
	public function drawScrollerSlotWithRectInView(rect:NSRect, view:NSView):Void {
		ASDraw.gradientRectWithRect(view.mcBounds(), 
			rect, 
			ASDraw.ANGLE_LEFT_TO_RIGHT,
			[0xE0E0E0, 0xF8F8F8],
			[30, 145]);
	}
	
	public function scrollerWidth():Number {
		return 18;
	}
	
	public function scrollerButtonWidth():Number {
		return 16;
	}
  
	//******************************************************
	//*                    Images
	//******************************************************

	public function registerDefaultImages():Void {
		//
		// ComboBox
		//
		setImage("NSComboBoxDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);
		setImage("NSHighlightedComboBoxDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);

		//
		// Stepper
		//
		setImage("NSStepperUpArrow", org.actionstep.themes.plastic.images.ASScrollerUpArrowRep);
		setImage("NSHighlightedStepperUpArrow", org.actionstep.themes.plastic.images.ASScrollerUpArrowRep);
		setImage("NSStepperDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);
		setImage("NSHighlightedStepperDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);

		//
		// Register new scroller arrows
		//
		setImage("NSScrollerUpArrow", org.actionstep.themes.plastic.images.ASScrollerUpArrowRep);
		setImage("NSHighlightedScrollerUpArrow", org.actionstep.themes.plastic.images.ASScrollerUpArrowRep);
		setImage("NSScrollerDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);
		setImage("NSHighlightedScrollerDownArrow", org.actionstep.themes.plastic.images.ASScrollerDownArrowRep);
		setImage("NSScrollerLeftArrow", org.actionstep.themes.plastic.images.ASScrollerLeftArrowRep);
		setImage("NSHighlightedScrollerLeftArrow", org.actionstep.themes.plastic.images.ASScrollerLeftArrowRep);
		setImage("NSScrollerRightArrow", org.actionstep.themes.plastic.images.ASScrollerRightArrowRep);
		setImage("NSHighlightedScrollerRightArrow", org.actionstep.themes.plastic.images.ASScrollerRightArrowRep);

		//
		// Browser
		//
		setImage("NSBrowserBranch", org.actionstep.themes.plastic.images.ASScrollerRightArrowRep);
		setImage("NSHighlightedBrowserBranch", org.actionstep.themes.plastic.images.ASScrollerRightArrowRep);
		
		//
		// Fill in anything we're missing
		//
		super.registerDefaultImages();
	}
}