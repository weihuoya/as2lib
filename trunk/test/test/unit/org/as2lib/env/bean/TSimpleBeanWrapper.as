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
import org.as2lib.core.BasicInterface;
import org.as2lib.core.BasicClass;
import org.as2lib.test.mock.support.SimpleMockControl;
import org.as2lib.env.bean.SimpleBeanWrapper;
import org.as2lib.env.bean.FatalBeanException;
import org.as2lib.env.bean.PropertyValue;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.bean.PropertyValueConverter;

/**
 * @author Simon Wacker
 */
class test.unit.org.as2lib.env.bean.TSimpleBeanWrapper extends TestCase {
	
	/********************************************************************************/
	/* REGISTER PROPERTY VALUE                                                      */
	/********************************************************************************/
	
	public function testRegisterPropertyValueConverterByNullTypeAndNullProperty(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		assertThrows(IllegalArgumentException, bw, bw.registerPropertyValueConverter, [null, null, new PropertyValueConverter()]);
	}
	
	public function testRegisterPropertyValueConverterByTypeViaFindPropertyValueConverter(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(PropertyValueConverter, c);
		assertSame("1", bw.findPropertyValueConverter(PropertyValueConverter, null), c);
		assertSame("2", bw.findPropertyValueConverter(PropertyValueConverter, "property"), c);
	}
	
	public function testRegisterPropertyValueConverterByTypeAndPropertyNameViaFindPropertyValueConverter(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(PropertyValueConverter, "property", c1);
		assertSame(bw.findPropertyValueConverter(PropertyValueConverter, "property"), c1);
	}
	
	/********************************************************************************/
	/* FIND PROPERTY VALUE                                                          */
	/********************************************************************************/
	
	public function testFindPropertyValueConverterByDirectType(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(PropertyValueConverter, c1);
		assertSame("1", bw.findPropertyValueConverter(PropertyValueConverter, null), c1);
		
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(MockControl, "property", c2);
		assertNull("2", bw.findPropertyValueConverter(MockControl, null));
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForSubinterface(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicInterface, c1);
		assertSame(bw.findPropertyValueConverter(PropertyValueConverter, null), c1);
	}
	
