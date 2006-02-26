import com.asual.enflash.EnFlashObject;

import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Dialog;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.UITheme;

import com.asual.enflash.utils.Arrays;
import com.asual.enflash.utils.Strings;

class com.asual.enflash.managers.ThemeManager extends EnFlashObject {
	
	private var _mc:MovieClip;
	private var _thememc:MovieClip;
	private var _theme:UITheme;	
	private var _swf:String;	
	private var _timeout:Number;	
	private var _loading:Number;
	private var _font:String;
	private var _queue:Array;
	private var _assets:Array;
	private var _name:String = "ThemeManager";

	public var oncomponentload:Function;

	public var onthemechange:Function;
	public var onthemeload:Function;
	public var onthemeset:Function;

	public var onpanesize:Function;
	public var onwindowsize:Function;
			
	public function ThemeManager(id:String) {
		
		super(id);
		_queue = new Array();
	}
	
	public function init(parent:Number, url:String) {
		_init(parent, url);
	}

	public function getSystemFont(family:String):String {

		if (family != undefined) {

			family = Strings.replace(family, ", ", ",");
			var members:Array = family.split(",");
			var fonts:Array = TextField.getFontList();

			if (fonts == undefined || fonts.length == 0) {
				return "_sans";	
			}

			var i, j;
			i = -1;
			while(++i != members.length){
				j = fonts.length;
				while(j--){
					if (members[i] == fonts[j]){
						return fonts[j];
					}
				}
			}
		}
	}
	
	public function get font():String {
		return _font;
	}
	
	public function get theme():UITheme {
		return _theme;
	}

	public function set theme(theme:UITheme):Void {
				
		if (theme == undefined || theme.url == _theme.url) return;

		_enflash.ui.visible = false;

		_enflash.loaderCall("setPercents", 0);
		_enflash.loaderCall("loadTheme");
		_enflash.loaderCall("show");

		if (_theme == undefined) {
			_theme = theme;
		}

		var thememc:MovieClip;

		if (_enflash.conf.themesLoading) {
			
			thememc = _mc.createEmptyMovieClip("_theme" + _mc.getNextHighestDepth(), _mc.getNextHighestDepth());
			thememc.loadMovie(theme.url);
	
			if (_thememc == undefined) {
				_thememc = thememc;
			}
	
			_timeout = 0;
						
		} else {

			var path = theme.url.split("/");
			_swf = path[path.length - 1];

			thememc = _mc.attachMovie(_swf, "_theme" + _mc.getNextHighestDepth(), _mc.getNextHighestDepth());

			if (_thememc == undefined) {
				_thememc = thememc;
			}
					
			_enflash.loaderCall("setPercents", 100);

		}

		_enflash.ui.removeEventListener("enterframe", this);
		_enflash.ui.addEventListener("enterframe", this, _themeCheck, {theme: theme, mc: thememc});
		
	}

	public function loadTheme(component:Component):Void {

		if (_enflash.conf.themesLoading) {
	
			component.asset.unloadMovie();
			if (component.swf != undefined) {
				_loadAsset(component);			
			} else {
				if (_enflash.ui.visible) {
					dispatchEventOnce(component, "componentload");
				}
			}
		
		} else {

			if (component.swf != undefined) {
				_loadAsset(component);	
				_showAsset(component);	
			} else {
				if (_enflash.ui.visible) {
					dispatchEventOnce(component, "componentload");
				}
			}			
		}
	}

	public function unloadTheme(component:Component):Void {
		
		component.asset.unloadMovie();
		Arrays.remove(_queue, component);
		
		if (_enflash.ui.visible) {
			dispatchEventOnce(component, "componentload");
		}

	}

	private function _init(parent:Number):Void {

		super._init(parent);

		_mc = _enflash.ui.movieclip.createEmptyMovieClip("_theme", 9999);
		_mc._visible = false;

		if (_enflash.conf.initialTheme != undefined) {
			theme = new UITheme(_enflash.conf.themesRepository + _enflash.conf.initialTheme);
		} else if (_enflash.getLocal("theme") != undefined){
			theme = new UITheme(_enflash.getLocal("theme"));
		} else {
			theme = new UITheme(_enflash.conf.themesRepository + _enflash.conf.defaultTheme);
		}
	}
		
	private function _themeCheck(evt:Object):Void {

		if (_enflash.conf.themesLoading) {

			_timeout++;
	
			var bl = evt.mc.getBytesLoaded();
			var bt = evt.mc.getBytesTotal();
			
			if (bt != undefined && bt > 0 && bl == bt) {
	
				if (evt.mc._loaded) {
					_themeLoad(evt.theme, evt.mc);
				}
				evt.mc._loaded = true;
			
			} else if (_timeout > 100) {
	
				_themeError();
			}
	
		} else {

			if (evt.mc._loaded) {
				_themeLoad(evt.theme, evt.mc);
			}
			if (evt.mc.name != undefined) {
				evt.mc._loaded = true;
				
			}
		}
	}

	private function _themeError():Void {
		
		_enflash.ui.visible = true;
		_enflash.ui.addEventListener("enterframe", this, _queueCheck);

		var themeErrorDialog = _enflash.getById("themeErrorDialog");

		if (themeErrorDialog == undefined) {

			themeErrorDialog = _enflash.ui.addDialog(new Dialog("themeErrorDialog"));
			themeErrorDialog.title = "Error";
			themeErrorDialog.setSize(400, 300);

			var themeErrorPane = themeErrorDialog.addPane(new ScrollPane());

			var themeErrorLabel = new Label();
			themeErrorLabel.display = "inline";
			themeErrorLabel.multiline = true;
			themeErrorLabel.wordWrap = false;
			themeErrorLabel.value = "Theme loading failed.";

			themeErrorPane.addItem(themeErrorLabel);

			_enflash.ui.addEventListener("enterframe", this, _themeErrorDialogLoad, {components: [themeErrorDialog.getBar(0).ref, themeErrorPane.ref, themeErrorLabel.ref]});
		
		} else {
			
			themeErrorDialog.refresh();
			themeErrorDialog.open();
		}
	}

