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
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.env.reflect.string.PropertyInfoStringifier;

/**
 * PropertyInfo represents a property.
 *
 * <p>The term property means only properties added via Object#addProperty
 * or the ones added with the 'get' and 'set' keywords.
 * 'Normal' properties are not supported because at runtime you can only
 * evaluate them if they have been initialized. Therefore results could
 * vary dramatically.
 *
 * <p>PropertyInfo instances for specific properties can be obtained using
 * the {@link ClassInfo#getProperties} or {@link ClassInfo#getProperty} methods. That means
 * you first have to get a class info for the class that declares or
 * inherits the property. You can therefor use the {@link ClassInfo#forObject},
 * {@link ClassInfo#forClass}, {@link ClassInfo#forInstance} or {@link ClassInfo#forName} methods.
 * 
 * <p>When you have obtained the property info you can use it to get
 * information about the property.
 *
 * <code>trace("Property name: " + propertyInfo.getName());
 * trace("Declaring type: " + propertyInfo.getDeclaringType().getFullName());
 * trace("Is Static?: " + propertyInfo.isStatic());
 * trace("Is Writable?: " + propertyInfo.isWritable());
 * trace("Is Readable?: " + propertyInfo.isReadable());</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.PropertyInfo extends BasicClass implements TypeMemberInfo {
	
	/** The property info stringifier. */
	private static var stringifier:Stringifier;
	
	/** The name of the property. */
	private var name:String;
	
	/** The setter operation of the property. */
	private var setter:MethodInfo;
	
	/** The getter operation of the property. */
	private var getter:MethodInfo;
	
	/** The type that declares the property. */
	private var declaringType:TypeInfo;
	
	/** A flag representing whether the operation is static. */
	private var staticFlag:Boolean;
	
	/**
	 * Returns the stringifier used to stringify property infos.
	 *
	 * <p>If no custom stringifier has been set via the {@link #setStringifier}
	 * method, a instance of the default PropertyInfoStringifier gets returned.
	 *
	 * @return the stringifier that stringifies property infos
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new PropertyInfoStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the stringifier used to stringify property infos.
	 *
	 * <p>If you set a stringifier of value null or undefined {@link #getStringifier}
	 * will return the default stringifier.
	 *
	 * @param propertyInfoStringifier the stringifier that stringifies property infos
	 */
	public static function setStringifier(propertyInfoStringifier:PropertyInfoStringifier):Void {
		stringifier = propertyInfoStringifier;
	}
	
	/**
	 * Constructs a new PropertyInfo instance.
	 *
	 * <p>All arguments are allowed to be null. But keep in mind that not
	 * all methods will function properly if one is.
	 *
	 * @param name the name of the property
	 * @param setter the setter method of the property
	 * @param getter the getter method of the property
	 * @param declaringType the type declaring the property
	 * @param static a flag saying whether the property is static
	 */
	public function PropertyInfo(name:String,
								 setter:Function,
								 getter:Function,
								 declaringType:TypeInfo,
								 staticFlag:Boolean) {
		this.name = name;
		this.declaringType = declaringType;
		this.staticFlag = staticFlag;
		this.setter = setter ? new MethodInfo("__set__" + name, setter, declaringType, staticFlag) : null;
		this.getter = getter ? new MethodInfo("__get__" + name, getter, declaringType, staticFlag) : null;
	}
	
	/**
	 * Returns the name of the property.
	 *
	 * <p>If you want the getter or setter methods' name you must use the
	 * getGetter()#getName or getSetter()#getName method. The name of the
	 * getter or setter method is the prefix '__set__' or '__get__' plus
	 * the name of the property.
	 *
	 * @return the name of the property
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the setter method of the property.
	 *
	 * <p>The setter method of a property takes one argument, that is the
	 * new value that shall be assigned to the property. You can invoke
	 * it the same as every other method.
	 *
	 * <p>The name of a setter method is the prefix '__set__' plus the name
	 * of the property.
	 *
	 * <p>Property setter methods are also known under the name implicit
	 * setters.
	 * 
	 * @return the setter method of the property
	 */
	public function getSetter(Void):MethodInfo {
		return setter;
	}
	
	/**
	 * Returns the getter method of the property.
	 * 
	 * <p>The getter method of a property takes no arguments, but returns
	 * the value of the property. You can invoke it the same as every other
	 * method.
	 *
	 * <p>The name of a getter method is the prefix '__get__' plus the name
	 * of the property.
	 *
	 * <p>Property get methods are also known under the name implicit
	 * getters.
	 *
	 * @return the getter method of the property
	 */
	public function getGetter(Void):MethodInfo {
		return getter;
	}
	
	/**
	 * Returns the type that declares the property.
	 *
	 * <p>At this time interfaces are not allowed to declare properties.
	 * The declaring type is thus allways an instance of type ClassInfo,
	 * a class.
	 *
	 * @return the type that declares the property
	 */
	public function getDeclaringType(Void):TypeInfo {
		return declaringType;
	}
	
	/**
	 * Returns whether the property is writable.
	 *
	 * <p>The property is writable when its setter is not null.
	 *
	 * @return true when the property is writable else false
	 */
	public function isWritable(Void):Boolean {
		return (setter != null);
	}
	
	/**
	 * Returns whether the property is readable.
	 *
	 * <p>The property is readable when its getter is not null.
	 *
	 * @return true when the property is readable else false
	 */
	public function isReadable(Void):Boolean {
		return (getter != null);
	}
	
	/**
	 * Returns whether the property is static or not.
	 *
	 * <p>Static properties are properties per type.
	 *
	 * <p>Non-Static properties are properties per instance.
	 *
	 * @return true when the property is static else false
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
	
	/**
	 * Returns the string representation of this property.
	 *
	 * <p>The string representation is obtained via the stringifier returned
	 * by the static {@link #getStringifier} method.
	 *
	 * @return the string representation of this property
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}