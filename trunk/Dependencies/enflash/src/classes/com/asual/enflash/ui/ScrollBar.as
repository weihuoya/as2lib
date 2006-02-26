import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;

import com.asual.enflash.utils.Time;

class com.asual.enflash.ui.ScrollBar extends Component {
	
	private var _track:Button;
	private var _thumb:Button;
	private var _up:Button;
	private var _down:Button;
	
	private var _interval:Number;	
	private var _speed:Number = 20;	
	private var _scrollPosition:Number = 0;	
	private var _smallStep:Number = 10;
	private var _largeStep:Number = 40;
	private var _horizontal:Boolean = false;

	private var _content:Object;

	private var _scrollSide:String = "ph";
	private var _scrollPoint:String = "y";
	private var _enabled:Boolean = false;
	
	private var _tabFocus:Boolean = false;
	private var _focusTimeout:Number;
	private var _name:String = "ScrollBar";

	public function ScrollBar(id) {
		super(id);
		_host = true;
	}

	public function get content() {
		return _content;
	}
	
	public function set content(content):Void {
		_content = content;
	}

	public function get smallStep():Number {
		return _smallStep;
	}

	public function set smallStep(smallStep:Number):Void {
		_smallStep = smallStep;
	}

	public function get largeStep():Number {
		return _largeStep;
	}

	public function set largeStep(largeStep:Number):Void {
		_largeStep = largeStep;
	}
	
	public function get speed():Number {
		return _speed;
	}

	public function set speed(speed:Number):Void {
		_speed = speed;
	}
	
	public function get position():Number {
		return _scrollPosition;
	}

	public function set position(position:Number):Void {
		_setScrollPosition(position, true);
	}	

	public function get horizontal():Boolean {
		return _horizontal;
	}

