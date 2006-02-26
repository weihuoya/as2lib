import com.asual.enflash.ui.Component;

import com.asual.enflash.utils.*;

class com.asual.enflash.ui.Label extends Component {
	
	private var _align:String = "left";
	private var _textfield:TextField;
	private var _value:String = "";
	private var _selectable:Boolean = true;
	private var _maxChars:Number = 20;
	private var _type:String = "dynamic";
	private var _multiline:Boolean = false;
	private var _lines:Number = 1;
	private var _password:Boolean = false;	
	private var _wordWrap:Boolean = false;	
	private var _css:String;
	private var _styleSheet:TextField.StyleSheet;
	private var _host:Boolean = false;
	private var _name:String = "Label";
	
	private var _face:String;
	private var _color:Number;
	private var _size:Number = 0;
	
	public var onchange:Function;
	public var onscroll:Function;
	
	public function Label(id:String) {
		super(id);
		_swf = "label.swf";	
	}
		
	public function setColor(color:Number):Void {
		_mc.color.setRGB(color);
	}
	
	public function unsetColor():Void {
		_mc.color.setTransform({ra:100, rb:0,ga:100,gb:0,ba:100,bb:0,aa:100,ab:0});
	}

	public function get value():String {
		return _getValue();
	}	
	
	public function set value(value:String):Void {
		_setValue(value);
	}

	public function get align():String {
		return _align;
	}	
	
	public function set align(align:String):Void {

		_align = align;

		if (_textfield != undefined) {
			_setSize(_w, _h);
		}
	}

	public function get pw():Number {
		return _pw;
	}

	public function get fontColor():Number {
		return _color;
	}	

	public function set fontColor(fontColor:Number):Void {
		_color = fontColor;
		setColor(_color);
	}
	
	public function get fontFace():String {
		return _face;
	}	

	public function set fontFace(fontFace:String):Void {
		
		_face = fontFace;
		
		if (_textfield != undefined) {
			_setFontSize();
		}
	}
	
	public function get fontSize():Number {
		return _size;
	}	

	public function set fontSize(fontSize:Number):Void {

		_size = fontSize;
		if (_textfield != undefined) {
			_textSize();
			_setSize(_w, _h);
		}
	}
	
	public function setStyle(identifyer:String, style:Object):Void {
		
		if (_styleSheet == undefined) {
			_styleSheet = new TextField.StyleSheet();
		}
		_styleSheet.setStyle(identifyer, style);
		value = _value;
	}

	public function get css():String {
		return _css;
	}	

	public function set css(css:String):Void {
		_css = css;
		if (_styleSheet == undefined) {
			_styleSheet = new TextField.StyleSheet();
		}
		_styleSheet.load(_css);
	}	

	public function get type():String {
		return _type;
	}	
	
	public function set type(type:String):Void {
		_type = type;
		if (_textfield != undefined){
			_textfield.type = _type;
		}
	}

	public function get wordWrap():Boolean {
		return _wordWrap;
	}	
	
	public function set wordWrap(wordWrap:Boolean):Void {
		_wordWrap = wordWrap;
		if (_textfield != undefined){
			_textfield.wordWrap = _wordWrap;
		}
	}	
	
	public function get multiline():Boolean {
		return _multiline;
	}	
	
	public function set multiline(multiline:Boolean):Void {
		_multiline = multiline;
		if (_textfield != undefined){
			_textfield.multiline = _multiline;
		}		
	}

	public function get size():Number {
		return _lines;
	}	
	
	public function set size(size:Number):Void {
		_lines = size;
		_textSize();
	}
	
	public function get maxChars():Number {
		return _maxChars;
	}
	
	public function set maxChars(maxChars:Number):Void {
		_maxChars = maxChars;
	}
	
	public function get selectable():Boolean {
		return _selectable;
	}	
	
	public function set selectable(selectable:Boolean):Void {
		_selectable = selectable;
		if (_textfield != undefined){
			_textfield.selectable = _selectable;
		}
	}

