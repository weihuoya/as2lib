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
import org.as2lib.env.reflect.algorithm.PackageMemberAlgorithm;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TPackageInfo_Package extends TestCase {
	
	public function testGetPackagesWithNullMembers(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackages());
	}
	
	public function testGetPackagesWithMembersOfTypeClassInfoAndPackageInfo(Void):Void {
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
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		var members:Array = i.getMemberPackages();
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
	
	public function testGetPackageByNameWithNullName(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberPackageByName(null));
		assertNull(i.getMemberPackageByName(undefined));
		
		ac.verify();
	}
	
	public function testGetPackageByNameWithNullMemberPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackageByName("package"));
	}
	
	public function testGetPackageByNameWithKnownMemberPackages(Void):Void {
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
		p1.getName();
		p1c.setDefaultReturnValue("package1");
		p1c.replay();
		
		var p2c:MockControl = new MockControl(PackageInfo);
		var p2:PackageInfo = p2c.getMock();
		p2.getName();
		p2c.setDefaultReturnValue("package2");
		p2c.replay();
		
		var p3c:MockControl = new MockControl(PackageInfo);
		var p3:PackageInfo = p3c.getMock();
		p3.getName();
		p3c.setDefaultReturnValue("package3");
		p3c.replay();
		
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		a.execute(i);
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertNull(i.getMemberPackageByName("class1"));
		assertNull(i.getMemberPackageByName("class2"));
		assertNull(i.getMemberPackageByName("class3"));
		assertSame(i.getMemberPackageByName("package1"), p1);
		assertSame(i.getMemberPackageByName("package2"), p2);
		assertSame(i.getMemberPackageByName("package3"), p3);
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
	public function testGetPackageByPackageWithNullAndUndefinedArgument(Void):Void {
		var ac:MockControl = new MockControl(PackageMemberAlgorithm);
		var a:PackageMemberAlgorithm = ac.getMock();
		ac.replay();
		
		var i:PackageInfo = new PackageInfo(null, new Object(), null);
		i.setPackageMemberAlgorithm(a);
		assertNull(i.getMemberPackageByPackage(null));
		assertNull(i.getMemberPackageByPackage(undefined));
		
		ac.verify();
	}
	
	public function testGetPackageByPackageWithNullMemberPackages(Void):Void {
		var i:PackageInfo = new PackageInfo(null, null, null);
		assertNull(i.getMemberPackageByPackage(new Object()));
	}
	
	public function testGetPackageByPackageWithRealValues(Void):Void {
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
		ac.setReturnValue([c1, p1, c2, c3, p2, p3]);
		ac.replay();
		
		i.setPackageMemberAlgorithm(a);
		
		assertSame(i.getMemberPackageByPackage(cp1), p1);
		assertSame(i.getMemberPackageByPackage(cp2), p2);
		assertSame(i.getMemberPackageByPackage(cp3), p3);
		assertNull(i.getMemberPackageByPackage(new Object()));
		
		ac.verify();
		c1c.verify();
		c2c.verify();
		c3c.verify();
		p1c.verify();
		p2c.verify();
		p3c.verify();
	}
	
}