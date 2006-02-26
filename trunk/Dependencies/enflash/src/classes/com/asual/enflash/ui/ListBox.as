import com.asual.enflash.ui.ComboBox;
import com.asual.enflash.ui.ListItem;
import com.asual.enflash.ui.Pane;

class com.asual.enflash.ui.ListBox extends Pane {

	private var _selectedItem:ListItem;
	private var _size:Number = 5;
	private var _name:String = "ListBox";

	public var comboBox:ComboBox;

	public var onchange:Function;

	public function ListBox(id:String) {
		super(id);
		_minWidth = 12;
		_hScrollPolicy = "off";
	}
	
	public function addItem(item:ListItem):ListItem {
		item = (item != undefined) ? item : new ListItem();
		item.addEventListener("load", this, _compLoad);
		item.addEventListener("change", this, _itemChange);	
		item.addEventListener("value", this, _itemValue);	
		super.addItem(item);
		return item;
	}

	public function addItemAt(index:Number, item:ListItem):ListItem {
		item = (item != undefined) ? item : new ListItem();
		item.addEventListener("load", this, _compLoad);
		item.addEventListener("change", this, _itemChange);
		item.addEventListener("value", this, _itemValue);
		super.addItemAt(index, item);
		return item;
	}

	public function removeItem(item:ListItem):Void {
		item.removeEventListener("load", this);
		item.removeEventListener("change", this);
		item.removeEventListener("value", this);
		super.removeItem(item);
	}

	public function removeItemAt(index:Number):Void {
		var item = getItem(index);
		item.removeEventListener("load", this);
		item.removeEventListener("change", this);
		item.removeEventListener("value", this);
		super.removeItemAt(index);
	}
	
	public function get size():Number {
		return _size;
	}
	
	public function set size(size:Number):Void {
		_size = size;
	}	

	public function get selectedItem():ListItem {
		return _selectedItem;
	}

	public function set selectedItem(selectedItem:ListItem):Void {
		if (_selectedItem != selectedItem) {
			selectedItem.selected = true;
			dispatchEvent("change", selectedItem);
		}
	}

	public function get selectedIndex():Number {
		return _content.getIndex(_selectedItem);
	}

	public function set selectedIndex(selectedIndex:Number):Void {

		var selectedItem = _content.getItem(selectedIndex);
		if (_selectedItem != selectedItem) {
			selectedItem.selected = true;
			dispatchEvent("change", selectedItem);
		}
	}

	public function refresh():Void {
		super.refresh();
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}
		if (_size != 5) {
			xml.firstChild.attributes.size = _size;
		}
		if (toString() == "ListBox" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "ListBox" && xml.firstChild.attributes.padding == "0.1") {
			delete xml.firstChild.attributes.padding;
		}

		var i:Number = -1
		var iMax:Number = xml.firstChild.childNodes.length;
		while(++i != iMax) {
			delete xml.firstChild.childNodes[i].firstChild.attributes.onload;
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
	
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}
		if (xml.attributes.size != undefined) {
			size = Number(xml.attributes.size);
		}
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			addItem(new ListItem(xml.childNodes[i].attributes.id)).setXML(xml.childNodes[i]);
		}

		super._setXML(xml);
	}

	private function _setSize(w:Number, h:Number):Void {

		_scrollSize = _ui.theme.scroll;

		if (_autoSize.h && _content.getItem(0)) {
			
			var ih = _content.getItem(0).h;
			h = ih*_size + _pixel2zoom(_scrollSpace*2) + _padding.left + _padding.top;
			minHeight = h;
			
			ih = _zoom2pixel(ih);
			
			smallStep = ih;
			largeStep = ih;
		}
		
		super._setSize(w, h);

		_setItemsSize();

	}

	private function _compLoad(evt:Object):Void {

		var i = _content.length;
		while(i--) {

			if (!_content.getItem(i).loaded) {
				return;
			}
		}

		super._compLoad(evt);
	}

	private function _setItemsSize(flag:Boolean):Void {

		if (_ui.visible && _content.length > 0) {
		
			var w = _w - (padding.left + padding.right) - _pixel2zoom(_scrollSpace*2);

			if (_autoSize.h) {
				if (_vScroll.visible || _content.length > _size) {
					w = w - _scrollSize;
				}
			} else {
				if (_vScroll.visible || _content.h > _ph) {
					w = w - _scrollSize;
				}
			}

			var h = 0;
			var item;
			var i:Number = -1;
			var iMax:Number = _content.length;	
			while(++i != iMax) {
				item = _content.getItem(i);
				item.move(_zoom2pixel(padding.left), _zoom2pixel(h + padding.top));
				item.w = w;
				h += item.h;
			}
		}
	}

	private function _itemChange(evt:Object):Void {

		if (!evt.target.selected) return;

		if (evt.target != _selectedItem) {

			if (evt.target.selected) {

				_selectedItem = evt.target;

				var item;
				var i:Number = _content.length;
				while(i--) {
					item = _content.getItem(i);
					if (item != _selectedItem) {
						item.selected = false;
					}
				}
				if (_ui.visible && comboBox == undefined) {
					Selection.setFocus(_rect.movieclip);
				}
			}
			dispatchEvent("change", selectedItem);

		} else {
	
			if (!evt.target.selected) {
				evt.target.selected = true;
			}
		}
	}
	
	private function _itemValue(evt:Object):Void {
		if (_ui.loaded){
			if (selectedItem != evt.target) {
				dispatchEvent("change", selectedItem);
			}
		}
	}
}