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
import org.as2lib.env.overload.Overload;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.TypeMemberFilter;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;

/**
 * ClassInfo reflects a real class in the Flash environment. This class
 * is used to get information about the class it represents.
 *
 * <p>You can use the static search methods #forName, #forObject, #forInstance
 * and #forClass.
 *
 * <p>If you for example have an instance you wanna get information about
 * you first must retrieve the appropriate ClassInfo instance and you
 * can then use its methods to get the wanted information.
 * 
 * <code>var myInstance:MyClass = new MyClass();
 * var classInfo:ClassInfo = ClassInfo.forInstance(myInstance);
 * trace("Class name: " + classInfo.getFullName());
 * trace("Super class name: " + classInfo.getSuperType().getFullName());
 * trace("Declared methods: " + classInfo.getMethods(true));
 * trace("Declared properties: " + classInfo.getProperties(true));</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ClassInfo extends BasicClass implements TypeInfo {
	
	/** The name of the class. */
	private var name:String;
	
	/** The full name of the class. This means the name with the whole path. */
	private var fullName:String;
	
	/** The class this ClassInfo represents. */
	private var clazz:Function;
	
	/** The super class's ClassInfo of the class. */
	private var superClass:ClassInfo;
	
	/** The package that contains the class. */
	private var parent:PackageInfo;
	
	/** The methods the class has. */
	private var methods:Array;
	
	/** The properties of the class. */
	private var properties:Array;
	
	/** The class's constructor. */
	private var classConstructor:ConstructorInfo;
	
	/** Stores the algorithm to find classes. */
	private var classAlgorithm:ClassAlgorithm;
	
	/** Stores the algorithm to find methods of this class. */
	private var methodAlgorithm:MethodAlgorithm;
	
	/** Stores the algorithm to find properties of this class. */
	private var propertyAlgorithm:PropertyAlgorithm;
	
	/**
	 * Returns the class info corresponding to the passed-in name.
	 *
	 * <p>The name is composed of the class's path as well as its name.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in name is null, undefined or a blank string.</li>
	 *   <li>There is no class with the given name.</li>
	 *   <li>The object corresponding to the name is not of type function.</li>
	 * </ul>
	 *
	 * @param className the full name of the class
	 * @return a class info representing the class corresponding to the name
	 */
	public static function forName(className:String):ClassInfo {
		if (!className) return null;
		var c:Function = eval("_global." + className);
		if (c) {
			if (typeof(c) == "function") {
				return forClass(c);
			}
		}
		return null;
	}
	
	/**
	 * Returns the class info corresponding to the passed-in object.
	 *
	 * <p>If the passed-in object is of type function it is supposed
	 * that this is the class you wanna get the class info for.
	 * Otherwise it is supposed that the object is an instance of a
	 * specific class you wanna get the class info for.
	 *
	 * <p>This method first checks whether the class is already contained
	 * in the cache.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The object is null or undefined.</li>
	 *   <li>The class info corresponding to the object could not be generated.</li>
	 * </ul>
	 *
	 * @param object the object you wanna get a class info for
	 * @return the class info corresponding to the object
	 */
	public static function forObject(object):ClassInfo {
		// not '!object' because parameter 'object' could be a blank string
		if (object == null) return null;
		var info:ClassInfo = ReflectConfig.getCache().getClass(object);
		if (!info) {
			info = ReflectConfig.getClassAlgorithm().execute(object);
		}
		return info;
	}
	
	/**
	 * This method does the same as the #forObject(*):ClassInfo method.
	 * It is planned to separate the class algorithm into two. One that
	 * searches specifically for instances and one that searches for
	 * classes to gain performance.
	 */
	public static function forInstance(instance):ClassInfo {
		// not '!instance' because parameter 'instance' could be a blank string
		if (instance == null) return null;
		return forObject(instance);
	}
	
	/**
	 * This method does the same as the #forObject(*):ClassInfo method.
	 * It is planned to separate the class algorithm into two. One that
	 * searches specifically for instances and one that searches for
	 * classes to gain performance.
	 */
	public static function forClass(clazz:Function):ClassInfo {
		if (!clazz) return null;
		return forObject(clazz);
	}
	
	/**
	 * Constructs a new ClassInfo.
	 *
	 * <p>All arguments are allowed to be null, but keep in mind that not
	 * all methods will function if one is.
	 * 
	 * @param name the name of the class
	 * @param class the class the newly created ClassInfo represents
	 * @param parent the parent of the class
	 */
	public function ClassInfo(name:String, 
							  clazz:Function, 
							  parent:PackageInfo) {
		this.name = name;
		this.clazz = clazz;
		this.parent = parent;
	}
	
	/**
	 * Sets the algorithm used to find classes. 
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * #getClassAlgorithm() will return the default one.
	 *
	 * <p>This algorithm is used by the #getSuperType() method.
	 *
	 * @param classAlgorithm the new class algorithm to find classes
	 * @see #getClassAlgorithm(Void):ClassAlgorithm
	 */
	public function setClassAlgorithm(classAlgorithm:ClassAlgorithm):Void {
		this.classAlgorithm = classAlgorithm;
	}
	
	/**
	 * Returns the class algorithm used to find classes.
	 *
	 * <p>Either the algorithm set via #setClassAlgorithm() will be
	 * returned or the default class algorithm returned by the
	 * ReflectConfig#getClassAlgorithm() method.
	 *
	 * <p>If you set an algorithm of value null or undefined the default
	 * one will be used.
	 *
	 * @return the currently used class algorithm
	 * @see #setClassAlgorithm(ClassAlgorithm):Void
	 */
	public function getClassAlgorithm(Void):ClassAlgorithm {
		if (!classAlgorithm) classAlgorithm = ReflectConfig.getClassAlgorithm();
		return classAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to find methods.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * #getMethodAlgorithm() will return the default one.
	 *
	 * <p>This algorithm is used by the #getMethods() method.
	 *
	 * @param methodAlgorithm the new method algorithm to find methods
	 * @see #getMethodAlgorithm(Void):MethodAlgorithm
	 */
	public function setMethodAlgorithm(methodAlgorithm:MethodAlgorithm):Void {
		this.methodAlgorithm = methodAlgorithm;
	}
	
	/**
	 * Returns the method algorithm used to find methods.
	 *
	 * <p>Either the algorithm set via #setMethodAlgorithm() will be
	 * returned or the default method algorithm returned by the
	 * ReflectConfig#getMethodAlgorithm() method.
	 *
	 * <p>If you set an algorithm of value null or undefined the default
	 * one will be used.
	 *
	 * @return the currently used method algorithm
	 * @see #setMethodAlgorithm(MethodAlgorithm):Void
	 */
	public function getMethodAlgorithm(Void):MethodAlgorithm {
		if (!methodAlgorithm) methodAlgorithm = ReflectConfig.getMethodAlgorithm();
		return methodAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to find properties.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * #getPropertyAlgorithm() will return the default one.
	 *
	 * <p>This algorithm is used by the #getProperties() method.
	 *
	 * @param propertyAlgorithm the new property algorithm to find properties
	 * @see #getPropertyAlgorithm(Void):PropertyAlgorithm
	 */
	public function setPropertyAlgorithm(propertyAlgorithm:PropertyAlgorithm):Void {
		this.propertyAlgorithm = propertyAlgorithm;
	}
	
	/**
	 * Returns the property algorithm used to find properties.
	 *
	 * <p>Either the algorithm set via #setPropertyAlgorithm() will be
	 * returned or the default property algorithm returned by the
	 * ReflectConfig#getPropertyAlgorithm() method.
	 *
	 * <p>If you set an algorithm of value null or undefined the default
	 * one will be used.
	 *
	 * @return the currently used property algorithm
	 * @see #setPropertyAlgorithm(PropertyAlgorithm):Void
	 */
	public function getPropertyAlgorithm(Void):PropertyAlgorithm {
		if (!propertyAlgorithm) propertyAlgorithm = ReflectConfig.getPropertyAlgorithm();
		return propertyAlgorithm;
	}
	
	/**
	 * Returns the name of the class without its namespace.
	 *
	 * <p>The namespace is the package path to the class. The namespace of
	 * the class 'org.as2lib.core.BasicClass' is 'org.as2lib.core'. In this
	 * example this method would only return 'BasicClass'.
	 *
	 * @reutrn the name of the class
	 * @see #getFullName(Void):String
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the represented class. That means the name
	 * of the class plus its package path, namespace.
	 *
	 * <p>The path will not be included if:
	 * <ul>
	 *   <li>The #getParent method returns null or undefined.</li>
	 *   <li>The #getParent method returns a package whose #isRoot method returns true.</li>
	 * </ul>
	 *
	 * @return the full name of the represented class
	 * @see #getName(Void):String
	 */
	public function getFullName(Void):String {
		if (fullName === undefined) {
			if (getParent().isRoot() || !getParent()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	/**
	 * Returns the actual class this class info represents.
	 *
	 * @return the represented class
	 */
	public function getType(Void):Function {
		return clazz;
	}
	
	/**
	 * Returns the class's constructor representation.
	 *
	 * <p>If the #getType method returns null or undefined, null will be
	 * returned.
	 *
	 * <p>You can use the returned ConstructorInfo instance to get the actual
	 * constructor. Note that the constructor in Flash is the same as the
	 * class. Thus #getType() and #getConstructor()#getMethod() return the
	 * same.
	 *
	 * @return the constructor of the class.
	 */
	public function getConstructor(Void):ConstructorInfo {
		if (classConstructor === undefined) {
			if (getType()) {
				classConstructor = new ConstructorInfo(getType(), this);
			} else {
				classConstructor = null;
			}
		}
		return classConstructor;
	}
	
	/**
	 * Returns the super class of the class this class info instance
	 * represents.
	 *
	 * <p>The returned instance is of type ClassInfo and can thus be
	 * casted to ClassInfo.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The represented type is Object.</li>
	 *   <li>The represented type has no prototype.</li>
	 *   <li>The super type could not be found.</li>
	 * </ul>
	 *
	 * @return the super class of the class this info represents
	 * @see #setClassAlgorithm(ClassAlgorithm):Void
	 */
	public function getSuperType(Void):TypeInfo {
		if (superClass === undefined) {
			if (clazz.prototype.__proto__) {
				superClass = ClassInfo(getClassAlgorithm().execute(clazz.prototype));
			} else {
				superClass = null;
			}
		}
		return superClass;
	}
	
	/**
	 * Creates a new instance of the class passing the constructor arguments.
	 *
	 * <p>Null will be returned if the #getType method returns null or
	 * undefined.
	 *
	 * <p>The passed-in args are allowed to be null or undefined. This gets
	 * interpreted as 'pass no arguments'.
	 *
	 * @param args the arguments to pass-in to the constructor on creation
	 * @return a new instance of the class
	 */
	public function newInstance(args:Array) {
		if (!clazz) return null;
		var result:Object = new Object();
		result.__proto__ = clazz.prototype;
		clazz.apply(result, args);
		return result;
	}
	
	/**
	 * Returns the parent package of the represented class.
	 *
	 * <p>The parent is the package the class is resides in. The parent of
	 * org.as2lib.core.BasicClass is org.as2lib.core.
	 *
	 * @return the parent package of the represented class
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * @overload #getMethodsByFlag(Boolean):Array
	 * @overload #getMethodsByFilter(TypeMemberFilter):Array
	 */
	public function getMethods():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getMethodsByFlag);
		o.addHandler([Boolean], getMethodsByFlag);
		o.addHandler([TypeMemberFilter], getMethodsByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing the methods represented by MethodInfos
	 * this type declares and maybe the ones of the super types.
	 *
	 * <p>The super types' methods are included if you pass-in false, null
	 * or undefined and excluded/filtered if you pass-in true.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The #getType method returns null or undefined.</li>
	 *   <li>The method algorithm returns null or undefined.</li>
	 * </ul>
	 *
	 * @param filterSuperTypes (optional) determines whether the super types'
	 * methods shall be excluded, that means filtered (true) or included (false)
	 * @return an array containing the methods
	 */
	public function getMethodsByFlag(filterSuperTypes:Boolean):Array {
		if (!getType()) return null;
		if (methods === undefined) {
			methods = getMethodAlgorithm().execute(this);
		}
		var result:Array = methods.concat();
		if (!filterSuperTypes) {
			if (getSuperType() != null) {
				result = result.concat(getSuperType().getMethodsByFlag(filterSuperTypes));
			}
		}
		return result;
	}
	
	/**
	 * Returns an array containing the methods represented by MethodInfos
	 * this type and super types' declare that do not get filtered/excluded.
	 *
	 * <p>The TypeMemberFilter#filter(TypeMemberInfo):Boolean gets invoked
	 * for every method to determine whether it shall be contained in the 
	 * result.
	 *
	 * <p>If the passed-in method filter is null or undefined the result of
	 * the invocation of #getMethodsByFlag(Boolean):Array with argument 
	 * 'false' gets returned.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The #getType method returns null or undefined.</li>
	 *   <li>The method algorithm returns null or undefined.</li>
	 * </ul>
	 *
	 * @param methodFilter the filter that filters unwanted methods out
	 * @return an array containing the remaining methods
	 */
	public function getMethodsByFilter(methodFilter:TypeMemberFilter):Array {
		if (!getType()) return null;
		if (!methodFilter) return getMethodsByFlag(false);
		var result:Array = getMethodsByFlag(methodFilter.filterSuperTypes());
		for (var i:Number = 0; i < result.length; i++) {
			if (methodFilter.filter(MethodInfo(result[i]))) {
				result.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getMethodByName(String):MethodInfo
	 * @overload #getMethodByMethod(Function):MethodInfo
	 */
	public function getMethod(method):MethodInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMethodByName);
		overload.addHandler([Function], getMethodByMethod);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the method info corresponding to the passed-in method name.
	 *
	 * Null will be returned if:
	 * <ul>
	 *   <li>The passed-in method name is null or undefined.</li>
	 *   <li>A method with the given name is not declared in the represented class or any super class.</li>
	 * </ul>
	 *
	 * <p>If this class overwrites a method of any super class the, MethodInfo
	 * instance of the overwriting method will be returned.
	 *
	 * <p>The declaring type of the returned method info is not always the
	 * one represented by this class. It can also be a super class of it.
	 *
	 * @param methodName the name of the method to return
	 * @return a method info representing the method corresponding to the name
	 */
	public function getMethodByName(methodName:String):MethodInfo {
		if (methodName == null) return null;
		var methodArray:Array = getMethodsByFlag(false);
		if (!methodArray) return null;
		var l:Number = methodArray.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var method:MethodInfo = methodArray[i];
			if (method.getName() == methodName) {
				return method;
			}
		}
		return null;
	}
	
	/**
	 * Returns teh method info corresponding to the passed-in concrete method.
	 *
	 * Null will be returned if:
	 * <ul>
	 *   <li>The passed-in method is null or undefined.</li>
	 *   <li>A method matching the given method cannot be found on the represented class or any super class.</li>
	 * </ul>
	 *
	 * <p>The declaring type of the returned method info is not always the
	 * one represented by this class. It can also be a super class of it.
	 *
	 * @param concreteMethod the concrete method the method info shall be returned for
	 * @return the method info thate represents the passed-in concrete method
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo {
		if (!concreteMethod) return null;
		var methodArray:Array = getMethodsByFlag(false);
		if (!methodArray) return null;
		var l:Number = methodArray.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var method:MethodInfo = methodArray[i];
			if (method.getMethod() == concreteMethod) {
				return method;
			}
		}
		return null;
	}
	
	/**
	 * @overload #getPropertiesByFlag(Boolean):Array
	 * @overload #getPropertiesByFilter(TypeMemberFilter):Array
	 */
	public function getProperties():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getPropertiesByFlag);
		o.addHandler([Boolean], getPropertiesByFlag);
		o.addHandler([TypeMemberFilter], getPropertiesByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing the properties represented by PropertyInfos
	 * this type declares and maybe the ones of the super types.
	 *
	 * <p>The super types' properties are included if you pass-in false, null
	 * or undefined and excluded/filtered if you pass-in true.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The #getType method returns null or undefined.</li>
	 *   <li>The property algorithm returns null or undefined.</li>
	 * </ul>
	 *
	 * @param filterSuperTypes (optional) determines whether the super types'
	 * properties shall be excluded, that means filtered (true) or included (false)
	 * @return an array containing the properties
	 */
	public function getPropertiesByFlag(filterSuperTypes:Boolean):Array {
		if (!getType()) return null;
		if (properties === undefined) {
			properties = getPropertyAlgorithm().execute(this);
		}
		var result:Array = properties.concat();
		if (!filterSuperTypes) {
			if (getSuperType() != null) {
				result = result.concat(ClassInfo(getSuperType()).getPropertiesByFlag(filterSuperTypes));
			}
		}
		return result;
	}
	
	/**
	 * Returns an array containing the properties represented by PropertyInfos
	 * this type and super types' declare that do not get filtered/excluded.
	 *
	 * <p>The TypeMemberFilter#filter(TypeMemberInfo):Boolean gets invoked
	 * for every property to determine whether it shall be contained in the 
	 * result.
	 *
	 * <p>If the passed-in method filter is null or undefined the result of
	 * the invocation of #getMethodsByFlag(Boolean):Array with argument 
	 * 'false' gets returned.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The #getType method returns null or undefined.</li>
	 *   <li>The property algorithm returns null or undefined.</li>
	 * </ul>
	 *
	 * @param propertyFilter the filter that filters unwanted properties out
	 * @return an array containing the remaining properties
	 */
	public function getPropertiesByFilter(propertyFilter:TypeMemberFilter):Array {
		if (!getType()) return null;
		if (!propertyFilter) return getPropertiesByFlag(false);
		var result:Array = getPropertiesByFlag(propertyFilter.filterSuperTypes());
		for (var i:Number = 0; i < result.length; i++) {
			if (propertyFilter.filter(PropertyInfo(result[i]))) {
				result.splice(i, 1);
				i--;
			}
		}
		return result;
	}
	
	/**
	 * @overload #getPropertyByName(String):PropertyInfo
	 * @overload #getPropertyByProperty(Function):PropertyInfo
	 */
	public function getProperty(property):PropertyInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getPropertyByName);
		overload.addHandler([Function], getPropertyByProperty);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the property info corresponding to the passed-in property 
	 * name.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in name is null or undefined.</li>
	 *   <li>A property with the given name does not exist on the represented class or any super class.</li>
	 * </ul>
	 *
	 * <p>If this class overwrites a property of any super class the, PropertyInfo
	 * instance of the overwriting property will be returned.
	 *
	 * <p>The declaring type of the returned property info is not always the
	 * one represented by this class. It can also be a super class of it.
	 *
	 * @param propertyName the name of the property you wanna obtain
	 * @return the property info correspoinding to the property's name
	 */
	public function getPropertyByName(propertyName:String):PropertyInfo {
		if (propertyName == null) return null;
		var propertyArray:Array = getPropertiesByFlag(false);
		if (!propertyArray) return null;
		var l:Number = propertyArray.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var property:PropertyInfo = propertyArray[i];
			if (property.getName() == propertyName) {
				return property;
			}
		}
		return null;
	}
	
	/**
	 * Returns the property info corresponding to the passed-in property.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in concrete property is null or undefined.</li>
	 *   <li>A property with the given name cannot be found on the represented class or any super class.</li>
	 * </ul>
	 *
	 * <p>The declaring type of the returned property info is not always the
	 * one represented by this class. It can also be a super class of it.
	 *
	 * @param property the property the corresponding property info shall be returned
	 * @return the property info correspoinding to the property
	 */
	public function getPropertyByProperty(concreteProperty:Function):PropertyInfo {
		if (concreteProperty == null) return null;
		var propertyArray:Array = getPropertiesByFlag(false);
		if (!propertyArray) return null;
		var l:Number = propertyArray.length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var property:PropertyInfo = propertyArray[i];
			if (property.getGetter() == concreteProperty
					|| property.getSetter() == concreteProperty) {
				return property;
			}
		}
		return null;
	}
	
}