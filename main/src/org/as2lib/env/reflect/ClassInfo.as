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
import org.as2lib.env.reflect.algorithm.ClassAlgorithm;
import org.as2lib.env.reflect.algorithm.MethodAlgorithm;
import org.as2lib.env.reflect.algorithm.PropertyAlgorithm;

/**
 * ClassInfo represents a real class in the Flash environment. This class is used
 * to get information about the class it represents.
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
	 *
	 * @see #getClassAlgorithm()
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
	 *
	 * @see #setClassAlgorithm(ClassAlgorithm)
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
	 *
	 * @see #getMethodAlgorithm()
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
	 *
	 * @see #setMethodAlgorithm(MethodAlgorithm)
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
	 *
	 * @see #getPropertyAlgorithm()
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
	 *
	 * @see #setPropertyAlgorithm(PropertyAlgorithm)
	 */
	public function getPropertyAlgorithm(Void):PropertyAlgorithm {
		if (!propertyAlgorithm) propertyAlgorithm = ReflectConfig.getPropertyAlgorithm();
		return propertyAlgorithm;
	}
	
	/**
	 * @see org.as2lib.env.reflect.MemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the represented class. That means the name
	 * of the class plus its package path.
	 *
	 * <p>The path will not be included if #getParent() returns null, 
	 * undefined.
	 *
	 * <p>If the #getParent() method returns a package whose #isRoot() method
	 * returns true it is not listed in the resulting string.
	 *
	 * @see org.as2lib.env.reflect.CompositeMemberInfo#getFullName()
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
	 * @see org.as2lib.env.reflect.TypeInfo#getType()
	 */
	public function getType(Void):Function {
		return clazz;
	}
	
	/**
	 * Returns the class's constructor as ConstructorInfo.
	 *
	 * <p>If the #getType() method returns null or undefined, null will be
	 * returned.
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
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The represented type is Object.</li>
	 *   <li>The represented type has no prototype.</li>
	 *   <li>The super type could not be found.</li>
	 * </ul>
	 *
	 * @see org.as2lib.env.reflect.TypeInfo#getSuperType()
	 * @see #setClassAlgorithm(ClassAlgorithm)
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
	 * <p>Null will be returned if the #getType() method returns null or
	 * undefined.
	 *
	 * @param args the constructor arguments
	 * @return a new instance of the class or null
	 */
	public function newInstance(args:Array) {
		if (!clazz) return null;
		var result:Object = new Object();
		result.__proto__ = clazz.prototype;
		clazz.apply(result, args);
		return result;
	}
	
	/**
	 * @see org.as2lib.env.reflect.CompositeMemberInfo#getParent()
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Null will be returned if the #getType() method returns null.
	 *
	 * @see org.as2lib.env.reflect.TypeInfo#getMethods()
	 */
	public function getMethods(Void):Array {
		if (!getType()) return null;
		if (methods === undefined) {
			methods = getMethodAlgorithm().execute(this);
			if (getSuperType() != null) {
				methods = methods.concat(getSuperType().getMethods());
			}
		}
		return methods;
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeInfo#getMethod()
	 */
	public function getMethod(method):MethodInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMethodByName);
		overload.addHandler([Function], getMethodByMethod);
		return overload.forward(arguments);
	}
	
	/**
	 * Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>A method with the given name can not be found.</li>
	 * </ul>
	 *
	 * <p>If this class overwrites a method of any super class the, MethodInfo
	 * instance of the overwriting method will be returned.
	 *
	 * @see org.as2lib.env.reflect.TypeInfo#getMethodByName()
	 */
	public function getMethodByName(methodName:String):MethodInfo {
		if (methodName == null) return null;
		if (!getMethods()) return null;
		var l:Number = getMethods().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var method:MethodInfo = getMethods()[i];
			if (method.getName() == methodName) {
				return method;
			}
		}
		return null;
	}
	
	/**
	 * Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>A method matching the given method can not be found.</li>
	 * </ul>
	 *
	 * @see org.as2lib.env.reflect.TypeInfo#getMethodByMethod()
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo {
		if (!concreteMethod) return null;
		if (!getMethods()) return null;
		var l:Number = getMethods().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var method:MethodInfo = getMethods()[i];
			if (method.getMethod() == concreteMethod) {
				return method;
			}
		}
		return null;
	}
	
	/**
	 * Returns an Array containing the properties represented by PropertyInfos
	 * the class has. As well as the properties defined by super classes.
	 *
	 * <p>Null will be returned if the #getType() method returns null.
	 *
	 * @return an Array containing PropertyInfos representing the properties
	 */
	public function getProperties(Void):Array {
		if (!getType()) return null;
		if (!properties) {
			properties = getPropertyAlgorithm().execute(this);
			if (getSuperType() != null) {
				properties = properties.concat(ClassInfo(getSuperType()).getProperties());
			}
		}
		return properties;
	}
	
	/**
	 * @overload #getPropertyByName(String)
	 * @overload #getPropertyByProperty(Function)
	 */
	public function getProperty(property):PropertyInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getPropertyByName);
		overload.addHandler([Function], getPropertyByProperty);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the PropertyInfo corresponding to the passed property name.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>A property with the given name cannot be found.</li>
	 * </ul>
	 *
	 * <p>If this class overwrites a property of any super class the, PropertyInfo
	 * instance of the overwriting property will be returned.
	 *
	 * @param propertyName the name of the property you wanna obtain
	 * @return the PropertyInfo correspoinding to the property's name
	 */
	public function getPropertyByName(propertyName:String):PropertyInfo {
		if (propertyName == null) return null;
		if (!getProperties()) return null;
		var l:Number = getProperties().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var property:PropertyInfo = getProperties()[i];
			if (property.getName() == propertyName) {
				return property;
			}
		}
		return null;
	}
	
	/**
	 * Returns the PropertyInfo corresponding to the passed property.
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in argument is null or undefined.</li>
	 *   <li>A property with the given name cannot be found.</li>
	 * </ul>
	 *
	 * @param property the property the corresponding PropertyInfo shall be returned
	 * @return the PropertyInfo correspoinding to the property
	 */
	public function getPropertyByProperty(concreteProperty:Function):PropertyInfo {
		if (concreteProperty == null) return null;
		if (!getProperties()) return null;
		var l:Number = getProperties().length;
		for (var i:Number = 0; i < l; i = i-(-1)) {
			var property:PropertyInfo = getProperties()[i];
			if (property.getGetter() == concreteProperty
					|| property.getSetter() == concreteProperty) {
				return property;
			}
		}
		return null;
	}
	
}