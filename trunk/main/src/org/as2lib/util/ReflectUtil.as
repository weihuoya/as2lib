﻿import org.as2lib.basic.BasicClass;
import org.as2lib.basic.reflect.Cache;
import org.as2lib.basic.reflect.ClassInfo;
import org.as2lib.basic.reflect.PackageInfo;
import org.as2lib.data.Hashtable;
import org.as2lib.basic.reflect.algorythm.CacheAlgorythm;
import org.as2lib.basic.reflect.algorythm.ContentAlgorythm;
import org.as2lib.basic.reflect.algorythm.ClassAlgorythm;
import org.as2lib.basic.reflect.algorythm.SuperClassAlgorythm;
import org.as2lib.basic.reflect.algorythm.PackageAlgorythm;
import org.as2lib.basic.reflect.algorythm.MethodAlgorythm;
import org.as2lib.basic.reflect.algorythm.PropertyAlgorythm;
import org.as2lib.basic.reflect.algorythm.ChildrenAlgorythm;
import org.as2lib.util.ObjectUtil;

/**
 * @author Simon Wacker
 * 
 * This util class offers the basic functionality to use reflections.
 * All operations are static to provide an easy external access.
 * It is not possible to instantiate the class due to its private constructor.
 */

class org.as2lib.util.ReflectUtil extends BasicClass {
	/** All classes and packages that have already been found will be cached here. */
	private static var cache:Cache = new Cache();
	private static var classAlgorythm:CacheAlgorythm = new ClassAlgorythm(cache);
	private static var packageAlgorythm:CacheAlgorythm = new PackageAlgorythm(cache);
	private static var superClassAlgorythm:ContentAlgorythm = new SuperClassAlgorythm(cache);
	private static var methodAlgorythm:ContentAlgorythm = new MethodAlgorythm(cache);
	private static var propertyAlgorythm:ContentAlgorythm = new PropertyAlgorythm(cache);
	private static var childrenAlgorythm:ContentAlgorythm = new ChildrenAlgorythm(cache);
	
	/**
	 * The constructor is private to prevent an instantiation.
	 */
	private function ReflectUtil(Void) {
	}
	
	/**
	 * This is the core operation of the class.
	 * It returns the ClassInfo instance appropriate to the Object containing all needed class information.
	 * It first checks based on the Object whether an appropriate ClassInfo instance exists.
	 * If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorythm.
	 * By default this is the ClassAlgorythm. But you can set your own with the setClassAlgorythm() operation.
	 * 
	 * @param The Object the appropriate ClassInfo shall be found.
	 * @return The appropriate ClassInfo instance containing all class information.
	 */
	public static function getClassInfo(object:Object):ClassInfo {
		if (ObjectUtil.isEmpty(cache.getClass(object))) {
			classAlgorythm.execute(object);
		}
		return cache.getClass(object);
	}
	
	/**
	 * This operation returns the PackageInfo instance representing the package passed in.
	 * It first checks based on the passed in Object whether an appropriate PackageInfo instance exists.
	 * If one exists it will be returned otherwise a new will be created.
	 * The responsibility for doing this lies in the suitable CacheAlgorythm.
	 * By default this is the PackageAlgorythm. But you can set your own with the setPackageAlgorythm() operation.
	 *
	 * @param The package the appropriate PackageInfo shall be found.
	 * @return The appropriate PackageInfo instance containing all package information.
	 */
	public static function getPackageInfo(package:Object):PackageInfo {
		if (ObjectUtil.isEmpty(cache.getPackage(package))) {
			packageAlgorythm.execute(package);
		}
		return cache.getPackage(package);
	}
	
	/**
	 * This operation returns the super class based on the passed in ClassInfo instance.
	 * It first checks if the ClassInfo of the searched for class already exists.
	 * If not it will use the appropriate ContentAlgorythm to find the class and create a ClassInfo instance of it.
	 * Otherwise the ClassInfo just will be returned.
	 * Do algorythm to find and store the super class can be set by you via the setSuperClassAlgorythm() operation.
	 *
	 * @param The ClassInfo instance the super class shall be returned.
	 * @return The ClassInfo instance representing the super class.
	 */
	public static function getSuperClass(info:ClassInfo):ClassInfo {
		if (ObjectUtil.isEmpty(cache.getClass(info.getClass().prototype))) {
			superClassAlgorythm.execute(info);
		}
		return cache.getClass(info.getClass().prototype);
	}
	
	/**
	 * This operation returns a Hashtable containing the MethodInfo instances representing the methods.
	 * The problem right now is that public and private methods are not distinguished.
	 * This is due to the impossibility of finding out (at runtime) whether the method is private or public.
	 *
	 * @param The ClassInfo instance representing the class the methods shall be searched for.
	 * @return A Hashtable holding MethodInfo instances for each method.
	 */
	public static function getMethods(info:ClassInfo):Hashtable {
		return methodAlgorythm.execute(info);
	}
	
	/** 
	 * This operation returns a Hashtable containing the PropertyInfo instances representing the Properties.
	 * Properties are set in Flash MX 2004 via the set and get keyword.
	 *
	 * @param The ClassInfo instance representing the class the methods shall be searched for.
	 * @return A Hashtable holding PropertyInfo instances for each property.
	 */
	public static function getProperties(info:ClassInfo):Hashtable {
		return propertyAlgorythm.execute(info);
	}
	
	/**
	 * This operation returns the children of a package.
	 * Children can be either of type ClassInfo or PackageInfo.
	 *
	 * @param A PackageInfo instance representing the package the children shall be returned.
	 * @return A Hashtable containing all children of the appropriate package.
	 */
	public static function getChildren(info:PackageInfo):Hashtable {
		return childrenAlgorythm.execute(info);
	}
	
	/**
	 * Sets the CacheAlgorythm used by the getClassInfo() operation.
	 */
	public static function setClassAlgorythm(algorythm:CacheAlgorythm):Void {
		classAlgorythm = algorythm;
	}
	
	/** 
	 * Sets the CacheAlgorythm used by the getPackageInfo() operation.
	 */
	public static function setPackageAlgorythm(algorythm:CacheAlgorythm):Void {
		packageAlgorythm = algorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getSuperClass() operation.
	 */
	public static function setSuperClassAlgorythm(algorythm:ContentAlgorythm):Void {
		superClassAlgorythm = algorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getMethods() operation.
	 */
	public static function setMethodAlgorythm(algorythm:ContentAlgorythm):Void {
		methodAlgorythm = algorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getProperties() operation.
	 */
	public static function setPropertyAlgorythm(algorythm:ContentAlgorythm):Void {
		propertyAlgorythm = algorythm;
	}
	
	/** 
	 * Sets the ContentAlgorythm used by the getChildren() operation.
	 */
	public static function setChildrenAlgorythm(algorythm:ContentAlgorythm):Void {
		childrenAlgorythm = algorythm;
	}
}