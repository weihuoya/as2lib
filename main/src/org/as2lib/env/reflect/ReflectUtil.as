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
 * ReflectUtil gets used to obtain simple information about every members.
 *
 * <p>It is independent on any module of the as2lib. And thus does not
 * include them and does not increase the file size.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.ReflectUtil extends BasicClass {
	
	public static function getTypeName(object):String {
		if (object == null) return null;
		if (typeof(object) == "function") {
			return getTypeNameForType(object);
		}
		return getTypeNameForInstance(object);
	}
	
	public static function getTypeNameForInstance(instance):String {
		if (instance == null) return null;
		_global.ASSetPropFlags(_global, null, 0, true);
		// The '__constructor__' or 'constructor' properties may not be correct with dynamic instances.
		// We thus use the '__proto__' property that referes to the prototype of the type.
		return getTypeNameForPrototypeByPackage(instance.__proto__, _global, "");
	}
	
	public static function getTypeNameForType(type:Function):String {
		if (!type) return null;
		_global.ASSetPropFlags(_global, null, 0, true);
		return getTypeNameForPrototypeByPackage(type.prototype, _global, "");
	}
	
	private static function getTypeNameForPrototypeByPackage(c, p, n:String):String {
		for (var r:String in p) {
			try {
				// flex stores every class in _global and in its actual package
				// e.g. org.as2lib.core.BasicClass is stored in _global with name org_as2lib_core_BasicClass
				// the first part of the if-clause excludes these extra stored classes
				if ((!eval("_global." + r.split("_").join(".")) || r.indexOf("_") < 0) && p[r].prototype == c) return (n + r);
				if (p[r].__constructor__ == Object) {
					r = getTypeNameForPrototypeByPackage(c, p[r], n + r + ".");
					if (r) return r;
				}
			} catch (e) {
			}
		}
		return null;
	}
	
	public static function getMethodName(method:Function, object):String {
		if (!method || object == null) return null;
		if (typeof(object) == "function") {
			return getMethodNameByType(method, object);
		}
		return getMethodNameByInstance(method, object);
	}
	
	public static function getMethodNameByInstance(method:Function, instance):String {
		if (!method || instance == null) return null;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		return getMethodNameByType(method, instance.__constructor__ ? instance.__constructor__ : instance.constructor);
	}
	
	public static function getMethodNameByType(method:Function, type:Function):String {
		if (!method || !type) return null;
		var p = type.prototype;
		var s = _global.ASSetPropFlags;
		while (p) {
			s(p, null, 0, true);
			s(p, ["__proto__", "__constructor__"], 7, true);
			for (var n:String in p) {
				try {
					if (p[n] == method) return n;
				} catch (e) {
				}
			}
			// ASSetPropFlags must be restored because unexpected behaviours get caused otherwise
			s(p, null, 1, true);
			p = p.__proto__;
		}
		for (var n:String in type) {
			s(type, null, 0, true);
			s(type, ["__proto__", "constructor", "prototype"], 7, true);
			try {
				if (type[n] == method) return n;
			} catch (e) {
			}
			// ASSetPropFlags must be restored because unexpected behaviours get caused otherwise
			s(type, null, 1, true);
		}
		return null;
	}
	
	public static function isMethodStatic(methodName:String, object):Boolean {
		if (!methodName || object == null) return false;
		if (typeof(object) == "function") {
			return isMethodStaticByType(methodName, object);
		}
		return isMethodStaticByInstance(methodName, object);
	}
	
	public static function isMethodStaticByInstance(methodName:String, instance):Boolean {
		if (!methodName || instance == null) return false;
		return isMethodStaticByType(methodName, instance.__constructor__);
	}
	
	public static function isMethodStaticByType(methodName:String, type:Function):Boolean {
		if (!methodName || !type) return false;
		try {
			if (type[methodName]) return true;
		} catch (e) {
		}
		return false;
	}
	
	public static function isConstructor(constructor:Function, object):Boolean {
		if (!constructor || object == null) return false;
		if (typeof(object) == "function") {
			return isConstructorByType(constructor, object);
		}
		return isConstructorByInstance(constructor, object);
	}
	
	public static function isConstructorByInstance(constructor:Function, instance):Boolean {
		if (!constructor || instance == null) return false;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		// Note that this causes problems with dynamically created inheritance chains like
		// myMovieClip.__proto__ = MyClass.prototype because the '__constructor__' and 'constructor' 
		// properties do not get changed.
		return isConstructorByType(constructor, instance.__constructor__ ? instance.__constructor__ : instance.constructor);
	}
	
	public static function isConstructorByType(constructor:Function, type:Function):Boolean {
		return (constructor == type);
	}
	
	/**
	 * Private constructor.
	 */
	private function ReflectUtil(Void) {
	}
	
}