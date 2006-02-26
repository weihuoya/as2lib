import com.asual.enflash.ui.UIObject;
import com.asual.enflash.utils.MovieClips;

class com.asual.enflash.ui.Mask extends UIObject{

	private var _name:String = "Mask";
	
	public function Mask(id:String) {
		super(id);
	}

	public function apply(mc:MovieClip):Void {
		mc.setMask(_mc);
	}

	private function _setSize(w:Number, h:Number):Void {
		_mc.clear();
		_mc.beginFill(0x000000);
		MovieClips.simpleRect(_mc, 0, 0, w, h); 
		_mc.endFill();
	}	
}