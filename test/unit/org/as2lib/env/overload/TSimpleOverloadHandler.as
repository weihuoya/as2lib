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
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.env.overload.OverloadHandler;
import org.as2lib.core.BasicInterface;
import org.as2lib.core.BasicClass;
import org.as2lib.env.overload.SubTypeOfBasicClass;
import org.as2lib.env.overload.SubTypeOfBasicInterface;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.overload.TSimpleOverloadHandler extends TestCase {
	
	private function getBasicInterface(Void):BasicInterface {
		var result = new Object();
		result.__proto__ = BasicInterface["prototype"];
		return result;
	}
	
	private function getOverloadHandler(Void):OverloadHandler {
		var result = new Object();
		result.__proto__ = OverloadHandler["prototype"];
		return result;
	}
	
	public function testNewWithNullValues(Void):Void {
		try {
			var o = new SimpleOverloadHandler([], null);
			fail("Constructor should have thrown an IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			var o = new SimpleOverloadHandler(null, function() {});
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
			fail("Constructor should not have thrown an IllegalArgumentException.");
		}
	}
	
	public function testMatchesWithNullArgument(Void):Void {
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([], function() {});
		assertTrue("A value of null should be interpreted as an empty array.", h.matches(null));
		
		h = new SimpleOverloadHandler([String], function() {});
		assertFalse("Null should be interpreted as an empty array, that means that the two arrays are completely different.", h.matches(null));
	}
	
	public function testMatchesForPrimitiveTypes(Void):Void {
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([String, Number, Boolean, MovieClip, Function], function() {});
		assertTrue("1_0", h.matches(["string", 43, true, _root.createEmptyMovieClip("testMatchesForPrimitiveTypes_mc", _root.getNextHighestDepth()), function() {}]));
		
		h = new SimpleOverloadHandler([String], function() {});
		assertTrue("2_0", h.matches(["muh"]));
		assertFalse("2_1", h.matches([4]));
		assertFalse("2_2", h.matches([true]));
		assertFalse("2_3", h.matches([new Object()]));
		assertFalse("2_4", h.matches([Object]));
		assertTrue("2_5", h.matches([null]));
		assertTrue("2_6", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([Number], function() {});
		assertTrue("3_0", h.matches([43]));
		assertFalse("3_1", h.matches(["test"]));
		assertFalse("3_2", h.matches([true]));
		assertFalse("3_2", h.matches([new Object()]));
		assertFalse("3_4", h.matches([Object]));
		assertTrue("3_5", h.matches([null]));
		assertTrue("3_6", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([Boolean], function() {});
		assertTrue("4_0", h.matches([true]));
		assertTrue("4_1", h.matches([false]));
		assertFalse("4_2", h.matches([1]));
		assertFalse("4_3", h.matches([0]));
		assertFalse("4_4", h.matches(["test"]));
		assertFalse("4_5", h.matches([Object]));
		assertFalse("4_6", h.matches([new Object()]));
		assertTrue("4_7", h.matches([null]));
		assertTrue("4_8", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([Function], function() {});
		assertTrue("5_0", h.matches([function() {}]));
		assertTrue("5_1", h.matches([new Function()]));
		assertFalse("5_2", h.matches(["test"]));
		assertFalse("5_3", h.matches([true]));
		assertFalse("5_4", h.matches([new Object()]));
		assertTrue("5_5", h.matches([Object]));
		assertFalse("5_6", h.matches([4]));
		assertTrue("5_7", h.matches([null]));
		assertTrue("5_8", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([MovieClip], function() {});
		assertTrue("6_0", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertTrue("6_1", h.matches([new MovieClip()]));
		assertFalse("6_2", h.matches(["test"]));
		assertFalse("6_3", h.matches([true]));
		assertFalse("6_4", h.matches([new Object()]));
		assertFalse("6_5", h.matches([Object]));
		assertFalse("6_6", h.matches([4]));
		assertTrue("6_7", h.matches([null]));
		assertTrue("6_8", h.matches([undefined]));
		
		_root.testMatchesForPrimitiveTypes_mc.removeMovieClip();
	}
	
	public function testMatchesForComplexTypes(Void):Void {
		_root.createEmptyMovieClip("testMatchesForPrimitiveTypes_mc", _root.getNextHighestDepth());
		
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([Object, BasicInterface, BasicClass, Array], function() {});
		assertTrue("1_0", h.matches([new BasicClass(), getBasicInterface(), new BasicClass(), new Array()]));
		
		h = new SimpleOverloadHandler([Object], function() {});
		assertTrue("2_0", h.matches([new Object()]));
		assertTrue("2_1", h.matches([new BasicClass()]));
		assertTrue("2_2", h.matches([getBasicInterface()]));
		assertTrue("2_3", h.matches(["test"]));
		assertTrue("2_4", h.matches([3]));
		assertTrue("2_5", h.matches([false]));
		assertTrue("2_6", h.matches([Function]));
		assertTrue("2_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertTrue("2_8", h.matches([null]));
		assertTrue("2_9", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([BasicClass], function() {});
		assertTrue("3_0", h.matches([new BasicClass()]));
		assertTrue("3_1", h.matches([new SubTypeOfBasicClass()]));
		assertFalse("3_2", h.matches([getBasicInterface()]));
		assertFalse("3_3", h.matches(["test"]));
		assertFalse("3_4", h.matches([3]));
		assertFalse("3_5", h.matches([false]));
		assertFalse("3_6", h.matches([Function]));
		assertFalse("3_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertTrue("3_8", h.matches([null]));
		assertTrue("3_9", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([BasicInterface], function() {});
		assertTrue("4_0", h.matches([new BasicClass()]));
		assertTrue("4_1", h.matches([new SimpleOverloadHandler([], function() {})]));
		assertTrue("4_2", h.matches([getBasicInterface()]));
		assertTrue("4_3", h.matches([getOverloadHandler()]));
		assertFalse("4_4", h.matches([3]));
		assertFalse("4_5", h.matches([false]));
		assertFalse("4_6", h.matches([Function]));
		assertFalse("4_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertFalse("4_8", h.matches(["test"]));
		assertTrue("4_9", h.matches([null]));
		assertTrue("4_10", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([Array], function() {});
		assertTrue("5_0", h.matches([new Array()]));
		assertTrue("5_1", h.matches([["Position 0", "Position 1"]]));
		assertFalse("5_2", h.matches([getBasicInterface()]));
		assertFalse("5_3", h.matches([getOverloadHandler()]));
		assertFalse("5_4", h.matches([3]));
		assertFalse("5_5", h.matches([false]));
		assertFalse("5_6", h.matches([Function]));
		assertFalse("5_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertFalse("5_8", h.matches(["test"]));
		assertFalse("5_9", h.matches([new Object()]));
		assertTrue("5_10", h.matches([null]));
		assertTrue("5_11", h.matches([undefined]));
		
		_root.testMatchesForPrimitiveTypes_mc.removeMovieClip();
	}
	
	public function testIsMoreExplicitWithNullArgument(Void):Void {
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([], function() {});
		assertTrue("If the passed in overload handler is null this overload handler is supposed to be more explicit.", h.isMoreExplicit(null));
	}
	
	public function testIsMoreExplicitWithNullReturningGetArgumentsMethod(Void):Void {
		var hc:MockControl = new MockControl(OverloadHandler);
		var mh:OverloadHandler = hc.getMock();
		mh.getArgumentsTypes();
		hc.setReturnValue(null, 2);
		hc.replay();
		
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([], function() {});
		assertNull("Arguments with value null should be interpreted as blank array.", h.isMoreExplicit(mh));
		
		h = new SimpleOverloadHandler([String], function() {});
		assertTrue("isMoreExplicit should return true if the lengths of the arguments do not match.", h.isMoreExplicit(mh));
		
		hc.verify();
	}
	
	public function testIsMoreExplicit(Void):Void {
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([Boolean, Number, String, Object, SubTypeOfBasicInterface, SubTypeOfBasicClass], function() {});
		assertTrue("1", h.isMoreExplicit(new SimpleOverloadHandler([Boolean, Number, String, Object, BasicInterface, BasicClass], function() {})));
		
		h = new SimpleOverloadHandler([Boolean], function() {});
		assertNull("2_0", h.isMoreExplicit(new SimpleOverloadHandler([Boolean], function() {})));
		assertTrue("2_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var BooleanSubClass:Function = function() {};
		BooleanSubClass.prototype = new Boolean();
		assertFalse("2_2", h.isMoreExplicit(new SimpleOverloadHandler([BooleanSubClass], function() {})));
		
		h = new SimpleOverloadHandler([Number], function() {});
		assertNull("3_0", h.isMoreExplicit(new SimpleOverloadHandler([Number], function() {})));
		assertTrue("3_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var NumberSubClass:Function = function() {};
		NumberSubClass.prototype = new Number();
		assertFalse("3_2", h.isMoreExplicit(new SimpleOverloadHandler([NumberSubClass], function() {})));
		
		h = new SimpleOverloadHandler([String], function() {});
		assertNull("4_0", h.isMoreExplicit(new SimpleOverloadHandler([String], function() {})));
		assertTrue("4_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var StringSubClass:Function = function() {};
		StringSubClass.prototype = new String();
		assertFalse("4_2", h.isMoreExplicit(new SimpleOverloadHandler([StringSubClass], function() {})));
		
		h = new SimpleOverloadHandler([Object], function() {});
		assertNull("5_0", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertTrue("5_1", h.isMoreExplicit(new SimpleOverloadHandler([null], function() {})));
		assertTrue("5_2", h.isMoreExplicit(new SimpleOverloadHandler([undefined], function() {})));
		assertFalse("5_3", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {})));
		assertFalse("5_4", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicClass], function() {})));
		assertFalse("5_5", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		
		h = new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {});
		assertNull("6_0", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {})));
		assertTrue("6_1", h.isMoreExplicit(new SimpleOverloadHandler([null], function() {})));
		assertTrue("6_2", h.isMoreExplicit(new SimpleOverloadHandler([undefined], function() {})));
		assertTrue("6_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertTrue("6_4", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		
		h = new SimpleOverloadHandler([BasicInterface], function() {});
		assertNull("7_0", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertFalse("7_1", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicClass], function() {})));
		assertTrue("7_2", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertFalse("7_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertFalse("7_3", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {})));
		
		h = new SimpleOverloadHandler([SubTypeOfBasicClass], function() {});
		assertNull("8_0", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicClass], function() {})));
		assertTrue("8_1", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertTrue("8_2", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertTrue("8_3", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {})));
		assertTrue("8_4", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		
		h = new SimpleOverloadHandler([BasicClass], function() {});
		assertNull("9_0", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertTrue("9_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertFalse("9_2", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicClass], function() {})));
		assertTrue("9_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertFalse("9_4", h.isMoreExplicit(new SimpleOverloadHandler([SubTypeOfBasicInterface], function() {})));
	}
	
}