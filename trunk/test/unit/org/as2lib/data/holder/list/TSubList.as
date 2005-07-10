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

import org.as2lib.test.mock.MockControl;
import org.as2lib.data.holder.List;
import org.as2lib.data.holder.list.SubList;
import org.as2lib.data.holder.AbstractTList;
import org.as2lib.data.holder.list.ArrayList;

/**
 * @author Simon Wacker
 */
class org.as2lib.data.holder.list.TSubList extends AbstractTList {
	
	private function createNewList(Void):List {
		var l:ArrayList = new ArrayList();
		l.insert("x");
		l.insert("y");
		l.insert("z");
		l.insert("X");
		l.insert("Y");
		l.insert("Z");
		return new SubList(l, 2, 2);
	}
	
	public function testNewWithNullList(Void):Void {
		try {
			var s:SubList = new SubList(null, 1, 3);
			fail("IllegalArgumentException was expected");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {	
		}
	}
	
	public function testNewWithFromIndexAndToIndexEqualToZero(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		m.size();
		c.setReturnValue(2);
		c.replay();
		var s:SubList = new SubList(m, 0, 0);
		c.verify();
	}
	
	public function testNewWithFromIndexLessThanZero(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		c.replay();
		try {
			var s:SubList = new SubList(m, -1, 3);
			fail("IndexOutOfBoundsException was expected");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {	
		}
		c.verify();
	}
	
	public function testNewWithFromIndexGreaterThanToIndex(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		m.size();
		c.setReturnValue(3);
		c.replay();
		try {
			var s:SubList = new SubList(m, 8, 3);
			fail("IndexOutOfBoundsException was expected");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {	
		}
		c.verify();
	}
	
	public function testSizeWithFromIndexAndToIndexEqualToZero(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		m.size();
		c.setReturnValue(0);
		c.replay();
		var s:SubList = new SubList(m, 0, 0);
		assertSame(s.size(), 0);
		c.verify();
	}
	
	public function testSizeWithFromIndexEqualToToIndex(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		m.size();
		c.setReturnValue(5);
		c.replay();
		var s:SubList = new SubList(m, 3, 3);
		assertSame(s.size(), 0);
		c.verify();
	}
	
	public function testSizeWithDifferentValuesForFromIndexAndToIndex(Void):Void {
		var c:MockControl = new MockControl(List);
		var m:List = c.getMock();
		m.size();
		c.setReturnValue(5);
		c.replay();
		var s:SubList = new SubList(m, 1, 3);
		assertSame(s.size(), 2);
		c.verify();
	}
	
}