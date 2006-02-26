
import org.aswing.debug.Delegate;
import org.aswing.debug.Logger;

/**
 *
 * @author iiley
 */
class org.aswing.debug.SOSLogger implements Logger {
	
	private var mysocket:XMLSocket;
	private var tracesBeforeConnected:Array;
	private var connected:Boolean;
	
	public function SOSLogger(){
		connected = false;
		tracesBeforeConnected = new Array();
		mysocket = new XMLSocket();
		mysocket.connect("127.0.0.1", 4444);
		mysocket.onConnect = Delegate.create(this, __onConnect);
	}
	
	private function __onConnect():Void{
		connected = true;
		for(var i:Number=0; i<tracesBeforeConnected.length; i++){
			log(tracesBeforeConnected[i]);
		}
		tracesBeforeConnected = new Array();
	}
	
	public function log(msg:String):Void {
		if(connected){
			mysocket.send(msg + "\n");
		}else{
			tracesBeforeConnected.push(msg);
		}
	}

}