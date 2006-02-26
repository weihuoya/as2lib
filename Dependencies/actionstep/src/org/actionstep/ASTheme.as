﻿/* See LICENSE for copyright and terms of use */

import org.actionstep.ASColors;
import org.actionstep.ASDraw;
import org.actionstep.ASThemeProtocol;
import org.actionstep.ASUtils;
import org.actionstep.constants.NSBezelStyle;
import org.actionstep.constants.NSBorderType;
import org.actionstep.constants.NSControlSize;
import org.actionstep.constants.NSImageFrameStyle;
import org.actionstep.constants.NSTabState;
import org.actionstep.NSButtonCell;
import org.actionstep.NSCell;
import org.actionstep.NSColor;
import org.actionstep.NSColorList;
import org.actionstep.NSDictionary;
import org.actionstep.NSImage;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSProgressIndicator;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSTabViewItem;
import org.actionstep.NSView;
import org.actionstep.themes.ASThemeColorNames;

/**
 * <p>This is the default ActionStep theme class.</p>
 *
 * <p>The current theme can be accessed through the {@link #current()} class
 * property, and can be set using {@link #setCurrent()}.</p>
 *
 * <p>When the theme changes, an {@link #ASThemeDidChangeNotification} is
 * posted to the default notification center.</p>
 *
 * @author Scott Hyndman
 * @author Rich Kilmer
 */
