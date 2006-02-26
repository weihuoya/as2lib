import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.ScrollPane;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Strings;

class com.asual.enflash.ui.SplitPane extends Component {

	private var _horizontal:Boolean = false;
	private var _percents:Boolean = true;

	private var _panes:Array;
	private var _rules:Array;
	private var _mins:Array;
	
	private var _collapsible:Number = 0;
	private var _collapsed:Boolean = false;
	
	private var _border:Component;
	private var _button:Button;
	private var _toggle:Button;

	private var _name:String = "SplitPane";

	public function SplitPane(id:String){
		super(id);
	}

	public function get collapsed():Boolean {
		return _collapsed;
	}

	public function set collapsed(collapsed:Boolean):Void {
		_collapsed = collapsed;
		_setSize(_w, h);
	}

	public function get collapsible():Number {
		return _collapsible;
	}

	public function set collapsible(collapsible:Number):Void {

		if (collapsible < 0) {
			collapsible = 0;
		} else if (collapsible > 1) {
			collapsible = 1;				
		}
		_collapsible = collapsible;
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

	public function get minWidth():Number {
		
		var mw:Number = 0;
		var i:Number = _panes.length; 
		
		if (_horizontal) {
			while(i--){
				if (mw < _panes[i].minWidth){
					mw = _panes[i].minWidth;
				}
			}			
		} else {
			mw = _ui.theme.border;
			while(i--){
				mw += _panes[i].minWidth;
			}			
		}
		return mw;
	}
	
	public function get minHeight():Number {

		var mh:Number;
		var i:Number = _panes.length; 
		
		if (_horizontal) {
			mh = _ui.theme.border;
			while(i--){
				mh += _panes[i].minHeight;
			}
		} else {
			while(i--){
				if (mh < _panes[i].minHeight){
					mh = _panes[i].minHeight;
				}
			}			
		}

		return mh;
	}

	public function addItem(item) {

		item = (item != undefined) ? item : new ScrollPane();
		item.init(_ref, _mc);

		_panes.push(item);	

		if (_panes.length == 2) {

			_border = new Component();
			_border.swf = "panesplit.swf";
			_border.init(_ref, _mc);
			
			_button = new Button();
			_button.swf = "panesplit.swf";
			_button.init(_ref, _mc);
			_button.alpha = 0;
			_button.focusable = false;
			_button.draggable = true;
			
			_button.addEventListener("rollover", this, _buttonRollOver);
			_button.addEventListener("rollout", this, _buttonRollOut);
			_button.addEventListener("dragbegin", this, _buttonDragBegin);
			_button.addEventListener("drag", this, _buttonDrag);
			_button.addEventListener("dragend", this, _buttonDragEnd);
			
			_toggle = new Button();
			_toggle.swf = "panetoggle.swf";
			_toggle.focusable = false;
			_toggle.init(_ref, _mc);
			_toggle.addEventListener("release", this, _toggleRelease);
		}

		if (_ui.visible) {
			_setSize(_w, _h);
		}
				
		return item;
	}

	public function removeItem(item) {
		
		Arrays.remove(_panes, item);
		
		item.remove();
		
		if (_panes.length < 2) {

			_border.remove();

			_button.removeEventListener("rollover", this);
			_button.removeEventListener("rollout", this);
			_button.removeEventListener("dragbegin", this);
			_button.removeEventListener("drag", this);
			_button.removeEventListener("dragend", this);		
			_button.remove();
			
			_toggle.removeEventListener("release", this, _toggleRelease);
			_toggle.remove();
			
			_percents = true;
			_rules = new Array();
			_rules.push(100);
		}		
	
		if (_ui.visible) {
			_setSize(_w, _h);
		}
		
		return item;
	}
	
	public function refresh():Void {
		if (_ui.visible){
			_setSize(_w, _h);
		}
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);
		
		_panes = new Array();
		
		if (_rules == undefined) {
			_setRules("50%,50%");
		}
		
		margin = 0;
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

		_collapsed = false;

		if (_horizontal) {
			_button.dragProperties = {top:_zoom2pixel(_panes[0].minHeight), right:_pw, bottom:_ph - _zoom2pixel(_ui.theme.border + _panes[1].minHeight), left:0};
		} else {
			_button.dragProperties = {top:0, right:_pw - _zoom2pixel(_ui.theme.border + _panes[1].minWidth), bottom:_ph, left:_zoom2pixel(_panes[0].minWidth)};
		}
		
		_button.alpha = 50;
	}

