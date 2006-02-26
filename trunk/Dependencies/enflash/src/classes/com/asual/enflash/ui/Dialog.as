//import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.Window;

class com.asual.enflash.ui.Dialog extends Window {

	private var _ratio:Boolean = true;
	private var _name:String = "Dialog";

	public function Dialog(id:String){
		super(id);
		_visible = false;
	}

	public function open():Void {

		x = Math.round((_ui.w - _w)/2);
		y = Math.round((_ui.h - _h)/2);

		super.open();
	}

	public function get ratio():Boolean {
		return _ratio;	
	}

	public function set ratio(ratio:Boolean):Void {
		_ratio = ratio;	
		_refresh();
	}
	
	private function _refresh():Void {

		super._refresh();

		h = _bars.h + _panes.getItem(0).contentHeight;
		w = (_ratio) ? _panes.getItem(0).contentHeight*1.6 : _panes.getItem(0).contentWidth;
	}

	private function _addPane(pane) {
		pane = super._addPane(pane);
		pane.hScrollPolicy = "off";
		pane.vScrollPolicy = "off";
		return pane;
	}
	
	private function _getXML():XMLNode {

		var xml = super._getXML();

		delete xml.firstChild.attributes.onopen;
		delete xml.firstChild.attributes.onclose;
		delete xml.firstChild.attributes.x;
		delete xml.firstChild.attributes.y;
		delete xml.firstChild.attributes.visible;
						
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if(xml.attributes.ratio != undefined){
			ratio = (xml.attributes.ratio == "false") ? false : true;
		}
		super._setXML(xml);
	}

}