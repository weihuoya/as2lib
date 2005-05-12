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

/**
 * {@code ReflectUtil} obtains simple information about members.
 * 
 * <p>It is independent on any module of the As2lib. And thus does not include them
 * and does not dramatically increase the file size.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectUtil extends BasicClass {
	
	/** The name to use for constructors. */
	public static var CONSTRUCTOR:String = "new";
	
	/**
	 * @overload #getTypeAndMethodInfoForType
	 * @overload #getTypeAndMethodInfoByInstance
	 */
	public static function getTypeAndMethodInfo(object, method:Function):Array {
		if (object == null || !method) return null;
		if (typeof(object) == "function") {
			return getTypeAndMethodInfoByType(object, method);
		}
		return getTypeAndMethodInfoByInstance(object, method);
	}
	
	/**
	 * Returns an array that contains the passed-in {@code method}'s scope, the name
	 * of the type that declares the method and the name of the method itself.
	 * 
	 * <p>The type that declares the {@code method} must not be the passed-in {@code type}.
	 * It may also be a super-type of the passed-in {@code type}.
	 * 
	 * <p>{@code null} will be returned if the passed-in {@code type} is {@code null}.
	 * 
	 * @param method the method to return information about
	 * @param type the type to start the search for the method
	 * @return an array containing the passed-in {@code method}'s scope, the name of
	 * the declaring type and the passed-in {@code method}'s name
	 */
	public static function getTypeAndMethodInfoByType(type:Function, method:Function):Array {
		if (!type) return null;
		var r:Array = new Array();
		var m:String;
		if (method == type) {
			m = CONSTRUCTOR;
		} else {
			m = getMethodNameByObject(method, type);
		}
		if (m != null) {
			r[0] = true;
			r[1] = getTypeNameForType(type);
			r[2] = m;
			return r;
		}
		return getTypeAndMethodInfoByPrototype(type.prototype, method);
	}
	
	/**
	 * Returns an array that contains the passed-in {@code method}'s scope, the name
	 * of the type that declares the method and the name of the method itself.
	 * 
	 * <p>The type that declares the {@code method} must not be the direct type of the
	 * passed-in {@code instance}. It may also be a super-type of this type.
	 * 
	 * <p>{@code null} will be returned if the passed-in {@code type} is {@code null}.
	 * 
	 * @param method the method to return information about
	 * @param instance the instance of the type to start the search for the method
	 * @return an array containing the passed-in {@code method}'s scope, the name of
	 * the declaring type and the passed-in {@code method}'s name
	 */
	public static function getTypeAndMethodInfoByInstance(instance, method:Function):Array {
		if (instance == null) return null;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		if (instance.__constructor__) {
			if (instance.__constructor__.prototype == instance.__proto__) {
				return getTypeAndMethodInfoByType(instance.__constructor__, method);
			}
		}
		if (instance.constructor) {
			if (instance.constructor.prototype == instance.__proto__) {
				return getTypeAndMethodInfoByType(instance.constructor, method);
			}
		}
		return getTypeAndMethodInfoByPrototype(instance.__proto__, method);
	}
	
	/**
	 * Returns an array that contains the passed-in method's {@code m} scope, the name
	 * of the type that declares the method and the name of the method itself.
	 * 
	 * <p>The type that declares the method must not be the direct type of the
	 * passed-in prototype {@code p}. It may also be a super-type of this type.
	 * 
	 * <p>{@code null} will be returned if the passed-in prototype is {@code null}.
	 * 
	 * @param m the method to return information about
	 * @param p the beginning of the prototype chain to search through
	 * @return an array containing the passed-in method's scope, the name of the
	 * declaring type and the passed-in method's name
	 */
	private static function getTypeAndMethodInfoByPrototype(p, m:Function):Array {
		if (p == null) return null;
		var o = p;
		_global.ASSetPropFlags(_global, null, 0, true);
		var n:String;
		while (p) {
			if (p.constructor == m) {
				n = CONSTRUCTOR;
			} else {
				n = getMethodNameByObject(m, p);
			}
			if (n != null) {
				var r:Array = new Array();
				r[0] = false;
				r[1] = getTypeNameForPrototype(p, _global, "", [_global]);;
				r[2] = n;
				return r;
			}
			p = p.__proto__;
		}
		return [null, getTypeNameForPrototype(o, _global, "", [_global]), null];
	}
	
	/**
	 * @overload #getTypeNameForInstance
	 * @overload #getTypeNameForType
	 */
	public static function getTypeName(object):String {
		if (object == null) return null;
		if (typeof(object) == "function") {
			return getTypeNameForType(object);
		}
		return getTypeNameForInstance(object);
	}
	
	/**
	 * Returns the name of the type, the passed-in object is an instance of.
	 *
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in {@code instance} is {@code null} or {@code undefined}.</li>
	 *   <li>The appropriate type could not be found in {@code _global}.</li>
	 * </ul>
	 *
	 * @param instance the instance of the type to return the name of
	 * @return the name of the type of the instance or {@code null}
	 */
	public static function getTypeNameForInstance(instance):String {
		if (instance == null) return null;
		_global.ASSetPropFlags(_global, null, 0, true);
		// The '__constructor__' or 'constructor' properties may not be correct with dynamic instances.
		// We thus use the '__proto__' property that referes to the prototype of the type.
		return getTypeNameForPrototype(instance.__proto__, _global, "", [_global]);
	}
	
	/**
	 * Returns the name of the passed-in {@code type}.
	 *
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in {@code type} is {@code null} or {@code undefined}.</li>
	 *   <li>The {@code type} could not be found in {@code _global}.</li>
	 * </ul>
	 *
	 * @param type the type to return the name of
	 * @return the name of the passed-in {@code type} or {@code null}
	 */
	public static function getTypeNameForType(type:Function):String {
		if (!type) return null;
		_global.ASSetPropFlags(_global, null, 0, true);
		return getTypeNameForPrototype(type.prototype, _global, "", [_global]);
	}
	
	/**
	 * Searches for the passed-in {@code c} (prototype) in the passed-in {code p}
	 * (package) and sub-packages and returns the name of the type that declares the
	 * prototype.
	 * 
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The prototype or package is {@code null} or {@code undefined}</li>
	 *   <li>The type defining the prototype could not be found.</li>
	 * </ul>
	 *
	 * @param c the prototype to search for
	 * @param p the package to find the type that defines the prototype in
	 * @param n the name of the preceding path separated by periods
	 * @param a already searched through packages
	 * @return the name of the type defining the prototype of {@code null}
	 */
	private static function getTypeNameForPrototype(c, p, n:String, a:Array):String {
		//if (c == null || p == null) return null; // why is this causing trouble?
		if (n == null) n = "";
		for (var r:String in p) {
			try {
				// flex stores every class in _global and in its actual package
				// e.g. org.as2lib.core.BasicClass is stored in _global with name org_as2lib_core_BasicClass
				// the first part of the if-clause excludes these extra stored classes
				if ((!eval("_global." + r.split("_").join(".")) || r.indexOf("_") < 0) && p[r].prototype == c) return (n + r);
				if (p[r].__constructor__ == Object) {
					// prevents recursion on back-reference
					var f:Boolean = false;
					for (var i:Number = 0; i < a.length; i++) {
						if (a[i] == p[r]) f = true;
					}
					if (!f) {
						a.push(p[r]);
						r = getTypeNameForPrototype(c, p[r], n + r + ".", a);
						if (r) return r;
					}
				}
			} catch (e) {
			}
		}
		return null;
	}
	
	/**
	 * @overload #getMethodNameByInstance
	 * @overload #getMethodNameByType
	 */
	public static function getMethodName(method:Function, object):String {
		if (!method || object == null) return null;
		if (typeof(object) == "function") {
			return getMethodNameByType(method, object);
		}
		return getMethodNameByInstance(method, object);
	}
	
	/**
	 * Returns the name of the {@code method} on the instance's {@code type}.
	 *
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in {@code method} or {@code instance} are {@code null}</li>
	 *   <li>The {@code method} does not exist on the {@code instance}'s type.</li>
	 * </ul>
	 *
	 * @param method the method to get the name of
	 * @param instance the instance whose type implements the {@code method}
	 * @return the name of the {@code method} or {@code null}
	 */
	public static function getMethodNameByInstance(method:Function, instance):String {
		if (!method || instance == null) return null;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		if (instance.__constructor__) {
			if (instance.__constructor__.prototype == instance.__proto__) {
				return getMethodNameByType(method, instance.__constructor__);
			}
		}
		if (instance.constructor) {
			if (instance.constructor.prototype == instance.__proto__) {
				return getMethodNameByType(method, instance.constructor);
			}
		}
		return getMethodNameByPrototype(method, instance.__proto__);
	}
	
	/**
	 * Returns the name of the {@code method} on the {@code type}.
	 *
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in {@code method} or {@code type} are {@code null}</li>
	 *   <li>The {@code method} does not exist on the {@code type}.</li>
	 * </ul>
	 *
	 * @param method the method to get the name of
	 * @param type the type that implements the {@code method}
	 * @return the name of the {@code method} or {@code null}
	 */
	public static function getMethodNameByType(method:Function, type:Function):String {
		if (!method || !type) return null;
		var m:String = getMethodNameByPrototype(method, type.prototype);
		if (m != null) return m;
		return getMethodNameByObject(method, type);
	}
	
	/**
	 * Returns the name of the method {@code m} on the prototype chain starting from
	 * the passed-in prototype {@code p}.
	 * 
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in method or prototype are {@code null}</li>
	 *   <li>The method does not exist on the prototype chain.</li>
	 * </ul>
	 * 
	 * @param m the method to get the name of
	 * @param o the prototype that has the {@code method}
	 * @return the name of the {@code method} or {@code null}
	 */
	private static function getMethodNameByPrototype(m:Function, p):String {
		if (m == null || p == null) return null;
		while (p) {
			getMethodNameByObject(m, p);
			p = p.__proto__;
		}
		return null;
	}
	
	/**
	 * Returns the name of the method {@code m} on the passed-in object {@code o} or
	 * {@code null}.
	 * 
	 * <p>Only the passed-in object is searched through. Note also that all methods
	 * regardless of their access permissions are enumerated.
	 * 
	 * <p>{@code null} will be returned if:
	 * <ul>
	 *   <li>The passed-in method or object are {@code null}</li>
	 *   <li>The method does not exist on the object.</li>
	 * </ul>
	 * 
	 * @param m the method to find
	 * @param o the object that may contain the method
	 * @return the name of the method or {@code null}
	 */
	private static function getMethodNameByObject(m:Function, o):String {
		var s:Function = _global.ASSetPropFlags;
		s(o, null, 0, true);
		s(o, ["__proto__", "prototype", "__constructor__", "constructor"], 7, true);
		for (var n:String in o) {
			try {
				if (o[n] == m) return n;
			} catch (e) {
			}
		}
		// ASSetPropFlags must be restored because unexpected behaviours get caused otherwise
		s(o, null, 1, true);
		return null;
	}
	
	/**
	 * @overload #isMethodStaticByInstance
	 * @overload #isMethodStaticByType
	 */
	public static function isMethodStatic(methodName:String, object):Boolean {
		if (!methodName || object == null) return false;
		if (typeof(object) == "function") {
			return isMethodStaticByType(methodName, object);
		}
		return isMethodStaticByInstance(methodName, object);
	}
	
	/**
	 * Returns whether the method with the passed-in {@code methodName} is static, that
	 * means a per type method.
	 * 
	 * <p>{@code false} will always be returned if the passed-in {@code methodName} is
	 * {@code null} or an empty string or if the passed-in {@code instance} is {@code null}.
	 *
	 * @param methodName the name of the method to check whether it is static
	 * @param instance the instance of the type that implements the method
	 * @return {@code true} if the method is static else {@code false}
	 */
	public static function isMethodStaticByInstance(methodName:String, instance):Boolean {
		if (!methodName || instance == null) return false;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		return isMethodStaticByType(methodName, instance.__constructor__ ? instance.__constructor : instance.constructor);
	}
	
	/**
	 * Returns whether the method with the passed-in {@code methodName} is static, that
	 * means a per type method.
	 * 
	 * <p>{@code false} will always be returned if the passed-in {@code methodName} is
	 * {@code null} or an empty string or if the passed-in {@code type} is {@code null}.
	 *
	 * @param methodName the name of the method to check whether it is static
	 * @param type the type that implements the method
	 * @return {@code true} if the method is static else {@code false}
	 */
	public static function isMethodStaticByType(methodName:String, type:Function):Boolean {
		if (!methodName || !type) return false;
		try {
			if (type[methodName]) return true;
		} catch (e) {
		}
		return false;
	}
	
	/**
	 * @overload #isConstructorByInstance
	 * @overload #isConstructorByType
	 */
	public static function isConstructor(constructor:Function, object):Boolean {
		if (!constructor || object == null) return false;
		if (typeof(object) == "function") {
			return isConstructorByType(constructor, object);
		}
		return isConstructorByInstance(constructor, object);
	}
	
	/**
	 * Returns whether the passed-in {@code method} is the constructor of the passed-in
	 * {@code instance}.
	 * 
	 * <p>{@code false} will always be returned if the passed-in {@code method} is
	 * {@code null} or if the passed-in {@code instance} is {@code null}.
	 *
	 * @param method the method to check whether it is the constructor of the passed-in
	 * {@code instance}
	 * @param instance the instance that might be instantiated by the passed-in {@code method}
	 * @return {@code true} if {@code method} is the constructor of {@code instance}
	 * else {@code false}
	 */
	public static function isConstructorByInstance(method:Function, instance):Boolean {
		if (!method || instance == null) return false;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		return isConstructorByType(method, instance.__constructor__ ? instance.__constructor__ : instance.constructor);
	}
	
	/**
	 * Returns whether the passed-in {@code method} is the constructor of the passed-in
	 * {@code type}.
	 * 
	 * <p>Note that in Flash the constructor is the same as the type.
	 *
	 * <p>{@code false} will always be returned if the passed-in {@code method} is
	 * {@code null} or if the passed-in {@code type} is {@code null}.
	 *
	 * @param method the method to check whether it is the constructor of the passed-in
	 * {@code type}
	 * @param type the type that might declare the passed-in {@code method} as constructor
	 * @return {@code true} if {@code method} is the constructor of {@code type} else
	 * {@code false}
	 */
	public static function isConstructorByType(method:Function, type:Function):Boolean {
		if (!method || !type) return false;
		return (method == type);
	}
	
	/**
	 * Returns an array that contains the names of the variables of the passed-in
	 * {@code instance} as {@code String}s.
	 *
	 * <p>The resulting array contains all variables' names even those hidden from
	 * for..in loops. Excluded are only {@code "__proto__"}, {@code "prototype"},
	 * {@code "__constructor__"} and {@code "constructor"} and members that are of
	 * type {@code "function"}.
	 *
	 * <p>Note that it is not possible to get variables that have been declared in the
	 * class but have not been initialized yet. These variables' names are thus not
	 * contained in the resulting array.
	 *
	 * <p>This method will never return {@code null}. If the passed-in {@code instance}
	 * has no variables an empty array will be returned.
	 *
	 * @param instance the instance whose varaibles to return
	 * @return all initialized variables of the passed-in {@code instance}
	 */
	public static function getVariableNames(instance):Array {
		var result:Array = new Array();
		var s:Function = _global.ASSetPropFlags;
		s(instance, null, 0, true);
		s(instance, ["__proto__", "prototype", "__constructor__", "constructor"], 7, true);
		for (var i:String in instance) {
			try {
				if (typeof(instance[i]) != "function") {
					result.push(i);
				}
			} catch (e) {
				// catches exceptions that may be thrown by properties
			}
		}
		s(instance, null, 1, true);
		return result;
	}
	
	/**
	 * Private constructor.
	 */
	private function ReflectUtil(Void) {
	}
	
}