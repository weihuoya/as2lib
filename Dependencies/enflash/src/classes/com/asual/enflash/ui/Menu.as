import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.MenuItem;

import com.asual.enflash.utils.Strings;
import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.Menu extends Component {
	
	private var _items:Collection;
	private var _rect:Button;
	private var _selected:MenuItem;
	private var _itemsShortcuts:Number = 0;
	private var _shortcut:String;
	private var _name:String = "Menu";
	private var _menuParent;
	private var _value:String;
	private var _keyNav:Boolean = false;

	public var onopen:Function;
	public var onclose:Function;
	public var onchange:Function;
	
	public function Menu(id:String) {
		super(id);
	}

	public function executeEnter():Void {

		if (_selected != null && _selected.menu == undefined) {
	
			if (_selected.type == "radio"){
				var item;
				var i = _items.length;
				while(i--){
					item = _items.getItem(i);
					if (item.group == _selected.group){
						item.checked = false;
					}
				}
				_selected.checked = true;
			} else if (_selected.type == "check"){
				_selected.checked = !_selected.checked;
			}

			Time.setTimeout(this, "dispatchEvent", 1, "change", _selected);
		}
	}
	
	public function open(x, y, altx, alty):Void {
		
		_setItemsSize();
		
		if (x == undefined) {
			x = _ui.movieclip._xmouse;
			y = _ui.movieclip._ymouse;
		}
		
		if (altx == undefined) {
			altx = x;
			alty = y;	
		}
		
		var nx = x;
		var ny = y;
		
		if (x + _pw > _ui.w) {
			nx = altx - _pw;
		}

		if (y + _ph > _ui.h) {
			ny = alty - _ph;
		}
		
		if (nx < 0) nx = x;
		if (ny < 0) ny = y;
		
		asset.setSize(_pw, _ph);

		move(nx, ny);
		visible = true;
		dispatchEvent("open");
	}

	public function close():Void {
		
		_selected.selected = false;
		_selected = null;

		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while(++i != iMax){
			item = _items.getItem(i);
			if (item.menu != undefined) item.menu.close();
		}		
		
		visible = false;
		move(-2000, y);
		dispatchEvent("close");
	}

	public function addSeparator():Component {

		var item = new Component();
		item.zoom = false;
		item.swf = "menuseparator.swf";
		item.margin = {top: 2, bottom: 2};
		item.h = 2;
		item.addEventListener("load", this, _compLoad);
		return _items.addItem(item);
	}
	
	public function addItem(item:MenuItem):MenuItem {
		
		item = (item != undefined) ? item : new MenuItem();
		item.addEventListener("release", this, _itemRelease);
		item.addEventListener("rollover", this, _itemRollOver);
		item.addEventListener("load", this, _compLoad);
		_items.addItem(item);
		return item;
	}

	public function addItemAt(index:Number, item:MenuItem):MenuItem {

		item = (item != undefined) ? item : new MenuItem();
		item.addEventListener("release", this, _itemRelease);
		item.addEventListener("rollover", this, _itemRollOver);
		item.addEventListener("load", this, _compLoad);
		_items.addItemAt(index, item);

		return item;
	}
	
	public function removeItem(item):Void {
		_items.removeItem(item);
	}
	
	public function removeItemAt(index):Void {
		_items.removeItemAt(index);
	}

	public function removeAll():Void{
		_items.removeAll();
	}

	public function getItem(index:Number):MenuItem {
		return _items.getItem(index);
	}

	public function getItemByValue(value:String):MenuItem {
		var i:Number = _items.length;
		while(i--) {
			if (Strings.removeHTML(_items.getItem(i).value) == value) {
				return _items.getItem(i);
			}
		}
	}
	
	public function moveUp():Void {

		_setKeyNav(true);

		var prev:MenuItem;

		if (_selected != null) {
			_selected.selected = false;
			prev = _items.getPreviousItem(_selected, true);
		} else {
			prev = _items.lastItem;			
		}

		_selected = prev;

		if (_selected.swf == "menuseparator.swf"){
			moveUp();
			return;
		}
		_selected.selected = true;

		Time.setTimeout(this, "_setKeyNav", 1000, false);

	}

	public function moveDown():Void {

		_setKeyNav(true);

		var next:MenuItem;

		if (_selected != null) {
			_selected.selected = false;
			next = _items.getNextItem(_selected, true);
		} else {
			next = _items.firstItem;
		}

		_selected = next;

		if (_selected.swf == "menuseparator.swf"){
			moveDown();
			return;
		}
		_selected.selected = true;

		Time.setTimeout(this, "_setKeyNav", 1000, false);
		
	}

	public function get value():String {
		return _value;
	}

	public function set value(value:String):Void {
		_value = value;
		_menuParent.value = _value;
		if (_shortcut != undefined) {
			_formatShortcut({shortcut:_shortcut});	
		}
	}
		
	public function get asset():MovieClip {
		return _rect.asset;
	}

	public function get keyNav():Boolean {
		return _keyNav;
	}

	public function get menuParent():Object {
		return _menuParent;
	}

	public function set menuParent(menuParent:Object):Void {
		_menuParent = menuParent;
	}
	
	public function get length():Object {
		return _items.length;
	}
	
	public function get selectedItem():Object {
		return _selected;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		padding = .1;

		_host = true;
				
		_rect = new Button();
		_rect.swf = "menu.swf";
		_rect.init(_ref, _mc);
		_rect.addEventListener("load", this, _compLoad);

		_items = new Collection();
		_items.init(_ref, _mc);
		
		visible = false;

		_ui.shortcutManager.addEventListener("format", this, _formatShortcut);
		_ui.shortcutManager.addEventListener("shortcut", this, _executeShortcut);

	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		
		delete xml.firstChild.attributes.visible;

		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}
		if (xml.firstChild.attributes.padding == "0.1") {
			delete xml.firstChild.attributes.padding;
		}
		if (xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (_value != undefined) {
			xml.firstChild.attributes.value = _value;
		}			
		if (_shortcut != undefined) {
			if (_menuParent.toString() == "Button") {
				var index1 = _menuParent.value.indexOf("<U>");
				var index2 = _menuParent.value.indexOf("</U>");
				xml.firstChild.attributes.shortcut = "Alt+" + _menuParent.value.substring(index1 + 3, index2);
			}
		}
		
		var item;
		var i = -1;
		var iMax = _items.length;
		while(++i != iMax) {
			item = _items.getItem(i);
			if (item.toString() == "Component") {
				xml.firstChild.appendChild(new XML("<Separator />"));
			} else {
				xml.firstChild.appendChild(item.getXML());
			}
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}
		if (xml.attributes.shortcut != undefined) {
			_ui.addShortcut(this, xml.attributes.shortcut);
		}
		if (xml.attributes.enabled != undefined) {
			enabled = (xml.attributes.enabled == "false") ? false : true;
		}

		var item;
		var i = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			if (item.nodeName == "Separator") {
				addSeparator();
			} else {
				addItem(new MenuItem(item.attributes.id)).setXML(item);
			}
		}
		
		super._setXML(xml);
		
	}
	
	private function _compLoad(evt:Object):Void {
		
		var i = _items.length;
		while(i--) {
			if (!_items.getItem(i).loaded) {
				return;
			}
		}
		
		if (!_rect.loaded) return;
		
		switch (_status) {
			case 0:
				_status = 2;
				break;
			case 1:
				_status = 3;
				_load();
				break;
		}
	}
	
	private function _uiZoom():Void {
		return;
	}

	private function _setSize(w:Number, h:Number):Void {
		
		if (_ui.visible) {
			_rect.setSize(w, h);
			_items.move(_zoom2pixel(_padding.left), _zoom2pixel(_padding.top));
			_items.setSize(_zoom2pixel(w - _padding.left - _padding.right), _zoom2pixel(h - _padding.top - _padding.bottom));
			super._setSize(w, h);
		}
	}

	private function _setItemsSize():Void {

		var space = _ui.theme.space;	
		
		var w:Number = 0;
		var h:Number = 0;
		
		var lw:Number = 0;
		var sw:Number = 0;
		
		var sl:Number = 0;
		var sr:Number = 0;
	
		var hasShortcut:Boolean = false;
		
		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		
		while(++i != iMax){
			
			item = _items.getItem(i);
			item.move(space, space + _zoom2pixel(h) + ((item.zoom) ? _zoom2pixel(item.margin.top) : item.margin.top));
				
			if (item.toString() == "MenuItem") {

				if (item.w > w){
					w = item.w;
				}
				if (item.label.pw > lw) {
					lw = item.label.pw;
				}

				if (item.shortcut != undefined) {
					hasShortcut = true;
					if (item.shortcutLabel.pw > sw) {
						sw = item.shortcutLabel.pw;
					}
					sl = item.shortcutLabel.margin.left;
					sr = item.padding.right;

				}

				h += item.h + item.margin.top + item.margin.bottom;
			
			} else {

				h += _pixel2zoom(item.h + item.margin.top + item.margin.bottom);
				
			}
			
		}
		
		if (hasShortcut) {
			w = _pixel2zoom(lw + sw) + _items.firstItem.padding.left + sl + sr;
		}
			
		i = -1;
		while(++i != iMax){
			
			item = _items.getItem(i);
			
			if (item.toString() == "MenuItem"){
				item.setSize(w, item.h);
			} else {
				item.setSize(_zoom2pixel(w), item.h);
			}
			
			if (item.shortcut != undefined) {
				item.shortcutLabel.x = lw + _zoom2pixel(_items.firstItem.padding.left + sl);
			}		
		}
	
		_setSize(w + _padding.left + _padding.right + _pixel2zoom(space*2), h + _padding.top + _padding.bottom + _pixel2zoom(space*2));
	
	}			

	private function _itemRelease(evt:Object):Void {

		if (evt.target.menu == undefined) {

			if (evt.target.type == "radio"){
				var item;
				var i = _items.length;
				while(i--){
					item = _items.getItem(i);
					if (item.group == evt.target.group){
						item.checked = false;
					}
				}
				evt.target.checked = true;
			} else if (evt.target.type == "check"){
				evt.target.checked = !evt.target.checked;
			}
			_ui.closeMenus();
			Time.setTimeout(this, "dispatchEvent", 1, "change", evt.target);
		} else {
			evt.target.menu.open();
		}
	}

	private function _itemRollOver(evt:Object):Void {

		if(_keyNav) return;

		_selected = evt.target;
		
		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while(++i != iMax){
			item = _items.getItem(i);
			if (item != _selected){
				item.selected = false;
			}
		}

		Time.setTimeout(this, "_closeMenus", 100);

		if (_menuParent.toString() == "MenuItem"){
			_menuParent["_mcRollOver"]();
			_menuParent.selected = true;
		}
		
	}

	private function _closeMenus(evt:Object):Void {

		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while(++i != iMax){
			item = _items.getItem(i);
			if (item != _selected && item.menu != undefined){
				item.menu.close();
			}
		}	
	}
	
	private function _setKeyNav(keyNav:Boolean):Void {
		_keyNav = keyNav;
	}

	private function _setEnabled(enabled:Boolean):Void {
		_enabled = enabled;
		menuParent.enabled = false;
	}	

	private function _formatShortcut(evt:Object):Void {
		
		_shortcut = evt.shortcut;
		
		if (_shortcut != undefined) {
		
			var keys = _shortcut.split("+");
			if (_menuParent.toString() == "Button") {
				_menuParent.value = Strings.replace(_menuParent.value, keys[1], "<u>" + keys[1] + "</u>", false, 1);		
			}
		
		} else {
			
			if (_menuParent.toString() == "Button") {
				var value = _menuParent.value;
				value = Strings.replace(value, "<u>", "", false);
				value = Strings.replace(value, "</u>", "", false);
				_menuParent.value = value;		
			}			
		} 
	}

	private function _executeShortcut():Void {
		open();
	}

	private function _remove():Void {
		_ui.removeShortcut(this);
		super._remove();
	}		
}
