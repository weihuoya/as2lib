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

import org.as2lib.data.holder.List;
import org.as2lib.data.holder.Iterator;
import org.as2lib.test.unit.TestCase;

/**
 * Abtract Testcase for any List
 *
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.data.holder.AbstractTList extends TestCase {
	
	/** Internal holder for list operations */
	private var list:List;
	
	/**
	 * Its a abstract List so it blocks itself from collecting of the TestSystem
	 * 
	 * @return true
	 */
	public static function blockCollecting(Void):Boolean {
		return true;
	}
	
	/**
	 * Creates a new list, based on the template method: createNew List
	 */
	public function setUp(Void):Void {
		list = createNewList();
	}
	
	/**
	 * Template method for the specific list implementation to create a new list to test with.
	 */
	private function createNewList(Void):List {
		return null;
	}
	
	/**
	 * Tests inserting different kind of content
	 */
	public function testInsertByValue(Void):Void {
		// Validates simple inserting
		list.insert("a");
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		
		// Validates that the content is the same even after inserting another content
		list.insert("b");
		assertEquals("Content at entry 0 should still be 'a'", list.get(0), "a");
		assertEquals("Content at entry 1 should be 'b'", list.get(1), "b");
		
		// Validates that 'null' is used properly
		list.insert(null);
		assertNull("Content at entry 2 should be 'null'", list.get(2));
		
		// Validatest that 'boolean' is used properly
		list.insert(undefined);
		assertUndefined("Content at entry 3 should be 'undefined'", list.get(3));
	}
	
	public function testInsertByIndexAndValue(Void):Void {
		list.insert(0, "a");
		assertEquals("list[0] != 'a'", list.get(0), "a");
		assertSame(list.size(), 1);
		list.insert(1, "b");
		assertEquals("list[1] != 'b'", list.get(1), "b");
		assertSame(list.size(), 2);
		list.insert(1, "c");
		assertEquals("list[1] != 'c'", list.get(1), "c");
		assertEquals("list[2] != 'b'", list.get(2), "b");
		assertSame(list.size(), 3);
		list.insert(1, "d");
		assertEquals("list[1] != 'd'", list.get(1), "d");
		assertEquals("list[2] != 'c'", list.get(2), "c");
		assertEquals("list[3] != 'b'", list.get(3), "b");
		assertSame(list.size(), 4);
		list.insert(2, "e");
		assertEquals("list[2] != 'e'", list.get(2), "e");
		assertEquals("list[3] != 'c'", list.get(3), "c");
		assertEquals("list[4] != 'b'", list.get(4), "b");
		assertSame(list.size(), 5);
		list.insert(0, "f");
		assertEquals("list[0] != 'f'", list.get(0), "f");
		assertEquals("list[1] != 'a'", list.get(1), "a");
		assertEquals("list[2] != 'd'", list.get(2), "d");
		assertEquals("list[3] != 'e'", list.get(3), "e");
		assertEquals("list[4] != 'c'", list.get(4), "c");
		assertEquals("list[5] != 'b'", list.get(5), "b");
		assertSame(list.size(), 6);
		list.insert(6, "g");
		assertEquals("list[6] != 'g'", list.get(6), "g");
		assertSame(list.size(), 7);
	}
	
	public function testInsertByIndexAndValueWithIndexOutOfRange(Void):Void {
		list.insert(0, "a");
		list.insert(1, "b");
		list.insert(2, "c");
		assertSame(list.size(), 3);
		try {
			list.insert(-1, "d");
			fail("expected IndexOutOfBoundsException for index (-1) less than 0");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.insert(-4, "e");
			fail("expected IndexOutOfBoundsException for index (-4) less than 0");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.insert(4, "f");
			fail("expected IndexOutOfBoundsException for index (4) greater than the list's size (3)");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.insert(8, "g");
			fail("expected IndexOutOfBoundsException for index (8) greater than the list's size (3)");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
	}
	
	/**
	 * Tests inserting of content to the first position
	 */
	public function testInsertFirst(Void):Void {
		// Validates a simple insert into a empty array
		list.insertFirst("a");
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		
		// Validates the insertFirst for a filled array.
		list.insertFirst("b");
		assertEquals("Content at entry 0 should be 'b'", list.get(0), "b");
		assertEquals("Content at entry 1 should be 'a'", list.get(1), "a");
	}
	
	/**
	 * Tests inserting of content to the last position
	 */
	public function testInsertLast(Void):Void {
		// Validates a simple insert into a empty array
		list.insert("a");
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		
		// Validates it for another insert.
		list.insert("b");
		assertEquals("Content at entry 0 should still be 'a'", list.get(0), "a");
		assertEquals("Content at entry 1 should be 'b'", list.get(1), "b");
	}
	
	/**
	 * Tests if inserting of a list to a list (with a specific position) works properly
	 */
	public function testInsertAllByList(Void):Void {
		list.insert("c");
		list.insert("d");
		var newList:List = createNewList();
		newList.insert("a");
		newList.insert("b");
		list.insertAll(newList);
		assertEquals("Content at entry 0 should be 'c'", list.get(0), "c");
		assertEquals("Content at entry 1 should be 'd'", list.get(1), "d");
		assertEquals("Content at entry 2 should be 'a'", list.get(2), "a");
		assertEquals("Content at entry 3 should be 'b'", list.get(3), "b");
	}
	
	public function testInsertAllByIndexAndListAtFirstIndex(Void):Void {
		list.insert("c");
		list.insert("d");
		var newList:List = createNewList();
		newList.insert("a");
		newList.insert("b");
		list.insertAll(0, newList);
		assertEquals("list[0] != 'a'", list.get(0), "a");
		assertEquals("list[1] != 'b'", list.get(1), "b");
		assertEquals("list[2] != 'c'", list.get(2), "c");
		assertEquals("list[3] != 'd'", list.get(3), "d");
	}
	
	public function testInsertAllByIndexAndListAtLastIndex(Void):Void {
		list.insert("c");
		list.insert("d");
		var newList:List = createNewList();
		newList.insert("a");
		newList.insert("b");
		list.insertAll(2, newList);
		assertEquals("list[0] != 'c'", list.get(0), "c");
		assertEquals("list[1] != 'd'", list.get(1), "d");
		assertEquals("list[2] != 'a'", list.get(2), "a");
		assertEquals("list[3] != 'b'", list.get(3), "b");
	}
	
	public function testInsertAllByIndexAndListInMiddle(Void):Void {
		list.insert("c");
		list.insert("d");
		var newList:List = createNewList();
		newList.insert("a");
		newList.insert("b");
		list.insertAll(1, newList);
		assertEquals("list[0] != 'c'", list.get(0), "c");
		assertEquals("list[1] != 'a'", list.get(1), "a");
		assertEquals("list[2] != 'b'", list.get(2), "b");
		assertEquals("list[3] != 'd'", list.get(3), "d");
	}
	
	public function testInsertAllByIndexAndListWithOutOfBoundsIndex(Void):Void {
		var a:List = createNewList();
		a.insert("a");
		a.insert("b");
		a.insert("c");
		list.insertAll(0, a);
		var newList:List = createNewList();
		newList.insert("d");
		newList.insert("e");
		try {
			list.insertAll(-1, newList);
			fail("expected IndexOutOfBoundsException for -1 index");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.insertAll(4, newList);
			fail("expected IndexOutOfBoundsException for 4 index");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
	}
	
	/**
	 * Tests removing of different entries
	 */
	public function testRemove() {
		list.insert("a");
		list.insert("b");
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		list.remove("a");
		assertEquals("Content at entry 0 should be 'b'", list.get(0), "b");
	}
	
	/**
	 * Test removing different entries by value
	 */
	public function testRemoveByValue(value):Void {
		list.insert("a");
		list.insert("b");
		list.insert("c");
		list.removeByValue('b');
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		assertEquals("Content at entry 1 should be 'c'", list.get(1), "c");
		list.removeByValue("b");
	}
	
	/**
	 * Tests removing by index of a entry
	 */
	public function testRemoveByIndex(Void):Void {
		list.insert("a");
		list.insert("b");
		list.insert("c");
		list.removeByIndex(1);
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		assertEquals("Content at entry 1 should be 'c'", list.get(1), "c");
	}
	
	public function testRemoveByIndexWithOutOfBoundsIndex(Void):Void {
		assertSame(list.size(), 0);
		try {
			list.removeByIndex(0);
			fail("expected IndexOutOfBoundsException with empty list and index 0");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		list.insert("a");
		list.insert("b");
		list.insert("c");
		try {
			list.removeByIndex(-1);
			fail("expected IndexOutOfBoundsException for index -1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.removeByIndex(4);
			fail("expected IndexOutOfBoundsException for index 4");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		try {
			list.removeByIndex(3);
			fail("expected IndexOutOfBoundsException for index 3");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
	}
	
	/**
	 * Tests if removing the first entry works properly
	 */
	public function testRemoveFirst(Void) {
		list.insert("a");
		list.insert("b");
		list.removeFirst();	
		assertEquals("Content at entry 0 should be 'b'", list.get(0), "b");
	}
	
	/**
	 * Tests if removing the last entry works properly
	 */
	public function testRemoveLast(Void) {
		list.insert("a");
		list.insert("b");
		list.removeLast();
		assertEquals("Content at entry 0 should be 'a'", list.get(0), "a");
		try {
			list.get(1);
			fail("expected IndexOutOfBoundsException for index 1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 1);
	}
	
	/**
	 * Tests if removing all entries applied within a list really removes all entries.
	 */
	public function testRemoveAll(Void):Void {
		var newList:List = createNewList();
		list.insert("a");
		list.insert("b");
		list.insert("c");
		newList.insert("a");
		newList.insert("b");
		list.removeAll(newList);
		assertEquals("Content at entry 0 should be 'c'", list.get(0), 'c');
		try {
			list.get(1);
			fail("expected IndexOutOfBoundsException for index 1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.get(2);
			fail("expected IndexOutOfBoundsException for index 2");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 1);
	}
	
	/**
	 * Tests if "set" works properly
	 */
	public function testSet(Void):Void {
		list.insert("a");
		list.insert("b");
		list.set(0, "c");
		assertEquals("Content at entry 0 should not be 'c'", list.get(0), 'c');
	}
	
	public function testSetWithOutOfBoundsIndex(Void):Void {
		try {
			list.set(0, "c");
			fail("expected IndexOutOfBoundsException in empty list with index 0");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		list.insert("a");
		list.insert("b");
		try {
			list.set(2, "c");
			fail("expected IndexOutOfBoundsException for index 2");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.set(-1, "c");
			fail("expected IndexOutOfBoundsException for index -1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 2);
	}
	
	/**
	 * Tests if setting of a list works properly
	 */
	public function testSetAll(Void):Void {
		var newList:List = createNewList();
		newList.insert("e");
		newList.insert("f");
		list.insert("a");
		list.insert("b");
		list.insert("c");
		list.insert("d");
		list.setAll(1, newList);
		assertEquals("Content at entry 0 should be 'a'", list.get(0), 'a');
		assertEquals("Content at entry 1 should be 'e'", list.get(1), 'e');
		assertEquals("Content at entry 2 should be 'f'", list.get(2), 'f');
		assertEquals("Content at entry 3 should be 'd'", list.get(3), 'd');
	}
	
	public function testSetAllWithOutOfBoundsIndex(Void):Void {
		var newList:List = createNewList();
		newList.insert("e");
		newList.insert("f");
		list.insert("a");
		list.insert("b");
		list.insert("c");
		list.insert("d");
		try {
			list.setAll(-1, newList);
			fail("expected IndexOutOfBoundsException for index -1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 4);
		try {
			list.setAll(4, newList);
			fail("expected IndexOutOfBoundsException for index 4");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 4);
		try {
			list.setAll(3, newList);
			fail("expected IndexOutOfBoundsException for index 3 and newList size 2");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 4);
		list.setAll(2, newList);
		assertSame(list.get(0), "a");
		assertSame(list.get(1), "b");
		assertSame(list.get(2), "e");
		assertSame(list.get(3), "f");
	}
	
	/**
	 * Tests if get always returns the correct content.
	 */
	public function testGet(Void):Void {
		var obj = {};
		var func = function() {};
		list.insert("a");
		list.insert(1);
		list.insert(true);
		list.insert(obj);
		list.insert(func);
		list.insert(null);
		assertEquals("Content at entry 0 should be 'a'", list.get(0), 'a');
		assertEquals("Content at entry 1 should be 1", list.get(1), 1);
		assertEquals("Content at entry 2 should be true", list.get(2), true);
		assertEquals("Content at entry 3 should be obj", list.get(3), obj);
		assertEquals("Content at entry 4 should be func", list.get(4), func);
		assertNull("Content at entry 5 should be null", list.get(5));
	}
	
	public function testGetWithOutOfBoundsIndex(Void):Void {
		try {
			list.get(0);
			fail("expected IndexOutOfBoundsException for 0 index in empty list");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		list.insert("a");
		list.insert("b");
		list.insert("c");
		try {
			list.get(3);
			fail("expected IndexOutOfBoundsException for index 3");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.get(-1);
			fail("expected IndexOutOfBoundsException for index -1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 3);
		assertSame(list.get(0), "a");
		assertSame(list.get(1), "b");
		assertSame(list.get(2), "c");
	}
	
	/**
	 * Tests if the list contains various contents
	 */
	public function testContains(Void):Void {
		
		var obj = {};
		var func = function() {};
		
		// Test with a empty list and different kind of entries
		assertFalse("List does not contain 'a'", list.contains("a"));
		assertFalse("List does not contain 1", list.contains(1));
		assertFalse("List does not contain true", list.contains(true));
		assertFalse("List does not contain obj", list.contains(obj));
		assertFalse("List does not contain func", list.contains(func));
		assertFalse("List does not contain null", list.contains(null));
		assertFalse("List does not contain undefined", list.contains(undefined));
		
		// Preparing the list
		list.insert("a");
		list.insert(1);
		list.insert(true);
		list.insert(obj);
		list.insert(func);
		list.insert(null);
		list.insert(undefined);
		
		// Test with a empty list and different kind of entries
		assertTrue("List should contain 'a'", list.contains("a"));
		assertTrue("List should contain 1", list.contains(1));
		assertTrue("List should contain true", list.contains(true));
		assertTrue("List should contain obj", list.contains(obj));
		assertTrue("List should contain func", list.contains(func));
		assertTrue("List should contain null", list.contains(null));
		assertTrue("List should contain undefined", list.contains(undefined));
	}
	
	/**
	 * Test if the list can handle the containAll method properly
	 */
	public function testContainsAll(Void):Void {
		// Preparing the searchlist
		var newList:List = createNewList();
		newList.insert("a");
		newList.insert("b");
		
		// Preparing the list
		list.insert("a");
		list.insert("b");
		list.insert("c");
		assertTrue("List contains 'a' and 'b'", list.containsAll(newList));
		
		// Change of the list
		list.set(0, "b");
		list.set(1, "a");
		assertTrue("List contains 'b' and 'a'", list.containsAll(newList));
		
		// Changing of the content in the searchList (Reference check!)
		newList.set(1, "e");
		assertFalse("List does not contain 'a' and 'e'", list.containsAll(newList));
		newList.set(0, "f");
		assertFalse("List does not contain 'f' and 'e'", list.containsAll(newList));
	}
	
	/**
	 * Test if it really removes all elements that should be removed by retainAll.
	 */
	public function testRetainAll(Void):Void {
		list.insert("a");
		list.insert("b");
		list.insert("c");
		var newList:List = createNewList();
		newList.insert("a");
		list.retainAll(newList);
		assertEquals("Content at entry 0 should be 'a'", list.get(0), 'a');
		try {
			list.get(1);
			fail("expected IndexOutOfBoundsException for index 1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.get(2);
			fail("expected IndexOutOfBoundsException for index 2");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		assertSame(list.size(), 1);
	}
	
	/**
	 * Tests if clear works properly in the implementation
	 */
	public function testClear(Void):Void {
		list.insert("a");
		list.insert("b");
		list.insert("c");
		list.clear();
		assertSame(list.size(), 0);
		try {
			list.get(0);
			fail("expected IndexOutOfBoundsException for index 0");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.get(1);
			fail("expected IndexOutOfBoundsException for index 1");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
		try {
			list.get(2);
			fail("expected IndexOutOfBoundsException for index 2");
		} catch (e:org.as2lib.data.holder.IndexOutOfBoundsException) {
		}
	}
	
	/**
	 * Tests with different content if the size works properly.
	 */
	public function testSize(Void):Void {
		// Test with never existed entries.
		assertEquals("List without content should have size == 0", list.size(), 0);
		
		// Test with filled list.
		var obj:Object = {};
		var func:Function = function() {};
		list.insert("a");
		list.insert(1);
		list.insert(true);
		list.insert(obj);
		list.insert(func);
		list.insert(null);
		list.insert(undefined);
		assertEquals("List with seven elements should have size == 7", list.size(), 7);
		
		// Test with cleared list.
		list.clear();
		assertEquals("List without content should have size == 0", list.size(), 0);
		
		// Test with removing existant entries.
		list.insert("a");
		list.insert("b");
		list.insert("c");
		assertEquals("List with three elements should have size == 3", list.size(), 3);
		list.remove("a");
		list.remove("b");
		list.remove("c");
		
		
		// Test with all removed entries.
		list.insert("a");
		assertEquals("List with one element should have size == 1", list.size(), 1);
	}
	
	/**
	 * Tests if isEmpty works in different cases.
	 */
	public function testIsEmpty(Void):Void {
		// Test if not filled list is empty
		assertTrue("List without any entry should be empty", list.isEmpty());
		
		// Test if filled list is not empty
		list.insert("a");
		assertFalse("List with one entry should not be empty", list.isEmpty());
		
		// Test if clear really works.
		list.clear();
		assertTrue("Cleared list should be empty", list.isEmpty());
		
		// Test if another inserting manipulates isEmpty
		list.insert("b");
		assertFalse("Again filled list should not be empty", list.isEmpty());
		
		// Test if a removed entry is really removed.
		list.remove("b");
		assertTrue("If no entry is available it should be empty", list.isEmpty());
	}
	
	/**
	 * Tests if the returned Iterator works properly
	 */
	public function testIterator(Void):Void {
		
		var iter:Iterator;
		var i:Number;
		
		// Test for a proper iterator from a empty list
		iter = list.iterator();
		assertFalse("Empty list should return a iterator that has nothing next", iter.hasNext());
		
		// Iteration over a normal filled list
		list.insert(0);
		list.insert(1);
		list.insert(2);
		assertEquals("Size of 3 expected within the list", list.size(), 3);
		iter = list.iterator();
		for(i = 0; iter.hasNext(); i++) {
			assertEquals("Iteration content should match list content #"+i, iter.next(), i);
		}
		
		// Iteration over a changed list
		list.set(0, 2);
		list.set(1, 3);
		list.set(2, 4);
		assertEquals("Size of 3 expected within the list", list.size(), 3);
		iter = list.iterator();
		for(i = 2; iter.hasNext(); i++) {
			assertEquals("Setted Iteration content should match list content #"+i, iter.next(), i);
		}
		// Iteration over a undefined and null entry
		list.clear();
		list.insert(null);
		list.insert(undefined);
		iter = list.iterator();
		for(i = 0; iter.hasNext(); i++) {
			if(i == 0) {
				assertNull("Content 0 should be null", iter.next());
			} else if(i == 1) {
				assertUndefined("Content 1 should be undefined", iter.next());
			}
		}
		assertEquals("Size of the iterator should be 2", i, 2);
	}
	
	/**
	 * Tests if a index of different entries work properly
	 */
	public function testIndexOf(Void):Void {
		var obj:Object = {};
		var func:Function = function() {};
		
		// Test for a empty list.
		assertEquals("List index of 'a' should be -1", list.indexOf("a"), -1);
		assertEquals("List index of 1 should be -1", list.indexOf(1), -1);
		assertEquals("List index of true should be -1", list.indexOf(true), -1);
		assertEquals("List index of obj should be -1", list.indexOf(obj), -1);
		assertEquals("List index of func should be -1", list.indexOf(func), -1);
		assertEquals("List index of null should be -1", list.indexOf(null), -1);
		assertEquals("List index of undefined should be -1", list.indexOf(undefined), -1);
		
		
		// Prepare list for a test with a filled list
		list.insert("a");
		list.insert(1);
		list.insert(true);
		list.insert(obj);
		list.insert(func);
		list.insert(null);
		list.insert(undefined);
		
		// Test the index of content in a filled list
		assertEquals("List content at index 0 should be 'a'", list.indexOf("a"), 0);
		assertEquals("List content at index 1 should be 1", list.indexOf(1), 1);
		assertEquals("List content at index 2 should be true", list.indexOf(true), 2);
		assertEquals("List content at index 3 should be obj", list.indexOf(obj), 3);
		assertEquals("List content at index 4 should be func", list.indexOf(func), 4);
		assertEquals("List content at index 5 should be null", list.indexOf(null), 5);
		assertEquals("List content at index 6 should be undefined", list.indexOf(undefined), 6);
	}
	
	public function testToArray(Void):Void {
		var obj1:Object = new Object();
		var obj2:Object = new Object();
		var obj3:Object = new Object();
		
		assertSame("array representation should contain no elements", list.toArray().length, 0);
		list.insert(obj1);
		assertSame("array representation should contain one element", list.toArray().length, 1);
		assertSame("first element should be obj1", list.toArray()[0], obj1);
		list.insert(obj2);
		assertSame("array representation should contain two elements", list.toArray().length, 2);
		assertSame("first element should be obj1", list.toArray()[0], obj1);
		assertSame("second element should be obj2", list.toArray()[1], obj2);
		list.insert(obj3);
		assertSame("array representation should contain three elements", list.toArray().length, 3);
		assertSame("first element should be obj1", list.toArray()[0], obj1);
		assertSame("second element should be obj2", list.toArray()[1], obj2);
		assertSame("third element should be obj3", list.toArray()[2], obj3);
		
		list.clear();
		assertSame("array representation should again contain no elements", list.toArray().length, 0);
	}
	
}