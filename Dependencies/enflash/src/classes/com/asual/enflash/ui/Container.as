import com.asual.enflash.ui.Bar;
import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.MenuBar;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.SplitPane;
import com.asual.enflash.ui.TitleBar;
import com.asual.enflash.ui.ToolBar;
import com.asual.enflash.ui.UIObject;
import com.asual.enflash.ui.Window;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Strings;

class com.asual.enflash.ui.Container extends UIObject {
	
	private var _bars:Collection;	
	private var _windows:Collection;
	private var _panes:Collection;	
	private var _borders:Collection;	
	private var _buttons:Collection;	
	
	private var _horizontal:Boolean = false;
	private var _percents:Boolean = false;
	private var _border:Boolean = true;

	private var _rules:Array;

	private var _name:String = "Container";
	
	public function Container(id:String) {

		super(id);

		padding = 0;

		_w = 100;
		_h = 100;
	}

	public function addBar(bar) {
		
		bar = _bars.addItem((bar != undefined) ? bar : new Bar());
		if (_ui.visible){
			_setSize(_w, _h);
		}
		return bar;
	}

	public function addBarAt(index, bar) {
		
		bar = _bars.addItemAt(index, (bar != undefined) ? bar : new Bar());
		if (_ui.visible){
			_setSize(_w, _h);
		}
		return bar;
	}
	
	public function getBar(index:Number) {
		return _bars.getItem(index);
	}

	public function addPane(pane) {
		return _addPane(pane);
	}

	public function getPane(index:Number){
		return _panes.getItem((index != undefined) ? index : 0);
	}

	public function addWindow(window:Window):Window {
		return _windows.addItem((window != undefined) ? window : new Window());
	}

	public function getWindow(index:Number):Window {
		return _windows.getItem(index);
	}
		
	public function get bars():Collection {
		return _bars;
	}

	public function get panes():Collection {
		return _panes;
	}

	public function get windows():Collection {
		return _windows;
	}

	public function get border():Boolean {
		return _border;
	}
	
	public function set border(border:Boolean):Void {
		_border = border;
		if (_border && _panes.length > 1) {
			_addBorder();			
		}
	}	

	public function get cols():String {
		if (!_horizontal) {
			return _getRules();
		}
	}
	
	public function set cols(cols:String):Void {
		_horizontal = false;
		_setRules(cols);		
	}	

	public function get rows():String {
		if (_horizontal) {
			return _getRules();
		}
	}
	
