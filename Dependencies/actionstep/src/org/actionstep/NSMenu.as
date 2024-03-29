/* See LICENSE for copyright and terms of use */

import org.actionstep.ASUtils;
import org.actionstep.NSApplication;
import org.actionstep.NSArray;
import org.actionstep.NSDictionary;
import org.actionstep.NSEnumerator;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSMenuItem;
import org.actionstep.menu.NSMenuPanel;
import org.actionstep.menu.NSMenuView;
import org.actionstep.NSNotification;
import org.actionstep.NSNotificationCenter;
import org.actionstep.NSObject;
import org.actionstep.NSPoint;
import org.actionstep.NSPopUpButtonCell;
import org.actionstep.NSRect;
import org.actionstep.NSSize;
import org.actionstep.NSUserDefaults;
import org.actionstep.NSView;
import org.actionstep.NSWindow;
import org.actionstep.NSCell;

/**
 * A menu. TODO Fill this comment in.
 *
 * For an example of this class' usage, please see
 * <code>org.actionstep.test.ASTestMenu</code>.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.NSMenu extends NSObject {

	//******************************************************
	//*                  Constants
	//******************************************************

	/** User default key */
	public static var NSMenuLocationsKey:String = "NSMenuLocations";

	//******************************************************
	//*                 Notifications
	//******************************************************
	public static var NSEnqueuedMenuMove:Number
		= ASUtils.intern("NSEnqueuedMoveNotification");

	/**
	 * Posted when a menu adds an <code>NSMenuItem</code>.
	 *
	 * The userInfo dictionary contains the following:
	 *   - "NSMenuItemIndex": The index of the item that was added. (Number)
	 */
	public static var NSMenuDidAddItemNotification:Number =
		ASUtils.intern("NSMenuDidAddItemNotification");

	/**
	 * Posted after a menu item changes appearance. This includes enabling /
	 * disabling, a title change or a change in state.
	 *
	 * The userInfo dictionary contains the following:
	 *   - "NSMenuItemIndex": The index of the item that was changed. (Number)
	 */
	public static var NSMenuDidChangeItemNotification:Number
		= ASUtils.intern("NSMenuDidChangeItemNotification");

	/**
	 * Posted when menu tracking ends. The notification object is the root
	 * node in the menu.
	 */
	public static var NSMenuDidEndTrackingNotification:Number
		= ASUtils.intern("NSMenuDidEndTrackingNotification");

	/**
	 * Posted after a menu item is removed from the menu.
	 *
	 * The userInfo dictionary contains the following:
	 *   - "NSMenuItemIndex": The index of the item that was removed. (Number)
	 */
	public static var NSMenuDidRemoveItemNotification:Number
		= ASUtils.intern("NSMenuDidRemoveItemNotification");

	/**
	 * Posted after a menu sends a menu item's action to its target. The object
	 * is the menu that contains the menu item.
	 *
	 * The userInfo dictionary contains the following:
	 *   - "MenuItem": The chosen menu item. (NSMenuItem)
	 */
	public static var NSMenuDidSendActionNotification:Number
		= ASUtils.intern("NSMenuDidSendActionNotification");

	/**
	 * Posted before a menu sends a menu item's action to its target. The object
	 * is the menu that contains the menu item.
	 *
	 * The userInfo dictionary contains the following:
	 *   - "MenuItem": The chosen menu item. (NSMenuItem)
	 */
	public static var NSMenuWillSendActionNotification:Number
		= ASUtils.intern("NSMenuWillSendActionNotification");

	//******************************************************
	//*                 Class members
	//******************************************************

	/** The notification center used by menus. */
	private static var g_nc:NSNotificationCenter;

	/** Delimeter between for menu paths. */
	private static var g_delimeter:String = ".";

	//******************************************************
	//*                Root Menu
	//******************************************************

	private static var g_rootMenu:NSMenu;

	public static function rootMenu():NSMenu {
		return g_rootMenu;
	}

	//******************************************************
	//*                Member variables
	//******************************************************

	private var m_app:NSApplication;
	private var m_notifications:NSArray;
	private var m_title:String;
	private var m_items:NSArray;
	private var m_oldHiglightedIndex:Number;

	private var m_superMenu:NSMenu;
	private var m_attachedMenu:NSMenu;
	private var m_oldAttachedMenu:NSMenu;
	private var m_view:NSMenuView;
	private var m_popUpButtonCell:NSPopUpButtonCell;

	//Flags
	private var m_needsSizing:Boolean;
	private var m_changedMessagesEnabled:Boolean;
	private var m_autoenable:Boolean;
	private var m_window:NSWindow;
	private var m_isRoot:Boolean;

	/**
	 * Initializes the menu with the title NSMenu.
	 */
	public function init():NSMenu {
		return initWithTitle("NSMenu");
	}

	/**
	 * Initializes the menu with the title <code>aTitle</code>.
	 */
	public function initWithTitle(aTitle:String):NSMenu {
		var contentView:NSView;

		super.init();
		m_app = NSApplication.sharedApplication();
		g_nc = NSNotificationCenter.defaultCenter();

		//
		// Set some field values.
		//
		m_title = aTitle;
		m_changedMessagesEnabled = true;
		m_items = new NSArray();
		m_notifications = new NSArray();
		m_needsSizing = true;
		m_autoenable = true; // According to the spec
		m_superMenu = null;
		m_isRoot = false;

		//
		// Create the windows that will display the menu.
		//
		m_window = createWindow();

		//! FIXME some bug here, so leave this out first
		//m_bWindow.setLevel(NSWindow.NSPopUpMenuWindowLevel);
		m_window.makeKeyWindow(); //AndOrderFront();

		//
		// Create a NSMenuView to draw our menu items.
		//
		m_view = NSMenuView((new NSMenuView()).initWithFrame(NSRect.ZeroRect));
		m_view.setMenu(this);
		m_view["setHorizontal"](false);
		m_view.setHidden(true);
		m_window.hide();

		contentView = m_window.contentView();
		contentView.addSubview(m_view);

		//
		// Set up the notification to start the process of redisplaying
		// the menus where the user left them the last time.
		//
		// Use NSApplicationDidFinishLaunching, and not
		// NSApplicationWillFinishLaunching, so that the programmer can set
		// up menus in NSApplicationWillFinishLaunching.
		//

		g_nc.addObserverSelectorNameObject(this, "showOnActivateApp",
			NSApplication.NSApplicationWillBecomeActiveNotification, m_app);

		g_nc.addObserverSelectorNameObject(this, "m_menuMoved",
			NSView.NSViewFrameDidChangeNotification, m_window.contentView());
		//! FIXME (this, "m_menuMoved", NSWindow.NSWindowDidMoveNotification, m_window);

		g_nc.addObserverSelectorNameObject(this, "m_updateUserDefaults",
			NSEnqueuedMenuMove, this);

		return this;
	}

	/**
	 * Releases this menu from memory.
	 */
	public function release():Void {
		g_nc.removeObserver(this);

		// Now clean the pointer to us stored each m_items element
		m_items.makeObjectsPerformSelectorWithObject("setMenu", null);
	}

	//******************************************************
	//*             Setting Up the Menu Commands
	//******************************************************

	public function insertItemAtIndex(newItem:NSMenuItem, index:Number):Void {
		var inserted:NSNotification;
		var d:NSDictionary;

		/*
		 * If the item is already attached to another menu it
		 * isn't added.
		 */
		if (newItem.menu() != null) {
			trace(asFatal("The object "+newItem+" is already attached to a"
				+ " menu; it isn't possible to add it."));
			return;
		}

		m_items.insertObjectAtIndex(newItem, index);
		m_needsSizing = true;

		// Create the notification for the menu representation.
		d = NSDictionary.dictionaryWithObjectForKey
		(index, "NSMenuItemIndex");

		inserted = NSNotification.withNameObjectUserInfo
		(NSMenuDidAddItemNotification, this, d);

		if (m_changedMessagesEnabled) {
			g_nc.postNotification(inserted);
		} else {
			m_notifications.addObject(inserted);
		}

		// Set this after the insert notification has been send.
		newItem.setMenu(this);
	}

	public function insertItemWithTitleActionKeyEquivalentAtIndex
	(aString:String, aSelector:String, charCode:String, index:Number):NSMenuItem {
		var anItem:NSMenuItem = (new NSMenuItem()).initWithTitleActionKeyEquivalent
		(aString, aSelector, charCode);
		if (!isRoot()) {
		  anItem.setState(NSCell.NSOffState);
		}

		// Insert the new item into the menu.
		insertItemAtIndex(anItem, index);

		// For returns sake.
		return anItem;
	}

	public function addItem(newItem:NSMenuItem):Void {
		insertItemAtIndex(newItem, m_items.count());
	}

	public function addItemWithTitleActionKeyEquivalent
	(aString:String, aSelector:String, keyEquiv:String):NSMenuItem {
		return insertItemWithTitleActionKeyEquivalentAtIndex
		(aString, aSelector, keyEquiv, m_items.count());
	}

	public function removeItem(anItem:NSMenuItem) {
		var index:Number = indexOfItem(anItem);

		if (-1 == index) {
			return;
		}

		removeItemAtIndex(index);
	}

	public function removeItemAtIndex(index:Number):Void {
		var removed:NSNotification;
		var d:NSDictionary;
		var anItem:NSMenuItem = NSMenuItem(m_items.objectAtIndex(index));

		if (anItem==null) {
			return;
		}

		anItem.setMenu(null);
		m_items.removeObjectAtIndex(index);
		m_needsSizing = true;

		d = NSDictionary.dictionaryWithObjectForKey
		(index, "NSMenuItemIndex");

		removed = NSNotification.withNameObjectUserInfo
		(NSMenuDidRemoveItemNotification, this, d);

		if (m_changedMessagesEnabled) {
			g_nc.postNotification(removed);
		} else {
			m_notifications.addObject(removed);
		}
	}

	public function itemChanged(anObject:NSMenuItem):Void {
		var changed:NSNotification;
		var d:NSDictionary;
		var index:Number = indexOfItem(anObject);

		if (index == -1) {
			return;
		}

		m_needsSizing = true;

		d = NSDictionary.dictionaryWithObjectForKey
		(index, "NSMenuItemIndex");

		changed = NSNotification.withNameObjectUserInfo
		(NSMenuDidChangeItemNotification, this, d);

		if (m_changedMessagesEnabled) {
			g_nc.postNotification(changed);
		} else {
			m_notifications.addObject(changed);
		}
		// Update the menu.
		update();
	}

	//******************************************************
	//*                Finding Menu Items
	//******************************************************

	public function itemWithTag(aTag:Number):NSMenuItem {
		var i:Number;
		var count:Number = m_items.count();
		var menuItem:NSMenuItem;

		for (i = 0; i < count; i++) {
			menuItem = NSMenuItem(m_items.objectAtIndex(i));
			if (menuItem.tag() == aTag) {
				return menuItem;
			}
		}

		return null;
	}

	public function itemWithTitle(aString:String):NSMenuItem {
		var i:Number;
		var count:Number = m_items.count();
		var menuItem:NSMenuItem;

		for (i = 0; i < count; i++) {
			menuItem = NSMenuItem(m_items.objectAtIndex(i));
			if (menuItem.title() == aString) {
				return menuItem;
			}
		}

		return null;
	}

	public function itemAtIndex(index:Number):NSMenuItem {
		if (index >= m_items.count() || index < 0) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo
			(NSException.NSRange, "Range error", null);
			trace(e);
			e.raise();
		}

		return NSMenuItem(m_items.objectAtIndex(index));
	}

	public function numberOfItems():Number {
		return m_items.count();
	}

	public function itemArray():NSArray {
		return m_items;
	}

	//******************************************************
	//*             Finding Indices of Menu Items
	//******************************************************

	public function indexOfItem(anObject:NSMenuItem):Number {
		var index:Number = m_items.indexOfObjectIdenticalTo(anObject);

		if (index == NSNotFound) {
			return -1;
		} else {
			return index;
		}
	}

	public function indexOfItemWithTitle(aTitle:String):Number {
		var anItem:NSMenuItem;

		if ((anItem = itemWithTitle(aTitle))) {
			return m_items.indexOfObjectIdenticalTo(anItem);
		} else {
			return -1;
		}
	}

	public function indexOfItemWithTag(aTag:Number):Number {
		var anItem:NSMenuItem;

		if ((anItem = itemWithTag(aTag))) {
			return m_items.indexOfObjectIdenticalTo(anItem);
		} else {
			return -1;
		}
	}

	public function indexOfItemWithTargetAndAction(anObject:Object,
			actionSelector:String):Number {
		var i:Number;
		var count:Number = m_items.count();
		var menuItem:NSMenuItem;

		for (i = 0; i < count; i++) {
			menuItem = NSMenuItem(m_items.objectAtIndex(i));

			if (actionSelector == 0 || (menuItem.action() == actionSelector)) {
				if (menuItem.target()==(anObject)) {
					return i;
				}
			}
		}

		return -1;
	}

	public function indexOfItemWithRepresentedObject(anObject:Object):Number {
		var i:Number;
		var count:Number = m_items.count();

		for (i = 0; i < count; i++) {
			//! what if isEqual is null?
			if (m_items.objectAtIndex(i).representedObject().isEqual(anObject)) {
				return i;
			}
		}

		return -1;
	}

	public function indexOfItemWithSubmenu(anObject:NSMenu):Number {
		var i:Number;
		var count:Number = m_items.count();
		var item:NSMenuItem;

		for (i = 0; i < count; i++) {
			item = NSMenuItem(m_items.objectAtIndex(i));
			//! what if isEqual is null?
			if (item.hasSubmenu() && item.submenu().isEqual(anObject)) {
				return i;
			}
		}

		return -1;
	}

	//******************************************************
	//*                Managing Submenus
	//******************************************************

	public function setSubmenuForItem
	(aMenu:NSMenu, anItem:NSMenuItem):Void {
		anItem.setSubmenu(aMenu);
	}

	/**
	 * This method is the action method assigned to menu items that open
	 * submenus.
	 */
	public function submenuAction(sender:Object):Void {
		trace(">>Some action<<");
	}


	public function attachedMenu():NSMenu {
		return m_attachedMenu;
	}

	private function setAttachedMenu(m : NSMenu) : Void {
		m_attachedMenu = m;
	}


	public function isAttached():Boolean {
		return ((m_superMenu!=null) && (m_superMenu.attachedMenu() == this));
	}

	public function locationForSubmenu(aSubmenu:NSMenu):NSPoint {
		return m_view.locationForSubmenu(aSubmenu);
	}

	public function superMenu():NSMenu {
		return m_superMenu;
	}

	public function setSupermenu(superMenu:NSMenu):Void {
		m_superMenu = superMenu;
	}

	/**
	 * AS-specific. Determines if the menu is the root one. A menu without a
	 * superMenu is the root menu.
	 *
	 * If the menu is the root one, its representation is:
	 * - horizontal
	 * - not hidden
	 *
	 * If <code>f</code> is not specified, defaults to true.
	 *
	 * Please note that only <code>NSApp</code> is allowed to invoke this
	 * method.
	 *
	 * @see org.actionstep.NSApplication#setMainMenu
	 */
	public function setRoot(f:Boolean):Void {
		if(!(arguments[1] instanceof NSApplication)) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo
			("ASInvalidCondition", "Not allowed to set root menu!");
			trace(e);
			throw e;
		}
		if(f==null) f=true;
		if(m_isRoot = f) {
			var n:Number =  NSWindow.NSWindowDidBecomeMainNotification;
			g_nc.removeObserverNameObject(g_rootMenu, n, null);
			g_rootMenu = this;
			g_nc.addObserverSelectorNameObject(
			this, "validateRootMenu", n, null);
		}

		menuRepresentation()["setHorizontal"](f);
		menuRepresentation().setHidden(!f);
		if(f)	m_window.show();
	}

	public function isRoot():Boolean {
		return m_isRoot;
	}

	//******************************************************
	//*         Enabling and Disabling Menu Items
	//******************************************************

	/**
	 * If <code>flag</code> is <code>true</code>, the menu will automatically
	 * enable and disable its menu items based on delegates implementing
	 * the <code>NSMenuValidation</code> protocol. If <code>flag</code> is
	 * <code>false</code>, they will not.
	 */
	public function setAutoenablesItems(flag:Boolean):Void {
		m_autoenable = flag;
	}

	/**
	 * Returns <code>true</code> if the menu automatically enables and disables
	 * menu items based on its delegates, or <code>false</code> if it doesn't.
	 */
	public function autoenablesItems():Boolean {
		return m_autoenable;
	}

	/**
	 * Enables / disables this menu's items based on the
	 * <code>NSMenuValidation</code> protocol, and also sizes the menu to fit
	 * its items.
	 */
	public function update():Void {
		// We use this as a recursion check.
		if (!m_changedMessagesEnabled) {
			return;
		}

		if (autoenablesItems()) {
			var i:Number, count:Number;
			var item:NSMenuItem;
			var action:String;
			var validator:Object;
			var wasEnabled:Boolean;
			var shouldBeEnabled:Boolean;

			count = m_items.count();

			// Temporary disable automatic displaying of menu.
			setMenuChangedMessagesEnabled(false);

			for (i = 0; i < count; i++) {
				item = NSMenuItem(m_items.objectAtIndex(i));
				action = item.action();
				validator = null;
				wasEnabled = item.isEnabled();
				shouldBeEnabled = null;

				// Update the submenu items if any.
				if (item.hasSubmenu()) {
					item.submenu().update();
				}

				// If there is no action - there can be no validator for the item.
				if (action!=null) {
					validator = m_app.targetForActionToFrom(action,
						item.target(), item);
				} else if (m_popUpButtonCell != null) {
					if (null != (action = m_popUpButtonCell.action())) {
						validator = m_app.targetForActionToFrom
						(action, m_popUpButtonCell.target(),
							m_popUpButtonCell.controlView());
					}
				}

				if (validator == null) {
					if (action != null) {
						shouldBeEnabled = true;
					}
				} else if (validator.respondsToSelector("validateMenuItem")) {
					shouldBeEnabled = validator.validateMenuItem(item);
				} else {
					shouldBeEnabled = true;
				}

				if (shouldBeEnabled != null && shouldBeEnabled != wasEnabled) {
					item.setEnabled(shouldBeEnabled);
				}
			}

			// Reenable displaying of menus
			setMenuChangedMessagesEnabled(true);
		}

		if (m_needsSizing && m_window.isVisible()) {
			//trace(asDebug("Calling Size To Fit (A)"));
			sizeToFit();
		}

		return;
	}

	//******************************************************
	//*            Handling Keyboard Equivalents
	//******************************************************

	/**
	 * Performs the key equivalent for the key equivalent described in
	 * <code>theEvent</code>.
	 *
	 * The arguments <code>flag</code> must be ignored by anyone invoking this
	 * function. It is used to prevent more than one menu from iterating
	 * through the menu heirachy.
	 */
	public function performKeyEquivalent(theEvent:NSEvent, flag:Boolean):Boolean {
		if(!isRoot() && flag==null) {
			return false;
		}

		var i:Number;
		var count:Number = m_items.count();
		var type:Number = theEvent.type;
		var item:NSMenuItem;

		if (type != NSEvent.NSKeyDown && type != NSEvent.NSKeyUp) {
			return false;
		}

		for (i = 0; i < count; i++) {
			item = NSMenuItem(m_items.objectAtIndex(i));

			if (item.hasSubmenu()) {
				// Recurse through submenus.
				if (item.submenu().performKeyEquivalent(theEvent, true)) {
					// The event has been handled by an item in the submenu.
					return true;
				}
			} else {
				if(theEvent.matchesKeyEquivalent
				(item.keyEquivalent(), item.keyEquivalentModifierMask())) {
					if (item.isEnabled()) {
						trace("performing key equivalent...");
						m_view.performActionWithHighlightingForItemAtIndex(i);
						return true;
					}
				}
			}
		}
		return false;
	}

	//******************************************************
	//*              Simulating Mouse Clicks
	//******************************************************

	/**
	 * Causes the action of the menu item at <code>index</code> to be sent to
	 * its target.
	 *
	 * This method posts an <code>NSMenuWillSendActionNotification</code> and
	 * a <code>NSMenuDidSendActionNotification</code> as a result of being
	 * called.
	 */
	public function performActionForItemAtIndex(index:Number):Void {
		var item:NSMenuItem = NSMenuItem(m_items.objectAtIndex(index));
		var d:NSDictionary;
		var action:String;

		if (item == null || !item.isEnabled()) {
			return;
		}

		//
		// Post an NSMenuWillSendActionNotification notification
		//

		d = NSDictionary.dictionaryWithObjectForKey
		(item, "MenuItem");

		g_nc.postNotificationWithNameObjectUserInfo(
			NSMenuWillSendActionNotification, this,
			NSDictionary(d.copyWithZone()));

		//
		// Tell the popup button, which item was selected (if there is one)
		//
		if (m_popUpButtonCell != null) {
			m_popUpButtonCell.selectItemAtIndex(index);
		}

		//
		// Send the item's action if possible.
		//
		if ((action = item.action()) != null) {
			m_app.sendActionToFrom
			(action, item.target(), item);
		} else if (m_popUpButtonCell != null) {
			if ((action = m_popUpButtonCell.action()) != null) {
				m_app.sendActionToFrom(
					action, m_popUpButtonCell.target(),
					m_popUpButtonCell.controlView());
			}
		}

		//
		// Post an NSMenuDidSendActionNotification notification
		//
		g_nc.postNotificationWithNameObjectUserInfo(
			NSMenuDidSendActionNotification, this,
			NSDictionary(d.copyWithZone()));
	}

	//******************************************************
	//*              Setting the title
	//******************************************************

	/**
	 * Sets the title of this menu to <code>aTitle</code>.
	 */
	public function setTitle(aTitle:String):Void {
		if(aTitle.indexOf(g_delimeter)!=-1) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo
			(NSException.NSInvalidArgument,
			"aTitle cannot contain the character(s) "+g_delimeter);
			trace(e);
			throw e;
		}
		m_title = aTitle;

		m_needsSizing = true;
		if (m_window.isVisible()) {
			sizeToFit();
		}
	}

	/**
	 * Returns the title of this menu.
	 */
	public function title():String {
		return m_title;
	}

	//******************************************************
	//*          Setting the Representing Object
	//******************************************************

	/**
	 * FIXME: This method is deprecated. Figure out another way to do it,
	 * or justify its necessity.
	 */
	public function setMenuRepresentation(menuRep:NSMenuView):Void {
		var contentView:NSView;

		// remove the old representation
		contentView = m_window.contentView();
		//! orig = removeSubview
		contentView.removeFromSuperview(m_view);

		m_view = menuRep;
		m_view.setMenu(this);

		// add the new representation
		contentView.addSubview(m_view);
	}

	/**
	 * FIXME: This method is deprecated. Figure out another way to do it,
	 * or justify its necessity.
	 */
	public function menuRepresentation():NSMenuView {
		return m_view;
	}

	//******************************************************
	//*                 Updating menu layout
	//******************************************************

	//!!!!
	// Wim 20030301: Question, what happens when the notification trigger
	// new notifications?	I think it is not allowed to add items
	// to the m_notifications array while enumerating it.
	//

	/**
	 * Sets whether or not this window posts notifications when menu items
	 * change. If <code>flag</code> is <code>true</code> it does, and if
	 * <code>flag</code> is false it does not.
	 */
	public function setMenuChangedMessagesEnabled(flag:Boolean):Void {
		if (m_changedMessagesEnabled != flag) {
			if (flag) {
				if (m_notifications.count()) {
					var enumerator:NSEnumerator = m_notifications
						.objectEnumerator();
					var aNotification:NSNotification;

					while ((aNotification = NSNotification(enumerator
							.nextObject()))) {
						g_nc.postNotification(aNotification);
					}
				}
				// Clean the notification array.
				m_notifications.removeAllObjects();
			}
			m_changedMessagesEnabled = flag;
		}
	}

	/**
	 * Returns <code>true</code> if this window posts notifications when
	 * menu items change, or <code>false</code> if it does not.
	 */
	public function menuChangedMessagesEnabled():Boolean {
		return m_changedMessagesEnabled;
	}

	/**
	 * Sizes the menu to fit its contents.
	 */
	public function sizeToFit():Void {
		var oldWindowFrame:NSRect;
		var newWindowFrame:NSRect;
		var menuFrame:NSRect;
		var size:NSSize;

		m_view.sizeToFit();

		menuFrame = m_view.frame();
		size = menuFrame.size;

		// Main
		oldWindowFrame = m_window.frame();
		newWindowFrame = NSWindow.frameRectForContentRectStyleMask
		(menuFrame, m_window.styleMask());

		if (!menuRepresentation().isHorizontal() && oldWindowFrame.size.height > 1) {
			newWindowFrame.origin = new NSPoint(oldWindowFrame.origin.x,
			oldWindowFrame.origin.y + oldWindowFrame.size.height -
				newWindowFrame.size.height);
		}

		m_window.setFrame(newWindowFrame);

		if (m_popUpButtonCell == null) {
			m_view.setFrameOrigin(NSPoint.ZeroPoint);
		}

		m_view.setNeedsDisplay(true);

		m_needsSizing = false;
	}

	//******************************************************
	//*         Displaying Context Sensitive Help
	//******************************************************

	public function helpRequested(event:NSEvent):Void {
		//! TODO: Won't be implemented until we have NSHelp*
	}

	public static function popUpContextMenuWithEventForView
	(menu:NSMenu, event:NSEvent, view:NSView):Void {
		menu.rightMouseDisplay(event);
	}

	private function showOnActivateApp(notification:NSNotification):Void {
		if (m_app.mainMenu() == this) {
			display();
			// we must make sure that any attached submenu is visible too.
			attachedMenu().display();
		}
	}

	//! NSScreen??
	public function isPartlyOffScreen():Boolean {
		return false;//!(NSContainsRect([NSScreen mainScreen] frame], [WINDOW.frame()))
	}

	private function performMenuClose(sender:Object):Void {
		if (m_attachedMenu!=null) {
			m_view.detachSubmenu();
		}
		m_view.setHighlightedItemIndex(-1);
		close();

		updateUserDefaults(null);
	}

	public function display():Void {
		//trace("displaying");

		if (m_needsSizing) {
			sizeToFit();
		}

		if (m_superMenu) {
			// query super menu for position
			//trace("querying...");
			m_window.setFrameOrigin(
			m_superMenu.menuRepresentation().locationForSubmenu(this));
			m_superMenu.setAttachedMenu(this);
		} else if (m_window.frame().origin.y <= 0
		&& m_popUpButtonCell == null) { // get geometry only if not set
			setGeometry();
		}

		trace(asDebug("Display, origin: "+m_window.frame().origin));

		m_window.orderFrontRegardless();
		m_window.show();
		m_view.setHidden(false);
		m_view.display();
	}

	/**
	 * Closes this menu.
	 */
	public function close():Void {
		var sub:NSMenu = attachedMenu();

		//
		// If we have an attached submenu, we must close that too - but then make
		// sure we still have a record of it so that it can be re-displayed if we
		// are redisplayed.
		//
		if (sub != null) {
			sub.close();
			m_attachedMenu = sub;
		}
		m_window.hide();
		m_window.orderOut(this);
		//m_window.contentView().setHidden(true);
		if (m_superMenu) {
			m_superMenu.m_attachedMenu = null;
			m_superMenu.menuRepresentation().setHighlightedItemIndex(-1);
		}
	}

	/**
	 * Returns the window containing the menu.
	 */
	public function window():NSWindow {
		return m_window;
	}

	/**
	 * Set the frame origin of the receiver to aPoint. If a submenu of
	 * the receiver is attached. The frame origin of the submenu is set
	 * appropriately.
	 */
	public function nestedSetFrameOrigin(aPoint:NSPoint):Void {
		var theWindow:NSWindow = window();

		// Move ourself and get our width.
		theWindow.setFrameOrigin(aPoint);

		// Do the same for attached menus.
		if (m_attachedMenu) {
			aPoint = locationForSubmenu(m_attachedMenu);
			m_attachedMenu.nestedSetFrameOrigin(aPoint);
		}
	}

	private static var SHIFT_DELTA:Number = 18;

	public function shiftOnScreen():Void {
		var theWindow:NSWindow = m_window;
		var frameRect:NSRect = theWindow.frame();
		//[NSScreen mainScreen].frame();
		var screenRect:NSRect = new NSRect(Stage.width, Stage.height);
		var vector:NSPoint	= new NSPoint(0, 0);
		var moveIt	:Boolean	= false;

		// 1 - determine the amount we need to shift in the y direction.
		if (frameRect.minY() < 0) {
			vector.y = Math.min(SHIFT_DELTA, -frameRect.minY());
			moveIt = true;
		} else if (frameRect.maxY() > screenRect.maxY()) {
			vector.y = -Math.min(SHIFT_DELTA, frameRect.maxY() - screenRect.maxY());
			moveIt = true;
		}

		// 2 - determine the amount we need to shift in the x direction.
		if (frameRect.minX() < 0) {
			vector.x = Math.min(SHIFT_DELTA, -frameRect.minX());
			moveIt = true;
		} else if (frameRect.maxX() > (screenRect.maxX() - 3)) {
		// Note the -3.	This is done so the menu, after shifting completely
		// has some spare room on the right hand side.	This is needed otherwise
		// the user can never access submenus of this menu.
			vector.x = -Math.min(SHIFT_DELTA,
			frameRect.maxX() - screenRect.maxX() + 3);
			moveIt = true;
		}

		if (moveIt) {
			var candidateMenu:NSMenu;
			var masterMenu:NSMenu;
			var masterLocation:NSPoint;
			var destinationPoint:NSPoint;

			// Look for the "master" menu, i.e. the one to move from.
			for (candidateMenu = masterMenu = this;
			candidateMenu = masterMenu.superMenu();
			masterMenu = candidateMenu);

			masterLocation = masterMenu.window().frame().origin;
			destinationPoint.x = masterLocation.x + vector.x;
			destinationPoint.y = masterLocation.y + vector.y;

			masterMenu.nestedSetFrameOrigin(destinationPoint);
		}
	}

	//! should be pte
	public function ownedByPopUp():Boolean {
		return m_popUpButtonCell != null;
	}

	private function setOwnedByPopUp(popUp:NSPopUpButtonCell):Void {
		if (m_popUpButtonCell != popUp) {
			m_popUpButtonCell = popUp;
			if (popUp != null) {
				m_window.setLevel(NSWindow.NSPopUpMenuWindowLevel);
			}
		}
		update();
	}

	//******************************************************
	//*              Describing the object
	//******************************************************

	/**
	 * Returns a string representation of the menu.
	 */
	public function description():String {
		return "NSMenu(title=" + m_title + ")";
	}

	//******************************************************
	//*                 NSObject Protocol
	//******************************************************

	public function isEqual(anObject:Object):Boolean {
		if (this == anObject) {
			return true;
		}
		if (anObject instanceof NSMenu) {
			if (!m_title == anObject.title()) {
				return false;
			}
			return itemArray().isEqual(anObject.itemArray());
		}
		return false;
	}

	//******************************************************
	//*                NSCopying Protocol
	//******************************************************

	public function copyWithZone():NSObject {
		var menu:NSMenu = (new NSMenu()).initWithTitle(m_title);
		var i:Number;
		var count:Number = m_items.count();

		menu.setAutoenablesItems(m_autoenable);
		for (i = 0; i < count; i++) {
			// This works because the copy on NSMenuItem sets the menu to null!!!
			menu.insertItemAtIndex
			(m_items.objectAtIndex(i).copyWithZone(), i);
		}

		return menu;
	}

	//******************************************************
	//*                Helper methods
	//******************************************************

	private function locationKey():String {
		if (m_superMenu == null) {
			return title();
		} else {
			return ((m_superMenu.locationKey()) + g_delimeter + title());
		}
	}

	public function setGeometry():Void {
		var key:String;
		var defaults:NSUserDefaults;
		var menuLocations:NSDictionary;
		var location:NSRect;

		var origin:NSPoint;
		var value:Number;

		origin = NSPoint.ZeroPoint;

		/*NSScreen.mainScreen().frame().size.height*/
		//Stage.height - m_window.frame().size.height);

		if (null != (key = locationKey())) {
			defaults = NSUserDefaults.standardUserDefaults();
			menuLocations = NSDictionary(defaults.objectForKey(NSMenuLocationsKey));

			if (NSDictionary(menuLocations)!=null) {
				location = NSRect(menuLocations.objectForKey(key));
			} else {
				location = null;
			}

			if (location && NSRect(location)!=null) {
				origin = NSPoint(location.origin.copy());
			}
		}
		m_window.setFrameOrigin(origin);
	}

	/**
	 * Create a non autorelease window for this menu.
	 */
	private function createWindow():NSWindow {
		var win:NSMenuPanel = NSMenuPanel((new NSMenuPanel()).
		initWithContentRectStyleMask(new NSRect(0, 0, 0, 0), NSWindow.NSBorderlessWindowMask));
		win.setLevel(NSWindow.NSSubmenuWindowLevel);
		win.setWorksWhenModal(false);
		win.setBecomesKeyOnlyIfNeeded(true);
		win.rootView().setHasShadow(true);

		return NSWindow(win);
	}

	/**
	 * Will track the mouse movement. It will trigger the updating of the user
	 * defaults in due time.
	 */
	private function menuMoved(notification:NSNotification):Void {
		var resend:NSNotification;

		resend = NSNotification.withNameObject
		(NSEnqueuedMenuMove, this);
		/*
		[NSNotificationQueue.defaultQueue()
			enqueueNotification: resend
			postingStyle: NSPostASAP
			coalesceMask: NSNotificationCoalescingOnSender
			forModes:	NSArray.arrayWithObject(NSDefaultRunLoopMode]);*/
	}

	/**
	 * Save the current menu position in the standard user defaults
	 */
	private function updateUserDefaults(notification:NSNotification):Void {
		var key:String;

		trace(asDebug("Synchronizing user defaults"));
		key = locationKey();

		if (key != null) {
			var defaults:NSUserDefaults;
			var menuLocations:NSDictionary;
			var loc:NSRect;

			defaults	= NSUserDefaults.standardUserDefaults();
			menuLocations = defaults.dictionaryForKey(NSMenuLocationsKey);

			if (NSDictionary(menuLocations)==null) {
				menuLocations = null;
			}
			if (m_window.isVisible() &&
			(m_app.mainMenu() == this)) {
				if (menuLocations == null) {
					menuLocations = new NSDictionary();
				}
				loc = window().frame();
				menuLocations.setObjectForKey(loc, key);
			} else {
				menuLocations.removeObjectForKey(key);
			}

			if (menuLocations.count() > 0) {
				defaults.setObjectForKey(menuLocations, NSMenuLocationsKey);
			} else {
				defaults.removeObjectForKey(NSMenuLocationsKey);
			}
			defaults.synchronize();
		}
	}

	private function rightMouseDisplay(theEvent:NSEvent):Void {
		//display transient stuff
	}

	private function validateRootMenu(n:NSNotification):Void {
		var menu:NSMenu;

		var wnd:NSWindow = NSWindow(n.object);
		//ask delegate
		var obj:Object = wnd.delegate();
		var sel:String = "menuForMainWindow";
		if(ASUtils.respondsToSelector(obj, sel)) {
			menu = obj[sel].call(obj, wnd);
		}

		if(menu) {
			trace(menu.title());
			m_app.setMainMenu(menu);
			menu.display();
		}
		//TODO ask validators
	}
}
