/**
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
import org.as2lib.test.mock.ArgumentsMatcher;
import org.as2lib.test.mock.support.DefaultArgumentsMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.support.TDefaultArgumentsMatcher extends TestCase {
	
	private function getMatcher(Void):ArgumentsMatcher {
		return new DefaultArgumentsMatcher();
	}
	
	public function testSimpleArguments(Void):Void {
		var matcher:ArgumentsMatcher = getMatcher();
		var o:Object = new Object();
		var args1:Array = ["arg1", 2, o];
		var args2:Array = ["arg1", 2, o];
		assertTrue(matcher.matchArguments(args1, args2));
		var args3:Array = ["arg3", 2, o];
		assertFalse(matcher.matchArguments(args1, args3));
	}
	
	public function testDifferentLengthsArguments(Void):Void {
		var matcher:ArgumentsMatcher = getMatcher();
		var o:Object = new Object();
		var args1:Array = ["arg1", 2, o];
		var args2:Array = ["arg1", 2];
		assertFalse(matcher.matchArguments(args1, args2));
	}
	
	public function testNestedArrayArguments(Void):Void {
		var matcher:ArgumentsMatcher = getMatcher();
		var args1:Array = [["arg1", 1], 2, [["3_1", "3_2", "3_3"]]];
		var args2:Array = [["arg1", 1], 2, [["3_1", "3_2", "3_3"]]];
		assertTrue(matcher.matchArguments(args1, args2));
	}
	
}