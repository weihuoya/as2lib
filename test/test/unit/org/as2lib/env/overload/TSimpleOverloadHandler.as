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
import org.as2lib.env.overload.SimpleOverloadHandler;
import org.as2lib.core.BasicInterface;
import org.as2lib.core.BasicClass;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.overload.TSimpleOverloadHandler extends TestCase {
	
	public function testNewWithNullValues(Void):Void {
		try {
			new SimpleOverloadHandler([], null);
			fail("Constructor should have thrown an IllegalArgumentException.");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			new SimpleOverloadHandler(null, function() {});
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
			fail("Constructor should not have thrown an IllegalArgumentException.");
		}
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
		_root.createEmptyMovieClip("testMatchesForPrimitiveTypes_mc", _root.getNextHighestDepth())
		
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([Object, BasicInterface, BasicClass, Array], function() {});
		assertTrue("1_0", h.matches([new BasicClass(), new BasicInterface(), new BasicClass(), new Array()]));
		
		h = new SimpleOverloadHandler([Object], function() {});
		assertTrue("2_0", h.matches([new Object()]));
		assertTrue("2_1", h.matches([new BasicClass()]));
		assertTrue("2_2", h.matches([new BasicInterface()]));
		assertTrue("2_3", h.matches(["test"]));
		assertTrue("2_4", h.matches([3]));
		assertTrue("2_5", h.matches([false]));
		assertTrue("2_6", h.matches([Function]));
		assertTrue("2_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertTrue("2_8", h.matches([null]));
		assertTrue("2_9", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([BasicClass], function() {});
		assertTrue("3_0", h.matches([new BasicClass()]));
		assertTrue("3_1", h.matches([new SimpleMockControl(Object)]));
		assertFalse("3_2", h.matches([new BasicInterface()]));
		assertFalse("3_3", h.matches(["test"]));
		assertFalse("3_4", h.matches([3]));
		assertFalse("3_5", h.matches([false]));
		assertFalse("3_6", h.matches([Function]));
		assertFalse("3_7", h.matches([_root.testMatchesForPrimitiveTypes_mc]));
		assertTrue("3_8", h.matches([null]));
		assertTrue("3_9", h.matches([undefined]));
		
		h = new SimpleOverloadHandler([BasicInterface], function() {});
		assertTrue("4_0", h.matches([new BasicClass()]));
		assertTrue("4_1", h.matches([new SimpleMockControl(Object)]));
		assertTrue("4_2", h.matches([new BasicInterface()]));
		assertTrue("4_3", h.matches([new MockControl()]));
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
		assertFalse("5_2", h.matches([new BasicInterface()]));
		assertFalse("5_3", h.matches([new MockControl()]));
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
	
	public function testIsMoreExplicit(Void):Void {
		var h:SimpleOverloadHandler = new SimpleOverloadHandler([Boolean, Number, String, Object, MockControl, SimpleMockControl], function() {});
		assertTrue("1", h.isMoreExplicit(new SimpleOverloadHandler([Boolean, Number, String, Object, BasicInterface, BasicClass], function() {})));
		
		h = new SimpleOverloadHandler([Boolean], function() {});
		assertNull("2_0", h.isMoreExplicit(new SimpleOverloadHandler([Boolean], function() {})));
		assertTrue("2_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var BooleanSubClass = function() {};
		BooleanSubClass.prototype = new Boolean();
		assertFalse("2_2", h.isMoreExplicit(new SimpleOverloadHandler([BooleanSubClass], function() {})));
		
		h = new SimpleOverloadHandler([Number], function() {});
		assertNull("3_0", h.isMoreExplicit(new SimpleOverloadHandler([Number], function() {})));
		assertTrue("3_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var NumberSubClass = function() {};
		NumberSubClass.prototype = new Number();
		assertFalse("3_2", h.isMoreExplicit(new SimpleOverloadHandler([NumberSubClass], function() {})));
		
		h = new SimpleOverloadHandler([String], function() {});
		assertNull("4_0", h.isMoreExplicit(new SimpleOverloadHandler([String], function() {})));
		assertTrue("4_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		var StringSubClass = function() {};
		StringSubClass.prototype = new String();
		assertFalse("4_2", h.isMoreExplicit(new SimpleOverloadHandler([StringSubClass], function() {})));
		
		h = new SimpleOverloadHandler([Object], function() {});
		assertNull("5_0", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertTrue("5_1", h.isMoreExplicit(new SimpleOverloadHandler([null], function() {})));
		assertTrue("5_2", h.isMoreExplicit(new SimpleOverloadHandler([undefined], function() {})));
		assertFalse("5_3", h.isMoreExplicit(new SimpleOverloadHandler([SimpleMockControl], function() {})));
		assertFalse("5_4", h.isMoreExplicit(new SimpleOverloadHandler([MockControl], function() {})));
		assertFalse("5_5", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		
		h = new SimpleOverloadHandler([MockControl], function() {});
		assertNull("6_0", h.isMoreExplicit(new SimpleOverloadHandler([MockControl], function() {})));
		assertTrue("6_1", h.isMoreExplicit(new SimpleOverloadHandler([null], function() {})));
		assertTrue("6_2", h.isMoreExplicit(new SimpleOverloadHandler([undefined], function() {})));
		assertTrue("6_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertTrue("6_4", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		
		h = new SimpleOverloadHandler([BasicInterface], function() {});
		assertNull("7_0", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertFalse("7_1", h.isMoreExplicit(new SimpleOverloadHandler([MockControl], function() {})));
		assertTrue("7_2", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertFalse("7_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertFalse("7_3", h.isMoreExplicit(new SimpleOverloadHandler([SimpleMockControl], function() {})));
		
		h = new SimpleOverloadHandler([SimpleMockControl], function() {});
		assertNull("8_0", h.isMoreExplicit(new SimpleOverloadHandler([SimpleMockControl], function() {})));
		assertTrue("8_1", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertTrue("8_2", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertTrue("8_3", h.isMoreExplicit(new SimpleOverloadHandler([MockControl], function() {})));
		assertTrue("8_4", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		
		h = new SimpleOverloadHandler([BasicClass], function() {});
		assertNull("9_0", h.isMoreExplicit(new SimpleOverloadHandler([BasicClass], function() {})));
		assertTrue("9_1", h.isMoreExplicit(new SimpleOverloadHandler([Object], function() {})));
		assertFalse("9_2", h.isMoreExplicit(new SimpleOverloadHandler([SimpleMockControl], function() {})));
		assertTrue("9_3", h.isMoreExplicit(new SimpleOverloadHandler([BasicInterface], function() {})));
		assertFalse("9_4", h.isMoreExplicit(new SimpleOverloadHandler([MockControl], function() {})));
	}
	
}