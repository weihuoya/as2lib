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
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.algorithm.CacheAlgorithm;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.algorithm.ContentAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;
import org.as2lib.env.reflect.algorithm.ChildrenAlgorithm;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.reflect.SimpleCache;
import org.as2lib.env.reflect.string.MethodInfoStringifier;
import org.as2lib.env.reflect.string.PropertyInfoStringifier;

/**
 * ReflectConfig is the main config used to globally configure key parts of the
 * work the classes of the reflect package try to solve.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectConfig extends BasicClass {
	/** The CacheAlgorithm used to find classes. */
	private static var classAlgorithm:CacheAlgorithm;
	
	/** The CacheAlgorithm used to find packages. */
	private static var packageAlgorithm:CacheAlgorithm;
	
	/** The ContentAlgorithm used to find methods. */
	private static var methodAlgorithm:ContentAlgorithm;
	
	/** The ContentAlgorithm used to find properties. */
	private static var propertyAlgorithm:ContentAlgorithm;
	
	/** The ContentAlgorithm used to find children. */
	private static var childrenAlgorithm:ContentAlgorithm;
	
	/** All ClassInfos and PackageInfos that have already been found will be cached here. */
	private static var cache:Cache = new SimpleCache();
	
	/** Used to stringify MethodInfo instances. */
	private static var methodInfoStringifier:Stringifier;
	
	/** Used to stringify PropertyInfo instances. */
	private static var propertyInfoStringifier:Stringifier;
	
	/**
	 * Private constructor to prevent an instantiation.
	 */
	private function ReflectConfig(Void) {
	}
	
	/**
	 * Sets the CacheAlgorithm used to return the appropriate ClassInfo of a specific
	 * instance.
	 *
	 * @param algorithm the new CacheAlgorithm to return appropriate ClassInfos
	 */
	public static function setClassAlgorithm(algorithm:CacheAlgorithm):Void {
		classAlgorithm = algorithm;
	}
	
	/**
	 * Returns the CacheAlgorithm used to find classes and return ClassInfos 
	 * representing this classes.
	 *
	 * @return the CacheAlgorithm used to return ClassInfos
	 */
	public static function getClassAlgorithm(Void):CacheAlgorithm {
		if (!classAlgorithm) classAlgorithm = new ClassAlgorithm();
		return classAlgorithm;
	}
	
	/**
	 * Sets the CacheAlgorithm used to return the appropriate PackageInfo of a 
	 * specific instance.
	 *
	 * @param algorithm the new CacheAlgorithm to return appropriate PackageInfos
	 */
	public static function setPackageAlgorithm(algorithm:CacheAlgorithm):Void {
		packageAlgorithm = algorithm;
	}
	
	/**
	 * Returns the CacheAlgorithm used to find packages and return ClassInfos 
	 * representing this packages.
	 *
	 * @return the CacheAlgorithm used to return PackageInfos
	 */
	public static function getPackageAlgorithm(Void):CacheAlgorithm {
		if (!packageAlgorithm) packageAlgorithm = new PackageAlgorithm();
		return packageAlgorithm;
	}
	
	/** 
	 * Sets the ContentAlgorithm used to find and store MethodInfos representing
	 * operations of a class.
	 *
	 * @param algorithm the new ContentAlgorithm to find and store MethodInfos
	 */
	public static function setMethodAlgorithm(algorithm:ContentAlgorithm):Void {
		methodAlgorithm = algorithm;
	}
	
	/**
	 * Returns the ContentAlgorithm used to find and store MethodInfos.
	 *
	 * @return the ContentAlgorithm to find and store MethodInfos
	 */
	public static function getMethodAlgorithm(Void):ContentAlgorithm {
		if (!methodAlgorithm) methodAlgorithm = new MethodAlgorithm();
		return methodAlgorithm;
	}
	
	/** 
	 * Sets the ContentAlgorithm used to find and store PropertyInfos representing
	 * properties of a class.
	 *
	 * @param algorithm the new ContentAlgorithm to find and store PropertyInfos
	 */
	public static function setPropertyAlgorithm(algorithm:ContentAlgorithm):Void {
		propertyAlgorithm = algorithm;
	}
	
	/**
	 * Returns the ContentAlgorithm used to find and store PropertyInfos.
	 *
	 * @return the ContentAlgorithm to find and store PropertyInfos
	 */
	public static function getPropertyAlgorithm(Void):ContentAlgorithm {
		if (!propertyAlgorithm) propertyAlgorithm = new PropertyAlgorithm();
		return propertyAlgorithm;
	}
	
	/** 
	 * Sets the ContentAlgorithm used to find and store childrens of a package.
	 *
	 * @param algorithm the new ContentAlgorithm to find and store the children
	 */
	public static function setChildrenAlgorithm(algorithm:ContentAlgorithm):Void {
		childrenAlgorithm = algorithm;
	}
	
	/**
	 * Returns the ContentAlgorithm used to find and store children.
	 *
	 * @return the ContentAlgorithm to find and store children
	 */
	public static function getChildrenAlgorithm(Void):ContentAlgorithm {
		if (!childrenAlgorithm) childrenAlgorithm = new ChildrenAlgorithm();
		return childrenAlgorithm;
	}
	
	/**
	 * Returns the cache used to cache all ClassInfos and PackageInfos that have
	 * already been found.
	 *
	 * @return the cache used to cache ClassInfos and PackageInfos
	 */
	public static function getCache(Void):Cache {
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
	 * Sets the new Stringifier to stringify MethodInfos.
	 *
	 * @param stringifier the new MethodInfo Stringifier
	 */
	public static function setMethodInfoStringifier(stringifier:Stringifier):Void {
		methodInfoStringifier = stringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify MethodInfos.
	 *
	 * @return the Stringifier used to stringify MethodInfos
	 */
	public static function getMethodInfoStringifier(Void):Stringifier {
		if (!methodInfoStringifier) methodInfoStringifier = new MethodInfoStringifier();
		return methodInfoStringifier;
	}
	
	/**
	 * Sets the new Stringifier to stringify PropertyInfos.
	 *
	 * @param stringifier the new PropertyInfo Stringifier
	 */
	public static function setPropertyInfoStringifier(stringifier:Stringifier):Void {
		propertyInfoStringifier = stringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify PropertyInfos.
	 *
	 * @return the Stringifier used to stringify PropertyInfos
	 */
	public static function getPropertyInfoStringifier(Void):Stringifier {
		if (!propertyInfoStringifier) propertyInfoStringifier = new PropertyInfoStringifier();
		return propertyInfoStringifier;
	}
}