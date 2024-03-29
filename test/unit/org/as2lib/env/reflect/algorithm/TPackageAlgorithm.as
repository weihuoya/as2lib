﻿/*
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
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.SimpleCache;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.TPackageAlgorithm extends TestCase {
	
	public function testExecuteWithNullAndUndefinedArgument(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(c);
		assertNull("Execute with null argument should return null.", a.execute(null));
		assertNull("Execute with undefined argument should return null.", a.execute(undefined));
		
		cc.verify();
	}
	
	// PackageAlgorithm is not checking the cache anymore
	/*public function testExecuteWithStoredPackageInfo(Void):Void {
		var p:Object = new Object();
		var o:Object = new Object();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getPackage(p);
		cc.setReturnValue(o);
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(c);
		assertSame(a.execute(p), o);
		
		cc.verify();
	}*/
	
	public function testExecuteWithUnknownPackage(Void):Void {
		var p:Object = new Object();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getPackage(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		cc.setDefaultReturnValue(null);
		c.getRoot();
		cc.setReturnValue(PackageInfo.getRootPackage());
		c.addPackage(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([PackageInfo]));
		cc.setDefaultReturnValue(null);
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(c);
		assertNull(a.execute(p));
		
		cc.verify();
	}
	
	public function testExecuteWithExistingPackage(Void):Void {
		var a:PackageAlgorithm = new PackageAlgorithm();
		var p1:Object = a.execute(_global.org.as2lib.core);
		var p2:Object = a.execute(_global.org.as2lib);
		assertNotNull("p1 is null", p1);
		assertNotNull("p2 is null", p2);
		assertSame(p1.package, _global.org.as2lib.core);
		assertSame(p2.package, _global.org.as2lib);
		assertSame(p1.name, "core");
		assertSame(p2.name, "as2lib");
		var pa1:PackageInfo = p1.parent;
		var pa2:PackageInfo = p2.parent;
		assertSame(pa1.getName(), "as2lib");
		assertSame(pa2.getName(), "org");
		assertSame(pa1.getParent(), pa2);
		assertSame(pa1.getPackage(), _global.org.as2lib);
		assertSame(pa2.getPackage(), _global.org);
		assertSame(pa2.getParent(), a.getCache().getRoot());
		/*var pp1:PackageMemberInfo = a.execute(_global.org.as2lib.core);
		var pp2:PackageMemberInfo = a.execute(_global.org.as2lib);
		assertNotNull("pp1 should not be null", pp1);
		assertNotNull("pp2 should not be null", pp2);
		var p1:PackageInfo = PackageInfo(pp1);
		var p2:PackageInfo = PackageInfo(pp2);
		assertNotNull("p1 is not of type PackageInfo", p1);
		assertNotNull("p2 is not of type PackageInfo", p2);
		assertSame("firstly and secondly received info's for org.as2lib.core should be the same", p1, a.execute(_global.org.as2lib.core));
		assertSame("firstly and secondly received info's for org.as2lib should be the same", p2, a.execute(_global.org.as2lib));
		assertSame("parent of p1 should be p2", p1.getParent(), p2);
		assertSame("name of p1 should be 'core'", p1.getName(), "core");
		assertSame("name of p2 should be 'core'", p2.getName(), "as2lib");
		assertSame("actual package of p1 should be org.as2lib.core", p1.getPackage(), _global.org.as2lib.core);
		assertSame("actual package of p2 should be org.as2lib", p2.getPackage(), _global.org.as2lib);*/
	}
	
	public function testExecuteByNameWithNullName(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		try {
			assertNull(a.executeByName(null));
			fail("expected IllegalArgumentException for 'null' name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			assertNull(a.executeByName(undefined));
			fail("expected IllegalArgumentException for 'undefined' name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		try {
			assertNull(a.executeByName());
			fail("expected IllegalArgumentException for no name");
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
		}
		
		cc.verify();
	}
	
	public function testExecuteByNameWithCachedPackageInfo(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		rc.replay();
		
		var ic:MockControl = new MockControl(PackageInfo);
		var i:PackageInfo = ic.getMock();
		ic.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(r);
		c.getPackage(_global.org.as2lib.core);
		cc.setReturnValue(i);
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(c);
		assertSame(a.executeByName("org.as2lib.core"), i);
		
		cc.verify();
		ic.verify();
		rc.verify();
	}
	
	public function testExecuteByNameWithIllegalName(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		rc.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getRoot();
		cc.setReturnValue(r);
		cc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(c);
		try {
			assertNull(a.executeByName("org.as2lib.unknownpackage"));
			fail("expected PackageNotFoundException for illegal name");
		} catch (e:org.as2lib.env.reflect.PackageNotFoundException) {
		}
		
		cc.verify();
		rc.verify();
	}
	
	public function testExecuteByName(Void):Void {
		_global.org.as2lib.core.textexecutebynamepackage = {};
		
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getFullName();
		rc.setReturnValue("_global");
		r.getPackage();
		rc.setReturnValue(_global, 2);
		r.isRoot();
		rc.setDefaultReturnValue(true);
		rc.replay();
		
		var a:PackageAlgorithm = new PackageAlgorithm();
		a.setCache(new SimpleCache(r));
		var i:PackageInfo = a.executeByName("org.as2lib.core.textexecutebynamepackage");
		assertSame(i.getName(), "textexecutebynamepackage");
		assertSame(i.getFullName(), "org.as2lib.core.textexecutebynamepackage");
		assertSame("wrong package ", i.getPackage(), _global.org.as2lib.core.textexecutebynamepackage);
		assertSame(i.getParent().getFullName(), "org.as2lib.core");
		assertSame("wrong parent package", i.getParent().getPackage(), _global.org.as2lib.core);
		assertSame("wrong root package", i.getParent().getParent().getParent().getParent(), r);
		
		rc.verify();
	}
	
}