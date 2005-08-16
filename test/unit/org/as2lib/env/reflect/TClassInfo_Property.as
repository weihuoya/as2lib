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
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.TypeMemberFilter;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;
import org.as2lib.env.reflect.MethodInfo;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.TClassInfo_Property extends TestCase {

	private var fpa:PropertyAlgorithm;
	private var fc:Cache;
	
	public function setUp() {
		fpa = ClassInfo.getPropertyAlgorithm();
		fc = ReflectConfig.getCache();
	}
	
	public function testGetPropertiesByFlagWithNullClass(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getProperties());
		assertNull(i.getProperties(true));
		assertNull(i.getProperties(false));
	}
	
	public function testGetPropertiesByFlagWithType(Void):Void {
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["property1", "property2", "property3", "property4", "property5", "property6"]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(false);
		assertSame("unexpected amount of properties", m.length, 6);
		assertSame(m[0], "property1");
		assertSame(m[1], "property2");
		assertSame(m[2], "property3");
		assertSame(m[3], "property4");
		assertSame(m[4], "property5");
		assertSame(m[5], "property6");
		
		mac.verify();
		cc.verify();
	}
	
	public function testGetPropertiesByFalseFlagWithTypeAndSuperType(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getPropertiesByFlag(false);
		sic.setReturnValue(["property4", "property5", "property6"]);
		sic.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["property1", "property2", "property3"]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClassByInstance(Type.prototype);
		cc.setReturnValue(si);
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(false);
		assertSame("unexpected amount of properties", m.length, 6);
		assertSame(m[0], "property1");
		assertSame(m[1], "property2");
		assertSame(m[2], "property3");
		assertSame(m[3], "property4");
		assertSame(m[4], "property5");
		assertSame(m[5], "property6");
		
		mac.verify();
		cc.verify();
		sic.verify();
	}
	
	public function testGetPropertiesByTrueFlagWithTypeAndSuperType(Void):Void {
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue(["property1", "property2", "property3"]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(true);
		assertSame("unexpected amount of properties", m.length, 3);
		assertSame(m[0], "property1");
		assertSame(m[1], "property2");
		assertSame(m[2], "property3");
		
		mac.verify();
		cc.verify();
	}
	
	public function testGetPropertiesByFilterWithNullClass(Void):Void {
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		fc.replay();
		
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getProperties(f));
		
		fc.verify();
	}
	
	public function testGetPropertiesByFilterWithNullFilter(Void):Void {
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(PropertyInfo);
		var m4:PropertyInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(PropertyInfo);
		var m5:PropertyInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(PropertyInfo);
		var m6:PropertyInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getPropertiesByFlag(false);
		sic.setReturnValue([m4, m5, m6]);
		sic.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClassByInstance(Type.prototype);
		cc.setReturnValue(si);
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getPropertiesByFilter(null);
		assertSame("unexpected amount of properties", m.length, 6);
		assertSame(m[0], m1);
		assertSame(m[1], m2);
		assertSame(m[2], m3);
		assertSame(m[3], m4);
		assertSame(m[4], m5);
		assertSame(m[5], m6);
		
		mac.verify();
		cc.verify();
		sic.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetPropertiesByFilterWithoutSuperTypeAndFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		var fc:MockControl = new MockControl(TypeMemberFilter);
		var f:TypeMemberFilter = fc.getMock();
		f.filter(null);
		fc.setReturnValue(false, 3);
		fc.setArgumentsMatcher(MockControl.getTypeArgumentsMatcher([PropertyInfo]));
		f.filterSuperTypes();
		fc.setReturnValue(false);
		fc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(f);
		assertSame("unexpected amount of methods", m.length, 3);
		assertSame(m[0], m1);
		assertSame(m[1], m2);
		assertSame(m[2], m3);
		
		mac.verify();
		cc.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetPropertiesByFilterWithoutSuperTypeButWithFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(PropertyInfo);
		var m4:PropertyInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(PropertyInfo);
		var m5:PropertyInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(PropertyInfo);
		var m6:PropertyInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3, m4, m5, m6]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
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
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m3);
		assertSame(m[1], m5);
		
		mac.verify();
		cc.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetPropertiesByFilterWithSuperTypeAndFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var m4c:MockControl = new MockControl(PropertyInfo);
		var m4:PropertyInfo = m4c.getMock();
		m4c.replay();
		
		var m5c:MockControl = new MockControl(PropertyInfo);
		var m5:PropertyInfo = m5c.getMock();
		m5c.replay();
		
		var m6c:MockControl = new MockControl(PropertyInfo);
		var m6:PropertyInfo = m6c.getMock();
		m6c.replay();
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var sic:MockControl = new MockControl(ClassInfo);
		var si:ClassInfo = sic.getMock();
		si.getPropertiesByFlag(false);
		sic.setReturnValue([m4, m5, m6]);
		sic.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClassByInstance(Type.prototype);
		cc.setReturnValue(si);
		cc.replay();
		
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
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m3);
		assertSame(m[1], m5);
		
		mac.verify();
		cc.verify();
		sic.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		m4c.verify();
		m5c.verify();
		m6c.verify();
	}
	
	public function testGetPropertiesByFilterWithExcludedSuperTypeButWithFilterFunctionality(Void):Void {
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
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
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		var m:Array = i.getProperties(f);
		assertSame("unexpected amount of methods", m.length, 2);
		assertSame(m[0], m1);
		assertSame(m[1], m3);
		
		mac.verify();
		cc.verify();
		fc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetPropertyByNameForClassWithUnknownProperties(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getPropertyByName("unknown"));
	}
	
	public function testGetPropertyByNameWithNullName(Void):Void {
		var i:ClassInfo = new ClassInfo(function() {}, null, null);
		assertNull(i.getPropertyByName(null));
	}
	
	public function testGetPropertyByNameWithUnknownProperty(Void):Void {
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		var properties:Array = [m1, m2, m3];
		properties["property1"] = m1;
		properties["property2"] = m2;
		properties["property3"] = m3;
		mac.setReturnValue(properties);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		assertNull(i.getPropertyByName("unkownProperty"));
		
		mac.verify();
		cc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetPropertyByNameForExistingProperty(Void):Void {
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		var properties:Array = [m1, m2, m3];
		properties["property1"] = m1;
		properties["property2"] = m2;
		properties["property3"] = m3;
		mac.setReturnValue(properties);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		assertSame(i.getPropertyByName("property2"), m2);
		assertSame(i.getPropertyByName("property3"), m3);
		assertSame(i.getPropertyByName("property1"), m1);
		
		mac.verify();
		cc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetPropertyByNameForSubClassMethodOverwritingSuperClassProperty(Void):Void {
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3c.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		var properties:Array = [m1, m2, m3];
		properties["property1"] = m1;
		properties["property2"] = m2;
		properties["property3"] = m3;
		mac.setReturnValue(properties);
		mac.replay();
		
		var sm2c:MockControl = new MockControl(PropertyInfo);
		var sm2:PropertyInfo = sm2c.getMock();
		sm2c.replay();
		
		var scc:MockControl = new MockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getPropertyByName("property5");
		scc.setReturnValue(sm2);
		scc.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClassByInstance(Type.prototype);
		cc.setReturnValue(sc);
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		assertSame(i.getPropertyByName("property2"), m2);
		assertSame(i.getPropertyByName("property5"), sm2);
		
		mac.verify();
		cc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
		scc.verify();
		sm2c.verify();
	}
	
	public function testGetPropertyByPropertyWithNullProperty(Void):Void {
		var i:ClassInfo = new ClassInfo(function() {}, null, null);
		assertNull(i.getPropertyByProperty(null));
	}
	
	public function testGetPropertyByPropertyForClassWithUnknownProperties(Void):Void {
		var i:ClassInfo = new ClassInfo(null, null, null);
		assertNull(i.getPropertyByProperty(function() {}));
	}
	
	public function testGetPropertyByPropertyWithUnknownProperty(Void):Void {
		var Type:Function = function() {};
		Type.prototype.__proto__ = null;
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var gp1c:MockControl = new MockControl(MethodInfo);
		var gp1:MethodInfo = gp1c.getMock();
		gp1.getMethod();
		gp1c.setReturnValue(function() {});
		gp1c.replay();
		
		var sp1c:MockControl = new MockControl(MethodInfo);
		var sp1:MethodInfo = sp1c.getMock();
		sp1.getMethod();
		sp1c.setReturnValue(function() {});
		sp1c.replay();
		
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getGetter();
		m1c.setReturnValue(gp1);
		m1.getSetter();
		m1c.setReturnValue(sp1);
		m1c.replay();
		
		var gp2c:MockControl = new MockControl(MethodInfo);
		var gp2:MethodInfo = gp2c.getMock();
		gp2.getMethod();
		gp2c.setReturnValue(function() {});
		gp2c.replay();
		
		var sp2c:MockControl = new MockControl(MethodInfo);
		var sp2:MethodInfo = sp2c.getMock();
		sp2.getMethod();
		sp2c.setReturnValue(function() {});
		sp2c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getGetter();
		m2c.setReturnValue(gp2);
		m2.getSetter();
		m2c.setReturnValue(sp2);
		m2c.replay();
		
		var gp3c:MockControl = new MockControl(MethodInfo);
		var gp3:MethodInfo = gp3c.getMock();
		gp3.getMethod();
		gp3c.setReturnValue(function() {});
		gp3c.replay();
		
		var sp3c:MockControl = new MockControl(MethodInfo);
		var sp3:MethodInfo = sp3c.getMock();
		sp3.getMethod();
		sp3c.setReturnValue(function() {});
		sp3c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getGetter();
		m3c.setReturnValue(gp3);
		m3.getSetter();
		m3c.setReturnValue(sp3);
		m3c.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		assertNull(i.getPropertyByProperty(function() {}));
		
		mac.verify();
		cc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function testGetPropertyByPropertyWithExistingProperty(Void):Void {
		var cm1:Function = function() {};
		var cm2:Function = function() {};
		var cm3:Function = function() {};
		var cm4:Function = function() {};
		
		var Type:Function = function() {};
		var i:ClassInfo = new ClassInfo(Type, null, null);
		
		var gp1c:MockControl = new MockControl(MethodInfo);
		var gp1:MethodInfo = gp1c.getMock();
		gp1.getMethod();
		gp1c.setDefaultReturnValue(cm1);
		gp1c.replay();
		
		var gp2c:MockControl = new MockControl(MethodInfo);
		var gp2:MethodInfo = gp2c.getMock();
		gp2.getMethod();
		gp2c.setDefaultReturnValue(cm2);
		gp2c.replay();
		
		var sp1c:MockControl = new MockControl(MethodInfo);
		var sp1:MethodInfo = sp1c.getMock();
		sp1.getMethod();
		sp1c.setDefaultReturnValue(cm3);
		sp1c.replay();
		
		var m1c:MockControl = new MockControl(PropertyInfo);
		var m1:PropertyInfo = m1c.getMock();
		m1.getGetter();
		m1c.setDefaultReturnValue(gp1);
		m1.getSetter();
		m1c.setDefaultReturnValue(null);
		m1c.replay();
		
		var m2c:MockControl = new MockControl(PropertyInfo);
		var m2:PropertyInfo = m2c.getMock();
		m2.getGetter();
		m2c.setDefaultReturnValue(gp2);
		m2.getSetter();
		m2c.setDefaultReturnValue(null);
		m2c.replay();
		
		var m3c:MockControl = new MockControl(PropertyInfo);
		var m3:PropertyInfo = m3c.getMock();
		m3.getGetter();
		m3c.setDefaultReturnValue(null);
		m3.getSetter();
		m3c.setDefaultReturnValue(sp1);
		m3c.replay();
		
		var mac:MockControl = new MockControl(PropertyAlgorithm);
		var ma:PropertyAlgorithm = mac.getMock();
		ma.execute(i);
		mac.setReturnValue([m1, m2, m3]);
		mac.replay();
		
		var sm4c:MockControl = new MockControl(PropertyInfo);
		var sm4:PropertyInfo = sm4c.getMock();
		sm4c.replay();
		
		var scc:MockControl = new MockControl(ClassInfo);
		var sc:ClassInfo = scc.getMock();
		sc.getPropertyByProperty(cm4);
		scc.setReturnValue(sm4);
		scc.replay();
		
		var cc:MockControl = new MockControl(Cache);
		var c:Cache = cc.getMock();
		c.getClassByInstance(Type.prototype);
		cc.setReturnValue(sc);
		cc.replay();
		
		ClassInfo.setPropertyAlgorithm(ma);
		ReflectConfig.setCache(c);
		assertSame(i.getPropertyByProperty(cm3), m3);
		assertSame(i.getPropertyByProperty(cm1), m1);
		assertSame(i.getPropertyByProperty(cm2), m2);
		assertSame(i.getPropertyByProperty(cm4), sm4);
		
		mac.verify();
		cc.verify();
		sm4c.verify();
		scc.verify();
		m1c.verify();
		m2c.verify();
		m3c.verify();
	}
	
	public function tearDown() {
		ClassInfo.setPropertyAlgorithm(fpa);
		ReflectConfig.setCache(fc);
	}
	
}