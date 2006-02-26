import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.CheckBox;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.ComboBox;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Container;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.LabeledTextArea;
import com.asual.enflash.ui.LabeledTextInput;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.Pane;
import com.asual.enflash.ui.ProgressBar;
import com.asual.enflash.ui.RadioButton;
import com.asual.enflash.ui.Rating;
import com.asual.enflash.ui.ScrollBar;
import com.asual.enflash.ui.TextArea;
import com.asual.enflash.ui.TextInput;
import com.asual.enflash.ui.Tree;

import com.asual.enflash.xhtml.A;

class com.asual.enflash.ui.ScrollPane extends Pane {
	
	private var _opaque:Boolean;

	private var _container:Container;
	private var _windows:Collection;
	
	private var _index:Number;
	private var _name:String = "ScrollPane";
	
	private var _rows:Array;
	private var _rowsWidth:Array;
	private var _rowsLeftWidth:Array;
	private var _rowsRightWidth:Array;
	private var _rowsHeight:Array;	

	public function ScrollPane(id:String){
		super(id);
		padding = .5;
	}

	public function addContainer(container:Container):Container {
		
		delete _rect.movieclip.onPress;
		
		_rect.removeEventListener("load", this);
		_rect.remove();
		_rect = null;

		_content.removeEventListener("resize", this);		
		_content.remove();
		_content = null;
		
		_vScroll.removeEventListener("load", this);
		_vScroll.remove();
		_vScroll = null;
		
		_hScroll.removeEventListener("load", this);
		_hScroll.remove();		
		_hScroll = null;
		
		_host = false;
		_ui.themeManager.loadTheme(this);
		
		_container = (container != undefined) ? container : new Container();
		_container.init(_ref, _mc);

		if (_ui.theme.loaded){
			_setSize(_w, _h);
		}
		
		return _container;
	}

	public function removeContainer(container:Container):Container {
		
		_container.remove();

		_host = true;

		_rect = new Button();
		_rect.swf = "scrollpane.swf";
		_rect.addEventListener("load", this, _compLoad);
		_rect.focusable = false;
		_rect.tabIndex = _index*_ui.paneCapacity;
		_rect.init(_ref, _mc);
		
		delete _rect.movieclip.onRollOver;
		delete _rect.movieclip.onRollOut;
		delete _rect.movieclip.onPress;
		delete _rect.movieclip.onRelease;
		
		_rect.movieclip.onPress = createDelegate(this, _rectPress);

		_content = new Collection();
		_content.init(_ref, _mc);
		_content.addEventListener("resize", this, _position);

		_hScroll = new ScrollBar();
		_hScroll.addEventListener("load", this, _compLoad);	
		_hScroll.init(_ref, _mc, 11);
		_hScroll.horizontal = true;
		_hScroll.content = _content;

		_vScroll = new ScrollBar();
		_vScroll.addEventListener("load", this, _compLoad);
		_vScroll.init(_ref, _mc, 12);
		_vScroll.content = _content;

		refresh();

		return _container;
	}
	
	public function getContainer():Container {
		return _container;
	}
	
	public function addItem(component){
		
		if (_content.length == _ui.paneCapacity) return;

		component = super.addItem(component);
		component.tabIndex = _rect.tabIndex + _content.length;
		return component;
	}

	public function addItemAt(index, component){

		if (_content.length == _ui.paneCapacity) return;
		
		component = super.addItemAt(index, component);
		var i:Number = -1;
		var iMax:Number = _content.length;
		while(++i != iMax) {
			_content.getItem(i).tabIndex = _rect.tabIndex + i + 1;
		}
		return component;
	}
	
	public function removeItem(component) {
		
		var item = super.removeItem(component);
		
		var i:Number = -1;
		var iMax:Number = _content.length;
		while(++i != iMax) {
			_content.getItem(i).tabIndex = _rect.tabIndex + i + 1;
		}

		return item;
	}
	
	public function removeItemAt(index) {
		
		var item = super.removeItemAt(index);
		
		var i:Number = -1;
		var iMax:Number = _content.length;
		while(++i != iMax) {
			_content.getItem(i).tabIndex = _rect.tabIndex + i + 1;
		}
		
		return item;
	}
	
	public function refresh():Void {
		if (_ui.visible){
			_position(_w, _h);
			_setSize(_w, _h);
		}
	}

	public function get content():Collection {
		return _content;
	}
	
	public function get opaque():Boolean {
		return _opaque;
	}
	
