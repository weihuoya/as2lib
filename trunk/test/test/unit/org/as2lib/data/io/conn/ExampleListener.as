import org.as2lib.core.BasicClass;
import org.as2lib.data.io.conn.ConnectionListener;
import org.as2lib.data.io.conn.ConnectionError;
import org.as2lib.data.io.conn.ConnectionResponse;
import org.as2lib.env.out.Out;

class ExampleListener extends BasicClass implements ConnectionListener {
	/** Internal counter (just to do something */
	public static var counter:Number = 0;
	private var myOut:Out;
	
	public function ExampleListener(Void) {
		counter++
		myOut = new Out();
	}
	
	/**
	 * Executes a call.
	 */
	public function onError(error:ConnectionError):Void{
		myOut.error(error);
	}
	
	public function onResponse(response:ConnectionResponse):Void{
		myOut.info(response)
	}
}