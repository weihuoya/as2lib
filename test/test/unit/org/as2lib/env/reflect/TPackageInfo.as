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
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.algorithm.ChildAlgorithm;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.reflect.TPackageInfo extends TestCase {
	
	public function testIsParentPackageWithNullArgument(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(null));
	}
	
	public function testIsParentPackageWithTheSameInstances(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(p));
	}
	
	public function testIsParentPackageWithRootPackageArgument(Void):Void {
		var ppc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.isRoot();
		ppc.setReturnValue(true);
		ppc.replay();
		
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(pp));
		
		ppc.verify(this);
	}
	
	public function testIsParentPackageWithPackageArgumentWhoseGetParentMethodReturnsNull(Void):Void {
		var ppc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.getParent();
		ppc.setReturnValue(null);
		pp.isRoot();
		ppc.setReturnValue(false);
		ppc.replay();
		
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(pp));
		
		ppc.verify(this);
	}
	
	public function testIsParentPackageWithDirectParentPackageMatch(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var ppc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.getParent();
		ppc.setReturnValue(p);
		pp.isRoot();
		ppc.setReturnValue(false);
		ppc.replay();
		
		assertTrue(p.isParentPackage(pp));
		
		ppc.verify(this);
	}
	
	public function testIsParentPackageWithMultipleLevels(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var pp3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp3:PackageInfo = pp3c.getMock();
		pp3.getParent();
		pp3c.setReturnValue(p);
		pp3.isRoot();
		pp3c.setReturnValue(false);
		pp3c.replay();
		
		var pp2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp2:PackageInfo = pp2c.getMock();
		pp2.getParent();
		pp2c.setReturnValue(pp3);
		pp2.isRoot();
		pp2c.setReturnValue(false);
		pp2c.replay();
		
		var pp1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp1:PackageInfo = pp1c.getMock();
		pp1.getParent();
		pp1c.setReturnValue(pp2);
		pp1.isRoot();
		pp1c.setReturnValue(false);
		pp1c.replay();
		
		assertTrue(p.isParentPackage(pp1));
		
		pp1c.verify(this);
		pp2c.verify(this);
		pp3c.verify(this);
	}
	
	public function testIsParentPackageWithMultipleLevelsAndNoMatch(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var pp3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp3:PackageInfo = pp3c.getMock();
		pp3.isRoot();
		pp3c.setReturnValue(true);
		pp3c.replay();
		
		var pp2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp2:PackageInfo = pp2c.getMock();
		pp2.getParent();
		pp2c.setReturnValue(pp3);
		pp2.isRoot();
		pp2c.setReturnValue(false);
		pp2c.replay();
		
		var pp1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var pp1:PackageInfo = pp1c.getMock();
		pp1.getParent();
		pp1c.setReturnValue(pp2);
		pp1.isRoot();
		pp1c.setReturnValue(false);
		pp1c.replay();
		
		assertFalse(p.isParentPackage(pp1));
		
		pp1c.verify(this);
		pp2c.verify(this);
		pp3c.verify(this);
	}
	
	public function testNewWithNullArguments(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertNull(p.getName());
		assertNull(p.getPackage());
		assertNull(p.getParent());
	}
	
	public function testNewWithRealArguments(Void):Void {
		var p:PackageInfo = new PackageInfo();
		var cp:Object = new Object();
		var i:PackageInfo = new PackageInfo("package", cp, p);
		assertSame(i.getName(), "package");
		assertSame(i.getPackage(), cp);
		assertSame(i.getParent(), p);
	}
	
	public function testGetFullNameWithNullName(Void):Void {
		//////////
		// TODO //
		//////////
	}
	
	public function testGetFullNameWithNullParent(Void):Void {
		var i:PackageInfo = new PackageInfo("MyClass", null, null);
		assertSame(i.getFullName(), "MyClass");
	}
	
	public function testGetFullNameWithRootAsParent(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(true);
		rc.replay();
		
		var i:PackageInfo = new PackageInfo("MyClass", null, r);
		assertSame(i.getFullName(), "MyClass");
		
		rc.verify(this);
	}
	
	public function testGetFullNameWithNormalParent(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(false);
		r.getFullName();
		rc.setReturnValue("org.as2lib.mypackage");
		rc.replay();
		
		var i:PackageInfo = new PackageInfo("MyClass", null, r);
		assertSame(i.getFullName(), "org.as2lib.mypackage.MyClass");
		
		rc.verify(this);
	}
	
	public function testGetChildrenWithNullPackage(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildren());
		
		ac.verify(this);
	}
	
	public function testGetChildrenWithRealPackage(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue(["child1", "child2", "child3"]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		var children:Array = i.getChildren();
		assertSame(children.length, 3);
		assertSame(children[0], "child1");
		assertSame(children[1], "child2");
		assertSame(children[2], "child3");
		
		ac.verify(this);
	}
	
	public function testGetChildClassesWithNullChildren(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildClasses());
	}
	
	public function testGetChildClassesWithChildrenOfTypeClassInfoAndPackageInfo(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
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
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildPackagesWithNullChildren(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildPackages());
	}
	
	public function testGetChildPackagesWithChildrenOfTypeClassInfoAndPackageInfo(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		var children:Array = i.getChildPackages();
		assertSame(children.length, 3);
		assertSame(children[0], p1);
		assertSame(children[1], p2);
		assertSame(children[2], p3);
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildByNameWithNullName(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildByName(null));
		assertNull(i.getChildByName(undefined));
		
		ac.verify(this);
	}
	
	public function testGetChildByNameWithNullChildren(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildByName("child"));
	}
	
	public function testGetChildByNameWithKnownChildren(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getName();
		c1c.setDefaultReturnValue("class1");
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getName();
		c2c.setDefaultReturnValue("class2");
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getName();
		c3c.setDefaultReturnValue("class3");
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getName();
		p1c.setDefaultReturnValue("package1");
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getName();
		p2c.setDefaultReturnValue("package2");
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getName();
		p3c.setDefaultReturnValue("package3");
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildByName("class1"), c1);
		assertSame(i.getChildByName("class2"), c2);
		assertSame(i.getChildByName("class3"), c3);
		assertSame(i.getChildByName("package1"), p1);
		assertSame(i.getChildByName("package2"), p2);
		assertSame(i.getChildByName("package3"), p3);
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildByChildWithNullAndUndefinedArgument(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildByChild(null));
		assertNull(i.getChildByChild(undefined));
		
		ac.verify(this);
	}
	
	public function testGetChildByChildWithNullChildren(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildByChild(new Object()));
	}
	
	public function testGetChildByChildWithRealValues(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getType();
		c2c.setDefaultReturnValue(T2);
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getType();
		c3c.setDefaultReturnValue(T3);
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getPackage();
		p1c.setDefaultReturnValue(cp1);
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildByChild(T1), c1);
		assertSame(i.getChildByChild(T2), c2);
		assertSame(i.getChildByChild(T3), c3);
		assertSame(i.getChildByChild(cp1), p1);
		assertSame(i.getChildByChild(cp2), p2);
		assertSame(i.getChildByChild(cp3), p3);
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildClassByNameWithNullName(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildClassByName(null));
		assertNull(i.getChildClassByName(undefined));
		
		ac.verify(this);
	}
	
	public function testGetChildClassByNameWithNullChildClasses(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildClassByName("class"));
	}
	
	public function testGetChildClassByNameWithKnownChildClasses(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getName();
		c1c.setDefaultReturnValue("class1");
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getName();
		c2c.setDefaultReturnValue("class2");
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getName();
		c3c.setDefaultReturnValue("class3");
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
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
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildClassByClassWithNullAndUndefinedArgument(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildClassByClass(null));
		assertNull(i.getChildClassByClass(undefined));
		
		ac.verify(this);
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
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getType();
		c2c.setDefaultReturnValue(T2);
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getType();
		c3c.setDefaultReturnValue(T3);
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getPackage();
		p1c.setDefaultReturnValue(cp1);
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildClassByClass(T1), c1);
		assertSame(i.getChildClassByClass(T2), c2);
		assertSame(i.getChildClassByClass(T3), c3);
		assertNull(i.getChildClassByClass(function() {}));
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildPackageByNameWithNullName(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildPackageByName(null));
		assertNull(i.getChildPackageByName(undefined));
		
		ac.verify(this);
	}
	
	public function testGetChildPackageByNameWithNullChildPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildPackageByName("package"));
	}
	
	public function testGetChildPackageByNameWithKnownChildPackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getName();
		p1c.setDefaultReturnValue("package1");
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getName();
		p2c.setDefaultReturnValue("package2");
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getName();
		p3c.setDefaultReturnValue("package3");
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertNull(i.getChildPackageByName("class1"));
		assertNull(i.getChildPackageByName("class2"));
		assertNull(i.getChildPackageByName("class3"));
		assertSame(i.getChildPackageByName("package1"), p1);
		assertSame(i.getChildPackageByName("package2"), p2);
		assertSame(i.getChildPackageByName("package3"), p3);
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
	public function testGetChildPackageByPackageWithNullAndUndefinedArgument(Void):Void {
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setChildAlgorithm(a);
		assertNull(i.getChildPackageByPackage(null));
		assertNull(i.getChildPackageByPackage(undefined));
		
		ac.verify(this);
	}
	
	public function testGetChildPackageByPackageWithNullChildPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getChildPackageByPackage(new Object()));
	}
	
	public function testGetChildPackageByPackageWithRealValues(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var c1c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var c2c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2.getType();
		c2c.setDefaultReturnValue(T2);
		c2c.replay();
		
		var c3c:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3.getType();
		c3c.setDefaultReturnValue(T3);
		c3c.replay();
		
		var p1c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getPackage();
		p1c.setDefaultReturnValue(cp1);
		p1c.replay();
		
		var p2c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2c.replay();
		
		var p3c:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3c.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ChildAlgorithm);
		var a:ChildAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setChildAlgorithm(a);
		
		assertSame(i.getChildPackageByPackage(cp1), p1);
		assertSame(i.getChildPackageByPackage(cp2), p2);
		assertSame(i.getChildPackageByPackage(cp3), p3);
		assertNull(i.getChildPackageByPackage(new Object()));
		
		ac.verify(this);
		c1c.verify(this);
		c2c.verify(this);
		c3c.verify(this);
		p1c.verify(this);
		p2c.verify(this);
		p3c.verify(this);
	}
	
}