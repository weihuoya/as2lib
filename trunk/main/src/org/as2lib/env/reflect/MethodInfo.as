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
import org.as2lib.env.reflect.TypeMemberInfo;
import org.as2lib.env.reflect.string.MethodInfoStringifier;

/**
 * MethodInfo represents a method.
 *
 * <p>MethodInfo instances for specific methods can be obtained using
 * the ClassInfo#getMethods or ClassInfo#getMethod methods. That means
 * you first have to get a class info for the class that declares or
 * inherits the method. You can therefor use the ClassInfo#forObject,
 * ClassInfo#forClass, ClassInfo#forInstance or ClassInfo#forName methods.
 * 
 * <p>When you have obtained the method info you can use it to get
 * information about the method.
 *
 * <code>trace("Method name: " + methodInfo.getName());
 * trace("Declaring type: " + methodInfo.getDeclaringType().getFullName());
 * trace("Is Static?: " + methodInfo.isStatic());</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.MethodInfo extends BasicClass implements TypeMemberInfo {
	
	/** The method info stringifier. */
	private static var stringifier:Stringifier;
	
	/** The name of the method. */
	private var name:String;
	
	/** The actual method. */
	private var method:Function;
	
	/** The type that declares the method. */
	private var declaringType:TypeInfo;
	
	/** A flag representing whether the method is static or not. */
	private var staticFlag:Boolean;
	
	/**
	 * Returns the stringifier used to stringify method infos.
	 *
	 * <p>If no custom stringifier has been set via the #setStringifier
	 * method, a instance of the default MethodInfoStringifier gets returned.
	 *
	 * @return the stringifier that stringifies method infos
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new MethodInfoStringifier();
		return stringifier;
	}
	
	/**
	 * Sets the stringifier used to stringify method infos.
	 *
	 * <p>If you set a stringifier of value null or undefined #getStringifier
	 * will return the default stringifier.
	 *
	 * @param methodInfoStringifier the stringifier that stringifies method infos
	 */
	public static function setStringifier(methodInfoStringifier:MethodInfoStringifier):Void {
		stringifier = methodInfoStringifier;
	}
	
	/**
	 * Constructs a new MethodInfo instance.
	 *
	 * <p>All arguments are allowed to be null. But keep in mind that not
	 * all methods will function properly if one is.
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
	 * Returns the name of the method.
	 *
	 * @return the name of the method
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * Returns the actual method this instance represents.
	 *
	 * @return the actual method
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * Returns the type that declares the method.
	 *
	 * @return the type that declares the method
	 */
	public function getDeclaringType(Void):TypeInfo {
		return declaringType;
	}
	
	/**
	 * Invokes this method on a different scope that is on any object you
	 * want, passing the specified arguments.
	 *
	 * <p>All methods the method calls get invoked on the new scope. The
	 * object referenced by 'this' is the object this method gets invoked
	 * on, its scope.
	 * 
	 * @param scope 'this'-scope for the method execution
	 * @param args arguments to be used for the method invocation
	 * @return the return value of the method execution
	 */
	public function invoke(scope, args:Array) {
		return method.apply(scope, args);
	}
	
	/**
	 * Returns whether the method is static or not.
	 *
	 * <p>Static methods are methods per type.
	 *
	 * <p>Non-Static methods are methods per instance.
	 *
	 * @return true when the method is static else false
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
	
	/**
	 * Returns the string representation of this method.
	 *
	 * <p>The string representation is obtained via the stringifier returned
	 * by the #getStringifier method.
	 *
	 * @return the string representation of this method
	 */
	public function toString(Void):String {
		return getStringifier().execute(this);
	}
	
}