	public function testFindPropertyValueConverterWithRegisteredClassForSubclass(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicClass, c1);
		assertSame(bw.findPropertyValueConverter(SimpleMockControl, null), c1);
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForImplementationClass(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicInterface, c1);
		assertSame(bw.findPropertyValueConverter(SimpleMockControl, null), c1);
	}
	
	public function testFindPropertyValueConverterWithDirectTypeForPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(MockControl, "property", c2);
		assertSame(bw.findPropertyValueConverter(MockControl, "property"), c2);
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForSubinterfaceAndPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicInterface, "property", c2);
		assertSame(bw.findPropertyValueConverter(PropertyValueConverter, "property"), c2);
	}
	
	public function testFindPropertyValueConverterWithRegisteredClassForSubclassAndPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicClass, "property", c2);
		assertSame(bw.findPropertyValueConverter(SimpleMockControl, "property"), c2);
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForImplementationClassAndPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(BasicInterface, "property", c2);
		assertSame(bw.findPropertyValueConverter(SimpleMockControl, "property"), c2);
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForWrongInterfaceButRightPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(MockControl, "property", c2);
		assertNull(bw.findPropertyValueConverter(BasicInterface, "property"));
	}
	
	public function testFindPropertyValueConverterWithRegisteredInterfaceForWrongClassButRightPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(MockControl, "property", c2);
		assertNull(bw.findPropertyValueConverter(BasicClass, "property"));
	}
	
	public function testFindPropertyValueConverterWithRegisteredClassForWrongClassButRightPropertyName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(SimpleMockControl, "property", c2);
		assertNull(bw.findPropertyValueConverter(BasicClass, "property"));
	}
	
	public function testFindPropertyValueConverterForPropertyNameWithNullType(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		
		var c1:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(null, "property", c1);
		assertSame("1", bw.findPropertyValueConverter(MockControl, "property"), c1);
		
		var c2:PropertyValueConverter = new PropertyValueConverter();
		bw.registerPropertyValueConverter(SimpleMockControl, "property", c2);
		assertSame("2", bw.findPropertyValueConverter(null, "property"), c2);
	}
	
	/********************************************************************************/
	/* GET PROPERTY VALUE                                                           */
	/********************************************************************************/
	
	public function testGetPropertyValueWithNullAndUndefinedAndBlankStringName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		assertThrows("1", IllegalArgumentException, bw, bw.getPropertyValue, [""]);
		assertThrows("1", IllegalArgumentException, bw, bw.getPropertyValue, [null]);
		assertThrows("1", IllegalArgumentException, bw, bw.getPropertyValue, [undefined]);
	}
	
	public function testGetPropertyValueForInexistentProperty(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		// Cannot be checked because properties can just be not-defined, 'undefined' or not-initialized yet.
		// The Object.hasOwnProperty(String) sould return true if the property has the value 'undefined' or
		// has not been initialized yet, but it actually does not. It returns false if the property has not
		// been initialized, not matter if it is declared or not.
		//assertThrows("1", FatalBeanException, bw, bw.getPropertyValue, [SimpleBeanWrapper.PROPERTY_PREFIX + "inexistentProperty"]);
		assertThrows("2", FatalBeanException, bw, bw.getPropertyValue, [SimpleBeanWrapper.METHOD_PREFIX + "inexistentMethod"]);
		assertThrows("3", FatalBeanException, bw, bw.getPropertyValue, ["inexistentProperty"]);
	}
	
	public function testGetPropertyValueForSimpleNameWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo["property"] = "value";
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		var p:String = bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property");
		assertSame(p, "value");
	}
	
	public function testGetPropertyValueForSimpleNameWithMethodPrefix(Void):Void {
		var woC:MockControl = new SimpleMockControl(Object);
		var wo:Object = woC.getMock();
		wo.returnProperty();
		woC.setReturnValue("value");
		woC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		var p:String = bw.getPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "returnProperty");
		assertSame(p, "value");
		
		woC.verify(this);
	}
	
	public function testGetPropertyValueForSimpleNameWithoutPrefix(Void):Void {
		var woC:MockControl = new SimpleMockControl(Object);
		var wo:Object = woC.getMock();
		wo.getProperty();
		woC.setReturnValue("value");
		woC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		var p:String = bw.getPropertyValue("property");
		assertSame(p, "value");
		
		woC.verify(this);
	}
	
	/*public function testGetPropertyValueForSimpleNestedPropertyWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo.a = new Object();
		wo.a.b = new Object();
		wo.a.b.c = new Object();
		wo.a.b.c["property"] = "value";
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		var p:String = bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a.b.c.property");
		assertSame(p, "value");
	}
	
	public function testGetPropertyValueForSimpleNestedPropertyWithMethodPrefix(Void):Void {
		// Question:
		// Should a property or method prefix apply to ALL parts of the property path or only
		// to the one the prefix stays in front of?
	}*/
	
	public function testGetPropertyValueForPropertyKeyNumberWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo.a = [null, null, null, "value", null];
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		var p:String = bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[3]");
		assertSame(p, "value");
	}
	
	public function testGetPropertyValueForPropertyKeyNumberWithMethodPrefix(Void):Void {
		var mc:MockControl = new SimpleMockControl(Object);
		var m:Object = mc.getMock();
		m.returnProperty(3);
		mc.setReturnValue("value");
		mc.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(m);
		var p:String = bw.getPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "returnProperty[3]");
		assertSame(p, "value");
		
		mc.verify(this);
	}
	
	public function testGetPropertyValueForPropertyKeyNumberWithoutPrefix(Void):Void {
		var mc:MockControl = new SimpleMockControl(Object);
		var m:Object = mc.getMock();
		m.getProperty(3);
		mc.setReturnValue("value");
		mc.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(m);
		var p:String = bw.getPropertyValue("property[3]");
		assertSame(p, "value");
		
		mc.verify(this);
	}
	
	public function testGetPropertyValueForPropertyKeyStringWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo.a = new Object();
		wo.a["property"] = "value";
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		assertSame("1", bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[property]"), "value");
		assertSame("2", bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[\"property\"]"), "value");
		assertSame("3", bw.getPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a['property']"), "value");
	}
	
	public function testGetPropertyValueForPropertyKeyStringWithMethodPrefix(Void):Void {
		var mc:MockControl = new SimpleMockControl(Object);
		var m:Object = mc.getMock();
		m.returnProperty("key");
		mc.setReturnValue("value", 3);
		mc.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(m);
		assertSame(bw.getPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "returnProperty[key]"), "value");
		assertSame(bw.getPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "returnProperty[\"key\"]"), "value");
		assertSame(bw.getPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "returnProperty['key']"), "value");
		
		mc.verify(this);
	}
	
	public function testGetPropertyValueForPropertyKeyStringWithoutPrefix(Void):Void {
		var mc:MockControl = new SimpleMockControl(Object);
		var m:Object = mc.getMock();
		m.getProperty("key");
		mc.setReturnValue("value", 3);
		mc.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(m);
		assertSame(bw.getPropertyValue("property[key]"), "value");
		assertSame(bw.getPropertyValue("property[\"key\"]"), "value");
		assertSame(bw.getPropertyValue("property['key']"), "value");
		
		mc.verify(this);
	}
	
	/********************************************************************************/
	/* SET PROPERTY VALUE                                                           */
	/********************************************************************************/
	
	public function testSetPropertyValueByUndefinedAndNullAndBlankStringName(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		assertThrows("1", IllegalArgumentException, bw, bw.setPropertyValueByNameAndValue, ["", "value"]);
		assertThrows("2", IllegalArgumentException, bw, bw.setPropertyValueByNameAndValue, [null, "value"]);
		//assertThrows("3", IllegalArgumentException, bw, bw.setPropertyValueByNameAndValue, [undefined, "value"]);
	}
	
	public function testSetPropertyForInexistentProperty(Void):Void {
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(new Object());
		assertThrows("1", FatalBeanException, bw, bw.setPropertyValue, [SimpleBeanWrapper.METHOD_PREFIX+"inexistentMethod", "value"]);
		assertThrows("2", FatalBeanException, bw, bw.setPropertyValue, ["inexistentSetter", "value"]);
		// cannot be checked
		//assertThrows("3", FatalBeanException, bw, bw.setPropertyValue, [SimpleBeanWrapper.PROPERTY_PREFIX+"inexistentProperty", "value"]);
	}
	
	public function testSetPropertyValueBySimpleNameAndValueWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "value");
		assertSame(wo.property, "value");
	}
	
	public function testSetPropertyValueBySimpleNameAndValueWithMethodPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.putProperty("value");
		mC.setVoidCallable();
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX + "putProperty", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueBySimpleNameAndValueWithoutPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.setProperty("value");
		mC.setVoidCallable();
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue("property", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueForKeyNumberWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo.a = [0, 1, 2, 3, 4];
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[3]", 22);
		assertSame(wo.a[3], 22);
	}
	
	public function testSetPropertyValueForKeyNumberWithMethodPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.putValue(3, "value");
		mC.setVoidCallable(3);
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue[3]", "value");
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue['3']", "value");
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue[\"3\"]", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueForKeyNumberWithoutPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.setValue("3", "value");
		mC.setVoidCallable(3);
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue("value[3]", "value");
		bw.setPropertyValue("value['3']", "value");
		bw.setPropertyValue("value[\"3\"]", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueForKeyStringWithPropertyPrefix(Void):Void {
		var wo:Object = new Object();
		wo.a = new Object();
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[key1]", "value");
		assertSame("1", wo.a.key1, "value");
		bw.setPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a['key2']", "value");
		assertSame("2", wo.a.key2, "value");
		bw.setPropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "a[\"key3\"]", "value");
		assertSame("3", wo.a.key3, "value");
	}
	
	public function testSetPropertyValueForKeyStringWithMethodPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.putValue("key", "value");
		mC.setVoidCallable(3);
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue[key]", "value");
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue['key']", "value");
		bw.setPropertyValue(SimpleBeanWrapper.METHOD_PREFIX+"putValue[\"key\"]", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueForKeyStringWithoutPrefix(Void):Void {
		var mC:MockControl = new SimpleMockControl(Object);
		var wo:Object = mC.getMock();
		wo.setValue("key", "value");
		mC.setVoidCallable(3);
		mC.replay();
		
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue("value[key]", "value");
		bw.setPropertyValue("value['key']", "value");
		bw.setPropertyValue("value[\"key\"]", "value");
		
		mC.verify(this);
	}
	
	public function testSetPropertyValueWithNumberType(Void):Void {
		var wo:Object = new Object();
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "3", Number));
		assertSame("1", wo.property, 3);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "3.25", Number));
		assertSame("2", wo.property, 3.25);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "true", Number));
		assertSame("3", wo.property, 1);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "false", Number));
		assertSame("4", wo.property, 0);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", null, Number));
		assertNull("5", wo.property);
	}
	
	public function testSetPropertyValueWithBooleanType(Void):Void {
		var wo:Object = new Object();
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "0", Boolean));
		assertSame("1", wo.property, false);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "1", Boolean));
		assertSame("2", wo.property, true);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "true", Boolean));
		assertSame("3", wo.property, true);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "false", Boolean));
		assertSame("4", wo.property, false);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "", Boolean));
		assertSame("5", wo.property, false);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "muile", Boolean));
		assertSame("6", wo.property, true);
	}
	
	public function testSetPropertyValueWithClassType(Void):Void {
		var wo:Object = new Object();
		var bw:SimpleBeanWrapper = new SimpleBeanWrapper(wo);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "Object", Function));
		assertSame("1", wo.property, Object);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "test.unit.org.as2lib.env.bean.TSimpleBeanWrapper", Function));
		assertSame("2", wo.property, test.unit.org.as2lib.env.bean.TSimpleBeanWrapper);
		bw.setPropertyValue(new PropertyValue(SimpleBeanWrapper.PROPERTY_PREFIX + "property", "test.unit.NotExistingClass", Function));
		assertNull("3", wo.property);
	}
	
}