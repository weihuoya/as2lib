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
import org.as2lib.env.reflect.PackageMemberFilter;
import org.as2lib.env.reflect.algorithm.PackageMemberAlgorithm;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TPackageInfo extends TestCase {
	
	public function testIsParentPackageWithNullArgument(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(null));
	}
	
	public function testIsParentPackageWithTheSameInstances(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(p));
	}
	
	public function testIsParentPackageWithRootPackageArgument(Void):Void {
		var ppc:MockControl = new MockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.isRoot();
		ppc.setReturnValue(true);
		ppc.replay();
		
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(pp));
		
		ppc.verify();
	}
	
	public function testIsParentPackageWithPackageArgumentWhoseGetParentMethodReturnsNull(Void):Void {
		var ppc:MockControl = new MockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.getParent();
		ppc.setReturnValue(null);
		pp.isRoot();
		ppc.setReturnValue(false);
		ppc.replay();
		
		var p:PackageInfo = new PackageInfo(null, null, null);
		assertFalse(p.isParentPackage(pp));
		
		ppc.verify();
	}
	
	public function testIsParentPackageWithDirectParentPackageMatch(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var ppc:MockControl = new MockControl(PackageInfo);
		var pp:PackageInfo = ppc.getMock();
		pp.getParent();
		ppc.setReturnValue(p);
		pp.isRoot();
		ppc.setReturnValue(false);
		ppc.replay();
		
		assertTrue(p.isParentPackage(pp));
		
		ppc.verify();
	}
	
	public function testIsParentPackageWithMultipleLevels(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var pp3c:MockControl = new MockControl(PackageInfo);
		var pp3:PackageInfo = pp3c.getMock();
		pp3.getParent();
		pp3c.setReturnValue(p);
		pp3.isRoot();
		pp3c.setReturnValue(false);
		pp3c.replay();
		
		var pp2c:MockControl = new MockControl(PackageInfo);
		var pp2:PackageInfo = pp2c.getMock();
		pp2.getParent();
		pp2c.setReturnValue(pp3);
		pp2.isRoot();
		pp2c.setReturnValue(false);
		pp2c.replay();
		
		var pp1c:MockControl = new MockControl(PackageInfo);
		var pp1:PackageInfo = pp1c.getMock();
		pp1.getParent();
		pp1c.setReturnValue(pp2);
		pp1.isRoot();
		pp1c.setReturnValue(false);
		pp1c.replay();
		
		assertTrue(p.isParentPackage(pp1));
		
		pp1c.verify();
		pp2c.verify();
		pp3c.verify();
	}
	
	public function testIsParentPackageWithMultipleLevelsAndNoMatch(Void):Void {
		var p:PackageInfo = new PackageInfo(null, null, null);
		
		var pp3c:MockControl = new MockControl(PackageInfo);
		var pp3:PackageInfo = pp3c.getMock();
		pp3.isRoot();
		pp3c.setReturnValue(true);
		pp3c.replay();
		
		var pp2c:MockControl = new MockControl(PackageInfo);
		var pp2:PackageInfo = pp2c.getMock();
		pp2.getParent();
		pp2c.setReturnValue(pp3);
		pp2.isRoot();
		pp2c.setReturnValue(false);
		pp2c.replay();
		
		var pp1c:MockControl = new MockControl(PackageInfo);
		var pp1:PackageInfo = pp1c.getMock();
		pp1.getParent();
		pp1c.setReturnValue(pp2);
		pp1.isRoot();
		pp1c.setReturnValue(false);
		pp1c.replay();
		
		assertFalse(p.isParentPackage(pp1));
		
		pp1c.verify();
		pp2c.verify();
		pp3c.verify();
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
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(true);
		rc.replay();
		
		var i:PackageInfo = new PackageInfo("MyClass", null, r);
		assertSame(i.getFullName(), "MyClass");
		
		rc.verify();
	}
	
	public function testGetFullNameWithNormalParent(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(false);
		r.getFullName();
		rc.setReturnValue("org.as2lib.mypackage");
		rc.replay();
		
		var i:PackageInfo = new PackageInfo("MyClass", null, r);
		assertSame(i.getFullName(), "org.as2lib.mypackage.MyClass");
		
		rc.verify();
	}
	
	public function testGetMembersByFlagWithNullPackage(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMembers(true));
		assertNull(i.getMembers(false));
		assertNull(i.getMembers());
		
		ac.verify();
	}
	
	public function testGetMembersByFlagWithRealPackage(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue(["member1", "member2", "member3"]);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		var members:Array = i.getMembers(true);
		assertSame(members.length, 3);
		assertSame(members[0], "member1");
		assertSame(members[1], "member2");
		assertSame(members[2], "member3");
		
		ac.verify();
	}
	
	public function testGetMembersByFlagWithSubPackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(null, p, null);
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMembersByFlag(false);
		p1c.setReturnValue(["member4", "member5"]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMembersByFlag(false);
		p2c.setReturnValue([]);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMembersByFlag(false);
		p3c.setReturnValue(["member6", "member7", "member8"]);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = ["member1", "member2", "member3"];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		var members:Array = i.getMembers(false);
		assertSame(members.length, 8);
		assertSame(members[0], "member1");
		assertSame(members[1], "member2");
		assertSame(members[2], "member3");
		assertSame(members[3], "member4");
		assertSame(members[4], "member5");
		assertSame(members[5], "member6");
		assertSame(members[6], "member7");
		assertSame(members[7], "member8");
		
		ac.verify();
		p3c.verify();
		p2c.verify();
		p1c.verify();
	}
	
	public function testGetMembersByFilterWithNullPackage(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		fc.replay();
		
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMembersByFilter(null));
		assertNull(i.getMembersByFilter());
		assertNull(i.getMembers(f));
		
		ac.verify();
		fc.verify();
	}
	
	public function testGetMembersByFilterWithFilteredSubpackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		
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
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([p1, p2, p3, c1, c2, c3]);
		ac.replay();
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(true);
		f.filter(p1);
		fc.setReturnValue(true);
		f.filter(p2);
		fc.setReturnValue(false);
		f.filter(p3);
		fc.setReturnValue(true);
		f.filter(c1);
		fc.setReturnValue(true);
		f.filter(c2);
		fc.setReturnValue(false);
		f.filter(c3);
		fc.setReturnValue(true);
		fc.replay();
		
		i.setPackageMemberAlgorithm(a);
		var members:Array = i.getMembers(f);
		assertSame(members[0], p2);
		assertSame(members[1], c2);
		
		ac.verify();
		fc.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMembersByFilter(Void):Void {
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		
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
		p1.getMembersByFlag(false);
		p1c.setReturnValue([]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMembersByFlag(false);
		p2c.setReturnValue([c2, c3]);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMembersByFlag(false);
		p3c.setReturnValue([]);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [p1, p2, p3, c1];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(false);
		f.filter(p1);
		fc.setReturnValue(true);
		f.filter(p2);
		fc.setReturnValue(false);
		f.filter(p3);
		fc.setReturnValue(true);
		f.filter(c1);
		fc.setReturnValue(false);
		f.filter(c2);
		fc.setReturnValue(false);
		f.filter(c3);
		fc.setReturnValue(false);
		fc.replay();
		
		i.setPackageMemberAlgorithm(a);
		var members:Array = i.getMembers(f);
		assertSame(members[0], p2);
		assertSame(members[1], c1);
		assertSame(members[2], c2);
		assertSame(members[3], c3);
		
		ac.verify();
		fc.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberByNameWithNullName(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberByName(null));
		assertNull(i.getMemberByName(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberByNameWithNullMembers(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberByName("member"));
	}
	
	public function testGetMemberByNameWithKnownMembers(Void):Void {
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
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3];
		members["class1"] = c1;
		members["class2"] = c2;
		members["class3"] = c3;
		members["package1"] = p1;
		members["package2"] = p2;
		members["package3"] = p3;
		ac.setReturnValue(members);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberByName("class1"), c1);
		assertSame(i.getMemberByName("class2"), c2);
		assertSame(i.getMemberByName("class3"), c3);
		assertSame(i.getMemberByName("package1"), p1);
		assertSame(i.getMemberByName("package2"), p2);
		assertSame(i.getMemberByName("package3"), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberByNameWithMembersInSubPackages(Void):Void {
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
		p1.getMemberByName("class1");
		p1c.setReturnValue(c1);
		p1.getMemberByName("package2");
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberByName("package2");
		p3c.setReturnValue(p2);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [p1, c2, c3, p2, p3];
		members["class2"] = c2;
		members["class3"] = c3;
		members["package1"] = p1;
		members["package3"] = p3;
		members["packages"] = [p1, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberByName("class1"), c1);
		assertSame(i.getMemberByName("class2"), c2);
		assertSame(i.getMemberByName("class3"), c3);
		assertSame(i.getMemberByName("package1"), p1);
		assertSame(i.getMemberByName("package2"), p2);
		assertSame(i.getMemberByName("package3"), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberByMemberWithNullAndUndefinedArgument(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberByMember(null));
		assertNull(i.getMemberByMember(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberByMemberWithNullMembers(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberByMember(new Object()));
	}
	
	public function testGetMemberByMemberWithRealValues(Void):Void {
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
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3];
		members["classes"] = [c1, c2, c3];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberByMember(T1), c1);
		assertSame(i.getMemberByMember(T2), c2);
		assertSame(i.getMemberByMember(T3), c3);
		assertSame(i.getMemberByMember(cp1), p1);
		assertSame(i.getMemberByMember(cp2), p2);
		assertSame(i.getMemberByMember(cp3), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberByMemberWithSubpackages(Void):Void {
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
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2.getMemberClassByClass(T2);
		p2c.setReturnValue(c2);
		p2.getMemberClassByClass(T3);
		p2c.setReturnValue(null);
		p2.getMemberPackageByPackage(cp1);
		p2c.setReturnValue(p1);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3.getMemberClassByClass(T3);
		p3c.setReturnValue(c3);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p2, p3];
		members["classes"] = [c1];
		members["packages"] = [p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberByMember(T1), c1);
		assertSame(i.getMemberByMember(T2), c2);
		assertSame(i.getMemberByMember(T3), c3);
		assertSame(i.getMemberByMember(cp1), p1);
		assertSame(i.getMemberByMember(cp2), p2);
		assertSame(i.getMemberByMember(cp3), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
}