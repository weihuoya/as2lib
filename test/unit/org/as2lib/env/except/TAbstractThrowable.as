/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.test.unit.TestCase;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.StackTraceElement;

/**
 * Basic validation of all 
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
class org.as2lib.env.except.TAbstractThrowable extends TestCase {
	
	/**
	 * Blocks test from beeing collected with the public TestCaseCollector
	 * 
	 * @return true to block collecting
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function getThrowable(message:String, thrower, args:FunctionArguments):Throwable {
		throw new Error("Abstract method that should be overwritten.");
		return null;
	}
	
	public function testNewWithNullArguments(Void):Void {
		var t:Throwable = getThrowable(null, null, null);
		assertNull(t.getMessage());
		
		var e:StackTraceElement = StackTraceElement(t.getStackTrace().pop());
		assertNull(e.getMethod());
		assertNull(e.getThrower());
		assertNull(e.getArguments());
	}
	
	public function testNewWithRealArguments(Void):Void {
		var h:Object = new Object();
		var t:Throwable = getThrowable("message", h, arguments);
		assertSame(t.getMessage(), "message");
		var e:StackTraceElement = StackTraceElement(t.getStackTrace().pop());
		assertSame(e.getMethod(), arguments.callee);
		assertSame(e.getThrower(), h);
		assertSame(e.getArguments(), arguments);
	}
	
	public function testInitCauseWithNullArgument(Void):Void {
		var t:Throwable = getThrowable("message", this, arguments);
		assertThrows(IllegalArgumentException, t, "initCause", [null]);
	}
	
	public function testInitCauseViaGetCause(Void):Void {
		var c1:Throwable = new Throwable();
		var c2:Throwable = new Throwable();
		
		var t:Throwable = getThrowable("message", this, arguments);
		assertSame(t.initCause(c1), t);
		assertSame(t.getCause(), c1);
		assertThrows(IllegalStateException, t, "initCause", [c2]);
		assertSame(t.getCause(), c1);
	}
	
	public function testGetStackTraceElement(Void):Void {
		var h0:Object = new Object();
		
		var h1:Object = new Object();
		var f1:Function = function() {};
		var a1:Array = new Array();
		
		var h2:Object = new Object();
		var f2:Function = function() {};
		var a2:Array = new Array();
		
		var e0:StackTraceElement = new StackTraceElement();
		var e1:StackTraceElement = new StackTraceElement();
		var e2:StackTraceElement = new StackTraceElement();
		
		var t:Throwable = getThrowable("message", h0, arguments);
		t.addStackTraceElement(h1, f1, a1);
		t.addStackTraceElement(h2, f2, a2);
		var s:Array = t.getStackTrace();

		var e:StackTraceElement;

		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h0);
		assertSame(e.getMethod(), arguments.callee);
		assertSame(e.getArguments(), arguments);
		
		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h1);
		assertSame(e.getMethod(), f1);
		assertSame(e.getArguments(), a1);

		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h2);
		assertSame(e.getMethod(), f2);
		assertSame(e.getArguments(), a2);
	}
	
}