class org.actionstep.ASTheme extends org.actionstep.NSObject
  implements ASThemeProtocol
{
  //******************************************************
  //*                  Notifications
  //******************************************************

  /**
   * Posted to the default notification center when the current theme changes.
   *
   * The userInfo dictionary contains the following:
   *   "ASOldTheme" - The old theme (<code>ASThemeProtocol</code>)
   *   "ASNewTheme" - The new theme (<code>ASThemeProtocol</code>)
   */
  public static var ASThemeDidChangeNotification:Number
    = ASUtils.intern("ASThemeDidChangeNotification");

  //******************************************************
  //*                    Members
  //******************************************************

  private static var g_current:ASThemeProtocol;
  private var m_firstResponderColor:NSColor;
  private var m_colorList:NSColorList;

  //******************************************************
  //*                   Construction
  //******************************************************

  /**
   * Constructs a new instance of ASTheme.
   */
  private function ASTheme() {
    m_firstResponderColor = new NSColor(0x3333dd);
    m_colorList = (new NSColorList()).initWithName("ASTheme");
    registerDefaultColors();
  }

  /**
   * Can perform setup operations in this method
   */
  public function setActive(value:Boolean):Void {
  }

  //******************************************************
  //*                   Properties
  //******************************************************
  //******************************************************
  //*                 Public Methods
  //******************************************************

  /**
   * @see org.actionstep.ASThemeProtocol#drawFillWithRectColorInView
   */
  public function drawFillWithRectColorInView(aRect:NSRect, aColor:NSColor,
    inView:NSView):Void
  {
    ASDraw.fillRectWithRect(inView.mcBounds(), aRect, aColor.value, aColor.alphaComponent()*100);
  }

  //******************************************************
  //*                     Lists
  //******************************************************

  public function drawListWithRectInView(rect:NSRect, view:NSView):Void {
    var mc:MovieClip = view.mcBounds();
    var topShadowRect:NSRect  = ASDraw.getScaledPixelRect(rect, rect.size.width-20, 0, -rect.size.width+3,                   -2);
    //var itemHiliteRect = ASDraw.getScaledPixelRect(rect, 1, 0, -22, -rect.size.height+19);

    drawTextfield(mc, rect);
    //these are the textfield left fade colors
    //ASDraw.gradientRectWithAlphaRect(mc, topShadowRect, ASDraw.ANGLE_LEFT_TO_RIGHT, [0x767A85, 0xB6BBC1], [0,255], [50,0]);
    //ASDraw.gradientRectWithAlphaRect(mc, itemHiliteRect, ASDraw.ANGLE_LEFT_TO_RIGHT,
    //  [0x494D56, 0x494D56, 0x494D56, 0x494D56], [265,373,413,430], [40,40,0,0]);
  }

  public function drawListSelectionWithRectInView(rect:NSRect, aView:NSView):Void {
    ASDraw.gradientRectWithAlphaRect(aView.mcBounds(),
      rect,
      ASDraw.ANGLE_LEFT_TO_RIGHT,
      [0x494D56, 0x494D56, 0x494D56, 0x494D56],
      [265,373,413,430],
      [40,40,0,0]);
  }

  //******************************************************
  //*                    Drawers
  //******************************************************

  /**
   * <p>Draws the drawer.</p>
   */
  public function drawDrawerWithRectInView(aRect:NSRect, view:NSView):Void {
    var mc:MovieClip = view.mcBounds();

    aRect = aRect.insetRect(1, 1);
    ASDraw.solidCornerRectWithRect(mc, aRect, 5, 0xFFFFFF);
    ASDraw.solidCornerRectWithRect(mc, aRect.insetRect(5, 5), 3, 0xCDCDCD);
    ASDraw.outlineCornerRectWithRect(mc, aRect, 5, 0x000000);
  }

  /**
   * Returns the amount of time (in milliseconds) the drawer takes to open.
   */
  public function drawerOpenDuration():Number {
    return 500;
  }

  /**
   * Returns the amount of time (in milliseconds) the drawer takes to close.
   */
  public function drawerCloseDuration():Number {
    return 500;
  }

  /**
   * Returns the function the drawer uses to ease open.
   */
  public function drawerEaseOpenFunction():Function {
    return ASDraw.easeInOutQuad;
  }

  /**
   * Returns the function the drawer uses to ease close.
   */
  public function drawerEaseCloseFunction():Function {
    return ASDraw.easeInOutQuad;
  }

  /**
   * Returns the width of the drawer's borders.
   */
  function drawerBorderWidth():Number {
    return 10;
  }

  //******************************************************
  //*                   Image Views
  //******************************************************

  /**
   * Draws an image frame in the view <code>view</code>, bounded by the
   * rectangle <code>rect</code> with a frame style of <code>style</code>.
   */
  public function drawImageFrameWithRectInViewStyle(rect:NSRect, view:NSView,
      style:NSImageFrameStyle):Void {

    var mc:MovieClip = view.mcBounds();
    switch (style)
    {
      case NSImageFrameStyle.NSImageFrameNone:
        // do nothing
        break;
      case NSImageFrameStyle.NSImageFramePhoto:
        ASDraw.drawRect(mc, rect.origin.x, rect.origin.y,
          rect.size.width, rect.size.height, 0x000000);
        // FIXME Add shadow
        break;
      case NSImageFrameStyle.NSImageFrameButton:
        ASDraw.outlineRectWithRect(mc, rect,
          [0xBEBEBE, 0x7D7D7D, 0x7D7D7D, 0xBEBEBE]);
        break;
      case NSImageFrameStyle.NSImageFrameGrayBezel:
        ASDraw.outlineRectWithRect(mc, rect,
          [0x353535, 0xE7E7E7, 0xE7E7E7, 0x353535]);
        break;
      case NSImageFrameStyle.NSImageFrameGroove:
        // TODO make this look decent.
        //ASDraw.drawRectWithRect(mc, rect, 0xDDDDDD);
        ASDraw.outlineRectWithThickness(mc,
          rect.origin.x+3,
          rect.origin.y+3,
          rect.size.width -3,
          rect.size.height - 3,
          [0xDDDDDD], 2);
        ASDraw.outlineRectWithThickness(mc,
          rect.origin.x,
          rect.origin.y,
          rect.size.width-3,
          rect.size.height-3,
          [0x333333], 2);
        break;
    }
  }
  //******************************************************
  //*                  ToolTips
  //******************************************************

  public function drawToolTipWithRectInView(rect:NSRect, view:NSView):Void {
    var mc:MovieClip = view.mcBounds();

    ASDraw.drawRectWithRect(mc, rect, 0x000000, 100);
    ASDraw.fillRectWithRect(mc, rect.insetRect(1, 1), 0xFFFFE1, 80);
  }

  public function toolTipStyleCss():String {
    return
    "tipText {" +
    "  font-family: Verdana, Arial;" +
    "  font-size: 10;" +
    "}";
  }

  public function toolTipInitialDelay():Number {
    return 0.5;
  }

  public function toolTipAutoPopDelay():Number {
    return 5;
  }

  public function toolTipSwf():String {
    return null;
  }

  //******************************************************
  //*                    Sliders
  //******************************************************

  public function sliderTrackWidth():Number {
    return 10;
  }

  public function sliderTickLength():Number {
    return 10;
  }

  public function drawSliderTrackWithRectInView(aRect:NSRect, view:NSView):Void {
    var vert:Boolean = aRect.size.height >= aRect.size.width;
    var mc:MovieClip = view.mcBounds();
    var c1:NSColor = colorWithName(ASThemeColorNames.ASSliderBarColor);
    var c2:NSColor = c1.adjustColorBrightnessByFactor(1.3);

    ASDraw.gradientRectWithRect(mc, aRect, vert ? 0 : 90, [c1.value, c2.value],
      [0, 255]);
    ASDraw.drawRectWithRect(mc, aRect, 0x333333, 100);
  }

  public function drawCircularSliderWithRectInView(aRect:NSRect, view:NSView)
      :Void {
    var mc:MovieClip = view.mcBounds();
    aRect = aRect.insetRect(1, 1);

    ASDraw.gradientEllipseWithRect(mc, aRect,
      [0xEDEDED, 0xEDEDED],
      [0, 255]);

    var highlightRect:NSRect = new NSRect(aRect.origin.x + aRect.size.width / 4,
      aRect.origin.y + 3, aRect.size.width / 2, aRect.height() / 3);
    ASDraw.gradientEllipseWithRect(mc, highlightRect,
      [0xFBFBFB, 0xFBFBFB],
      [0, 255]);

    mc.lineStyle(1, 0x000000, 100);
    ASDraw.drawEllipseWithRect(mc, aRect);
  }

  public function drawLinearSliderTickWithRectInViewVertical(aRect:NSRect,
      view:NSView, vertical:Boolean):Void {
    var mc:MovieClip = view.mcBounds();

    if (vertical) {
      aRect = aRect.insetRect(0, (aRect.size.height - 2) / 2);
    } else {
      aRect = aRect.insetRect((aRect.size.width - 2) / 2, 0);
    }

    ASDraw.drawRectWithRect(mc, aRect, 0xDDDDDD);
    ASDraw.drawRectWithRect(mc,
      new NSRect(aRect.origin.x+1, aRect.origin.y+1, aRect.size.width, aRect.size.height),
      0xDDDDDD);
    ASDraw.drawRectWithRect(mc,
      new NSRect(aRect.origin.x, aRect.origin.y, aRect.size.width-1, aRect.size.height-1),
      0x333333);
  }

  public function drawCircularSliderTickWithRectLengthAngleInView(rect:NSRect,
      length:Number, angle:Number, view:NSView):Void {

  }

  //******************************************************
  //*                    Windows
  //******************************************************

  public function drawResizingWindowWithRectInView(aRect:NSRect, view:NSView):Void {
    var mc:MovieClip = view.mcBounds();
    var x:Number = aRect.origin.x;
    var y:Number = aRect.origin.y;
    var w:Number = aRect.size.width;
    var h:Number = aRect.size.height;

    with (mc) {
      beginFill(0xDDDDDD, 40);
      lineStyle(1, 0x888888, 100);
      moveTo(x, y);
      lineTo(x + w, y);
      lineTo(x + w, y + h);
      lineTo(x, y + h);
      lineTo(x, y);
      endFill();
    }
  }

  public function drawWindowTitleBarWithRectInViewIsKey(aRect:NSRect,
      view:NSView, isKey:Boolean):Void {

    var fillColors:Array = isKey ? [0xFFFFFF, 0xDEDEDE, 0xC6C6C6] : [0xFFFFFF, 0xDEDEDE, 0xFFFFFF];
    var fillAlpha:Number = 100;
    var cornerRadius:Number = 4;
    var x:Number = aRect.origin.x;
    var y:Number = aRect.origin.y;
    var width:Number = aRect.size.width;
    var height:Number = aRect.size.height;

    with (view.mcBounds()) {
      lineStyle(1.5, 0x8E8E8E, 100);
      beginGradientFill("linear", fillColors, [100,100,100], [0, 50, 255],
        {matrixType:"box", x:x,y:y,w:width,h:height,r:(.5*Math.PI)});
      moveTo(x+cornerRadius, y);
      lineTo(x+width-cornerRadius, y);
      lineTo(x+width, y+cornerRadius); //Angle
      lineTo(x+width, y+height);
      lineStyle(1.5, 0x6E6E6E, 100);
      lineTo(x, y+height);
      lineStyle(1.5, 0x8E8E8E, 100);
      lineTo(x, y+cornerRadius);
      lineTo(x+cornerRadius, y); //Angle
      endFill();
    }
  }

  //******************************************************
  //*                   Buttons
  //******************************************************

  /**
   * Draws a button border of the provided type and style
   */
  function drawButtonCellBorderInRectOfView(cell:NSButtonCell, rect:NSRect, view:NSView):Void {
    var mask:Number;
    var highlighted:Boolean = cell.isHighlighted();
    if (highlighted) {
      mask = cell.highlightsBy();
      if (cell.state() == 1) {
        mask &= ~cell.showsStateBy();
      }
    } else if (cell.state() == 1) {
      mask = cell.showsStateBy();
    } else {
      mask = NSCell.NSNoCellMask;
    }

    if (cell.isBezeled()) {
      switch(cell.bezelStyle()) {
        case NSBezelStyle.NSRoundedBezelStyle:
        case NSBezelStyle.NSThickSquareBezelStyle:
        case NSBezelStyle.NSThickerSquareBezelStyle:
        case NSBezelStyle.NSDisclosureBezelStyle:
        case NSBezelStyle.NSCircularBezelStyle:
        case NSBezelStyle.NSHelpButtonBezelStyle:
        // ^-- above not implemented --^
        //     fall through to default
        case NSBezelStyle.NSRegularSquareBezelStyle:
          if (cell.isEnabled()) {
            if (highlighted || (mask & (NSCell.NSChangeGrayCellMask | NSCell.NSChangeBackgroundCellMask))) {
              drawButtonDown(view.mcBounds(), rect);
            } else {
              drawButtonUp(view.mcBounds(), rect);
            }
          } else {
            if (highlighted || (mask & (NSCell.NSChangeGrayCellMask | NSCell.NSChangeBackgroundCellMask))) {
              drawButtonDownDisabled(view.mcBounds(), rect);
            } else {
              drawButtonUpDisabled(view.mcBounds(), rect);
            }
          }
        break;
        case NSBezelStyle.NSShadowlessSquareBezelStyle:
          if (cell.isEnabled()) {
            if (highlighted || (mask & (NSCell.NSChangeGrayCellMask | NSCell.NSChangeBackgroundCellMask))) {
              drawButtonDownWithoutBorder(view.mcBounds(), rect);
            } else {
              drawButtonUpWithoutBorder(view.mcBounds(), rect);
            }
          } else {
            if (highlighted || (mask & (NSCell.NSChangeGrayCellMask | NSCell.NSChangeBackgroundCellMask))) {
              drawButtonDownDisabledWithoutBorder(view.mcBounds(), rect);
            } else {
              drawButtonUpDisabledWithoutBorder(view.mcBounds(), rect);
            }
          }
        break;
      }
    } else if (cell.isBordered()) {
      if (cell.isEnabled()) {
        drawBorderButtonUp(view.mcBounds(), rect);
      } else {
        drawBorderButtonDown(view.mcBounds(), rect);
      }
    }
  }

  /**
   * Draws a button interior of the provided color, type and style
   */
  function drawButtonCellInteriorInRectOfView(cell:NSButtonCell, rect:NSRect, view:NSView):Void {
    //enabled:Boolean, backgroundColor:NSColor, borderType:NSBorderType, bezelStyle:NSBezelStyle
  }



  //******************************************************
  //*                 First Responder
  //******************************************************

  public function firstResponderColor():NSColor {
    return m_firstResponderColor;
  }

  public function drawFirstResponderWithRectInView(rect:NSRect, view:NSView):Void {
    drawFirstResponderWithRectInClip(rect, view.mcBounds());
  }

  public function drawFirstResponderWithRectInClip(rect:NSRect, mc:MovieClip):Void {
    var x:Number = rect.origin.x+1;
    var y:Number = rect.origin.y+1;
    var width:Number = rect.size.width-3;
    var height:Number = rect.size.height-3;
    var color:Number = firstResponderColor().value;

    mc.lineStyle(3, color, 40);
    mc.moveTo(x, y);
    mc.lineTo(x+width, y);
    mc.lineTo(x+width, y+height);
    mc.lineTo(x, y+height);
    mc.lineTo(x, y);
  }

  //******************************************************
  //*                    Textfields
  //******************************************************

  public function drawTextFieldWithRectInView(rect:NSRect, view:NSView):Void {
    drawTextfield(view.mcBounds(), rect);
  }

  //******************************************************
  //*                   Scrollers
  //******************************************************

  public function drawScrollerSlotWithRectInView(rect:NSRect, view:NSView):Void {
    drawScrollerSlot(view.mcBounds(), rect);
  }

  public function drawScrollerWithRectInClip(rect:NSRect, clip:MovieClip):Void {
    drawScroller(clip, rect);
  }

  public function scrollerWidth():Number {
    return 20;
  }

  public function scrollerButtonWidth():Number {
    return 18;
  }

  //******************************************************
  //*                   Scrollviews
  //******************************************************

  public function drawScrollViewBorderInRectWithViewBorderType(rect:NSRect,
      view:NSView, border:NSBorderType):Void {
    drawBoxBorderWithRectInViewExcludeRectBorderType(rect, view, null, border);
  }

  //******************************************************
  //*                      Box
  //******************************************************

  public function drawBoxBorderWithRectInViewExcludeRectBorderType(rect:NSRect,
      view:NSView, excludeRect:NSRect, border:NSBorderType):Void {
  var mc:MovieClip = view.mcBounds();

    switch(border) {
      case NSBorderType.NSNoBorder: // No border
        break;

      case NSBorderType.NSLineBorder:
        if (excludeRect != undefined) {
          ASDraw.outlineRectWithRectExcludingRect(mc, rect, excludeRect, [0]);
        } else {
          ASDraw.drawRectWithRect(mc, rect, 0x000000);
        }
        break;

      case NSBorderType.NSBezelBorder:
        //! FIXME Implement this
        if (excludeRect != undefined) {
          ASDraw.outlineRectWithRectExcludingRect(mc, rect, excludeRect, [0]);
        } else {
          ASDraw.drawRectWithRect(mc, rect, 0x000000);
        }
        break;

      case NSBorderType.NSGrooveBorder:
        if (excludeRect != undefined) {
          ASDraw.outlineRectWithRectExcludingRect(mc, rect, excludeRect,
            [0xDDDDDD]);
          ASDraw.outlineRectWithRectExcludingRect(mc,
            new NSRect(
              rect.origin.x+1,
              rect.origin.y+1,
              rect.size.width,
              rect.size.height),
            excludeRect, [0xDDDDDD]);
          ASDraw.outlineRectWithRectExcludingRect(mc,
            new NSRect(
              rect.origin.x,
              rect.origin.y,
              rect.size.width-1,
              rect.size.height-1),
            excludeRect, [0x333333]);
        } else {
          ASDraw.drawRectWithRect(mc, rect, 0xDDDDDD);
          ASDraw.drawRectWithRect(mc,
            new NSRect(
              rect.origin.x+1,
              rect.origin.y+1,
              rect.size.width,
              rect.size.height),
            0xDDDDDD);
          ASDraw.drawRectWithRect(mc,
            new NSRect(
              rect.origin.x,
              rect.origin.y,
              rect.size.width-1,
              rect.size.height-1),
            0x333333);
        }
        break;
      }
  }
  //******************************************************
  //*                    Tabviews
  //******************************************************

  public function tabHeight():Number {
    return 20;
  }

  public function drawTabViewItemInRectWithView(item:NSTabViewItem, rect:NSRect,
      view:NSView):Void {
    var fillColors:Array;
    var fillAlpha:Number = 100;
    var cornerRadius:Number = 3;

    //
    // Calculate colors
    //
    var baseColor:NSColor = item.tabState() == NSTabState.NSBackgroundTab ?
      item.color().adjustColorBrightnessByFactor(0.7) : item.color();
    fillColors = [baseColor.adjustColorBrightnessByFactor(1.2).value,
      baseColor.value];

    //
    // Draw tab item
    //
    var mc:MovieClip = view.mcBounds();
    var x:Number = rect.origin.x;
    var y:Number = rect.origin.y;
    var width:Number = rect.size.width;
    var height:Number = rect.size.height;
    with (mc) {
      lineStyle(1.5, 0x8E8E8E, 100);
      beginGradientFill("linear", fillColors, [100,100], [0, 0xff],
                        {matrixType:"box", x:x,y:y,w:width,h:height,r:(.5*Math.PI)});
      moveTo(x+cornerRadius, y);
      lineTo(x+width-cornerRadius, y);
      lineTo(x+width, y+cornerRadius); //Angle
      lineTo(x+width, y+height);
      lineStyle(undefined, 0, 100);
      lineTo(x, y+height);
      lineStyle(1.5, 0x8E8E8E, 100);
      lineTo(x, y+cornerRadius);
      lineTo(x+cornerRadius, y); //Angle
      endFill();
    }
  }

  //******************************************************
  //*                   Tableviews
  //******************************************************

  /**
   * @see org.actionstep.ASThemeProtocol#drawTableHeaderWithRectInViewHighlighted
   */
  public function drawTableHeaderWithRectInViewHighlighted(rect:NSRect,
      view:NSView, highlighted:Boolean):Void {
    var mc:MovieClip = view.mcBounds();
    var x:Number = rect.origin.x;
    var y:Number = rect.origin.y;
    var w:Number = rect.size.width;
    var h:Number = rect.size.height;
    var c1:Number;
    var c2:Number;
    var c3:Number;

    ASDraw.drawLine(mc, x + w, y, x + w, y + h, 0xC0C0C0);
    ASDraw.drawLine(mc, x, y + h, x + w, y + h, 0x666666);

    if (highlighted) {
      c1 = 0xD0E0F4;
      c2 = 0x6AAAEB;
      c3 = 0xB8FAFF;
    } else {
      c1 = 0xFFFFFF;
      c2 = 0xE8E8E8;
      c3 = 0xFFFFFF;
    }

    ASDraw.gradientRectWithRect(mc, new NSRect(x + 1, y + 1, w - 2, h - 2),
      90, [c1, c2, c3], [0, 50, 100]);
  }

  //******************************************************
  //*                 Status bars
  //******************************************************

  public function statusBarThickness():Number {
    return 22;
  }

  public function drawStatusBarBackgroundInRectWithViewHighlight(rect:NSRect,
      aView:NSView, highlight:Boolean):Void {
    var mc:MovieClip = aView.mcBounds();
    var colors:Array;
    var ratios:Array;

    if (highlight) {
      colors = [0x3973BD, 0x619BDF];
    } else {
      colors = [0xFFFFFF, 0xFFFFFF];
    }

    ratios = [0, 255];

    ASDraw.gradientRectWithRect(mc, rect, 90, colors, ratios);
  }

  //******************************************************
  //*               Progress Indicators
  //******************************************************

  public function progressIndicatorSizeForSize(size:NSControlSize):NSSize {
    var w:Number;
    var h:Number;

    switch(size) {
      case NSControlSize.NSMiniControlSize:
        w = 60;
        h = 8;
        break;

      case NSControlSize.NSRegularControlSize:
        w = 120;
        h = NSProgressIndicator.NSProgressIndicatorPreferredThickness;
        break;

      case NSControlSize.NSSmallControlSize:
        w = 90;
        h = NSProgressIndicator.NSProgressIndicatorPreferredSmallThickness;
        break;

      default:
        return null;
    }

    return new NSSize(w, h);
  }

	//because of the way the animation layer moves for the indeterminate bars, the border needs its own
	//clip to draw above everything else. otherwise the animation obscures the border.
  public function drawProgressBarBorderInRectWithClipBezeledProgress(
      rect:NSRect, mc:MovieClip, bezeled:Boolean, progress:Number):Void {
    ASDraw.gradientRectWithAlphaRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM, [0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF],
      																															       [       0,       1,       4,       5,       7,       9,      12,      16],
      																															       [       0,      30,      50,      30,      10,      40,      30,      20]);
	  if (bezeled) {
		  ASDraw.outlineRectWithRect(mc, rect, [0x333333, 0xAAAAAA]);
		  ASDraw.outlineRectWithRect(mc, rect.insetRect(1,1), [0xAAAAAA,0x333333]);
		}
	}

  public function drawProgressBarInRectWithViewBezeledProgress(
      rect:NSRect, aView:NSView, bezeled:Boolean, progress:Number):Void {
    var mc:MovieClip = aView.mcBounds();

    //
    // Draw background
    //
    ASDraw.fillRectWithRect(mc, rect, 
      colorWithName(ASThemeColorNames.ASProgressBarBackground).value);

    if (progress > 100 || progress <= 0) {
      return;
    }

    //
    // Draw progress bar
    //
    var pbColor1:NSColor = colorWithName(ASThemeColorNames.ASProgressBar);
    var pbColor2:NSColor = pbColor1.adjustColorBrightnessByFactor(0.6);
    var alpha:Number = pbColor1.alphaComponent() * 100;
    rect = rect.insetRect(0,1);
    rect = rect.insetRect(0,-1);
    rect.size.width *= progress / 100;
    ASDraw.gradientRectWithAlphaRect(mc, rect, 90, [pbColor1.value, pbColor2.value], [0, 255], [alpha, alpha]);
  }

	//TODO clean this up a bit
  private static var progressBarDeterminatePattern_colors:Array   = [0x336CC2,0x375ABB,0x336CC2];
  private static var progressBarIndeterminatePattern_colors:Array = [0x949494,0x949494,0x3548B0,0x3548B0,0x949494,0x949494,0x3548B0,0x3548B0,0x949494,0x949494];
  private static var progressBarIndeterminatePattern_alphas:Array = [     100,     100,     100,     100,     100,     100,     100,     100,     100,     100];
  public function drawProgressBarPatternInRectWithClipIndeterminate(rect:NSRect, mc:MovieClip, indeterminate:Boolean):Void {
	  if (indeterminate) {
			var angle:Number   = 45;
  		var radians:Number = degreesToRadians(angle);

			//the size of the gradient has to be adjusted for the angle or the tiles won't line up.
		  var gradientHeight:Number = Math.sqrt(rect.size.height*rect.size.height + rect.size.height*rect.size.height);

		  var size:Number = gradientHeight/20;
		  var beginEnd:Number = size;
		  var solid:Number    = size*2;
		  var fade:Number     = size*3;
		  var total:Number    = 0;

		  var ratios:Array = new Array();

			ratios[0] = total;
		  total += beginEnd;
			ratios[1] = total;
		  total += fade;
			ratios[2] = total;
		  total += solid;
			ratios[3] = total;
		  total += fade;
			ratios[4] = total;
		  total += solid;
			ratios[5] = total;
		  total += fade;
			ratios[6] = total;
		  total += solid;
			ratios[7] = total;
		  total += fade;
			ratios[8] = total;
		  total += beginEnd;
			ratios[9] = total;

//	    ASDraw.gradientRectWithRect(mc, rect, angle,
//		                              progressBarIndeterminatePattern_colors,
//		                              ratios);
//TODO move generalized logic for this into ASDraw
      var offset:Number = (rect.size.height - gradientHeight)/2;

      var matrix:Object = ASDraw.getMatrix(new NSRect(rect.origin.x+offset, rect.origin.y+offset, gradientHeight, gradientHeight), angle);
      var actualRatios:Array = ASDraw.getActualRatios(ratios);

      mc.lineStyle(undefined, 0, 100);
      ASDraw.beginLinearGradientFill(mc,progressBarIndeterminatePattern_colors,progressBarIndeterminatePattern_alphas,actualRatios,matrix);
      mc.moveTo(rect.origin.x,rect.origin.y);
      mc.lineTo(rect.origin.x+rect.size.width, rect.origin.y);
      mc.lineTo(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
      mc.lineTo(rect.origin.x, rect.origin.y+rect.size.height);
      mc.lineTo(rect.origin.x, rect.origin.y);
      mc.endFill();


		}
		else {
		  var size:Number = rect.size.height/2;
		  var ratios:Array = new Array();
		  for (var i:Number = 0; i<3; i++) {
			  ratios.push(i*size);
		  }
	    ASDraw.gradientRectWithRect(mc, rect, ASDraw.ANGLE_LEFT_TO_RIGHT,
		                              progressBarDeterminatePattern_colors,
		                              ratios);
		}
	}

  public function drawProgressBarSpinnerInRectWithClip(rect:NSRect, mc:MovieClip):Void {
		//the rect SHOULD have a negative origin, such that 0,0 is the center.
		var radius:Number   = Math.floor(rect.size.width/2);
		var segments:Number  = 12;
		var degrees:Number = 360/segments;
		var alphaIncrement:Number = 90/segments;
		var thickness:Number = 2;
		if (radius < 6) {
			thickness = 1;
		}
		for (var i:Number=1; i<=segments; i++) {
			var angle:Number = degreesToRadians(i*degrees);
			var alpha:Number = 10+alphaIncrement*i;
			var x1:Number = Math.cos(angle)*radius/2;
			var y1:Number = Math.sin(angle)*radius/2;
			var x2:Number = Math.cos(angle)*radius;
			var y2:Number = Math.sin(angle)*radius;
		  ASDraw.drawLine(mc, x1, y1, x2, y2, 0x0D0D0D, alpha, thickness);
		}
  }

	private static function degreesToRadians(degrees:Number):Number {
		return degrees*Math.PI/180;
	}

	private static function radiansToDegrees(radians:Number):Number {
		return radians*180/Math.PI;
	}

  //******************************************************
  //*                    Colors
  //******************************************************

  /**
   * @see org.actionstep.ASThemeProtocol#colors
   */
  public function colors():NSColorList {
    return m_colorList;
  }

  /**
   * @see org.actionstep.ASThemeProtocol#colorWithName
   */
  public function colorWithName(name:String):NSColor {
    return NSColor(m_colorList.colorWithKey(name).copyWithZone());
  }

  /**
   * @see org.actionstep.ASThemeProtocol#setColors
   */
  public function setColors(aColorList:NSColorList):Void {
    //! TODO should the current list's name be deregistered?
    m_colorList = aColorList;
  }

  /**
   * Adds the color <code>aColor</code> named <code>name</code> to the theme's
   * color list.
   */
  public function setColorForName(aColor:NSColor, name:String):Void {
    m_colorList.setColorForKey(aColor, name);
  }

  /**
   * Registers the default colors for the theme.
   */
  public function registerDefaultColors():Void {
    m_colorList.setColorForKey(ASColors.whiteColor(), 
      ASThemeColorNames.ASMainMenuBackground);
  	m_colorList.setColorForKey(ASColors.grayColor(),
  	  ASThemeColorNames.ASProgressBar);
  	m_colorList.setColorForKey(ASColors.grayColor(),
  	  ASThemeColorNames.ASSliderBarColor);
  	m_colorList.setColorForKey(
  	  ASColors.lightGrayColor().adjustColorBrightnessByFactor(1.1),
  	  ASThemeColorNames.ASProgressBarBackground);
  	m_colorList.setColorForKey(new NSColor(0xC6C6C6),
  	  ASThemeColorNames.ASTabViewItem);
  	  
  	// NSBrowser
  	m_colorList.setColorForKey(ASColors.blackColor(),
  	  ASThemeColorNames.ASBrowserText);
	m_colorList.setColorForKey(ASColors.whiteColor(),
	  ASThemeColorNames.ASBrowserFirstResponderSelectionText);
	m_colorList.setColorForKey(ASColors.blueColor(),
	  ASThemeColorNames.ASBrowserFirstResponderSelectionBackground);
	m_colorList.setColorForKey(ASColors.whiteColor(), 
	  ASThemeColorNames.ASBrowserSelectionText);
	m_colorList.setColorForKey(ASColors.darkGrayColor(),
	  ASThemeColorNames.ASBrowserSelectionBackground);  
  	m_colorList.setColorForKey(ASColors.whiteColor(),
  	  ASThemeColorNames.ASBrowserMatrixBackground);
  }

  //******************************************************
  //*                   Images
  //******************************************************

  public function registerDefaultImages():Void {
    //! TODO These images really should be constants
    setImage("NSRadioButton", org.actionstep.images.ASRadioButtonRep);
    setImage("NSHighlightedRadioButton", org.actionstep.images.ASHighlightedRadioButtonRep);
    setImage("NSSwitch", org.actionstep.images.ASSwitchRep);
    setImage("NSHighlightedSwitch", org.actionstep.images.ASHighlightedSwitchRep);

    // Scrollers

    setImage("NSScrollerUpArrow", org.actionstep.images.ASScrollerUpArrowRep);
    setImage("NSHighlightedScrollerUpArrow", org.actionstep.images.ASHighlightedScrollerUpArrowRep);
    setImage("NSScrollerDownArrow", org.actionstep.images.ASScrollerDownArrowRep);
    setImage("NSHighlightedScrollerDownArrow", org.actionstep.images.ASHighlightedScrollerDownArrowRep);
    setImage("NSScrollerLeftArrow", org.actionstep.images.ASScrollerLeftArrowRep);
    setImage("NSHighlightedScrollerLeftArrow", org.actionstep.images.ASHighlightedScrollerLeftArrowRep);
    setImage("NSScrollerRightArrow", org.actionstep.images.ASScrollerRightArrowRep);
    setImage("NSHighlightedScrollerRightArrow", org.actionstep.images.ASHighlightedScrollerRightArrowRep);

    // Browser
    
    setImage("NSBrowserBranch", org.actionstep.images.ASScrollerRightArrowRep);
    setImage("NSHighlightedBrowserBranch", org.actionstep.images.ASHighlightedScrollerRightArrowRep);
		
    // Combobox

    setImage("NSComboBoxDownArrow", org.actionstep.images.ASScrollerDownArrowRep);
    setImage("NSHighlightedComboBoxDownArrow", org.actionstep.images.ASHighlightedScrollerDownArrowRep);

    // Stepper

    setImage("NSStepperUpArrow", org.actionstep.images.ASScrollerUpArrowRep);
    setImage("NSHighlightedStepperUpArrow", org.actionstep.images.ASHighlightedScrollerUpArrowRep);
    setImage("NSStepperDownArrow", org.actionstep.images.ASScrollerDownArrowRep);
    setImage("NSHighlightedStepperDownArrow", org.actionstep.images.ASHighlightedScrollerDownArrowRep);


    // Sort indicators

    setImage("NSSortUpIndicator", org.actionstep.images.ASSortUpIndicatorRep);
    setImage("NSSortDownIndicator", org.actionstep.images.ASSortDownIndicatorRep);

    // Cursors

    setImage("NSArrowCursorRep", org.actionstep.images.ASArrowCursorRep);
    setImage("NSResizeUpDownCursorRep", org.actionstep.images.ASResizeUpDownCursorRep);
    setImage("NSResizeUpCursorRep", org.actionstep.images.ASResizeUpCursorRep);
    setImage("NSResizeDownCursorRep", org.actionstep.images.ASResizeDownCursorRep);
    setImage("NSResizeLeftRightCursorRep", org.actionstep.images.ASResizeLeftRightCursorRep);
    setImage("NSResizeRightCursorRep", org.actionstep.images.ASResizeRightCursorRep);
    setImage("NSResizeLeftCursorRep", org.actionstep.images.ASResizeLeftCursorRep);
    setImage("NSResizeDiagonalDownCursorRep", org.actionstep.images.ASResizeDiagonalDownCursorRep);
    setImage("NSResizeDiagonalUpCursorRep", org.actionstep.images.ASResizeDiagonalUpCursorRep);
    setImage("NSCrosshairCursorRep", org.actionstep.images.ASCrosshairCursorRep);

    // Window icons

    setImage("NSWindowCloseIconRep", org.actionstep.images.ASWindowCloseIconRep);
    setImage("NSWindowMiniaturizeIconRep", org.actionstep.images.ASWindowMiniaturizeIconRep);
    setImage("NSWindowRestoreIconRep", org.actionstep.images.ASWindowRestoreIconRep);

    // Progress bar

    setImage("NSProgressBarIndeterminatePatternRep", org.actionstep.images.ASProgressBarIndeterminatePatternRep);
    setImage("NSProgressBarDeterminatePatternRep",   org.actionstep.images.ASProgressBarDeterminatePatternRep);
    setImage("NSProgressBarSpinnerRep",              org.actionstep.images.ASProgressBarSpinnerRep);

    // Slider

    setImage("NSSliderRoundThumbRep", org.actionstep.images.ASSliderRoundThumbRep);
    setImage("NSSliderLinearVerticalThumbRep", org.actionstep.images.ASSliderLinearVerticalThumbRep);
    setImage("NSSliderLinearHorizontalThumbRep", org.actionstep.images.ASSliderLinearHorizontalThumbRep);
    setImage("NSSliderCircularThumbRep", org.actionstep.images.ASSliderCircularThumbRep);

    // Menu Items

    setImage("NSMenuItemOnState", org.actionstep.images.ASMenuItemOnStateRep);
    setImage("NSMenuItemOffState", org.actionstep.images.ASMenuItemOffStateRep);
    setImage("NSMenuItemMixedState", org.actionstep.images.ASMenuItemMixedStateRep);
    setImage("NSMenuArrow", org.actionstep.images.ASMenuArrowRep);
    setImage("NSHighlightedMenuArrow", org.actionstep.images.ASHighlightedMenuArrowRep);

    // Modifier glyphs

    setImage("NSGlyphControlRep", org.actionstep.images.glyphs.ASControlRep);
    setImage("NSGlyphAlternateRep", org.actionstep.images.glyphs.ASAlternateRep);
  }

  public function setImage(name:String, klass:Function):Void {
    var image:NSImage = (new NSImage()).init();
    image.setName(name);
    image.addRepresentation(new klass());
  }

  /**
   * @see org.actionstep.NSObject#description
   */
  public function description():String
  {
    return "ASTheme()";
  }

  //******************************************************
  //*               Private Methods
  //******************************************************

  private function drawBorderButtonUp(mc:MovieClip, rect:NSRect):Void {
    var x:Number = rect.origin.x;
    var y:Number = rect.origin.y;
    var width:Number = rect.size.width-1;
    var height:Number = rect.size.height-1;
    ASDraw.fillRect(mc, x, y, width, height, 0xC7CAD1);
    ASDraw.drawRect(mc, x, y, width, height, 0x000000);
  }

  private function drawBorderButtonDown(mc:MovieClip, rect:NSRect):Void {
    var x:Number = rect.origin.x;
    var y:Number = rect.origin.y;
    var width:Number = rect.size.width-1;
    var height:Number = rect.size.height-1;
    ASDraw.fillRect(mc, x, y, width, height, 0xB1B5BC);
    ASDraw.drawRect(mc, x, y, width, height, 0x000000);
  }

	///////////////////////////////
	// BUTTON DRAW FUNCTIONS

  private static var drawButtonUp_outlineColors:Array = [0x82858E, 0xD3D6DB];
  private static var drawButtonUp_inlineColors:Array  = [0xDFE2E9, 0x858992];
  private static var drawButtonUp_colors:Array = [0xEEF2F5, 0xC7CAD1, 0xC7CAD1, 0x858992];
  private static var drawButtonUp_ratios:Array = [       1,       5,       23,       26];
  private function drawButtonUp(mc:MovieClip, rect:NSRect)
  {
    drawButtonUpWithoutBorder(mc, rect.insetRect(1,1));
    ASDraw.outlineRectWithRect( mc, rect, drawButtonUp_outlineColors);
  }

  private function drawButtonUpWithoutBorder(mc:MovieClip, rect:NSRect)
  {
    ASDraw.gradientRectWithRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM, drawButtonUp_colors, drawButtonUp_ratios);
    ASDraw.outlineRectWithRect( mc, rect, drawButtonUp_inlineColors);
  }

  private static var drawButtonDown_outlineColors:Array = [0x82858E, 0xECEDF0];
  private static var drawButtonDown_inlineColors:Array  = [0x696F79, 0xD4D6DB];
  private static var drawButtonDown_colors:Array = [0x696F79, 0xB1B5BC, 0xB1B5BC, 0xD9DBDF, 0xC9CDD2];
  private static var drawButtonDown_ratios:Array = [       1,        5,       23,       25,       26];
  private function drawButtonDown(mc:MovieClip, rect:NSRect)
  {
    drawButtonDownWithoutBorder(mc, rect.insetRect(1,1));
    ASDraw.outlineRectWithRect( mc, rect, drawButtonDown_outlineColors);
  }

  private static var drawButtonUpDisabled_outlineAlphas:Array = [      50,      50];
  private static var drawButtonUpDisabled_inlineAlphas:Array  = [      50,      50];
  private static var drawButtonUpDisabled_alphas:Array        = [      50,      50,       50,       50];
  public function drawButtonUpDisabled(mc:MovieClip, rect:NSRect)
  {
    drawButtonUpDisabledWithoutBorder(mc, rect.insetRect(1,1));
    ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonUp_outlineColors, drawButtonUpDisabled_outlineAlphas);
  }

  public function drawButtonUpDisabledWithoutBorder(mc:MovieClip, rect:NSRect)
  {
    ASDraw.gradientRectWithAlphaRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM,
                                     drawButtonUp_colors, drawButtonUp_ratios, drawButtonUpDisabled_alphas);
    ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonUp_inlineColors, drawButtonUpDisabled_inlineAlphas);
  }

  private function drawButtonDownWithoutBorder(mc:MovieClip, rect:NSRect)
  {
    ASDraw.gradientRectWithRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM, drawButtonDown_colors, drawButtonDown_ratios);
    ASDraw.outlineRectWithRect( mc, rect, drawButtonDown_inlineColors);
  }

  private static var drawButtonDownDisabled_outlineAlphas:Array = [      50,      50];
  private static var drawButtonDownDisabled_inlineAlphas:Array  = [      50,      50];
  private static var drawButtonDownDisabled_alphas:Array        = [      50,      50,       50,       50,       50];
  public function drawButtonDownDisabled(mc:MovieClip, rect:NSRect)
  {
    drawButtonDownDisabledWithoutBorder(mc, rect.insetRect(1,1));
    ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonDown_outlineColors, drawButtonDownDisabled_outlineAlphas);
  }

  public function drawButtonDownDisabledWithoutBorder(mc:MovieClip, rect:NSRect)
  {
    ASDraw.gradientRectWithAlphaRect(mc, rect, ASDraw.ANGLE_TOP_TO_BOTTOM,
                                     drawButtonDown_colors, drawButtonDown_ratios, drawButtonDownDisabled_alphas);
    ASDraw.outlineRectWithAlphaRect( mc, rect, drawButtonDown_inlineColors, drawButtonDownDisabled_inlineAlphas);
  }

	// END BUTTON DRAW FUNCTIONS
	///////////////////////////////

	///////////////////////////////
	// TEXTFIELD DRAW FUNCTIONS
  private static var drawTextfield_outlineColors:Array = [0x4B4F57, 0xDEE1E6];
  private static var drawTextfield_colors:Array = [0x80848F, 0xAFB4BA, 0xCACDD2];
  private static var drawTextfield_ratios:Array = [       0,       6,        24];
  private static var drawTextfieldShadow_colors:Array = [0x767A85, 0xB6BBC1];
  private static var drawTextfieldShadow_alphas:Array = [     100,        0];
  private static var drawTextfieldShadow_ratios:Array = [       0,        5];
  private function drawTextfield(mc:MovieClip, rect:NSRect)
  {
    var insetRect:NSRect = rect.insetRect(1,1);
    ASDraw.fillRectWithRect(        mc, rect, 0xCACDD2);
    //ASDraw.gradientRectWithRect(     mc, rect, ANGLE_TOP_TO_BOTTOM, drawTextfield_colors, drawTextfield_ratios);
    ASDraw.gradientRectWithRect(     mc, new NSRect(rect.origin.x, rect.origin.y, rect.size.width, 25), ASDraw.ANGLE_TOP_TO_BOTTOM,
                                            drawTextfield_colors, drawTextfield_ratios);
    ASDraw.gradientRectWithAlphaRect(mc, new NSRect(rect.origin.x, rect.origin.y, 5, rect.size.height), 30,
                                            drawTextfieldShadow_colors, drawTextfieldShadow_ratios, drawTextfieldShadow_alphas);
    ASDraw.outlineRectWithRect(      mc, rect, drawTextfield_outlineColors);
  }
  // END TEXTFIELD DRAW FUNCTIONS
  ///////////////////////////////

  ///////////////////////////////
  // SCROLLER DRAW FUNCTIONS
  private static var drawScrollerSlot_outlineColors:Array = [0x4B4F57, 0xDEE1E6];
  private static var drawScrollerSlot_colors:Array = [0x80848F, 0xAFB4BA, 0xCACDD2];
  private static var drawScrollerSlot_ratios:Array = [       0,       6,        24];
  private static var drawScrollerSlotShadow_colors:Array = [0x767A85, 0xB6BBC1];
  private static var drawScrollerSlotShadow_alphas:Array = [     100,        0];
  private static var drawScrollerSlotShadow_ratios:Array = [       0,        5];
  private function drawScrollerSlot(mc:MovieClip, rect:NSRect) {
    var insetRect:NSRect = rect.insetRect(1,1);
    ASDraw.fillRectWithRect(        mc, rect, 0xCACDD2);
    //ASDraw.gradientRectWithRect(     mc, rect, ANGLE_TOP_TO_BOTTOM, drawTextfield_colors, drawTextfield_ratios);
    ASDraw.gradientRectWithAlphaRect(mc, new NSRect(rect.origin.x, rect.origin.y, rect.size.width, 5), ASDraw.ANGLE_TOP_TO_BOTTOM,
                                            drawScrollerSlotShadow_colors, drawScrollerSlotShadow_ratios, drawScrollerSlotShadow_alphas);
    ASDraw.gradientRectWithAlphaRect(mc, new NSRect(rect.origin.x, rect.origin.y, 5, rect.size.height), 30,
                                            drawScrollerSlotShadow_colors, drawScrollerSlotShadow_ratios, drawScrollerSlotShadow_alphas);
    ASDraw.outlineRectWithRect(      mc, rect, drawScrollerSlot_outlineColors);
  }

  private static var drawScroller_outlineColors:Array = [0xDEE1E6, 0x4B4F57];
  private function drawScroller(mc:MovieClip, rect:NSRect) {
    ASDraw.fillRectWithRect(        mc, rect, 0xCACDD2);
    ASDraw.outlineRectWithRect(      mc, rect, drawScroller_outlineColors);
    if (rect.size.width > rect.size.height) {
      var x1:Number = rect.origin.x + rect.size.width/2-1;
      var x2:Number = x1 + 6;
      x1 -= 6;
      var y1:Number = rect.origin.y + 3;
      var y2:Number = rect.origin.y + rect.size.height - 4;
      while (x1 < x2) {
        mc.lineStyle(1, 0xDEE1E6, 50);
        mc.moveTo(x1, y1);
        mc.lineTo(x1, y2);
        mc.lineStyle(1, 0x4B4F57, 50);
        mc.moveTo(x1+1, y2);
        mc.lineTo(x1+1, y1);
        x1+=2;
      }
    } else {
   	  var y1:Number = rect.origin.y + rect.size.height/2-1;
      var y2:Number = y1 + 6;
      y1 -= 6;
      var x1:Number = rect.origin.x + 3;
      var x2:Number = rect.origin.x + rect.size.width - 4;
      while (y1 < y2) {
        mc.lineStyle(1, 0xDEE1E6, 50);
        mc.moveTo(x1, y1);
        mc.lineTo(x2, y1);
        mc.lineStyle(1, 0x4B4F57, 50);
        mc.moveTo(x2, y1+1);
        mc.lineTo(x1, y1+1);
        y1+=2;
      }
    }
  }

  // END TEXTFIELD DRAW FUNCTIONS
  ///////////////////////////////



  //******************************************************
  //*			   Public Static Properties				   *
  //******************************************************

  /**
   * Returns the current theme.
   */
  public static function current():ASThemeProtocol {
    if (g_current == undefined) {
      setCurrent(new ASTheme());
    }
    return g_current;
  }

  /**
   * Sets the current theme to <code>value</code>.
   *
   * This method results in an <code>ASThemeDidChangeNotification</code> being
   * posted to the default notification center.
   */
  public static function setCurrent(value:ASThemeProtocol) {
    var old:ASThemeProtocol = g_current;

    if (g_current != undefined) {
      g_current.setActive(false);
    }
    g_current = value;
    g_current.setActive(true);

    //
    // Build and post notification
    //
    var userInfo:NSDictionary = NSDictionary.dictionaryWithObjectForKey(
      g_current, "ASNewTheme");
    if (null != old) {
      userInfo.setObjectForKey(old, "ASOldTheme");
    }

    NSNotificationCenter.defaultCenter()
      .postNotificationWithNameObjectUserInfo(
        ASThemeDidChangeNotification,
        ASTheme,
        userInfo);
  }
}
