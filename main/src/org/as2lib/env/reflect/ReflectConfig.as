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
import org.as2lib.util.Stringifier;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.SimpleCache;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.string.MethodInfoStringifier;
import org.as2lib.env.reflect.string.PropertyInfoStringifier;

/**
 * ReflectConfig is the main config used to globally configure key parts of the
 * work the classes of the reflect package try to solve.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectConfig extends BasicClass {
	
	/** All ClassInfos and PackageInfos that have already been found will be cached here. */
	private static var cache:Cache;
	
	/** Stores the root package of the hierarchy. */
	private static var rootPackage:PackageInfo;
	
	/**
	 * Private constructor to prevent instantiation.
	 */
	private function ReflectConfig(Void) {
	}
	
	/**
	 * Returns the cache used to cache all ClassInfos and PackageInfos that have
	 * already been found.
	 *
	 * @return the cache used to cache ClassInfos and PackageInfos
	 */
	public static function getCache(Void):Cache {
		if (!cache) cache = new SimpleCache(getRootPackage());
		return cache;
	}
	
	/**
	 * Sets the new cache used to cache ClassInfos and PackageInfos.
	 *
	 * @param cache the new cache to be used
	 */
	public static function setCache(newCache:Cache):Void {
		cache = newCache;
	}
	
	/**
	 * @return the root package of the hierarchy.
	 */
	public static function getRootPackage(Void):PackageInfo {
		if (!rootPackage) rootPackage = new PackageInfo(_global, "_global", null);
		return rootPackage;
	}
	
	/**
	 * Sets the new root of the hierarchy.
	 *
	 * @param newRootPackage the new root package
	 */
	public static function setRootPackage(newRootPackage:PackageInfo):Void {
		rootPackage = newRootPackage;
	}
	
}