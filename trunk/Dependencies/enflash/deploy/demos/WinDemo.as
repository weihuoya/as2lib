import com.asual.enflash.EnFlash;
import com.asual.enflash.EnFlashConfiguration;

import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.UITheme;
import com.asual.enflash.ui.Window;

import com.asual.enflash.utils.Time;

class WinDemo extends EnFlash {

	private var _prjWin:Window;
	private var _descWin:Window;
	private var _optWin:Window;
	private var _winDimension:Number = 18;
				
	private var _name:String = "WinDemo";

	public static function main():Void {
		
		var conf = new EnFlashConfiguration();
		conf.xmlMode = true;
		if (conf.xmlFile == undefined){
			conf.xmlFile = "windemo.xml";
		}
		conf.themesLoading = false;
		conf.marginTop = (_root.enflash != undefined) ? 24 : 0;
		
		(new WinDemo()).init(conf);
	}

	public function uiLoad(evt:Object):Void {
		
		_prjWin = _enflash.getById("prjWin");
		_descWin = _enflash.getById("descWin");
		_optWin = _enflash.getById("optWin");

		var langMenu = getById("langMenu");
		var i:Number = langMenu.length;
		while(i--) {
			if (_ui.lang == langMenu.getItem(i).id) {
				langMenu.getItem(i).checked = true;
			} else {
				langMenu.getItem(i).checked = false;				
			}
		}

		var zoomBox = getById("zoomBox");
		i = zoomBox.length;
		while(i--) {
			if (parseInt(zoomBox.getItem(i).value) == ui.zoom) {
				zoomBox.selectedIndex = i;
				break;
			}
		}

		var themeBox = getById("themeBox");
		i = themeBox.length;
		while(i--) {
			if (themeBox.getItem(i).id == (ui.theme.name.toLowerCase() + "Theme")) {
				themeBox.selectedIndex = i;
				break;
			}
		}

		winSize();
		showProject();
		log("ui loaded");
	}

	public function zoomChange(evt:Object):Void {
		var zoom = parseInt(evt.selectedItem.value);
		if(_ui.loaded && !isNaN(zoom)) {
			_ui.zoom = zoom;	
		}
	}

	public function themeChange(evt:Object):Void {

		if(_ui.visible) {
			switch(evt.selectedItem.id){
				case "defaultTheme":
					ui.theme = new UITheme(_enflash.conf.themesRepository + "default.swf");
					break;
				case "oasisTheme":
					ui.theme = new UITheme(_enflash.conf.themesRepository + "oasis.swf");
					break;
				case "officeTheme":
					ui.theme = new UITheme(_enflash.conf.themesRepository + "office.swf");
					break;
			}
		}
	}
	
	public function winChange(evt:Object):Void {
	
		var win;
	
		switch (evt.menuItem.id) {
			case "prjMenuItem":
				win = _prjWin;
				break;
			case "optMenuItem":
				win = _optWin;
				break;
			case "descMenuItem":
				win = _descWin;
				break;
		}
		
		if (evt.menuItem.checked) {
			win.open();			
		} else {
			win.close();			
		}
		
		winSize();
	}

	public function langChange(evt:Object):Void {

		_ui.lang = evt.menuItem.id;
	}
	
	public function helpChange(evt:Object):Void {

		switch(evt.menuItem.id){
			case "aboutMenuItem":
				var dialog = getById("aboutDialog");
				dialog.open();
				break;
			case "homepageMenuItem":
				_root.getURL("http://www.asual.com/enflash/", "_blank");
				break;
		}
	}

	public function winSize(evt:Object):Void {
	
		if (!ui.loaded) return;
	
		var space = ui.theme.uiPadding;
		var x = space;
		var y = ui.bars.h + space*2;
		var w = ui.w;
		var h = ui.h - y + space;
		
		var ow = ui.zoom2pixel(_winDimension);
		var oh = ui.zoom2pixel(_winDimension);

		var visWins = new Array();
		var isProjects, isOptions, isDesc;

		if (_prjWin.visible) {
			visWins.push(_prjWin);
		}
		if (_optWin.visible) {
			visWins.push(_optWin);
		}
		if (_descWin.visible) {
			visWins.push(_descWin);
		}

		switch(visWins.length) {
			case 1:
				visWins[0].x = x;
				visWins[0].y = y;
				visWins[0].w = w;
				visWins[0].h = h;
				
				break;	
			case 2:
				if (_descWin.visible) {
				
					visWins[0].x = x;
					visWins[0].y = y;
					visWins[0].w = ow;
					visWins[0].h = Math.max(oh, h);
					
					visWins[1].x = x + ow + space;
					visWins[1].y = y;
					visWins[1].w = Math.max(ow, w - ow - space);
					visWins[1].h = visWins[0].h;
				
				} else {
					
					visWins[0].x = x;
					visWins[0].y = y;
					visWins[0].w = w;
					visWins[0].h = Math.max(oh, h - oh - space);
					
					visWins[1].x = x;
					visWins[1].y = visWins[0].y + visWins[0].h + space;
					visWins[1].w = w;
					visWins[1].h = oh;
				}
				break;	
			
			case 3:
				visWins[0].x = x;
				visWins[0].y = y;		
				visWins[0].w = ow;
				visWins[0].h = Math.max(oh, h - oh - space);
		
				visWins[1].x = x;
				visWins[1].y = visWins[0].y + visWins[0].h + space;
				visWins[1].w = ow;
				visWins[1].h = oh;
				
				visWins[2].x = x + ow + space;
				visWins[2].y = y;
				visWins[2].w = Math.max(ow, w - ow - space);
				visWins[2].h = visWins[0].h + space + visWins[1].h;
				break;	
		}

		var pane = _prjWin.getPane(0);
		pane.getItem(0).h = pane.h - pane.padding.top - pane.padding.bottom - ui.pixel2zoom(_ui.theme.space*2);
		pane.refresh();
	}

	public function winClose(evt:Object):Void {
		
		var menuitem;

		switch (evt.target.id) {
			case "prjWin":
				menuitem = getById("prjMenuItem");
				break;
			case "optWin":
				menuitem = getById("optMenuItem");
				break;
			case "descWin":
				menuitem = getById("descMenuItem");
				break;
		}
		menuitem.checked = false;
		
		winSize();
	}
	
	public function showProject(evt:Object):Void {

		if (_descWin != undefined) {
			
			var pane = _descWin.getPane(0);
			pane.removeAll();
	
			var label = pane.addItem(new Label());
			Time.setTimeout(this, "_showLoading", 1000, label);
			
			var prjXML = new XML();
			prjXML.ignoreWhite = true;
			prjXML.onLoad = createDelegate(this, _loadProject);
			prjXML.load("projects/" + getById("prjList").selectedItem.value.toLowerCase() + ".xml");
		}
	}	

	private function _showLoading(label):Void {

		if (label.value != null) {
			label.value = "Loading...";
		}
	}	
	
	private function _loadProject(evt:Object):Void {
		var pane = _descWin.getPane(0);
		pane.setXML(evt.target.firstChild);
		pane.refresh();
	}
}