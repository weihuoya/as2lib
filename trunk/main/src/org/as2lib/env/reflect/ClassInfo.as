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
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ConstructorInfo;
import org.as2lib.env.reflect.NoSuchTypeMemberException;
import org.as2lib.env.EnvConfig;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.overload.Overload;

/**
 * ClassInfo represents a real class in the Flash environment. This class is used
 * to store information about the class it represents.
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
	 * @see org.as2lib.env.reflect.MemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * @see org.as2lib.env.reflect.CompositeMemberInfo#getFullName()
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
	 * @see org.as2lib.env.reflect.TypeInfo#getType()
	 */
	public function getType(Void):Function {
		return clazz;
	}
	
	/**
	 * Returns the class's constructor as ConstructorInfo.
	 *
	 * @return the constructor of the class.
	 */
	public function getConstructor(Void):ConstructorInfo {
		if (ObjectUtil.isEmpty(constructor)) {
			constructor = new ConstructorInfo(getType(), this);
		}
		return constructor;
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeInfo#getSuperType()
	 */
	public function getSuperType(Void):TypeInfo {
		if (ObjectUtil.isEmpty(superClass)) {
			superClass = ReflectUtil.getClassInfo(clazz.prototype);
		}
		return superClass;
	}
	
	/**
	 * Creates a new instance of the class passing the constructor arguments.
	 *
	 * @param args the constructor arguments
	 * @return a new instance of the class
	 */
	public function newInstance(args:Array) {
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
	 * @see org.as2lib.env.reflect.TypeInfo#getMethods()
	 */
	public function getMethods(Void):Map {
		if (ObjectUtil.isEmpty(methods)) {
			methods = ReflectConfig.getMethodAlgorithm().execute(this);
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
	 * @see org.as2lib.env.reflect.TypeInfo#getMethodByName()
	 */
	public function getMethodByName(methodName:String):MethodInfo {
		var result:MethodInfo = getMethods().get(methodName);
		if (ObjectUtil.isAvailable(result)) {
			return result;
		}
		throw new NoSuchTypeMemberException("The method with the name [" + methodName + "] you tried to obtain does not exist.",
										this,
										arguments);
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeInfo#getMethodByMethod()
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
		throw new NoSuchTypeMemberException("The method [" + concreteMethod + "] you tried to obtain does not exist in this class.",
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
			properties = ReflectConfig.getPropertyAlgorithm().execute(this);
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
	 * @throws org.as2lib.env.reflect.NoSuchTypeMemberException if the property you tried to obtain does not exist
	 */
	public function getPropertyByName(propertyName:String):PropertyInfo {
		var property:PropertyInfo = getProperties().get(propertyName);
		if (ObjectUtil.isAvailable(property)) {
			return property;
		}
		throw new NoSuchTypeMemberException("The property with the name [" + propertyName + "] you tried to obtain does not exist.",
										this,
										arguments);
	}
	
	/**
	 * Returns the PropertyInfo corresponding to the passed property.
	 *
	 * @param property the property the corresponding PropertyInfo shall be returned
	 * @return the PropertyInfo correspoinding to the property
	 * @throws org.as2lib.env.reflect.NoSuchTypeMemberException if the property you tried to obtain does not exist
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
		throw new NoSuchTypeMemberException("The property [" + concreteProperty + "] you tried to obtain does not exist in this class.",
										this,
										arguments);
	}
}