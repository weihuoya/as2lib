import org.as2lib.core.BasicClass;
import org.as2lib.core.BasicInterface;
import org.as2lib.core.BasicMovieClip;
import org.as2lib.test.unit.TestCase;
import org.as2lib.test.unit.Test;
import org.as2lib.util.ObjectUtil;

/**
 * Testcase for massive ObjectUtil testing.
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.util.TObjectUtil extends TestCase {
	
	/**
	 * Tests if .getChildName really returns the childname or returns null.
	 */
	public function testGetChildName(Void):Void {
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
	}
	
	/**
	 * Tests if all accesspermission can be set correct.
	 */
	public function testSetAccessPermission(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// Test for a valid all allowed state.
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		
		inObject.test = "b";
		assertNotEquals("test was not overwritten, even if it was allowed to", inObject.test, "a");
		
		inObject.test = "a";
		assertTrue("test was not deleted, even if it was allowed to", delete inObject.test);
		
		
		// Test setting of isHidden
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_IS_HIDDEN);

		for(var i:String in inObject) {
			if(i == "test") {
				fail("Test was visible, even by explicit hiding");
			}
		}
		
		// Test of protection from delete.
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_DELETE);
		assertFalse("test could be deleted, even if it was protected", delete inObject.test);
		inObject.test = "a";
		
		// Test of protection from overwrite.
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_OVERWRITE);
		inObject.test = "b";
		assertEquals("test was overwritten, even if it was protected", inObject.test, "a");
		inObject.test = "a";
		
		// Another test with all permissions
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		var found:Boolean = false;
		for(var i:String in inObject) {
			if(i == "test") {
				found = true;
			}
		}
		if(!found) {
			fail("test should be visible, because all was allowed");
		}
		
		/**
		 * This has been inverted(!!!!) due to a Macromedia Bug. 
		 * TODO: Provide this informations to Macromedia.
		 */
		inObject.test = "b";
		assertEquals("test was overwritten, even if MM had a bug! (TODO: Notice this change!)", inObject.test, "a");
		inObject.test = "a";
		
		assertTrue("test was deleted, even if MM had a bug! (TODO: Notice this change!)", delete inObject.test);
	}
	
	/**
	 * Tests if all accesspermission can be set correct.
	 */
	public function testGetAccessPermission(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		assertFalse("Validates as hidden even if it is not hidden", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_IS_HIDDEN) == ObjectUtil.ACCESS_IS_HIDDEN);
		assertFalse("Validates as protected of deletion even if it is not protected", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_DELETE) == ObjectUtil.ACCESS_PROTECT_DELETE);
		assertFalse("Validates as protected of overwriting even if it is not protected", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_OVERWRITE) == ObjectUtil.ACCESS_PROTECT_OVERWRITE);
		
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_IS_HIDDEN);
		assertTrue("Validates as not hidden even if it is hidden", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_IS_HIDDEN) == ObjectUtil.ACCESS_IS_HIDDEN);
		
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_DELETE);
		assertTrue("Validates as not protected of deletion if it is protected", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_DELETE) == ObjectUtil.ACCESS_PROTECT_DELETE);
		
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_OVERWRITE);
		assertTrue("Validates as not protected of overwriting if it is protected", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_OVERWRITE) == ObjectUtil.ACCESS_PROTECT_OVERWRITE);
		
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		assertFalse("Validates as hidden even if it is not hidden", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_IS_HIDDEN) == ObjectUtil.ACCESS_IS_HIDDEN);
		
		/**
		 * This has been inverted(!!!) due to a Macromedia Bug. 
		 * TODO: Provide this informations to Macromedia.
		 */
		assertTrue("Validates as protected of deletion even if it is protected and MM had a bug here (TODO: Notice this change!)", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_DELETE) == ObjectUtil.ACCESS_PROTECT_DELETE);
		assertTrue("Validates as protected of overwriting even if it is protected and MM had a bug here (TODO: Notice this change!)", (ObjectUtil.getAccessPermission(inObject, "test") & ObjectUtil.ACCESS_PROTECT_OVERWRITE) == ObjectUtil.ACCESS_PROTECT_OVERWRITE);
	}
	
	/**
	 * Test for the functionality of .isEnumerable.
	 */
	public function testIsEnumerable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be enumberable by default", ObjectUtil.isEnumerable(inObject, "test"));
		
		// negative case
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_IS_HIDDEN);
		assertFalse("'test' should not be enumberable if its denied!", ObjectUtil.isEnumerable(inObject, "test"));
		
		// positive case again
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		assertTrue("'test' should be enumberable", ObjectUtil.isEnumerable(inObject, "test"));
		
		// invalid case
		assertFalse("'test2' doesnt exists, so it should not be enumerable", ObjectUtil.isEnumerable(inObject, "test2"));
	}
	
	/**
	 * Test for the functionality of .isOverwritable.
	 */
	public function testIsOverwritable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be overwriteable by default", ObjectUtil.isOverwritable(inObject, "test"));
		
		// negative case
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_OVERWRITE);
		assertFalse("'test' should not be overwriteable if its denied!", ObjectUtil.isOverwritable(inObject, "test"));
		
		// positive case again (doesn't work! - MM Bug)
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		assertFalse("'test' should be overwriteable, but MM has a Bug. If you see this, tell Macromedia they fixed it.", ObjectUtil.isOverwritable(inObject, "test"));
		
		// invalid case
		assertTrue("'test2' doesnt exist, so it should be overwriteable", ObjectUtil.isOverwritable(inObject, "test2"));
	}
	
	/**
	 * Test for the functionality of .isDeletable.
	 */
	public function testIsDeletable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be deletable by default", ObjectUtil.isDeletable(inObject, "test"));
		
		// negative case
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_PROTECT_DELETE);
		assertFalse("'test' should not be deleteable if its denied!", ObjectUtil.isDeletable(inObject, "test"));
		
		// positive case again (doesn't work! - MM Bug)
		ObjectUtil.setAccessPermission(inObject, ["test"], ObjectUtil.ACCESS_ALL_ALLOWED);
		assertFalse("'test' should be deletable, but MM has a Bug. If you see this, tell Macromedia they fixed it.", ObjectUtil.isDeletable(inObject, "test"));
		
		// invalid case
		assertFalse("'test2' doesnt exist, so it should not be deleteable", ObjectUtil.isDeletable(inObject, "test2"));
	}
	
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
		var test8:Function = function() {}
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
	}
	
	
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
	
	public function testIsPrimitiveType(Void):Void {
	}
	
	public function testIsTypeOf(Void):Void {
	}
	
	public function testIsInstanceOf(Void):Void {
	}
	
	public function testIsExplicitInstanceOf(Void):Void {
	}
	
	public function testIsEmpty(Void):Void {
	}
	
	public function testIsAvailable(Void):Void {
	}
	
	public function testForEach(Void):Void {
	}
}