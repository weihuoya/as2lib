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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.algorithm.ChildAlgorithm;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TPackageInfo_Class extends TestCase {
	
	public function testGetChildClassesWithNullChildren(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildClasses());
	}
	
	public function testGetChildClassesWithChildrenOfTypeClassInfoAndPackageInfo(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var ac:MockControl = new MockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		var children:Array = i.getChildClasses();
		assertSame(children.length, 3);
		assertSame(children[0], c1);
		assertSame(children[1], c2);
		assertSame(children[2], c3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetChildClassByNameWithNullName(Void):Void {
		var ac:MockControl = new MockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildClassByName(null));
		assertNull(i.getChildClassByName(undefined));
		
		ac.verify();
	}
	
	public function testGetChildClassByNameWithNullChildClasses(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildClassByName("class"));
	}
	
	public function testGetChildClassByNameWithKnownChildClasses(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getName();
		c1c.setDefaultReturnValue("class1");
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getName();
		c2c.setDefaultReturnValue("class2");
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getName();
		c3c.setDefaultReturnValue("class3");
		c3c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var ac:MockControl = new MockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildClassByName("class1"), c1);
		assertSame(i.getChildClassByName("class2"), c2);
		assertSame(i.getChildClassByName("class3"), c3);
		assertNull(i.getChildClassByName("package1"));
		assertNull(i.getChildClassByName("package2"));
		assertNull(i.getChildClassByName("package3"));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetChildClassByClassWithNullAndUndefinedArgument(Void):Void {
		var ac:MockControl = new MockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildClassByClass(null));
		assertNull(i.getChildClassByClass(undefined));
		
		ac.verify();
	}
	
	public function testGetChildClassByClassWithNullChildClasses(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildClassByClass(Object));
	}
	
	public function testGetChildClassByClassWithRealValues(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getType();
		c2c.setDefaultReturnValue(T2);
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getType();
		c3c.setDefaultReturnValue(T3);
		c3c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getPackage();
		p1c.setDefaultReturnValue(cp1);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3c.replay();
		
		var ac:MockControl = new MockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildClassByClass(T1), c1);
		assertSame(i.getChildClassByClass(T2), c2);
		assertSame(i.getChildClassByClass(T3), c3);
		assertNull(i.getChildClassByClass(function() {}));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
}