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
import org.as2lib.test.mock.support.RecordState;
import org.as2lib.test.mock.Behaviour;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TRecordState extends TestCase {
	
	public function testNewWithNullArgument(Void):Void {
		try {
			var s:RecordState = new RecordState(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
	}
	
	public function testNewWithRealArgument(Void):Void {
		var s:RecordState = new RecordState(new Behaviour());
	}
	
	public function testVerify(Void):Void {
		var s:RecordState = new RecordState(new Behaviour());
		try {
			s.verify(null);
			fail("exception should be thrown");
		} catch (e:org.as2lib.env.except.IllegalStateException) {
		}
	}
	
}