	private function _buttonDrag(evt:Object):Void {
		_calculateRules();
	}
	
	private function _buttonDragEnd(evt:Object):Void {

		_calculateRules();
		_setSize(_w, _h);

		_ui.hideCursor();
		_button.alpha = 0;
	}

	private function _toggleRelease(evt:Object):Void {
		_collapsed = !_collapsed;	
		_setSize(_w, _h);
	}

	private function _getXML():XMLNode {

		var xml = super._getXML();

		delete xml.firstChild.attributes.w;
		delete xml.firstChild.attributes.h;

		if (xml.firstChild.attributes.margin == "0") {
			delete xml.firstChild.attributes.margin;
		}
		if (xml.firstChild.attributes.padding == "0") {
			delete xml.firstChild.attributes.padding;
		}
		if (_rules.length > 1) {		
			if (_horizontal) {
				xml.firstChild.attributes.rows = rows;
			} else {
				xml.firstChild.attributes.cols = cols;
			}
		}
		if (collapsible == 1) {
			xml.firstChild.attributes.collapsible = collapsible;
		}
		if (collapsed) {
			xml.firstChild.attributes.collapsed = "true";
		}
		if (_panes[0] != undefined){
			xml.firstChild.appendChild(_panes[0].getXML());
		} 
		if (_panes[1] != undefined){
			xml.firstChild.appendChild(_panes[1].getXML());
		} 

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.cols != undefined) {
			cols = xml.attributes.cols;
		}
		if (xml.attributes.rows != undefined) {
			rows = xml.attributes.rows;
		}
		if (xml.attributes.collapsible != undefined) {
			collapsible = parseInt(xml.attributes.collapsible);
		}
		if (xml.attributes.collapsed != undefined) {
			collapsed = (xml.attributes.collapsed == "true") ? true : false;
		}

