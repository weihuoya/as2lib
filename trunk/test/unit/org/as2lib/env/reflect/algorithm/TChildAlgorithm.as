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
import org.as2lib.env.reflect.algorithm.ChildAlgorithm;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.SimpleCache;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.TChildAlgorithm extends TestCase {
	
	public function setUp(Void):Void {
		org.as2lib.env.reflect.treflect;
		org.as2lib.env.reflect.treflect.SubClass;
		org.as2lib.env.reflect.treflect.SuperClass;
		org.as2lib.env.reflect.treflect.package0.Package0Class;
		org.as2lib.env.reflect.treflect.package1.Package1Class;
	}
	
	public function testExecuteWithNullAndUndefinedArguments(Void):Void {
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:ChildAlgorithm = new ChildAlgorithm();
		a.setCache(c);
		assertNull("execute(null) should return null", a.execute(null));
		assertNull("execute(undefined) should return null", a.execute(undefined));
		
		cc.verify();
	}
	
	public function testExecuteWithArgumentWhoseGetPackageMethodReturnsNull(Void):Void {
		var ic:MockControl = new MockControl(PackageInfo);
		var i:PackageInfo = ic.getMock();
		i.getPackage();
		ic.setReturnValue(null);
		ic.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var a:ChildAlgorithm = new ChildAlgorithm();
		a.setCache(c);
		assertNull(a.execute(i));
		
		ic.verify();
		cc.verify();
	}
	
	// crashes flex
	public function testExecute(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.getPackage();
		rc.setReturnValue(_global);
		rc.replay();
		
		var pc:MockControl = new MockControl(PackageInfo);
		var p:PackageInfo = pc.getMock();
		p.getPackage();
		pc.setReturnValue(_global.org.as2lib.env.reflect.treflect);
		pc.replay();
		
		var a:ChildAlgorithm = new ChildAlgorithm();
		a.setCache(new SimpleCache(r));
		var c:Array = a.execute(p);
		assertSame("there should be 4 children", c.length, 4);
		for (var i:Number = 0; i < c.length; i++) {
			if (c[i] instanceof ClassInfo) {
				var k:ClassInfo = c[i];
				var found:Boolean = false;
				for (var y:Number = 0; y < c["classes"].length; y++) {
					if (c["classes"][y] == k) {
						found = true;
						break;
					}
				}
				assertTrue(k.getName() + ": second storage by index failed", found);
				if (k.getName() == "SubClass") {
					assertSame("SubClass: storage by name failed", k, c["classes"][k.getName()]);
					assertSame("SubClass: wrong type", k.getType(),org.as2lib.env.reflect.treflect.SubClass);
					assertSame("SubClass: wrong parent", k.getParent(), p);
				} else if (k.getName() == "SuperClass") {
					assertSame("SuperClass: storage by name failed", k, c["classes"][k.getName()]);
					assertSame("SuperClass: wrong type", k.getType(),org.as2lib.env.reflect.treflect.SuperClass);
					assertSame("SuperClass: wrong parent", k.getParent(), p);
				} else {
					fail("unkown class '" + k + "'");
				}
			} else if (c[i] instanceof PackageInfo) {
				var j:PackageInfo = c[i];
				var found:Boolean = false;
				for (var y:Number = 0; y < c["packages"].length; y++) {
					if (c["packages"][y] == j) {
						found = true;
						break;
					}
				}
				assertTrue(k.getName() + ": second storage by index failed", found);
				if (j.getName() == "package0") {
					assertSame("package0: storage by name failed", j, c["packages"][j.getName()]);
					assertSame("package0: wrong object", j.getPackage(),org.as2lib.env.reflect.treflect.package0);
					assertSame("package0: wrong parent", j.getParent(), p);
				} else if (j.getName() == "package1") {
					assertSame("package1: storage by name failed", j, c["packages"][j.getName()]);
					assertSame("package1: wrong object", j.getPackage(),org.as2lib.env.reflect.treflect.package1);
					assertSame("package1: wrong parent", j.getParent(), p);
				} else {
					fail("unkown package '" + k + "'");
				}
			} else {
				fail("child of unkown type: " + c[i]);
			}
		}
		
		pc.verify();
		rc.verify();
	}
	
	public function testExecuteWithEmptyPackage(Void):Void {
		_global.testExecuteWithEmptyPackage = new Object();
		_global.testExecuteWithEmptyPackage.empty = new Object();
		
		var pc:MockControl = new MockControl(PackageInfo);
		var p:PackageInfo = pc.getMock();
		p.getPackage();
		pc.setReturnValue(_global.testExecuteWithEmptyPackage.empty);
		pc.replay();
		
		var a:ChildAlgorithm = new ChildAlgorithm();
		var c:Array = a.execute(p);
		assertNotNull("children array should not be null", c);
		assertSame("there should be no children", c.length, 0);
		
		pc.verify();
	}
	
}