import com.asual.enflash.data.List;

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.Icon;
import com.asual.enflash.ui.Tree;

class com.asual.enflash.ui.TreeItem extends Button {

	private var _icon:Icon;
	private var _expandedIcon:String;
	private var _collapsedIcon:String;
	private var _expanded:Boolean = false;
	private var _treeParent;
	private var _tree:Tree;
	private var _items:List;
	private var _depth:Number = 0;
	private var _name:String = "TreeItem";

	public function TreeItem(treeParent, id:String) {

		super(id);

		margin = 0;
		
		_treeParent = treeParent;
		_align = "left";		
		_toggle = true;
		_focusable = false;
		_swf = "treeitem.swf";
	}

	public function get treeParent() {
		return _treeParent;
	}

	public function get expanded():Boolean {
		return _expanded;
	}

	public function set expanded(expanded:Boolean):Void {

		if (_items.length == 0) return;
		
		_expanded = expanded;
		_setExpand();

		var i:Number = _items.length;
		while(i--) {
			_items.getItem(i)._setVisibility(_expanded);
		}

		if (_expandedIcon != undefined && _collapsedIcon != undefined) {
			icon = (_expanded) ? _expandedIcon : _collapsedIcon;
		}

		if (_tree.autoRefresh && _ui.visible) {
			_tree.refresh();
		}
	}

	public function get depth():Number {
		return _depth;
	}

	public function get deeplength():Number {
		var l:Number = _items.length;
		var i:Number = _items.length;
		while(i--) {
			l += _items.getItem(i).deeplength;
		}
		return l;
	}
	
	public function get length():Number {
		var length:Number = 0;
		var i:Number = _items.length;
		while(i--) {
			length += _items.getItem(i).length;
		}
		return length;
	}

	public function addItem(treeItem:TreeItem):TreeItem {
		
		var index = _tree.getIndex(this) + _items.length + 1;
		var i:Number = _items.length;
		while(i--) {
			index += _items.getItem(i).deeplength;
		} 

		var item = _tree.addItemAt(index, (treeItem != undefined) ? treeItem : new TreeItem(this));
		item.visible = _expanded;

		_items.addItem(item);
		_setExpand();
		
		return item;
	}

	public function addItemAt(index:Number, treeItem:TreeItem):TreeItem {
		
		if (index > (_items.length - 1)) {
			addItem(treeItem);
		}
		
		var newIndex = _tree.getIndex(this) + index + 1;

		var i:Number = index;
		while(i--) {
			newIndex += _items.getItem(i).deeplength;
		} 

		var item = _tree.addItemAt(newIndex, (treeItem != undefined) ? treeItem : new TreeItem(this));
		item.visible = _expanded;		

		_items.addItem(item);
		_setExpand();

		return item;
	}	

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		var treeParent = _treeParent;
		while(treeParent.toString() != "Tree") {
			treeParent = treeParent.treeParent;
			_depth++;
		}
		_tree = treeParent;
		
		_padding = {top:0, right:0, bottom:0, left: _depth};

		_items = new List();
		_items.init(_ref);
		
		_label = new Label();
		_label.wordWrap = false;
		_label.selectable = false;
		_label.margin = {top:0, right:0, bottom:0, left: 1.4};
		_label.addEventListener("resize", this, _labelResize);
		_label.addEventListener("load", this, _labelLoad);
		_label.init(_ref, _mc);		
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (_swf != "treeitem.swf") {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (_expanded) {
			xml.firstChild.attributes.expanded = _expanded;
		}
		if (!_selected) {
			delete xml.firstChild.attributes.selected;
		}
		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "TreeItem" && xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "TreeItem" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}
		if (toString() == "TreeItem" && xml.firstChild.attributes.padding.indexOf("top: 0, right: 0, bottom: 0") > -1) {
			delete xml.firstChild.attributes.padding;
		}
		delete xml.firstChild.attributes.toggle;

		if (_items.length > 0) {
			if (_expandedIcon != _tree.expandedIcon) {
				xml.firstChild.attributes.expandedIcon = _expandedIcon;
			}
			if (_collapsedIcon != _tree.collapsedIcon) {
				xml.firstChild.attributes.collapsedIcon = _collapsedIcon;
			}
		}	
		if (_items.length == 0 && icon == _tree.leafIcon) {
			delete xml.firstChild.attributes.icon;
		}

		var i = -1;
		var iMax = _items.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_items.getItem(i).getXML());
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		var item;
		var i = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			addItem(new TreeItem(this, item.attributes.id)).setXML(item);
		}
		
		if (_items.length > 0) {
			if (_tree.expandedIcon != undefined) {
				_expandedIcon = _tree.expandedIcon;
			}
			if (_tree.collapsedIcon != undefined) {
				_collapsedIcon = _tree.collapsedIcon;
			}
			expanded = (xml.attributes.expanded == "true") ? true : false;
		} else {
			if (_tree.leafIcon != undefined) {
				icon = _tree.leafIcon;
			}			
		}
		
		if (xml.attributes.selected != undefined) {
			var selected = (xml.attributes.selected == "true") ? true : false;
			if (selected) super._mcPress();
		}
		
		super._setXML(xml);
	}


	private function _load():Void {

		_setExpand();
		super._load();
	}

	private function _setSize(w, h):Void {
		
		super._setSize(w, h);
		_icon.move(_zoom2pixel(_padding.left + _label.margin.left) + _icon.margin.left, _icon.margin.top);
	}

	private function _setExpand():Void {

		if (_items.length > 0) {
			_asset.setExpandable(true);
			_asset.setExpand(_expanded);
		} else {
			_asset.setExpandable(false);				
		}
	}

	private function _setVisibility(visibility:Boolean):Void {

		visible = visibility;

		visibility = (visibility) ? _expanded : false;
		var i:Number = _items.length;
		while(i--) {
			_items.getItem(i)._setVisibility(visibility);
		}
	}
		
	private function _mcPress():Void {
		
		if (_items.length > 0) {

			var hit = (_expanded) ? _asset.collapse.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false) : _asset.expand.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false);
			
			if (_doublepress + _doubletime > getTimer()) {
			
				if (!hit) expanded = !expanded;

			} else {
				
				if (hit) expanded = !expanded;
				
				if (_selected) {
					_selected = false;
				}
			}
		}

		super._mcPress();
	
		if (!_selected && _tree.selectedItem == this) {
			selected = true;	
		}
	}

	private function _remove():Void {

		var i:Number = _items.length;
		while(i--) {
			_tree.removeItem(_items.getItem(i)).remove();
		}

		_tree = undefined;
		_treeParent = undefined;

		super._remove();
	}

}