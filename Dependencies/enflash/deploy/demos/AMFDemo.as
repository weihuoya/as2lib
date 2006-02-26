import com.asual.enflash.*;
import com.asual.enflash.ui.*;

import mx.remoting.*;
import mx.remoting.debug.*;
import mx.rpc.*;

class AMFDemo extends EnFlash {
	
	private var _name:String = "AMFDemo";

	public static function main():Void {
		
		var conf = new EnFlashConfiguration();
		conf.marginTop = (_root.enflash != undefined) ? 24 : 0;
		
		(new AMFDemo()).init(conf);
	}

	public function init(conf:EnFlashConfiguration):Void {
	
		super.init(conf);
		_ui.addEventListener("themeload", this, _createUI);
		NetDebug.initialize();
	}

	private function _createUI():Void {
		
		_ui.addBar(new TitleBar("mainBar")).value = "EnFlash AMFDemo";
		_ui.addPane(new ScrollPane("mainPane"));

		_remoteCall("http://localhost/remoting/openamf/gateway");
		_remoteCall("http://localhost/remoting/amfphp/gateway.php");
	}

	private function _remoteCall(gateway:String):Void {

		var service:Service = new Service(gateway, null , "AMFDemo", null, null );
		var call:PendingCall = service.helloWorld();
		call.responder = new RelayResponder(this, "_helloWorld");
	}
		
	private function _helloWorld(evt:Object):Void {

		var label = getById("mainPane").addItem(new Label());
		label.display = "block";
		label.fontSize = 10;
		label.margin = {bottom: 0};
		label.value = evt.result;
	}

}