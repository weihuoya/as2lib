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
 * MethodInfo represents an operation.
 *
 * @author Simon Wacker
 * @see org.as2lib.core.BasicClass
 */
class org.as2lib.env.reflect.MethodInfo extends BasicClass implements TypeMemberInfo {
	/** The name of the operation. */
	private var name:String;
	
	/** The actual operation. */
	private var method:Function;
	
	/** The type that declares the operation. */
	private var declaringType:TypeInfo;
	
	/** A flag representing whether the operaion is static of not. */
	private var staticFlag:Boolean;
	
	/**
	 * Constructs a new MethodInfo.
	 *
	 * @param name the name of the operation
	 * @param method the actual operation
	 * @param declaringType the declaring type of the operation
	 * @param static a flag representing whether the operation is static
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
	 * Returns the actual operation this MethodInfo represents.
	 *
	 * @return the actual operation
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
	 * Possibility to call this method to a different scope.
	 * Allows fast executiont to a Object.
	 * 
	 * @param scope "this"-Scope for the Method call.
	 * @param arguments Arguments to be applied with this method call.
	 * @return Returnvalue of the method.
	 */
	public function applyTo(scope, arguments:Array) {
		method.apply(scope, arguments);
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