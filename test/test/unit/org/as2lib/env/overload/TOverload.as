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
import org.as2lib.test.mock.MockControl;
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.overload.Overload;
import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.env.overload.UnknownOverloadHandlerException;
import org.as2lib.env.overload.SameTypeSignatureException;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.overload.TOverload extends TestCase {
	
	public function testAddHandlerForOverloadability(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = new OverloadHandler();
		o.addHandler(oh);
		assertNotThrows(o, "removeHandler", [oh]);
	}
	
	public function testAddHandlerByValueViaRemoveHandler(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = o.addHandler([], new Function());
		assertNotEmpty("The received OverloadHandler [" + oh + "] is empty.", oh);
		assertTrue("The received instance [" + oh + "] is not of type OverloadHandler.", oh instanceof OverloadHandler);
		assertNotThrows(o, "removeHandler", [oh]);
	}
	
	public function testRemoveHandlerViaAddHandler(Void):Void {
		var o:Overload = new Overload(this);
		var oh:OverloadHandler = o.addHandler([], new Function());
		assertNotThrows(o, "removeHandler", [oh]);
		// Why gets the exception not thrown?
		//assertThrows(IllegalArgumentException, o, "removeHandler", [new OverloadHandler()]);
	}
	
	public function testForwardWithMultipleOverloadHandlers(Void):Void {
		var args:Array = [new Object(), "arg2", 3];
		
		var hc1:MockControl = new SimpleMockControl(OverloadHandler);
		var h1:OverloadHandler = hc1.getMock();
		h1.isMoreExplicit();
		hc1.setReturnValue(false);
		h1.matches(args);
		hc1.setReturnValue(true);
		hc1.replay();
		
		var hc2:MockControl = new SimpleMockControl(OverloadHandler);
		var h2:OverloadHandler = hc2.getMock();
		h2.matches(args);
		hc2.setReturnValue(false);
		hc2.replay();
		
		var hc3:MockControl = new SimpleMockControl(OverloadHandler);
		var h3:OverloadHandler = hc3.getMock();
		h3.isMoreExplicit();
		hc3.setReturnValue(true);
		h3.matches(args);
		hc3.setReturnValue(true);
		h3.getMethod();
		hc3.setReturnValue(function() {});
		hc3.replay();
		
		var hc4:MockControl = new SimpleMockControl(OverloadHandler);
		var h4:OverloadHandler = hc4.getMock();
		h4.matches(args);
		hc4.setReturnValue(true);
		hc4.replay();
		
		var o:Overload = new Overload(null);
		o.addHandler(h1);
		o.addHandler(h2);
		o.addHandler(h3);
		o.addHandler(h4);
		o.forward(args);
		
		hc1.verify(this);
		hc2.verify(this);
		hc3.verify(this);
		hc4.verify(this);
	}
	
	public function testForwardWithNoMatchingOverloadHandler(Void):Void {
		var args:Array = [new Object(), "arg2", 3];
		
		var hc1:MockControl = new SimpleMockControl(OverloadHandler);
		var h1:OverloadHandler = hc1.getMock();
		h1.matches(args);
		hc1.setReturnValue(false);
		hc1.replay();
		
		var hc2:MockControl = new SimpleMockControl(OverloadHandler);
		var h2:OverloadHandler = hc2.getMock();
		h2.matches(args);
		hc2.setReturnValue(false);
		hc2.replay();
		
		var o:Overload = new Overload(null);
		o.addHandler(h1);
		o.addHandler(h2);
		assertThrows(UnknownOverloadHandlerException, o, o.forward, [args]);
		
		hc1.verify(this);
		hc2.verify(this);
	}
	
	public function testForwardWithTwoOverloadHandlersWithTheSameTypeSignature(Void):Void {
		var args:Array = [new Object(), "arg2", 3];
		
		var hc1:MockControl = new SimpleMockControl(OverloadHandler);
		var h1:OverloadHandler = hc1.getMock();
		h1.isMoreExplicit();
		hc1.setReturnValue(null);
		h1.matches(args);
		hc1.setReturnValue(true);
		hc1.replay();
		
		var hc3:MockControl = new SimpleMockControl(OverloadHandler);
		var h3:OverloadHandler = hc3.getMock();
		h3.isMoreExplicit();
		hc3.setReturnValue(null);
		h3.matches(args);
		hc3.setReturnValue(true);
		hc3.replay();
		
		var o:Overload = new Overload(null);
		o.addHandler(h1);
		o.addHandler(h3);
		assertThrows(SameTypeSignatureException, o, o.forward, [args]);
		
		hc1.verify(this);
		hc3.verify(this);
	}
	
	/*public function testForward(Void):Void {
		var o:Overload = new Overload(this);
		o.addHandler([String, Object], firstMethod);
		o.addHandler([Object, String], secondMethod);
		var number:Number = Number(o.forward(["string", new Object()]));
		assertTrue("The returned number [" + number + "] does not have the correct value [0].", (number == 0));
		assertThrows(SameTypeSignatureException, o, "forward", [[new String("firstString"), new String("secondString")]]);
		assertThrows(UnknownOverloadHandlerException, o, "forward", [[0, 0]]);
	}
	
	private function firstMethod(string:String, object:Object):Number {
		assertTrue("The passed in parameter string [" + string + "] does not have the correct value [string].", (string == "string"));
		assertTrue("The passed in parameter object [" + object + "] is not of type Object.", ObjectUtil.isInstanceOf(object, Object));
		return 0;
	}
	
	private function secondMethod(Void):Void {
		fail("The wrong method is being executed.");
	}*/
	
}