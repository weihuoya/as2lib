import com.asual.enflash.EnFlashObject;

import com.asual.enflash.utils.Strings;

class com.asual.enflash.ui.UIObject extends EnFlashObject {

	private static var _ui:Object;
	
	private var _w:Number = 0;
	private var _h:Number = 0;		
	private var _mc:MovieClip;
	private var _padding:Object;
	private var _margin:Object;	
	private var _visible:Boolean = true;
	private var _alpha:Number = 100;
	private var _name:String = "UIObject";
	
	public var onresize:Function;
	public var onload:Function;
	
	public function UIObject(id:String) {
		
		super(id);
		
		_padding = new Object();
		_padding = {top:0, right:0, bottom:0, left:0};
		
		_margin = new Object();
		_margin = {top:0, right:0, bottom:0, left:0};
	}

	public function init(parent:Number, mc:MovieClip, depth:Number):Void {
		_init(parent, mc, depth);
	}
	
	public function setSize(w:Number, h:Number):Void {
		_setSize(w, h);
	}

	public function load(url:String):Void {
		_mc.loadMovie(url);
		_ui.addEventListener("enterframe", this, _enterFrame);
	}

	public function move(x:Number, y:Number):Void {
		_mc._x = x;
		_mc._y = y;
	}

	public function get x():Number {
		return _mc._x;
	}

	public function set x(x:Number):Void {
		move(x, y);
	}

	public function get y():Number {
		return _mc._y;
	}

	public function set y(y:Number):Void {
		move(x, y);
	}
	
	public function get w():Number {
		return (!isNaN(_w)) ? _w : 0;
	}

	public function set w(w:Number):Void {
		_setWidth(w);
	}

	public function get h():Number {
		return (!isNaN(_h)) ? _h : 0;
	}	

	public function set h(h:Number):Void {
		_setHeight(h);
	}
	
	public function get padding():Object {
		
		var padding = new Object();
		
		padding.top = _padding.top;
		padding.right = _padding.right;
		padding.bottom = _padding.bottom;
		padding.left = _padding.left;
		
		return padding;
	}

	public function set padding(padding):Void {
		
		if (typeof(padding) == "number") {
			_padding.top = padding;
			_padding.right = padding;
			_padding.bottom = padding;
			_padding.left = padding;						
		} else {
			if (padding.top != undefined) _padding.top = padding.top;
			if (padding.right != undefined) _padding.right = padding.right;
			if (padding.bottom != undefined) _padding.bottom = padding.bottom;
			if (padding.left != undefined) _padding.left = padding.left;			
		}
		if (_ui.visible) {
			_setSize(_w, _h);
		}
	}

	public function get margin():Object {
		
		var margin = new Object();
		
		margin.top = _margin.top;
		margin.right = _margin.right;
		margin.bottom = _margin.bottom;
		margin.left = _margin.left;
		
		return margin;
	}

	public function set margin(margin):Void {
		
		if (typeof(margin) == "number") {
			
			_margin.top = margin;
			_margin.right = margin;
			_margin.bottom = margin;
			_margin.left = margin;
			
		} else {
			
			if (margin.top != undefined) _margin.top = margin.top;
			if (margin.right != undefined) _margin.right = margin.right;
			if (margin.bottom != undefined) _margin.bottom = margin.bottom;
			if (margin.left != undefined) _margin.left = margin.left;
		
		}
		
		if (_ui.visible) {
			_setSize(_w, _h);
		}
	}
		
	public function get alpha():Number {
		return _alpha;
	}	

	public function set alpha(alpha:Number):Void {
		_alpha = alpha
		if (_mc != undefined) {
			_mc._alpha = _alpha;
		}
	}
	
	public function get visible():Boolean {
		return _visible;
	}	

	public function set visible(visible:Boolean):Void {
		_setVisible(visible);
	}
	