		var item;
		var i:Number = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			
			item = xml.childNodes[i];
			switch(item.nodeName) {
				case "ScrollPane":
					addItem(new ScrollPane(item.attributes.id)).setXML(item);
					break;
				case "SplitPane":
					addItem(new SplitPane(item.attributes.id)).setXML(item);
					break;
			}
		}

		super._setXML(xml);
	}

	private function _setSize(w:Number, h:Number):Void {

		if (_rules == undefined || _rules.length == 1) {
	
			_panes[0].setSize(w, h);	

		} else {

			var rules = Arrays.duplicate(_rules);
			var sizes = new Array();
			var pb = _zoom2pixel(_ui.theme.border);
			var space:Number;

			if (Arrays.contains(rules, "*")) {

				if (_percents) {
					space = 100 - _ui.theme.border*100/((_horizontal) ? h : w);
				} else {
					space = ((_horizontal) ? h : w) - _ui.theme.border;
				}
				var i:Number = rules.length;
				while(i--) {
					if (_rules[i] != "*") {
						space = space - rules[i];					
					}
				}
				Arrays.replace(rules, "*", space)
			}

			_panes[0].visible = _panes[1].visible = true;

			if (_collapsed) {
				if (_collapsible == 0) {
					rules[1] = parseFloat(rules[0]) + parseFloat(rules[1]);
					rules[0] = 0;	
				} else {
					rules[0] = parseFloat(rules[0]) + parseFloat(rules[1]);
					rules[1] = 0;						
				}
				_panes[_collapsible].visible = false;
			}
			
			if (_percents) {
				sizes[0] = rules[0]*((_horizontal) ? h : w)/100;
			} else {
				sizes[0] = rules[0];
			}	
			sizes[1] = ((_horizontal) ? h : w) - sizes[0] - _ui.theme.border;

			if (!_collapsed) {
				
				var tmpSizes:Array = Arrays.duplicate(sizes);
				if (_horizontal) {		
					sizes[0] = Math.max(sizes[0], _panes[0].minHeight);
					sizes[1] = Math.max(sizes[1], _panes[1].minHeight);
				} else {
					sizes[0] = Math.max(sizes[0], _panes[0].minWidth);
					sizes[1] = Math.max(sizes[1], _panes[1].minWidth);				
				}
				
				if (tmpSizes[1] < sizes[1]) {
					sizes[0] = ((_horizontal) ? h : w) - sizes[1] - _ui.theme.border;				
				}

				sizes[1] = ((_horizontal) ? h : w) - sizes[0] - _ui.theme.border;

			}
						
			var zoomFix:Number = _zoom2pixel(sizes[0]) + _zoom2pixel(sizes[1]) + _zoom2pixel(_ui.theme.border) - _zoom2pixel(h);
			if (zoomFix != 0){
				if (_collapsed && _collapsible == 1) {
					sizes[0] -= _pixel2zoom(zoomFix);				
				} else {
					sizes[1] -= _pixel2zoom(zoomFix);
				}
			}
						
			if (_horizontal) {		
				_panes[0].setSize(w, sizes[0]);
				_panes[1].setSize(w, sizes[1]);
			} else {
				_panes[0].setSize(sizes[0], h);
				_panes[1].setSize(sizes[1], h);
			}
		
			if (_horizontal) {

				_border.rotation = _button.rotation = 90;	
				_border.y = _button.y = (_collapsible == 0 && _collapsed) ? 0 : _panes[0].ph;

				_border.setSize(w, _ui.theme.border);
				_button.setSize(w, _ui.theme.border);

				_panes[1].y = _button.y + _button.ph;
			
				if (_collapsed) {
					_toggle.rotation = (_collapsible == 0) ? 90 : -90;				
				} else {
					_toggle.rotation = (_collapsible == 0) ? -90 : 90;
				}
				_toggle.setSize(_ui.theme.toggle, _ui.theme.border);
				_toggle.move(_zoom2pixel((w - _ui.theme.toggle)/2), _border.y);
							
			} else {

				_border.x = _button.x = (_collapsible == 0 && _collapsed) ? 0 : _panes[0].pw;

				_border.setSize(_ui.theme.border, h);		
				_button.setSize(_ui.theme.border, h);		

				_panes[1].x = _button.x + _button.pw;

				if (_collapsed) {
					_toggle.rotation = (_collapsible == 0) ? 0 : 180;				
				} else {
					_toggle.rotation = (_collapsible == 0) ? 180 : 0;				
				}
				_toggle.setSize(_ui.theme.border, _ui.theme.toggle);
				_toggle.move(_border.x, _zoom2pixel((h - _ui.theme.toggle)/2));

			}
		}
		super._setSize(w, h);
	}

	private function _getRules():String {

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

	private function _calculateRules():Void {

		if (_horizontal) {
			_rules[0] = _pixel2zoom(_button.y - _panes[0].y);					
			_rules[1] = _pixel2zoom(_ph - _button.y - _button.ph);			
		} else {
			_rules[0] = _pixel2zoom(_button.x - _panes[0].x);
			_rules[1] = _pixel2zoom(_pw - _button.x - _button.pw);			
		}

		if (_percents){
			if (_horizontal) {
				_rules[0] = Math.round((_button.y - _panes[0].y)*10000/_ph)/100;					
				_rules[1] = Math.round((_ph - _button.y - _button.ph)*10000/_ph)/100;			
			} else {
				_rules[0] = Math.round((_button.x - _panes[0].x)*10000/_pw)/100;
				_rules[1] = Math.round((_pw - _button.x - _button.pw)*10000/_pw)/100;			
			}
		}
	}

	private function _remove():Void {
		var i:Number = _panes.length;
		while(i--){
			_panes.remove();	
		}
		super._remove();	
	}

}