	public function set horizontal(horizontal:Boolean):Void {
		_horizontal = horizontal;
		if (_horizontal){
			_scrollSide = "pw";
			_scrollPoint = "x";
			_up.rotation = 270;
			_down.rotation = 90;
			_track.rotation = 90;
			_thumb.rotation = 90;
		} else {
			_scrollSide = "ph";
			_scrollPoint = "y";
			_up.rotation = 0;
			_down.rotation = 180;
			_track.rotation = 0;
			_thumb.rotation = 0;
		}
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void{
		
		super._init(parent, mc, depth);
		
		_track = new Button();
		_track.swf = "scrolltrack.swf";
		_track.zoom = false;
		_track.addEventListener("press", this, _trackPress);
		_track.addEventListener("release", this, _scrollStop);
		_track.addEventListener("dragout", this, _scrollStop);
		_track.addEventListener("load", this, _compLoad);
		_track.init(_ref, _mc);
		_track.focusable = false;

		_thumb = new Button();
		_thumb.swf = "scrollthumb.swf";
		_thumb.zoom = false;
		_thumb.addEventListener("press", this, _thumbPress);
		_thumb.addEventListener("release", this, _scrollStop);
		_thumb.addEventListener("drag", this, _thumbDrag);
		_thumb.addEventListener("load", this, _compLoad);
		_thumb.init(_ref, _mc);
		_thumb.focusable = false;
		_thumb.draggable = true;
		
		_up = new Button();
		_up.swf = "scrollbutton.swf";
		_up.zoom = false;
		_up.addEventListener("press", this, _upPress);
		_up.addEventListener("release", this, _scrollStop);
		_up.addEventListener("dragout", this, _scrollStop);
		_up.addEventListener("load", this, _compLoad);
		_up.init(_ref, _mc);
		_up.focusable = false;
		
		_down = new Button();
		_down.swf = "scrollbutton.swf";
		_down.zoom = false;
		_down.addEventListener("press", this, _downPress);
		_down.addEventListener("release", this, _scrollStop);
		_down.addEventListener("dragout", this, _scrollStop);	
		_down.addEventListener("load", this, _compLoad);
		_down.init(_ref, _mc);
		_down.rotation = 180;
		_down.focusable = false;

		
		var parentObject = _enflash.getByRef(parent);
		
		if (parentObject.toString() == "TextArea") {

			parentObject.addEventListener("blur", this, _textAreaBlur);

			_thumb.addEventListener("dragbegin", this, _blurTextField);
			_thumb.addEventListener("dragend", this, _focusTextField);
			
			_enabled = true;
			_smallStep = 1;
			_largeStep = 1;				
		}
		
	}

	private function _compLoad(evt:Object):Void {
			
		if (_track.loaded && _thumb.loaded && _up.loaded && _down.loaded) {
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

	private function _load():Void {

		enabled = _enabled;
		_setSize(_w, _h);
		super._load();
	}
	
	private function _trackPress(evt:Object):Void {
		
		if (parent.toString() == "TextArea") {
			_blurTextField();
		}
		
		if (_track.movieclip["_" + _scrollPoint + "mouse"] < _thumb[_scrollPoint]){
			_scrollStart(-_largeStep);
		} else {
			_scrollStart(_largeStep);
		}
		dispatchEvent("press");
	}

	private function _thumbDrag(evt:Object):Void {
		_setScrollPosition(-Math.round((_thumb[_scrollPoint] - _up[_scrollSide])*(this[_scrollSide] - _scrollSize())/(_track[_scrollSide] - _thumb[_scrollSide])), false);
	}

	private function _thumbPress(evt:Object):Void {
		dispatchEvent("press");
	}
	
	private function _upPress(evt:Object):Void {
		if (parent.toString() == "TextArea") {
			_blurTextField();
		}
		_scrollStart(-_smallStep);
		dispatchEvent("press");
	}

	private function _downPress(evt:Object):Void {
		if (parent.toString() == "TextArea") {
			_blurTextField();
		}
		_scrollStart(_smallStep);
		dispatchEvent("press");
	}
	
	private function _setSize(w:Number, h:Number):Void {
		
		var pw = _zoom2pixel(w);
		var ph = _zoom2pixel(h);
	
		if (_horizontal){
			
			pw = Math.max(pw, _up.h*3 + 2);
			
			_track.move(ph, 0);
			_track.setSize(pw - ph*2, ph);
			
			_up.setSize(ph, ph);
			_down.setSize(ph, ph);
			_down.move(pw - ph, 0);
			
			_setThumbSize(pw);
			_setThumbPosition(pw);
			
			_thumb.dragProperties = {left:_up.w, top:0, right:pw - _down.w, bottom:_thumb.h};
			
		} else {
			
			ph = Math.max(ph, _up.w*3 + 2);
			
			_track.move(0, pw);
			_track.setSize(pw, ph - pw*2);
			
			_up.setSize(pw, pw);
			_down.setSize(pw, pw);
			
			_down.move(0, ph - pw);
			
			_setThumbSize(ph);
			_setThumbPosition(ph);
			
			_thumb.dragProperties = {left:0, top:_up.h, right:_thumb.w, bottom:ph - _down.h};	
			
		}
		
		super._setSize(w, h);

		_scroll(0);
	}

	private function _scrollSize() {
		
		return (_horizontal) ? parent.contentWidth : parent.contentHeight;
		
	}

	private function _scrollStart(step:Number):Void {
		_scroll(step);
		_interval = setInterval(this, "_scroll", _speed, step);
	}

	private function _scrollStop():Void {
		clearInterval(_interval);
		if (parent.toString() == "TextArea") {
			_focusTextField();		
		}
		dispatchEvent("release");
	}
	
	private function _scroll(step:Number):Void {
		_setScrollPosition(_scrollPosition + Math.round(step), true);
	}
	
	private function _setScrollPosition(scrollPosition:Number, thumbScroll:Boolean):Void {

		if (parent.toString() == "TextArea") {

			if (thumbScroll){
	
				var newscroll = _content.textfield.scroll + scrollPosition;
	
				if (newscroll < 1) newscroll = 1;
				if (newscroll > _content.textfield.maxscroll) newscroll = _content.textfield.maxscroll;
	
				_content.textfield.scroll = newscroll;
	
				_setThumbPosition(this[_scrollSide]);
	
			} else {
				_content.textfield.scroll = Math.round((_thumb[_scrollPoint] - _up[_scrollSide])*(_content.textfield.maxscroll - 1)/(_track[_scrollSide] - _thumb[_scrollSide])) + 1;			
			}	
		
		} else { 
		
			var minPos = 0;
			var maxPos = _scrollSize() - _content[_scrollSide.substr(1, 1)];
			if (maxPos < 0) maxPos = 0;
			
			var pos = scrollPosition;
			
			if (pos < minPos) pos = minPos;
			if (pos > maxPos) pos = maxPos;
			
			_scrollPosition = pos;
			
			_content.movieclip._content["_" + _scrollPoint] = -_scrollPosition;

			if (thumbScroll){
				_setThumbPosition(this[_scrollSide]);
			}
		}
	}
	
	private function _setThumbSize(side:Number):Void {

		var size;
		
		if (parent.toString() == "TextArea") {
			size = Math.max(Math.round(_track[_scrollSide]*_content.size/_scrollSize()), _up.w + 1);
		} else {
			size = Math.max(Math.round(_track[_scrollSide]*side/_scrollSize()), _up.w + 1);
		}

		if (this.horizontal){
			size = Math.max(size, _up.h + 1);
			_thumb.setSize(size, _up.h);
		} else {
			size = Math.max(size, _up.w + 1);
			_thumb.setSize(_up.w, size);
		}

		if (size < _track[_scrollSide]){
			_up.enabled = true;
			_down.enabled = true;
			_track.enabled = true;
			_thumb.visible = true;
		} else {
			_up.enabled = false;
			_down.enabled = false;
			_track.enabled = false;
			_thumb.visible = false;

			if (_horizontal) {
				_content.parent.hPosition = 0;
			} else {
				_content.parent.vPosition = 0;				
			}
		}
		
		if (parent.toString() == "TextArea") {

			visible = _up.enabled;
	
			if (!_enabled) {
				_up.enabled = false;
				_down.enabled = false;
				_track.enabled = false;
				_thumb.visible = false;			
			}
			
		} else {
			_enabled = _up.enabled;
		}
	}
	
	private function _setThumbPosition(side:Number):Void {

		var pos;
		var minPos = _up[_scrollSide];
		var maxPos = _down[_scrollPoint] - _thumb[_scrollSide];

		if (parent.toString() == "TextArea") {
			if (_content.textfield.maxscroll == 1){
				pos = 0;
			} else {
				pos = _up[_scrollSide] + Math.round((_track[_scrollSide] -  _thumb[_scrollSide])*(_content.textfield.scroll - 1)/(_content.textfield.maxscroll - 1));
			}
		} else {
			pos = _up[_scrollSide] + Math.round(-_scrollPosition*(_track[_scrollSide] - _thumb[_scrollSide])/(side - _scrollSize()));
		}

		if (pos < minPos) pos = minPos;
		if (pos > maxPos) pos = maxPos;
		
		_thumb[_scrollPoint] = pos;
	}

	private function _setEnabled(enabled:Boolean):Void {

		_up.enabled = enabled;
		_down.enabled = enabled;
		_track.enabled = enabled;
		_thumb.visible = enabled;
		_enabled = enabled;
	}

	private function _textAreaBlur():Void {
		if(!_mc.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, true)){
			parent.movieclip.tabFocus = false;
		}
	}
	
	private function _blurTextField():Void {
		
		_tabFocus = parent.movieclip.tabFocus;
		if (_tabFocus){
			parent.asset.focus();
		}
		
		Time.clearTimeout(_focusTimeout);
		
		_content.removeEventListener("scroll", parent);
	}

	private function _focusTextField():Void {

		var pos = position;

		Selection.setFocus(_content.textfield);
		Selection.setSelection(_content.textfield.beginIndex, _content.textfield.endIndex);

		_setScrollPosition(pos);

		_focusTimeout = Time.setTimeout(_content, "addEventListener", 500, "scroll", parent, "_labelScroll");

		parent.movieclip.tabFocus = _tabFocus;
	}

	private function _remove():Void {

		_track.removeEventListener("press", this);
		_track.removeEventListener("release", this);
		_track.removeEventListener("dragout", this);
		_track.removeEventListener("load", this);

		_thumb.removeEventListener("drag", this);
		_thumb.removeEventListener("load", this);

		_up.removeEventListener("press", this);
		_up.removeEventListener("release", this);
		_up.removeEventListener("dragout", this);		
		_up.removeEventListener("load", this);		
		
		_down.removeEventListener("press", this);
		_down.removeEventListener("release", this);
		_down.removeEventListener("dragout", this);
		_down.removeEventListener("load", this);
		
		if (parent.toString() == "TextArea") {

			_thumb.removeEventListener("dragbegin", this);
			_thumb.removeEventListener("dragend", this);

			_content.removeEventListener("scroll", parent);

			parent.removeEventListener("blur", this);
		}
		
		super._remove();
	}
					
}