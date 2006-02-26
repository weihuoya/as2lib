import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.ScrollBar;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.TextArea extends Component {
	
	private var _label:Label;
	private var _value:String;
	private var _vScroll:ScrollBar;
	private var _scrollSize:Number;
	private var _scrollSpace:Number;
	private var _interval:Number;
	private var _resizeFlag:Boolean = true;
	private var _host:Boolean = true;
	private var _name:String = "TextArea";

	public function TextArea(id:String) {
		
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

	public function get size():Number {
		return _label.size;
	}
	
	public function set size(size:Number):Void {
		_label.size = size;
	}	

	public function get wordWrap():Boolean {
		return _label.wordWrap;
	}	
	
	public function set wordWrap(wordWrap:Boolean):Void {
		_label.wordWrap = wordWrap;
	}
	
	public function get textfield():TextField {
		return _label.textfield;	
	}
	
	public function get contentWidth():Number {
		return (_label.maxChars + _label.textfield.maxhscroll - 1);
	}

	public function get contentHeight():Number {
		return (_label.size + _label.textfield.maxscroll - 1);
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		_scrollSize = _ui.theme.scroll;
		_scrollSpace = _ui.theme.space;	

		_label = new Label();
		_label.focusable = true;
		_label.type = "input";
		_label.multiline = true;
		_label.wordWrap = true;
		_label.size = 5;
		_label.zoom = _zoom;
		_label.addEventListener("scroll", this, _labelScroll);
		_label.addEventListener("change", this, _labelChange);
		_label.addEventListener("load", this, _labelLoad);

		if (_value != undefined) {
			value = _value;
		}

		autoSize = _autoSize;

		_label.init(_ref, _mc);
		
		_vScroll = new ScrollBar();
		_vScroll.init(_ref, _mc);
		_vScroll.content = _label;
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
		if (_label.size != 5) {
			xml.firstChild.attributes.size = _label.size;
		}
		if (toString() == "TextArea" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "TextArea" && xml.firstChild.attributes.padding == "0.2") {
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
				break;
			case 3:
				_load();
				break;
		}
	}
	
	private function _setSize(w:Number, h:Number):Void {

		_scrollSize = _ui.theme.scroll;
		_scrollSpace = _ui.theme.space;	

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

		_vScroll.move(_pw - _zoom2pixel(_scrollSize) - _scrollSpace, _scrollSpace);
		_vScroll.setSize(_scrollSize, _pixel2zoom(_ph - _scrollSpace*2));
	}

	private function _labelResize():Void {
		
		if (_resizeFlag) {

			var w = (_autoSize.w) ? _label.w + _padding.left + _padding.right : _w;
			var h = (_autoSize.h) ? _label.h + _padding.top + _padding.bottom : _h;		

			if (w != _w){
				_vScroll.move(_zoom2pixel(w - _scrollSize) - _scrollSpace, _scrollSpace);
			}

			super._setSize(w, h);
		}
	}

	private function _labelChange():Void {
		_value = _label.value;
		_vScroll.setSize(_scrollSize, _pixel2zoom(_ph - _scrollSpace*2));
	}
		
	private function _labelScroll():Void {
		_vScroll.setSize(_scrollSize, _pixel2zoom(_ph - _scrollSpace*2));
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
		_vScroll.enabled = enabled;
		if (!enabled && this == _ui.focus){
			_blur();
			Time.setTimeout(Selection, "setFocus", 2, null);
		}
		super._setEnabled(enabled);
	}

	private function _focus(evt:Object):Void {
		if (evt.tab && eval(Selection.getFocus()) == _label.textfield){ 
			_mc.tabFocus = true;
			_asset.focus();
			Time.setTimeout(Selection, "setSelection", 1, _label.textfield.beginIndex, _label.textfield.endIndex);
		} else {
			_mc.tabFocus = false;
		}
		_interval = setInterval(this, "_setIndices", 500);
		super._focus(evt);
	}
	
	private function _blur(evt:Object):Void {
		clearInterval(_interval);
		super._blur(evt);
	}

	private function _setFocus(assetFocus:Boolean):Void {
		_label.focus(assetFocus);
	}
		
	private function _setIndices():Void {
		_label.textfield.beginIndex = Selection.getBeginIndex();
		_label.textfield.endIndex = Selection.getEndIndex();
	}
	
	private function _remove():Void {
		
		_label.removeEventListener("scroll", this);
		_label.removeEventListener("change", this);
		_label.removeEventListener("load", this);
		
		_label.remove();
		_vScroll.remove();
		
		super._remove();
	}
			
}