	public function get password():Boolean {
		return _password;
	}	
	
	public function set password(password:Boolean):Void {
		_password = password;
		if (_textfield != undefined){
			_textfield.password = _password;
		}
	}

	public function get textfield():TextField {
		return _textfield;	
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		_ui.addEventListener("styles", this, _stylesLoad);
		_ui.zoomManager.addEventListener("textzoom", this, _textSize);

		_mc.color = new Color(_mc);
		
		if (_css != undefined) {
			_styleSheet.load(_css);
		}
		if(_color != undefined) {
			setColor(_color);
		}
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (_swf != "label.swf" && _swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (_display == "block") {
			xml.firstChild.attributes.display = _display;
		} else {
			delete xml.firstChild.attributes.display;
		}
		if (_multiline) {
			xml.firstChild.attributes.multiline = _multiline;
		}
		if (_wordWrap) {
			xml.firstChild.attributes.wordWrap = "true";
		}
		if (!_selectable) {
			xml.firstChild.attributes.selectable = _selectable;
		}
		if (_css != undefined) {
			xml.firstChild.attributes.css = _css;
		}
		if (_align == "right" || _align == "center") {
			xml.firstChild.attributes.align = _align;
		}
		if (_value != undefined) {
			
			var newvalue = _value;

			newvalue = Strings.replace(newvalue, '"', "&quot;");
			newvalue = Strings.replace(newvalue, "<", "&lt;");
			newvalue = Strings.replace(newvalue, ">", "&gt;");

			xml.firstChild.attributes.value = newvalue;
		}
		if (_face != undefined) {
			xml.firstChild.attributes.fontFace = _face;
		}
		if (_size != 0) {
			xml.firstChild.attributes.fontSize = _size;
		}
		if (_color != undefined) {
			xml.firstChild.attributes.fontColor = "0x" + _color.toString(16).toUpperCase();
		}
		if (toString() == "Label" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Label" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.multiline != undefined) {
			multiline = (xml.attributes.multiline == "true") ? true : false;
		}
		if (xml.attributes.wordWrap != undefined) {
			wordWrap = (xml.attributes.wordWrap == "true") ? true : false;
		}
		if (xml.attributes.selectable != undefined) {
			selectable = (xml.attributes.selectable == "true") ? true : false;
		}
		if (xml.attributes.css != undefined) {
			css = xml.attributes.css;
		}
		if (xml.attributes.align == "left" || xml.attributes.align == "right" || xml.attributes.align == "center") {
			align = xml.attributes.align;
		}
		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}
		if (xml.attributes.fontSize != undefined) {
			fontSize = Number(xml.attributes.fontSize);
		}
		if (xml.attributes.fontFace != undefined) {
			fontFace = String(xml.attributes.fontFace);
		}
		if (xml.attributes.fontColor != undefined) {
			fontColor = Number(xml.attributes.fontColor);
		}
	
		if (xml.hasChildNodes()) {

			while(xml.hasChildNodes()) {

				switch(xml.firstChild.nodeName.toLowerCase()){
					case "value":
						var newvalue = escape(xml.firstChild.childNodes.join(""));

						newvalue = Strings.replace(newvalue, "%09", "");
						newvalue = Strings.replace(newvalue, "%0A", "");
						newvalue = Strings.replace(newvalue, "%0D", "");

						value = unescape(newvalue);
						break;
				}
				xml.firstChild.removeNode();	
			}
		}
		super._setXML(xml);
	}
	
	private function _themeChange():Void {
		unsetColor();
		super._themeChange();
	}

	private function _load():Void {

		_asset._x = (_zoom) ? _zoom2pixel(_padding.left) : _padding.left;
		_asset._y = (_zoom) ? _zoom2pixel(_padding.top) : _padding.top;

		enabled = _enabled;

		super._load();
	}

