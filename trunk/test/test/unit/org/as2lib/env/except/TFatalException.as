﻿import org.as2lib.test.unit.TestCase;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.FatalException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.util.ObjectUtil;
import org.as2lib.data.holder.Stack;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.except.TFatalException extends TestCase {
	public function TFatalException(Void) {
	}
	
	public function testGetMessage(Void):Void {
		var e:Throwable = new FatalException("message", this, arguments);
		var m:String = e.getMessage();
		assertEquals("The received message [" + m + "] is not correct.", m , "message");
	}
	
	public function testInitCause(Void):Void {
		var cause:Throwable = new FatalException("cause", this, arguments);
		  var e:Throwable = new FatalException("message", this, arguments);
		assertNotThrows("No IllegalStateException expected.", IllegalStateException, e, "initCause", [cause]);
		assertThrows("IllegalStateException expected", IllegalStateException, e, "initCause", [cause]);
	}
	
	public function testGetCause(Void):Void {
		var cause:Throwable = new FatalException("cause", this, arguments);
		var e:Throwable = new FatalException("message", this, arguments);
		e.initCause(cause);
		var rCause:Throwable = e.getCause();
		assertTrue("The received cause [" + rCause + "] does not match the passed cause [" + cause + "].", (e.getCause() == rCause));
	}
	
	public function testGetStackTrace(Void):Void {
		var e:Throwable = new FatalException("message", this, arguments);
		var s:Stack = e.getStackTrace();
		assertTrue("The stack trace [" + s + "] is not of instance Stack.", ObjectUtil.isInstanceOf(s, Stack));
		assertTrue("The received stack trace is empty.", !s.isEmpty());
	}
}