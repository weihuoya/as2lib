import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.Menu;

import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.MenuItem extends Button {
	
	private var _type:String;
	private var _group:String;
	private var _checked:Boolean = false;
	private var _slabel:Label;
	private var _shortcut:String;
	private var _host:Boolean = true;
	private var _menu:Menu;
	private var _name:String = "MenuItem";
	
	public function MenuItem(id:String) {
		
		super(id);
		
		_align = "left";
		_swf = "menuitem.swf";
		_focusable = false;
		_type = "normal";

		_margin = {top:0, right:0, bottom:0, left:0};
		_padding = {top:0, right:1.4, bottom:0, left:1.8};

		_label = new Label();

	}

	public function get shortcut():String {
		return _shortcut;
	}
	
	public function get type():String {
		return _type;
	}
	
	public function set type(type:String):Void {
		_type = type;
	}
	
	public function get group():String {
		return _group;
	}
	
	public function set group(group:String):Void {
		_group = group;
	}	
	
	public function get checked():Boolean {
		return _checked;
	}
	
	public function set checked(checked:Boolean):Void {
		
		_checked = checked;
		if (_type == "check"){
			asset.setCheck(_checked);
		} else if (_type == "radio"){
			asset.setRadio(_checked);
		}

	}

	public function addSeparator():Component {
		if (_menu == undefined) {
			_addMenu();
		}
		return _menu.addSeparator();
	}
	
	public function addItem(item:MenuItem):MenuItem {
		if (_menu == undefined) {
			_addMenu();
		}
		return _menu.addItem(item);
	}

	public function addItemAt(index:Number, item:MenuItem):MenuItem {
		if (_menu == undefined) {
			_addMenu();
		}
		return _menu.addItemAt(index, item);
	}

	public function removeItem(item):Void {
		_menu.removeItem(item);
		if (_menu != undefined && _menu.getItem(0) == undefined) {
			_removeMenu();
		}
	}
	
	public function removeItemAt(index):Void {
		_menu.removeItemAt(index);
		if (_menu != undefined && _menu.getItem(0) == undefined) {
			_removeMenu();
		}

	}

	public function removeAll():Void{
		_menu.removeAll();
		if (_menu != undefined) {
			_removeMenu();
		}
	}

	public function get shortcutLabel():Label {
		return _slabel;
	}
	
	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(selected:Boolean):Void {
		
		_selected = selected;

		if (_selected){
			asset.setDown();
		} else {
			asset.setUp();
		}
	}
	
	public function get menu():Menu {
		return _menu;
	}

	public function moveRight():Void {
		
		var x = _ui.getX(this) + _pw;
		var y = _ui.getY(this) - _ui.theme.space - 1;
		var altx = _ui.getX(this);
		var alty = _ui.getY(this) + _ph + _ui.theme.space + 1;

		_menu.open(x, y, altx, alty);
		_menu.moveDown();
	}


	public function moveLeft():Void {
		
		_menu.close();
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
	
		super._init(parent, mc, depth);

		_label.wordWrap = false;
		_label.selectable = false;
		_label.margin = 0;
		_label.addEventListener("resize", this, _labelResize);
		_label.addEventListener("load", this, _compLoad);
		_label.init(_ref, _mc);

		_ui.shortcutManager.addEventListener("format", this, _formatShortcut);
		_ui.shortcutManager.addEventListener("shortcut", this, _executeShortcut);
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (_swf != "menuitem.swf") {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}

		if (type != "normal") {
			xml.firstChild.attributes.type = type;
			xml.firstChild.attributes.checked = checked;
		}
		if (group != undefined) {
			xml.firstChild.attributes.group = group;
		}
		if (_slabel != undefined) {
			xml.firstChild.attributes.shortcut = _slabel.value;
		}

		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "top: 0, right: 1.4, bottom: 0, left: 1.8") {
			delete xml.firstChild.attributes.padding;
		}

		delete xml.firstChild.attributes.onload;
		delete xml.firstChild.attributes.onrelease;
		
		if (_menu != undefined) {
			var item;
			var i = -1;
			var iMax = _menu.length;
			while(++i != iMax) {
				item = _menu.getItem(i);
				if (item.toString() == "Component") {
					xml.firstChild.appendChild(new XML("<Separator />"));
				} else {
					xml.firstChild.appendChild(item.getXML());
				}
			}
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
		
		var item;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			if (item.nodeName == "Separator") {
				addSeparator();
			} else {
				addItem(new MenuItem(item.attributes.id)).setXML(item);
			}
		}		

		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange, _menu);
		}
		if (xml.attributes.type != undefined) {
			type = xml.attributes.type;
		}
		if (xml.attributes.group != undefined) {
			group = xml.attributes.group;
		}
		if (xml.attributes.checked != undefined) {
			checked = (xml.attributes.checked == "true") ? true : false;
		}
		if (xml.attributes.shortcut != undefined) {
			_ui.addShortcut(this, xml.attributes.shortcut);
		}

		super._setXML(xml);
	}

	private function _load():Void {

		_asset.setCheck(false);
		_asset.setRadio(false);
		
		if (_type == "check"){
			_asset.setCheck(_checked);
		} else if (_type == "radio"){
			_asset.setRadio(_checked);
		}
		
		if (_menu != undefined){
			_asset.setExpand(true);
		} else {
			_asset.setExpand(false);
		}
		
		super._load();
	}

	private function _uiZoom():Void {
		return;
	}

	private function _compLoad(evt:Object):Void {
		
		if (_label.loaded && (_slabel == undefined || _slabel.loaded)) {

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

	private function _setSize(w, h):Void {

		autoSize = { w:true, h:true };
		_label.autoSize = { w:true, h:true };

		super._setSize(w, h);

		if (_ui.visible && _icon != undefined) {
			_icon.move(_icon.margin.left, _icon.margin.top);
			_label.move(_icon.w + _icon.margin.left*2, _zoom2pixel(_padding.top + _label.margin.top));
			_slabel.y = _label.y;
		}
	}
	
	private function _labelResize(evt:Object):Void {
		
		if (_resizeFlag) {
			
			var w = _label.w + _label.margin.left + _label.margin.right + _padding.left + _padding.right;
			var h = _label.h + _label.margin.top + _label.margin.bottom + _padding.top + _padding.bottom;					

			if (_slabel != undefined) {
				w += _slabel.w + _slabel.margin.left + _slabel.margin.right;
			}

			if (w != _w || h != _h){
				_setSize(w, h);
			}
		}
	}

	private function _setEnabled(enabled:Boolean):Void {
		
		_label.enabled = enabled;
		
		if (_slabel != undefined) {
			_slabel.enabled = enabled;
		}

		_enabled = enabled;
	}

	private function _formatShortcut(evt:Object):Void {
		
		if (evt.shortcut != undefined) {
		
			_shortcut = evt.shortcut;
	
			_slabel = new Label();
			_slabel.wordWrap = false;
			_slabel.margin = {top:0, right:0, bottom:0, left:0.6};
			_slabel.init(_ref, _mc);
			_slabel.value = shortcut;
			
			_label.removeEventListener("resize", this);
			_slabel.addEventListener("load", this, _compLoad);
			_slabel.addEventListener("resize", this, _labelResize);
		
		} else {
			if (_slabel != undefined) {
				_slabel.removeEventListener("resize", this);
				_slabel.remove();
				_label.addEventListener("resize", this, _labelResize);
			}
		}
	}
	
	private function _executeShortcut(evt:Object):Void {		
		_mc.onRelease();
	}

	private function _addMenu():Void {	
		
		_menu = new Menu();
		_menu.menuParent = this;
		_ui.addMenu(menu);
		
		asset.setExpand(true);
	}

	private function _removeMenu():Void {	
		_ui.removeMenu(_menu);
		asset.setExpand(false);
		_menu = undefined;
	}	

	private function _mcRelease():Void {
		
		if (_enabled){
			super._mcRelease();
		}
	}
	
	private function _mcRollOver():Void {
		
		if (parent.parent.keyNav) return;
		
		if (_menu != undefined){
			Time.setTimeout(this, "_menuOpen", 500);
		}

		_over = true;

		if (_selected){ 
			_asset.setDownOver();
		} else { 
			_asset.setUpOver();
		}
		dispatchEvent("rollover");
	}

	private function _mcRollOut():Void {

		if (parent.parent.keyNav) return;
		
		if (_menu != undefined){
			if (!_menu.asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
				_asset.setUp();	
				Time.setTimeout(this, "_menuClose", 300);
			}
		} else {
			_asset.setUp();
		}
		_over = false;
		dispatchEvent("rollout");
	}

	private function _menuOpen():Void {
		
		if (_over){
			var x = _ui.getX(this) + _pw;
			var y = _ui.getY(this) - _ui.theme.space - 1;
			var altx = _ui.getX(this);
			var alty = _ui.getY(this) + _ui.theme.space + 1 + _ph;
			_menu.open(x, y, altx, alty);
		}
	}
	
	private function _menuClose():Void {
		if (!_menu.asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
			_menu.close();
		}
	}

	private function _remove():Void {
		if (_menu != undefined) {
			_removeMenu();
		}
		super._remove();
	}
}