	private function _stylesLoad():Void {
		if (_value.toLowerCase().indexOf("c" + "lass") > -1) {
			_textSize();
			_textSize();
			var p = parent.parent;
			if (p.toString().indexOf("Pane") > -1) {
				p.refresh();
			}
		}
	}
	
	private function _setFontSize():Void {
		if (_asset != undefined) {
			_asset.setFontSize(_ui.zoomManager.fontSize + _size, _face, _align);
		}
	}

	private function _textSize():Void {
		
		if (_textfield == undefined) return;

		_textfield.autoSize = "left";

		// Colorize Labels 
		//_textfield.background = true;
		//_textfield.backgroundColor = 0xCCCCCC;

		_textfield.multiline = _multiline;
		_textfield.selectable = (_enabled) ? ((_type == "dynamic") ? _selectable : true) : false;
		_textfield.type = (_enabled) ? _type : "dynamic";
		
		_textfield.tabEnabled = _focusable;
		_textfield.tabIndex = _tabIndex;

		if (_type == "input"){

			_textfield.password = false;
			_textfield.wordWrap = false;
			_textfield.text = ".";

			_setFontSize();
			
			var w, h;
			if (_autoSize.w){
				
				var i:Number = Math.round(_maxChars/2);
				while(i--){
					_textfield.text += "Ww"; 	
				}
				w = _textfield._width;
				
			} else {
				w = (_zoom) ? _zoom2pixel(_w) : _w;
			}
			
			if (_autoSize.h){
				h = _textfield._height;	
			} else {
				h = (_zoom) ? _zoom2pixel(_h) : _h;
			}

			_textfield.autoSize = "none";
			_textfield.onChanged = createDelegate(this, _tfChange);

			var space = (_zoom) ? _pixel2zoom(_ui.theme.space) : _ui.theme.space;

			if (_lines > 1){

				_textfield.onScroller = createDelegate(this, _tfScroll);

				_textfield._width = w - space*2;		
				_textfield._height = (h - _textfield.getTextFormat().leading*2)*_lines + _textfield.getTextFormat().leading*2;
				_textfield.wordWrap = _wordWrap;

			} else {
				_textfield._width = w - space*2;
				_textfield._height = h;
				_textfield.maxChars = _maxChars;
			}
			
			if (_autoSize.w) {
				_w = (_zoom) ? _pixel2zoom(_textfield._width) : _textfield._width;
				_autoSize.w = false;
			}
		}

		_textfield.wordWrap = _wordWrap;		
		_textfield.password = _password;

		value = _value;

		if (_autoSize.w || _autoSize.h){
			dispatchEvent("resize");
		}
	}	

	private function _setSize(w:Number, h:Number):Void {

		var pw:Number;
		var ph:Number;

		if (_zoom){
			pw = _zoom2pixel(w);
			ph = _zoom2pixel(h);			
		} else {
			pw = w;
			ph = h;
		}

		if (_textfield != undefined) {
			
			if (_autoSize.w || _autoSize.h) {
				pw = (_autoSize.w) ? Math.ceil(_textfield._width) + ((_zoom) ? _zoom2pixel(_padding.left + _padding.right) : (_padding.left + _padding.right)) : pw;
				ph = (_autoSize.h) ? Math.ceil(_textfield._height) + ((_zoom) ? _zoom2pixel(_padding.top + _padding.bottom) : (_padding.top + _padding.bottom)) : ph;
			}
			
			_textfield._y = Math.round((ph - _textfield._height)/2);
		}
		
		super._setSize(w, h);

		if (!_autoSize.w && _value != "" && _type != "input" && !_multiline) {
			TextFields.reduce(_textfield);
		}
	}

	private function _uiZoom():Void {
		super._uiZoom();
		if (_textfield.styleSheet != undefined){
			_textSize();
		}
	}

	private function _tfChange():Void {
		_value = _textfield.htmlText;
		dispatchEvent("change");
	}
	
