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
	
	public function getThrowable(message:String, thrower, args:Array):Throwable {
		throw new Error("Abstract method that should be overwritten.");
		return null;
	}
	
	public function testNewWithNullArguments(Void):Void {
		var t:Throwable = getThrowable(null, null, null);
		assertNull(t.getMessage());
		
		var e:StackTraceElement = StackTraceElement(t.getStackTrace().pop());
		assertNull(e.getMethod());
		assertNull(e.getThrower());
		assertEmpty(e.getArguments());
	}
	
	public function testNewWithRealArguments(Void):Void {
		var a:Array = ["arg1", 2, true, new Object()];
		a.callee = function() {};
		var h:Object = new Object();
		var t:Throwable = getThrowable("message", h, a);
		assertSame(t.getMessage(), "message");
		var e:StackTraceElement = StackTraceElement(t.getStackTrace().pop());
		assertSame(e.getMethod(), a.callee);
		assertSame(e.getThrower(), h);
		var args:Array = e.getArguments();
		assertSame("length is different", a.length, args.length);
		for (var i:Number = 0; i < a.length; i++) {
			assertSame("element '" + i + "' is not the same", a[i], args[i]);
		}
	}
	
	public function testInitCauseWithNullArgument(Void):Void {
		var t:Throwable = getThrowable("message", this, arguments);
		assertThrows(IllegalArgumentException, t, "initCause", [null]);
	}
	
	public function testInitCauseViaGetCause(Void):Void {
		var c1:Throwable = getThrowable();
		var c2:Throwable = getThrowable();
		
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
		var args:Array;

		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h0);
		assertSame(e.getMethod(), arguments.callee);
		args = e.getArguments();
		assertSame("length is different", arguments.length, args.length);
		for (var i:Number = 0; i < arguments.length; i++) {
			assertSame("element '" + i + "' is not the same", arguments[i], args[i]);
		}
		
		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h1);
		assertSame(e.getMethod(), f1);
		args = e.getArguments();
		assertSame("length is different", a1.length, args.length);
		for (var i:Number = 0; i < a1.length; i++) {
			assertSame("element '" + i + "' is not the same", a1[i], args[i]);
		}

		e = StackTraceElement(s.shift());
		assertSame(e.getThrower(), h2);
		assertSame(e.getMethod(), f2);
		args = e.getArguments();
		assertSame("length is different", a2.length, args.length);
		for (var i:Number = 0; i < a2.length; i++) {
			assertSame("element '" + i + "' is not the same", a2[i], args[i]);
		}
	}
	
}