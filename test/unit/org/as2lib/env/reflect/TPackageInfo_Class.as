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
class org.as2lib.env.reflect.TPackageInfo_Class extends TestCase {
	
	private var fpma:PackageMemberAlgorithm;
	
	public function setUp() {
		fpma = PackageInfo.getPackageMemberAlgorithm();
	}
	
	public function testGetMemberClassesByFlagWithNullMembers(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberClasses());
		assertNull(i.getMemberClasses(true));
		assertNull(i.getMemberClasses(false));
	}
	
	public function testGetMemberClassesByFlagWithMembersOfTypeClassInfoAndPackageInfo(Void):Void {
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
		members["classes"] = [c1, c2, c3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClasses(true);
		assertSame(members.length, 3);
		assertSame(members[0], c1);
		assertSame(members[1], c2);
		assertSame(members[2], c3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassesByFlagWithNullArgument(Void):Void {
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
		members["classes"] = [c1, c2, c3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClassesByFlag(null);
		assertSame(members.length, 3);
		assertSame(members[0], c1);
		assertSame(members[1], c2);
		assertSame(members[2], c3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassesByFlagWithSubpackagesToSearchThrough(Void):Void {
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo( p, null,  null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var c4c:MockControl = new MockControl(ClassInfo);
		var c4:ClassInfo = c4c.getMock();
		c4c.replay();
		
		var c5c:MockControl = new MockControl(ClassInfo);
		var c5:ClassInfo = c5c.getMock();
		c5c.replay();
		
		var c6c:MockControl = new MockControl(ClassInfo);
		var c6:ClassInfo = c6c.getMock();
		c6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberClassesByFlag(false);
		p1c.setReturnValue([c4, c5]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberClassesByFlag(false);
		p2c.setReturnValue([c6]);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberClassesByFlag(false);
		p3c.setReturnValue([]);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3];
		members["classes"] = [c1, c2, c3];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClasses(false);
		assertSame(members.length, 6);
		assertSame(members[0], c1);
		assertSame(members[1], c2);
		assertSame(members[2], c3);
		assertSame(members[3], c4);
		assertSame(members[4], c5);
		assertSame(members[5], c6);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassesByFilterWithNullPackage(Void):Void {
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		fc.replay();
		
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberClassesByFilter(null));
		assertNull(i.getMemberClasses(f));
		
		fc.verify();
	}
	
	public function testGetMemberClassesByFilterWithNullFilter(Void):Void {
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
		members["classes"] = [c1, c2, c3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClassesByFilter(null);
		assertSame(members.length, 3);
		assertSame(members[0], c1);
		assertSame(members[1], c2);
		assertSame(members[2], c3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassesByFilterWithFilteredSubPackages(Void):Void {
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
		
		var c4c:MockControl = new MockControl(ClassInfo);
		var c4:ClassInfo = c4c.getMock();
		c4c.replay();
		
		var c5c:MockControl = new MockControl(ClassInfo);
		var c5:ClassInfo = c5c.getMock();
		c5c.replay();
		
		var c6c:MockControl = new MockControl(ClassInfo);
		var c6:ClassInfo = c6c.getMock();
		c6c.replay();
		
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
		var members:Array = [c1, p1, c2, c3, p2, p3, c4, c5, c6];
		members["classes"] = [c1, c2, c3, c4, c5, c6];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(true);
		f.filter(c1);
		fc.setReturnValue(false);
		f.filter(c2);
		fc.setReturnValue(true);
		f.filter(c3);
		fc.setReturnValue(true);
		f.filter(c4);
		fc.setReturnValue(false);
		f.filter(c5);
		fc.setReturnValue(false);
		f.filter(c6);
		fc.setReturnValue(true);
		fc.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClassesByFilter(f);
		assertSame(members.length, 3);
		assertSame(members[0], c1);
		assertSame(members[1], c4);
		assertSame(members[2], c5);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		c4c.verify();
		c5c.verify();
		c6c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		fc.verify();
	}
	
	public function testGetMemberClassesByFilterWithSubPackages(Void):Void {
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
		
		var c4c:MockControl = new MockControl(ClassInfo);
		var c4:ClassInfo = c4c.getMock();
		c4c.replay();
		
		var c5c:MockControl = new MockControl(ClassInfo);
		var c5:ClassInfo = c5c.getMock();
		c5c.replay();
		
		var c6c:MockControl = new MockControl(ClassInfo);
		var c6:ClassInfo = c6c.getMock();
		c6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberClassesByFlag(false);
		p1c.setReturnValue([c2, c3]);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberClassesByFlag(false);
		p2c.setReturnValue([c4]);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberClassesByFlag(false);
		p3c.setReturnValue([c5, c6]);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, c3, p2, p3, c4, c5, c6];
		members["classes"] = [c1];
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		var fc:MockControl = new MockControl(PackageMemberFilter);
		var f:PackageMemberFilter = fc.getMock();
		f.filterSubPackages();
		fc.setReturnValue(false);
		f.filter(c1);
		fc.setReturnValue(true);
		f.filter(c2);
		fc.setReturnValue(false);
		f.filter(c3);
		fc.setReturnValue(true);
		f.filter(c4);
		fc.setReturnValue(false);
		f.filter(c5);
		fc.setReturnValue(false);
		f.filter(c6);
		fc.setReturnValue(true);
		fc.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		members = i.getMemberClassesByFilter(f);
		assertSame(members.length, 3);
		assertSame(members[0], c2);
		assertSame(members[1], c4);
		assertSame(members[2], c5);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		c4c.verify();
		c5c.verify();
		c6c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
		fc.verify();
	}
	
	public function testGetMemberClassByNameWithNullName(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(new Object(), null, null);
		PackageInfo.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberClassByName(null));
		assertNull(i.getMemberClassByName(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberClassByNameWithNullMemberClasses(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberClassByName("class"));
	}
	
	public function testGetMemberClassByNameWithKnownMemberClasses(Void):Void {
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
		members["classes"] = [c1, c2, c3];
		members["classes"]["class1"] = c1;
		members["classes"]["class2"] = c2;
		members["classes"]["class3"] = c3;
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberClassByName("class1"), c1);
		assertSame(i.getMemberClassByName("class2"), c2);
		assertSame(i.getMemberClassByName("class3"), c3);
		assertNull(i.getMemberClassByName("package1"));
		assertNull(i.getMemberClassByName("package2"));
		assertNull(i.getMemberClassByName("package3"));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassByNameWithMemberClassesInSubPackages(Void):Void {
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
		
		var c4c:MockControl = new MockControl(ClassInfo);
		var c4:ClassInfo = c4c.getMock();
		c4c.replay();
		
		var c5c:MockControl = new MockControl(ClassInfo);
		var c5:ClassInfo = c5c.getMock();
		c5c.replay();
		
		var c6c:MockControl = new MockControl(ClassInfo);
		var c6:ClassInfo = c6c.getMock();
		c6c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberClassByName("class3");
		p1c.setReturnValue(c3);
		p1.getMemberClassByName("class4");
		p1c.setReturnValue(null);
		p1.getMemberClassByName("class5");
		p1c.setReturnValue(null);
		p1.getMemberClassByName("class6");
		p1c.setReturnValue(c6);
		p1.getMemberClassByName("unknwonClass");
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberClassByName("class4");
		p2c.setReturnValue(null);
		p2.getMemberClassByName("class5");
		p2c.setReturnValue(null);
		p2.getMemberClassByName("unknwonClass");
		p2c.setReturnValue(null);
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getMemberClassByName("class4");
		p3c.setReturnValue(c4);
		p3.getMemberClassByName("class5");
		p3c.setReturnValue(c5);
		p3.getMemberClassByName("unknwonClass");
		p3c.setReturnValue(null);
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, c2, p2, p3];
		members["classes"] = [c1, c2];
		members["classes"]["class1"] = c1;
		members["classes"]["class2"] = c2;
		members["packages"] = [p1, p2, p3];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberClassByName("class1"), c1);
		assertSame(i.getMemberClassByName("class2"), c2);
		assertSame(i.getMemberClassByName("class3"), c3);
		assertSame(i.getMemberClassByName("class4"), c4);
		assertSame(i.getMemberClassByName("class5"), c5);
		assertSame(i.getMemberClassByName("class6"), c6);
		assertNull(i.getMemberClassByName("unknwonClass"));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		c4c.verify();
		c5c.verify();
		c6c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassByClassWithNullAndUndefinedArgument(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(new Object(), null, null);
		PackageInfo.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberClassByClass(null));
		assertNull(i.getMemberClassByClass(undefined));
		
		ac.verify();
	}
	
	public function testGetMemberClassByClassWithNullMemberClasses(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberClassByClass(Object));
	}
	
	public function testGetMemberClassByClassWithRealValues(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		
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
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberClassByClass(T1), c1);
		assertSame(i.getMemberClassByClass(T2), c2);
		assertSame(i.getMemberClassByClass(T3), c3);
		assertNull(i.getMemberClassByClass(function() {}));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetMemberClassByClassWithMemberClassesInSubpackages(Void):Void {
		var T1:Function = function() {};
		var T2:Function = function() {};
		var T3:Function = function() {};
		var T4:Function = function() {};
		var T5:Function = function() {};
		var UF:Function = function() {};
		var cp1:Object = new Object();
		var cp2:Object = new Object();
		var cp3:Object = new Object();
		
		var p:Object = new Object();
		var i:PackageInfo = new PackageInfo(p, null, null);
		
		var c1c:MockControl = new MockControl(ClassInfo);
		var c1:ClassInfo = c1c.getMock();
		c1.getType();
		c1c.setDefaultReturnValue(T1);
		c1c.replay();
		
		var c2c:MockControl = new MockControl(ClassInfo);
		var c2:ClassInfo = c2c.getMock();
		c2c.replay();
		
		var c3c:MockControl = new MockControl(ClassInfo);
		var c3:ClassInfo = c3c.getMock();
		c3c.replay();
		
		var c4c:MockControl = new MockControl(ClassInfo);
		var c4:ClassInfo = c4c.getMock();
		c4c.replay();
		
		var c5c:MockControl = new MockControl(ClassInfo);
		var c5:ClassInfo = c5c.getMock();
		c5c.replay();
		
		var p1c:MockControl = new MockControl(PackageInfo);
		var p1:PackageInfo = p1c.getMock();
		p1.getMemberClassByClass(T2);
		p1c.setReturnValue(null);
		p1.getMemberClassByClass(T3);
		p1c.setReturnValue(null);
		p1.getMemberClassByClass(T4);
		p1c.setReturnValue(c4);
		p1.getMemberClassByClass(T5);
		p1c.setReturnValue(null);
		p1.getMemberClassByClass(UF);
		p1c.setReturnValue(null);
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getMemberClassByClass(T2);
		p2c.setReturnValue(c2);
		p2.getMemberClassByClass(T3);
		p2c.setReturnValue(c3);
		p2.getMemberClassByClass(T5);
		p2c.setReturnValue(c5);
		p2.getMemberClassByClass(UF);
		p2c.setReturnValue(null);
		p2c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		var members:Array = [c1, p1, p2];
		members["classes"] = [c1];
		members["packages"] = [p1, p2];
		ac.setReturnValue(members);
		ac.replay();
		
		PackageInfo.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberClassByClass(T1), c1);
		assertSame(i.getMemberClassByClass(T2), c2);
		assertSame(i.getMemberClassByClass(T3), c3);
		assertSame(i.getMemberClassByClass(T4), c4);
		assertSame(i.getMemberClassByClass(T5), c5);
		assertNull(i.getMemberClassByClass(UF));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		c4c.verify();
		c5c.verify();
		p1c.verify();
		p2c.verify();
	}
	
	public function tearDown() {
		PackageInfo.setPackageMemberAlgorithm(fpma);
	}
}