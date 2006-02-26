import com.asual.enflash.ui.Component;

class com.asual.enflash.ui.Cursor extends Component {
	
	private var _margintop:Number;
	private var _marginleft:Number;
	private var _name:String = "Cursor";

	public function Cursor(id:String) {
		super(id);
		_swf = "cursor.swf";
	}

	public function show(cursor:String):Void {

		_asset.show(cursor);
		_margintop = (_ui.movieclip.margintop != undefined) ? parseInt(_ui.movieclip.margintop) : 0;
		_marginleft = (_ui.movieclip.marginleft != undefined) ? parseInt(_ui.movieclip.marginleft) : 0;		

		_position();

		_ui.addEventListener("enterframe", this, _position);
		Mouse.hide();
		visible = true;
	}	

	public function hide():Void {
		visible = false;
		asset.hide();
		_ui.removeEventListener("enterframe", this);
		Mouse.show();
	}	

	private function _position():Void {
		x = Math.round(_ui.movieclip._xmouse) - 16 - _marginleft;
		y = Math.round(_ui.movieclip._ymouse) - 16 - _margintop;
	}	
}