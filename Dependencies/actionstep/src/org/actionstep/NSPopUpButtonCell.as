/* See LICENSE for copyright and terms of use */

import org.actionstep.menu.NSMenuItemCell;
import org.actionstep.NSMenu;
import org.actionstep.constants.NSRectEdge;
import org.actionstep.constants.NSPopUpArrowPosition;
import org.actionstep.NSArray;
import org.actionstep.NSMenuItem;
import org.actionstep.NSCell;
import org.actionstep.NSControl;

class org.actionstep.NSPopUpButtonCell extends NSMenuItemCell {
	//******************************************************
	//*                 Member variables
	//******************************************************

	private var m_menu:NSMenu;
	private var m_selectedItem:NSMenuItem;
	private var m_arrowPosition:NSPopUpArrowPosition;

	// Flags
	private var m_pullsDown:Boolean;
	private var m_autoenablesItems:Boolean;
	private var m_preferredEdge:NSRectEdge;
	private var m_usesItemFromMenu:Boolean;
	private var m_altersStateOfSelectedItem:Boolean;

	private var m_title:String;

	//******************************************************
	//*                  Construction
	//******************************************************

	public function init():NSPopUpButtonCell {
		return initTextCellPullsDown("", false);
	}

	public function initTextCellPullsDown(itemName:String, f:Boolean):NSPopUpButtonCell {
		super.initTextCell(itemName);
		setPullsDown(f);
		setMenu((new NSMenu()).initWithTitle(""));
		setUsesItemFromMenu(true);

		if(itemName!="") {
			addItemWithTitle(itemName);
		}

		return this;
	}

	//******************************************************
	//*                  Adding Items
	//******************************************************

	public function addItemWithTitle(name:String):Void {
		insertItemWithTitleAtIndex(name, m_menu.numberOfItems());
	}

	public function addItemsWithTitles(arr:NSArray):Void {
		var i:Number = arr.count();
		while(i--) {
			addItemWithTitle(String(arr.objectAtIndex(i)));
		}
	}

	public function insertItemWithTitleAtIndex(title:String, n:Number):Void {
		var i:Number = indexOfItemWithTitle(title);
		if(i!=-1) {
			removeItemAtIndex(i);
		}

		var count:Number = m_menu.numberOfItems();

		if(n<0) {
			n = 0;
		}
		if(n>count) {
			n = count;
		}

		var anItem:NSMenuItem = m_menu.addItemWithTitleActionKeyEquivalent
		(title, null, "", n);

		anItem.setOnStateImage(null);
		anItem.setOffStateImage(null);
		anItem.setMixedStateImage(null);
	}

	//******************************************************
	//*                  Removing Items
	//******************************************************

	public function removeAllItems():Void {
		selectItem(null);
		var i:Number = numberOfItems();
		while(i--) {
			m_menu.removeItemAtIndex(i);
		}
	}

	public function removeItemAtIndex(i:Number):Void {
		if(i==indexOfSelectedItem()) {
			selectItem(null);
		}
		m_menu.removeItemAtIndex(i);
	}

	public function removeItemWithTitle(title:String):Void {
		removeItemAtIndex(indexOfItemWithTitle(title));
	}

	//******************************************************
	//*                  Selecting Items
	//******************************************************

	public function selectedItem():NSMenuItem {
		return m_selectedItem;
	}

	public function selectItem(item:NSMenuItem):Void {
		if(item==m_selectedItem) {
			return;
		}

		if(m_selectedItem!=null && altersStateOfSelectedItem()) {
			m_selectedItem.setState(NSCell.NSOffState);
		}

		m_selectedItem = item;

		if(m_selectedItem!=null) {
			if(altersStateOfSelectedItem()) {
				m_selectedItem.setState(NSCell.NSOnState);
			}
			m_menu.menuRepresentation().setHighlightedItemIndex(m_menu.indexOfItem(item));
		}
	}

	public function selectItemAtIndex(n:Number):Void {
		selectItem(m_menu.itemAtIndex(n));
	}

	public function selectItemWithTag(n:Number):Void {
		selectItem(m_menu.itemWithTag(n));
	}

