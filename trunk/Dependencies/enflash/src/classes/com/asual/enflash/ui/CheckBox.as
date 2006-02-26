import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;

class com.asual.enflash.ui.CheckBox extends Component {

	private var _button:Button;
	private var _label:Button;
	private var _value:String;
	private var _selected:Boolean = false;
	private var _size:Number = .8;
	private var _name:String = "CheckBox";
	
	public var onchange:Function;

	public function CheckBox(id) {
	
		super(id);

		_button = new Button();
		_label = new Button();
		
		_host = true;
	}

	public function get value():String {
		return _value;
	}
	
	public function set value(value:String):Void {
		_value = value;
	}
	
	public function get label():String {
		return _label.value;
	}
	
	public function set label(label:String):Void {
		_label.value = label;
	}

	public function get size():Number {
		return _size;
	}

	public function set size(size:Number):Void {
		_size = size;
		_setSize(_w, _h);
	}

	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(selected:Boolean):Void {
		_selected = selected;
		_button.asset.setCheck(_selected);
		dispatchEvent("change");
	}	

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);
	
		_button.swf = "checkbox.swf";
		_button.padding = 0;
		_button.focusable = true;
		_button.addEventListener("load", this, _compLoad);
		_button.addEventListener("release", this, _buttonRelease);
		_button.init(_ref, _mc);

		_label.margin = {top:.0, right:.0, bottom:.0, left:.5};
		_label.align = "left";
		_label.padding = 0;
		_label.swf = "";
		_label.addEventListener("load", this, _compLoad);
		_label.addEventListener("press", this, _labelPress);
		_label.addEventListener("release", this, _labelRelease);
		_label.addEventListener("dragout", this, _labelDragOut);
		_label.addEventListener("resize", this, _labelResize);
		_label.init(_ref, _mc);

	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();

		if (_button.swf != "checkbox.swf") {
			xml.firstChild.attributes.swf = _button.swf;
		}
		if (label != undefined) {
			xml.firstChild.attributes.label = label;
		}
		if (_value != undefined) {
			xml.firstChild.attributes.value = _value;
		}
		if (_selected) {
			xml.firstChild.attributes.selected = _selected;
		}
		if (getListeners("change").length > 0) {
			xml.firstChild.attributes.onchange = _getEvent("change");
		}

		if (toString() == "CheckBox" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "CheckBox" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		return xml;
	}
	
	private function _setXML(xml:XMLNode):Void {
		
		if (xml.attributes.label != undefined) {
			label = xml.attributes.label;
		}
		if (xml.attributes.value != undefined) {
			_value = xml.attributes.value;
		}
		if (xml.attributes.swf != undefined) {
			_button.swf = xml.attributes.swf;
		}
		if (xml.attributes.selected != undefined) {
			selected = (xml.attributes.selected == "true") ? true : false;
		}
		if (xml.attributes.onchange != undefined) {
			_setEvent("change", xml.attributes.onchange);
		}		
				
		super._setXML(xml);
	}	

	private function _load():Void {

		if (_label.value == undefined || _label.value.length < 1) {
			_label.margin = 0;
			_label.w = 0;
		}

		selected = _selected;

		_uiZoom();

		super._load();
	}
	
	private function _compLoad(evt:Object):Void {
		
		if (_button.loaded && _label.loaded) {
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

	private function _uiZoom():Void {
		
		_w = (_autoSize.w) ? _ui.labelHeight*_size + _padding.left +_padding.right + _label.w + _label.margin.left + _label.margin.right : _w;
		_h = (_autoSize.h) ? _ui.labelHeight*_size + _padding.top + _padding.bottom : _h;
		
		super._uiZoom();
	}
	
	private function _setSize(w:Number, h:Number):Void {

		_button.move(_ui.zoom2pixel(_padding.left), _ui.zoom2pixel(_padding.top));
		_button.setSize(h - _padding.left - _padding.right, h - _padding.top - _padding.bottom);
		_label.move(_ui.zoom2pixel(padding.left + _button.w + _label.margin.left), _ui.zoom2pixel(_padding.top + _label.margin.top - (h - _size)/4));		

		super._setSize(w, h);
	}	
	
	private function _labelPress(evt:Object):Void {
		_button.asset.setDownOver();
	}

	private function _labelRelease(evt:Object):Void {
		_buttonRelease();
		_button.asset.setUp();
	}

	private function _labelDragOut(evt:Object):Void {
		Selection.setFocus(_button.movieclip);
	}

	private function _labelResize(evt:Object):Void {
		if (_autoSize.w) {
			w = _ui.labelHeight*_size + _padding.left +_padding.right + _label.w + _label.margin.left + _label.margin.right;
		}
	}

	private function _buttonRelease(evt:Object):Void {
		Selection.setFocus(_button.movieclip);
		selected = !_selected;
	}

	private function _buttonDragOut(evt:Object):Void {
		Selection.setFocus(_button.movieclip);
	}

	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		if (_button != undefined) {
			_button.tabIndex = tabIndex;
		}
	}

	private function _setFocusable(focusable:Boolean):Void {
		
		_focusable = focusable;
		_button.focusable = focusable;
	}

	private function _setFocus(assetFocus:Boolean):Void {
		_button.focus(assetFocus);
	}
	
	private function _remove():Void {
	
		_button.removeEventListener("load", this);
		_button.removeEventListener("release", this);
		_button.remove();
		
		_label.removeEventListener("load", this);
		_label.removeEventListener("press", this);
		_label.removeEventListener("release", this);
		_label.removeEventListener("dragout", this);
		_label.removeEventListener("resize", this);
		_label.remove();

		super._remove();
	}
}