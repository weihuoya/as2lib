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
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.Cache;

/**
 * SimpleCache is a simple and performant implementation of the Cache
 * interface.
 *
 * <p>The caching of classes and packages leads to higher performance. 
 * You also must cache them because for example the parent of two classes 
 * residing in the same package should be the same PackageInfo instance.
 *
 * <p>The cache is mostly used internally. But you can also use it to
 * add ClassInfo or PackageInfo instances directly so that they do not
 * have to be searched for. This can improve the performance dramatically
 * with classes or packages that are needed quite often.
 *
 * <p>This implementation sets a property with name '__as2lib__hashCode'
 * on every cached class and package to offer high performance. Do not
 * delete this property.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.SimpleCache extends BasicClass implements Cache {

	/** Stores added infos. */
	private var cache:Array;
	
	/** Stores the amount of generated hash codes. */
	private var hashCodeCounter:Number;
	
	/** The root represented by a PackageInfo instance. */
	private var root:PackageInfo;
	
	/**
	 * Constructs a new SimpleCache instance.
	 *
	 * <p>The root/default package determines where the ClassAlgorithm
	 * and PackageAlgorithm start their search.
	 *
	 * @param root the root/default package of the hierarchy
	 */
	public function SimpleCache(root:PackageInfo) {
		this.root = root;
		releaseAll();
	}
	
	/**
	 * Returns the class info representing either the class the object was
	 * instantiated of or the class that was passed in.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>There is no corresponding ClassInfo instance cached.</li>
	 *   <li>The passed-in object is null or undefined.</li>
	 * </ul>
	 *
	 * @param object the instance or class the appropriate class info shall be returned
	 * @return the class info representing the class
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
	 * Adds a class info to the list of cached class infos and returns the
	 * added class info.
	 * 
	 * @param info the class info to add
	 * @return the added class info
	 */
	public function addClass(info:ClassInfo):ClassInfo {
		if (!info) return null;
		var p = info.getType().prototype;
		cache[p.__as2lib__hashCode = hashCodeCounter++] = info;
		_global.ASSetPropFlags(p, "__as2lib__hashCode", 1, true);
		return info;
	}
	
	/**
	 * Returns the package info representing the package. 
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>There is no corresponding PackageInfo instance cached.</li>
	 *   <li>The passed-in package is null or undefined.</li>
	 * </ul>
	 *
	 * @param package the package the appropriate package info shall be returned
	 * @return the pakcage info representing the passed-in package
	 */
	public function getPackage(package):PackageInfo {
		if (!package) return null;
		return cache[package.__as2lib__hashCode];
	}
	
	/**
	 * Adds a package info to the cache and returns the added package info.
	 *
	 * @param info the package info to add
	 * @return the added package info
	 */
	public function addPackage(info:PackageInfo):PackageInfo {
		if (!info) return null;
		var p = info.getPackage();
		cache[p.__as2lib__hashCode = hashCodeCounter++] = info;
		_global.ASSetPropFlags(p, "__as2lib__hashCode", 1, true);
		return info;
	}
	
	/**
	 * Returns the root package of the whole package hierarchy.
	 *
	 * <p>The root package is also refered to as the default package.
	 *
	 * <p>The root/default package determines where the ClassAlgorithm
	 * and PackageAlgorithm start their search.
	 *
	 * @return the root/default package
	 */
	public function getRoot(Void):PackageInfo {
		return root;
	}
	
	/**
	 * Releases all cached class and package infos.
	 */
	public function releaseAll(Void):Void {
		cache = new Array();
		hashCodeCounter = 0;
		addPackage(root);
	}
	
}