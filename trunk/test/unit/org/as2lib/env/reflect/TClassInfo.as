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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.test.mock.MockControl;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TClassInfo extends TestCase {
	
	private var formerClassAlgorithm:ClassAlgorithm;
	
	public function setUp() {
		formerClassAlgorithm = ClassInfo.getClassAlgorithm();
	}
	
	public function testNewWithNullArguments(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull("name not null", i.getName());
		assertNull("type not null", i.getType());
		assertNull("package not null", i.getPackage());
	}
	
	public function testNewWithRealArguments(Void):Void {
		var pc:MockControl = new MockControl(PackageInfo);
		var p:PackageInfo = pc.getMock();
		pc.replay();
		
		var MyClass:Function = function() {};
		var i:ClassInfo = new ClassInfo(MyClass, "MyClass", p);
		assertSame("wrong name", i.getName(), "MyClass");
		assertSame("wrong type", i.getType(), MyClass);
		assertSame("wrong package", i.getPackage(), p);
		
		pc.verify();
	}
	
	public function testGetFullNameWithNullName(Void):Void {
		//////////
		// TODO //
		//////////
	}
	
	public function testGetFullNameWithNullParent(Void):Void {
		var i:ClassInfo = new ClassInfo(null, "MyClass", null);
		assertSame(i.getFullName(), "MyClass");
	}
	
	public function testGetFullNameWithRootAsParent(Void):Void {
		var rc:MockControl = new MockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(true);
		rc.replay();
		
		var i:ClassInfo = new ClassInfo(null, "MyClass", r);
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
		
		var i:ClassInfo = new ClassInfo(null, "MyClass", r);
		assertSame(i.getFullName(), "org.as2lib.mypackage.MyClass");
		
		rc.verify();
	}
	
	public function testGetConstructorWithNullType(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getConstructor());
	}
	
	public function testGetConstructorWithDefinedType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		var ci:MethodInfo = i.getConstructor();
		assertNotEmpty("returned constructor info should not be null or undefined", ci);
		assertSame(ci.getMethod(), Type);
	}
	
	public function testGetSuperTypeForObject(Void):Void {
		var i:ClassInfo = new ClassInfo(Object, null, null);
		assertNull("Object has no super type.", i.getSuperType());
	}
	
	public function testGetSuperTypeForClassWithNotDefinedPrototype(Void):Void {
		var Type:Function = function() {};
		
		Type.prototype = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		assertNull("prototype is set to null", i.getSuperType());
		
		Type.prototype = undefined;
		i = new ClassInfo(Type, null, null);
		assertNull("prototype is set to undefined", i.getSuperType());
	}
	
	/*public function testGetSuperTypeForClassWithSuperClass(Void):Void {
		var Type:Function = function() {};
		
		var ic:MockControl = new MockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		ic.replay();
		
		var ac:MockControl = new MockControl(ClassAlgorithm);
		var a:ClassAlgorithm = ac.getMock();
		a.execute(Type.prototype);
		ac.setReturnValue(i);
		ac.replay();
		var o:ClassInfo = new ClassInfo(Type, null, null);
		ClassInfo.setClassAlgorithm(a);
		assertSame(o.getSuperType(), i);
		
		ic.verify();
		ac.verify();
	}*/
	
	/*public function testNewInstanceWithNotDefinedClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull("class == null", i.newInstance(null));
		
		i = new ClassInfo(null, undefined, null);
		assertNull("class == undefined", i.newInstance(null));
	}
	
	public function testNewInstanceWithNullAndUndefinedArgument(Void):Void {
		var parent:TestCase = this;
		var Type:Function = function() {
			this.invoked = true;
			parent["assertSame"](arguments.length, 0);
		};
		
		var i:ClassInfo = new ClassInfo(Type, null, null);
		var o = i.newInstance(null)
		assertNotNull(o);
		assertTrue(o.invoked);
		
		o.invoked = false;
		
		var o2 = i.newInstance(undefined)
		assertNotNull(o2);
		assertTrue(o2.invoked);
		assertNotSame(o, o2);
	}
	
	public function testNewInstanceWithMultipleArguments(Void):Void {
		var arg3 = new Object();
		var parent:TestCase = this;
		var Type:Function = function() {
			this.invoked = true;
			parent["assertSame"](arguments.length, 3);
			parent["assertSame"](arguments[0], "arg1");
			parent["assertSame"](arguments[1], 2);
			parent["assertSame"](arguments[2], arg3);
		};
		
		var i:ClassInfo = new ClassInfo(Type, null, null);
		var o = i.newInstance(["arg1", 2, arg3])
		assertNotNull(o);
		assertTrue(o.invoked);
	}*/
	
	public function tearDown() {
		ClassInfo.setClassAlgorithm(formerClassAlgorithm);
	}
}