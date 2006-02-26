import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Label;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.TextInput extends Component {
	
	private var _label:Label;
	private var _value:String;
	private var _resizeFlag:Boolean = true;
	private var _host:Boolean = true;
	private var _name:String = "TextInput";

	public function TextInput(id:String) {
		
		super(id);
		
		_swf = "text.swf";
		_focusable = true;
		_value = "";
		_padding = {top: .2, right: .3, bottom: .2, left: .3};
	}
	
	public function get maxChars():Number {
		return _label.maxChars;
	}
	
	public function set maxChars(maxChars:Number):Void {
		_label.maxChars = maxChars;
	}

	public function get value():String {
		return _value;
	}
	
	public function set value(value:String):Void {
		_value = value;
		_label.value = _value;
	}
	
	public function get password():Boolean {
		return _label.password;
	}	
	
	public function set password(password:Boolean):Void {
		_label.password = password;
	}
	
	public function get textfield():TextField {
		return _label.textfield;	
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		_label = new Label();
		_label.focusable = true;
		_label.margin = 0;
		_label.wordWrap = false;
		_label.zoom = _zoom;
		_label.type = "input";
		_label.addEventListener("change", this, _labelChange);
		_label.addEventListener("load", this, _labelLoad);

		if (_value != undefined) {
			value = _value;
		}

		autoSize = _autoSize;
	
		_label.init(_ref, _mc);

	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (_swf != "text.swf" && _swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}
		if (_value != undefined && _value != "") {
			xml.firstChild.attributes.value = _value;
		}
		if (_label.password) {
			xml.firstChild.attributes.password = _label.password;
		}

		if (toString() == "TextInput" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "TextInput" && xml.firstChild.attributes.padding == "0.2") {
			delete xml.firstChild.attributes.padding;
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
		
		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}
		if (xml.attributes.maxChars != undefined) {
			maxChars = xml.attributes.maxChars;
		}
		if (xml.attributes.password != undefined) {
			password = (xml.attributes.password == "true") ? true : false;
		}
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}
		super._setXML(xml);
	}
		
	private function _load():Void {
		super._load();
		_setSize(_w, _h);
	}	

	private function _labelLoad():Void {
		
		switch (_status) {
			case 0:
				_status = 2;
				break;
			case 1:
				_status = 3;
				_load();
			case 3:
				_load();
				break;
		}
	}
	
	private function _setSize(w:Number, h:Number):Void {
		
		if (loaded) {

			if (_zoom) {
				_label.move(_zoom2pixel(_padding.left), _zoom2pixel(_padding.top));
			} else {
				_label.move(_padding.left, _padding.top);				
			}

			if (!_autoSize.w || !_autoSize.h){ 
				var lw = (_autoSize.w) ? _label.w : w - _padding.left - _padding.right;
				var lh = (_autoSize.h) ? _label.h : h - _padding.top - _padding.bottom;
				if (lw != _label.w || lh != _label.h){
					_resizeFlag = false;
					if (!_autoSize.w && !_autoSize.h) {
						_label.setSize(lw, lh);
					} else if (!_autoSize.w) {
						_label.w = lw;
					} else {
						_label.h = lh;
					}
					_resizeFlag = true;
				}
			}
		}	

		super._setSize(w, h);
	}

	private function _labelResize(evt:Object):Void {

		if (_resizeFlag) {
			var w = (_autoSize.w) ? _label.w + _padding.left + _padding.right : _w;
			var h = (_autoSize.h) ? _label.h + _padding.top + _padding.bottom : _h;		

			super._setSize(w, h);
		}
	}

	private function _labelChange():Void {
		_value = _label.value;
	}


	private function _setZoom(zoom:Boolean):Void {
		super._setZoom(zoom);
		_label.zoom = _zoom;
	}
	
	private function _setAutoSize(autoSize:Object):Void {
		
		super._setAutoSize(autoSize);
		
		if (_label != undefined){ 
			_label.autoSize = _autoSize;
			if (_autoSize.w || _autoSize.h){
				if (!Arrays.contains(_label.getListeningObjects("resize"), this)){
					_label.addEventListener("resize", this, _labelResize);
				}
			} else {
				_label.removeEventListener("resize", this);
			}
		}
	}

	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		_label.tabIndex = tabIndex;
	}

	private function _setEnabled(enabled:Boolean):Void {

		_label.enabled = enabled;
		if (!enabled && this == _ui.focus){
			_blur();
			Time.setTimeout(Selection, "setFocus", 2, null);
		}
		super._setEnabled(enabled);
	}
	
	private function _focus(evt:Object):Void {
		
		if (evt.tab && eval(Selection.getFocus()) == _label.textfield){ 
			_asset.focus();
			Selection.setSelection(0, _label.value.length);
		}
		super._focus(evt);
	}

	private function _setFocus(assetFocus):Void {
		_label.focus(assetFocus);
	}
		
	private function _remove():Void {
		
		_label.removeEventListener("change", this);
		_label.removeEventListener("load", this);
		_label.removeEventListener("resize", this);
		
		_label.remove();
		
		super._remove();
	}
					
}