import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.out.Out;

class test.org.as2lib.data.io.conn.ExampleListener extends BasicClass implements ConnectorListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	private var cnt:Number;
	private var myOut:Out;
	
	public function ExampleListener(Void) {
		counter++;
		cnt=counter;
		myOut = new Out();
		myOut.info("ExampleListener.instance: "+counter);
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectorError):Void{
		myOut.info("ExampleListener Nr."+cnt);
		myOut.info(error.getMessage());
		myOut.error(error);
	}
	
	public function onResponse(response:ConnectorResponse):Void{
		trace("ExampleListener Nr."+cnt);
		//trace(response.getName());
		myOut.info(response.getData().toString());
	}
}