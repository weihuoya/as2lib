import com.asual.enflash.ui.Component;

class com.asual.enflash.ui.ProgressBar extends Component {
	
	private var _value:Number = 0;
	private var _name:String = "ProgressBar";
	
	public function ProgressBar(id:String) {
		super(id);
		_swf = "progressbar.swf";
		_w = 20;
	}

	public function get value():Number {
		return _value;
	}
	
	public function set value(value:Number):Void {	
		_value = value;
		_asset.setValue(_value);
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (_swf != "progressbar.swf" && _swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}

		if (_value != undefined) {
			xml.firstChild.attributes.value = _value;
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}

		super._setXML(xml);
	}

	private function _load():Void {
		super._load();
		
		_setSize(_w, _ui.labelHeight);
		value = _value;
	}

	private function _setSize(w:Number, h:Number):Void {
		super._setSize(w, h);
		value = _value;
	}

}