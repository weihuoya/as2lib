import com.asual.enflash.EnFlashObject;
import com.asual.enflash.ui.Component;

dynamic class com.asual.enflash.ui.UITheme extends EnFlashObject {	
	
	public var author:String;
	public var name:String;
	public var version:String;

	public var fontFamily:String = "";
	public var fontSize:Number = 11;

	// pixel values
	public var corner:Number = 3;
	public var space:Number = 2;	
	public var uiPadding:Number = 4;

	// zoom values
	public var scroll:Number = 1.6;	
	public var toggle:Number = 5;
	public var border:Number = 0.5;	

	private var _url:String;
	private var _swfMap:Object;
	private var _parent:MovieClip;
	private var _name:String = "UITheme";

	public function UITheme(url: String, id:String) {

		super(id);
		_url = url;
	}

	public function get url():String {
		return _url;
	}

	public function getAssets():Object {

		var assets = new Object();
		assets.bar = "bar.swf";
		assets.bg = "bg.swf";
		assets.button = "button.swf";
		assets.checkbox = "checkbox.swf";
		assets.combobox = "combobox.swf";
		assets.cursor = "cursor.swf";
		assets.label = "label.swf";
		assets.listitem = "listitem.swf";
		assets.menu = "menu.swf";
		assets.menubaritem = "menubaritem.swf";
		assets.menuitem = "menuitem.swf";
		assets.menuseparator = "menuseparator.swf";
		assets.pane = "pane.swf";
		assets.panesplit = "panesplit.swf";
		assets.panetoggle = "panetoggle.swf";
		assets.progressbar = "progressbar.swf";
		assets.radiobutton = "radiobutton.swf";
		assets.rating = "rating.swf";
		assets.scrollbutton = "scrollbutton.swf";
		assets.scrollpane = "scrollpane.swf";
		assets.scrollpaneopaque = "scrollpaneopaque.swf";
		assets.scrollthumb = "scrollthumb.swf";
		assets.scrolltrack = "scrolltrack.swf";
		assets.text = "text.swf";
		assets.titlebarbutton = "titlebarbutton.swf";
		assets.treeitem = "treeitem.swf";

		if (this.getCustomAssets != undefined) {
			assets = this.getCustomAssets(assets);
		}

		var i = _enflash.conf.excludeAssets.length;
		while(i--) {
			delete assets[_enflash.conf.excludeAssets[i]];
		}
				
		return assets;		
	}
	
	public function getMethods(component:Component, swf:String):Object {
		
		var methods:Object = new Object();
		
		methods.setSize = setSize;
		methods.setRotation = setRotation;
		methods.focus = focus;
		methods.blur = blur;		
		
		switch(component.toString()){
			case "Button":
				methods.setUp = setUp;
				methods.setUpOver = setUpOver;
				methods.setUpDisabled = setUpDisabled;
				methods.setDown = setDown;
				methods.setDownOver = setDownOver;
				methods.setDownDisabled = setDownDisabled;
				break;
			case "ComboBox":
				methods.setSize = setComboBoxSize;
				methods.setUp = setUp;
				methods.setUpOver = setUpOver;
				methods.setUpDisabled = setUpDisabled;
				methods.setDown = setDown;
				methods.setDownOver = setDownOver;
				methods.setDownDisabled = setDownDisabled;
				break;				
			case "Cursor":
				methods.show = showCursor;
				methods.hide = hideCursor;
				break;
			case "Label":
				methods.setSize = setLabelSize;
				methods.setNormal = setLabelNormal;
				methods.setDisabled = setLabelDisabled;
				methods.setFontSize = setFontSize;			
				break;	
			case "MenuItem":
				methods.setSize = setMenuItemSize;
				methods.setUp = setUp;
				methods.setUpOver = setUpOver;
				methods.setUpDisabled = setUpDisabled;
				methods.setDown = setDown;
				methods.setDownOver = setDownOver;
				methods.setDownDisabled = setDownDisabled;
				methods.setCheck = setMenuItemCheck;	
				methods.setRadio = setMenuItemRadio;	
				methods.setExpand = setMenuItemExpand;
				break;
			case "ProgressBar":
				methods.setSize = setProgressBarSize;
				methods.setValue = setProgressBarValue;
				break;	
			case "ListItem":
				methods.setSize = setListItemSize;
				methods.setUp = setUp;
				methods.setUpOver = setUpOver;
				methods.setUpDisabled = setUpDisabled;
				methods.setDown = setDown;
				methods.setDownOver = setDownOver;
				methods.setDownDisabled = setDownDisabled;
				break;
			case "TreeItem":
				methods.setSize = setTreeItemSize;
				methods.setUp = setUp;
				methods.setUpOver = setUpOver;
				methods.setUpDisabled = setUpDisabled;
				methods.setDown = setDown;
				methods.setDownOver = setDownOver;
				methods.setDownDisabled = setDownDisabled;
				methods.setExpand = setTreeItemExpand;	
				methods.setExpandable = setTreeItemExpandable;	
				break;	
		}
		
		switch(swf){
			case "bg.swf":
				methods.setSize = setBgSize;
				break;
			case "checkbox.swf":
				methods.setSize = setCheckBoxSize;
				methods.setCheck = setCheckBoxCheck;
				break;	
			case "menuseparator.swf":
				methods.setSize = setSeparatorSize;
				break;
			case "panesplit.swf":
				methods.setSize = setPaneSplitSize;
				break;				
			case "panetoggle.swf":
				methods.setSize = setPaneToggleSize;
				methods.setRotation = setPaneToggleRotation;
				break;
			case "radiobutton.swf":
				methods.setSize = setRadioButtonSize;
				methods.setCheck = setRadioButtonCheck;
				break;
			case "rating.swf":
				methods.setSize = setRatingSize;
				break;
			case "scrollbutton.swf":
				methods.setSize = setScrollButtonSize;
				methods.setRotation = setScrollButtonRotation;
				break;				
			case "scrollthumb.swf":
				methods.setSize = setScrollThumbSize;
				break;
			case "scrolltrack.swf":
				methods.setSize = setScrollTrackSize;
				break;
			case "titlebarbutton.swf":
				methods.setSize = setTitleBarButtonSize;
				break;
		}	
		
		if (this.getCustomMethods != undefined) {
			methods = this.getCustomMethods(methods, component, swf);
		}

		return methods;
	}

	public function setSize(w, h):Void {
		
		this.top._width = w - this.corner*2;
		this.topright._x = w;
		this.left._height = h - this.corner*2;
		this.center._width = w - this.corner*2;
		this.center._height = h - this.corner*2;
		this.right._x = w;
		this.right._height = h - this.corner*2;
		this.bottomleft._y = h - this.corner;
		this.bottom._width = w - this.corner*2;
		this.bottom._y = h - this.corner;
		this.bottomright._x = w;
		this.bottomright._y = h - this.corner;
	}
	
	public function setRotation(angle:Number, w:Number, h:Number):Void {
		
		if (angle == 0) return;
		
		this._rotation = angle;
		
		switch(this._rotation){
			case -90:
				this.setSize(h, w);
				this._y = h;			
				break;
			case 90:
				this.setSize(h, w);
				this._x = w;
				break;
			case 180:
				this._x = w;
				this._y = h;
				break;
		}
	}

	public function setIconSize(w, h):Void {
		
		this._width = w;
		this._height = h;
	}

	public function setFontSize(size, font, align):Void {
		
		size += this.fontSize;

		if (font == undefined) {
			font = this.enflash.ui.systemFont;
		}


		if (this._textfield.styleSheet != undefined){
			
			for (var p in this._textfield.styleSheet._styles){
				this._textfield.styleSheet._styles[p].font = font;
				this._textfield.styleSheet._styles[p].size = size;
				this._textfield.styleSheet._styles[p].align = align;
			}
			
		} else {
			
			var fmt = this._textfield.getTextFormat();
			fmt.size = size;		
			fmt.font = font;
			fmt.align = align;
			this._textfield.setTextFormat(fmt);
			this._textfield.setNewTextFormat(fmt);
		
		}
	}
	
	public function focus():Void {
		for (var mc in this){
			this[mc].focus._visible = true;
		}
	}

	public function blur():Void {
		for (var mc in this){
			this[mc].focus._visible = false;
		}
	}
	
	public function setLabelSize(w, h):Void {
		if (this._textfield.type == "input" && this._textfield.multiline) {
			w = w - this.enflash.ui.zoom2pixel(this.enflash.ui.theme.scroll);
		}
		this._textfield._width = w;
		this._textfield._height = h;
	}
	
	public function setLabelNormal():Void {
		for (var p in this){
			var o = this[p];
			if (o == this.tf){
				o._visible = true;
			} else {
				o._visible = false;
			}
		}
	}
	
	public function setLabelDisabled():Void {
		for (var p in this){
			var o = this[p];
			if (o == this.tfdisabled){
				o._visible = true;
			} else {
				o._visible = false;
			}
		}
	}
	
	public function setScrollTrackSize(w:Number, h:Number):Void {
		
		this.top._width = w-this.corner*2;
		this.topright._x = w-this.corner;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w - this.corner;
		this.right._height = h-this.corner*2;
		this.bottomleft._y = h;
		this.bottom._width = w-this.corner*2;
		this.bottom._y = h;
		this.bottomright._x = w-this.corner;
		this.bottomright._y = h;
	}
	
	public function setScrollThumbSize(w:Number, h:Number):Void {
		
		this.top._width = w-this.corner*2;
		this.topright._x = w-this.corner;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w - this.corner;
		this.right._height = h-this.corner*2;
		this.bottomleft._y = h;
		this.bottom._width = w-this.corner*2;
		this.bottom._y = h;
		this.bottomright._x = w-this.corner;
		this.bottomright._y = h;
		
		this.icon._xscale = Math.round(100*w/18);
		this.icon._yscale = Math.round(100*w/18);
		this.icon._x = w/2;
		this.icon._y = Math.round(h/2);			
	}

	public function setScrollButtonSize(w:Number, h:Number):Void {
		
		this.top._width = w-this.corner*2;
		this.topright._x = w;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w;
		this.right._height = h-this.corner*2;
		
		this.bottomleft._y = h-this.corner;
		this.bottomleft._y = h-this.corner;

		this.bottom._width = w-this.corner*2;
		this.bottom._y = h-this.corner;

		this.bottomright._x = w-this.corner;
		this.bottomright._y = h-this.corner;
		
		this.icon._xscale = Math.round(100*w/18);
		this.icon._yscale = Math.round(100*w/18);

		this.icon._x = w/2;
		this.icon._y = h/2;
	}
	
	public function setScrollButtonRotation(angle:Number, w:Number, h:Number):Void {
		
		if (angle == 0) return;
		
		this.icon._rotation = angle;
		
		this.bottomleft._rotation = angle;
		this.bottomright._rotation = angle;
		
		switch(this.icon._rotation){
			case -90:
				this.topright._rotation = 360;
				this.topright._x = 0;	
				this.topright._y = h;				
				this.bottomleft._x = w - this.corner;
				this.bottomleft._y = h;			
				this.bottomright._x =  w - this.corner;
				this.bottomright._y = this.corner;
				break;
			case 90:
				this.topleft._rotation = 90;
				this.topleft._x = w ;	
				this.topleft._y = 0;
				this.topright._rotation = 270;
				this.topright._x = w;	
				this.topright._y = h;		
				this.bottomleft._x = this.corner;			
				this.bottomleft._y = 0;			
				this.bottomright._x = this.corner;
				this.bottomright._y = h - this.corner;			
				break;
			case 180:
				this.topleft._rotation = 270;
				this.topleft._x = 0;	
				this.topleft._y = h;
				this.topright._rotation = 270;
				this.topright._x = w;	
				this.topright._y = h;
				this.bottomleft._x = w;			
				this.bottomleft._y = this.corner;			
				this.bottomright._x = this.corner;
				this.bottomright._y = this.corner;			
				break;	
		}
	}

	public function setUp():Void {
		for (var mc in this){
			this[mc].gotoAndStop(1);
		}
	}	
	
	public function setUpOver():Void {
		for (var mc in this){
			this[mc].gotoAndStop(2);
		}
	}
	
	public function setUpDisabled():Void {
		for (var mc in this){
			this[mc].gotoAndStop(3);
		}
	}	
	
	public function setDown():Void {
		for (var mc in this){
			this[mc].gotoAndStop(4);
		}
	}		

	public function setDownOver():Void {
		for (var mc in this){
			this[mc].gotoAndStop(5);
		}
	}
	
	public function setDownDisabled():Void {
		for (var mc in this){
			this[mc].gotoAndStop(6);
		}
	}
	
	public function setBgSize(w:Number, h:Number):Void {
		this.center._width = w;
		this.center._height = h;
	}

	public function setSeparatorSize(w:Number, h:Number):Void {
		this.top._width = w;
		this.top._height = h/2;
		this.bottom._width = w;
		this.bottom._y = h/2;		
		this.bottom._height = h/2;
	}

	public function setCheckBoxSize(w:Number, h:Number):Void {

		this.top._width = w-this.corner*2;
		this.topright._x = w;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w;
		this.right._height = h-this.corner*2;
		this.bottomleft._y = h-this.corner;
		this.bottom._width = w-this.corner*2;
		this.bottom._y = h-this.corner;
		this.bottomright._x = w;
		this.bottomright._y = h-this.corner;
		
		this.check._xscale = this.check._yscale = Math.round(100*h/21);

		this.check._x = w/2;
		this.check._y = h/2;	
	}

	public function setCheckBoxCheck(flag:Boolean):Void {
		this.check._visible = flag;
	}

	public function setComboBoxSize(w:Number, h:Number):Void {

		this.top._width = w-this.corner*2;
		this.topright._x = w;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w;
		this.right._height = h-this.corner*2;
		this.bottomleft._y = h-this.corner;
		this.bottom._width = w-this.corner*2;
		this.bottom._y = h-this.corner;
		this.bottomright._x = w;
		this.bottomright._y = h-this.corner;
		
		var bw = this.enflash.ui.zoom2pixel(this.enflash.ui.theme.scroll) + this.enflash.ui.theme.space;
		var bx = w - bw;
		
		this.btntopleft._x = bx;
		this.btntop._x = bx + this.corner;
		this.btntop._width = bw - this.corner*2;
		this.btntopright._x = w;
		this.btnleft._x = bx;
		this.btnleft._height = h - this.corner*2;
		this.btncenter._x = bx + this.corner;
		this.btncenter._width = bw - this.corner*2;
		this.btncenter._height = h - this.corner*2;
		this.btnright._x = w;
		this.btnright._height = h - this.corner*2;
		this.btnbottomleft._x = bx;
		this.btnbottomleft._y = h - this.corner;
		this.btnbottom._x = bx + this.corner;
		this.btnbottom._width = bw - this.corner*2;
		this.btnbottom._y = h - this.corner;
		this.btnbottomright._x = w;
		this.btnbottomright._y = h - this.corner;
		
		this.icon._xscale = 100*bw/18;
		this.icon._yscale = 100*bw/18;
		this.icon._x = bx + bw/2;
		this.icon._y = h/2;
	
	}
	
	public function setRadioButtonSize(w:Number, h:Number):Void {
		
		this.circle._width = w;
		this.circle._height = h;
		
		this.center._width = w - this.corner;
		this.center._height = h - this.corner;
		
		this.check._xscale = this.check._yscale = Math.round(100*h/21);
		this.check._x = w/2;
		this.check._y = h/2;
	}

	public function setRadioButtonCheck(flag:Boolean):Void {
		this.check._visible = flag;
	}

	public function setRatingSize(w:Number, h:Number):Void {
		
		this.circle._width = w;
		this.circle._height = h;
		
		this.center._width = w - this.corner;
		this.center._height = h - this.corner;	
	}

	public function setMenuItemSize(w:Number, h:Number):Void {

		this.center._width = w;
		this.center._height = h;
		
		this.check._xscale = this.check._yscale = this.radio._xscale = this.radio._yscale = this.expand._xscale = this.expand._yscale = Math.round(100*h/21);

		var paddingleft = this.enflash.ui.zoom2pixel(this.enflash.getByRef(_parent._ref).padding.left);
		var paddingright = this.enflash.ui.zoom2pixel(this.enflash.getByRef(_parent._ref).padding.right);

		this.check._x = this.radio._x = paddingleft/2;
		this.expand._x = w - paddingright/2;
		this.check._y = this.radio._y = this.expand._y = h/2;	
	}
	
	public function setMenuItemCheck(flag:Boolean):Void {
		this.check._visible = flag;
	}

	public function setMenuItemRadio(flag:Boolean):Void {
		this.radio._visible = flag;
	}

	public function setMenuItemExpand(flag:Boolean):Void {
		this.expand._visible = flag;
	}

	public function setListItemSize(w:Number, h:Number):Void {

		this.center._width = w;
		this.center._height = h;
	}

	public function setTreeItemSize(w:Number, h:Number):Void {

		var paddingleft = this.enflash.ui.zoom2pixel(this.enflash.getByRef(_parent._ref).padding.left);
		var marginleft = this.enflash.ui.zoom2pixel(this.enflash.getByRef(_parent._ref).label.margin.left);

		this.center._width = w;
		this.center._height = h;
		
		this.expand._xscale = this.expand._yscale = this.collapse._xscale = this.collapse._yscale = Math.round(100*h/21);
		this.expand._x = this.collapse._x = paddingleft + marginleft*.6;
		this.expand._y = this.collapse._y = h/2;
	}

	public function setTreeItemExpand(flag:Boolean):Void {
		this.expand._visible = !flag;
		this.collapse._visible = flag;
	}

	public function setTreeItemExpandable(flag:Boolean):Void {
		this.expand._visible = flag;
		this.collapse._visible = flag;
	}
	
	public function setProgressBarSize(w:Number, h:Number):Void {

		this.top._width = w-this.corner*2;
		this.topright._x = w;
		this.left._height = h-this.corner*2;
		this.center._width = w-this.corner*2;
		this.center._height = h-this.corner*2;
		this.right._x = w;
		this.right._height = h-this.corner*2;
		this.bottomleft._y = h-this.corner;
		this.bottom._width = w-this.corner*2;
		this.bottom._y = h-this.corner;
		this.bottomright._x = w;
		this.bottomright._y = h-this.corner;

		this.bar._width = w - this.corner*2;
		this.bar._height = h - this.corner*2;
	}

	public function setProgressBarValue(value:Number):Void {
		
		this.bar._width = Math.round(this.center._width*value/100);
	}

	public function setPaneToggleSize(w:Number, h:Number):Void {

		if (w < h){
			this.icon._xscale = 100*w/6;
			this.icon._yscale = 100*w/6;
		} else {
			this.icon._xscale = 100*h/6;
			this.icon._yscale = 100*h/6;
		}
		
		this.icon._x = w/2;
		this.icon._y = h/2;
		this.center._width = w;
		this.center._height = h;
	
	}	
	
	public function setPaneToggleRotation(angle:Number, w:Number, h:Number):Void {

		this.icon._rotation = angle;
		
		switch(angle){
			case -90:
				this.center._rotation = 90;
				this.center._x = w;
				this.center._height = w;
				break;
			case 90:
				this.center._rotation = 90;
				this.center._x = w;
				this.center._height = w;
				break;
		}		
	}	

	public function setPaneSplitSize(w:Number, h:Number):Void {

		this.center._width = w;
		this.center._height = h;
	}

	public function setTitleBarButtonSize(w:Number, h:Number):Void {
		
		this.top._width = w - this.corner*2;
		this.topright._x = w;
		this.left._height = h - this.corner*2;
		this.center._width = w - this.corner*2;
		this.center._height = h - this.corner*2;
		this.right._x = w;
		this.right._height = h - this.corner*2;
		this.bottomleft._y = h - this.corner;
		this.bottom._width = w - this.corner*2;
		this.bottom._y = h - this.corner;
		this.bottomright._x = w;
		this.bottomright._y = h - this.corner;
		
		this.icon._xscale = Math.round(100*w/18);
		this.icon._yscale = Math.round(100*w/18);

		this.icon._x = w/2;
		this.icon._y = h/2;
	}
	
	public function showCursor(cursor:String):Void {
		switch (cursor) {
			case "n-resize":
				this.gotoAndStop(5);
				break;
			case "s-resize":
				this.gotoAndStop(5);
				break;
			case "e-resize":
				this.gotoAndStop(4);
				break;
			case "w-resize":
				this.gotoAndStop(4);
				break;	
			case "nw-resize":
				this.gotoAndStop(3);
				break;
			case "se-resize":
				this.gotoAndStop(3);
				break;	
			case "ne-resize":
				this.gotoAndStop(2);
				break;
			case "sw-resize":
				this.gotoAndStop(2);
				break;	
			case "ns-split":
				this.gotoAndStop(6);
				break;
			case "ew-split":
				this.gotoAndStop(7);
				break;					
			case "hand":
				this.gotoAndStop(8);
				break;	
			default:
				this.gotoAndStop(1);
				break;					
		}
	}
	
	public function hideCursor():Void {
		this.gotoAndStop(1);
	}	
}