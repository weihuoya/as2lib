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
import org.as2lib.test.mock.support.TypeArgumentsMatcher;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.CompositeMemberInfo;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.reflect.algorithm.TPackageAlgorithm extends TestCase {
	
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
	
	public function testExecuteWithStoredPackageInfo(Void):Void {
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
	}
	
	public function testExecuteWithUnknownPackage(Void):Void {
		var p:Object = new Object();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getPackage(null);
		cc.setArgumentsMatcher(new TypeArgumentsMatcher([Object]));
		cc.setDefaultReturnValue(null);
		c.getRoot();
		cc.setReturnValue(ReflectUtil.getRootInfo());
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
		var pp1:CompositeMemberInfo = a.execute(_global.org.as2lib.core);
		var pp2:CompositeMemberInfo = a.execute(_global.org.as2lib);
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
		assertSame("actual package of p2 should be org.as2lib", p2.getPackage(), _global.org.as2lib);
	}
	
}