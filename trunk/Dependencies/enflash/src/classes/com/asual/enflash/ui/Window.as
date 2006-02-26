import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Container;
//import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.TitleBar;

class com.asual.enflash.ui.Window extends Container {
	
	private var _titlebar:TitleBar;
	private var _drag:Button;
	private var _draggable:Boolean = true;
	private var _name:String = "Window";

	public var onopen:Function;
	public var onclose:Function;
	public var onfocus:Function;
	public var onblur:Function;

	public function Window(id:String){
		super(id);
	}

	public function get title():String {
		return _titlebar.value;
	}
	
	public function set title(title:String):Void {

		if (_titlebar == undefined) {

			_titlebar = addBarAt(0, new TitleBar());
			_titlebar.close = true;
			_titlebar.addEventListener("close", this, close);

			_drag = new Button();
			_drag.alpha = 0;
			_drag.draggable = true;
			_drag.init(_ref, _mc);
			_drag.addEventListener("drag", this, _dragMove);
			_drag.addEventListener("dragend", this, _dragEnd);
			_drag.draggable = _draggable;
		}
		_titlebar.value = title;
	}

	public function get draggable():Boolean {
		return _draggable;
	}
	
	public function set draggable(draggable:Boolean):Void {
		_draggable = draggable;
		if (_drag != undefined) {
			_drag.draggable = _draggable;
		}
	}

	public function refresh():Void {
		_refresh();	
	}

	public function open():Void {

		_setVisible(true);
		dispatchEvent("open");
	}

	public function close():Void {

		_setVisible(false);
		dispatchEvent("close");
	}

	public function focus():Void {
		_setFocus();
	}
	
	public function blur():Void {
		_setBlur();
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);		

		_ui.themeManager.addEventListener("windowsize", this, refresh);
		_ui.zoomManager.addEventListener("windowsize", this, refresh);
	}
	
	private function _refresh():Void {
		var i = _panes.length;
		while(i--) {
			_panes.getItem(i).refresh();	
		}
		_setSize(_w, _h);
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		xml.firstChild.firstChild.removeNode();
		
		if (title != undefined) {
			xml.firstChild.attributes.title = title;
		}
		if (!draggable) {
			xml.firstChild.attributes.draggable = draggable;
		}		
		if (getListeners("open").length > 0) {
			xml.firstChild.attributes.onopen = _getEvent("open");
		}
		if (getListeners("close").length > 0) {
			xml.firstChild.attributes.onclose = _getEvent("close");
		}
		
		return xml;
	}
	
	private function _setXML(xml):Void {

		if (xml.attributes.onopen != undefined) {
			_setEvent("open", xml.attributes.onopen);
		}
		if (xml.attributes.onclose != undefined) {
			_setEvent("close", xml.attributes.onclose);
		}

		super._setXML(xml);
		
		if (xml.attributes.title != undefined) {
			title = xml.attributes.title;
		}
		if (xml.attributes.draggable != undefined) {
			draggable = (xml.attributes.draggable == "false") ? false : true;
		}
	}

	private function _setSize(w:Number, h:Number):Void {

		super._setSize(w, h);
			
		var item;
		var rw:Number = _titlebar.padding.right;
		var i:Number = -1;
		var iMax:Number = _titlebar.length;
		while(++i < iMax) {
			item = _titlebar.getItem(i);
			if (item.float == "right") {
				rw += item.w;
			}
		}
				
		if (_drag != undefined) {
			_drag.setSize(_titlebar.w - rw, _titlebar.h);
		}
	}

	private function _setFocus():Void {
		
		if (parent.length == undefined || parent.length < 2) return;
		
		parent.setIndex(parent.length - 1, this);
		
		var window;
		var i = parent.length;
		while(i--){
			window = parent.getItem(i);
			if (window != this) {
				window.blur();
			}
		}
		
		dispatchEvent("focus");
	}

	private function _setBlur():Void {
		dispatchEvent("blur");
	}
	
	private function _dragMove(evt:Object):Void {
	
		_bars.move(evt.target.x, evt.target.y);
		_panes.move(evt.target.x, evt.target.y + _bars.h);
		/*
		if (_panes.length > 2){
			
			var pane0:ScrollPane = _panes.getItem(0);
			var pane1:ScrollPane = _panes.getItem(1);
			var toggleWidth = _zoom2pixel(_ui.theme.toggleWidth);
			
			if (_horizontal) {
				_split.move(0, _panes.y + pane0.ph);				
				_splitButton.move(0, _panes.y + pane0.ph);
				_toggle.move(Math.round((_panes.w - toggleWidth)/2), _panes.y + pane0.ph);		
			} else {
				_split.move(pane0.pw, _panes.y);
				_splitButton.move(pane0.pw, _panes.y);
				_toggle.move(pane0.pw, Math.max(_panes.y, _panes.y + Math.round((_panes.h - toggleWidth)/2)));
			}
		}
		*/
		_windows.move(evt.target.x, evt.target.y + _bars.h);
	}

	private function _dragEnd(evt:Object):Void {

		_mc._x = _mc._x + _drag.x;
		_mc._y = _mc._y + _drag.y;
		
		_drag.x = 0;
		_drag.y = 0;

		_bars.move(0, 0);
		_panes.move(0, _bars.h);
		_windows.move(0, _bars.h);
	}
	
	private function _remove():Void {

		_ui.themeManager.removeEventListener("windowsize", this);

		if (_titlebar != undefined) {

			_drag.removeEventListener("drag", this);
			_drag.removeEventListener("dragend", this);
			_drag.remove();
			
		}

		super._remove();
	}		
}