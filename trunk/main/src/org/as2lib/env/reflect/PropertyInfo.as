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
import org.as2lib.env.reflect.TypeInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * PropertyInfo represents a property.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.PropertyInfo extends BasicClass implements TypeMemberInfo {
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
	 * Constructs a new PropertyInfo.
	 *
	 * @param name the name of the property
	 * @param setter the setter operation of the property
	 * @param getter the getter operation of the property
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
		setSetter(setter);
		setGetter(getter);
	}
	
	/**
	 * Sets the setter of the property.
	 *
	 * @param getter the property's setter
	 */
	private function setSetter(concreteSetter:Function):Void {
		if (concreteSetter != undefined) {
			setter = new MethodInfo("__set__" + getName(), concreteSetter, getDeclaringType(), isStatic());
		}
	}
	
	/**
	 * Sets the getter of the property.
	 *
	 * @param getter the property's getter
	 */
	private function setGetter(concreteGetter:Function):Void {
		if (concreteGetter != undefined) {
			setter = new MethodInfo("__get__" + getName(), concreteGetter, getDeclaringType(), isStatic());
		}
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeMemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the setter operation of the property.
	 * 
	 * @return the propertie's setter
	 */
	public function getSetter(Void):MethodInfo {
		return setter;
	}
	
	/**
	 * Returns the getter operation of the property.
	 * 
	 * @return the propertie's getter
	 */
	public function getGetter(Void):MethodInfo {
		return getter;
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeMemberInfo#getDeclaringType()
	 */
	public function getDeclaringType(Void):TypeInfo {
		return declaringType;
	}
	
	/**
	 * Returns whether the property is writeable.
	 *
	 * @return true when the property is writeable else false
	 */
	public function isWritable(Void):Boolean {
		return ObjectUtil.isAvailable(setter);
	}
	
	/**
	 * Returns whether the property is readable.
	 *
	 * @return true when the property is readable else false
	 */
	public function isReadable(Void):Boolean {
		return ObjectUtil.isAvailable(getter);
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeMemberInfo#isStatic()
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
	
	/**
	 * @see org.as2lib.core.BasicInterface#toString()
	 */
	public function toString(Void):String {
		return ReflectConfig.getPropertyInfoStringifier().execute(this);
	}
}