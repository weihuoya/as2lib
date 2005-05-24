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
import org.as2lib.env.reflect.stringifier.MethodInfoStringifier;

/**
 * {@code MethodInfo} represents a method.
 * 
 * <p>{@code MethodInfo} instances for specific methods can be obtained using the
 * {@link ClassInfo#getMethods} or {@link ClassInfo#getMethod} methods. That means
 * you first have to get a class info for the class that declares or inherits the
 * method. You can therefor use the {@link ClassInfo#forObject}, {@link ClassInfo#forClass},
 * {@link ClassInfo#forInstance} and {@link ClassInfo#forName} methods.
 * 
 * <p>When you have obtained the method info you can use it to get information about
 * the method.
 *
 * <code>
 *   trace("Method name: " + methodInfo.getName());
 *   trace("Declaring type: " + methodInfo.getDeclaringType().getFullName());
 *   trace("Is Static?: " + methodInfo.isStatic());
 * </code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.MethodInfo extends BasicClass implements TypeMemberInfo {
	
	/** The method info stringifier. */
	private static var stringifier:Stringifier;
	
	/**
	 * Returns the stringifier used to stringify method infos.
	 *
	 * <p>If no custom stringifier has been set via the {@link #setStringifier} method,
	 * a instance of the default {@code MethodInfoStringifier} class is returned.
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
	 * <p>If {@code methodInfoStringifier} is {@code null} or {@code undefined}
	 * {@link #getStringifier} will return the default stringifier.
	 * 
	 * @param methodInfoStringifier the stringifier that stringifies method infos
	 */
	public static function setStringifier(methodInfoStringifier:MethodInfoStringifier):Void {
		stringifier = methodInfoStringifier;
	}
	
	/** The name of this method. */
	private var name:String;
	
	/** The concrete method. */
	private var method:Function;
	
	/** The type that declares this method. */
	private var declaringType:TypeInfo;
	
	/** A flag representing whether this method is static or not. */
	private var staticFlag:Boolean;
	
	/**
	 * Constructs a new {@code MethodInfo} instance.
	 *
	 * <p>All arguments are allowed to be {@code null}. But keep in mind that not all
	 * methods will function properly if one is.
	 * 
	 * @param name the name of the method
	 * @param method the concrete method
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
	 * Returns the name of this method.
	 *
	 * @return the name of this method
	 */
	public function getName(Void):String {
		return name;
	}
	
	
	/**
	 * Returns the full name of this method.
	 * 
	 * <p>The full name is the fully qualified name of the declaring type plus the name
	 * of this method.
	 *
	 * @return the full name of this method
	 */
	public function getFullName(Void):String {
		if (declaringType.getFullName()) {
			return declaringType.getFullName() + "." + name;
		}
		return name;
	}
	
	/**
	 * Returns the concrete method this instance represents.
	 *
	 * @return the concrete method
	 */
	public function getMethod(Void):Function {
		return method;
	}
	
	/**
	 * Returns the type that declares this method.
	 *
	 * @return the type that declares this method
	 */
	public function getDeclaringType(Void):TypeInfo {
		return declaringType;
	}
	
	/**
	 * Invokes this method on the passed-in {@code scope} passing the given {@code args}.
	 * 
	 * <p>The object referenced by {@code this} in this method is the object this method
	 * is invoked on, its / the passed-in {@code scope}.
	 * 
	 * @param scope the {@code this}-scope for the method invocation
	 * @param args the arguments to pass-to the method on invocation
	 * @return the return value of the method invocation
	 */
	public function invoke(scope, args:Array) {
		return method.apply(scope, args);
	}
	
	/**
	 * Returns whether this method is static or not.
	 * 
	 * <p>Static methods are methods per type.
	 *
	 * <p>Non-Static methods are methods per instance.
	 *
	 * @return {@code true} if this method is static else {@code false}
	 */
	public function isStatic(Void):Boolean {
		return staticFlag;
	}
	
	/**
	 * Returns the string representation of this method.
	 *
	 * <p>The string representation is obtained via the stringifier returned by the
	 * static {@link #getStringifier} method.
	 * 
	 * @return the string representation of this method
	 */
	public function toString():String {
		return getStringifier().execute(this);
	}
	
}