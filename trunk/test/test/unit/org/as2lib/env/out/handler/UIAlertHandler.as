import org.as2lib.env.event.EventInfo;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutInfo;
import org.as2lib.env.out.OutConfig;
import org.as2lib.core.BasicClass;
import mx.controls.Alert;

/** 
  * Macromedia Alert Component has to be in the library and you have to posess Flash MX 2004 Professional to 
  *  be able to use the Alert class;
  * @author Christoph Atteneder
 */
class test.unit.org.as2lib.env.out.handler.UIAlertHandler extends BasicClass implements OutHandler {

	/**
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function write(info:OutInfo):Void {
		Alert.show(info.getMessage(), getClass().getName());
	}
	
	/**
	 * @see org.as2lib.env.out.OutHandler
	 */
	public function error(info:OutInfo):Void {
		Alert.show(info.getMessage(), getClass().getName());
	}
}