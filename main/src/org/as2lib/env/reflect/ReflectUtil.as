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
	
	public static function getClassName(object):String {
		if (object == null) return null;
		if (typeof(object) == "function") {
			return getClassNameForClass(object);
		}
		return getClassNameForInstance(object);
	}
	
	public static function getClassNameForInstance(instance):String {
		if (instance == null) return null;
		// MovieClips on the stage do not have a '__constructor__' but a 'constructor' variable.
		return getClassNameForClass(instance.__constructor__ ? instance.__constructor__ : instance.constructor);
	}
	
	public static function getClassNameForClass(clazz:Function):String {
		if (!clazz) return null;
		_global.ASSetPropFlags(_global, null, 0, true);
		return getClassNameForClassByPackage(clazz, _global, "");
	}
	
	private static function getClassNameForClassByPackage(c:Function, p, n:String):String {
		for (var r:String in p) {
			try {
				if (p[r] == c) return (n + r);
				if (p[r].__constructor__ == Object) {
					r = getClassNameForClassByPackage(c, p[r], n + r + ".");
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
			return getMethodNameByClass(method, object);
		}
		return getMethodNameByInstance(method, object);
	}
	
	public static function getMethodNameByInstance(method:Function, instance):String {
		if (!method || instance == null) return null;
		return getMethodNameByClass(method, instance.__constructor__);
	}
	
	public static function getMethodNameByClass(method:Function, clazz:Function):String {
		if (!method || !clazz) return null;
		var p = clazz.prototype;
		while (p) {
			_global.ASSetPropFlags(p, null, 0, true);
			_global.ASSetPropFlags(p, ["__proto__", "constructor", "prototype"], 7, true);
			for (var n:String in p) {
				try {
					if (p[n] == method) return n;
				} catch (e) {
				}
			}
			p = p.__proto__;
		}
		for (var n:String in clazz) {
			_global.ASSetPropFlags(clazz, null, 0, true);
			_global.ASSetPropFlags(clazz, ["__proto__", "constructor", "prototype"], 7, true);
			try {
				if (clazz[n] == method) return n;
			} catch (e) {
			}
		}
		return null;
	}
	
	public static function isMethodStatic(methodName:String, object):Boolean {
		if (!methodName || object == null) return false;
		if (typeof(object) == "function") {
			return isMethodStaticByClass(methodName, object);
		}
		return isMethodStaticByInstance(methodName, object);
	}
	
	public static function isMethodStaticByInstance(methodName:String, instance):Boolean {
		if (!methodName || instance == null) return false;
		return isMethodStaticByClass(methodName, instance.__constructor__);
	}
	
	public static function isMethodStaticByClass(methodName:String, clazz:Function):Boolean {
		if (!methodName || !clazz) return false;
		try {
			if (clazz[methodName]) return true;
		} catch (e) {
		}
		return false;
	}
	
	public static function isConstructor(constructor:Function, object):Boolean {
		if (!constructor || object == null) return false;
		if (typeof(object) == "function") {
			return isConstructorByClass(constructor, object);
		}
		return isConstructorByInstance(constructor, object);
	}
	
	public static function isConstructorByInstance(constructor:Function, instance):Boolean {
		if (!constructor || instance == null) return false;
		return isConstructorByClass(constructor, instance.__constructor__);
	}
	
	public static function isConstructorByClass(constructor:Function, clazz:Function):Boolean {
		return (constructor == clazz);
	}
	
	/**
	 * Private constructor.
	 */
	private function ReflectUtil(Void) {
	}
	
}