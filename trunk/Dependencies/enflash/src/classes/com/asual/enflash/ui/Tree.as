import com.asual.enflash.ui.Pane;
import com.asual.enflash.ui.TreeItem;

class com.asual.enflash.ui.Tree extends Pane {

	private var _expandedIcon:String;
	private var _collapsedIcon:String;
	private var _leafIcon:String;
	private var _selectedItem:TreeItem;
	private var _name:String = "Tree";

	public var onchange:Function;

	public function Tree(id:String) {
		super(id);
		_focusable = true;
	}

	public function addItem(treeItem:TreeItem):TreeItem {
		var item = super.addItem((treeItem != undefined) ? treeItem : new TreeItem(this));
		item.addEventListener("change", this, _itemChange);
		item.addEventListener("remove", this, _itemRemove);
		if (_content.length == 1) item.selected = true;
		return item;
	}

	public function addItemAt(index:Number, treeItem:TreeItem):TreeItem {
		var item = super.addItemAt(index, (treeItem != undefined) ? treeItem : new TreeItem(this));
		item.addEventListener("change", this, _itemChange);
		item.addEventListener("remove", this, _itemRemove);
		if (_content.length == 1) item.selected = true;
		return item;
	}

	public function removeItem(treeItem:TreeItem):TreeItem {
		treeItem.removeEventListener("change", this);
		treeItem.removeEventListener("remove", this);
		var item = super.removeItem(treeItem);
		return item;
	}

	public function removeItemAt(index:Number):TreeItem {
		var treeItem = getItem(index);
		treeItem.removeEventListener("change", this);
		treeItem.removeEventListener("remove", this);
		return super.removeItemAt(index);
	}

	public function get expandedIcon():String {
		return _expandedIcon;
	}

	public function get collapsedIcon():String {
		return _collapsedIcon;
	}

	public function get leafIcon():String {
		return _leafIcon;
	}

	public function get selectedItem():TreeItem {
		return _selectedItem;
	}

	public function set selectedItem(selectedItem:TreeItem):Void {
		if (_selectedItem != selectedItem) {
			selectedItem.selected = true;
		}
	}

	public function get selectedIndex():Number {
		return _content.getIndex(_selectedItem);
	}

	public function set selectedIndex(selectedIndex:Number):Void {
		var selectedItem = _content.getItem(selectedIndex)
		if (_selectedItem != selectedItem) {
			selectedItem.selected = true;
		}
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (_expandedIcon != undefined) {
			xml.firstChild.attributes.expandedIcon = _expandedIcon;
		}
		if (_collapsedIcon != undefined) {
			xml.firstChild.attributes.collapsedIcon = _collapsedIcon;
		}
		if (_leafIcon != undefined) {
			xml.firstChild.attributes.leafIcon = _leafIcon;
		}
		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}

		if (toString() == "Tree" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Tree" && xml.firstChild.attributes.padding == "0.1") {
			delete xml.firstChild.attributes.padding;
		}

		while(xml.firstChild.hasChildNodes()) {
			xml.firstChild.firstChild.removeNode();
		}
		
		var i:Number = -1;
		var iMax:Number = _content.length;
		var item;
		while(++i != iMax) {
			item = _content.getItem(i);
			if (item.depth == 0) {
				xml.firstChild.appendChild(item.getXML());
			}
		}
	
		return xml;
	}
	
	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.expandedIcon != undefined) {
			_expandedIcon = xml.attributes.expandedIcon;
		}
		if (xml.attributes.collapsedIcon != undefined) {
			_collapsedIcon = xml.attributes.collapsedIcon;
		}
		if (xml.attributes.leafIcon != undefined) {
			_leafIcon = xml.attributes.leafIcon;
		}				
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}
		
		var item;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			addItem(new TreeItem(this, item.attributes.id)).setXML(item);
		}

		super._setXML(xml);
	}

	private function _setSize(w:Number, h:Number):Void {
		super._setSize(w, h);
		_setItemsSize();
	}

	private function _setItemsSize():Void {

		if (_ui.visible) {
		
			var w = contentWidth;
			
			if (w < _content.w) w = _content.w;
			w = _pixel2zoom(w) - (padding.left + padding.right);
	
			var h = 0;
			var item;
			var i:Number = -1;
			var iMax:Number = _content.length;	
			while(++i < iMax) {
				item = _content.getItem(i);
				item.move(_zoom2pixel(padding.left), _zoom2pixel(h + padding.top));
				item.asset.setSize(_zoom2pixel(w), _zoom2pixel(item.h));
				if (item.visible) {
					h += item.h;
				}
			}
		}
	}

	private function _itemChange(evt:Object):Void {

		if (evt.target != _selectedItem && evt.target.selected) {

			var item;
			var i:Number = _content.length;
			while(i--) {
				item = _content.getItem(i);
				if (item == evt.target) {
					_selectedItem = item;
				} else if (item.selected) {
					item.selected = false;
				}
			}
			dispatchEvent("change");
		}

		if (_ui.visible) {
			Selection.setFocus(_rect.movieclip);
		}
	}

	private function _itemRemove(evt:Object):Void {

		if (evt.target == _selectedItem) {
			selectedItem = getItem(0);	
		}
	}
}