/* See LICENSE for copyright and terms of use */

import org.actionstep.ASDraw;
import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSColor;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSFont;
import org.actionstep.NSMenu;
import org.actionstep.NSMenuItem;
import org.actionstep.menu.NSMenuItemCell;
import org.actionstep.NSNotification;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSPoint;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSView;
import org.actionstep.NSWindow;
import org.actionstep.ASColors;

/**
 * The visual representation of an <code>NSMenu</code>.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.menu.NSMenuView extends NSView {
	private static var g_ht:Number;

	//******************************************************
	//*                   Boundaries
	//******************************************************

	/**
	 * Defines the bounds which will constrain the entire menu system. The default dimensions
	 * are the <code>Stage</code> dimensions.
	 *
	 * <code>NSSize</code> instead of <code>NSRect</code> is used, since co-ordinates are
	 * calculated relative to the root menu view.
	 *
	 * Please note that <code>Stage</code> dimensions will not be updated if the movie is re-sized.
	 */
	private static var g_bounds:NSSize = new NSSize(Stage.width, Stage.height);

	/**
	 * Returns a reference to the <code>bounds</code>, instead of a copy.
	 */
	public static function bounds():NSSize {
		return g_bounds;
	}

	/**
	 * Sets the <code>bounds</code>.
	 */
	public static function setBounds(size:NSSize):Void {
		if(size==null) {
			g_bounds = new NSSize(Stage.width, Stage.height);
		} else {
			g_bounds = size;
		}
	}

	private static var g_nc:NSNotificationCenter = NSNotificationCenter.defaultCenter();

	private var m_horizontal:Boolean;
	private var m_needsSizing:Boolean;

	private var m_highlightedItemIndex:Number;
	private var m_horizontalEdgePad:Number;
	private var m_stateImageOffset:Number;
	private var m_stateImageWidth:Number;

	private var m_imageOffset:Number;
	private var m_imageWidth:Number;
	private var m_titleWidth:Number;
	private var m_titleAndKeyEqOffset:Number;
	private var m_titleAndKeyEqWidth:Number;

	private var m_keyEqImgOffset:Number;
	private var m_keyEqImgWidth:Number;

	private var m_arrowOffset:Number;

	private var m_leftBorderOffset:Number;

	private var m_menu:NSMenu;
	private var m_font:NSFont;
	private var m_itemsLink:NSArray;
	private var m_itemCells:NSArray;
	private var m_cellSize:NSSize;

	private var m_trackingData:Object;
	private var m_app:NSApplication;

	private static function addLeftBorderOffsetToRect(aRect:NSRect):Void {
		aRect.origin.x--;
		aRect.size.width++;
	}

	/*
	 * Class methods.
	 */
	public static function menuBarHeight():Number {
		if(g_ht==null) {
			g_ht = 0;
		}
		if (g_ht == 0) {
			var font:NSFont = NSFont.menuFontOfSize(0);

			/* Should make up 23 for the default font */
			g_ht = font.getTextExtent("NSMV").height + 8;
			if (g_ht < 23) {
				g_ht = 23;
			}
		}

		return g_ht;
	}

	/*
	 * NSView overrides
	 */
	public function acceptsFirstMouse(theEvent:NSEvent):Boolean {
		return true;
	}

	public function acceptsFirstResponder(theEvent:NSEvent):Boolean {
		return true;
	}

	// We do not want to popup menus in this menu.
	// overrides NSView
	public function menuForEvent(theEvent:NSEvent):NSMenu {
		return null;
	}

	/*
	 * Init methods.
	 */
	public function initWithFrame(aFrame:NSRect):NSMenuView {
		super.initWithFrame(aFrame);

		setFont(NSFont.menuFontOfSize(15));

		m_app = NSApplication.sharedApplication();
		m_highlightedItemIndex = -1;
		m_horizontalEdgePad = 4.;

		/* Set the necessary offset for the menuView. That is, how many pixels
		 * do we need for our left side border line.
		 */
	   m_leftBorderOffset = 1;

		// Create an array to store our menu item cells.
		m_itemCells = new NSArray();

		return this;
	}

	/**
	 * Releases the menu view from memory.
	 */
	public function release():Void {
		// We must remove the menu view from the menu list of observers.
		if (m_menu != null) {
			NSNotificationCenter.defaultCenter().
			removeObserverNameObject
			(this, null, m_menu);
		}

		// Clean the pointer to us stored into the m_itemCells.
		m_itemCells.makeObjectsPerformSelectorWithObject
		("setMenuView", null);

		super.release();
	}

	/*
	 * Getting and Setting Menu View Attributes
	 */
	public function setMenu(menu:NSMenu):Void {
		var nc:NSNotificationCenter = NSNotificationCenter.defaultCenter();

		if (m_menu != null) {
			// Remove this menu view from the old menu list of observers.
			nc.removeObserverNameObject(this, null, m_menu);
		}

		/* menu is retaining us, so we should not be retaining menu.	*/
		m_menu = menu;
		m_itemsLink = m_menu.itemArray();

		if (m_menu != null) {
			// Add this menu view to the menu's list of observers.
			nc.addObserverSelectorNameObject
			(this, "itemChanged", NSMenu.NSMenuDidChangeItemNotification, m_menu);

			nc.addObserverSelectorNameObject
			(this, "itemAdded", NSMenu.NSMenuDidAddItemNotification, m_menu);

			nc.addObserverSelectorNameObject
			(this, "itemRemoved", NSMenu.NSMenuDidRemoveItemNotification, m_menu);
		}

		// Force menu view's layout to be recalculated.
		setNeedsSizing(true);

		update();
	}

	public function menu():NSMenu {
		return m_menu;
	}

	private function setHorizontal(flag:Boolean):Void {
		m_horizontal = flag;
	}

	public function isHorizontal():Boolean {
		return m_horizontal;
	}

	public function setFont(font:NSFont):Void {
		m_font = font;
		if (m_font != null) {
			var r:NSSize = m_font.getTextExtent("Hi");
			/* Should make up 110, 20 for default font */
			m_cellSize = r; //new NSSize(r.width * 10, r.height + 6);

			if (m_cellSize.height < 20) {
				m_cellSize.height = 20;
			}

			setNeedsSizing(true);
		}
	}

	public function font():NSFont {
		return m_font;
	}

	public function setHighlightedItemIndex(index:Number):Void {
		var aCell:NSMenuItemCell;

		if (index == m_highlightedItemIndex) {
			return;
		}

		// Unhighlight old
		if (m_highlightedItemIndex != -1) {
			aCell	= NSMenuItemCell
			(m_itemCells.objectAtIndex(m_highlightedItemIndex));
			aCell.setHighlighted(false);
			setNeedsDisplayForItemAtIndex(m_highlightedItemIndex);
		}

		// Set ivar to new index.
		m_highlightedItemIndex = index;

		// Highlight new
		if (m_highlightedItemIndex != -1) {
			aCell	= NSMenuItemCell
			(m_itemCells.objectAtIndex(m_highlightedItemIndex));
			aCell.setHighlighted(true);
			setNeedsDisplayForItemAtIndex(m_highlightedItemIndex);
		}
	}

	public function highlightedItemIndex():Number {
		return m_highlightedItemIndex;
	}

	public function setMenuItemCellForItemAtIndex
	(cell:NSMenuItemCell, index:Number):Void {
		var anItem:NSMenuItem = NSMenuItem
		(m_itemsLink.objectAtIndex(index));

		m_itemCells.replaceObjectAtIndexWithObject(index, cell);

		cell.setMenuItem(anItem);
		cell.setMenuView(this);

		if (highlightedItemIndex() == index) {
			cell.setHighlighted(true);
		} else {
			cell.setHighlighted(false);
		}
		// Mark the new cell and the menu view as needing resizing.
		cell.setNeedsSizing(true);
		setNeedsSizing(true);
	}

	public function menuItemCellForItemAtIndex(index:Number):NSMenuItemCell {
		return NSMenuItemCell
		(m_itemCells.objectAtIndex(index));
	}

	public function attachedMenuView():NSMenuView {
		return m_menu.attachedMenu().menuRepresentation();
	}

	public function attachedMenu():NSMenu {
		return m_menu.attachedMenu();
	}

	public function isAttached():Boolean {
		return m_menu.isAttached();
	}

	public function setHorizontalEdgePadding(pad:Number):Void {
		m_horizontalEdgePad = pad;
		setNeedsSizing(true);
	}

	public function horizontalEdgePadding():Number {
		return m_horizontalEdgePad;
	}

	/*
	 * Notification Methods
	 */
	public function itemChanged(notification:NSNotification):Void {
		var index:Number = Number(notification.userInfo.objectForKey(
			"NSMenuItemIndex"));
		var aCell:NSMenuItemCell = NSMenuItemCell
		(m_itemCells.objectAtIndex(index));

		// Enabling of the item may have changed
		aCell.setEnabled(aCell.menuItem().isEnabled());

		// Mark the cell associated with the item as needing resizing.
		aCell.setNeedsSizing(true);
		setNeedsDisplayForItemAtIndex(index);

		// Mark the menu view as needing to be resized.
		setNeedsSizing(true);
	}

	public function itemAdded(notification:NSNotification):Void {
		var index:Number = Number(notification.userInfo.objectForKey(
			"NSMenuItemIndex"));
		var anItem:NSMenuItem = NSMenuItem
		(m_itemsLink.objectAtIndex(index));
		var aCell:NSMenuItemCell = (new NSMenuItemCell()).init();
		var wasHighlighted:Number = m_highlightedItemIndex;

		aCell.setMenuItem(anItem);
		aCell.setMenuView(this);
		aCell.setFont(m_font);

		/* Unlight the previous highlighted cell if the index of the highlighted
		 * cell will be ruined up by the insertion of the new cell.	*/
		if (wasHighlighted >= index) {
			setHighlightedItemIndex(-1);
		}

		m_itemCells.insertObjectAtIndex(aCell, index);

		/* Restore the highlighted cell, with the new index for it.	*/
		if (wasHighlighted >= index) {
			/* Please note that if wasHighlighted == -1, it shouldn't be possible
			 * to be here.	*/
			setHighlightedItemIndex(++wasHighlighted);
		}

		aCell.setNeedsSizing(true);

		// Mark the menu view as needing to be resized.
		setNeedsSizing(true);
	}

	public function itemRemoved(notification:NSNotification):Void {
		var wasHighlighted:Number = highlightedItemIndex();
		var index:Number = Number(notification.userInfo.objectForKey(
			"NSMenuItemIndex"));

		if (index <= wasHighlighted) {
			setHighlightedItemIndex(-1);
		}
		m_itemCells.removeObjectAtIndex(index);

		if (wasHighlighted > index) {
			setHighlightedItemIndex(--wasHighlighted);
		}
		// Mark the menu view as needing to be resized.
		setNeedsSizing(true);
	}

	/*
	 * Working with Submenus.
	 */

	/**
	 * Detaches the window associated with the currently visible submenu and removes any
	 * menu item highlights.
	 *
	 *  If the submenu itself displays further submenus, this method detaches the windows
	 *  associated with those submenus as well.
	 *
	 *  In other words, recursively kill all attached submenus.
	 */
	public function detachSubmenu():Void {
		var am:NSMenu = attachedMenu();
		var amv:NSMenuView;

		if (am==null) {
			return;
		}
		amv = attachedMenuView();

		amv.detachSubmenu();
		amv.setHighlightedItemIndex(-1);

		//trace(asDebug("detach submenu: "+am+" from: "+m_menu));

		menu()["setAttachedMenu"](null);
		am.close();
		amv.window().display();
		amv.setHidden(true);
	}

	public function attachSubmenuForItemAtIndex(index:Number):Void {
		/*
		 * Transient menus are used for torn-off menus, which are already on the
		 * screen and for sons of transient menus.	As transients disappear as
		 * soon as we release the mouse the user will be able to leave submenus
		 * open on the screen and interact with other menus at the same time.
		 */
		if (index < 0) {
			return;
		}

		var attachableMenu:NSMenu = m_itemsLink.objectAtIndex(index).submenu();

		if(attachableMenu!=null) {
			menu()["setAttachedMenu"](attachableMenu);
		}

		attachableMenu.display();
	}

	/*
	 * Calculating Menu Geometry
	 */
	public function update():Void {
		//trace(asDebug("update called on menu view"));

		if (!m_menu.ownedByPopUp()) {
			//! FIXME Add title view. If this menu not owned by popup
		}

		// Resize it anyway.
		sizeToFit();

		// Just quit here if we are a popup.
		if (m_menu.ownedByPopUp()) {
			return;
		}
	}

	public function setNeedsSizing(flag:Boolean):Void {
		m_needsSizing = flag;
	}

	public function needsSizing():Boolean {
		return m_needsSizing;
	}

	public function sizeToFit():Void {
		var length:Number = m_itemCells.count();
		var wideTitleView:Number = 1;
		var neededImageWidth:Number = 0;
		var neededTitleWidth:Number = 0;
		var neededKeyEqImgWidth:Number = 0;
		var neededKeyEqWidth:Number = 0;
		var neededStateImageWidth:Number = 0;
		var neededHeight:Number = 0;
		var accumulatedOffset:Number = 0;
		var popupImageWidth:Number = 0;

		var aStateImageWidth:Number;
		var anImageWidth:Number;
		var aTitleWidth:Number;
		var aKeyEqImgWidth:Number;
		var aKeyEqWidth:Number;
		var needsArrowFlag:Boolean = false;
		var aCell:NSMenuItemCell;

		for (var i:Number = 0; i < length; i++) {
			aCell = NSMenuItemCell(m_itemCells.objectAtIndex(i));
			aCell.calcSize();

			// State image area.
			aStateImageWidth = aCell.stateImageWidth();

			// Title and Image area.
			aTitleWidth = aCell.titleWidth();
			anImageWidth = aCell.imageWidth();

			// Key equivalent area.
			aKeyEqImgWidth = aCell.keyEquivalentImageWidth();
			aKeyEqWidth = aCell.keyEquivalentWidth();

			needsArrowFlag = (aCell.menuItem().hasSubmenu() && !m_menu.isRoot() ? true : needsArrowFlag);

			if (aStateImageWidth > neededStateImageWidth) {
				neededStateImageWidth = aStateImageWidth;
			}
			if (anImageWidth > neededImageWidth) {
				neededImageWidth = anImageWidth;
			}
			if (aTitleWidth > neededTitleWidth) {
				neededTitleWidth = aTitleWidth;
			}
			if (aKeyEqImgWidth > neededKeyEqImgWidth) {
				neededKeyEqImgWidth = aKeyEqImgWidth;
			}
			if (aKeyEqWidth > neededKeyEqWidth) {
				neededKeyEqWidth = aKeyEqWidth;
			}
			// Get max height
			if (aCell.menuItemHeight() > neededHeight) {
				neededHeight = aCell.menuItemHeight();
			}
		}

		// Cache the needed widths.
		m_imageWidth = neededImageWidth;
		m_titleWidth = neededTitleWidth;
		m_titleAndKeyEqWidth = neededTitleWidth +
		(neededKeyEqWidth>0 ?
		NSMenuItemCell.tabSpacing() + neededKeyEqWidth
		 + m_horizontalEdgePad + neededKeyEqImgWidth
		: 0);
		m_stateImageWidth = neededStateImageWidth;

		accumulatedOffset = m_horizontalEdgePad;

		if (length>0) {
			// Calculate the offsets and cache them.
			if (neededStateImageWidth > 0) {
				m_stateImageOffset = accumulatedOffset;
				m_stateImageWidth = neededStateImageWidth;
				accumulatedOffset += neededStateImageWidth + m_horizontalEdgePad;
			} else {
			  m_stateImageOffset = 0;
			}

			if (neededImageWidth > 0) {
				m_imageOffset = accumulatedOffset;
				m_imageWidth = neededImageWidth;
				accumulatedOffset += neededImageWidth + m_horizontalEdgePad;
			} else {
				m_imageOffset = 0;
			}

			if (m_titleAndKeyEqWidth > 0) {
				m_titleAndKeyEqOffset = accumulatedOffset;
				accumulatedOffset += m_titleAndKeyEqWidth + m_horizontalEdgePad;
			} else {
				m_titleAndKeyEqOffset = 0;
			}

			if (neededKeyEqImgWidth > 0) {
				m_keyEqImgOffset = m_horizontalEdgePad + m_titleWidth + NSMenuItemCell.tabSpacing();
				m_keyEqImgWidth = neededKeyEqImgWidth;
				// don't touch accumulatedOffset
			}

			if (needsArrowFlag) {
				m_arrowOffset = accumulatedOffset;
			}
		}

		// Calculate frame size.
		m_cellSize.width = accumulatedOffset +
		(needsArrowFlag ?
		NSMenuItemCell.arrowWidth() + m_horizontalEdgePad: 0 );
		m_cellSize.height = neededHeight;

		var pad:Number = NSMenuItemCell.cellPadding();

		if (m_horizontal == false) {
			setFrameSize(new NSSize(
			m_cellSize.width + m_leftBorderOffset +
			pad*2,
			length * m_cellSize.height +
			(length + 1) * pad));
		} else {
			var w:Number = pad;
			length = m_itemCells.count();
			var item:NSMenuItemCell;
			while(length--) {
				item = NSMenuItemCell(
				m_itemCells.objectAtIndex(length));
				w+=item.cellWidth() + pad;
			}

			setFrameSize(new NSSize(w,
			m_cellSize.height + m_leftBorderOffset +
			pad*2));
		}

		m_needsSizing = false;
	}

	private function paddedRectForIndex(index:Number):NSRect {
		var pad:Number = NSMenuItemCell.cellPadding();
		return rectOfItemAtIndex(index).insetRect(-pad, -pad);
	}

	public function stateImageOffset():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_stateImageOffset;
	}

	public function stateImageWidth():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_stateImageWidth;
	}

	public function imageOffset():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_imageOffset;
	}

	public function imageWidth():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_imageWidth;
	}

	public function titleWidth():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_titleWidth;
	}

	/**
	 * Returns the offset <em>relative</em> to the textfield. In other words,
	 * the origin of the textfield on the x-axis has not be factored in.
	 */
	public function keyEquivalentImageOffset():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_keyEqImgOffset;
	}

	public function keyEquivalentImageWidth():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_keyEqImgWidth;
	}

	public function titleAndKeyEquivalentOffset():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_titleAndKeyEqOffset;
	}

	public function titleAndKeyEquivalentWidth():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_titleAndKeyEqWidth;
	}

	public function submenuArrowOffset():Number {
		if (m_needsSizing) {
			sizeToFit();
		}
		return m_arrowOffset;
	}

	public function innerRect():NSRect {
		if (m_horizontal == false) {
			return new NSRect(m_bounds.origin.x + m_leftBorderOffset,
			m_bounds.origin.y,
			m_bounds.size.width - m_leftBorderOffset,
			m_bounds.size.height);
		} else {
			return new NSRect (m_bounds.origin.x,
			m_bounds.origin.y + m_leftBorderOffset,
			m_bounds.size.width,
			m_bounds.size.height - m_leftBorderOffset);
		}
	}

	public function rectOfItemAtIndex(index:Number):NSRect {
		var theRect:NSRect = NSRect.ZeroRect;
		var pad:Number = NSMenuItemCell.cellPadding();

		if (m_needsSizing == true) {
			sizeToFit();
		}

		/* Fiddle with the origin so that the item rect is shifted 1 pixel over
		 * so we do not draw on the heavy line at origin.x = 0.
		 */
		theRect.size = NSSize(m_cellSize.copy());

		if (m_horizontal == false) {
			theRect.origin.y = m_cellSize.height * index +
			pad * (index+1);
			theRect.origin.x = m_leftBorderOffset + pad;
		} else {
			theRect.origin.y = pad;
			var cell:NSMenuItemCell = NSMenuItemCell(
			m_itemCells.objectAtIndex(index));
			theRect.size.width = cell.cellWidth();
			theRect.origin.x = pad;
			for (var i : Number = 0; i < index; i++) {
				theRect.origin.x += NSMenuItemCell(m_itemCells.objectAtIndex(i)).
				cellWidth() + pad;
			}
		}

		addLeftBorderOffsetToRect(theRect);

		/* NOTE: This returns the correct NSRect for drawing cells, but nothing
		 * else (unless we are a popup). This rect will have to be modified for
		 * event calculation, etc..
		 */

		return theRect;
	}

	public function indexOfItemAtPoint(point:NSPoint):Number {
		var howMany:Number = m_itemCells.count();
		var i:Number;
		var aRect:NSRect;

		for (i = 0; i < howMany; i++) {
			aRect = paddedRectForIndex(i);

			if (aRect.pointInRect(point)) {
				return i;
			}
		}

		return -1;
	}

	public function setNeedsDisplayForItemAtIndex(index:Number):Void {
		var aRect:NSRect ;

		aRect = rectOfItemAtIndex(index);
		//! NSView.setNeedsDisplayInRect(aRect);
		setNeedsDisplay(true);
	}

	public function locationForSubmenu(aSubmenu:NSMenu ):NSPoint {
		var rect:NSRect = rectOfItemAtIndex(m_highlightedItemIndex);
		var pt:NSPoint = m_window.convertBaseToScreen(rect.origin);
		var frame:NSSize = aSubmenu.menuRepresentation().frame().size;
		var offset:Number = 0;
		var size:NSSize = g_bounds;//.subtractSize(new NSSize(pt.x, pt.y));

		if (m_needsSizing) {
			sizeToFit();
		}

		if(isHorizontal()==false) {
			pt.x += rect.size.width;
			pt.y -= NSMenuItemCell.cellPadding();
			if(pt.x + frame.width > size.width) {
				pt.x -= rect.size.width + frame.width - offset;
				if(pt.x<0) {
					//!TODO looks weird
					pt.x = size.width - frame.width - offset;
				}
			} else {
				pt.x -= offset;
			}
			if(pt.y + frame.height > size.height) {
				pt.y = size.height - frame.height;
			}
		} else {
			pt.y += rect.size.height + NSMenuItemCell.cellPadding();
			if(pt.x + frame.width > size.width) {
				pt.x = size.width - frame.width - offset;
			}
		}
		return pt;
	}

	public function resizeWindowWithMaxHeight(maxHeight:Number):Void {
		//! FIXME set the menuview's window to max height in order to keep on screen?
	}

	//no onScreen, preferredEdge: name unchanged for compatibility
	public function setWindowFrameForAttachingToRectOnScreenPreferredEdgePopUpSelectedItem
	(screenRect:NSRect, /*screen:NSScreen, */selectedItemIndex:Number):Void {
		var r:NSRect;
		var cellFrame:NSRect;
		var screenFrame:NSRect;
		var items:Number = m_itemCells.count();

		// Convert the screen rect to our view
		cellFrame.size = screenRect.size;
		cellFrame.origin = m_window.convertScreenToBase(screenRect.origin);
		cellFrame = convertRectFromView(cellFrame, null);

		// Only call update if needed.
		if ((m_cellSize.isEqual(cellFrame.size) == false) || m_needsSizing) {
			trace(cellFrame.size);
			m_cellSize = cellFrame.size;
			update();
		}

		/*
		 * Compute the frame
		 */
		screenFrame = screenRect;
		if (items > 0) {
			var f:Number;

			if (m_horizontal == false) {
				f = screenRect.size.height * (items - 1);
				screenFrame.size.height += f + m_leftBorderOffset;
				screenFrame.origin.y -= f;
				screenFrame.size.width += m_leftBorderOffset;
				screenFrame.origin.x -= m_leftBorderOffset;
				// Compute position for popups, if needed
				if (selectedItemIndex != -1) {
					screenFrame.origin.y += screenRect.size.height * selectedItemIndex;
				}
			} else {
				f = screenRect.size.width * (items - 1);
				screenFrame.size.width += f;
				// Compute position for popups, if needed
				if (selectedItemIndex != -1) {
					screenFrame.origin.x -= screenRect.size.width * selectedItemIndex;
				}
			}
		}

		// Get the frameRect
		r = NSWindow.frameRectForContentRectStyleMask
		(screenFrame, m_window.styleMask());

		// Update position,if needed, using the preferredEdge;
		//! unsused?

		// Set the window frame
		m_window.setFrame(r);
	}

	/*
	 * Drawing.
	 */
	public function isOpaque():Boolean {
		return true;
	}

	public function drawRect(rect:NSRect):Void {
		var i:Number;
		var howMany:Number = m_itemCells.count();
		var aRect:NSRect;
		var aCell:NSMenuItemCell;

		// Draw the dark gray upper and left lines.
		var mc:MovieClip;
		try {
			mc = mcBounds();
		} catch(e:NSException) {
			trace(e);
			trace(asFatal(e.message));
			return;
		}
		mc.clear();
		ASDraw.fillRectWithRect(mc, rect, NSColor.controlBackgroundColor().value, 90);
		if (m_horizontal) {
		  ASDraw.drawLine(mc, rect.minX(), rect.maxY()-1, rect.maxX(), rect.maxY()-1, ASColors.lightGrayColor().value);
		} else {
		  ASDraw.drawRectWithRect(mc, rect, ASColors.lightGrayColor().value, 100, 2);
		}

		//top, then left
		//! try using outlineRectWithAlpha
		//ASDraw.drawHLine(mc, ASColors.darkGrayColor().value, rect.minX(), rect.maxX(), rect.minY());
		//ASDraw.drawVLine(mc, ASColors.darkGrayColor().value, rect.minY(), rect.maxY(), rect.minX());

		// Draw the menu cells
		for (i = 0; i < howMany; i++) {
			aRect = rectOfItemAtIndex(i);
			if (rect.intersectsRect(aRect) == true) {
				aCell = NSMenuItemCell(m_itemCells.objectAtIndex(i));
				aCell.drawWithFrameInView(aRect, this);
			}
		}
	}

	public function mouseDown (event:NSEvent):Void {
		m_trackingData = {
			eventMask:
			NSEvent.NSLeftMouseUpMask | NSEvent.NSLeftMouseDraggedMask |
			NSEvent.NSMouseMovedMask | NSEvent.NSLeftMouseDownMask
		};

		mouseTrackingCallback(event);
	}

	private function mouseTrackingCallback(event:NSEvent):Void {
		var location:NSPoint = convertPointFromView(event.mouseLocation);
		var index:Number = indexOfItemAtPoint(location);

		//1 The mouse has moved out of the menu
		if (index == -1) {
			//in global co-ords
			var loc:NSPoint = event.mouseLocation;

			//1ii) - Check if we enter the attached submenu
			var windowUnderMouse:NSWindow = m_menu.attachedMenu().window();
			if (windowUnderMouse != null
			&& windowUnderMouse.frame().pointInRect
			(loc)) {
				var v:NSMenuView = attachedMenuView();
				v.mouseDown(event);
				return;
			}

			//1i) I am a submenu, and user moved into my ancestor
			var candidateMenu:NSMenu = m_menu.superMenu();
			while (candidateMenu.superMenu()!=null
			&& !candidateMenu.window().frame().pointInRect(loc) // not found yet
			&& candidateMenu.isAttached()) {// has displayed parent
				candidateMenu = candidateMenu.superMenu();
			}

			if (candidateMenu != null
			&& candidateMenu.window().frame().pointInRect
			(loc)) {
				var v:NSMenuView = candidateMenu.menuRepresentation();
				//! FIXME detach here?
				v.mouseDown(event);

				return;
			}

			//1iii) - Don't close the menu unless clicked outside
			if (event.type==NSEvent.NSLeftMouseDown) {
				trackingDone();
				return;
			}
		}
		//2 - User has selected another item
		if(index != m_highlightedItemIndex) {
			//don't detach the menu if just attached
			if(m_menu.indexOfItemWithSubmenu(attachedMenu())!=index) {
				detachSubmenu();
			}
			//invoke now since detach will set index to -1
			setHighlightedItemIndex(index);

			//3 - attach submenu
			if (index >= 0 && (m_itemsLink.objectAtIndex(index).submenu()!=null)) {
				attachSubmenuForItemAtIndex(index);
			}
			setNeedsDisplay(true);
		}

		if(event.type==NSEvent.NSLeftMouseUp) {
			if(m_itemsLink.objectAtIndex(m_highlightedItemIndex).submenu()==null) {
				//since it has no submenus, perform an action
				trackingDone();
				return;
			}
		}

		m_app.callObjectSelectorWithNextEventMatchingMaskDequeue
		(this, "mouseTrackingCallback", m_trackingData.eventMask, true);
	}

	private function trackingDone():Void {
		g_nc.postNotificationWithNameObject(
		NSMenu.NSMenuDidEndTrackingNotification, NSMenu.rootMenu());
		// We need to store this, because m_highlightedItemIndex
		// will not be valid after we removed this menu from the screen.

		var indexOfActionToExecute:Number = m_highlightedItemIndex;
		//remove transient menus.
		var curr:NSMenu = m_menu;

		while (curr.superMenu()!=null) {
			curr=curr.superMenu();
		}

		curr.menuRepresentation().detachSubmenu();

		if (m_highlightedItemIndex >= 0) {
			setHighlightedItemIndex(-1);
		}

		m_menu.performActionForItemAtIndex(indexOfActionToExecute);
	}

	/*
	 * Event Handling
	 */
	public function performActionWithHighlightingForItemAtIndex(index:Number):Void {
		var candidateMenu:NSMenu = m_menu;
		var targetMenuView:NSMenuView;
		var indexToHighlight:Number = index;
		var oldHighlightedIndex:Number;
		var superMenu:NSMenu;

		for (;;) {
			superMenu = candidateMenu.superMenu();

			if (superMenu == null
			|| candidateMenu.isAttached()) {
				targetMenuView = candidateMenu.menuRepresentation();

				break;
			} else {
				indexToHighlight = superMenu.indexOfItemWithSubmenu(candidateMenu);
				candidateMenu = superMenu;
			}
		}

		oldHighlightedIndex = targetMenuView.highlightedItemIndex();
		targetMenuView.setHighlightedItemIndex(indexToHighlight);

		/* We need to let the run loop run a little so that the fact that
		 * the item is highlighted gets displayed on screen.
		 *
		[NSRunLoop.currentRunLoop()
			runUntilDate: NSDate.dateWithTimeIntervalSinceNow(0.1]);
		*/
		m_menu.performActionForItemAtIndex(index);

		if (!m_menu.ownedByPopUp()) {
			targetMenuView.setHighlightedItemIndex(oldHighlightedIndex);
		}
	}

	public function performKeyEquivalent(theEvent:NSEvent ):Boolean {
		return m_menu.performKeyEquivalent(theEvent);
	}

	public function description():String {
		return "NSMenuView("+m_menu.title()+")";
	}
}
