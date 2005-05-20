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
class org.as2lib.env.reflect.TPackageInfo_Package extends TestCase {
	
	private var fpma:PackageMemberAlgorithm;
	
	public function setUp() {
		fpma = PackageInfo.getPackageMemberAlgorithm();
	}
	
	public function testGetMemberPackagesByFlagWithNullMembers(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackages());
		assertNull(i.getMemberPackages(true));
		assertNull(i.getMemberPackages(false));
	}
	
	public function testGetMemberPackagesByFlagWithMembersOfTypeClassInfoAndPackageInfo(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
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
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberPackages();
		assertSame(members.length, 3);
		assertSame(members[0], p1);
		assertSame(members[1], p2);
		assertSame(members[2], p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberPackagesByFlagWithMembersOfSubPackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3c.replay();
		
		var p4c:MockControl = new MockControl(PackageInfo);
		var p4:PackageInfo = p4c.getMock();
		p4c.replay();
		
		var p5c:MockControl = new MockControl(PackageInfo);
		var p5:PackageInfo = p5c.getMock();
		p5c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberPackagesByFlag(false);
		p1c.setReturnValue([p3]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberPackagesByFlag(false);
		p2c.setReturnValue([p4, p5]);
		p2c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, p2];
		members["packages"] = [p1, p2];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberPackages(false);
		assertSame(members.length, 5);
		assertSame(members[0], p1);
		assertSame(members[1], p2);
		assertSame(members[2], p3);
		assertSame(members[3], p4);
		assertSame(members[4], p5);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberPackagesByFilterWithNullMembers(Void):Void {
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		fc.replay();
		
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackagesByFilter(null));
		assertNull(i.getMemberPackages(f));
		
		fc.verify();
	}
	
	public function testGetMemberPackagesByFilterWithNullFilter(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
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
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberPackagesByFilter(null);
		assertSame(members.length, 3);
		assertSame(members[0], p1);
		assertSame(members[1], p2);
		assertSame(members[2], p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberPackagesByFilterWithFilteredSubpackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
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
		
		var p4c:MockControl = new MockControl(PackageInfo);
		var p4:PackageInfo = p4c.getMock();
		p4c.replay();
		
		var p5c:MockControl = new MockControl(PackageInfo);
		var p5:PackageInfo = p5c.getMock();
		p5c.replay();
		
		var p6c:MockControl = new MockControl(PackageInfo);
		var p6:PackageInfo = p6c.getMock();
		p6c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3, p4, p5, p6];
		members["packages"] = [p1, p2, p3, p4, p5, p6];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(true);
		f.filter(p1);
		fc.setReturnValue(true);
		f.filter(p2);
		fc.setReturnValue(false);
		f.filter(p3);
		fc.setReturnValue(false);
		f.filter(p4);
		fc.setReturnValue(true);
		f.filter(p5);
		fc.setReturnValue(false);
		f.filter(p6);
		fc.setReturnValue(false);
		fc.replay();
		
		members = i.getMemberPackages(f);
		assertSame(members.length, 4);
		assertSame(members[0], p2);
		assertSame(members[1], p3);
		assertSame(members[2], p5);
		assertSame(members[3], p6);
		
		fc.verify();
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		p4c.verify();
		p5c.verify();
		p6c.verify();
	}
	
	public function testGetMemberPackagesByFilterWithMembersOfSubpackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var p4c:MockControl = new MockControl(PackageInfo);
		var p4:PackageInfo = p4c.getMock();
		p4c.replay();
		
		var p5c:MockControl = new MockControl(PackageInfo);
		var p5:PackageInfo = p5c.getMock();
		p5c.replay();
		
		var p6c:MockControl = new MockControl(PackageInfo);
		var p6:PackageInfo = p6c.getMock();
		p6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberPackagesByFlag(false);
		p1c.setReturnValue([]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberPackagesByFlag(false);
		p2c.setReturnValue([p4]);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberPackagesByFlag(false);
		p3c.setReturnValue([p5, p6]);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3, p4, p5, p6];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(false);
		f.filter(p1);
		fc.setReturnValue(false);
		f.filter(p2);
		fc.setReturnValue(false);
		f.filter(p3);
		fc.setReturnValue(false);
		f.filter(p4);
		fc.setReturnValue(true);
		f.filter(p5);
		fc.setReturnValue(false);
		f.filter(p6);
		fc.setReturnValue(true);
		fc.replay();
		
		members = i.getMemberPackages(f);
		assertSame(members.length, 4);
		assertSame(members[0], p1);
		assertSame(members[1], p2);
		assertSame(members[2], p3);
		assertSame(members[3], p5);
		
		fc.verify();
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		p4c.verify();
		p5c.verify();
		p6c.verify();
	}
	
	public function testGetMemberPackageByNameWithNullName(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(new Object(), null, null);
		PackageInfo.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberPackageByName(null));
		assertNull(i.getMemberPackageByName(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberPackageByNameWithNullMemberPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackageByName("package"));
	}
	
	public function testGetMemberPackageByNameWithKnownMemberPackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberPackageByName("class1");
		p1c.setReturnValue(null);
		p1.getMemberPackageByName("class2");
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberPackageByName("class1");
		p2c.setReturnValue(null);
		p2.getMemberPackageByName("class2");
		p2c.setReturnValue(null);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberPackageByName("class1");
		p3c.setReturnValue(null);
		p3.getMemberPackageByName("class2");
		p3c.setReturnValue(null);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, p2, p3];
		members["packages"] = [p1, p2, p3];
		members["packages"]["package1"] = p1;
		members["packages"]["package2"] = p2;
		members["packages"]["package3"] = p3;
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertNull(i.getMemberPackageByName("class1"));
		assertNull(i.getMemberPackageByName("class2"));
		assertSame(i.getMemberPackageByName("package1"), p1);
		assertSame(i.getMemberPackageByName("package2"), p2);
		assertSame(i.getMemberPackageByName("package3"), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberPackageByNameWithMembersInSubPackages(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var p4c:MockControl = new MockControl(PackageInfo);
		var p4:PackageInfo = p4c.getMock();
		p4c.replay();
		
		var p5c:MockControl = new MockControl(PackageInfo);
		var p5:PackageInfo = p5c.getMock();
		p5c.replay();
		
		var p6c:MockControl = new MockControl(PackageInfo);
		var p6:PackageInfo = p6c.getMock();
		p6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberPackageByName("class2");
		p1c.setReturnValue(null);
		p1.getMemberPackageByName("package4");
		p1c.setReturnValue(null);
		p1.getMemberPackageByName("package5");
		p1c.setReturnValue(p5);
		p1.getMemberPackageByName("package6");
		p1c.setReturnValue(null);
		p1.getMemberPackageByName("unknownpackage");
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberPackageByName("class2");
		p2c.setReturnValue(null);
		p2.getMemberPackageByName("package4");
		p2c.setReturnValue(p4);
		p2.getMemberPackageByName("package6");
		p2c.setReturnValue(null);
		p2.getMemberPackageByName("unknownpackage");
		p2c.setReturnValue(null);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberPackageByName("class2");
		p3c.setReturnValue(null);
		p3.getMemberPackageByName("package6");
		p3c.setReturnValue(p6);
		p3.getMemberPackageByName("unknownpackage");
		p3c.setReturnValue(null);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, p2, p3];
		members["packages"] = [p1, p2, p3];
		members["packages"]["package1"] = p1;
		members["packages"]["package2"] = p2;
		members["packages"]["package3"] = p3;
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertNull(i.getMemberPackageByName("class2"));
		assertSame(i.getMemberPackageByName("package1"), p1);
		assertSame(i.getMemberPackageByName("package2"), p2);
		assertSame(i.getMemberPackageByName("package3"), p3);
		assertSame(i.getMemberPackageByName("package4"), p4);
		assertSame(i.getMemberPackageByName("package5"), p5);
		assertSame(i.getMemberPackageByName("package6"), p6);
		assertNull(i.getMemberPackageByName("unknownpackage"));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		p4c.verify();
		p5c.verify();
		p6c.verify();
	}
	
	public function testGetMemberPackageByPackageWithNullAndUndefinedArgument(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(new Object(), null, null);
		PackageInfo.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberPackageByPackage(null));
		assertNull(i.getMemberPackageByPackage(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberPackageByPackageWithNullMemberPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackageByPackage(new Object()));
	}
	
	public function testGetMemberPackageByPackageWithRealValues(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		var up:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
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
		p1.getMemberPackageByPackage(up);
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2.getMemberPackageByPackage(up);
		p2c.setReturnValue(null);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3.getMemberPackageByPackage(up);
		p3c.setReturnValue(null);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberPackageByPackage(cp1), p1);
		assertSame(i.getMemberPackageByPackage(cp2), p2);
		assertSame(i.getMemberPackageByPackage(cp3), p3);
		assertNull(i.getMemberPackageByPackage(up));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberPackageByPackageWithMembersInSubpackages(Void):Void {
		var T1:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		var cp4:Object = new Object();
		var cp5:Object = new Object();
		var cp6:Object = new Object();
		var up:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var p4c:MockControl = new MockControl(PackageInfo);
		var p4:PackageInfo = p4c.getMock();
		p4c.replay();
		
		var p5c:MockControl = new MockControl(PackageInfo);
		var p5:PackageInfo = p5c.getMock();
		p5c.replay();
		
		var p6c:MockControl = new MockControl(PackageInfo);
		var p6:PackageInfo = p6c.getMock();
		p6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getPackage();
		p1c.setDefaultReturnValue(cp1);
		p1.getMemberPackageByPackage(cp4);
		p1c.setReturnValue(null);
		p1.getMemberPackageByPackage(cp5);
		p1c.setReturnValue(null);
		p1.getMemberPackageByPackage(cp6);
		p1c.setReturnValue(p6);
		p1.getMemberPackageByPackage(up);
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getPackage();
		p2c.setDefaultReturnValue(cp2);
		p2.getMemberPackageByPackage(cp4);
		p2c.setReturnValue(p4);
		p2.getMemberPackageByPackage(cp5);
		p2c.setReturnValue(null);
		p2.getMemberPackageByPackage(up);
		p2c.setReturnValue(null);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getPackage();
		p3c.setDefaultReturnValue(cp3);
		p3.getMemberPackageByPackage(cp5);
		p3c.setReturnValue(p5);
		p3.getMemberPackageByPackage(up);
		p3c.setReturnValue(null);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, p2, p3];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberPackageByPackage(cp1), p1);
		assertSame(i.getMemberPackageByPackage(cp2), p2);
		assertSame(i.getMemberPackageByPackage(cp3), p3);
		assertSame(i.getMemberPackageByPackage(cp4), p4);
		assertSame(i.getMemberPackageByPackage(cp5), p5);
		assertSame(i.getMemberPackageByPackage(cp6), p6);
		assertNull(i.getMemberPackageByPackage(up));
		
		ac.verify();
		c1c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		p4c.verify();
		p5c.verify();
		p6c.verify();
	}
	
	public function testGetMemberPackageByPackageOrgFromRootPackage(Void):Void {
		var p:PackageInfo = PackageInfo.getRootPackage();
		var c:PackageInfo = p.getMemberPackage(_global.org);
		assertNotNull(c);
		assertSame(c.getPackage(), _global.org);
		assertSame(c.getName(), "org");
		assertSame(c.getFullName(), "org");
		assertSame(c.getParent(), p);
	}
	
	public function tearDown() {
		PackageInfo.setPackageMemberAlgorithm(fpma);
	}
	
}