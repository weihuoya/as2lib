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
import org.as2lib.test.mock.MethodResponse;

/**
 * @author Simon Wacker
 */
class org.as2lib.test.mock.TMethodResponse extends TestCase {
	
	public function testResponseWithNoDefinedResponse(Void):Void {
		var r:MethodResponse = new MethodResponse();
		assertUndefined(r.response());
	}
	
	public function testResponseWithDefinedReturnValue(Void):Void {
		var v:Object = new Object();
		var r:MethodResponse = new MethodResponse();
		r.setReturnValue(v);
		assertSame(r.response(), v);
	}
	
	public function testResponseWithNullReturnValue(Void):Void {
		var r:MethodResponse = new MethodResponse();
		r.setReturnValue(null);
		assertNull(r.response());
	}
	
	public function testResponseWithDefinedThrowable(Void):Void {
		var t:Object = new Object();
		var r:MethodResponse = new MethodResponse();
		r.setThrowable(t);
		try {
			r.response();
			fail("exception should be thrown");
		} catch (e) {
			assertSame(e, t);
		}
	}
	
	public function testResponseWithNullThrowable(Void):Void {
		var r:MethodResponse = new MethodResponse();
		r.setThrowable(null);
		try {
			r.response();
			fail("exception should be thrown");
		} catch (e) {
			assertNull(e);
		}
	}
	
	public function testResponseWithBothReturnValueAndThrowableSet(Void):Void {
		var v:Object = new Object();
		var t:Object = new Object();
		var r:MethodResponse = new MethodResponse();
		r.setThrowable(t);
		r.setReturnValue(v);
		assertSame(r.response(), v);
		r.setThrowable(t);
		try {
			r.response();
			fail("exception should be thrown");
		} catch (e) {
			assertSame(e, t);
		}
	}
	
}