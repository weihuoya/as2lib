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
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.TypedMap;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Iterator;
import test.unit.org.as2lib.data.holder.AbstractTMap;
import org.as2lib.env.except.IllegalArgumentException;

/**
 * Test for a TypedMap. It contains all standard Map tests and extended tests for
 * the type related methods
 * 
 * @author Martin Heidegger
 */
class test.unit.org.as2lib.data.holder.map.TTypedMap extends AbstractTMap {
	
	/**
	 * Extended Template Method of AbstractTMap.getMap.
	 * 
	 * @return New instance of a TypedMap that wrapps a HashMap
	 */
	public function getMap(Void):Map {
		return new TypedMap(Object, new HashMap());
	}
	
	/**
	 * Test if put also works with note expected types properly.
	 */
	public function testPut(Void):Void {
		var map:Map = new TypedMap(String, new HashMap());
		assertThrows("A IllegalArgumentException should be thrown if the wrong type of content (1) was put to the map", IllegalArgumentException, map, "put", ["a", 2]);
	}
	
	/**
	 * Tests putAll with not allowed types.
	 */
	public function testPutAll(Void):Void {
		super.testPutAll();
		var map:Map = new TypedMap(String, new HashMap());
		var map2:Map = new TypedMap(Number, new HashMap());
		map2.put("a", 1);
		map2.put("b", 2);
		assertThrows("A IllegalArgumentException should be thrown if the wrong type of content (1) was put to the map", IllegalArgumentException, map, "putAll", [map2]);
	}
}