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
		cnt=counter++;
		myOut = new Out();
		myOut.info("ExampleListener.instance: "+counter);
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectorError):Void{
		trace("onError "+cnt);
		myOut.error(error);
	}
	
	public function onResponse(response:ConnectorResponse):Void{
		trace("onResponse");
		myOut.info(response.toString());
	}
}