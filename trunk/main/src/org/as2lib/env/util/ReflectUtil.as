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
import org.as2lib.data.holder.Map;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.NoSuchChildException;
import org.as2lib.env.reflect.RootInfo;
import org.as2lib.env.overload.Overload;

/**
 * This util class offers the basic functionality to use reflections. All operations
 * are static to provide an easy external access. It is not possible to instantiate
 * the class due to its private constructor.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.util.ReflectUtil extends BasicClass {
	/**
	 * The constructor is private to prevent instantiation.
	 */
	private function ReflectUtil(Void) {
	}
	
	/**
	 * Overload
	 * #getClassInfoByObject()
	 * #getClassInfoByName()
	 */
	public static function getClassInfo():ClassInfo {
		var overload:Overload = new Overload(eval("th" + "is"));
		overload.addHandler([Object], getClassInfoByObject);
		overload.addHandler([String], getClassInfoByName);
		return ClassInfo(overload.forward(arguments));
	}
	
	/**
	 * Returns the ClassInfo appropriate to the object containing all needed
	 * class information.
	 * It first checks based on the object whether an appropriate ClassInfo
	 * exists. If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorithm.
	 * By default this is the ClassAlgorithm. But you can set your own with the
	 * ReflectConfig#setClassAlgorithm() operation.
	 * 
	 * @param object the object the appropriate ClassInfo shall be found.
	 * @return the appropriate ClassInfo instance containing all class information
	 * @throws IllegalArgumentException if the passed in object is neither of type function nor object
	 */
	public static function getClassInfoByObject(object):ClassInfo {
		var info:ClassInfo = ReflectConfig.getCache().getClass(object);
		if (ObjectUtil.isEmpty(info)) {
			info = ClassInfo(ReflectConfig.getClassAlgorithm().execute(object));
			ReflectConfig.getCache().addClass(info);
		}
		return info;
	}
	
	/**
	 * Returns the ClassInfo corresponding to the passed name. The name must
	 * be composed of the class's path as well as its name.
	 *
	 * @param name the full name of the class
	 * @return a ClassInfo representing the class corresponding to the name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the class with the specified name does not exist
	 */
	public static function getClassInfoByName(name:String):ClassInfo {
		var clazz:Function = eval("_global." + name);
		if (ObjectUtil.isTypeOf(clazz, "function")) {
			return getClassInfoByObject(clazz);
		}
		throw new NoSuchChildException("The class [" + name + "] you tried to obtain does not exist.",
										eval("th" + "is"),
										arguments);
	}
	
	/**
	 * Overload
	 * #getPackageInfoByPackage()
	 * #getPackageInfoByName()
	 */
	public static function getPackageInfo():PackageInfo {
		var overload:Overload = new Overload(eval("th" + "is"));
		overload.addHandler([Object], getPackageInfoByPackage);
		overload.addHandler([String], getPackageInfoByName);
		return PackageInfo(overload.forward(arguments));
	}
	
	/**
	 * This operation returns the PackageInfo instance representing the package
	 * passed in. It first checks based on the passed in package whether an
	 * appropriate PackageInfo exists. If one exists it will be returned otherwise
	 * a new will be created. The responsibility for doing this lies in the
	 * suitable CacheAlgorithm. By default this is the PackageAlgorithm. But you
	 * can set your own with the ReflectConfig#setPackageAlgorithm() operation.
	 *
	 * @param package the package the appropriate PackageInfo shall be found.
	 * @return the appropriate PackageInfo instance containing all package information.
	 */
	public static function getPackageInfoByPackage(package):PackageInfo {
		var info:PackageInfo = ReflectConfig.getCache().getPackage(package);
		if (ObjectUtil.isEmpty(info)) {
			info = PackageInfo(ReflectConfig.getPackageAlgorithm().execute(package));
			ReflectConfig.getCache().addPackage(info);
		}
		return info;
	}
	
	/**
	 * Returns the PackageInfo corresponding to the passed name. The name must
	 * be composed of the package's path as well as its name.
	 *
	 * @param name the full name of the package
	 * @return a PackageInfo representing the package corresponding to the name
	 * @throws org.as2lib.env.reflect.NoSuchChildException if the package with the specified name does not exist
	 */
	public static function getPackageInfoByName(name:String):PackageInfo {
		var package:Object = eval("_global." + name);
		if (ObjectUtil.isTypeOf(package, "object")) {
			return getPackageInfoByPackage(package);
		}
		throw new NoSuchChildException("The package [" + name + "] you tried to obtain does not exist.",
										eval("th" + "is"),
										arguments);
	}
	
	/**
	 * Returns the root of the whole hierachy.
	 *
	 * @return the root of the hierachy
	 */
	public static function getRootInfo(Void):RootInfo {
		return ReflectConfig.getCache().getRoot();
	}
}