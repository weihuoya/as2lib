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
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.PackageAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;
import org.as2lib.env.reflect.algorithm.PackageMemberAlgorithm;
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
	
	/** The package member algorithm used to find package members. */
	private static var packageMemberAlgorithm:PackageMemberAlgorithm;
	
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
	 * Sets the algorithm used to find and store members of a package.
	 *
	 * @param algorithm the new algorithm to find and store the members
	 */
	public static function setPackageMemberAlgorithm(algorithm:PackageMemberAlgorithm):Void {
		packageMemberAlgorithm = algorithm;
	}
	
	/**
	 * Returns the algorithm used to find and store members.
	 *
	 * @return the algorithm to find and store members
	 */
	public static function getPackageMemberAlgorithm(Void):PackageMemberAlgorithm {
		if (!packageMemberAlgorithm) packageMemberAlgorithm = new PackageMemberAlgorithm();
		return packageMemberAlgorithm;
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
		if (!rootPackage) rootPackage = new PackageInfo("_global", _global, null);
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