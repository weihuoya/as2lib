﻿/*
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
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.data.holder.Stack;
import org.as2lib.env.except.Throwable;
import org.as2lib.env.except.StackTraceElementFactory;
import org.as2lib.env.except.SimpleStackTraceElementFactory;
import org.as2lib.env.except.StackTraceElement;
import org.as2lib.env.except.ExceptConfig;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.except.TAbstractThrowable extends TestCase {
	
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	public function TAbstractThrowable(Void) {
	}
	
	public function tearDown(Void):Void {
		ExceptConfig.setStackTraceElementFactory(new SimpleStackTraceElementFactory());
	}
	
	public function getThrowable(message:String, thrower, args:FunctionArguments):Throwable {
		throw new Error("Abstract method that should be overwritten.");
		return null;
	}
	
	public function testNewWithNullArguments(Void):Void {
		var e:StackTraceElement = new StackTraceElement();
		
		var stefControl:MockControl = new MockControl(StackTraceElementFactory);
		var stef:StackTraceElementFactory = stefControl.getMock();
		stef.getStackTraceElement(null, undefined, null);
		stefControl.setReturnValue(e);
		stefControl.replay();
		
		ExceptConfig.setStackTraceElementFactory(stef);
		
		var t:Throwable = getThrowable(null, null, null);
		assertNull(t.getMessage());
		assertSame(t.getStackTrace().pop(), e);
		
		stefControl.verify();
	}
	
	public function testNewWithRealArguments(Void):Void {
		var h:Object = new Object();
		var e:StackTraceElement = new StackTraceElement();
		
		var stefControl:MockControl = new MockControl(StackTraceElementFactory);
		var stef:StackTraceElementFactory = stefControl.getMock();
		stef.getStackTraceElement(h, arguments.callee, arguments);
		stefControl.setReturnValue(e);
		stefControl.replay();
		
		ExceptConfig.setStackTraceElementFactory(stef);
		
		var t:Throwable = getThrowable("message", h, arguments);
		assertSame(t.getMessage(), "message");
		assertSame(t.getStackTrace().pop(), e);
		
		stefControl.verify();
	}
	
	public function testInitCauseWithNullArgument(Void):Void {
		ExceptConfig.setStackTraceElementFactory(new SimpleStackTraceElementFactory());
		
		var t:Throwable = getThrowable("message", this, arguments);
		try {
			t.initCause(null);
			fail("Expected IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testInitCauseViaGetCause(Void):Void {
		var stefControl:MockControl = new MockControl(StackTraceElementFactory);
		var stef:StackTraceElementFactory = stefControl.getMock();
		stef.getStackTraceElement(this, arguments.callee, arguments);
		stefControl.setReturnValue(new StackTraceElement());
		stefControl.replay();
		
		ExceptConfig.setStackTraceElementFactory(stef);
		
		var c1:Throwable = new Throwable();
		var c2:Throwable = new Throwable();
		
		var t:Throwable = getThrowable("message", this, arguments);
		assertSame(t.initCause(c1), t);
		assertSame(t.getCause(), c1);
		try {
			t.initCause(c2);
			fail("Expected IllegalStateException.");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
		assertSame(t.getCause(), c1);
		
		stefControl.verify();
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
		
		var stefControl:MockControl = new MockControl(StackTraceElementFactory);
		var stef:StackTraceElementFactory = stefControl.getMock();
		stef.getStackTraceElement(h0, arguments.callee, arguments);
		stefControl.setReturnValue(e0);
		stef.getStackTraceElement(h1, f1, a1);
		stefControl.setReturnValue(e1);
		stef.getStackTraceElement(h2, f2, a2);
		stefControl.setReturnValue(e2);
		stefControl.replay();
		
		ExceptConfig.setStackTraceElementFactory(stef);
		
		var t:Throwable = getThrowable("message", h0, arguments);
		t.addStackTraceElement(h1, f1, a1);
		t.addStackTraceElement(h2, f2, a2);
		var s:Stack = t.getStackTrace();
		assertSame(s.pop(), e2);
		assertSame(s.pop(), e1);
		assertSame(s.pop(), e0);
		
		stefControl.verify();
	}
	
}