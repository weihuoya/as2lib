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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.env.reflect.NoSuchMethodException;
import org.as2lib.env.reflect.NoSuchPropertyException;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.TypeMemberFilter;
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;

/**
 * ClassInfo reflects a real class in the Flash environment. This class
 * is used to get information about the class it represents.
 *
 * <p>You can use the static search methods {@link #forName}, {@link #forObject},
 * {@link #forInstance} and {@link #forClass} to get class infos for 
 * specific cocrete classes.
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
 * <p>Note that it is not possible right now to distinguish between
 * interfaces and classes at run-time. Therefore are both classes and
 * interfaces represented by ClassInfo instances. This is going to
 * change as soon is a differentiation is possible.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ClassInfo extends BasicClass implements TypeInfo {
	
	/** The algorithm to find classes. */
	private static var classAlgorithm:ClassAlgorithm;
	
	/** The algorithm to find methods of classes. */
	private static var methodAlgorithm:MethodAlgorithm;
	
	/** The algorithm to find properties of classes. */
	private static var propertyAlgorithm:PropertyAlgorithm;
	
	/** The name of the class. */
	private var name:String;
	
	/** The full name of the class. This means the name with the whole path. */
	private var fullName:String;
	
	/** The class this ClassInfo represents. */
	private var clazz:Function;
	
	/** The super class's ClassInfo of the class. */
	private var superClass:ClassInfo;
	
	/** The package that contains the class. */
	private var package:PackageInfo;
	
	/** The methods the class has. */
	private var methods:Array;
	
	/** The properties of the class. */
	private var properties:Array;
	
	/** The class's constructor. */
	private var classConstructor:ConstructorInfo;
	
	/**
	 * Returns the class info corresponding to the passed-in name.
	 *
	 * <p>The name must be fully qualified, that means it must be composed
	 * of the class's path (namespace) as well as its name. For example
	 * 'org.as2lib.core.BasicClass'.
	 *
	 * <p>This method first checks whether the class is already contained
	 * in the cache.
	 *
	 * @param className the fully qualified class name
	 * @return a class info representing the class corresponding to the name
	 * @throws IllegalArgumentException if the passed-in name is null or undefined or an empty string or
	 *                                  if the object corresponding to the passed-in name is not of type Function
	 * @throws ClassNotFoundException if a class with the passed-in name could not be found or
	 */
	public static function forName(className:String):ClassInfo {
		try {
			return getClassAlgorithm().executeByName(className);
			// I do not use org.as2lib.env.except.Throwable as type because Flex does not allow to
			// use types in the catch-signature that do not extend Error.
		} catch (e:org.as2lib.env.except.IllegalArgumentException) {
			e.addStackTraceElement(eval("th"+"is"), arguments.callee, arguments);
			throw e;
		} catch (e:org.as2lib.env.reflect.ClassNotFoundException) {
			e.addStackTraceElement(eval("th"+"is"), arguments.callee, arguments);
			throw e;
		}
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
	 * @param object the object you wanna get a class info for
	 * @return the class info corresponding to the object
	 * @throws IllegalArgumentException if the passed-in object is null or undefined
	 * @throws ClassNotFoundException if the class corresponding to the passed-in object could not be found
	 * @see #forClass
	 * @see #forInstance
	 */
	public static function forObject(object):ClassInfo {
		// not '!object' because parameter 'object' could be an empty string
		if (object == null) throw new IllegalArgumentException("The passed-in object '" + object + "' is not allowed to be null or undefined.", eval("th" + "is"), arguments);
		var classInfo:ClassInfo = ReflectConfig.getCache().getClass(object);
		if (classInfo) return classInfo;
		// not 'object instanceof Function' because that would include instances
		// of type Function that were created using the new keyword 'new Function()'.
		if (typeof(object) == "function") {
			return forClass(object);
		}
		return forInstance(object);
	}
	
	/**
	 * Returns the class info corresponding to the passed-in instance, that
	 * is the class info representing the class the pssed-in instance is
	 * an instance of.
	 *
	 * <p>This method first checks whether the class is already contained
	 * in the cache and adds it to the cache if not.
	 *
	 * @param instance the instance you wanna get the class info for
	 * @return the class info representing the class tha passed-in instance
	 * is an instance of
	 * @throws IllegalArgumentException if the passed-in instance is null or undefined
	 * @throws ClassNotFoundException if the class corresponding to the passed-in instance could not be found
	 */
	public static function forInstance(instance):ClassInfo {
		// not '!instance' because parameter 'instance' could be a blank string
		if (instance == null) throw new IllegalArgumentException("The passed-in instance '" + instance + "' is not allowed to be null or undefined.", eval("th" + "is"), arguments);
		var classInfo:ClassInfo = ReflectConfig.getCache().getClass(instance);
		if (classInfo) return classInfo;
		// if the __constructor__ is defined it most probably references the correct class
		if (instance.__constructor__) {
			// check if it really is the correct one
			// it may be incorrect if the __proto__ property was set manually like myInstance.__proto__ = MyClass.prototype
			if (instance.__constructor__.prototype == instance.__proto__) {
				return ReflectConfig.getCache().addClass(new ClassInfo(instance.__constructor__));
			}
		}
		// if the __constructor__ is not defined or is not the correct one the constructor may be correct
		// this is most probably true for MovieClips, TextFields etc. that have been put on the stage without
		// linkage to any other class
		if (instance.constructor) {
			// check if it really is the correct one
			// it may be incorrect if the __proto__ property was set manually like myInstance.__proto__ = MyClass.prototype
			if (instance.constructor.prototype == instance.__proto__) {
				return ReflectConfig.getCache().addClass(new ClassInfo(instance.constructor));
			}
		}
		// if all the above tests do not hold true we must search for the class using the instance
		var info = getClassAlgorithm().executeByInstance(instance);
		// info is null if the class algorithm could not find the appropriate class
		if (info) {
			// Would throwing an exception be more appropriate if any of the following
			// if-statements holds true?
			if (info.name == null) info.name = null;
			if (!info.clazz) info.clazz = null;
			if (!info.package) info.package = null;
			return ReflectConfig.getCache().addClass(new ClassInfo(info.clazz, info.name, info.package));
		}
		throw new ClassNotFoundException("The class corresponding to the passed-in instance '" + instance + "' could not be found.", eval("th" + "is"), arguments);
	}
	
	/**
	 * Returns the class info corresponding to the passed-in class.
	 *
	 * <p>This method first checks whether the class is already contained
	 * in the cache and adds it to the cache if not.
	 *
	 * <p>Null will be returned if the passed-in class is null or undefined.
	 *
	 * @param clazz the class you wanna get the class info for
	 * @return the class info representing the passed-in class
	 * @throws IllegalArgumentException if the passed-in class is null or undefined
	 */
	public static function forClass(clazz:Function):ClassInfo {
		if (!clazz) throw new IllegalArgumentException("The passed-in class '" + clazz + "' is not allowed to be null or undefined.", eval("th" + "is"), arguments);
		var classInfo:ClassInfo = ReflectConfig.getCache().getClass(clazz);
		if (classInfo) return classInfo;
		return ReflectConfig.getCache().addClass(new ClassInfo(clazz));
	}
	
	/**
	 * Sets the algorithm used to find classes. 
	 *
	 * <p>If you pass-in an algorithm of value null or undefined,
	 * {@link #getClassAlgorithm} will return the default one.
	 *
	 * @param newClassAlgorithm the new class algorithm to find classes
	 * @see #getClassAlgorithm
	 */
	public static function setClassAlgorithm(newClassAlgorithm:ClassAlgorithm):Void {
		classAlgorithm = newClassAlgorithm;
	}
	
	/**
	 * Returns the class algorithm used to find classes.
	 *
	 * <p>Either the algorithm set via {@link #setClassAlgorithm} will be
	 * returned or the default one which is an instance of the class
	 * {@link ClassAlgorithm}.
	 *
	 * @return the set or the default class algorithm
	 * @see #setClassAlgorithm
	 */
	public static function getClassAlgorithm(Void):ClassAlgorithm {
		if (!classAlgorithm) classAlgorithm = new ClassAlgorithm();
		return classAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to find methods.
	 *
	 * <p>If you pass-in an algorithm of value null or undefined,
	 * {@link #getMethodAlgorithm} will return the default one.
	 *
	 * @param newMethodAlgorithm the new method algorithm to find methods
	 * @see #getMethodAlgorithm
	 */
	public static function setMethodAlgorithm(newMethodAlgorithm:MethodAlgorithm):Void {
		methodAlgorithm = newMethodAlgorithm;
	}
	
	/**
	 * Returns the method algorithm used to find methods.
	 *
	 * <p>Either the algorithm set via {@link #setMethodAlgorithm} will be
	 * returned or the default one which is an instance of the class
	 * {@link MethodAlgorithm}.
	 *
	 * @return the set or the default method algorithm
	 * @see #setMethodAlgorithm
	 */
	public static function getMethodAlgorithm(Void):MethodAlgorithm {
		if (!methodAlgorithm) methodAlgorithm = new MethodAlgorithm();
		return methodAlgorithm;
	}
	
	/**
	 * Sets the algorithm used to find properties.
	 *
	 * <p>If you pass an algorithm of value null or undefined,
	 * {@link #getPropertyAlgorithm} will return the default one.
	 *
	 * @param newPropertyAlgorithm the new property algorithm to find properties
	 * @see #getPropertyAlgorithm
	 */
	public static function setPropertyAlgorithm(newPropertyAlgorithm:PropertyAlgorithm):Void {
		propertyAlgorithm = newPropertyAlgorithm;
	}
	
	/**
	 * Returns the property algorithm used to find properties.
	 *
	 * <p>Either the algorithm set via {@link #setPropertyAlgorithm} will be
	 * returned or the default one which is an instance of the class
	 * {@link PropertyAlgorithm}.
	 *
	 * @return the set or the default property algorithm
	 * @see #setPropertyAlgorithm
	 */
	public static function getPropertyAlgorithm(Void):PropertyAlgorithm {
		if (!propertyAlgorithm) propertyAlgorithm = new PropertyAlgorithm();
		return propertyAlgorithm;
	}
	
	/**
	 * Constructs a new ClassInfo instance.
	 *
	 * <p>Note that you do not have to pass-in the class. But if you do not
	 * pass it in some methods cannot do their job correctly.
	 * 
	 * <p>If you do not pass-in the name or the package they get resolved
	 * lazily when requested using the passed-in class.
	 *
	 * @param class the class the newly created class info represents
	 * @param name (optional) the name of the class
	 * @param package (optional) the package in which the class is declared / resides in
	 */
	public function ClassInfo(clazz:Function,
							  name:String,
							  package:PackageInfo) {
		this.name = name;
		this.clazz = clazz;
		this.package = package;
	}
	
	/**
	 * Returns the name of the represented class without its namespace.
	 *
	 * <p>The namespace is the package path to the class. The namespace of
	 * the class 'org.as2lib.core.BasicClass' is 'org.as2lib.core'. In this
	 * example this method would only return 'BasicClass'.
	 *
	 * @reutrn the name of the represented class
	 * @see #getFullName
	 */
	public function getName(Void):String {
		if (name === undefined) initNameAndPackage();
		return name;
	}
	
	/**
	 * Returns the full name of the represented class. That means the name
	 * of the class plus its package path, namespace.
	 *
	 * <p>The path will not be included if:
	 * <ul>
	 *   <li>The {@link #getPackage} method returns null or undefined.</li>
	 *   <li>The isRoot method of the package returned by {@link #getPackage} returns true.</li>
	 * </ul>
	 *
	 * @return the full name of the represented class
	 * @see #getName
	 */
	public function getFullName(Void):String {
		if (fullName === undefined) {
			if (getPackage().isRoot() || !getPackage()) {
				return (fullName = getName());
			}
			fullName = getPackage().getFullName() + "." + getName();
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
	 * <p>If the {@link #getType} method returns null or undefined, null will be
	 * returned.
	 *
	 * <p>You can use the returned ConstructorInfo instance to get the actual
	 * constructor. Note that the constructor in Flash is the same as the
	 * class. Thus the function returned by the {@link #getType} method and the
	 * {@link ConstructorInfo#getMethod} method of this class info is the same.
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
	 * @see #forInstance
	 */
	public function getSuperType(Void):TypeInfo {
		if (superClass === undefined) {
			if (clazz.prototype.__proto__) {
				superClass = forInstance(clazz.prototype);
			} else {
				superClass = null;
			}
		}
		return superClass;
	}
	
	/**
	 * Creates a new instance of the class passing the constructor arguments.
	 *
	 * <p>Null will be returned if the {@link #getType} method returns null or
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
		result.__constructor__ = clazz;
		clazz.apply(result, args);
		return result;
	}
	
	/**
	 * Returns the package the represented class is declared in / resides
	 * in.
	 *
	 * <p>The package of the class org.as2lib.core.BasicClass is org.as2lib.core.
	 *
	 * @return the package the represented class is declared in / resides in
	 */
	public function getPackage(Void):PackageInfo {
		if (package === undefined) initNameAndPackage();
		return package;
	}
	
	/**
	 * Initializes the name and the package of the represented class.
	 *
	 * <p>This is done using the result of an execution of the class algorithm
	 * returned by the static {@link #getClassAlgorithm} method.
	 */
	private function initNameAndPackage(Void):Void {
		var info = getClassAlgorithm().executeByClass(getType());
		if (name === undefined) name = info.name == null ? null : info.name;
		if (package === undefined) package = info.package == null ? null : info.package;
	}
	
	/**
	 * @overload #getMethodsByFlag
	 * @overload #getMethodsByFilter
	 */
	public function getMethods():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getMethodsByFlag);
		o.addHandler([Boolean], getMethodsByFlag);
		o.addHandler([TypeMemberFilter], getMethodsByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing the methods represented by {@link MethodInfo}
	 * instances this type declares and maybe the ones of the super types.
	 *
	 * <p>The super types' methods are included if you pass-in false, null
	 * or undefined and excluded/filtered if you pass-in true.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The {@link #getType} method returns null or undefined.</li>
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
	 * Returns an array containing the methods represented by {@link MethodInfo}
	 * instances this type and super types' declare that do not get filtered/excluded.
	 *
	 * <p>The {@link TypeMemberFilter#filter} method gets invoked
	 * for every method to determine whether it shall be contained in the 
	 * result.
	 *
	 * <p>If the passed-in method filter is null or undefined the result of
	 * the invocation of {@link #getMethodsByFlag} with argument 
	 * 'false' gets returned.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The {@link #getType} method returns null or undefined.</li>
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
	 * @overload #getMethodByName
	 * @overload #getMethodByMethod
	 */
	public function getMethod():MethodInfo {
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
		if (getMethodsByFlag(true)) {
			if (methods[methodName]) return methods[methodName];
		}
		if (getSuperType()) return getSuperType().getMethodByName(methodName);
		return null;
	}
	
	/**
	 * Returns the method info corresponding to the passed-in concrete method.
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
		var methodArray:Array = getMethodsByFlag(true);
		if (methodArray) {
			var l:Number = methodArray.length;
			for (var i:Number = 0; i < l; i = i-(-1)) {
				var method:MethodInfo = methodArray[i];
				if (method.getMethod() == concreteMethod) {
					return method;
				}
			}
		}
		if (getSuperType()) return getSuperType().getMethodByMethod(concreteMethod);
		return null;
	}
	
	/**
	 * @overload #getPropertiesByFlag
	 * @overload #getPropertiesByFilter
	 */
	public function getProperties():Array {
		var o:Overload = new Overload(this);
		o.addHandler([], getPropertiesByFlag);
		o.addHandler([Boolean], getPropertiesByFlag);
		o.addHandler([TypeMemberFilter], getPropertiesByFilter);
		return o.forward(arguments);
	}
	
	/**
	 * Returns an array containing the properties represented by {@link PropertyInfo}
	 * instances this type declares and maybe the ones of the super types.
	 *
	 * <p>The super types' properties are included if you pass-in false, null
	 * or undefined and excluded/filtered if you pass-in true.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The {@link #getType} method returns null or undefined.</li>
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
	 * Returns an array containing the properties represented by {@link PropertyInfo}
	 * instances this type and super types' declare that do not get filtered/excluded.
	 *
	 * <p>The {@link TypeMemberFilter#filter} gets invoked
	 * for every property to determine whether it shall be contained in the 
	 * result.
	 *
	 * <p>If the passed-in method filter is null or undefined the result of
	 * the invocation of {@link #getPropertiesByFlag} with argument 
	 * 'false' gets returned.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The {@link #getType} method returns null or undefined.</li>
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
	 * @overload #getPropertyByName
	 * @overload #getPropertyByProperty
	 */
	public function getProperty():PropertyInfo {
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
	 * <p>If this class overwrites a property of any super class the PropertyInfo
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
		if (getPropertiesByFlag(true)) {
			if (properties[propertyName]) return properties[propertyName];
		}
		if (getSuperType()) return ClassInfo(getSuperType()).getPropertyByName(propertyName);
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
		var propertyArray:Array = getPropertiesByFlag(true);
		if (propertyArray) {
			var l:Number = propertyArray.length;
			for (var i:Number = 0; i < l; i = i-(-1)) {
				var property:PropertyInfo = propertyArray[i];
				if (property.getGetter() == concreteProperty
						|| property.getSetter() == concreteProperty) {
					return property;
				}
			}
		}
		if (getSuperType()) return ClassInfo(getSuperType()).getPropertyByProperty(concreteProperty);
		return null;
	}
	
}