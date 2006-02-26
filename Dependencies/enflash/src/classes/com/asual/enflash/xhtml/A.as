import com.asual.enflash.ui.Label;

class com.asual.enflash.xhtml.A extends Label {

	private var _href:String;
	private var _target:String;
	
	public function A(id:String) {
		super(id);
	}

	public function get href():String {
		return _href;
	}	
	
	public function set href(href:String):Void {
		_href = href;
	}

	public function get target():String {
		return _target;
	}	
	
	public function set target(target:String):Void {
		_target = target;
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (_href != undefined){
			xml.firstChild.attributes.href = _href;
		} 
		if (_target != undefined){
			xml.firstChild.attributes.target = _target;
		} 
		if (_value != undefined){
			xml.firstChild.appendChild(new XML(_value));
		}
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.href != undefined) {
			href = xml.attributes.href;
		}
		if (xml.attributes.target != undefined) {
			target = xml.attributes.target;
		}
		if (xml.firstChild.nodeValue != undefined) {
			value = xml.firstChild.nodeValue;
		}
		super._setXML(xml);
	}

	private function _setValue(value:String):Void {
		super._setValue("<a href=\"" + _href + "\" target=\"" + _target + "\">" + value + "</a>");
	}

}