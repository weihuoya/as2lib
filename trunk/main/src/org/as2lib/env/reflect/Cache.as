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
 * Cache is used to cache classes and packages. The caching of classes and packages
 * leads to higher performance. You also must cache them because for example the
 * parent of two classes residing in one package should be the same PackageInfo
 * instance.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.Cache extends BasicInterface {
	
	/**
	 * Releases all class and package infos that have been cached so
	 * far.
	 */
	public function releaseAll(Void):Void;
	
	/**
	 * Returns the ClassInfo representing either the class the object was instantiated
	 * of or the class that was passed in. If there is no corresponding ClassInfo
	 * cached nothing will be returned.
	 *
	 * @param object the instance or class the appropriate ClassInfo shall be returned
	 * @return the ClassInfo representing the class
	 * @throws IllegalArgumentException if the passed in object is neither of type function nor object
	 */
	public function getClass(object):ClassInfo;
	
	/**
	 * Adds a ClassInfo to the list of cached ClassInfos and returns the added
	 * ClassInfo.
	 * 
	 * @param info the ClassInfo that shall be added
	 * @return the added ClassInfo
	 */
	public function addClass(info:ClassInfo):ClassInfo;
	
	/**
	 * Returns the PackageInfo representing the package. If the appropriate PackageInfo
	 * has not been cached already and does thus not exist nothing will be returned.
	 *
	 * @param package the package the appropriate PackageInfo shall be found
	 * @return the PackageInfo representing the package
	 */
	public function getPackage(package):PackageInfo;
	
	/**
	 * Adds a PackageInfo to the list of cache PackageInfos and returns teh added
	 * PackageInfo.
	 *
	 * @param info the PackageInfo that shall be added
	 * @return the added PackageInfo
	 */
	public function addPackage(info:PackageInfo):PackageInfo;
	
	/**
	 * Returns the root of the whole hierachy.
	 *
	 * @return the root
	 */
	public function getRoot(Void):PackageInfo;
	
}