import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.Label;

class com.asual.enflash.ui.Bar extends Component {
	
	private var _items:Collection;
	private var _name:String = "Bar";
	
	public function Bar(id:String) {
		super(id);
		_host = true;
		_swf = "bar.swf";
		_focusable = false;
	}

	public function addItem(component:Component) {
		return _addItem(component);
	}		

	public function addItemAt(index:Number, component:Component) {
		return _addItemAt(index, component);
	}

	public function removeItem(component:Component):Void {
		_removeItem(component);
	}	

	public function removeItemAt(index:Number):Void {
		_removeItemAt(index);
	}

	public function getItem(index:Number) {
		return _items.getItem(index);
	}	

	public function getIndex(component:Component) {
		return _items.getIndex(component);
	}	

	public function get length():Number {
		return _items.length;
	}
	
	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		super._init(parent, mc, depth);
		_items = new Collection();
		_items.init(_ref, _mc);
		_padding = {top:.4, right:.4, bottom:.4, left:.8};
		margin = 0;
	}

	private function _addItem(component:Component) {
		var item = (component != undefined) ? component : new Button();
		item.focusable = false;
		item.addEventListener("load", this, _compLoad);
		item.addEventListener("resize", this, _position);
		_items.addItem(item);
		if (_ui.visible) {
			_position();
		}
		return item;
	}
	
	private function _addItemAt(index:Number, component:Component) {
		var item = (component != undefined) ? component : new Button();
		item.focusable = false;
		item.addEventListener("load", this, _compLoad);
		item.addEventListener("resize", this, _position);
		_items.addItemAt(index, item);
		if (_ui.visible) {
			_position();
		}
		return item;
	}
	
	private function _removeItem(component:Component):Void {
		component.removeEventListener("load", this);
		component.removeEventListener("resize", this);
		_items.removeItem(component);
		if (_ui.visible) {
			_position();
		}
	}	
	
	private function _removeItemAt(index:Number):Void {
		_items.getItem(index).removeEventListener("load", this);
		_items.getItem(index).removeEventListener("resize", this);
		_items.removeItemAt(index);
		if (_ui.visible) {
			_position();
		}
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		delete xml.firstChild.attributes.w;
		delete xml.firstChild.attributes.h;

		if (_swf != "bar.swf" && _swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "top: 0.4, right: 0.4, bottom: 0.4, left: 0.8") {
			delete xml.firstChild.attributes.padding;
		}
		
		var item;
		var i:Number = -1;
		var iMax:Number = _items.length;
		while(++i != iMax) {

			item = _items.getItem(i).getXML();
			
			delete item.firstChild.attributes.onresize;
			delete item.firstChild.attributes.onload;

			xml.firstChild.appendChild(item);
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		var item, node;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
			
			item = xml.childNodes[i];
			switch(item.nodeName) {
				case "Button":
					node = addItem(new Button(item.attributes.id));
					break;
				case "Label":
					node = addItem(new Label(item.attributes.id));
					node.wordWrap = false;
					break;
			}			
			node.margin = 0;
			node.setXML(item);
	
		}
		super._setXML(xml);
	}	
		
	private function _setSize(w:Number, h:Number):Void {
		
		_items.move(_zoom2pixel(_padding.left), _zoom2pixel(_padding.top));
		_items.setSize(_zoom2pixel(w - _padding.left - _padding.right), _zoom2pixel(h - _padding.top - _padding.bottom));
		
		super._setSize(w, h);
	
		_position();
	}

	private function _position():Void {

		var neww = 0
		var lw = 0;
		var rw = 0;
		var newh = 0;
		
		var i:Number = -1
		var iMax:Number = _items.length;
		while (++i != iMax){
			
			var item = _items.getItem(i);
			
			if (item.float == "right") {
				rw += item.w + item.margin.left + item.margin.right;
				item.move(_items.w - _zoom2pixel(rw - item.margin.left), _zoom2pixel(item.margin.top));
			} else {
				item.move(_zoom2pixel(lw + item.margin.left), _zoom2pixel(item.margin.top));
				lw += item.w + item.margin.left + item.margin.right;
			}
			
			neww = lw + rw;
			if (newh < item.h) newh = item.h + item.margin.top + item.margin.bottom;
		}
		newh = newh + _padding.top + _padding.bottom;
		
		if (h != newh) _setSize(_w, newh);
	}

	private function _compLoad(evt:Object):Void {

		var i = _items.length;
		while(i--) {
			if (!_items.getItem(i).loaded) {
				return;
			}
		}
		
		switch (_status) {
			case 0:
				_status = 2;
				break;
			case 1:
				_status = 3;
				_load();
				break;
			case 3:
				_position();
				_load();
				break;
		}
	}
}