import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.env.out.Out;

class test.org.as2lib.data.io.conn.ExampleListener extends BasicClass implements ConnectorListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	private var myOut:Out;
	
	public function ExampleListener(Void) {
		counter++
		myOut = new Out();
		myOut.info("ExampleListener.counter: "+counter);
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectorError):Void{
		myOut.error(error);
	}
	
	public function onResponse(response:ConnectorResponse):Void{
		myOut.info(response.toString());
	}
}