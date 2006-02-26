import com.asual.enflash.data.List;

import com.asual.enflash.managers.FocusManager;
import com.asual.enflash.managers.LangManager;
import com.asual.enflash.managers.ShortcutManager;
import com.asual.enflash.managers.ThemeManager;
import com.asual.enflash.managers.ZoomManager;

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Collection;
import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Container;
import com.asual.enflash.ui.Cursor;
import com.asual.enflash.ui.Dialog;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.Menu;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.UITheme;
import com.asual.enflash.ui.Window;

class com.asual.enflash.ui.UI extends Container {

	private var _bg:Component;
	private var _cursor:Cursor;
	private var _combos:Collection;
	private var _menus:Collection;
	private var _openedMenus:List;
	private var _log:Window;
	
	private var _fm:FocusManager;
	private var _sm:ShortcutManager;
	private var _lm:LangManager;
	private var _tm:ThemeManager;
	private var _zm:ZoomManager;
	
	private var _stageInterval:Number;
	private var _label:Label;

	private var _dialog:Dialog;
	private var _dialogs:Collection;
	private var _dialogBackground:Button;

	private var _css:String;
	private var _styleSheet:TextField.StyleSheet;

	private var _loaded:Boolean = false;
	private var _isMouseDown:Boolean = false;
	private var _paneCapacity:Number = 100;
	private var _name:String = "UI";

	public var onstyles:Function;
	public var onenterframe:Function;
	public var onkeydown:Function;
	public var onkeyup:Function;
	public var onmousedown:Function;
	public var onmouseup:Function;
	public var onthemeload:Function;
	public var onthemeset:Function;
	public var onzoom:Function;
	
	public function UI(id:String) {
		super(id);
		_ui = this;
	}

	public function init(parent:Number, mc:MovieClip, depth:Number):Void {
		_init(parent, mc, depth);
	}

	public function addDialog(dialog:Dialog):Dialog {
		dialog = _dialogs.addItem((dialog != undefined) ? dialog : new Dialog());
		dialog.addEventListener("open", this, _openDialog);
		dialog.addEventListener("close", this, _closeDialog);
		return dialog;
	}
	
	public function addShortcut(object:Object, shortcut:String):Void {
		_sm.addShortcut(object, shortcut);
	}

	public function removeShortcut(object:Object):Void {
		_sm.removeShortcut(object);
	}

	public function addComboList(listBox):ListBox {
		return _combos.addItem(listBox);
	}

	public function removeComboList(listBox:ListBox):ListBox {
		return _combos.removeItem(listBox);
	}

	public function closeComboList():Void {

		var i:Number = _combos.length;
		var item;
		while(i--){
			item = _combos.getItem(i);
			if (item.visible) {
				item.comboBox.close();	
			}
		}
	}

	public function addMenu(menu:Menu):Menu {
		if (menu == undefined) menu = new Menu();
		menu.addEventListener("open", this, _openMenu);
		menu.addEventListener("close", this, _closeMenu);
		return _menus.addItem(menu);
	}

	public function removeMenu(menu:Menu):Void {
		menu.removeEventListener("open", this);
		menu.removeEventListener("close", this);
		_menus.removeItem(menu);
	}

	public function removeMenus():Void {
		_menus.removeAll();
	}
	
	public function closeMenu():Void {
		_openedMenus.lastItem.close();
	}
	
	public function closeMenus():Void {
		var i:Number = _menus.length;
		while(i--){
			_menus.getItem(i).close();
		}
	}

	public function showCursor(cursor:String):Void {
		_cursor.show(cursor);
	}

	public function hideCursor():Void {
		_cursor.hide();
	}

	public function getX(object):Number {
		var x = object.x;
		if (object.parent != this){
			x += getX(object.parent);
			if (object.parent.hPosition != undefined) {
				x -= object.parent.hPosition;	
			}
		}
		return x;		
	}

	public function getY(object):Number {
		var y = object.y;
		if (object.parent != this){
			y += getY(object.parent);
			if (object.parent.vPosition != undefined) {
				y -= object.parent.vPosition;	
			}
		}
		return y;
	}

	public function get systemFont():String {
		return _tm.font;
	}

	public function get dialog():Object {
		return _dialog;
	}

	public function set lang(lang:String):Void {
		_lm.lang = lang;
	}