	private function _tfScroll():Void {
		dispatchEvent("scroll");
		Time.setTimeout(this, "dispatchEvent", 100, "scroll");
	}	
	
	private function _getValue():String {
		return _value;
	}
	
	private function _setValue(value:String):Void {

		_value = value;

		if (value == undefined || _textfield == undefined) return;

		_textfield.htmlText = _value;
		
		if (_value.toLowerCase().indexOf("c" + "lass") > -1) {
			if (_styleSheet != undefined) {
				_textfield.styleSheet = _styleSheet;
			} else if (_ui.styleSheet != undefined) {
				_textfield.styleSheet = _ui.styleSheet;
			}
		}

		_setFontSize();

		if (_autoSize.w && _autoSize.h) {

			_pw = Math.ceil(_textfield._width) + ((_zoom) ? _zoom2pixel(_padding.left + _padding.right) : (_padding.left + _padding.right));
			_w = (_zoom) ? _pixel2zoom(_pw) : _pw;

			_ph = Math.ceil(_textfield._height) + ((_zoom) ? _zoom2pixel(_padding.top + _padding.bottom) : (_padding.top + _padding.bottom));
			_h = (_zoom) ? _pixel2zoom(_ph) : _ph;
			
		} else if (!_autoSize.w && _autoSize.h) {

			var ph = _textfield._height;

			_ph = Math.ceil(_textfield._height) + ((_zoom) ? _zoom2pixel(_padding.top + _padding.bottom) : (_padding.top + _padding.bottom));
			_h = (_zoom) ? _pixel2zoom(_ph) : _ph;
			
			if (!_wordWrap){
				_textfield.autoSize = "none";
			}
			
			_textfield._height = ph;

		} else if (_autoSize.w && !_autoSize.h){

			_pw = Math.ceil(_textfield._width) + ((_zoom) ? _zoom2pixel(_padding.left + _padding.right) : (_padding.left + _padding.right));
			_w = (_zoom) ? _pixel2zoom(_pw) : _pw;
			
		} else if (!_autoSize.w && !_autoSize.h) {

			var ph = _textfield._height;

			if (!_wordWrap){
				_textfield.autoSize = "none";
			}

			_textfield._height = ph;
		}
		
		_setSize(_w, _h);

	}
	
	private function _setWidth(w:Number):Void {
		super._setWidth(w);
		_textSize();
	}	

	private function _setHeight(h:Number):Void {
		super._setHeight(h);
		_textSize();
	}

	private function _setDisplay(display:String):Void {
		super._setDisplay(display);
		if (_display == "inline") {
			wordWrap = false;	
		} else {
			wordWrap = true;				
		}
	}
		
	private function _setEnabled(enabled:Boolean):Void {

		_enabled = enabled;
		
		if (_enabled){
			_asset.setNormal();
			_asset._textfield = _asset.tf;
			_textfield = _asset.tf;
		} else {
			_asset.setDisabled();
			_asset._textfield = _asset.tfdisabled;
			_textfield = _asset.tfdisabled;
		}
		
		_textSize();
	}
	
	private function _setFocusable(focusable:Boolean):Void {
		
		_focusable = focusable;
		if (_textfield != undefined) {
			_textfield.tabEnabled = _focusable;
		}
	}

	private function _setTabIndex(tabIndex:Number):Void {

		_tabIndex = tabIndex;
		if (_focusable){
			if (_textfield != undefined){
				_textfield.tabIndex = _tabIndex;
			}
		}
	}

	private function _setFocus(assetFocus:Boolean):Void {

		if (assetFocus == undefined){
			assetFocus = true;
		}
		if (_focusable) {
			Selection.setFocus(_textfield);
			if (assetFocus) {
				_asset.focus();
			}
		}
	}
	
	private function _remove():Void {

		_ui.removeEventListener("styles", this);
		_ui.zoomManager.removeEventListener("textzoom", this);
		super._remove();
	}
		
}