	public function selectItemWithTitle(title:String):Void {
		selectItem(m_menu.itemWithTitle(title));
	}

	public function titleOfSelectedItem():String {
		return m_selectedItem.title();
	}

	//******************************************************
	//*                  Retrieving Menu Items
	//******************************************************

	public function itemAtIndex(n:Number):NSMenuItem {
		return m_menu.itemAtIndex(n);
	}

	public function indexOfItem(item:NSMenuItem):Number {
		return m_menu.indexOfItem(item);
	}

	public function indexOfItemWithRepresentedObject(obj:Object):Number {
		return m_menu.indexOfItemWithRepresentedObject(obj);
	}

	public function indexOfItemWithTag(tag:Number):Number {
		return m_menu.indexOfItemWithTag(tag);
	}

	public function indexOfItemWithTargetAndAction
	(target:Object, action:String):Number {
		return m_menu.indexOfItemWithTargetAndAction(target, action);
	}

	public function indexOfItemWithTitle(title:String):Number {
		return m_menu.indexOfItemWithTitle(title);
	}

	public function indexOfSelectedItem():Number {
		return m_menu.indexOfItem(m_selectedItem);
	}

	public function itemTitleAtIndex(n:Number):String {
		return itemAtIndex(n).title();
	}

	public function itemTitles():NSArray {
		var x:Number = m_menu.numberOfItems();
		var items:NSArray = m_menu.itemArray();
		while(x--) {
			items.replaceObjectAtIndexWithObject(x, items.objectAtIndex(x).title());
		}

		return items;
	}

	public function itemWithTitle(title:String):NSMenuItem {
		return m_menu.itemWithTitle(title);
	}

	public function lastItem():NSMenuItem {
		return m_menu.itemAtIndex(m_menu.numberOfItems()-1);
	}

	//******************************************************
	//*                  Setting/getting Cell Attributes
	//******************************************************

	public function setMenu(menu:NSMenu):Void {
		m_menu = menu;
	}

	public function menu ():NSMenu {
		return m_menu;
	}

	public function setTitle(aString:String):Void{
		if (aString==null)	aString = "";

		m_title = aString;
	}

	public function title():String {
		return m_title;
	}

	public function setPullsDown(f:Boolean):Void {
		m_pullsDown = f;
	}

	public function pullsDown():Boolean {
		return m_pullsDown;
	}

	public function setAutoenablesItems(f:Boolean):Void {
		m_autoenablesItems = f;
	}

	public function autoenablesItems():Boolean {
		return m_autoenablesItems;
	}

	public function setUsesItemFromMenu(f:Boolean):Void {
		m_usesItemFromMenu = f;
	}

	public function usesItemFromMenu():Boolean {
		return m_usesItemFromMenu;
	}

	public function setAltersStateOfSelectedItem(f:Boolean):Void {
		m_altersStateOfSelectedItem = f;
	}

	public function altersStateOfSelectedItem():Boolean {
		return m_altersStateOfSelectedItem;
	}

	public function setPreferredEdge(f:NSRectEdge):Void {
		m_preferredEdge = f;
	}

	public function preferredEdge():NSRectEdge {
		return m_preferredEdge;
	}

	public function itemArray():NSArray {
		return m_menu.itemArray();
	}

	public function numberOfItems():Number {
		return m_menu.numberOfItems();
	}

	//******************************************************
	//*                  Synchronizing with NSMenuItem Instances
	//******************************************************

	public function synchronizeTitleAndSelectedItem():Void {
		var index:Number;

		if(!m_usesItemFromMenu) {
			return;
		}
		if(m_menu.numberOfItems() == 0) {
			index = -1;
		} else if (m_pullsDown) {
			index = 0;
		} else {
			index = m_menu.menuRepresentation().highlightedItemIndex();

			if(index<0) {
				index = indexOfSelectedItem();
				index = (index<0) ? 0 : index;
			}
		}

		if((index >=0) && (m_menu.numberOfItems() > index)) {
			setMenuItem(m_menu.itemAtIndex(index));
		} else {
			setMenuItem(null);
		}

		if(m_controlView!=null && (m_controlView instanceof NSControl)) {
			NSControl(m_controlView).updateCell();
		}
	}
}