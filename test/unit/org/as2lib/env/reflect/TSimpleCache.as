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
import org.as2lib.env.reflect.SimpleCache;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TSimpleCache extends TestCase {
	
	public function testGetClassWithNullAndUndefinedArgument(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertNull("c.getClass(null) should return null", c.getClass(null));
		assertNull("c.getClass(undefined) should return null", c.getClass(undefined));
	}
	
	public function testGetClassWithNotStoredClassInfoByObject(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertEmpty(c.getClass(new Object()));
	}
	
	public function testGetClassWithNotStoredClassInfoByClass(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertEmpty(c.getClass(Object));
	}
	
	public function testGetClassWithCachedClassInfo(Void):Void {
		var Type:Function = function(Void) {
		}
		
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		i.getType();
		ic.setReturnValue(Type);
		ic.replay();
		
		var c:SimpleCache = new SimpleCache();
		assertSame("added and returned ClassInfo should be the same", c.addClass(i), i);
		assertNull("no ClassInfo regitered for this class", c.getClass(function() {}));
		assertNull("no ClassInfo regitered for this instance", c.getClass(new function() {}()));
		assertSame("returned ClassInfo should match the added one: c.getClass(new Type())", c.getClass(new Type()), i);
		assertSame("returned ClassInfo should match the added one: c.getClass(Type)", c.getClass(Type), i);
		
		ic.verify();
	}
	
	public function testGetClassWithCachedSuperClassInfo(Void):Void {
		var SuperType:Function = function(Void) {
		}
		var SubType:Function = function(Void) {
		}
		SubType.prototype = new SuperType();
		
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		i.getType();
		ic.setReturnValue(SuperType);
		ic.replay();
		
		var c:SimpleCache = new SimpleCache();
		assertSame("added and returned ClassInfo should be the same", c.addClass(i), i);
		assertNull("class info is only registerd for super class: c.getClass(new SubType())", c.getClass(new SubType()));
		assertNull("class info is only registerd for super class: c.getClass(SubType)", c.getClass(SubType));
		
		ic.verify();
	}
	
	public function testGetPackageWithNullAndUndefinedArgument(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertNull("c.getPackage(null) should return null", c.getPackage(null));
		assertNull("c.getPackage(undefined) should return null", c.getPackage(undefined));
	}
	
	public function testGetPackageWithNotStoredPackageInfo(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertEmpty(c.getPackage(new Object()));
	}
	
	public function testGetPackageWithCachedPackageInfo(Void):Void {
		var p:Object = new Object();
		
		var ic:MockControl = new MockControl(PackageInfo);
		var i:PackageInfo = ic.getMock();
		i.getPackage();
		ic.setReturnValue(p);
		ic.replay();
		
		var c:SimpleCache = new SimpleCache();
		assertSame("added and returned package info should be the same", c.addPackage(i), i);
		assertEmpty("not package info registered for this package", c.getPackage(new Object()));
		assertSame("returned package info should match added one", c.getPackage(p), i);
		
		ic.verify();
	}
	
	public function testAddClassWithNullAndUndefinedArgument(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertNull(c.addClass(null));
		assertNull(c.addClass(undefined));
	}
	
	public function testAddPackageWithNullAndUndefinedArgument(Void):Void {
		var c:SimpleCache = new SimpleCache();
		assertNull(c.addPackage(null));
		assertNull(c.addPackage(undefined));
	}
	
	public function testReleaseAllForPackages(Void):Void {
		var p:Object = new Object();
		
		var ic:MockControl = new MockControl(PackageInfo);
		var i:PackageInfo = ic.getMock();
		i.getPackage();
		ic.setReturnValue(p, 2);
		ic.replay();
		
		var c:SimpleCache = new SimpleCache();
		assertSame("added and returned package info should be the same", c.addPackage(i), i);
		assertEmpty("not package info registered for this package", c.getPackage(new Object()));
		assertSame("returned package info should match added one", c.getPackage(p), i);
		
		c.releaseAll();
		
		assertEmpty("package should be released", c.getPackage(p));
		
		c.addPackage(i);
		assertSame("returned package info should match added one", c.getPackage(p), i);
		
		ic.verify();
	}
	
	public function testReleaseAllForClasses(Void):Void {
		var Type:Function = function(Void) {
		}
		
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		i.getType();
		ic.setReturnValue(Type, 2);
		ic.replay();
		
		var c:SimpleCache = new SimpleCache();
		assertSame("added and returned ClassInfo should be the same", c.addClass(i), i);
		assertNull("no class info regitered for this class", c.getClass(function() {}));
		assertNull("no class info regitered for this instance", c.getClass(new function() {}()));
		assertSame("returned ClassInfo should match the added one: c.getClass(new Type())", c.getClass(new Type()), i);
		assertSame("returned ClassInfo should match the added one: c.getClass(Type)", c.getClass(Type), i);
		
		c.releaseAll();
		
		assertEmpty("class should be released", c.getClass(new Type()));
		assertEmpty("class should be released", c.getClass(Type));
		
		c.addClass(i);
		assertSame("returned ClassInfo should match the added one: c.getClass(new Type())", c.getClass(new Type()), i);
		assertSame("returned ClassInfo should match the added one: c.getClass(Type)", c.getClass(Type), i);
		
		ic.verify();
	}
	
}