	public function set rows(rows:String):Void {
		_horizontal = true;
		_setRules(rows);		
	}	

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);
		
		_bars = new Collection();
		_bars.init(_ref, _mc, 2);

		_panes = new Collection();
		_panes.init(_ref, _mc, 3);

		_buttons = new Collection();
		_buttons.init(_ref, _mc, 4);

		_borders = new Collection();
		_borders.init(_ref, _mc, 5);

		_windows = new Collection();
		_windows.init(_ref, _mc, 10);

		_ui.addEventListener("mousedown", this, _windowsDown);
	}

	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (_rules.length > 1) {		
			if (_horizontal) {
				xml.firstChild.attributes.rows = rows;
			} else {
				xml.firstChild.attributes.cols = cols;
			}
		}
				
		if (toString() == "Container") {
			delete xml.firstChild.attributes.x;
			delete xml.firstChild.attributes.y;
		}
		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}

		var i, iMax;
		
		i = -1;
		iMax = _bars.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_bars.getItem(i).getXML());
		}

		i = -1;
		iMax = _panes.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_panes.getItem(i).getXML());
		}

		i = -1;
		iMax = _windows.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_windows.getItem(i).getXML());
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (_bars.length > 0) {
			_bars.removeAll();
		}
		if (_panes.length > 0) {
			_panes.removeAll();
		}
		if (_windows.length > 0) {
			_windows.removeAll();
		}
		if (xml.attributes.border != undefined) {
			border = (xml.attributes.border == "false") ? false : true;
		}
		if (xml.attributes.cols != undefined) {
			cols = xml.attributes.cols;
		}
		if (xml.attributes.rows != undefined) {
			rows = xml.attributes.rows;
		}

		var item;
		var i:Number = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			
			item = xml.childNodes[i];
			
			switch(item.nodeName) {
				case "MenuBar":
					addBar(new MenuBar(item.attributes.id)).setXML(item);
					break;
				case "ScrollPane":
					addPane(new ScrollPane(item.attributes.id)).setXML(item);
					break;
				case "SplitPane":
					addPane(new SplitPane(item.attributes.id)).setXML(item);
					break;
				case "TitleBar":
					addBar(new TitleBar(item.attributes.id)).setXML(item);
					break;
				case "ToolBar":
					addBar(new ToolBar(item.attributes.id)).setXML(item);
					break;
				case "Window":
					addWindow(new Window(item.attributes.id)).setXML(item);
					break;
			}
		}

		super._setXML(xml);
	}

	private function _addPane(pane) {

		pane = _panes.addItem((pane != undefined) ? pane : new ScrollPane());
		if (_ui.visible){
			_setSize(_w, _h);
		}

		_addBorder();		
		
		return pane;
	}

	private function _addBorder():Void {

		while (_panes.length > (_borders.length + 1)) {

			var border = _borders.addItem(new Component());
			border.swf = "panesplit.swf";
			border.zoom = false;
			border.visible = _border;
			
			var button = _buttons.addItem(new Button());
			button.swf = "panesplit.swf";
			button.zoom = false;
			button.alpha = 0;
			button.focusable = false;
			button.draggable = true;
			button.visible = _border;
	
			button.addEventListener("rollover", this, _buttonRollOver);
			button.addEventListener("rollout", this, _buttonRollOut);
			button.addEventListener("dragbegin", this, _buttonDragBegin);
			button.addEventListener("dragend", this, _buttonDragEnd);
		
			if (_horizontal) {
				border.rotation = 90;	
				button.rotation = 90;	
			}
		}
	}

	private function _buttonRollOver(evt:Object):Void {

		if (evt.target.draggable){
			if (_horizontal){
				_ui.showCursor("ns-split");
			} else {
				_ui.showCursor("ew-split");
			}
		}		
	}

	private function _buttonRollOut(evt:Object):Void {
		_ui.hideCursor();
	}

	private function _buttonDragBegin(evt:Object):Void {
		
		var button = evt.target;
		var index = _buttons.getIndex(button);
		
		var pane1 = _panes.getItem(index);
		var pane2 = _panes.getItem(index + 1);

		if (_horizontal) {
			button.dragProperties = {top:pane1.y + _zoom2pixel(pane1.minHeight), right:_panes.w, bottom:pane2.y + pane2.ph - _zoom2pixel(pane2.minHeight), left:0};
		} else {
			button.dragProperties = {top:0, right:pane2.x + pane2.pw - _zoom2pixel(pane2.minWidth), bottom:_panes.h, left:pane1.x + _zoom2pixel(pane1.minWidth)};
		}
		
		button.alpha = 50;
	}

	private function _buttonDragEnd(evt:Object):Void {

		var button = evt.target;
		var index = _buttons.getIndex(button);
		var border = _borders.getItem(index);
		
		var pane1 = _panes.getItem(index);
		var pane2 = _panes.getItem(index + 1);

		var rule1 = _rules[index];
		var rule2 = _rules[index + 1];

		if (_percents){
			if (_rules[index] != "*"){
				if (_horizontal) {
					_rules[index] = Math.round((button.y - pane1.y)*10000/_panes.h)/100;					
				} else {
					_rules[index] = Math.round((button.x - pane1.x)*10000/_panes.w)/100;
				}		
			}
			if (_rules[index + 1] != "*"){
				if (_horizontal) {
					_rules[index + 1] = Math.round((pane2.y + pane2.ph - button.y - button.ph)*10000/_panes.h)/100;			
				} else {
					_rules[index + 1] = Math.round((pane2.x + pane2.pw - button.x - button.pw)*10000/_panes.w)/100;			
				}
			}
		} else {
			if (_rules[index] != "*"){
				if (_horizontal) {
					_rules[index] = _pixel2zoom(button.y - pane1.y);					
				} else {
					_rules[index] = _pixel2zoom(button.x - pane1.x);
				}		
			}
			if (_rules[index + 1] != "*"){
				if (_horizontal) {
					_rules[index + 1] = _pixel2zoom(pane2.y + pane2.ph - button.y - button.ph);			
				} else {
					_rules[index + 1] = _pixel2zoom(pane2.x + pane2.pw - button.x - button.pw);			
				}
			}
		}

		_setPanesSize(_panes.w, _panes.h);
		_setBordersSize(_borders.w, _borders.h);

		_ui.hideCursor();

		button.alpha = 0;

	}

	private function _setBarsSize(w:Number, h:Number):Void {
		
		if (_bars.length > 0){
			
			var barh = 0;
			var i:Number = -1;
			var iMax:Number = _bars.length
			while (++i != iMax) {
				var bar = _bars.getItem(i);
				bar.setSize(_pixel2zoom(w), bar.h);
				barh += bar.h;
			}
			_bars.setSize(w, _zoom2pixel(barh));
			
		} else {
			_bars.setSize(0, 0);		
		}
	}

	private function _setPanesSize(w:Number, h:Number):Void {

		if (!_ui.visible) return;

		_panes.setSize(w, h);

		if (_rules == undefined || _rules.length == 1) {

			_panes.getItem(0).setSize(_pixel2zoom(w), _pixel2zoom(h));	

		} else {

			var zw:Number = _pixel2zoom(w);
			var zh:Number = _pixel2zoom(h);
			var rules = Arrays.duplicate(_rules);
			var pb = _zoom2pixel(_ui.theme.border);

			if (Arrays.contains(rules, "*")) {

				var space:Number;
				if (_percents) {
					space = 100;
					if (_border) {
						space = space - (_ui.theme.border*(_rules.length - 1))*100/((_horizontal) ? zh : zw);
					}
				} else {
					space = (_horizontal) ? zh : zw;	
					if (_border) {
						space = space - _ui.theme.border*(_rules.length - 1);
					}
				}
				var i:Number = rules.length;
				while(i--) {
					if (_rules[i] != "*") {
						space = space - rules[i];					
					}
				}
				Arrays.replace(rules, "*", space)
			}
			
			var pane;
			var s:Number = 0;
			var i:Number = -1;
			var iMax:Number = _panes.length;
			while(++i < iMax){
				
				pane = _panes.getItem(i);
				
				if (_horizontal) {
					
					pane.y = (_border) ? s + pb*i : s;
					if (_percents) {
						pane.setSize(zw, rules[i]*zh/100);
					} else {
						pane.setSize(zw, rules[i]);
					}
					s += _zoom2pixel(pane.h);
					
				} else {
					
					pane.x = (_border) ? s + pb*i : s;
					if (_percents) {
						pane.setSize(rules[i]*zw/100, zh);
					} else {
						pane.setSize(rules[i], zh);
					}
					s += _zoom2pixel(pane.w);
				}
			}
		}
		
	}

	private function _setBordersSize(w:Number, h:Number):Void {

		if (_border) {

			var pb = _zoom2pixel(_ui.theme.border);

			_borders.setSize(w, h);
			_buttons.setSize(w, h);

			var border, button, pane;
			var i:Number = -1;
			var iMax:Number = _borders.length;
			
			while(++i < iMax){

				border = _borders.getItem(i);	
				button = _buttons.getItem(i);	

				pane = _panes.getItem(i+1);

				if (_horizontal) {
					border.setSize(w, pb);
					border.y = pane.y - border.h;
					button.setSize(w, pb);
					button.y = pane.y - button.h;
				} else {
					border.setSize(pb, h);
					border.x = pane.x - border.w;
					button.setSize(pb, h);
					button.x = pane.x - button.w;
				}
			}
		}
	}

	private function _setSize(w:Number, h:Number):Void {

		if (_ui.visible) {

			var mw:Number = 0;
			var mh:Number = 0;
			var i:Number;

			if (_horizontal) {
				
				i = _panes.length;
				while(i--) {
					if (mw < _panes.getItem(i).minWidth) {
						mw = _panes.getItem(i).minWidth;
					}
				}
	
				i = _panes.length;		
				while(i--) {
					mh += _panes.getItem(i).minHeight;
				}
				
				if (_border && _panes.length > 1) {
					mh += _ui.theme.border*(_panes.length - 1);
				}

			} else {
	
				i = _panes.length;		
				while(i--) {
					mw += _panes.getItem(i).minWidth;
				}
								
				if (_border && _panes.length > 1) {
					mw += _ui.theme.border*(_panes.length - 1);
				}
				
				i = _panes.length;
				while(i--) {
					if (mh < _panes.getItem(i).minHeight) {
						mh = _panes.getItem(i).minHeight;
					}
				}
			}
			
			w = Math.max(w, _zoom2pixel(mw));

			_setBarsSize(w, _bars.h);

			mh += _pixel2zoom(_bars.h);
			h = Math.max(h, _zoom2pixel(mh));	
			
			if (parent.toString() == "ScrollPane" || parent.toString() == "SplitPane") {
				parent.minWidth = Math.max(parent.minWidth, mw);
				parent.minHeight = Math.max(parent.minHeight, mh);			
			}

			_panes.move(0, _bars.h);
			_setPanesSize(w, h - _bars.h);	

			_borders.move(0, _bars.h);
			_buttons.move(0, _bars.h);

			_setBordersSize(w, h - _bars.h);	

			_windows.setSize(w, h);
		}

		super._setSize(w, h);
	}

	private function _windowsDown(evt:Object):Void {

		var window:Window;
		var i:Number = _windows.length;
		while(i--) {
			window = _windows.getItem(i);
			if (window.movieclip.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, true)) {
				window.focus();
				break;
			}
		}
	}

	private function _getRules():String {

		if (_rules.length > 1) {
		
			var rules = Arrays.duplicate(_rules);
	
			if (_percents) {
				var i:Number = rules.length;
				while(i--) {
					if (rules[i] != "*") {
						rules[i] = rules[i] + "%";
					}	
				}
			}
			return rules.toString();
		}
	}

	private function _setRules(rules:String):Void {

		rules = Strings.replace(rules, " ", "");
		if (rules.indexOf("%") > -1){
			_percents = true;	
			rules = Strings.replace(rules, "%", "");
		} else {
			_percents = false;				
		}
		_rules = rules.split(",");
	}
	
	private function _remove():Void {

		_ui.removeEventListener("mousedown", this);

		if (_bars.length > 0) {
			_bars.removeAll();
		}
		if (_borders.length > 0) {
			_borders.removeAll();
		}
		if (_buttons.length > 0) {
			_buttons.removeAll();
		}
		if (_panes.length > 0) {
			_panes.removeAll();
		}
		if (_windows.length > 0) {
			_windows.removeAll();
		}

		super._remove();
	}
}