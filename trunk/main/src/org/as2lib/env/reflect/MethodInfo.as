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
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * MethodInfo represents a method.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.MethodInfo extends BasicClass implements TypeMemberInfo {
	
	/** The name of the method. */
	private var name:String;
	
	/** The actual method. */
	private var method:Function;
	
	/** The type that declares the method. */
	private var declaringType:TypeInfo;
	
	/** A flag representing whether the operaion is static of not. */
	private var staticFlag:Boolean;
	
	/**
	 * Constructs a new MethodInfo.
	 *
	 * @param name the name of the method
	 * @param method the actual method
	 * @param declaringType the declaring type of the method
	 * @param static a flag representing whether the method is static
	 */
	public function MethodInfo(name:String,
							   method:Function,
							   declaringType:TypeInfo,
							   staticFlag:Boolean) {
		this.name = name;
		this.method = method;
		this.declaringType = declaringType;
		this.staticFlag = staticFlag;
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeMemberInfo#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the actual method this MethodInfo represents.
	 *
	 * @return the actual method
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * @see org.as2lib.env.reflect.TypeMemberInfo#getDeclaringType()
	 */
	public function getDeclaringType(Void):TypeInfo {
		return declaringType;
	}
	
	/**
	 * Allows you to call this method on a different scope that is on any
	 * object you want.
	 * 
	 * @param scope 'this'-scope for the method execution
	 * @param args arguments to be used for the method invocation
	 * @return the return value of the method execution
	 */
	public function applyTo(scope, args:Array) {
		return method.apply(scope, args);
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
		return ReflectConfig.getMethodInfoStringifier().execute(this);
	}
	
}