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

import org.as2lib.core.BasicClass;

/**
 * ClassUtil contains fundamental operations to efficiently and easily work
 * with any class. All methods here are supposed to be used with functions treated
 * as classes.
 *
 * @author Martin Heidegger
 */
class org.as2lib.util.ClassUtil extends BasicClass {
	/** Private constructor. */
	private function BasicClass(Void) {}
	
	/**
	 * Checks if the fistly passed class is extended by the secondly passed class.
	 * 
	 * @param subClass class that shall be checked.
	 * @param superClass class that shall be matched
	 * @return true if subClass is a subclass of superClass
	 */
	public static function isSubClassOf(subClass:Function, superClass:Function):Boolean {
		if(subClass == null || superClass == null) {
			return false;
		} else if (subClass.prototype instanceof superClass){
			return true;
		}
	}
	
	/**
	 * Checks if the passed class implements the interface.
	 * 
	 * @param clazz class that shall be checked.
	 * @param interfaceObject interface that the class shall implement
	 * @author Martin Heidegger
	 * @author Ralf Bokelberg (www.qlod.com)
	 */
	public static function isImplementationOf(clazz:Function, interfaceObject:Function):Boolean {
		return (createCleanInstance(clazz) instanceof interfaceObject);
	}
	
	/**
	 * Creates a new Instance of a class without calling the constructor.
	 * 
	 * @param clazz	class to create a new Instance.
	 */
	public static function createCleanInstance(clazz:Function):Object {
		var result:Object = new Object();
		result.__proto__ = clazz.prototype;
		return result;
	}
}