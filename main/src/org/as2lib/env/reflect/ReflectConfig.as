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
import org.as2lib.util.Stringifier;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;
import org.as2lib.env.reflect.algorithm.ChildAlgorithm;
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
	
	/** The class algorithm used to find classes. */
	private static var classAlgorithm:ClassAlgorithm;
	
	/** The property algorithm used to find packages. */
	private static var packageAlgorithm:PackageAlgorithm;
	
	/** The method algorithm used to find methods. */
	private static var methodAlgorithm:MethodAlgorithm;
	
	/** The property algorithm used to find properties. */
	private static var propertyAlgorithm:PropertyAlgorithm;
	
	/** The child algorithm used to find children. */
	private static var childAlgorithm:ChildAlgorithm;
	
	/** All ClassInfos and PackageInfos that have already been found will be cached here. */
	private static var cache:Cache = new SimpleCache();
	
	/** Used to stringify MethodInfo instances. */
	private static var methodInfoStringifier:Stringifier;
	
	/** Used to stringify PropertyInfo instances. */
	private static var propertyInfoStringifier:Stringifier;
	
	/**
	 * Private constructor to prevent instantiation.
	 */
	private function ReflectConfig(Void) {
	}
	
	/**
	 * Sets the algorithm used to return the appropriate ClassInfo instance
	 * of a specific instance or class.
	 *
	 * @param algorithm the new class algortihm to return appropriate ClassInfo instances
	 */
	public static function setClassAlgorithm(algorithm:ClassAlgorithm):Void {
		classAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find classes and return ClassInfo instances
	 * representing this classes.
	 *
	 * @return the algorithm used to return ClassInfo instances
	 */
	public static function getClassAlgorithm(Void):ClassAlgorithm {
		if (!classAlgorithm) classAlgorithm = new ClassAlgorithm();
		return classAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to return the appropriate PackageInfo instance of a 
	 * specific package.
	 *
	 * @param algorithm the new algorithm to return appropriate PackageInfo instances
	 */
	public static function setPackageAlgorithm(algorithm:PackageAlgorithm):Void {
		packageAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find packages and return PackageInfo instances 
	 * representing this packages.
	 *
	 * @return the algorithm used to return appropriate PackageInfo instances
	 */
	public static function getPackageAlgorithm(Void):PackageAlgorithm {
		if (!packageAlgorithm) packageAlgorithm = new PackageAlgorithm();
		return packageAlgorithm;
	}
	
	/** 
	 * Sets the algorithm used to find MethodInfo instances representing
	 * methods of a class.
	 *
	 * @param algorithm the new algorithm to find and store MethodInfo instances
	 */
	public static function setMethodAlgorithm(algorithm:MethodAlgorithm):Void {
		methodAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find MethodInfo instances.
	 *
	 * @return the algorithm to find MethodInfo instances
	 */
	public static function getMethodAlgorithm(Void):MethodAlgorithm {
		if (!methodAlgorithm) methodAlgorithm = new MethodAlgorithm();
		return methodAlgorithm;
	}
	
	/** 
	 * Sets the algorithm used to find PropertyInfo instances representing
	 * properties of a class.
	 *
	 * @param algorithm the new algorithm to find PropertyInfo instances
	 */
	public static function setPropertyAlgorithm(algorithm:PropertyAlgorithm):Void {
		propertyAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find PropertyInfo instances.
	 *
	 * @return the algorithm to find PropertyInfo instances
	 */
	public static function getPropertyAlgorithm(Void):PropertyAlgorithm {
		if (!propertyAlgorithm) propertyAlgorithm = new PropertyAlgorithm();
		return propertyAlgorithm;
	}
	
	/** 
	 * Sets the algorithm used to find and store children of a package.
	 *
	 * @param algorithm the new algorithm to find and store the children
	 */
	public static function setChildAlgorithm(algorithm:ChildAlgorithm):Void {
		childAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find and store children.
	 *
	 * @return the algorithm to find and store children
	 */
	public static function getChildAlgorithm(Void):ChildAlgorithm {
		if (!childAlgorithm) childAlgorithm = new ChildAlgorithm();
		return childAlgorithm;
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