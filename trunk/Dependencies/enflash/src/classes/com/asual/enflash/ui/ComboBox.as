import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.ListItem;

class com.asual.enflash.ui.ComboBox extends Button {

	private var _list:ListBox;
	private var _selectedItem:ListItem;
	private var _size:Number;
	private var _open:Boolean = false;
	private var _name:String = "ComboBox";
	
	public var onchange:Function;

	public function ComboBox(id) {
		super(id);
		_swf = "combobox.swf";
		_w = 12;
	}

	public function open():Void {

		_open = true;

		_list.x = _ui.getX(this);
		
		var ny = _ui.getY(this) + _ph - 1;
		if (ny + _list.ph > _ui.h) {
			ny = _ui.getY(this) + 1 - _list.ph;
		}
		
		_list.y = ny;

		if (_over) {
			_asset.setDownOver();
		} else {
			_asset.setDown();			
		}		
	}

	public function close():Void {

		if (_enabled) {		

			_open = false;
			_list.x = -2000;
	
			if (_over) {
				_asset.setUpOver();
			} else {
				_asset.setUp();			
			}	
		}
	}

	public function get length():Number {
		return _list.length;
	}

	public function get size():Number {
		return _size;
	}

	public function set size(size:Number):Void {
		_size = size;
		_list.size = _size;	
	}

	public function get selectedItem():ListItem {
		return _selectedItem;
	}

	public function set selectedItem(selectedItem:ListItem):Void {
		_selectedItem = selectedItem;
		_list.selectedItem = _selectedItem;
	}

	public function get selectedIndex():Number {
		return _list.selectedIndex;
	}

	public function set selectedIndex(selectedIndex:Number):Void {
		_list.selectedIndex = selectedIndex;
	}

	public function getItem(index:Number):ListItem {
		return _list.getItem(index);
	}

	public function addItem(item:ListItem):ListItem {
		item = _list.addItem(item);
		if (_list.length == 1) {
			_selectedItem = item;
			_list.selectedItem = item;
		}
		return item;
	}

	public function addItemAt(index:Number, item:ListItem):ListItem {
		item = _list.addItemAt(index, item);
		if (_list.length == 1) {
			_selectedItem = item;
			_list.selectedItem = item;
		}
		return item;
	}

	public function removeItem(item:ListItem):Void {
		_list.removeItem(item);
	}

	public function removeItemAt(index:Number, item:ListItem):Void {
		_list.removeItemAt(index, item);
	}
	
	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);

		align = "left";
		_padding = {top: .2, right: .3, bottom: .2, left: .3};

		_list = new ListBox();
		_list.comboBox = this;
		_list.focusable = false;
		_list.addEventListener("load", this, _compLoad);
		_list.addEventListener("change", this, _listChange);
		
		if (_size != undefined) {
			_list.size = _size;	
		}
		_ui.addComboList(_list);	
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (_swf == "combobox.swf") {
			delete xml.firstChild.attributes.swf;
		}
		if (_padding.top == .2 && _padding.bottom == .2 && _padding.left == .3){
			delete xml.firstChild.attributes.padding;
		}		
		if (xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}
		if (_size != undefined) {
			xml.firstChild.attributes.size = _size;
		}
		
		var listXML = _list.getXML();
		var node;
		var i:Number = -1;
		var iMax:Number = listXML.firstChild.childNodes.length;
		
		while(++i != iMax) {
			node = listXML.firstChild.childNodes[i];
			node.firstChild.nodeName = "ComboItem";
			xml.firstChild.appendChild(node.firstChild);
		}
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
	
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}
		if (xml.attributes.size != undefined) {
			size = xml.attributes.size;
		}	
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			addItem(new ListItem(xml.childNodes[i].attributes.id)).setXML(xml.childNodes[i]);
		}

		super._setXML(xml);
	}

	private function _load():Void {

		_padding.right = _ui.theme.scroll + _ui.pixel2zoom(_ui.theme.space) + .2;
		_setValue(_selectedItem.value);
		_labelResize();		
		super._load();
	}

	private function _uiZoom():Void {

		_padding.right = _ui.theme.scroll + _ui.pixel2zoom(_ui.theme.space) + .2;
		super._uiZoom();
	}
	
	private function _compLoad(evt:Object):Void {
			
		if (_list.loaded) {
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
	}

	private function _listChange(evt:Object):Void {
		if(_enabled) {
			if (_selectedItem != evt.selectedItem) {
				_selectedItem = evt.selectedItem;
				dispatchEvent("change", _selectedItem);
			}
			close();
			_setValue(evt.selectedItem.value);
		}
	}

	private function _setSize(w:Number, h:Number):Void {

		super._setSize(w, h);

		_list.minWidth = w;
		_list.w = w;
		if (_size == undefined) {
			_list.size = _list.length;
		}
	}

	private function _setValue(value:String):Void {
		
		if (value == selectedItem.value) {
			super._setValue(value);
		} else {
			var i:Number = -1;
			var iMax:Number = _list.length;
			while(++i != iMax) {
				if (value == _list.getItem(i).value) {
					selectedIndex = i;
					return;
				}
			}
		}
	}

	private function _mcRollOver(evt:Object):Void {
		
		super._mcRollOver(evt);
		
		if (Key.isDown(Key.TAB) && !_asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
			return;	
		}
				
		if (_open) {
			_asset.setDownOver();
		} else {
			_asset.setUpOver();			
		}
		
	}

	private function _mcRollOut(evt:Object):Void {
		
		super._mcRollOut(evt);

		if (_open) {
			_asset.setDown();
		} else {
			_asset.setUp();			
		}
	}

	private function _mcPress(evt:Object):Void {
		
		super._mcPress(evt);

		if (_open){
			close();
		} else {
			open();			
		}
	}

	private function _mcRelease(evt:Object):Void {
		
		super._mcRelease(evt);

		if (_open){
			if (_over) {
				_asset.setDownOver();
			} else {
				_asset.setDown();
			}
		}
	}

	private function _mcDragOut(evt:Object):Void {
		
		super._mcDragOut(evt);
		
		if (_open){
			_asset.setDown();
		} else {
			_asset.setUp();
		}
	}

	private function _mcReleaseOutside(evt:Object):Void {
		
		super._mcReleaseOutside(evt);
		
		if (_open){
			_asset.setDown();
		} else {
			_asset.setUp();
		}
	}

	private function _keyDown():Void {

		if (Key.getCode() == Key.UP) {
			_list.selectedIndex -= 1; 
		}

		if (Key.getCode() == Key.DOWN) {
			_list.selectedIndex += 1; 
		}
	}

	private function _remove():Void {
		
		_list.removeEventListener("load", this);
		_list.removeEventListener("change", this);
		_ui.removeComboList(_list).remove();

		super._remove();
	}
}