	private function _themeErrorDialogLoad(evt:Object):Void {

		var i:Number = evt.components.length;
		while(i--) {
			if (!_enflash.getByRef(evt.components[i]).loaded) {
				return;
			}
		}

		var themeErrorDialog = _enflash.getById("themeErrorDialog");
		themeErrorDialog.refresh();
		themeErrorDialog.open();
		_enflash.ui.removeEventListener("enterframe", this, _themeErrorDialogLoad);

		_enflash.loaderCall("hide");
	}

	private function _themeLoad(theme:UITheme, thememc:MovieClip):Void {

		if (_theme != theme) {
			_theme = theme;
			_thememc = thememc;
		}

		for(var p in _thememc) {
			_theme[p] = _thememc[p];
		}

		_assets = new Array();
		var themeAssets = _theme.getAssets();
		for (var p in themeAssets) {
			_assets.push(themeAssets[p]);	
		}
		_font = getSystemFont(_theme.fontFamily);
		
		_enflash.setLocal("theme", String(_theme.url));

		if (_enflash.ui.loaded) {
			dispatchEvent("themechange");
		}

		if (_enflash.conf.themesLoading) {
			
			var url = Strings.replace(_theme.url, ".swf", "/");
			var i:Number = _assets.length;
			while (i--) {
				_thememc.createEmptyMovieClip("_asset" + i, i);
				_thememc["_asset" + i].loadMovie(url + _assets[i]);
			}	

			_enflash.ui.removeEventListener("enterframe", this);
			_enflash.ui.addEventListener("enterframe", this, _assetsCheck);
		
		} else {

			_enflash.ui.removeEventListener("enterframe", this);
			//_enflash.ui.addEventListener("enterframe", this, _assetsCheck);

			_enflash.loaderCall("setPercents", 100);
			dispatchEvent("themeload");	

			if (_enflash.ui.loaded) {
	
				var components = this.getListeners("componentload");
				var i = -1;
				var iMax = components.length;
				while (++i != iMax) {
					loadTheme(components[i].object);
				}
			}
			_themeSet();		
		}
	}
	
	private function _themeSet():Void {
		
		_enflash.ui.visible = true;

		dispatchEvent("componentload");
		dispatchEvent("panesize");
		dispatchEvent("windowsize");

		_enflash.ui.move(_enflash.conf.marginLeft + _theme.uiPadding, _enflash.conf.marginTop + _theme.uiPadding);
		_enflash.ui.setSize(Stage.width - _theme.uiPadding*2 - _enflash.conf.marginLeft - _enflash.conf.marginRight, Stage.height - _theme.uiPadding*2 - _enflash.conf.marginTop - _enflash.conf.marginBottom);

		dispatchEvent("themeset");
		_enflash.loaderCall("hide");
	}
	
	private function _assetsCheck() {

		var count = 0;
		var bl, bt;
		var i = -1;
		var iMax:Number = _assets.length;
		while(++i != iMax){
			
			bl = _thememc["_asset" + i].getBytesLoaded();
			bt = _thememc["_asset" + i].getBytesTotal();
			
			if (bt != undefined && bt > 0 && bl == bt) {
				count++;
			}
		}
		
		_enflash.loaderCall("setPercents", Math.round((count/iMax)*100));

		if (count != iMax) {
			return;
		}
		
		dispatchEvent("themeload");

		if (_enflash.ui.loaded) {

			var components = this.getListeners("componentload");
			i = -1;
			iMax = components.length;
			while (++i != iMax) {
				loadTheme(components[i].object);
			}
		}

		_enflash.ui.removeEventListener("enterframe", this);
		_enflash.ui.addEventListener("enterframe", this, _queueCheck);
	}

	private function _queueCheck(evt:Object):Void {

		if (_queue.length == 0) return;

		var bl, bt;
		var i:Number = -1;
		while(++i < _queue.length){

			if (_queue[i].asset._loaded) {
				_showAsset(_queue[i]);
			}
			
			bl = _queue[i].asset.getBytesLoaded();
			bt = _queue[i].asset.getBytesTotal();

			if (bt != undefined && bt > 0 && bl == bt) {
				_queue[i].asset._loaded = true;
			}
		}
		
		if (!_enflash.ui.visible && _queue.length == 0) {
			_themeSet();
		}
	}
	
	private function _loadAsset(component:Component):Void {

		var url = Strings.replace(_theme.url, ".swf", "/");

		if (_enflash.conf.themesLoading) {
	
			if (!Arrays.contains(_queue, component)) {
				_queue.push(component);
			}
			if (Arrays.contains(_assets, component.swf)) {
				component.asset.loadMovie(url + component.swf); 
			} else {
				component.asset.loadMovie(component.swf);
			}
			
		} else {
			
			if (Arrays.contains(_assets, component.swf)) {
				component["_asset"] = component.movieclip.attachMovie(_swf + "." + component.swf, "_asset", 0);
			} else {
				component["_asset"] = component.movieclip.attachMovie(component.swf, "_asset", 0);
			}
			component["_asset"]._loaded = true;
		}
	}

	private function _showAsset(component:Component):Void {

		if (_enflash.conf.themesLoading) {
			Arrays.remove(_queue, component);
		}		
		
		if (_enflash.ui.visible) {
			dispatchEventOnce(component, "componentload");
		}
	}
}	