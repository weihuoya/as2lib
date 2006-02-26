import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Icon;

class com.asual.enflash.ui.ListItem extends Button {

	private var _icon:Icon;
	private var _expanded:Boolean = false;
	private var _name:String = "ListItem";

	public function ListItem(id:String) {

		super(id);
		
		margin = 0;
		padding = 0;
		
		_align = "left";
		_toggle = true;
		_focusable = false;
		_host = true;
		_swf = "listitem.swf";
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (_swf != "listitem.swf") {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (!_selected) {
			delete xml.firstChild.attributes.selected;
		}
		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		delete xml.firstChild.attributes.toggle;
		delete xml.firstChild.attributes.w;
		
		return xml;
	}

	private function _setSize(w:Number, h:Number):Void {
		
		super._setSize(w, h);
		if (_icon != undefined) {
			_icon.move(_zoom2pixel(_padding.left + _label.margin.left) + _icon.margin.left, _icon.margin.top);
		}
	}	
	
}