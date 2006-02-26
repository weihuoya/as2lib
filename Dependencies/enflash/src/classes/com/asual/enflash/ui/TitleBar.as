import com.asual.enflash.ui.Bar;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Label;

class com.asual.enflash.ui.TitleBar extends Bar {
	
	private var _label:Label;
	private var _value:String;
	private var _name:String = "TitleBar";

	private var _close:Boolean = false;
	private var _closeButton:Button;
	
	public var onclose:Function;
	
	public function TitleBar(id:String) {
		super(id);
	}

	public function get label():Label {
		return _label;
	}

	public function get close():Boolean {
		return _close;
	}
	
	public function set close(close:Boolean):Void {	
		
		_close = close;

		if (_close) {
			_closeButton = new Button();
			_closeButton.float = "right";
			_closeButton.margin = 0;
			_closeButton.padding = 0;
			_closeButton.addEventListener("release", this, _closeRelease);
			addItem(_closeButton);
		} else if (_closeButton != undefined) {
			_closeButton.remove();
		}
	}
	
	public function get value():String {
		return _value;
	}
	
	public function set value(value:String):Void {	
		
		_value = value;
		if (_mc != undefined) {
			_label.value = "<b>" + _value + "</b>";
		}
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);

		_label = new Label();
		_label.selectable = false;
		_label.wordWrap = false;
		_label.margin = 0;
		addItem(_label);

		if (_value != undefined) {
			value = _value;
		}
	}

	private function _addItem(component:Component) {
		var item = (component != undefined) ? component : new Button();
		switch(component.toString()) {
			case "Button":
				component.swf = "titlebarbutton.swf";
				break;
		}
		return super._addItem(component);
	}
	
	private function _addItemAt(index:Number, component:Component) {
		var item = (component != undefined) ? component : new Button();
		switch(component.toString()) {
			case "Button":
				component.swf = "titlebarbutton.swf";
				break;
		}
		return super._addItemAt(index, component);
	}
		
	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		xml.firstChild.firstChild.removeNode();

		if (_value != undefined) {
			xml.firstChild.attributes.value = _value;
		}
		if (_label.fontFace != undefined) {
			xml.firstChild.attributes.fontFace = _label.fontFace;
		}
		if (_label.fontSize != undefined && _label.fontSize != 0) {
			xml.firstChild.attributes.fontSize = _label.fontSize;
		}
		if (_label.fontColor != undefined) {
			xml.firstChild.attributes.fontColor = "0x" + _label.fontColor.toString(16);
		}
		
		return xml;
	}
	
	private function _setXML(xml:XMLNode):Void {
		
		if (xml.attributes.value != undefined) {
			value = String(xml.attributes.value);
		}
		if (xml.attributes.fontFace != undefined) {
			_label.fontFace = String(xml.attributes.fontFace);
		}
		if (xml.attributes.fontSize != undefined) {
			_label.fontSize = Number(xml.attributes.fontSize);
		}
		if (xml.attributes.fontColor != undefined) {
			_label.fontColor = Number(xml.attributes.fontColor);
		}
		super._setXML(xml);
	}

	private function _setSize(w:Number, h:Number):Void {
		
		super._setSize(w, h);
		
		var lw = w - _padding.left - _padding.right;
		if (_items.length > 1) {
			var i = 0;
			var iMax = _items.length;
			var item;
			while(++i != iMax) {
				item = _items.getItem(i);
				lw = lw - item.w - item.margin.left - item.margin.right;
			}	
		}
		_label.w = lw;
	}

	private function _closeRelease(evt:Object):Void {
		dispatchEvent("close");	
	}

	private function _remove():Void {	
		
		_label.removeEventListener("load", _label);
		_label.remove();
				
		if (_close) {
			_closeButton.remove();
		}

		super._remove();
	}
}