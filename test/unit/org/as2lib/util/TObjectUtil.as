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

import org.as2lib.core.BasicClass;
import org.as2lib.core.BasicInterface;
import org.as2lib.core.BasicMovieClip;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.Test;
import org.as2lib.util.ObjectUtil;
import org.as2lib.app.exec.Call;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.util.ExtendedString;
import org.as2lib.util.ExtendedBoolean;
import org.as2lib.util.ExtendedNumber;

/**
 * Testcase for massive ObjectUtil testing.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.util.TObjectUtil extends TestCase {
	
	/**
	 * Tests if .getChildName really returns the childname or returns null.
	 */
	/*public function testGetChildName(Void):Void {
		var complexObject:Object = new Object();
		complexObject.test = "c";
		
		var inObject:Object = new Object();
		inObject.test = "b";
		inObject.test2 = complexObject;
		
		assertNull("If you search for nothing, then it should return null", ObjectUtil.getChildName(inObject));
		assertNull("If you search for something, but nothing was found, it should return null", ObjectUtil.getChildName(inObject, "a"));
		assertEquals("The childname of 'b' should be test", ObjectUtil.getChildName(inObject, "b"), "test");
		assertEquals("The childname of 'complexObject' should be test2", ObjectUtil.getChildName(inObject, complexObject), "test2");
		assertNull("The Subchild 'c' shoud not be found!", ObjectUtil.getChildName(inObject, "c"));
	}*/
	
	/**
	 * Compares the types of different cases.
	 */
	public function testTypesMatch(Void):Void {
		var test1:String = "String";
		var test2:Number = 0;
		var test3:Boolean = true;
		var test4:Object = null;
		var test5:Object = undefined;
		var test6:Object = {};
		var test7:BasicClass = new BasicClass();
		var test8:Function = function() {};
		var test9:BasicMovieClip = new BasicMovieClip();
		
		// Positive cases.
		assertTrue("'test1' is a string, so it should match a String", ObjectUtil.typesMatch(test1, String));
		assertTrue("'test1' is a string, so it should match a Object", ObjectUtil.typesMatch(test1, Object));
		assertTrue("'test2' is a number, so it should match a Number", ObjectUtil.typesMatch(test2, Number));
		assertTrue("'test2' is a number, so it should match a Object", ObjectUtil.typesMatch(test2, Object));
		assertTrue("'test3' is a boolean, so it should match a Boolean", ObjectUtil.typesMatch(test3, Boolean));
		assertTrue("'test4' is null, it has to match a Object", ObjectUtil.typesMatch(test4, Object));
		assertTrue("'test5' is undefined, it has to match Object", ObjectUtil.typesMatch(test5, Object));
		assertTrue("'test6' is a object, it has to match Object", ObjectUtil.typesMatch(test6, Object));
		assertTrue("'test7' is a complex object, it has to match BasicClass", ObjectUtil.typesMatch(test7, BasicClass));
		assertTrue("'test7' is a complex object, it has to match BasicInterface", ObjectUtil.typesMatch(test7, BasicInterface));
		assertTrue("'test7' is a complex object, it has to match Object", ObjectUtil.typesMatch(test7, Object));
		assertTrue("'test8' is a function, it has to match Function", ObjectUtil.typesMatch(test8, Function));
		assertTrue("'test8' is a function, it has to match Object", ObjectUtil.typesMatch(test8, Object));
		assertTrue("'test9' is a extended MovieClip, it has to match MovieClip", ObjectUtil.typesMatch(test9, MovieClip));
		assertTrue("'test9' is a extended MovieClip, it has to match BasicMovieClip", ObjectUtil.typesMatch(test9, BasicMovieClip));
		assertTrue("'test9' is a extended MovieClip, it has to match BasicInterface", ObjectUtil.typesMatch(test9, BasicInterface));
		assertTrue("'test9' is a extended MovieClip, it has to match Object", ObjectUtil.typesMatch(test9, Object));
		
		// Negative cases.
		assertFalse("'test1' is a string, so it should not match to Number", ObjectUtil.typesMatch(test1, Number));
		assertFalse("'test1' is a string, so it should not match 'null'", ObjectUtil.typesMatch(test1, null));
		assertFalse("'test1' is a string, so it should not match 'undefined'", ObjectUtil.typesMatch(test1, undefined));
		assertFalse("'test2' is a number, so it should not match to String", ObjectUtil.typesMatch(test2, String));
		assertFalse("'test2' is a number, so it should not match 'null'", ObjectUtil.typesMatch(test2, null));
		assertFalse("'test2' is a number, so it should not match 'undefined'", ObjectUtil.typesMatch(test2, undefined));
		assertFalse("'test3' is a boolean, so it should not match to String", ObjectUtil.typesMatch(test3, String));
		assertFalse("'test3' is a boolean, so it should not match 'null'", ObjectUtil.typesMatch(test3, null));
		assertFalse("'test3' is a boolean, so it should not match 'undefined'", ObjectUtil.typesMatch(test3, undefined));
		assertFalse("'test4' is null, so it should not match to String", ObjectUtil.typesMatch(test4, String));
		assertFalse("'test4' is null, so it should not match 'null'", ObjectUtil.typesMatch(test4, null));
		assertFalse("'test4' is null, so it should not match 'undefined'", ObjectUtil.typesMatch(test4, undefined));
		assertFalse("'test5' is undefined, so it should not match to String", ObjectUtil.typesMatch(test5, String));
		assertFalse("'test5' is undefined, so it should not match 'null'", ObjectUtil.typesMatch(test5, null));
		assertFalse("'test5' is undefined, so it should not match 'undefined'", ObjectUtil.typesMatch(test5, undefined));
		assertFalse("'test6' is a object, so it should not match to String", ObjectUtil.typesMatch(test6, String));
		assertFalse("'test6' is a object, so it should not match 'null'", ObjectUtil.typesMatch(test6, null));
		assertFalse("'test6' is a object, so it should not match 'undefined'", ObjectUtil.typesMatch(test6, undefined));
		assertFalse("'test7' is a complex object, so it should not match to String", ObjectUtil.typesMatch(test7, String));
		assertFalse("'test7' is a complex object, so it should not match to TestCase", ObjectUtil.typesMatch(test7, TestCase));
		assertFalse("'test7' is a complex object, so it should not match to Test", ObjectUtil.typesMatch(test7, Test));
		assertFalse("'test7' is a complex object, so it should not match 'null'", ObjectUtil.typesMatch(test7, null));
		assertFalse("'test7' is a complex object, so it should not match 'undefined'", ObjectUtil.typesMatch(test7, undefined));
		assertFalse("'test8' is a function, so it should not match to String", ObjectUtil.typesMatch(test8, String));
		assertFalse("'test8' is a function, so it should not match to BasicClass", ObjectUtil.typesMatch(test8, BasicClass));
		assertFalse("'test8' is a function, so it should not match 'null'", ObjectUtil.typesMatch(test8, null));
		assertFalse("'test8' is a function, so it should not match 'undefined'", ObjectUtil.typesMatch(test8, undefined));
		assertFalse("'test9' is a extended movieclip, so it should not match to String", ObjectUtil.typesMatch(test8, String));
		assertFalse("'test9' is a extended movieclip, so it should not match to BasicClass", ObjectUtil.typesMatch(test8, BasicClass));
		assertFalse("'test9' is a extended movieclip, so it should not match 'null'", ObjectUtil.typesMatch(test8, null));
		assertFalse("'test9' is a extended movieclip, so it should not match 'undefined'", ObjectUtil.typesMatch(test8, undefined));
		
		/**
		 * Complex case if a Constructor of a class threws a exception and you validate with a primitive class
		 */
		assertNotThrows("Call throws a exception but should be validated anyway", ObjectUtil, "typesMatch", ["test", Call]);
	}
	
	/**
	 * Tests if compareTypeOf works properly.
	 */
	public function testCompareTypeOf(Void):Void {
		var test1:String = "a";
		var test2:String = "b";
		var test3:Number = 0;
		var test4:Number = -1;
		var test5:Array= [];
		var test6:Object = {test:"a"};
		var test7:Boolean = true;
		var test8:Boolean = false;
		var test9:Object = null;
		var test10:Object = null;
		var test11:Object = undefined;
		var test12:Object = undefined;
		var test13:MovieClip = new BasicMovieClip();
		var test14:MovieClip = _root;
		var test15:Function = function(){};
		var test16:Function = BasicClass;
		
		assertTrue("'test1' & 'test2' are strings", ObjectUtil.compareTypeOf(test1, test2));
		assertTrue("'test3' & 'test4' are numbers", ObjectUtil.compareTypeOf(test3, test4));
	}
	
	/**
	 * Test of primitive and complex types used with ObjectUtil.isPrimitiveType(...).
	 */
	public function testIsPrimitiveType(Void):Void {
		var primitiveString:String = "a";
		var primitiveNumber:Number = 1;
		var primitiveBoolean:Boolean = true;
		var complexObject:Object = {};
		var complexObject2:Object = new BasicClass();
		var func:Function = function() {};
		var nullValue:Object = null;
		var undefinedValue:Object = undefined;
		
		assertTrue("'primitiveString' is type of string, so it should be a primitive", ObjectUtil.isPrimitiveType(primitiveString));
		assertTrue("'primitiveNumber' is type of number, so it should be a primitive", ObjectUtil.isPrimitiveType(primitiveNumber));
		assertTrue("'primitiveBoolean' is type of boolean, so it should be a primitive", ObjectUtil.isPrimitiveType(primitiveBoolean));
		assertFalse("'func' is type of function, so it should not be a primitive", ObjectUtil.isPrimitiveType(func));
		assertFalse("'complexObject' is type of object, so it should not be a primitive", ObjectUtil.isPrimitiveType(complexObject));
		assertFalse("'complexObject2' is type of BasicClass, so it should not be a primitive", ObjectUtil.isPrimitiveType(complexObject2));
		assertFalse("'nullValue' is type of null, so it should not be a primitive", ObjectUtil.isPrimitiveType(nullValue));
		assertFalse("'undefinedValue' is type of undefined, so it should not be a primitive", ObjectUtil.isPrimitiveType(undefinedValue));
	}
	
	/**
	 * Type of tests, test if type of matches
	 */
	public function testIsTypeOf(Void):Void {
		var string:String = "a";
		var number:Number = 1;
		var boolean:Boolean = true;
		var object:Object = {};
		var movieClip:MovieClip = _root;
		var func:Function = function() {};
		var nullValue:Object = null;
		var undefinedValue:Object = undefined;
		
		assertTrue("'string' should be typeof String", ObjectUtil.isTypeOf(string, ObjectUtil.TYPE_STRING));
		assertTrue("'number' should be typeof Number", ObjectUtil.isTypeOf(number, ObjectUtil.TYPE_NUMBER));
		assertTrue("'boolean' should be typeof Boolean", ObjectUtil.isTypeOf(boolean, ObjectUtil.TYPE_BOOLEAN));
		assertTrue("'object' should be typeof Object", ObjectUtil.isTypeOf(object, ObjectUtil.TYPE_OBJECT));
		assertTrue("'movieClip' should be typeof MovieClip", ObjectUtil.isTypeOf(movieClip, ObjectUtil.TYPE_MOVIECLIP));
		assertTrue("'func' should be typeof Function", ObjectUtil.isTypeOf(func, ObjectUtil.TYPE_FUNCTION));
		assertTrue("'nullValue' should be typeof null", ObjectUtil.isTypeOf(nullValue, ObjectUtil.TYPE_NULL));
		assertTrue("'undefinedValue' should be typeof undefined", ObjectUtil.isTypeOf(undefinedValue, ObjectUtil.TYPE_UNDEFINED));
		
		assertFalse("'string' should not be a type of Number", ObjectUtil.isTypeOf(string, ObjectUtil.TYPE_NUMBER));
		assertFalse("'number' should not be a type of String", ObjectUtil.isTypeOf(number, ObjectUtil.TYPE_STRING));
		assertFalse("'boolean' should not be a type of Object", ObjectUtil.isTypeOf(boolean, ObjectUtil.TYPE_OBJECT));
		assertFalse("'object' should not be a type of Boolean", ObjectUtil.isTypeOf(object, ObjectUtil.TYPE_BOOLEAN));
		assertFalse("'movieClip' should not be a type of Function", ObjectUtil.isTypeOf(movieClip, ObjectUtil.TYPE_FUNCTION));
		assertFalse("'func' should not be a type of MovieClip", ObjectUtil.isTypeOf(func, ObjectUtil.TYPE_MOVIECLIP));
		assertFalse("'nullValue' should not be a type of undefined", ObjectUtil.isTypeOf(nullValue, ObjectUtil.TYPE_UNDEFINED));
		assertFalse("'undefinedValue' should not be a type of null", ObjectUtil.isTypeOf(undefinedValue, ObjectUtil.TYPE_NULL));
	}
	
	/**
	 * Instance of tests.
	 */
	public function testIsInstanceOf(Void):Void {
		var primitive:Boolean = true;
		var object:Object = {};
		var inst:Object = new BasicClass();
		
		assertTrue("'primitive' is a instance of Object", ObjectUtil.isInstanceOf(primitive, Object));
		assertTrue("'object' is a instance of Object", ObjectUtil.isInstanceOf(object, Object));
		assertTrue("'inst' is a instance of Object", ObjectUtil.isInstanceOf(inst, Object));
		assertTrue("'inst' is a instance of BasicClass", ObjectUtil.isInstanceOf(inst, BasicClass));
		assertTrue("'inst' is a instance of BasicInterface", ObjectUtil.isInstanceOf(inst, BasicInterface));
		assertFalse("'inst' is not a instance of Test", ObjectUtil.isInstanceOf(inst, Test));
		assertFalse("'inst' is not a instance of null, its a instance of Object", ObjectUtil.isInstanceOf(inst, null));
		assertTrue("'this' should be a instance of "+ClassInfo.forObject(this).getFullName(), ObjectUtil.isInstanceOf(this, ClassInfo.forObject(this).getType()));
	}
	
	/**
	 * Tests for a explicit instance of a Element
	 */
	public function testIsExplicitInstanceOf(Void):Void {
		var inst:Object = new BasicClass();
		var string:String = "a";
		var stringInst:String = new String("1");
		var extStringInst:ExtendedString = new ExtendedString(1);
		var number:Number = 0;
		var numberInst:Number = new Number(1);
		var extNumberInst:ExtendedNumber = new ExtendedNumber(1);
		var boolean:Boolean = true;
		var booleanInst:Boolean = new Boolean(true);
		var extBooleanInst:Boolean = new ExtendedBoolean(true);
		
		assertTrue("'inst' should be the explicit instance of BasicClass", ObjectUtil.isExplicitInstanceOf(inst, BasicClass));
		assertFalse("'inst' should not be the explicit instance of Object", ObjectUtil.isExplicitInstanceOf(inst, Object));
		assertTrue("'inst' should not be the explicit instance of BasicInterface because BasicClass is directly implementing it", ObjectUtil.isExplicitInstanceOf(inst, BasicClass));
		assertTrue("'string' should be a explicit instance of String", ObjectUtil.isExplicitInstanceOf(string, String));
		assertFalse("'string' should not be a explicit instance of Object", ObjectUtil.isExplicitInstanceOf(string, Object));
		assertTrue("'stringInst' should be a explicit instance of String", ObjectUtil.isExplicitInstanceOf(stringInst, String));
		assertFalse("'extStringInst' should not be a explicit instance of String", ObjectUtil.isExplicitInstanceOf(extStringInst, String));
		assertTrue("'number' should be a explicit instance of Number", ObjectUtil.isExplicitInstanceOf(number, Number));
		assertFalse("'number' should not be a explicit instance of Object", ObjectUtil.isExplicitInstanceOf(number, Object));
		assertTrue("'numberInst' should be a explicit instance of Number", ObjectUtil.isExplicitInstanceOf(numberInst, Number));
		assertFalse("'extNumberInst' should not be a explicit instance of Number", ObjectUtil.isExplicitInstanceOf(extNumberInst, Number));
		assertTrue("'boolean' should be a explicit instance of Boolean", ObjectUtil.isExplicitInstanceOf(boolean, Boolean));
		assertFalse("'boolean' should not be a explicit instance of Object", ObjectUtil.isExplicitInstanceOf(boolean, Object));
		assertTrue("'booleanInst' should be a explicit instance of Boolean", ObjectUtil.isExplicitInstanceOf(booleanInst, Boolean));
		assertFalse("'extBooleanInst' should not be a explicit instance of Boolean", ObjectUtil.isExplicitInstanceOf(extBooleanInst, Boolean));
		assertFalse("'this' should not be a explicit instance of BasicClass", ObjectUtil.isExplicitInstanceOf(this, BasicClass));
		assertFalse("'this' should not be a explicit instance of BasicInterface", ObjectUtil.isExplicitInstanceOf(this, BasicInterface));
		assertFalse("'this' should not be a explicit instance of Test", ObjectUtil.isExplicitInstanceOf(this, Test));
		assertTrue("'this' should be a explicit instance of "+ClassInfo.forObject(this).getFullName(), ObjectUtil.isExplicitInstanceOf(this, ClassInfo.forObject(this).getType()));
	}
	
	/**
	 * Tests the isEmpty method with a positive and negative case.
	 */
	/*public function testIsEmpty(Void):Void {
		var string:String = "a";
		var nullValue:Object = null;
		var undefinedValue:Object = undefined;
		
		assertFalse("'string' is not empty", ObjectUtil.isEmpty(string));
		assertTrue("'nullValue' is empty", ObjectUtil.isEmpty(nullValue));
		assertTrue("'undefinedValue' is empty", ObjectUtil.isEmpty(undefinedValue));
	}*/
	
	/**
	 * Tests the .isAvailable method. (Inversion of the isEmpty test)
	 */
	/*public function testIsAvailable(Void):Void {
		var string:String = "a";
		var nullValue:Object = null;
		var undefinedValue:Object = undefined;
		
		assertTrue("'string' is not empty", ObjectUtil.isAvailable(string));
		assertFalse("'nullValue' is empty", ObjectUtil.isAvailable(nullValue));
		assertFalse("'undefinedValue' is empty", ObjectUtil.isAvailable(undefinedValue));
	}*/
	
	
	/**
	 * Tests the .isAvailable method.
	 */
	/*public function testForEach(Void):Void {
		var call:Call = new Call(this, forEachCall);
		var obj:Object = new Object();
		obj.test1 = "a";
		obj.test2 = "b";
		obj.test3 = "c";
		
		ObjectUtil.forEach(obj, call);
	}*/
	
	
	/**
	 * Call to be executed by forEach.
	 */
	/*private function forEachCall(object, name:String):Void {
		if(name == "test1") {
			assertEquals("'test1' should be 'a'", object, "a");
		} else if(name == "test2") {
			assertEquals("'test2' should be 'b'", object, "b");
		} else if(name == "test3") {
			assertEquals("'test3' should be 'c'", object, "c");
		} else {
			fail("Unexpected name: '"+name+"' occured in object")
		}
	}*/
}