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
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberFilter;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TClassInfo_Method extends TestCase {
	
	public function testGetMethodsByFlagWithNullClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getMethods());
		assertNull(i.getMethods(false));
		assertNull(i.getMethods(true));
	}
	
	public function testGetMethodsByFlagWithType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["method1", "method2", "method3", "method4", "method5", "method6"]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(false);
		assertSame("unexpected amount of methods", m.length, 6);
		assertSame(m[0], "method1");
		assertSame(m[1], "method2");
		assertSame(m[2], "method3");
		assertSame(m[3], "method4");
		assertSame(m[4], "method5");
		assertSame(m[5], "method6");
		
		mac.verify();
		cac.verify();
	}
	
	public function testGetMethodsByFlagWithTypeAndSuperType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getMethodsByFlag(false);
		sic.setReturnValue(["method4", "method5", "method6"]);
		sic.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["method1", "method2", "method3"]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(si);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(false);
		assertSame("unexpected amount of methods", m.length, 6);
		assertSame(m[0], "method1");
		assertSame(m[1], "method2");
		assertSame(m[2], "method3");
		assertSame(m[3], "method4");
		assertSame(m[4], "method5");
		assertSame(m[5], "method6");
		
		mac.verify();
		cac.verify();
		sic.verify();
	}
	
	public function testGetMethodsByFlagWithTypeAndSuperTypeButTrueFilterFlag(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["method1", "method2", "method3"]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(true);
		assertSame("unexpected amount of methods", m.length, 3);
		assertSame(m[0], "method1");
		assertSame(m[1], "method2");
		assertSame(m[2], "method3");
		
		mac.verify();
		cac.verify();
	}
	
	public function testGetMethodsByFilterWithNullClass(Void):Void {
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		fc.replay();
		
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getMethods(f));
		
		fc.verify();
	}
	
	public function testGetMethodsByFilterWithNullFilter(Void):Void {
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(MethodInfo);
		var m4:MethodInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(MethodInfo);
		var m5:MethodInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(MethodInfo);
		var m6:MethodInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getMethodsByFlag(false);
		sic.setReturnValue([m4, m5, m6]);
		sic.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(si);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethodsByFilter(null);
		assertSame("unexpected amount of methods", m.length, 6);
		assertSame(m[0], m1);
		assertSame(m[1], m2);
		assertSame(m[2], m3);
		assertSame(m[3], m4);
		assertSame(m[4], m5);
		assertSame(m[5], m6);
		
		mac.verify();
		cac.verify();
		sic.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetMethodsByFilterWithoutSuperTypeAndFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		f.filter(null);
		fc.setReturnValue(false, 3);
		fc.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([MethodInfo]));
		f.filterSuperTypes();
		fc.setReturnValue(false);
		fc.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(f);
		assertSame("unexpected amount of methods", m.length, 3);
		assertSame(m[0], m1);
		assertSame(m[1], m2);
		assertSame(m[2], m3);
		
		mac.verify();
		cac.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetMethodsByFilterWithoutSuperTypeButWithFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(MethodInfo);
		var m4:MethodInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(MethodInfo);
		var m5:MethodInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(MethodInfo);
		var m6:MethodInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3, m4, m5, m6]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		f.filter(m1);
		fc.setReturnValue(true);
		f.filter(m2);
		fc.setReturnValue(true);
		f.filter(m3);
		fc.setReturnValue(false);
		f.filter(m4);
		fc.setReturnValue(true);
		f.filter(m5);
		fc.setReturnValue(false);
		f.filter(m6);
		fc.setReturnValue(true);
		f.filterSuperTypes();
		fc.setReturnValue(false);
		fc.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m3);
		assertSame(m[1], m5);
		
		mac.verify();
		cac.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetMethodsByFilterWithSuperTypeAndFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(MethodInfo);
		var m4:MethodInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(MethodInfo);
		var m5:MethodInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(MethodInfo);
		var m6:MethodInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getMethodsByFlag(false);
		sic.setReturnValue([m4, m5, m6]);
		sic.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(si);
		cac.replay();
		
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		f.filter(m1);
		fc.setReturnValue(true);
		f.filter(m2);
		fc.setReturnValue(true);
		f.filter(m3);
		fc.setReturnValue(false);
		f.filter(m4);
		fc.setReturnValue(true);
		f.filter(m5);
		fc.setReturnValue(false);
		f.filter(m6);
		fc.setReturnValue(true);
		f.filterSuperTypes();
		fc.setReturnValue(false);
		fc.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m3);
		assertSame(m[1], m5);
		
		mac.verify();
		cac.verify();
		sic.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetMethodsByFilterWithExcludedSuperTypeButWithFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		cac.replay();
		
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		f.filter(m1);
		fc.setReturnValue(false);
		f.filter(m2);
		fc.setReturnValue(true);
		f.filter(m3);
		fc.setReturnValue(false);
		f.filterSuperTypes();
		fc.setReturnValue(true);
		fc.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		var m:Array = i.getMethods(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m1);
		assertSame(m[1], m3);
		
		mac.verify();
		cac.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
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
		
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		var methods:Array = [m1, m2, m3];
		methods["method1"] = m1;
		methods["method2"] = m2;
		methods["method3"] = m3;
		mac.setReturnValue(methods);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getMethodByName("unkownMethod"));
		
		mac.verify();
		cac.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetMethodByNameForExistingMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		var methods:Array = [m1, m2, m3];
		methods["method1"] = m1;
		methods["method2"] = m2;
		methods["method3"] = m3;
		mac.setReturnValue(methods);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getMethodByName("method2"), m2);
		assertSame(i.getMethodByName("method3"), m3);
		assertSame(i.getMethodByName("method1"), m1);
		
		mac.verify();
		cac.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetMethodByNameForSubClassMethodOverwritingSuperClassMethod(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		var methods:Array = [m1, m2, m3];
		methods["method1"] = m1;
		methods["method2"] = m2;
		methods["method3"] = m3;
		mac.setReturnValue(methods);
		mac.replay();
		
		var sm2c:MockControl = new MockControl(MethodInfo);
		var sm2:MethodInfo = sm2c.getMock();
		sm2c.replay();
		
		var sm5c:MockControl = new MockControl(MethodInfo);
		var sm5:MethodInfo = sm5c.getMock();
		sm5c.replay();
		
		var scc:MockControl = new MockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getMethodByName("method5");
		scc.setReturnValue(sm5);
		scc.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(sc);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame(i.getMethodByName("method2"), m2);
		assertSame(i.getMethodByName("method5"), sm5);
		
		mac.verify();
		cac.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		scc.verify();
		sm2c.verify();
		sm5c.verify();
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
		
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getMethod();
		m1c.setReturnValue(function() {});
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getMethod();
		m2c.setReturnValue(function() {});
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getMethod();
		m3c.setReturnValue(function() {});
		m3c.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(null);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertNull(i.getMethodByMethod(function() {}));
		
		mac.verify();
		cac.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetMethodByMethodWithExistingMethod(Void):Void {
		var cm1:Function = function() {};
		var cm2:Function = function() {};
		var cm3:Function = function() {};
		var cm4:Function = function() {};
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(null, Type, null);
		
		var m1c:MockControl = new MockControl(MethodInfo);
		var m1:MethodInfo = m1c.getMock();
		m1.getMethod();
		m1c.setDefaultReturnValue(cm1);
		m1c.replay();
		
		var m2c:MockControl = new MockControl(MethodInfo);
		var m2:MethodInfo = m2c.getMock();
		m2.getMethod();
		m2c.setDefaultReturnValue(cm2);
		m2c.replay();
		
		var m3c:MockControl = new MockControl(MethodInfo);
		var m3:MethodInfo = m3c.getMock();
		m3.getMethod();
		m3c.setDefaultReturnValue(cm3);
		m3c.replay();
		
		var mac:MockControl = new MockControl(MethodAlgorithm);
		var ma:MethodAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var m4c:MockControl = new MockControl(MethodInfo);
		var m4:MethodInfo = m4c.getMock();
		m4.getMethod();
		m4c.setDefaultReturnValue(cm4);
		m4c.replay();
		
		var scc:MockControl = new MockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getMethodByMethod(cm4);
		scc.setReturnValue(m4);
		scc.replay();
		
		var cac:MockControl = new MockControl(ClassAlgorithm);
		var ca:ClassAlgorithm = cac.getMock();
		ca.execute(Type.prototype);
		cac.setReturnValue(sc);
		cac.replay();
		
		i.setMethodAlgorithm(ma);
		i.setClassAlgorithm(ca);
		assertSame("m3", i.getMethodByMethod(cm3), m3);
		assertSame("m1", i.getMethodByMethod(cm1), m1);
		assertSame("m2", i.getMethodByMethod(cm2), m2);
		assertSame("m4", i.getMethodByMethod(cm4), m4);
		
		scc.verify();
		mac.verify();
		cac.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
}