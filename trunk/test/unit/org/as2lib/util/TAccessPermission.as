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
import org.as2lib.util.AccessPermission;
 
/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.util.TAccessPermission extends TestCase {
 
	/**
	 * Tests if all accesspermission can be set correct.
	 */
	public function testSetAccessPermission(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// Test for a valid all allowed state.
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		
		inObject.test = "b";
		assertNotEquals("test was not overwritten, even if it was allowed to", inObject.test, "a");
		
		inObject.test = "a";
		assertTrue("test was not deleted, even if it was allowed to", delete inObject.test);
		
		
		// Test setting of isHidden
		AccessPermission.set(inObject, ["test"], AccessPermission.HIDE);

		for(var i:String in inObject) {
			if(i == "test") {
				fail("Test was visible, even by explicit hiding");
			}
		}
		
		// Test of protection from delete.
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_DELETE);
		assertFalse("test could be deleted, even if it was protected", delete inObject.test);
		inObject.test = "a";
		
		// Test of protection from overwrite.
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_OVERWRITE);
		inObject.test = "b";
		assertEquals("test was overwritten, even if it was protected", inObject.test, "a");
		inObject.test = "a";
		
		// Another test with all permissions
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
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
		
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		assertFalse("Validates as hidden even if it is not hidden", (AccessPermission.get(inObject, "test") & AccessPermission.HIDE) == AccessPermission.HIDE);
		assertFalse("Validates as protected of deletion even if it is not protected", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_DELETE) == AccessPermission.PROTECT_DELETE);
		assertFalse("Validates as protected of overwriting even if it is not protected", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_OVERWRITE) == AccessPermission.PROTECT_OVERWRITE);
		
		AccessPermission.set(inObject, ["test"], AccessPermission.HIDE);
		assertTrue("Validates as not hidden even if it is hidden", (AccessPermission.get(inObject, "test") & AccessPermission.HIDE) == AccessPermission.HIDE);
		
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_DELETE);
		assertTrue("Validates as not protected of deletion if it is protected", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_DELETE) == AccessPermission.PROTECT_DELETE);
		
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_OVERWRITE);
		assertTrue("Validates as not protected of overwriting if it is protected", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_OVERWRITE) == AccessPermission.PROTECT_OVERWRITE);
		
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		assertFalse("Validates 2nd time as hidden even if it is not hidden", (AccessPermission.get(inObject, "test") & AccessPermission.HIDE) == AccessPermission.HIDE);
		
		/**
		 * This has been inverted(!!!) due to a Macromedia Bug. 
		 * TODO: Provide this informations to Macromedia.
		 */
		assertTrue("Validates as protected of deletion even if it is protected and MM had a bug here (TODO: Notice this change!)", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_DELETE) == AccessPermission.PROTECT_DELETE);
		assertTrue("Validates as protected of overwriting even if it is protected and MM had a bug here (TODO: Notice this change!)", (AccessPermission.get(inObject, "test") & AccessPermission.PROTECT_OVERWRITE) == AccessPermission.PROTECT_OVERWRITE);
	}
	
	/**
	 * Test for the functionality of .isEnumerable.
	 */
	public function testIsEnumerable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be enumberable by default", AccessPermission.isEnumerable(inObject, "test"));
		
		// negative case
		AccessPermission.set(inObject, ["test"], AccessPermission.HIDE);
		assertFalse("'test' should not be enumberable if its denied!", AccessPermission.isEnumerable(inObject, "test"));
		
		// positive case again
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		assertTrue("'test' should be enumberable", AccessPermission.isEnumerable(inObject, "test"));
		
		// invalid case
		assertFalse("'test2' doesnt exists, so it should not be enumerable", AccessPermission.isEnumerable(inObject, "test2"));
	}
	
	/**
	 * Test for the functionality of .isOverwritable.
	 */
	public function testIsOverwritable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be overwriteable by default", AccessPermission.isOverwritable(inObject, "test"));
		
		// negative case
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_OVERWRITE);
		assertFalse("'test' should not be overwriteable if its denied!", AccessPermission.isOverwritable(inObject, "test"));
		
		// positive case again (doesn't work! - MM Bug)
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		assertFalse("'test' should be overwriteable, but MM has a Bug. If you see this, tell Macromedia they fixed it.", AccessPermission.isOverwritable(inObject, "test"));
		
		// invalid case
		assertTrue("'test2' doesnt exist, so it should be overwriteable", AccessPermission.isOverwritable(inObject, "test2"));
	}
	
	/**
	 * Test for the functionality of .isDeletable.
	 */
	public function testIsDeletable(Void):Void {
		var inObject:Object = new Object();
		inObject.test = "a";
		
		// positive case
		assertTrue("'test' should be deletable by default", AccessPermission.isDeletable(inObject, "test"));
		
		// negative case
		AccessPermission.set(inObject, ["test"], AccessPermission.PROTECT_DELETE);
		assertFalse("'test' should not be deleteable if its denied!", AccessPermission.isDeletable(inObject, "test"));
		
		// positive case again (doesn't work! - MM Bug)
		AccessPermission.set(inObject, ["test"], AccessPermission.ALLOW_ALL);
		assertFalse("'test' should be deletable, but MM has a Bug. If you see this, tell Macromedia they fixed it.", AccessPermission.isDeletable(inObject, "test"));
		
		// invalid case
		assertFalse("'test2' doesnt exist, so it should not be deleteable", AccessPermission.isDeletable(inObject, "test2"));
	}
	
}