	public function get lang():String {
		return _lm.lang;
	}

	public function set theme(theme:UITheme):Void {
		_tm.theme = theme;
	}

	public function get theme():UITheme {
		return _tm.theme;
	}

	public function zoom2pixel(value:Number):Number {
		return _zoom2pixel(value);
	}

	public function pixel2zoom(value:Number):Number {
		return _pixel2zoom(value);
	}

	public function set zoom(zoom:Number):Void {
		_zm.zoom = zoom;
		dispatchEvent("zoom");
	}

	public function get zoom():Number {
		return _zm.zoom;
	}

	public function get paneCapacity():Number {
		return _paneCapacity;
	}

	public function get focusedPane():ScrollPane {
		return _fm.getFocusedPane();
	}

	public function get loaded():Boolean {
		return _loaded;
	}

	public function get css():String {
		return _css;
	}	

	public function set css(css:String):Void {
		
		_css = css;
		if (_styleSheet == undefined) {
			_styleSheet = new TextField.StyleSheet();
		}
		_styleSheet.load(_css);
		_styleSheet.onLoad = createDelegate(this, _styleLoad);
	}
	
	public function get isMouseDown():Boolean {
		return _isMouseDown;
	}

	public function get styleSheet():TextField.StyleSheet {
		return _styleSheet;
	}

	public function get labelHeight():Number {
		return _label.h;
	}

	public function get focus():Object {
		return _fm.focusedObject;
	}
	
	public function set focus(object:Object):Void {
		_fm.focusedObject = object;
	}

	public function get previousFocus():Object {
		return _fm.previousFocus;
	}

	public function get nextFocus():Object {
		return _fm.nextFocus;
	}

	public function get focusManager():FocusManager {
		return _fm;
	}

	public function get shortcutManager():ShortcutManager {
		return _sm;
	}

	public function get themeManager():ThemeManager {
		return _tm;
	}

	public function get zoomManager():ZoomManager {
		return _zm;
	}

	public function get langManager():LangManager {
		return _lm;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);

		Stage.scaleMode = "noScale";
		Stage.align = "TL";
		Stage.showMenu = false;

		var listener = new Object();
		listener.onResize = createDelegate(this, _stageResize);
		listener.onMouseDown = createDelegate(this, _mouseDown);
		listener.onMouseUp = createDelegate(this, _mouseUp);
		listener.onMouseWheel = createDelegate(this, _mouseWheel);
		listener.onKeyDown = createDelegate(this, _keyDown);
		listener.onKeyUp = createDelegate(this, _keyUp);

		Mouse.addListener(listener);
		Key.addListener(listener);
		Stage.addListener(listener);
		
		_mc.onEnterFrame = createDelegate(this, _enterFrame);

		_tm = new ThemeManager();		
		_tm.addEventListener("themeload", this, _themeLoad);
		_tm.addEventListener("themeset", this, _themeSet);
		_tm.init(_ref);

		_zm = new ZoomManager();		
		_zm.init(_ref);	

		_fm = new FocusManager();
		_fm.init(_ref);

		_sm = new ShortcutManager();
		_sm.init(_ref);

		_lm = new LangManager();		
		_lm.init(_ref);	

		_openedMenus = new List();
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		if (css != undefined) {
			xml.firstChild.attributes.css = css;
		}
		if (getListeners("zoom").length > 0) {
			xml.firstChild.attributes.onzoom = _getEvent("zoom");
		}
		if (getListeners("themeload").length > 0) {
			xml.firstChild.attributes.onthemeload = _getEvent("themeload");
		}
		if (getListeners("themeset").length > 0) {
			xml.firstChild.attributes.onthemeset = _getEvent("themeset");
		}
		var i = -1;
		var iMax = _dialogs.length;
		while(++i != iMax) {
			xml.firstChild.appendChild(_dialogs.getItem(i).getXML());
		}

		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (theme.name == undefined) {
			_ui.addEventListener("themeload", this, _themeSetXML, {xml: xml});	
			return;
		}

