import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectorListener;
import org.as2lib.data.io.conn.ConnectorError;
import org.as2lib.data.io.conn.ConnectorResponse;
import org.as2lib.Config;
import org.as2lib.env.out.OutAccess;

class test.unit.org.as2lib.data.io.conn.ExampleListener extends BasicClass implements ConnectorListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	private var cnt:Number;
	/* Standard debug output */
	private var aOut:OutAccess;
	
	public function ExampleListener(Void) {
		counter++;
		cnt=counter;
		aOut = Config.getOut();
		aOut.debug(getClass().getName()+".instance: "+counter);
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectorError):Void{
		aOut.debug(getClass().getName()+".onError");
		aOut.debug(getClass().getName()+".cnt = "+cnt);
		aOut.error(error);
	}
	
	public function onResponse(response:ConnectorResponse):Void{
		aOut.debug(getClass().getName()+".onResponse");
		aOut.debug(getClass().getName()+".cnt = "+cnt);
		aOut.debug(response.getData().toString());
	}
}