	public function get movieclip():MovieClip {
		return _mc;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		super._init(parent);
		
		if (depth == undefined) depth = mc.getNextHighestDepth();

		_mc = mc.createEmptyMovieClip(_id, depth);
		_mc._ref = _ref;
		_mc._alpha = _alpha;
		_mc._visible = _visible;
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		xml.firstChild.attributes.w = w;
		xml.firstChild.attributes.h = h;
		xml.firstChild.attributes.x = x;
		xml.firstChild.attributes.y = y;
				
		if (!visible) {
			xml.firstChild.attributes.visible = visible;
		}
		if (alpha != 100) {
			xml.firstChild.attributes.alpha = alpha;
		}		
		if ((_padding.top == _padding.right) && (_padding.right == _padding.bottom) && (_padding.bottom == _padding.left)) {
			xml.firstChild.attributes.padding = _padding.top;
		} else {
			xml.firstChild.attributes.padding = "top: " + _padding.top + ", right: " + _padding.right + ", bottom: " + _padding.bottom + ", left: " + _padding.left;
		}
		if ((_margin.top == _margin.right) && (_margin.right == _margin.bottom) && (_margin.bottom == _margin.left)) {
			xml.firstChild.attributes.margin = _margin.top;
		} else {
			xml.firstChild.attributes.margin = "top: " + _margin.top + ", right: " + _margin.right + ", bottom: " + _margin.bottom + ", left: " + _margin.left;
		}
		if (toString() == "UIObject" && xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (toString() == "UIObject" && xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}
		if (getListeners("load").length > 0) {
			xml.firstChild.attributes.onload = _getEvent("load");
		}
		if (getListeners("resize").length > 0) {
			xml.firstChild.attributes.onresize = _getEvent("resize");
		}
		
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {
	
		if (xml.attributes.w != undefined && xml.attributes.h != undefined) {
			setSize(Number(xml.attributes.w), Number(xml.attributes.h));
		} else if (xml.attributes.w != undefined) {
			w = Number(xml.attributes.w);
		} else if (xml.attributes.h != undefined) {
			h = Number(xml.attributes.h);
		}		
		if (xml.attributes.x != undefined) {
			x = Number(xml.attributes.x);
		}
		if (xml.attributes.y != undefined) {
			y = Number(xml.attributes.y);
		}		
		if (xml.attributes.alpha != undefined) {
			alpha = Number(xml.attributes.alpha);
		}
		if (xml.attributes.visible != undefined) {
			visible = (xml.attributes.visible == "false") ? false : true;
		}		
		if (xml.attributes.onload != undefined) {
			_setEvent("load", xml.attributes.onload);
		}
		if (xml.attributes.onresize != undefined) {
			_setEvent("resize", xml.attributes.onresize);
		}		
		if (xml.attributes.margin != undefined) {
			if (xml.attributes.margin.toString().indexOf(":") > -1) {
				var arr = Strings.replace(xml.attributes.margin, " ", "").split(",");	
				var obj = new Object();
				var a:Array;
				var i = arr.length;
				while(i--) {
					a = arr[i].split(":");
					obj[a[0]] = Number(a[1]);
				}
				margin = obj;
			} else {
				margin = Number(xml.attributes.margin);
			}
		}
		if (xml.attributes.padding != undefined) {
			if (xml.attributes.padding.toString().indexOf(":") > -1) {
				var arr = Strings.replace(xml.attributes.padding, " ", "").split(",");	
				var obj = new Object();
				var a:Array;
				var i = arr.length;
				while(i--) {
					a = arr[i].split(":");
					obj[a[0]] = Number(a[1]);
				}
				padding = obj;
			} else {
				padding = Number(xml.attributes.padding);
			}
		}
		
		super._setXML(xml);
	}
	
	private function _setSize(w:Number, h:Number):Void {

		if (_w != w || _h != h){
			_w = w;
			_h = h;
			if (_ui.visible){
				dispatchEvent("resize");
			}
		}
	}
	
	/**
	 * Continuously fired while load() is being processed.
	 */
	private function _enterFrame(evt:Object):Void{
		var bl = _mc.getBytesLoaded();
		var bt = _mc.getBytesTotal();
		
		if (bt != undefined && bt > 0 && bl == bt) {
			_mc._alpha = _alpha;
			_setSize(_mc._width, _mc._height);
			_ui.removeEventListener("enterframe", this);
			dispatchEvent("load");
		}
	}

	private function _zoom2pixel(value:Number):Number {
		return Math.round(_ui.zoomManager.factor*value);		
	}

	private function _pixel2zoom(value:Number):Number {
		return Math.round(value*100/_ui.zoomManager.factor)/100;		
	}

	private function _setWidth(w:Number):Void {
		_setSize(w, _h);
	}

	private function _setHeight(h:Number):Void {
		_setSize(_w, h);
	}

	private function _setVisible(visible:Boolean):Void {
		_visible = visible;
		if (_mc != undefined) {
			_mc._visible = _visible;
		}
	}			
	
	private function _remove():Void {
		
		for(var p in _mc){
			delete _mc[p];
			_mc[p] = null;
		}
		
		_mc.removeMovieClip();

		super._remove();
	}
}