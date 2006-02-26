/* See LICENSE for copyright and terms of use */

import org.actionstep.menu.ASMenuSeparator;
import org.actionstep.NSCell;
import org.actionstep.NSEvent;
import org.actionstep.NSException;
import org.actionstep.NSImage;
import org.actionstep.NSMenu;
import org.actionstep.NSObject;
import org.actionstep.NSUserDefaults;

/**
 * An item in an <code>NSMenu</code>.
 *
 * @author Tay Ray Chuan
 */
class org.actionstep.NSMenuItem extends NSObject {
	/**
	 * Exceptions are thrown if usage of state images or key equivalents is
	 * attempted.
	 */
	private static var g_rootHasNoStateException:NSException;
	private static var g_rootHasNoKeyEquivalent:NSException;
	private static var g_menuHasNoKeyEquivalent:NSException;

	private static var g_usesUserKeyEquivalents:Boolean = false;

	private var m_keyEquivalentModifierMask:Number;
	private var	m_keyEquivalent:String;
	private var	m_mnemonicLocation:Number;
	private var	m_state:Number;
	private var	m_enabled:Boolean;
	private var	m_action:String;
	private var	m_target:Object;
	private var	m_tag:Number;
	private var	m_representedObject:Object;
	private var	m_title:String;
	private var	m_changesState:Boolean;

	//Menus
	private var	m_menu:NSMenu;
	private var	m_submenu:NSMenu;

	//Images
	private var	m_image:NSImage;
	private var	m_onStateImage:NSImage;
	private var	m_offStateImage:NSImage;
	private var	m_mixedStateImage:NSImage;

	public static function setUsesUserKeyEquivalents(flag:Boolean):Void {
		g_usesUserKeyEquivalents = flag;
	}

	public static function usesUserKeyEquivalents():Boolean {
		return g_usesUserKeyEquivalents;
	}

	/**
	* Returns a separator.
	* This is just a blank menu item which serves to divide the menu into separate parts.
	*/
	public static function separatorItem ():NSMenuItem {
		return (new ASMenuSeparator()).init();
	}

	public function NSMenuItem() {
		if(g_rootHasNoStateException==null) {
			g_rootHasNoStateException = NSException.exceptionWithNameReasonUserInfo
			("ASRootMenuException", "Root menu cannot display state", null);

			g_rootHasNoKeyEquivalent = NSException.exceptionWithNameReasonUserInfo
			("ASRootMenuException", "Root menu cannot display key equivalent", null);

			g_menuHasNoKeyEquivalent = NSException.exceptionWithNameReasonUserInfo
			("ASRootMenuException", "Menu with submenus cannot display key equivalent", null);
		}
	}

	public function init():NSMenuItem {
		return initWithTitleActionKeyEquivalent("", null, "");
	}

	public function initWithTitleActionKeyEquivalent(aString:String, aSelector:String, charCode:String):NSMenuItem {
		setTitle(aString);
		setKeyEquivalent(charCode);
		m_keyEquivalentModifierMask = NSEvent.NSCommandKeyMask;
		m_mnemonicLocation = 255; // No mnemonic
		m_state = NSCell.NSOffState;
		m_enabled = true;
		// Set the images according to the spec. On: check mark; off: dash.
		setOnStateImage(NSImage.imageNamed("NSMenuItemOnState"));
		setMixedStateImage(NSImage.imageNamed("NSMenuItemMixedState"));
		setOffStateImage(NSImage.imageNamed("NSMenuItemOffState"));
		m_action = aSelector;
		return this;
	}

	public function setMenu(menu:NSMenu):Void {
		m_menu = menu;
		if(menu.isRoot() && m_keyEquivalent!="") {
			trace(asWarning("clearing key equivalent..."));
			m_keyEquivalent = "";
		}
		if (m_submenu != null) {
			m_submenu.setSupermenu(menu);
			setTarget(m_menu);
		}
	}

	public function menu ():NSMenu {
		return m_menu;
	}

	public function hasSubmenu():Boolean {
		return !(m_submenu == null);
	}

	public function setSubmenu(submenu:NSMenu):Void {
		if (submenu.superMenu() != null) {
			var e:NSException = NSException.exceptionWithNameReasonUserInfo
			(NSException.NSInvalidArgument,
			"submenu ("+submenu.title()+") already has superMenu ("+submenu.superMenu().title()+")",
			null);
			trace(e);
			e.raise();
		}
		setKeyEquivalent("", true);
		m_submenu = submenu;
		if (submenu != null) {
			submenu.setSupermenu(m_menu);
			submenu.setTitle(m_title);
		}
		setTarget(m_menu);
		setAction("submenuAction");
		m_menu.itemChanged(this);
	}

	public function submenu():NSMenu {
		return m_submenu;
	}

	public function setTitle(aString:String):Void{
		if (aString==null)	aString = "";

		m_title = aString;
		m_menu.itemChanged(this);
	}

	public function title():String {
		return m_title;
	}

	public function isSeparatorItem():Boolean {
		return false;
	}

	//! TODO document toClear
	public function setKeyEquivalent(aKeyEquivalent:String, toClear:Boolean):Void {
		if(m_menu.isRoot() && toClear!=true) {
			trace(g_rootHasNoKeyEquivalent);
			throw g_rootHasNoKeyEquivalent;
		}
		if(hasSubmenu()) {
			trace(g_menuHasNoKeyEquivalent);
			throw g_menuHasNoKeyEquivalent;
		}
		if (aKeyEquivalent == null) {
			aKeyEquivalent = "";
		}

		m_keyEquivalent = aKeyEquivalent;
		m_menu.itemChanged(this);
	}

