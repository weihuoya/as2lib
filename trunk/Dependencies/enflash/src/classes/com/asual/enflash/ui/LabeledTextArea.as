import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.TextArea;

class com.asual.enflash.ui.LabeledTextArea extends Component {

	private var _label:Label;
	private var _input:TextArea;
	private var _name:String = "LabeledTextArea";
	
	private var _resizeFlag:Boolean = true;
	
	public function LabeledTextArea(id:String) {
		super(id);

		_label = new Label();
		_input = new TextArea();
	}
	
	public function get textfield():TextField {
		return _input.textfield;
	}
	
	public function get value():String {
		return _input.value;
	}
	
	public function set value(value:String):Void {
		_input.value = value;
	}

	public function get label():String {
		return _label.value;
	}
	
	public function set label(label:String):Void {
		_label.value = label;
	}
	
	public function get size():Number {
		return _input.size;
	}
	
	public function set size(size:Number):Void {
		_input.size = size;
	}	

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);

		_label.wordWrap = false;
		_label.addEventListener("load", this, _compLoad);
		_label.addEventListener("resize", this, _compResize);
		_label.init(_ref, _mc);

		_input.addEventListener("load", this, _compLoad);
		_input.addEventListener("resize", this, _compResize);
		_input.init(_ref, _mc);
	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		
		if (_label.value != undefined) {
			xml.firstChild.attributes.label = _label.value;
		}
		
		var inputXml = _input.getXML();
		for (var p in inputXml.firstChild.attributes) {
			if (p != "onload" && p != "onresize") {
				xml.firstChild.attributes[p] = inputXml.firstChild.attributes[p];
			}
		}

		if (xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.label != undefined) {
			_label.value = xml.attributes.label;
		}
		_input.setXML(xml);
		
		super._setXML(xml);
	}
	
	private function _setSize(w:Number, h:Number):Void {
			
		if (!_autoSize.w || !_autoSize.h){ 

			var lw, iw;

			lw = (_autoSize.w) ? _label.w : w - _pixel2zoom(_padding.left + _padding.right);
			if (lw != _label.w) {
				_resizeFlag = false;
				_label.w = lw;
				_resizeFlag = true;
			}

			iw = (_autoSize.w) ? _input.w : w - _pixel2zoom(_padding.left + _padding.right);
			if (iw != _input.w) {
				_resizeFlag = false;
				_input.w = iw;
				_resizeFlag = true;
			}
		}
		_input.move(_padding.left, _zoom2pixel(_label.h));		

		super._setSize(w, h);

	}
	
	private function _compLoad(evt:Object):Void {
		
		if (_label.loaded && _input.loaded) {
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
	
	private function _compResize(evt:Object):Void {
		if (_resizeFlag) {
			
			var w, h;
			
			if(_zoom){
				w = (_autoSize.w) ? _pixel2zoom(_input.pw + _padding.left + _padding.right) : _w;
				h = (_autoSize.h) ? _pixel2zoom(_label.ph + _input.ph + _padding.top + _padding.bottom) : _h;		
			} else {
				w = (_autoSize.w) ? (_input.pw + _padding.left + _padding.right) : _w;
				h = (_autoSize.h) ? (_label.ph + _input.ph + _padding.top + _padding.bottom) : _h;					
			}
			if (w != _w || h != _h){
				_setSize(w, h);
			}
		}
	}

	private function _setWidth(w:Number):Void {
		_label.w = w;
		_input.w = w;
		super._setWidth(w);
	}

	private function _setHeight(h:Number):Void {
		_label.h = h;
		_input.h = h;
		super._setHeight(h);
	}	


	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		if (_input != undefined){
			_input.tabIndex = tabIndex;
		}
	}

	private function _setEnabled(enabled:Boolean):Void {
		_enabled = enabled;
		_input.enabled = _enabled;
	}

	private function _setFocusable(focusable:Boolean):Void {
		
		_focusable = focusable;
		_input.focusable = focusable;
	}

	private function _setFocus(assetFocus:Boolean):Void {
		_input.focus(assetFocus);
	}

	private function _remove():Void {
	
		_label.removeEventListener("load", this);
		_label.removeEventListener("resize", this);
		_label.remove();
		
		_input.removeEventListener("load", this);
		_input.removeEventListener("resize", this);
		_input.remove();
		
		super._remove();
	}	
}