	public function set opaque(opaque:Boolean):Void {
		if (_opaque == opaque) return;
		_opaque = opaque;
		_rect.swf = (_opaque) ? "scrollpaneopaque.swf" : "scrollpane.swf";
		_hScrollPolicy = (_opaque) ? "off" : "on";
		_vScrollPolicy = (_opaque) ? "off" : "on";
	}

	public function get length():Number {
		if (_content.length != undefined) {
			return _content.length;
		} else {
			return 0;
		}
	}

	public function get index():Number {
		return _index;
	}
	
	public function set index(index:Number):Void {
		_index = index;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);

		_ui.themeManager.removeEventListener("panesize", this);	
		_ui.focusManager.register(this);

		_rect.swf = "scrollpane.swf";
		_rect.focusable = false;
		_rect.tabIndex = _index*_ui.paneCapacity;

		_content.addEventListener("resize", this, _position);
	}
		
	private function _getXML():XMLNode {

		var xml = super._getXML();
		
		if (opaque) {
			xml.firstChild.attributes.opaque = opaque;
			delete xml.firstChild.attributes.hScrollPolicy;
			delete xml.firstChild.attributes.vScrollPolicy;
		}

		delete xml.firstChild.attributes.w;
		delete xml.firstChild.attributes.h;
		delete xml.firstChild.attributes.swf;
		
		if (_rect.swf != "scrollpane.swf" && _rect.swf != "scrollpaneopaque.swf" && _rect.swf != undefined) {
			xml.firstChild.attributes.swf = _rect.swf;
		}

		if (xml.firstChild.attributes.padding == "0.5") {
			delete xml.firstChild.attributes.padding;
		}
		if (xml.firstChild.attributes.margin == "0.5") {
			delete xml.firstChild.attributes.margin;
		}
		if (_container != undefined){
			xml.firstChild.appendChild(_container.getXML());
		} 

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (_container != undefined) {
			_container.remove();
		} else {
			if (_content.length > 0) {
				removeAll();
			}
		}
		if (_ui.visible && _content != undefined && _enflash.conf.themesLoading) {
			_content.visible = false;
		}
		if (xml.attributes.opaque != undefined) {
			opaque = (xml.attributes.opaque == "true") ? true : false;
		}
		if (xml.attributes.swf != undefined) {
			_rect.swf = xml.attributes.swf;
		}

		var item, node;
		var i:Number = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			switch(item.nodeName) {
				case "A":
					addItem(new A(item.attributes.id)).setXML(item);
					break;
				case "Button":
					addItem(new Button(item.attributes.id)).setXML(item);
					break;
				case "CheckBox":
					addItem(new CheckBox(item.attributes.id)).setXML(item);
					break;
				case "Component":
					addItem(new Component(item.attributes.id)).setXML(item);
					break;
				case "ComboBox":
					addItem(new ComboBox(item.attributes.id)).setXML(item);
					break;
				case "Container":
					addContainer(new Container(item.attributes.id)).setXML(item);
					break;
				case "Label":
					addItem(new Label(item.attributes.id)).setXML(item);
					break;
				case "LabeledTextInput":
					addItem(new LabeledTextInput(item.attributes.id)).setXML(item);
					break;
				case "LabeledTextArea":
					addItem(new LabeledTextArea(item.attributes.id)).setXML(item);
					break;
				case "ListBox":
					addItem(new ListBox(item.attributes.id)).setXML(item);
					break;
				case "Pane":
					addItem(new Pane(item.attributes.id)).setXML(item);
					break;
				case "ProgressBar":
					addItem(new ProgressBar(item.attributes.id)).setXML(item);
					break;
				case "RadioButton":
					addItem(new RadioButton(item.attributes.id)).setXML(item);
					break;
				case "Rating":
					addItem(new Rating(item.attributes.id)).setXML(item);
					break;
				case "TextInput":
					addItem(new TextInput(item.attributes.id)).setXML(item);
					break;
				case "TextArea":
					addItem(new TextArea(item.attributes.id)).setXML(item);
					break;
				case "Tree":
					addItem(new Tree(item.attributes.id)).setXML(item);
					break;
			}
		}
		
		super._setXML(xml);
	}

	private function _setSize(w:Number, h:Number):Void {

		_scrollSpace = _ui.theme.space;
		_scrollSize = _ui.theme.scroll;		
		
		if (_ui.visible) {

			w = Math.max(w, _minWidth);
			h = Math.max(h, _minHeight);

			if (_container != undefined){
				_container.setSize(_zoom2pixel(w), _zoom2pixel(h));
			}
		}

		super._setSize(w, h);
	}

	private function _getContentWidth():Number {
		
		var w = 0;
		var row;
		var i:Number = _rowsWidth.length;
		while (i--){
			if (w < _rowsWidth[i]){
				w = _rowsWidth[i];
				row = i;
			} 
		}
		
		return w + _zoom2pixel(_padding.left + _padding.right);
	}

	private function _getContentHeight():Number {
		
		var h = 0;
		var i:Number = _rowsHeight.length;
		while (i--){
			h += _rowsHeight[i];
		}
		return h + _zoom2pixel(_padding.top + _padding.bottom);
	}
	
	private function _position(){

		if (_ui.visible && _container == undefined){

			_rows = new Array();
			_rows.push(new Array());

			_rowsWidth = new Array();
			_rowsWidth.push(0);			
			_rowsLeftWidth = new Array();
			_rowsLeftWidth.push(0);
			_rowsRightWidth = new Array();
			_rowsRightWidth.push(0);

			_rowsHeight = new Array();
			_rowsHeight.push(0);

			var maxWidth = _content.w - _zoom2pixel(_padding.left + _padding.right);

			var component, cw, ch, rows, row, prev, sw, sh, j;
			
			var i:Number = - 1;
			while (++i != _content.length){
				
				component = _content.getItem(i);
				
				if (component.display == "block" && component.autoSize.w) {
					if (component.zoom) {
						component.w = _pixel2zoom(maxWidth) - (component.margin.left + component.margin.right);
					} else {
						component.w = maxWidth - _zoom2pixel(component.margin.left + component.margin.right);						
					}
					component.autoSize = { w: true, h: true };
				}

				cw = component.pw + _zoom2pixel(component.margin.left + component.margin.right);
				ch = component.ph + _zoom2pixel(component.margin.top + component.margin.bottom);

				rows = _rows.length - 1;
				row = _rows[rows];
				prev = row[row.length - 1];
				
				if ((_rowsWidth[rows] + cw > maxWidth) || component.clear){
					
					_rows.push(new Array(component));
					_rowsWidth.push(cw);
					if (component.float == "right") {
						_rowsLeftWidth.push(0);
						_rowsRightWidth.push(cw);
					} else {
						_rowsLeftWidth.push(cw);
						_rowsRightWidth.push(0);
					}
					_rowsHeight.push(ch);

				} else {

					_rows[rows].push(component);
					_rowsWidth[rows] += cw;
					if (component.float == "right") {
						_rowsRightWidth[rows] += cw;
					} else {
						_rowsLeftWidth[rows] += cw;
					}
					var newRowHeight = ch;
					if (_rowsHeight[rows] < newRowHeight){
						_rowsHeight[rows] = newRowHeight;
					}
				}

				rows = _rows.length - 1;
				
				sh = 0;
				j = rows;
				while (j--){
					sh += _rowsHeight[j];
				}
				
				if (component.float == "right") {
					component.x = maxWidth - _rowsRightWidth[rows] + _zoom2pixel(_padding.left + component.margin.left);
				} else {
					component.x = _rowsLeftWidth[rows] - component.pw - _zoom2pixel(component.margin.right - padding.left);
				}

				component.y = sh + _zoom2pixel(component.margin.top + _padding.top);
			}
		}
	}
	
	private function _rectPress(evt:Object):Void {
		if (_ui.focusedPane == this){
			Selection.setFocus(null);
		} else {
			_rect.focusable = true;
			Selection.setFocus(_rect.movieclip);
		}
	}

	private function _componentLoad(evt):Void {

		var loaded = super._componentLoad(evt);
		
		if (loaded) {
			_content.visible = true;
		}
	}		

	private function _remove():Void {
/*
		delete _rect.movieclip.onPress;
		
		_rect.removeEventListener("load", this);
		_rect.remove();
		_rect = null;

		_content.removeEventListener("resize", this);		
		_content.remove();
		_content = null;
		
		_vScroll.removeEventListener("load", this);
		_vScroll.remove();
		_vScroll = null;
		
		_hScroll.removeEventListener("load", this);
		_hScroll.remove();		
		_hScroll = null;
*/
		_ui.focusManager.unregister(this);

		if (_rect){
			delete _rect.movieclip.onPress;
			_rect.remove();
		}
		super._remove();	
	}

}