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
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.reflect.TClassInfo extends TestCase {
	
	public function testNewWithNullArguments(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull("name not null", i.getName());
		assertNull("type not null", i.getType());
		assertNull("parent not null", i.getParent());
	}
	
	public function testNewWithRealArguments(Void):Void {
		var pc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var p:PackageInfo = pc.getMock();
		pc.replay();
		
		var MyClass:Function = function() {};
		var i:ClassInfo = new ClassInfo("MyClass", MyClass, p);
		assertSame("wrong name", i.getName(), "MyClass");
		assertSame("wrong type", i.getType(), MyClass);
		assertSame("wrong parent", i.getParent(), p);
		
		pc.verify(this);
	}
	
	public function testGetFullNameWithNullName(Void):Void {
		//////////
		// TODO //
		//////////
	}
	
	public function testGetFullNameWithNullParent(Void):Void {
		var i:ClassInfo = new ClassInfo("MyClass", null, null);
		assertSame(i.getFullName(), "MyClass");
	}
	
	public function testGetFullNameWithRootAsParent(Void):Void {
		var rc:SimpleMockControl = new SimpleMockControl(PackageInfo);
		var r:PackageInfo = rc.getMock();
		r.isRoot();
		rc.setReturnValue(true);
		rc.replay();
		
		var i:ClassInfo = new ClassInfo("MyClass", null, r);
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
		
		var i:ClassInfo = new ClassInfo("MyClass", null, r);
		assertSame(i.getFullName(), "org.as2lib.mypackage.MyClass");
		
		rc.verify(this);
	}
	
	public function testGetConstructorWithNullType(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getConstructor());
	}
	
	public function testGetConstructorWithDefinedType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		var ci:MethodInfo = i.getConstructor();
		assertNotEmpty("returned constructor info should not be null or undefined", ci);
		assertSame(ci.getMethod(), Type);
	}
	
	public function testGetSuperTypeForObject(Void):Void {
		var i:ClassInfo = new ClassInfo(null, Object, null);
		assertNull("Object has no super type.", i.getSuperType());
	}
	
	public function testGetSuperTypeForClassWithNotDefinedPrototype(Void):Void {
		var Type:Function = function() {};
		
		Type.prototype = null;
		var i:ClassInfo = new ClassInfo(null, Type, null);
		assertNull("prototype is set to null", i.getSuperType());
		
		Type.prototype = undefined;
		var i:ClassInfo = new ClassInfo(null, Type, null);
		assertNull("prototype is set to undefined", i.getSuperType());
	}
	
	public function testGetSuperTypeForClassWithSuperClass(Void):Void {
		var Type:Function = function() {};
		
		var ic:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var i:ClassInfo = ic.getMock();
		ic.replay();
		
		var ac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var a:ClassAlgorithm = ac.getMock();
		a.execute(Type.prototype);
		ac.setReturnValue(i);
		ac.replay();
		
		var o:ClassInfo = new ClassInfo(null, Type, null);
		o.setClassAlgorithm(a);
		assertSame(o.getSuperType(), i);
		
		ic.verify(this);
		ac.verify(this);
	}
	
	public function testNewInstanceWithNotDefinedClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull("class == null", i.newInstance(null));
		
		var i:ClassInfo = new ClassInfo(null, undefined, null);
		assertNull("class == undefined", i.newInstance(null));
	}
	
	public function testNewInstanceWithNullAndUndefinedArgument(Void):Void {
		var parent:TestCase = this;
		var Type:Function = function() {
			this.invoked = true;
			parent.assertSame(arguments.length, 0);
		};
		
		var i:ClassInfo = new ClassInfo(null, Type, null);
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
			parent.assertSame(arguments.length, 3);
			parent.assertSame(arguments[0], "arg1");
			parent.assertSame(arguments[1], 2);
			parent.assertSame(arguments[2], arg3);
		};
		
		var i:ClassInfo = new ClassInfo(null, Type, null);
		var o = i.newInstance(["arg1", 2, arg3])
		assertNotNull(o);
		assertTrue(o.invoked);
	}
	
	public function testGetMethodsWithNullClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getMethods());
	}
	
	public function testGetMethodsWithType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["method1", "method2", "method3", "method4", "method5", "method6"]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods();
		assertSame("unexpected amount of methods", m.length, 6);
		assertSame(m[0], "method1");
		assertSame(m[1], "method2");
		assertSame(m[2], "method3");
		assertSame(m[3], "method4");
		assertSame(m[4], "method5");
		assertSame(m[5], "method6");
		
		mac.verify(this);
		cac.verify(this);
	}
	
	public function testGetMethodsWithTypeAndSuperType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var sic:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getMethods();
		sic.setReturnValue(["method4", "method5", "method6"]);
		sic.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["method1", "method2", "method3"]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(si);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods();
		assertSame("unexpected amount of methods", m.length, 6);
		assertSame(m[0], "method1");
		assertSame(m[1], "method2");
		assertSame(m[2], "method3");
		assertSame(m[3], "method4");
		assertSame(m[4], "method5");
		assertSame(m[5], "method6");
		
		mac.verify(this);
		cac.verify(this);
		sic.verify(this);
	}
	
	public function testGetMethodByNameForClassWithUnknownMethods(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getMethodByName("unknown"));
	}
	
	public function testGetMethodByNameWithNullName(Void):Void {
		var i:ClassInfo = new ClassInfo(null, function() {}, null);
		assertNull(i.getMethodByName(null));
	}
	
	public function testGetMethodByNameWithUnknownMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getName();
		m1c.setReturnValue("method1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getName();
		m2c.setReturnValue("method2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getName();
		m3c.setReturnValue("method3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getMethodByName("unkownMethod"));
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetMethodByNameForExistingMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getName();
		m1c.setDefaultReturnValue("method1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getName();
		m2c.setDefaultReturnValue("method2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getName();
		m3c.setDefaultReturnValue("method3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getMethodByName("method2"), m2);
		assertSame(i.getMethodByName("method3"), m3);
		assertSame(i.getMethodByName("method1"), m1);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetMethodByNameForSubClassMethodOverwritingSuperClassMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getName();
		m1c.setDefaultReturnValue("method1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getName();
		m2c.setDefaultReturnValue("method2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getName();
		m3c.setDefaultReturnValue("method3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var sm2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var sm2:MethodInfo = sm2c.getMock();
		sm2.getName();
		sm2c.setDefaultReturnValue("method2");
		sm2c.replay();
		
		var scc:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getMethods();
		scc.setReturnValue(sm2);
		scc.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(sc);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getMethodByName("method2"), m2);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
		scc.verify(this);
		sm2c.verify(this);
	}
	
	public function testGetMethodByMethodWithNullMethod(Void):Void {
		var i:ClassInfo = new ClassInfo(null, function() {}, null);
		assertNull(i.getMethodByMethod(null));
	}
	
	public function testGetMethodByMethodForClassWithUnknownMethods(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getMethodByMethod(function() {}));
	}
	
	public function testGetMethodByMethodWithUnknownMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getMethod();
		m1c.setReturnValue(function() {});
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getMethod();
		m2c.setReturnValue(function() {});
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getMethod();
		m3c.setReturnValue(function() {});
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getMethodByMethod(function() {}));
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetMethodByMethodWithExistingMethod(Void):Void {
		var cm1:Function = function() {};
		var cm2:Function = function() {};
		var cm3:Function = function() {};
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getMethod();
		m1c.setDefaultReturnValue(cm1);
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getMethod();
		m2c.setDefaultReturnValue(cm2);
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getMethod();
		m3c.setDefaultReturnValue(cm3);
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getMethodByMethod(cm3), m3);
		assertSame(i.getMethodByMethod(cm1), m1);
		assertSame(i.getMethodByMethod(cm2), m2);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function testGetPropertiesWithNullClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getProperties());
	}
	
	public function testGetPropertiesWithType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["property1", "property2", "property3", "property4", "property5", "property6"]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getProperties();
		assertSame("unexpected amount of properties", m.length, 6);
		assertSame(m[0], "property1");
		assertSame(m[1], "property2");
		assertSame(m[2], "property3");
		assertSame(m[3], "property4");
		assertSame(m[4], "property5");
		assertSame(m[5], "property6");
		
		mac.verify(this);
		cac.verify(this);
	}
	
	public function testGetPropertiesWithTypeAndSuperType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var sic:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getProperties();
		sic.setReturnValue(["property4", "property5", "property6"]);
		sic.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["property1", "property2", "property3"]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(si);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getProperties();
		assertSame("unexpected amount of properties", m.length, 6);
		assertSame(m[0], "property1");
		assertSame(m[1], "property2");
		assertSame(m[2], "property3");
		assertSame(m[3], "property4");
		assertSame(m[4], "property5");
		assertSame(m[5], "property6");
		
		mac.verify(this);
		cac.verify(this);
		sic.verify(this);
	}
	
	public function testGetPropertiesByNameForClassWithUnknownProperties(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getPropertyByName("unknown"));
	}
	
	public function testGetPropertyByNameWithNullName(Void):Void {
		var i:ClassInfo = new ClassInfo(null, function() {}, null);
		assertNull(i.getPropertyByName(null));
	}
	
	public function testGetPropertyByNameWithUnknownProperty(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getName();
		m1c.setReturnValue("property1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getName();
		m2c.setReturnValue("property2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getName();
		m3c.setReturnValue("property3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getPropertyByName("unkownProperty"));
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetPropertyByNameForExistingProperty(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getName();
		m1c.setDefaultReturnValue("property1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getName();
		m2c.setDefaultReturnValue("property2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getName();
		m3c.setDefaultReturnValue("property3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getPropertyByName("property2"), m2);
		assertSame(i.getPropertyByName("property3"), m3);
		assertSame(i.getPropertyByName("property1"), m1);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetPropertyByNameForSubClassMethodOverwritingSuperClassProperty(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getName();
		m1c.setDefaultReturnValue("property1");
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getName();
		m2c.setDefaultReturnValue("property2");
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getName();
		m3c.setDefaultReturnValue("property3");
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var sm2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var sm2:PropertyInfo = sm2c.getMock();
		sm2.getName();
		sm2c.setDefaultReturnValue("property2");
		sm2c.replay();
		
		var scc:SimpleMockControl = new SimpleMockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getProperties();
		scc.setReturnValue(sm2);
		scc.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(sc);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getPropertyByName("property2"), m2);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
		scc.verify(this);
		sm2c.verify(this);
	}
	
	public function testGetPropertyByPropertyWithNullProperty(Void):Void {
		var i:ClassInfo = new ClassInfo(null, function() {}, null);
		assertNull(i.getPropertyByProperty(null));
	}
	
	public function testGetPropertyByPropertyForClassWithUnknownProperties(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getPropertyByProperty(function() {}));
	}
	
	public function testGetPropertyByPropertyWithUnknownProperty(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getGetter();
		m1c.setReturnValue(function() {});
		m1.getSetter();
		m1c.setReturnValue(function() {});
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getGetter();
		m2c.setReturnValue(function() {});
		m2.getSetter();
		m2c.setReturnValue(function() {});
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getGetter();
		m3c.setReturnValue(function() {});
		m3.getSetter();
		m3c.setReturnValue(function() {});
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getPropertyByProperty(function() {}));
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
	public function testGetPropertyByPropertyWithExistingProperty(Void):Void {
		var cm1:Function = function() {};
		var cm2:Function = function() {};
		var cm3:Function = function() {};
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getGetter();
		m1c.setDefaultReturnValue(cm1);
		m1.getSetter();
		m1c.setDefaultReturnValue(null);
		m1c.replay();
		
		var m2c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getGetter();
		m2c.setDefaultReturnValue(cm2);
		m2.getSetter();
		m2c.setDefaultReturnValue(null);
		m2c.replay();
		
		var m3c:SimpleMockControl = new SimpleMockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getGetter();
		m3c.setDefaultReturnValue(null);
		m3.getSetter();
		m3c.setDefaultReturnValue(cm3);
		m3c.replay();
		
		var mac:SimpleMockControl = new SimpleMockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:SimpleMockControl = new SimpleMockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setPropertyAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getPropertyByProperty(cm3), m3);
		assertSame(i.getPropertyByProperty(cm1), m1);
		assertSame(i.getPropertyByProperty(cm2), m2);
		
		mac.verify(this);
		cac.verify(this);
		m1c.verify(this);
		m2c.verify(this);
		m3c.verify(this);
	}
	
}