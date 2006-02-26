import com.asual.enflash.ui.UIObject;
import com.asual.enflash.utils.MovieClips;

class com.asual.enflash.ui.Component extends UIObject {

	private var _w:Number = 0;
	private var _h:Number = 0;	
	private var _pw:Number = 0;
	private var _ph:Number = 0;

	private var _asset:MovieClip;
	private var _swf:String;
	private var _autoSize:Object;
	private var _rotation:Number = 0;
	private var _enabled:Boolean = true;
	private var _focusable:Boolean = false;	
	private var _zoom:Boolean = true;
	private var _float:String = "left";
	private var _clear:Boolean = false;
	private var _display:String = "inline";
	private var _tabIndex:Number;
	private var _name:String = "Component";

	private var _host:Boolean = false;
	private var _status:Number = 0;
	
	public var onblur:Function;
	public var onfocus:Function;
	public var onzoom:Function;

	public function Component(id:String) {
		
		super(id);

		_autoSize = new Object();
		_autoSize.w = true;
		_autoSize.h = true;
		
		_margin = {top:.5, right:.5, bottom:.5, left:.5};
	}

	public function setSize(w:Number, h:Number):Void {
		autoSize = { w:false, h:false };
		super.setSize(w, h);
	}
	
	public function get pw():Number {
		return _pw;
	}

	public function get ph():Number {
		return _ph;
	}

	public function get autoSize():Object {
		return _autoSize;
	}

	public function set autoSize(autoSize:Object):Void {
		_setAutoSize(autoSize);
	}

	public function get asset():MovieClip {
		return _asset;
	}
	
	public function get loaded():Boolean {
		return (_status == 3) ? true : false;
	}

	public function get float():String {
		return _float;
	}	
	
	public function set float(float:String):Void {
		_float = float;
	}

	public function get clear():Boolean {
		return _clear;
	}	
	
	public function set clear(clear:Boolean):Void {
		_clear = clear;
	}

	public function get display():String {
		return _display;
	}	
	
	public function set display(display:String):Void {
		_setDisplay(display);
	}

	public function get swf():String {
		return _swf;
	}

	public function set swf(swf:String):Void {

		_swf = (swf == "") ? undefined : swf;
		_status = 0;

		if (_mc != undefined) {
			if (_swf != undefined) {
				_ui.themeManager.loadTheme(this);
			} else {
				_ui.themeManager.unloadTheme(this);
				_asset.removeMovieClip();
			}
		}
	}

	public function get zoom():Boolean {
		return _zoom;
	}

	public function set zoom(zoom:Boolean):Void {
		_setZoom(zoom);
	}

	public function get focusable():Boolean {
		return _focusable;
	}

	public function set focusable(focusable:Boolean):Void {
		_setFocusable(focusable);
	}

	public function get rotation():Number {
		return _rotation;
	}

	public function set rotation(rotation:Number):Void {
		
		_rotation = Math.round(rotation/90)*90;
		if (_ui.visible){
			_setSize(_w, _h);		
		}
	}
	
	public function get enabled():Boolean {
		return _enabled;
	}	

	public function set enabled(enabled:Boolean):Void {
		_setEnabled(enabled);
	}

	public function get tabIndex():Number {
		return _tabIndex;
	}	

	public function set tabIndex(tabIndex:Number):Void {
		_setTabIndex(tabIndex);
	}

	public function get host():Boolean {
		return _host;
	}

	public function focus(assetFocus:Boolean):Void {
		_setFocus(assetFocus);
	}
	
	public function blur():Void {
		Selection.setFocus(null);
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);
		
		_mc.useHandCursor = false;
		_mc.tabEnabled = false;
		if (_tabIndex != undefined) {
			_mc.tabIndex = _tabIndex;
		}

		if (_enflash.conf.themesLoading) {
			_asset = _mc.createEmptyMovieClip("_asset", 0);
		}
		
		_ui.focusManager.addEventListener("focus", this, _focus);
		_ui.focusManager.addEventListener("blur", this, _blur);
		_ui.themeManager.addEventListener("themechange", this, _themeChange);
		_ui.themeManager.addEventListener("componentload", this, _themeLoad);
		_ui.zoomManager.addEventListener("zoom", this, _uiZoom);

		if (_ui.visible) {
			_mc._visible = false;
			_ui.langManager.getLang(this);				
		}

		_ui.themeManager.loadTheme(this);
		
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (!_enabled) {
			xml.firstChild.attributes.enabled = _enabled;
		}
		if (_clear) {
			xml.firstChild.attributes.clear = _clear;
		}
		if (_display == "block") {
			xml.firstChild.attributes.display = _display;
		}
		if (_float != "left") {
			xml.firstChild.attributes.float = _float;
		}
		if (!_zoom) {
			xml.firstChild.attributes.zoom = _zoom;
		}
		if (_autoSize.w) {
			delete xml.firstChild.attributes.w;
		}
		if (_autoSize.h) {
			delete xml.firstChild.attributes.h;
		}
		
		delete xml.firstChild.attributes.x;
		delete xml.firstChild.attributes.y;
		