	public function keyEquivalent():String {
		if (usesUserKeyEquivalents()) {
			return userKeyEquivalent();
		} else {
			return m_keyEquivalent;
		}
	}

	public function setKeyEquivalentModifierMask(mask:Number):Void {
		m_keyEquivalentModifierMask = mask;

		m_menu.itemChanged(this);
	}

	public function keyEquivalentModifierMask():Number {
		return m_keyEquivalentModifierMask;
	}

	public function userKeyEquivalent():String {
		var userKeyEquivalent:String = //NSDictionary(
		NSUserDefaults.standardUserDefaults().
		persistentDomainForName("NSGlobalDomain").
		objectForKey("NSCommandKeys").
		objectForKey(m_title);
		/*NSString *userKeyEquivalent = [(NSDictionary*)[
							 objectForKey: @"NSCommandKeys"]
							objectForKey: _title];*/

		if ( userKeyEquivalent == null) {
			userKeyEquivalent = "";
		}

		return userKeyEquivalent;
	}

	public function userKeyEquivalentModifierMask():Number {
		return NSEvent.NSCommandKeyMask;
	}

	public function setMnemonicLocation(location:Number):Void {
		m_mnemonicLocation = location;
		m_menu.itemChanged(this);
	}

	public function mnemonicLocation():Number {
		if (m_mnemonicLocation != 255) {
			return m_mnemonicLocation;
		} else {
			return NSObject.NSNotFound;
		}
	}

	public function mnemonic():String {
		if (m_mnemonicLocation != 255) {
			//return m_title.substringWithRange(NSMakeRange(m_mnemonicLocation, 1));
			return m_title.substr(m_mnemonicLocation, 1);
		} else {
			return "";
		}
	}

	public function setTitleWithMnemonic(stringWithAmpersand:String):Void {
		var location:Number = stringWithAmpersand.indexOf("&");
		var f1:Array = stringWithAmpersand.split("&");

		setTitle(f1.join(""));		//removes "&"
		setMnemonicLocation(location);
	}

	public function setImage(image:NSImage):Void {
		m_image = (image==null) ? null : image;
		m_menu.itemChanged(this);
	}

	public function image():NSImage {
		return m_image;
	}

	public function setState(state:Number):Void {
		if(menu().isRoot()) {
			trace(g_rootHasNoStateException);
			throw g_rootHasNoStateException;
		}
		m_changesState = true;
		if (m_state == state) {
			return;
		}

		m_state = state;
		m_menu.itemChanged(this);
	}

	public function state():Number {
		return m_state;
	}

	/**
	 * AS-specific function.<br/>
	 * Returns the current state image.
	 */
	public function stateImage():NSImage {
		if(!m_changesState) {
			return null;
		}
		switch(m_state) {
		  case NSCell.NSOnState:
		    return onStateImage();
		  case NSCell.NSMixedState:
		    return mixedStateImage();
		  case NSCell.NSOffState:
		  default:
		    return offStateImage();
		}
	}

	public function setOnStateImage(image:NSImage):Void {
		if(menu().isRoot()) {
			trace(g_rootHasNoStateException);
			throw g_rootHasNoStateException;
		}
		m_onStateImage = (image==null) ? null : image;
		m_menu.itemChanged(this);
	}

	public function onStateImage():NSImage {
		return m_onStateImage;
	}

	public function setOffStateImage(image:NSImage):Void {
		if(menu().isRoot()) {
			trace(g_rootHasNoStateException);
			throw g_rootHasNoStateException;
		}
		m_offStateImage = (image==null) ? null : image;
		m_menu.itemChanged(this);
	}

	public function offStateImage():NSImage {
		return m_offStateImage;
	}

	public function setMixedStateImage(image:NSImage):Void {
		if(menu().isRoot()) {
			trace(g_rootHasNoStateException);
			throw g_rootHasNoStateException;
		}
		m_mixedStateImage = (image==null) ? null : image;
		m_menu.itemChanged(this);
	}

	public function mixedStateImage():NSImage {
		return m_mixedStateImage;
	}

	public function setEnabled(flag:Boolean):Void {
		if (flag == m_enabled) {
			return;
		}

		m_enabled = flag;
		m_menu.itemChanged(this);
	}

	public function isEnabled():Boolean {
		return m_enabled;
	}

	public function setTarget(anObject:Object):Void {
		if (m_target == anObject) {
			return;
		}

		m_target = anObject;
		m_menu.itemChanged(this);
	}

	public function target():Object {
		return m_target;
	}

	public function setAction(aSelector:String):Void {
		if (m_action == aSelector) {
			return;
		}

		m_action = aSelector;
		m_menu.itemChanged(this);
	}

	public function action():String {
		return m_action;
	}

	public function setTag(anInt:Number):Void {
		m_tag = anInt;
	}

	public function tag():Number {
		return m_tag;
	}

	public function setRepresentedObject(anObject:Object):Void {
		m_representedObject = anObject;
	}

	public function representedObject():Object {
		return m_representedObject;
	}

	public function setChangesState(n:Boolean):Void {
		m_changesState = n;
	}

	public function changesState():Boolean {
		return m_changesState;
	}

	public function description():String {
		return "NSMenuItem("+m_title+")";
	}
}