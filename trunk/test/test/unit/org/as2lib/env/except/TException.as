import org.as2lib.test.unit.TestCase;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Stack;

/**
 * @author Simon Wacker
 */
class test.org.as2lib.env.except.TException extends TestCase {
	public function TException(Void) {
	}
	
	public function testGetMessage(Void):Void {
		var e:Throwable = new Exception("message", this, arguments);
		var m:String = e.getMessage();
		assertTrue("The received message [" + m + "] is not correct.", (m == "message"));
	}
	
	public function testInitCause(Void):Void {
		var cause:Throwable = new Exception("cause", this, arguments);
		var e:Throwable = new Exception("message", this, arguments);
		assertNotThrows(e, "initCause", [cause]);
		assertThrows(IllegalStateException, e, "initCause", [cause]);
	}
	
	public function testGetCause(Void):Void {
		var cause:Throwable = new Exception("cause", this, arguments);
		var e:Throwable = new Exception("message", this, arguments);
		e.initCause(cause);
		var rCause:Throwable = e.getCause();
		assertTrue("The received cause [" + rCause + "] does not match the passed cause [" + cause + "].", (e.getCause() == rCause));
	}
	
	public function testGetStackTrace(Void):Void {
		var e:Throwable = new Exception("message", this, arguments);
		var s:Stack = e.getStackTrace();
		assertTrue("The stack trace [" + s + "] is not of instance Stack.", ObjectUtil.isInstanceOf(s, Stack));
		assertTrue("The received stack trace is empty.", !s.isEmpty());
	}
}