		if (xml.attributes.theme != undefined) {
			theme = new UITheme(xml.attributes.theme);
		}
		if (xml.attributes.lang != undefined) {
			lang = xml.attributes.lang;
		}
		if (xml.attributes.css != undefined) {
			css = xml.attributes.css;
		}
		if (xml.attributes.onzoom != undefined) {
			_setEvent("zoom", xml.attributes.onzoom);
		}
		if (xml.attributes.onthemeload != undefined) {
			_setEvent("themeload", xml.attributes.onthemeload);
		}
		if (xml.attributes.onthemeset != undefined) {
			_setEvent("themeset", xml.attributes.onthemeset);
		}
		if (_dialogs.length > 0) {
			_dialogs.removeAll();
		}

		var item;
		var i:Number = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];
			switch(item.nodeName) {
				case "Dialog":
					addDialog(new Dialog(item.attributes.id)).setXML(item);
					break;
				case "Menu":
					addMenu(new Menu(item.attributes.id)).setXML(item);
					break;
			}
		}

		super._setXML(xml);
	}

	private function _createComponents():Void {

		_label = new Label();
		_label.wordWrap = false;
		_label.init(_ref, _mc, 0);
		_label.value = "HIDDEN_LABEL";

		_bg = new Component();
		_bg.swf = "bg.swf";
		_bg.init(_ref, _mc, 1);

		_dialogBackground = new Button();
		_dialogBackground.swf = "bg.swf";
		_dialogBackground.init(_ref, _mc, 11);
		_dialogBackground.alpha = 10;
		_dialogBackground.visible = false;	

		_dialogs = new Collection();
		_dialogs.init(_ref, _mc, 12);

		_log = new Window("EnFlashLogWindow");
		_log.init(_ref, _mc, 13);
		_log.setSize(360, 225);
		_log.title = "Log";
		_log.visible = _enflash.logger;
		
		var pane = _log.addPane();
		pane.padding = 0;
		
		var label = pane.addItem(new Label("EnFlashLogLabel"));
		label.multiline = true;

		_combos = new Collection();
		_combos.init(_ref, _mc, 14);

		_menus = new Collection();
		_menus.init(_ref, _mc, 15);
		
		_cursor = new Cursor();
		_cursor.init(_ref, _mc, 16);
	}

	private function _setSize(w:Number, h:Number):Void {

		var padding = theme.uiPadding;
		_bg.move(-padding, -padding);
		_bg.setSize(w + padding*2, h + padding*2);

		closeMenus();
		_menus.setSize(w + padding*2, h + padding*2);
		_combos.setSize(w + padding*2, h + padding*2);

		super._setSize(w, h);
		
		_windows.move(-padding, -padding);
		_windows.setSize(w + padding*2, h + padding*2);
	
		_dialogBackground.move(-padding, -padding);
		_dialogBackground.setSize(w + padding*2, h + padding*2);

		_dialogs.move(-padding, -padding);
		_dialogs.setSize(w + padding*2, h + padding*2);
	
	}

	private function _styleLoad(evt:Object):Void {
		if (evt.success) {
			dispatchEvent("styles");	
		}
	}
	
	private function _openMenu(evt:Object):Void {
		
		_openedMenus.addItem(evt.target);

		var id = focus._parent._parent._parent._id;
		if (id.indexOf("TextArea") > -1){
			Selection.setFocus(null);
		}
	}

	private function _closeMenu(evt:Object):Void {
		_openedMenus.removeItem(evt.target);
	}

	private function _openDialog(evt:Object):Void {
		_dialogBackground.visible = true;
		_dialog = evt.target;
		_fm.disableAll();
	}

	private function _closeDialog(evt:Object):Void {
		_dialogBackground.visible = false;
		_dialog = undefined;
		_fm.enableAll();
	}
	
	private function _themeSetXML(evt:Object):Void {
	
		_createComponents();
		_ui.removeEventListener("themeload", this, _themeSetXML);
		setXML(evt.xml);
	}

	private function _stageResize():Void {
		if (_stageInterval == null){
			_stageInterval = setInterval(this, "_resize", 200);
		}		
	}
	
	private function _resize():Void {
		
		if (_stageInterval != undefined){
			clearInterval(_stageInterval);
			delete _stageInterval;
		}

		var padding = theme.uiPadding;
		
		var neww = Stage.width - padding*2 - _enflash.conf.marginLeft - _enflash.conf.marginRight;
		var newh = Stage.height - padding*2 - _enflash.conf.marginTop - _enflash.conf.marginBottom;
		
		if (neww != _w || newh != _h){
			move(_enflash.conf.marginLeft + padding, _enflash.conf.marginTop + padding);
			_setSize(neww, newh);
		}

		_logPosition();
	}
	
	private function _logPosition():Void {
		if (_log != undefined){
			_log.x = _w - _log.w - _ui.zoom2pixel(theme.scroll) - 20;
			_log.y = _h - _log.h - _ui.zoom2pixel(theme.scroll) - 20;
		}
	}

	private function _themeLoad():Void {
		
		if (!_enflash.conf.xmlMode && !_ui.loaded) {
			_createComponents();
		}

		dispatchEvent("themeload");
	}
	
	private function _themeSet():Void {
		
		dispatchEvent("themeset");

		if (!_loaded) {

			_loaded = true;
			_logPosition();

			if (lang != undefined) {
				lang = lang;
			}
			
			dispatchEvent("load");
		}
	}

	private function _enterFrame():Void {
		dispatchEvent("enterframe");
	}
	
	private function _mouseDown():Void {
		
		_isMouseDown = true;
		
		var i:Number;
		
		if (_openedMenus.length > 0){

			i = -1;
			var over:Boolean = false;
			var iMax:Number = _openedMenus.length;
			while(++i != iMax){
				if (_openedMenus.getItem(i).asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
					over = true;	
				}
			}
			if (_openedMenus.firstItem.menuParent.asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
				over = true;	
			}
			if (!over) closeMenus();
		}	

		i = _combos.length;
		var item;
		while(i--){
			item = _combos.getItem(i);
			if (item.visible) {
				if (!item.asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false) && !item.comboBox.asset.hitTest(_enflash.movieclip._xmouse, _enflash.movieclip._ymouse, false)){
					item.comboBox.close();	
				}
			}
		}
		
		dispatchEvent("mousedown");
	}

	private function _mouseUp():Void {
		_isMouseDown = false;
		dispatchEvent("mouseup");
	}
	
	private function _mouseWheel(evt):Void {
	
		var delta = evt.delta;

		if (focus.toString().indexOf("TextArea") > -1 && focus.textfield.maxscroll > 1){

			focus.textfield.scroll -= delta;

		} else if (focus.vPosition != undefined) {

			var pane = focus;

			if (pane.opaque) return;
			
			if (Key.isDown(Key.SHIFT)){
				pane.hPosition = pane.hPosition - delta*pane.smallStep;
			} else {
				pane.vPosition = pane.vPosition - delta*pane.smallStep;
			}
			
		} else {
			
			var pane = focusedPane;

			if (pane.opaque) return;
			
			closeComboList();
			
			if (_dialog != undefined && pane != _dialog.getPane(0)) return;

			if (Key.isDown(Key.SHIFT)){
				pane.hPosition = pane.hPosition - delta*pane.smallStep;
			} else {
				pane.vPosition = pane.vPosition - delta*pane.smallStep;
			}
		}		
	}
	
	private function _keyDown():Void {
		
		if (_openedMenus.length > 0){

			if (Key.getCode() == Key.UP){
				_openedMenus.lastItem.moveUp();	
			}

			if (Key.getCode() == Key.DOWN){
				_openedMenus.lastItem.moveDown();	
			}

			if (Key.getCode() == Key.LEFT){
					
				if (_openedMenus.lastItem.menuParent.toString() == "MenuItem"){
					_openedMenus.lastItem.menuParent.moveLeft();
				} else if (_openedMenus.firstItem.menuParent.toString() == "Button") {
					_openedMenus.firstItem.menuParent.parent.parent.moveLeft();	
				}
			}

			if (Key.getCode() == Key.RIGHT){
				if (_openedMenus.lastItem.selectedItem.menu != undefined){
					_openedMenus.lastItem.selectedItem.moveRight();
				} else if (_openedMenus.firstItem.menuParent.toString() == "Button") {
					_openedMenus.firstItem.menuParent.parent.parent.moveRight();	
				}
			}
			
			if (Key.getCode() == Key.ENTER){
				_openedMenus.lastItem.executeEnter();
				closeMenus();
			}
		}

		dispatchEvent("keydown");
	}

	private function _keyUp():Void {
		dispatchEvent("keyup");
	}			
}