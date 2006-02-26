import com.asual.enflash.data.List;

import com.asual.enflash.ui.Bar;
import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Menu;

import com.asual.enflash.utils.Strings;

class com.asual.enflash.ui.MenuBar extends Bar {
	
	private var _selected:Button;
	private var _selectedMenu:Menu;
	private var _menus:List;
	private var _name:String = "MenuBar";
	
	public function MenuBar(id:String) {
		super(id);
		_menus = new List();
		_selected = null;
		_selectedMenu = null;
	}

	public function addItem(menu:Menu):Menu {

		var menuButton = new Button();
		menuButton.swf = "menubaritem.swf";
		menuButton.margin = 0;
		menuButton.padding = {top:0, right:.4, bottom:0, left:.4};
		menuButton.addEventListener("rollover", this, _btnRollOver);
		menuButton.addEventListener("rollout", this, _btnRollOut);
		menuButton.addEventListener("press", this, _btnPress);
		menuButton.addEventListener("release", this, _btnRelease);
		menuButton.addEventListener("releaseoutside", this, _btnReleaseOutside);
		menuButton.addEventListener("dragout", this, _btnDragOut);
		super.addItem(menuButton);
				
		var item = (menu == undefined) ? new Menu() : menu;
		item.menuParent = menuButton;
		item.addEventListener("open", this, _menuOpen);
		item.addEventListener("close", this, _menuClose);
		
		_ui.addMenu(item);
		_menus.addItem(item);
		
		return item;
	}


	public function addItemAt(index:Number, menu:Menu):Menu {
		
		var menuButton = new Button();
		menuButton.swf = "menubaritem.swf";
		menuButton.margin = 0;
		menuButton.padding = {top:0, right:.4, bottom:0, left:.4};
		menuButton.addEventListener("rollover", this, _btnRollOver);
		menuButton.addEventListener("rollout", this, _btnRollOut);
		menuButton.addEventListener("press", this, _btnPress);
		menuButton.addEventListener("release", this, _btnRelease);
		menuButton.addEventListener("releaseoutside", this, _btnReleaseOutside);
		menuButton.addEventListener("dragout", this, _btnDragOut);
		super.addItemAt(index, menuButton);
				
		var item = (menu == undefined) ? new Menu() : menu;
		item.menuParent = menuButton;
		item.addEventListener("open", this, _menuOpen);
		item.addEventListener("close", this, _menuClose);
		
		_ui.addMenu(item);
		_menus.addItemAt(index, item);
		
		return item;		
	}

	public function removeItem(value:String):Void {
		
		var menuButton = _items.getItemByProperty("value", value);	
		var menuIndex = _items.getIndex(menuButton);
	
		menuButton.removeEventListener("rollover", this);
		menuButton.removeEventListener("rollout", this);
		menuButton.removeEventListener("press", this);
		menuButton.removeEventListener("release", this);
		menuButton.removeEventListener("releaseoutside", this);
		menuButton.removeEventListener("dragout", this);	
	
		super.removeItem(menuButton);

		var menu = _menus.getItem(menuIndex);
		menu.removeEventListener("close", this);
		_menus.removeItemAt(menuIndex);
		_ui.removeMenu(menu);
	}

	public function removeItemAt(index:Number):Void {

		var menuButton = _items.getItem(index);
		
		menuButton.removeEventListener("rollover", this);
		menuButton.removeEventListener("rollout", this);
		menuButton.removeEventListener("press", this);
		menuButton.removeEventListener("release", this);
		menuButton.removeEventListener("releaseoutside", this);
		menuButton.removeEventListener("dragout", this);	

		super.removeItemAt(index);

		var menu = _menus.getItem(index);
		menu.removeEventListener("close", this);
		_menus.removeItemAt(index);
		_ui.removeMenu(menu);
	}

	public function getItem(index:Number):Menu {
		return _menus.getItem(index);
	}

	public function getItemByValue(value:String):Menu {
		var i:Number = _items.length;
		while(i--) {
			if (Strings.removeHTML(_items.getItem(i).value) == value) {
				return _menus.getItem(i);
			}
		}
	}
	
	public function moveLeft():Void {
		
		if (_items.length > 1) {
			
			var prev:Button = _items.getPreviousItem(_selected, true);

			_closeSelected();
			
			if (!prev.enabled) {
				_selected = prev;
				moveLeft();
				return;
			}

			_openSelected(prev);			
			_selectedMenu.moveDown();
		}
	}

	public function moveRight():Void {
		
		if (_items.length > 1) {

			var next:Button = _items.getNextItem(_selected, true);

			_closeSelected();

			if (!next.enabled) {
				_selected = next;
				moveRight();
				return;
			}
			
			_openSelected(next);
			_selectedMenu.moveDown();
		}	
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();

		while(xml.firstChild.hasChildNodes()) {
			xml.firstChild.firstChild.removeNode();	
		}
		
		var i:Number = -1;
		var iMax:Number = _menus.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_menus.getItem(i).getXML());
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
		
		var item;
		var menu;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			addItem(new Menu(item.attributes.id)).setXML(item);
		}
		super._setXML(xml);
	}
	
	private function _btnRollOver(evt:Object):Void {
		if (_selected != null && _selected != evt.target){
			_closeSelected();
			_openSelected(evt.target);
		}
		if (evt.target == _selected){
			evt.target.selected = true;
		}	
	}

	private function _btnRollOut(evt:Object):Void {
		
		if (evt.target == _selected){
			evt.target.selected = true;
		}	
	}

	private function _btnPress(evt:Object):Void {
		if (_selected == null){
			_openSelected(evt.target);
		} else {
			var selected = _selected;
			_closeSelected();
			selected.asset.setDownOver();
		}	
	}

	private function _btnRelease(evt:Object):Void {
		if (evt.target == _selected){
			evt.target.selected = true;
		}	
	}

	private function _btnReleaseOutside(evt:Object):Void {
		if (evt.target == _selected){
			evt.target.selected = true;
		}		
	}

	private function _btnDragOut(evt:Object):Void {
		if (evt.target == _selected){
			evt.target.selected = true;
		}	
	}

	private function _menuOpen(evt:Object):Void {

		var menuButton = evt.target.menuParent;
		if (_selected == menuButton) return;

		if (_selected != null && _selected != menuButton){
			_closeSelected();
		}
		
		_openSelected(menuButton);
		_selectedMenu.moveDown();		
	}

	private function _menuClose(evt:Object):Void {
		_selected.selected = false;
		_selectedMenu = null;
		_selected = null;
	}

	private function _openSelected(menuButton):Void {

		_selected = menuButton;		
		_selected.selected = true;
		
		var x = _ui.getX(_selected);
		var y = _ui.getY(_selected) + _selected.ph - 1;
		var altx = _ui.getX(_selected) + menuButton.pw;
		var alty = _ui.getY(_selected) + 1;
		
		_selectedMenu = _menus.getItem(_items.getIndex(_selected));
		_selectedMenu.open(x, y, altx, alty);
	}

	private function _closeSelected():Void {
		
		_selected.selected = false;
		_selected.asset.setUp();
		_selected = null;

		_selectedMenu.close();
		_selectedMenu = null;
	
	}
	
}