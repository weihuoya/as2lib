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
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorithm.ContentAlgorithm;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * Searches for children, that means classes and packages, of a specific
 * package. Sub-packages are not searched through.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.ChildrenAlgorithm extends BasicClass implements ContentAlgorithm {
	
	private var c:Cache;
	
	/**
	 * Constructs a new instance.
	 */
	public function ChildrenAlgorithm(Void) {
	}
	
	/**
	 * Sets the cache that gets used by the #execute(Object) method to
	 * look whether the child package or class is already stored.
	 *
	 * @param cache the new cache
	 */
	public function setCache(cache:Cache):Void {
		c = cache;
	}
	
	/**
	 * Returns the cache set via the #setCache(Cache) method or the default
	 * cache that gets returned by the ReflectConfig#getCache() method.
	 *
	 * @return the currently used cache
	 */
	public function getCache(Void):Cache {
		if (!c) c = ReflectConfig.getCache();
		return c;
	}
	
	/**
	 * Executes the search for the children, that means child classes and
	 * packages.
	 *
	 * <p>The resulting array contains instances of type CompositeMemberInfo,
	 * that is either of type ClassInfo or PackageInfo.
	 *
	 * <p>This method will return null if:
	 * <ul>
	 *   <li>The argument is null or undefined.</li>
	 *   <li>The argument is not of type PackageInfo.</li>
	 * </ul>
	 *
	 * <p>Only the passed-in package will be searched through.
	 *
	 * <p>In case the cache already contains a specific child class or package
	 * info it will be added to the children array.
	 *
	 * @param g the PackageInfo instance representing the package to search through
	 * @return the children of the package, a blank array or null
	 */
	public function execute(g:CompositeMemberInfo):Array {
		if (g == null) return null;
		var p:PackageInfo = PackageInfo(g);
		if (p == null) return null;
		getCache();
		var r:Array = new Array();
		var t:Object = p.getPackage();
		var i:String;
		for (i in t) {
			if (typeof(t[i]) == "function") {
				var b:ClassInfo = c.getClass(t[i]);
				if (!b) {
					b = c.addClass(new ClassInfo(i, t[i], p));
				}
				r[r.length] = b;
			} else if (typeof(t[i]) == "object") {
				var a:PackageInfo = c.getPackage(t[i]);
				if (!a) {
					a = c.addPackage(new PackageInfo(i, t[i], p));
				}
				r[r.length] = a;
			}
		}
		return r;
	}
	
}