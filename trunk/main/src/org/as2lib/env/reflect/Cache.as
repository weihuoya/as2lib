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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.util.ObjectUtil;

/**
 * Cache chaches classes and packages.
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
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.Cache extends BasicInterface {
	
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
	public function getClass(object):ClassInfo;
	
	/**
	 * Adds a class info to the list of cached class infos and returns the
	 * added class info.
	 * 
	 * @param info the class info to add
	 * @return the added class info
	 */
	public function addClass(info:ClassInfo):ClassInfo;
	
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
	public function getPackage(package):PackageInfo;
	
	/**
	 * Adds a package info to the cache and returns the added package info.
	 *
	 * @param info the package info to add
	 * @return the added package info
	 */
	public function addPackage(info:PackageInfo):PackageInfo;
	
	/**
	 * Returns the root package of the whole package hierarchy.
	 *
	 * <p>The root package is also refered to as the default package.
	 *
	 * <p>The root/default package set determines where the ClassAlgorithm
	 * and PackageAlgorithm start their search.
	 *
	 * @return the root/default package
	 */
	public function getRoot(Void):PackageInfo;
	
	/**
	 * Releases all cached class and package infos.
	 */
	public function releaseAll(Void):Void;
	
}