		if (toString() == "Component" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Component" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}
		if (_swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		}
		if (getListeners("zoom").length > 0) {
			xml.firstChild.attributes.onzoom = _getEvent("zoom");
		}
		if (getListeners("focus").length > 0) {
			xml.firstChild.attributes.onfocus = _getEvent("focus");
		}
		if (getListeners("blur").length > 0) {
			xml.firstChild.attributes.onblur = _getEvent("blur");
		}
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.zoom != undefined) {
			zoom = (xml.attributes.zoom == "false") ? false : true;
		}
		if (xml.attributes.float != undefined) {
			float = xml.attributes.float;
		}
		if (xml.attributes.clear != undefined) {
			clear = (xml.attributes.clear == "true") ? true : false;
		}
		if (xml.attributes.display != undefined) {
			display = xml.attributes.display;
		}
		if (xml.attributes.swf != undefined) {
			swf = xml.attributes.swf;
		}
		if (xml.attributes.enabled != undefined) {
			enabled = (xml.attributes.enabled == "false") ? false : true;
		}
		if (xml.attributes.onzoom != undefined) {
			_setEvent("zoom", xml.attributes.onzoom);
		}		
		if (xml.attributes.onfocus != undefined) {
			_setEvent("focus", xml.attributes.onfocus);
		}		
		if (xml.attributes.onblur != undefined) {
			_setEvent("blur", xml.attributes.onblur);
		}
		super._setXML(xml);
	}
	
	private function _load():Void {
	
		_setSize(_w, _h);		
		dispatchEvent("load");

		if (_visible) {
			_mc._visible = true;
		}	
	}

	private function _getThemeMethods():Void {

		_asset.enflash = _enflash;
		_asset.log = _enflash.log;
		_asset.fontSize = _ui.theme.fontSize;
		_asset.corner = _ui.theme.corner;
		
		var methods = _ui.theme.getMethods(this, _swf);
		for (var m in methods){
			if (_asset[m] == undefined) {
				_asset[m] = methods[m];
			}
		}
		_asset.blur();
	}
	
	private function _themeChange():Void {
		_status = 0;
	}
	
	private function _themeLoad():Void {

		if (_swf != undefined) {
			_getThemeMethods();
		}

		if (_host) {
			switch(_status) {
				case 0:
					_status = 1;
					break;
				case 2:
					_status = 3;
					_load();
					break;
			}
		} else {
			_status = 3;
			_load();
		}
		
	}	
	
	private function _uiZoom():Void {
		_setSize(_w, _h);
		dispatchEvent("zoom");
	}
	
	private function _setSize(w:Number, h:Number):Void {

		if (_zoom){
			_pw = _zoom2pixel(w);
			_ph = _zoom2pixel(h);		
		} else {
			_pw = w;
			_ph = h;
		}

		if (_swf != undefined){		
			_asset.setSize(_pw, _ph);
			_asset.setRotation(_rotation, _pw, _ph);
		}

		if (_w != w || _h != h){
			_w = w;
			_h = h;
			dispatchEvent("resize");
		}
		
		var outline = false;
		if (outline) {
			_mc.clear();
			_mc.lineStyle(1, (_display == "block") ? 0xFF0000 : 0x00FF00);
			MovieClips.simpleRect(_mc, 0, 0, _pw - 1, _ph - 1);		
		}
	}

	private function _setDisplay(display:String):Void {
		_display = display;
	}
	
	private function _setWidth(w:Number):Void {
		autoSize = { w:false, h:_autoSize.h };
		super._setWidth(w);
	}

	private function _setHeight(h:Number):Void {
		autoSize = { w:_autoSize.w, h:false };
		super._setHeight(h);
	}
	
	private function _setAutoSize(autoSize:Object):Void {
		_autoSize.w = autoSize.w;
		_autoSize.h = autoSize.h;
	}
	
	private function _setZoom(zoom:Boolean):Void {
		_zoom = zoom;
	}

	private function _setFocusable(focusable:Boolean):Void {
		
		_focusable = focusable;
		if(_focusable && _enabled) {
			_mc.tabEnabled = true;
		} else { 
			_mc.tabEnabled = false;
		}
	}

	private function _setEnabled(enabled:Boolean):Void {

		_enabled = enabled;
		_mc.enabled = _enabled;
		if(_focusable && _enabled) {
			_mc.tabEnabled = true;
		} else { 
			_mc.tabEnabled = false;
		}
	}
	
	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		if (_mc != undefined) {
			_mc.tabIndex = tabIndex;
		}
	}
			
	private function _focus(evt:Object):Void {
		if (evt.tab && eval(Selection.getFocus()) == _mc){ 
			_asset.focus();
		}
		_setSize(_w, _h);
		dispatchEvent("focus", evt.oldFocus, evt.tab);
	}
	
	private function _blur(evt:Object):Void {
		
		_asset.blur();
		_setSize(_w, _h);
		dispatchEvent("blur", evt.newFocus);
	}	

	private function _setFocus(assetFocus:Boolean):Void {
		
		if (assetFocus == undefined) {
			assetFocus = true;
		}
		
		if (_focusable) {
			Selection.setFocus(_mc);
			if (assetFocus) {
				_asset.focus();
			}
		}
	}

	private function _remove():Void {

		_ui.focusManager.removeEventListener("focus", this);
		_ui.focusManager.removeEventListener("blur", this);
		_ui.themeManager.removeEventListener("themechange", this);
		_ui.themeManager.removeEventListener("componentload", this);
		_ui.zoomManager.removeEventListener("zoom", this);

		for(var p in _asset){
			delete _asset[p];
			_asset[p] = null;
		}

		_ui.themeManager.unloadTheme(this);

		super._remove();
	}
}