import com.asual.enflash.EnFlashObject;

class com.asual.enflash.managers.ZoomManager extends EnFlashObject {

	private var _zoom:Number = 100;
	private var _factor:Number = 11;
	private var _fontSize:Number = 0;
	private var _name:String = "ZoomManager";

	public var ontextzoom:Function;
	public var onzoom:Function;
	public var onwindowsize:Function;

	public function ZoomManager(id:String) {
		super(id);
	}

	public function get factor():Number {
		return _factor;
	}

	public function get fontSize():Number {
		return _fontSize;
	}
	
	public function get zoom():Number {
		return _zoom;
	}
	
	public function set zoom(zoom:Number):Void {

		_zoom = zoom;
		_fontSize = Math.round((_zoom - 100)/10);
		_setFontSize();
		_enflash.setLocal("zoom", Number(_zoom));
	}

	private function _init(parent:Number):Void {
		
		super._init(parent);

		_enflash.getByRef(parent).themeManager.addEventListener("themeload", this, _setFontSize);

		if (!isNaN(_enflash.getLocal("zoom"))){ 
			zoom = _enflash.getLocal("zoom");
		}
	}
	
	private function _setFontSize():Void {
		
		_factor = _fontSize + parent.theme.fontSize;

		if (_enflash.ui.loaded) {
			dispatchEvent("textzoom");
			dispatchEvent("zoom");
			dispatchEvent("windowsize");
			_enflash.ui.setSize(_enflash.ui.w, _enflash.ui.h);
		}
	}
}