import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Icon;
import com.asual.enflash.ui.Label;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.Button extends Component {

	private var _label:Label;
	private var _value:String;
	private var _align:String = "center";
	private var _toggle:Boolean;
	private var _selected:Boolean = false;
	private var _key:Boolean = false;
	private var _press:Boolean = false;
	private var _over:Boolean = false;
	private var _resizeFlag:Boolean = true;
	private var _icon:Icon;
	private var _linkage:String;
	private var _name:String = "Button";

	private var _draggable:Boolean = false;	
	private var _dragged:Boolean = false;
	private var _dragObject:Object;
	private var _doublepress:Number;
	private var _doubletime:Number = 500;
	
	public var onrollover:Function;
	public var onrollout:Function;	
	
	public var onpress:Function;
	public var ondoublepress:Function;
	public var onrelease:Function;
	public var onreleaseoutside:Function;

	public var ondragout:Function;
	public var ondragbegin:Function;
	public var ondrag:Function;
	public var ondragend:Function;

	public var onchange:Function;
	public var onvalue:Function;

	public function Button(id:String) {
		
		super(id);
		
		_swf = "button.swf";
		_focusable = true;
		padding = .5;
	}

	public function get icon():String {
		return _linkage;
	}

	public function set icon(linkage:String):Void {
		
		_linkage = linkage;
		if (_mc != undefined) {
			if (_icon != undefined) {
				_icon.remove();				
			}
			_icon = new Icon(_linkage);
			_icon.init(_ref, _mc);
			_icon.margin = 3;
			_setSize(_w, _h);
		}
	}
	
	public function get label():Label {
		return _label;
	}

	public function get value():String {
		return _value;
	}
	
	public function set value(value:String):Void {	
		_setValue(value);
	}

	public function get align():String {
		return _align;
	}

	public function set align(align:String):Void {
		_align = align;
		if (_label != undefined) {
			_label.align = _align;
		}
	}

	public function get toggle():Boolean {
		return _toggle;
	}

	public function set toggle(toggle:Boolean):Void {
		_toggle = toggle;
	}

	public function get selected():Boolean {
		return _selected;
	}

	public function set selected(selected:Boolean):Void {
		_setSelected(selected);
	}

	public function get draggable():Boolean {
		return _draggable;
	}	

	public function set draggable(draggable:Boolean):Void {

		_draggable = draggable;
		if(_draggable){
			_dragObject = new Object();
		} else {
			delete _dragObject;
		}
	}

	public function get dragProperties():Object {

		var dragProperties = new Object();
		dragProperties.left = _dragObject.left;
		dragProperties.top = _dragObject.top;
		dragProperties.right = _dragObject.right;
		dragProperties.bottom = _dragObject.bottom;		
		
		return dragProperties;
	}	

	public function set dragProperties(dragProperties:Object):Void {

		_dragObject.left = dragProperties.left;
		_dragObject.top = dragProperties.top;
		_dragObject.right = dragProperties.right;
		_dragObject.bottom = dragProperties.bottom;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);

		_mc.onRollOver = createDelegate(this, _mcRollOver);
		_mc.onRollOut = createDelegate(this, _mcRollOut);
		_mc.onPress = createDelegate(this, _mcPress);
		_mc.onRelease = createDelegate(this, _mcRelease);
		_mc.onReleaseOutside = createDelegate(this, _mcReleaseOutside);

		if (_value != undefined) {
			value = _value;
		}
		
		if (_linkage != undefined) {
			icon = _linkage;
			if (_label == undefined) {
				_load();
			}
		}

		if (_draggable) {
			_dragObject = new Object();
		}
	}
	
	private function _getXML():XMLNode {
		
		var xml = super._getXML();

		if (_swf != "button.swf" && _swf != undefined) {
			xml.firstChild.attributes.swf = _swf;
		} else {
			delete xml.firstChild.attributes.swf;
		}
		if (_align == "right" || _align == "center") {
			xml.firstChild.attributes.align = _align;
		}
		if (_icon.linkage != undefined) {
			xml.firstChild.attributes.icon = _icon.linkage;
		}
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
		if (_toggle) {
			xml.firstChild.attributes.toggle = _toggle;
			xml.firstChild.attributes.selected = _selected;
		}
		if (toString() == "Button" && xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "Button" && xml.firstChild.attributes.padding == "0.5") {
			delete xml.firstChild.attributes.padding;
		}
		if (getListeners("press").length > 0) {
			xml.firstChild.attributes.onrelease = _getEvent("press");
		}
		if (getListeners("release").length > 0) {
			xml.firstChild.attributes.onrelease = _getEvent("release");
		}

		return xml;
	}
	
	private function _setXML(xml:XMLNode):Void {
		
		if (xml.attributes.value != undefined) {
			value = xml.attributes.value;
		}
		if (xml.attributes.align == "left" || xml.attributes.align == "right" || xml.attributes.align == "center") {
			align = xml.attributes.align;
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
		if (xml.attributes.toggle != undefined) {
			toggle = (xml.attributes.toggle == "true") ? true : false;
		}
		if (xml.attributes.selected != undefined) {
			selected = (xml.attributes.selected == "true") ? true : false;
		}
		if (xml.attributes.icon != undefined) {
			icon = xml.attributes.icon;
		}
		if (xml.attributes.onpress != undefined) {
			_setEvent("press", xml.attributes.onpress);
		}
		if (xml.attributes.onrelease != undefined) {
			_setEvent("release", xml.attributes.onrelease);
		}
		
		super._setXML(xml);
	}
		
	private function _mcRollOver(evt:Object):Void {

		if (Key.isDown(Key.TAB) && !_asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
			return;	
		}
			
		_over = true;

		if (_selected){ 
			_asset.setDownOver();
		} else { 
			_asset.setUpOver();
		}
		dispatchEvent("rollover");
	}

	private function _mcRollOut(evt:Object):Void {

		if(_over) {
			if (_selected){ 
				_asset.setDown();
			} else { 
				_asset.setUp();
			}
			_over = false;		
			dispatchEvent("rollout");
		}
	}

	private function _mcPress(evt:Object):Void {

		_press = true;

		if (_doublepress + _doubletime > getTimer()) {

			dispatchEvent("doublepress");

			_doublepress = _doublepress - _doubletime;
			_asset.setDownOver();

		} else {

			if (_toggle) {
				selected = !_selected;
			}
			
			_asset.setDownOver();

			if (_focusable && eval(Selection.getFocus()) != _mc){
				Selection.setFocus(_mc);
			}

			if (_draggable) {
				_dragStart();
			}

			_mc.onDragOut = createDelegate(this, _mcDragOut);
			_doublepress = getTimer();
			dispatchEvent("press");
		}
	}

	private function _mcRelease(evt:Object):Void {
		
		if (_selected){
			if (_over){
				_asset.setDownOver();
			} else {
				_asset.setDown();
			}	
		} else {
			if (_over){
				_asset.setUpOver();
			} else {
				_asset.setUp();
			}	
		}
		_press = false;
		
		if (_draggable) {
			_dragStop();	
		} 

		delete _mc.onDragOut;
		dispatchEvent("release");
	}
	
	private function _mcReleaseOutside(evt:Object):Void {
		
		if (_selected){
			_asset.setDown();
		} else {
			_asset.setUp();
		}
		_press = false;
		
		if (_draggable) {
			_dragStop();	
		}
		
		delete _mc.onDragOut;
		dispatchEvent("releaseoutside");
	}
	
	private function _mcDragOut(evt:Object):Void {

		if (!_dragged) {
		
			if (_selected){ 
				_asset.setDown();
			} else { 
				_asset.setUp();
			}
			_press = false;	
			_over = false;
		}
		
		dispatchEvent("dragout");
	}
	
	private function _keyDown(evt:Object):Void {
		if((Key.getCode() == Key.SPACE || Key.getCode() == Key.ENTER)&& !_key){
			_key = true;
			_mcPress();
		}		
	}
	
	private function _keyUp(evt:Object):Void {

		if((Key.getCode() == Key.SPACE || Key.getCode() == Key.ENTER) && _key){
			_key = false;
			_mcRelease();
		}		
	}
	
	private function _dragStart(lock, left, top, right, bottom):Void {

		dispatchEvent("dragbegin");
		
		_dragged = true;
		
		_dragObject.cx = Math.round(_enflash.movieclip._xmouse - x);
		_dragObject.cy = Math.round(_enflash.movieclip._ymouse - y);
		
		_ui.addEventListener("enterframe", this, _drag);
	}

	private function _drag(){
		
		var nx = Math.round(_enflash.movieclip._xmouse - _dragObject.cx);
		var ny = Math.round(_enflash.movieclip._ymouse - _dragObject.cy);
		
		if (_dragObject.left != undefined && _dragObject.left > nx) {
			nx = _dragObject.left;	
		}
		if (_dragObject.top != undefined && _dragObject.top > ny){
			ny = _dragObject.top;
		} 
		if (_dragObject.right != undefined && _dragObject.right < nx + _pw){
			nx = _dragObject.right - _pw;
		} 
		if (_dragObject.bottom != undefined && _dragObject.bottom < ny + _ph){
			ny = _dragObject.bottom - _ph;	
		}
		
		if (nx != x || ny != y){
			move(nx, ny);			
			dispatchEvent("drag");
		}
	}
	
	private function _dragStop():Void {
		
		_ui.removeEventListener("enterframe", this);
		
		_drag();
		_dragged = false;
		
		dispatchEvent("dragend");
	}

	private function _setSelected(selected:Boolean):Void {

		if (_selected != selected) {

			_selected = selected;

			if (_selected){
				if (_over){
					_asset.setDownOver();
				} else {
					_asset.setDown();
				}	
			} else {
				if (_over){
					_asset.setUpOver();
				} else {
					_asset.setUp();
				}	
			}
			dispatchEvent("change");
		}
	}

	private function _setEnabled(enabled:Boolean):Void {
		
		if (_selected){
			if (enabled){
				asset.setDown();
			} else {
				asset.setDownDisabled();
			}	
		} else { 
			if (enabled){
				asset.setUp();
			} else {
				asset.setUpDisabled();
			}
		}
		
		if (_label != undefined && _label.enabled != enabled) {
			_label.enabled = enabled;
		}
	
		if (!enabled && this == _ui.focus){
			_blur();
			Time.setTimeout(Selection, "setFocus", 2, null);
		}
		
		super._setEnabled(enabled);
	}

	private function _setAutoSize(autoSize:Object):Void {
		
		super._setAutoSize(autoSize);
		
		if (_label != undefined){ 
			_label.autoSize = {w:_autoSize.w, h:_autoSize.h};
			if (_autoSize.w || _autoSize.h){
				if (!Arrays.contains(_label.getListeners("resize"), this)){
					_label.addEventListener("resize", this, _labelResize);
				}
			} else {
				_label.removeEventListener("resize", this);
			}
		}
	}

	private function _setZoom(zoom:Boolean):Void {
		super._setZoom(zoom);
		if (_label != undefined) {
			_label.zoom = _zoom;
		}
	}

	private function _setValue(value:String):Void {
		
		_value = value;
		_host = true;
		
		if (_mc != undefined) {
			if (_label == undefined){
				_label = new Label();
				_label.wordWrap = false;
				_label.selectable = false;
				_label.margin = 0;
				_label.zoom = _zoom;
				_label.align = _align;
				_label.addEventListener("load", this, _labelLoad);
				_label.value = _value;

				autoSize = _autoSize;

				_label.init(_ref, _mc);

			} else {
				_label.value = _value;
			}
		}
		dispatchEvent("value");
	}

	private function _load():Void {

		selected = _selected;
		enabled = _enabled;	

		var w, h;

		if (_label == undefined) {
			_w = (_autoSize.w) ? _ui.labelHeight + _padding.left + _padding.right : _w;
			_h = (_autoSize.h) ? _ui.labelHeight + _padding.top + _padding.bottom : _h;
		}
		super._load();
		
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

	private function _uiZoom():Void {
		
		if (!_autoSize.w && !_autoSize.h) {
			_setSize(_w, _h);
		} else {
			if (_label == undefined) {
				var w = (_autoSize.w) ? _ui.labelHeight + _padding.left + _padding.right : _w;
				var h = (_autoSize.h) ? _ui.labelHeight + _padding.top + _padding.bottom : _h;
				_setSize(w, h);
			}
		}
	}

	private function _setSize(w:Number, h:Number):Void {

		var iw = 0;
		if (_icon != undefined && loaded) {
			var is = _zoom2pixel(h - _padding.top - _padding.bottom) - _icon.margin.top*2;
			_icon.move(_zoom2pixel(_padding.left) + _icon.margin.left, _zoom2pixel(_padding.top) + _icon.margin.top);
			_icon.setSize(is, is);
			if (_autoSize.w) {
				iw = is + _icon.margin.top*2;
			}
		}
			
		if (_label != undefined && loaded){ 

			if (_zoom) {
				_label.move(iw + _zoom2pixel(_padding.left + _label.margin.left), _zoom2pixel(_padding.top + _label.margin.top));
			} else {
				_label.move(iw + _padding.left + _label.margin.left, _padding.top + _label.margin.top);				
			}

			if (!_autoSize.w || !_autoSize.h) {
			
				var lw = (_autoSize.w) ? _label.w : w - (_padding.left + _padding.right + _label.margin.left + _label.margin.right);
				var lh = (_autoSize.h) ? _label.h : h - (_padding.top + _padding.bottom + _label.margin.top + _label.margin.bottom);

				lw = Math.max(0, lw);
				lh = Math.max(0, lh);
				
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
		
	}

	private function _labelResize(evt:Object):Void {
		
		if (_resizeFlag) {

			var w = (_autoSize.w) ? _label.w + _label.margin.left + _label.margin.right + _padding.left + _padding.right : _w;
			var h = (_autoSize.h) ? _label.h + _label.margin.top + _label.margin.bottom + _padding.top + _padding.bottom : _h;					

			if (_autoSize.w && _icon != undefined) {
				w += h - _padding.top - _padding.bottom;
			}
			if (w != _w || h != _h) {
				_setSize(w, h);
			}
		}
	}
	
	private function _focus(evt:Object):Void {

		if (!Arrays.contains(_ui.getListeningObjects("keydown"), this)) {
			_ui.addEventListener("keydown", this, _keyDown);
			_ui.addEventListener("keyup", this, _keyUp);
		}
		super._focus(evt);
	}

	private function _blur(evt:Object):Void {

		if (Arrays.contains(_ui.getListeningObjects("keydown"), this)) {
			_ui.removeEventListener("keydown", this);
			_ui.removeEventListener("keyup", this);
		}
		super._blur(evt);
	}

	private function _remove():Void {

		if (_dragged) {
			_ui.removeEventListener("enterframe", this);
		}
		if (_icon != undefined) {
			_icon.remove();
		}
		if (_label != undefined) {
			_label.removeEventListener("load", this);
			_label.removeEventListener("resize", this);
			_label.remove();
		}

		super._remove();
	}

}