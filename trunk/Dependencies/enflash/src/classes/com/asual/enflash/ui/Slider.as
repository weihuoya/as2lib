import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Component;

class com.asual.enflash.ui.Slider extends Component {
	
	private var _drag:Button;
	private var _name:String = "Slider";

	public function Slider(id:String){
		super(id);
	}


	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {

		super._init(parent, mc, depth);		

		_drag = new Button();
		_drag.init(_id, _mc);
		_drag.draggable = true;

	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		return xml;
	}
	
	private function _setXML(xml):Void {


		super._setXML(xml);
				
	}

	private function _setSize(w:Number, h:Number):Void {

		super._setSize(w, h);
			
	}

	private function _dragMove(evt:Object):Void {
	
	}

	private function _dragEnd(evt:Object):Void {


	}
	
	private function _remove():Void {

		_drag.remove();
		super._remove();
	}		
}