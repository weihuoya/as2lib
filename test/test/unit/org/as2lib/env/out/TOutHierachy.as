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
import org.as2lib.env.out.Out;
import org.as2lib.env.out.OutHierachy;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.out.TOutHierachy extends TestCase {
	
	public function testGetOutByName(Void):Void {
		var root:Out = new Out("root");
		var repository:OutHierachy = new OutHierachy(root);
		
		var out1:Out = repository.getOut("test.unit.org.as2lib.env.out");
		assertNotNull(out1);
		assertNotUndefined(out1);
		assertSame("out1's parent must be root", out1.getParent(), root);
		
		var out2:Out = repository.getOut("test.unit.org.as2lib.env.out.Test");
		assertNotNull(out2);
		assertNotUndefined(out2);
		assertSame("out2's parent must be out1", out2.getParent(), out1);
		
		var out4:Out = repository.getOut("test.unit.org.as2lib.core.Test");
		assertNotNull(out4);
		assertNotUndefined(out4);
		assertSame("out4's parent must be root", out4.getParent(), root);
		
		var out3:Out = repository.getOut("test.unit.org.as2lib");
		assertNotNull(out3);
		assertNotUndefined(out3);
		assertSame("out3's parent must be root", out3.getParent(), root);
		assertSame("out1's parent must be out3", out1.getParent(), out3);
		assertSame("out4's parent must be out3", out4.getParent(), out3);
		assertSame("out2's parent must still be out1", out2.getParent(), out1);
	}
	
	public function testGetRootOut(Void):Void {
		var root:Out = new Out("root");
		var repository:OutHierachy = new OutHierachy(root);
		assertSame("repository.getRootOut() and root must be the same", repository.getRootOut(), root);
	}
	
}