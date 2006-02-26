import com.asual.enflash.ui.UIObject;

class com.asual.enflash.ui.Icon extends UIObject {

	private var _icon:MovieClip;
	private var _linkage:String;
	private var _name:String = "Icon";

	public function Icon(linkage:String, id:String) {
		super(id);
		_linkage = linkage;
	}
	
	public function get linkage():String {
		return _linkage;
	}

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent);
		
		if (depth == undefined) depth = mc.getNextHighestDepth();

		_mc = mc.attachMovie(_linkage, _id, depth);
		_mc._ref = _ref;
		_mc._alpha = _alpha;
		_mc._visible = _visible;
	}

	private function _setSize(w:Number, h:Number):Void {
		super._setSize(w, h);
		_mc._width = w;
		_mc._height = h;
	}
		
}