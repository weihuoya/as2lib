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
import org.as2lib.test.mock.MockBehaviour;
import org.as2lib.test.mock.support.DefaultMockBehaviour;
import org.as2lib.test.mock.MethodCallBehaviour;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.test.mock.support.TDefaultMockBehaviour extends TestCase {
	
	private function getBehaviour(Void):MockBehaviour {
		return new DefaultMockBehaviour();
	}
	
	public function testAddMethodCallBehaviour(Void):Void {
		var behaviour:MockBehaviour = getBehaviour();
		var b1:MethodCallBehaviour = behaviour.addMethodCallBehaviour("b1");
		assertNotUndefined(b1);
		assertNotNull(b1);
		assertSame(b1, behaviour.getMethodCallBehaviour("b1"));
	}
	
	public function testGetLastMethodCallBehaviour(Void):Void {
		var behaviour:MockBehaviour = getBehaviour();
		var b1:MethodCallBehaviour = behaviour.addMethodCallBehaviour("b1");
		assertSame(b1, behaviour.getLastMethodCallBehaviour());
		var b2:MethodCallBehaviour = behaviour.addMethodCallBehaviour("b2");
		assertSame(b2, behaviour.getLastMethodCallBehaviour());
	}
	
	public function testRemoveAllBehaviour(Void):Void {
		var behaviour:MockBehaviour = getBehaviour();
		var b1:MethodCallBehaviour = behaviour.addMethodCallBehaviour("b1");
		var b2:MethodCallBehaviour = behaviour.addMethodCallBehaviour("b2");
		behaviour.removeAllBehaviour();
		assertUndefined(behaviour.getMethodCallBehaviour("b1"));
		assertUndefined(behaviour.getMethodCallBehaviour("b2"));
	}
	
}