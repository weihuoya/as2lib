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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.RootInfo;
import org.as2lib.env.reflect.Cache;

/**
 * A simple implementation of the Cache interface. This implementation
 * sets a property with name '__as2lib__hashCode' on every cached class
 * and package to offer high performance.
 *
 * @author Simon Wacker
 * @see org.as2lib.env.reflect.Cache
 */
class org.as2lib.env.reflect.SimpleCache extends BasicClass implements Cache {

	/** Stores added infos. */
	private var cache:Array;
	
	/** Stores the amount of generated hash codes. */
	private var hashCodeCounter:Number;
	
	/** The root represented by a RootInfo. */
	private var root:RootInfo;
	
	/**
	 * Constructs a new Cache instance.
	 */
	public function SimpleCache(Void) {
		root = RootInfo.getInstance();
		releaseAll();
	}
	
	/**
	 * @see Cache#releaseAll()
	 */
	public function releaseAll(Void):Void {
		cache = new Array();
		hashCodeCounter = 0;
		addPackage(root);
	}
	
	/**
	 * Returns the ClassInfo representing either the class the object was instantiated
	 * of or the class that was passed in.
	 *
	 * <p>Null or undefined will be returned if:
	 * <ul>
	 *   <li>There is no corresponding class info cached.</li>
	 *   <li>The passed-in argument is null or undefined.</li>
	 * </ul>
	 *
	 * @param object the instance or class the appropriate ClassInfo shall be returned
	 * @return the ClassInfo representing the class or null or undefined
	 */
	public function getClass(object):ClassInfo {
		if (object == null) return null;
		if (typeof(object) == "function") {
			var p:Object = object.prototype;
			var c:Number = p.__as2lib__hashCode;
			if (c == undefined) return null;
			if (c == p.__proto__.__as2lib__hashCode) {
				return null;
			}
			return cache[c];
		} else {
			var p:Object = object.__proto__;
			var c:Number = p.__as2lib__hashCode;
			if (c == undefined) return null;
			if (c == p.__proto__.__as2lib__hashCode) {
				return null;
			}
			return cache[c];
		}
	}
	
	/**
	 * Adds a ClassInfo to the list of cached ClassInfos and returns the added
	 * ClassInfo. If the ClassInfo to add is null or undefined, null will be
	 * returned.
	 * 
	 * @param info the ClassInfo that shall be added
	 * @return the added ClassInfo or null
	 */
	public function addClass(info:ClassInfo):ClassInfo {
		if (!info) return null;
		var p = info.getType().prototype;
		cache[p.__as2lib__hashCode = hashCodeCounter++] = info;
		_global.ASSetPropFlags(p, "__as2lib__hashCode", 1, true);
		return info;
	}
	
	/**
	 * Returns the PackageInfo representing the package.
	 *
	 * <p>Null or undefined will be returned if:
	 * <ul>
	 *   <li>The appropriate package info has not been cached already.</li>
	 *   <li>The passed-in argument is null or undefined.</li>
	 * </ul>
	 *
	 * @param package the package the appropriate PackageInfo shall be found
	 * @return the PackageInfo representing the package or null or undefined
	 */
	public function getPackage(package):PackageInfo {
		if (!package) return null;
		return cache[package.__as2lib__hashCode];
	}
	
	/**
	 * Adds a PackageInfo to the list of cache PackageInfos and returns the added
	 * PackageInfo. If the PackageInfo is null or undefined, null will be returned.
	 *
	 * @param info the PackageInfo that shall be added
	 * @return the added PackageInfo or null
	 */
	public function addPackage(info:PackageInfo):PackageInfo {
		if (!info) return null;
		var p = info.getPackage();
		cache[p.__as2lib__hashCode = hashCodeCounter++] = info;
		_global.ASSetPropFlags(p, "__as2lib__hashCode", 1, true);
		return info;
	}
	
	/**
	 * Returns the root of the whole hierachy.
	 *
	 * @return the root
	 */
	public function getRoot(Void):RootInfo {
		return root;
	}
	
}