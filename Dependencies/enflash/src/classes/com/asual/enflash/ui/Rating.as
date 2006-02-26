import com.asual.enflash.data.List;

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;

import com.asual.enflash.utils.MovieClips;

class com.asual.enflash.ui.Rating extends Component {
	
	private var _size:Number = 5;
	private var _value:Number = 0;
	private var _over:Boolean = false;
	private var _selectedItem:Button;
	private var _items:List;
	private var _name:String = "Rating";

	public function Rating(id:String) {
		super(id);
		_host = true;
		_focusable = true;
		_items = new List();
	}

	public function get size():Number {
		return _size;
	}

	public function set size(size:Number):Void {

		if (_size > 2) { 

			_size = size;
			
			var items = _items.removeAll(false);
			var i = items.length;
			while(i--) {
				items[i].removeEventListener("load", this);
				items[i].removeEventListener("press", this);
				items[i].removeEventListener("rollover", this);
				items[i].removeEventListener("rollout", this);
				items[i].removeEventListener("dragout", this);			
				items[i].remove();
			}

			var item;
			i = -1;
			while (++i != _size) {

				item = new Button();
				item.swf = "rating.swf";
				item.margin = 0;
				item.padding = 0;
				item.toggle = true;
				item.addEventListener("load", this, _compLoad);
				item.addEventListener("press", this, _itemPress);
				item.addEventListener("rollover", this, _itemRollOver);
				item.addEventListener("rollout", this, _itemRollOut);
				item.addEventListener("dragout", this, _itemRollOut);
				
				item.init(_ref, _mc);

				_items.addItem(item);
			}
		}
	}

	public function get value():Number {
		return _value;
	}

	public function set value(value:Number):Void {
		_value = value;
		_itemSelect(_items.getItem(Math.round((_value/100)*_size) - 1));
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);
		_items.init(_ref);
		size = _size;
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();	
		if (_size != 5) {
			xml.firstChild.attributes.size = _size;
		}
		xml.firstChild.attributes.value = _value;
	
		if (toString() == "Rating" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Rating" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}
		if (xml.attributes.size != undefined) {
			size = Number(xml.attributes.size);
		}
	
		super._setXML(xml);
	}
	
	private function _uiZoom(evt:Object):Void {

		_itemSize();
		super._uiZoom();

	}

	private function _load():Void {

		_itemSelect(_items.getItem(Math.round((_value/100)*_size) - 1));
		_setEnabled(_enabled);
		_itemSize();

		super._load();
	}

	private function _itemSize():Void {
		
		var item, size;
		var w = 0;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while (++i != iMax) {
			size = (.6 + .8/_size*(i+1))*_ui.labelHeight;
			w += size + .5;
			item = _items.getItem(i);
			item.setSize(size, size);
		}
		_setSize(w + padding.left + padding.right - .5, size + padding.top + padding.bottom);
	}

	private function _itemSelect(selectedItem:Button):Void {

		_selectedItem.tabIndex = null;
		_selectedItem.focusable = false;

		_selectedItem = selectedItem;
		_selectedItem.focusable = _focusable;
		_selectedItem.tabIndex = _tabIndex;
			
		var index = _items.getIndex(_selectedItem);
		_value = (index + 1)*100/_size;

		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while (++i != iMax) {
			item = _items.getItem(i);
			if (i > index) {
				item.selected = false;
			} else {
				item.selected = true;
			}
		}

		if (_over) {
			_itemRollOver({target: _selectedItem});
		}
	}

	private function _itemPress(evt:Object):Void {
		_itemSelect(evt.target);
	}

	private function _itemRollOver(evt:Object):Void {
		
		var item;
		var i:Number = -1;
		var iMax:Number = _items.getIndex(evt.target);
		while (++i != iMax) {
			item = _items.getItem(i);
			if (item.selected) {
				item.asset.setDownOver();
			} else {
				item.asset.setUpOver();
			}
		}
		_over = true;
	}

	private function _itemRollOut(evt:Object):Void {
		
		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while (++i != iMax) {
			item = _items.getItem(i);
			if (item.selected) {
				item.asset.setDown();
			} else {
				item.asset.setUp();
			}
		}
		_over = false;
	}

	private function _compLoad(evt:Object):Void {

		var i:Number = -1;
		while (++i != _items.length) {
			if (!_items.getItem(i).loaded) return;
		}

		switch (_status) {
			case 0:
				_status = 2;
				break;
			case 1:
				_status = 3;
				_load();
				break;
		}

		_itemSize();
	}

	private function _setSize(w:Number, h:Number):Void {

		var item;
		var space = _zoom2pixel(.5);
		var nw = 0;
		var i:Number = -1;
		while (++i != _size) {
			item = _items.getItem(i);
			item.x = nw;
			item.y = (_ph - item.ph)/2;
		
			item.asset.clear();
			item.asset.beginFill(0x000000, 0);
			MovieClips.simpleRect(item.asset, 0, 0, item.pw + space, item.ph);
			item.asset.endFill();

			nw += item.pw + space;

		}

		super._setSize(w, h);
	}
	
	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		_selectedItem.tabIndex = _tabIndex;
	}

	private function _setEnabled(enabled:Boolean):Void {

		_enabled = enabled;

		var i:Number = -1;
		while (++i != _size) {
			_items.getItem(i).enabled = _enabled;
		}
	}
	
	private function _setFocusable(focusable:Boolean):Void {
		_focusable = focusable;
	}

	private function _setFocus(assetFocus:Boolean):Void {
		_selectedItem.focus(assetFocus);
	}
	
	private function _remove():Void {

		var items = _items.removeAll(false);
		var i = items.length;
		while(i--) {
			items[i].removeEventListener("load", this);
			items[i].removeEventListener("press", this);
			items[i].removeEventListener("rollover", this);
			items[i].removeEventListener("rollout", this);
			items[i].removeEventListener("dragout", this);			
			items[i].remove();
		}
		
		super._remove();	
	}
		
}