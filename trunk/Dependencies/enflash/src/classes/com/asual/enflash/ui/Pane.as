import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.ScrollBar;
import com.asual.enflash.ui.Component;

import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.Pane extends Component {

	private var _vScrollPolicy:String = "auto";
	private var _hScrollPolicy:String = "auto";

	private var _rect:Button;
	private var _content:Collection;

	private var _scrollSize:Number = 0;
	private var _scrollSpace:Number = 0;

	private var _vScroll:ScrollBar;
	private var _hScroll:ScrollBar;
	
	private var _minWidth:Number = 7;
	private var _minHeight:Number = 7;

	private var _autoRefresh:Boolean = true;
	private var _name:String = "Pane";

	public var oncomponents:Function;

	public function Pane(id:String){

		super(id);
		_host = true;
		_focusable = true;
	}

	public function addItem(component:Component){
		return _addItem(component);
	}

	public function addItemAt(index:Number, component:Component){
		return _addItemAt(index, component);
	}

	public function removeAll(remove:Boolean):Array {
		var items = _content.removeAll(remove);
		if (_autoRefresh) {
			refresh();
		}
		return items;
	}
	
	public function removeItem(component:Component) {
		var item = _content.removeItem(component);
		if (_autoRefresh) {
			refresh();
		}
		return item;
	}
	
	public function removeItemAt(index:Number) {
		var item = _content.removeItemAt(index);
		if (_autoRefresh) {
			refresh();
		}
		return item;
	}
	
	public function refresh():Void {
		if (_ui.visible){
			_setSize(_w, _h);
		}
	}
	
	public function getItem(i:Number) {
		return _content.getItem(i);
	}

	public function getIndex(item):Number {
		return _content.getIndex(item);
	}
	
	public function get length():Number {
		return _content.length;
	}

	public function get autoRefresh():Boolean {
		return _autoRefresh;
	}

	public function set autoRefresh(autoRefresh:Boolean):Void {
		_autoRefresh = autoRefresh;
		if (_autoRefresh) {
			refresh();
		}
	}

	public function get asset():MovieClip {
		return _rect.asset;
	}

	public function get hScrollPolicy():String {
		return _hScrollPolicy;
	}
	
	public function set hScrollPolicy(policy:String):Void {
		_hScrollPolicy = policy;
	}
	
	public function get vScrollPolicy():String {
		return _vScrollPolicy;
	}
	
	public function set vScrollPolicy(policy:String):Void {
		_vScrollPolicy = policy;
	}

	public function get minWidth():Number {
		return _minWidth;
	}
	
	public function set minWidth(minWidth:Number):Void {
		_minWidth = minWidth;
	}

	public function get minHeight():Number {
		return _minHeight;
	}
	
	public function set minHeight(minHeight:Number):Void {
		_minHeight = minHeight;
	}

	public function get smallStep():Number {
		return _hScroll.smallStep;
	}

	public function set smallStep(smallStep:Number):Void {
		_hScroll.smallStep = smallStep;
		_vScroll.smallStep = smallStep;
	}

	public function get largeStep():Number {
		return _hScroll.largeStep;
	}

	public function set largeStep(largeStep:Number):Void {
		_hScroll.largeStep = largeStep;
		_vScroll.largeStep = largeStep;
	}	

	public function get hPosition():Number {
		return _hScroll.position;
	}
	
	public function set hPosition(position:Number):Void {
		_hScroll.position = position;
	}
	
	public function get vPosition():Number {
		return _vScroll.position;
	}
	
	public function set vPosition(position:Number):Void {
		_vScroll.position = position;
	}

	public function get contentWidth():Number {
		return _getContentWidth();
	}

	public function get contentHeight():Number {
		return _getContentHeight();
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		padding = .1;

		_ui.themeManager.addEventListener("panesize", this, refresh);

		_scrollSpace = _ui.theme.space;

		_rect = new Button();
		_rect.swf = "pane.swf";
		_rect.addEventListener("load", this, _compLoad);
		_rect.focusable = true;
		_rect.init(_ref, _mc);
		
		delete _rect.movieclip.onRollOver;
		delete _rect.movieclip.onRollOut;
		delete _rect.movieclip.onPress;
		delete _rect.movieclip.onRelease;
		
		_rect.movieclip.onPress = createDelegate(this, _rectPress);

		_content = new Collection();
		_content.init(_ref, _mc);

		_hScroll = new ScrollBar();
		_hScroll.addEventListener("load", this, _compLoad);	
		_hScroll.init(_ref, _mc, 11);
		_hScroll.horizontal = true;
		_hScroll.content = _content;

		_vScroll = new ScrollBar();
		_vScroll.addEventListener("load", this, _compLoad);
		_vScroll.init(_ref, _mc, 12);
		_vScroll.content = _content;

	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		
		if (_minWidth != 7) {
			xml.firstChild.attributes.minWidth = _minWidth;
		}
		if (_minHeight != 7) {
			xml.firstChild.attributes.minHeight = _minHeight;
		}
		if (_vScrollPolicy != "auto") {
			xml.firstChild.attributes.vScrollPolicy = _vScrollPolicy;
		}
		if (_hScrollPolicy != "auto") {
			xml.firstChild.attributes.hScrollPolicy = _hScrollPolicy;
		}
		if (_rect.swf != "pane.swf" && _rect.swf != undefined) {
			xml.firstChild.attributes.swf = _rect.swf;
		}
		if (getListeners("components").length > 0) {
			xml.firstChild.attributes.oncomponents = _getEvent("components");
		}
		if (toString() == "Pane" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Pane" && xml.firstChild.attributes.padding == "0.1") {
			delete xml.firstChild.attributes.padding;
		}

		if (_content.length != undefined) {
			var node;
			var i = -1;
			var iMax = _content.length;
			while(++i != iMax) {
				xml.firstChild.appendChild(_content.getItem(i).getXML());
			}
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
	
		if (xml.attributes.minWidth != undefined) {
			minWidth = Number(xml.attributes.minWidth);
		}
		if (xml.attributes.minHeight != undefined) {
			minHeight = Number(xml.attributes.minHeight);
		}
		if (xml.attributes.vScrollPolicy != undefined) {
			vScrollPolicy = xml.attributes.vScrollPolicy;
		}		
		if (xml.attributes.hScrollPolicy != undefined) {
			hScrollPolicy = xml.attributes.hScrollPolicy;
		}		
		if (xml.attributes.swf != undefined) {
			_rect.swf = xml.attributes.swf;
		}
		if (xml.attributes.oncomponents != undefined) {
			_setEvent("components", xml.attributes.oncomponents);
		}	
		super._setXML(xml);
	}

	private function _compLoad(evt:Object):Void {

		if (_rect.loaded && _hScroll.loaded && _vScroll.loaded) {

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

	private function _addItem(component:Component){

		component = _content.addItem(component);
		if (_ui.visible) {
			if (_enflash.conf.themesLoading) {
				component.addEventListener("load", this, _componentLoad);
			} else {
				if (_autoRefresh) {
					refresh();
				}
			}
		}
		return component;
	}

	private function _addItemAt(index:Number, component:Component){

		component =  _content.addItemAt(index, component);
		if (_ui.visible) {
			if (_enflash.conf.themesLoading) {
				component.addEventListener("load", this, _componentLoad);
			} else {
				if (_autoRefresh) {
					refresh();
				}
			}
		}
		return component;
	}

	private function _setSize(w:Number, h:Number):Void {

		_scrollSpace = _ui.theme.space;
		_scrollSize = _ui.theme.scroll;		

		w = Math.max(w, _minWidth);
		h = Math.max(h, _minHeight);

		if (_ui.visible && !_rect != undefined) {
			_rect.setSize(w, h);
			_content.move(_scrollSpace, _scrollSpace);
			_setScrollersSize(w, h);
		}		

		super._setSize(w, h);
	}
	
	private function _getContentWidth():Number {
		
		var item;
		var w = 0;
		var i = _content.length;
		while(i--) {
			item = _content.getItem(i);
			if (item.visible && item.pw > w) {
				w = item.pw;
			}
		}
		return (w + _zoom2pixel(_padding.left + _padding.right));
	}

	private function _getContentHeight():Number {
		
		var item;
		var h = 0;
		var i = _content.length;
		while(i--) {
			item = _content.getItem(i);
			if (item.visible) {
				h += _content.getItem(i).ph;
			}
		}
		return (h + _zoom2pixel(_padding.top + _padding.bottom));
	}
	
	private function _setScrollersSize(w, h):Void {

		_hScroll.move(_scrollSpace, _zoom2pixel(h - _scrollSize) - _scrollSpace);
		_vScroll.move(_zoom2pixel(w - _scrollSize) - _scrollSpace, _scrollSpace);

		switch(_hScrollPolicy){
			case "off":
				_hScroll.visible = false;
				switch(_vScrollPolicy){
					case "off":
						_vScroll.visible = false;
						_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
						break;
					case "on":
						_vScroll.visible = true;
						_vScroll.setSize(_scrollSize, h - _pixel2zoom(_scrollSpace*2));
						_content.setSize(_zoom2pixel(w - _vScroll.w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);						
						break;
					case "auto":
						_vScroll.setSize(_scrollSize, h - _pixel2zoom(_scrollSpace*2));
						if (_vScroll.enabled) {
							_vScroll.visible = true;
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
						} else {
							_vScroll.visible = false;
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
						}
						break;
				}
				break;
			case "on":
				_hScroll.visible = true;
				switch(_vScrollPolicy){
					case "off":
						_vScroll.visible = false;
						_hScroll.setSize(w - _pixel2zoom(_scrollSpace*2), _scrollSize);
						_hScroll.move(_scrollSpace, _pixel2zoom(h - _scrollSize) - _scrollSpace);
						_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
						break;
					case "on":
						_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
						_vScroll.visible = true;			
						_vScroll.setSize(_scrollSize, h - _scrollSize - _pixel2zoom(_scrollSpace*2));							
						_hScroll.setSize(w - _scrollSize - _pixel2zoom(_scrollSpace*2), _scrollSize);
						break;
					case "auto":
						_vScroll.setSize(_scrollSize, h  - _scrollSize - _pixel2zoom(_scrollSpace*2));
						_vScroll.visible = _vScroll.enabled;
						if (_vScroll.enabled) {
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
							_hScroll.setSize(w - _scrollSize - _pixel2zoom(_scrollSpace*2), _scrollSize);
						} else {
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
							_hScroll.setSize(w - _pixel2zoom(_scrollSpace*2), _scrollSize);
						}
						break;
				}
				break;
			case "auto":
				switch(_vScrollPolicy){
					case "off":
						_vScroll.visible = false;
						_hScroll.setSize(w - _pixel2zoom(_scrollSpace*2), _scrollSize);
						if (_hScroll.enabled){
							_hScroll.visible = true;
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
						} else {
							_hScroll.visible = false;
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
						}
						break;
					case "on":
						_vScroll.visible = true;			
						_vScroll.setSize(_scrollSize, h - _scrollSize - _pixel2zoom(_scrollSpace*2));
						_hScroll.setSize(w - _scrollSize - _pixel2zoom(_scrollSpace*2), _scrollSize);
						_hScroll.visible = _hScroll.enabled;
						if (_hScroll.enabled){
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
							_vScroll.setSize(_scrollSize, h - _scrollSize - _pixel2zoom(_scrollSpace*2));
						} else {
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
							_vScroll.setSize(_scrollSize, h - _pixel2zoom(_scrollSpace*2));
						}							
						_hScroll.setSize(w - _scrollSize - _pixel2zoom(_scrollSpace*2), _scrollSize);
						_hScroll.visible = _hScroll.enabled;
						if (_hScroll.enabled){
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
							_vScroll.setSize(_scrollSize, h - _scrollSize - _pixel2zoom(_scrollSpace*2));
						} else {
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
							_vScroll.setSize(_scrollSize, h - _pixel2zoom(_scrollSpace*2));
						}
						break;
					case "auto":
						_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
						_hScroll.setSize(w - _scrollSize - _pixel2zoom(_scrollSpace*2), _scrollSize);
						_vScroll.setSize(_scrollSize, h - _scrollSize - _pixel2zoom(_scrollSpace*2));
						
						if (_vScroll.enabled && _hScroll.enabled) {
							_hScroll.visible = true;
							_vScroll.visible = true;
						} else if (_hScroll.enabled){
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h - _scrollSize) - _scrollSpace*2);
							_hScroll.setSize(w - _pixel2zoom(_scrollSpace*2), _scrollSize);
							_hScroll.visible = _hScroll.enabled;
							_vScroll.visible = false;
							if (!_hScroll.enabled) {
								_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
							}
						} else if (_vScroll.enabled) {
							_content.setSize(_zoom2pixel(w - _scrollSize) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);								
							_vScroll.setSize(_scrollSize, h - _pixel2zoom(_scrollSpace*2));
							_hScroll.visible = false;
							_vScroll.visible = _vScroll.enabled;
							if (!_vScroll.enabled) {
								_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);								
							}
						} else {
							_content.setSize(_zoom2pixel(w) - _scrollSpace*2, _zoom2pixel(h) - _scrollSpace*2);
							_hScroll.visible = false;
							_vScroll.visible = false;
						}
						break;
				}
				break;
		}
		
		if (_hScrollPolicy == "off") _hScroll.visible = false;
		if (_vScrollPolicy == "off") _vScroll.visible = false;	

	}

	private function _componentLoad(evt:Object):Boolean {

		evt.target.removeEventListener("load", this, _componentLoad);

		var i:Number = _content.length;
		while(i--) {
			if (!_content.getItem(i).loaded) {
				return false;
			}
		}

		if (_autoRefresh) {
			refresh();
		}
		dispatchEvent("components");

		return true;
	}
	
	private function _rectPress(evt:Object):Void {
		Selection.setFocus(_rect.movieclip);
	}

	private function _setEnabled(enabled:Boolean):Void {

		_rect.enabled = enabled;
		_vScroll.enabled = enabled;
		_hScroll.enabled = enabled;

		var i = -1;
		var iMax = _content.length;
		while(++i != iMax) {
			_content.getItem(i).enabled = enabled;
		}

		if (!enabled && _rect == _ui.focus){
			_blur();
			Time.setTimeout(Selection, "setFocus", 2, null);
		}	

		super._setEnabled(enabled);
	}

	private function _setTabIndex(tabIndex:Number):Void {
		_tabIndex = tabIndex;
		_rect.tabIndex = tabIndex;
	}

	private function _setFocus(assetFocus:Boolean):Void {
		_rect.focus(assetFocus);
	}
		
	private function _remove():Void {

		removeDelegate(_rect.movieclip, _rect.movieclip.onPress);

		removeAll();

		_content.removeEventListener("resize", this);
		_content.remove();

		_ui.themeManager.removeEventListener("panesize", this);		
		
		super._remove();	
	}			
}