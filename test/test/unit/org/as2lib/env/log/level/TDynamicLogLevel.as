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
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.DynamicLogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.log.level.TDynamicLogLevel extends TestCase {
	
	public function testNewWithNullLevel(Void):Void {
		try {
			new DynamicLogLevel(null, "name");
			fail("level of value null should cause IllegalArgumentException to be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithNullName(Void):Void {
		var l:DynamicLogLevel = new DynamicLogLevel(2, null);
		assertNull(l.toString());
	}
	
	public function testIsGreaterOrEqualWithNullLevel(Void):Void {
		var l:DynamicLogLevel = new DynamicLogLevel(2, "name");
		assertTrue(l.isGreaterOrEqual(null));
	}
	
	public function testIsGreaterOrEqualWithNullReturningGetLevelMethod(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(null);
		ac.replay();
		
		var l:DynamicLogLevel = new DynamicLogLevel(2, "name");
		assertTrue(l.isGreaterOrEqual(a));
		
		ac.verify(this);
	}
	
	public function testIGreaterOfEqualWithEqualLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(2);
		ac.replay();
		
		var l:DynamicLogLevel = new DynamicLogLevel(2, "name");
		assertTrue(l.isGreaterOrEqual(a));
		
		ac.verify(this);
	}
	
	public function testIsGreaterOrEqualWithGreaterLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(44);
		ac.replay();

		var l:DynamicLogLevel = new DynamicLogLevel(2, "name");
		assertFalse(l.isGreaterOrEqual(a));
		
		ac.verify(this);
	}
	
	public function testIGreaterOfEqualWithSmallerLevel(Void):Void {
		var ac:MockControl = new MockControl(LogLevel);
		var a:LogLevel = ac.getMock();
		a.toNumber();
		ac.setReturnValue(1);
		ac.replay();
		
		var l:DynamicLogLevel = new DynamicLogLevel(2, "name");
		assertTrue(l.isGreaterOrEqual(a));
		
		ac.verify(this);
	}
	
}