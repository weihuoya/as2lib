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
import org.as2lib.data.holder.Map;
import org.as2lib.data.iterator.Iterator;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.NoSuchClassMemberException;
import org.as2lib.env.EnvConfig;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.overload.Overload;

/**
 * ClassInfo represents a real class in the Flash environment. This class is used
 * to store information about the class it represents.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ClassInfo extends BasicClass implements CacheInfo {
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
	private var methods:Map;
	
	/** The properties of the class. */
	private var properties:Map;
	
	/** The class's constructor. */
	private var constructor:ConstructorInfo;
	
	/**
	 * Constructs a new ClassInfo.
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
	 * Returns the name of the class.
	 *
	 * @return the name of the class
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the full name of the class. Lazy loading is used here. That means
	 * that the full name will not be resolved until this method is called. Once
	 * the full name has been resolved it will be stored.
	 *
	 * @return the full name of the class
	 */
	public function getFullName(Void):String {
		if (ObjectUtil.isEmpty(fullName)) {
			if (getParent().isRoot()) {
				return (fullName = getName());
			}
			fullName = getParent().getFullName() + "." + getName();
		}
		return fullName;
	}
	
	/**
	 * Returns the class this ClassInfo represents.
	 *
	 * @return the class represented by this ClassInfo
	 */
	public function getClass(Void):Function {
		return clazz;
	}
	
	/**
	 * Returns the class's constructor as ConstructorInfo.
	 *
	 * @return the constructor of the class.
	 */
	public function getConstructor(Void):ConstructorInfo {
		if (ObjectUtil.isEmpty(constructor)) {
			constructor = new ConstructorInfo(getClass(), this);
		}
		return constructor;
	}
	
	/**
	 * Returns the super class's ClassInfo of the class this ClassInfo represents.
	 * The lazy loading strategy is used here to prevent doing the work if it is
	 * not needed at all.
	 * 
	 * @return the super class's ClassInfo
	 */
	public function getSuperClass(Void):ClassInfo {
		if (ObjectUtil.isEmpty(superClass)) {
			superClass = ReflectUtil.getClassInfo(clazz.prototype);
		}
		return superClass;
	}
	
	/**
	 * Creates a new instance of the class.
	 *
	 * @return a new instance of the class
	 */
	public function newInstance(Void) {
		return (new clazz());
	}
	
	/**
	 * Returns the parent of the class. The parent is the package represented
	 * by a PackageInfo the class resides in.
	 *
	 * @return the parent of the class
	 */
	public function getParent(Void):PackageInfo {
		return parent;
	}
	
	/**
	 * Returns a Map containing the operations represented by MethodInfos
	 * the class has. Lazy loading is used.
	 *
	 * @return a Map containing MethodInfos representing the operations
	 */
	public function getMethods(Void):Map {
		if (ObjectUtil.isEmpty(methods)) {
			methods = ReflectConfig.getMethodAlgorythm().execute(this);
		}
		return methods;
	}
	
	/**
	 * Overload
	 * #getMethodByName()
	 * #getMethodByMethod()
	 */
	public function getMethod(method):MethodInfo {
		var overload:Overload = new Overload(this);
		overload.addHandler([String], getMethodByName);
		overload.addHandler([Function], getMethodByMethod);
		return overload.forward(arguments);
	}
	
	/**
	 * Returns the MethodInfo corresponding to the passed method name.
	 *
	 * @param methodName the name of the method you wanna obtain
	 * @return the MethodInfo correspoinding to the method name
	 * @throws org.as2lib.env.reflect.NoSuchClassMemberException if the method you tried to obtain does not exist
	 */
	public function getMethodByName(methodName:String):MethodInfo {
		var result:MethodInfo = getMethods().get(methodName);
		if (ObjectUtil.isAvailable(result)) {
			return result;
		}
		throw new NoSuchClassMemberException("The method with the name [" + methodName + "] you tried to obtain does not exist.",
										this,
										arguments);
	}
	
	/**
	 * Returns the MethodInfo corresponding to the passed method.
	 *
	 * @param method the method you wanna obtain the corresponding MethodInfo
	 * @return the MethodInfo correspoinding to the method
	 * @throws org.as2lib.env.reflect.NoSuchClassMemberException if the method you tried to obtain does not exist
	 */
	public function getMethodByMethod(concreteMethod:Function):MethodInfo {
		var iterator:Iterator = getMethods().iterator();
		var method:MethodInfo;
		while (iterator.hasNext()) {
			method = MethodInfo(iterator.next());
			if (method.getMethod() == concreteMethod) {
				return method;
			}
		}
		throw new NoSuchClassMemberException("The method [" + concreteMethod + "] you tried to obtain does not exist in this class.",
										this,
										arguments);
	}
	
	/**
	 * Returns a Map containing the properties represented by PropertyInfos
	 * the class has. Lazy loading is used.
	 *
	 * @return a Map containing PropertyInfos representing the properties
	 */
	public function getProperties(Void):Map {
		if (ObjectUtil.isEmpty(properties)) {
			properties = ReflectConfig.getPropertyAlgorythm().execute(this);
		}
		return properties;
	}
	
	/**
	 * Overload
	 * #getPropertyByName()
	 * #getPropertyByProperty()
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
	 * @param propertyName the name of the property you wanna obtain
	 * @return the PropertyInfo correspoinding to the property's name
	 * @throws org.as2lib.env.reflect.NoSuchClassMemberException if the property you tried to obtain does not exist
	 */
	public function getPropertyByName(propertyName:String):PropertyInfo {
		var property:PropertyInfo = getProperties().get(propertyName);
		if (ObjectUtil.isAvailable(property)) {
			return property;
		}
		throw new NoSuchClassMemberException("The property with the name [" + propertyName + "] you tried to obtain does not exist.",
										this,
										arguments);
	}
	
	/**
	 * Returns the PropertyInfo corresponding to the passed property.
	 *
	 * @param property the property the corresponding PropertyInfo shall be returned
	 * @return the PropertyInfo correspoinding to the property
	 * @throws org.as2lib.env.reflect.NoSuchClassMemberException if the property you tried to obtain does not exist
	 */
	public function getPropertyByProperty(concreteProperty:Function):PropertyInfo {
		var iterator:Iterator = getProperties().iterator();
		var property:PropertyInfo;
		while (iterator.hasNext()) {
			property = PropertyInfo(iterator.next());
			if (property.getGetter() == concreteProperty
					|| property.getSetter() == concreteProperty) {
				return property;
			}
		}
		throw new NoSuchClassMemberException("The property [" + concreteProperty + "] you tried to obtain does not exist in this class.",
										this,
										arguments);
	}
	
	/**
	 * Returns null becuase a class cannot contain any children.
	 *
	 * @return null
	 */
	public function getChildren(Void):Map {
		return null;
	}
}