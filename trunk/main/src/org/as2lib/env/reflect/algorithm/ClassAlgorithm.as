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
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * ClassAlgorithm searches for the class of a specific instance and returns
 * a ClassInfo instance representing the found class.
 *
 * <p>To obtain the class info corresponding to an instance or a class 
 * you use the ClassAlgorithm class as follows.
 *
 * <code>var myInstance:MyClass = new MyClass();
 * var classAlgorithm:ClassAlgorithm = new ClassAlgorithm();
 * var classInfoByInstance:ClassInfo = classAlgorithm.execute(myInstance);
 * var classInfoByClass:ClassInfo = classAlgorithm.execute(MyClass);</code>
 *
 * <p>Already retrieved class infos are stored in a cache. There thus 
 * exists only one ClassInfo instance of a class. The following returns
 * true.
 *
 * <code>trace(classInfoByInstance == classInfoByClass)</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.ClassAlgorithm extends BasicClass {
	
	private var c:Cache;
	private var r:ClassInfo;
	
	/**
	 * Constructs a new instance.
	 */
	public function ClassAlgorithm(Void) {
	}
	
	/**
	 * Sets the cache that gets used by the #execute(Object) method to
	 * look whether the class the shall be found is already stored.
	 *
	 * @param cache the new cache
	 */
	public function setCache(cache:Cache):Void {
		c = cache;
	}
	
	/**
	 * Returns the cache set via the #setCache(Cache) method or the default
	 * cache that gets returned by the ReflectConfig#getCache() method.
	 *
	 * @return the currently used cache
	 */
	public function getCache(Void):Cache {
		if (!c) c = ReflectConfig.getCache();
		return c;
	}
	
	/**
	 * Executes the search for the class.
	 *
	 * <p>This method will return null if:
	 * <ul>
	 *   <li>The argument is null or undefined.</li>
	 *   <li>The searched for class could not be found.</li>
	 * </ul>
	 *
	 * <p>The search starts on the package returned by the cache's getRoot()
	 * method. That is by default _global.
	 *
	 * <p>In case the cache already contains the wanted class info it will
	 * be returned.
	 *
	 * @param d instance of the class to find or
	 *          the class itself
	 * @return a ClassInfo instance representing the class or null
	 */
	public function execute(d):ClassInfo {
		if (d == null) return null;
		r = getCache().getClass(d);
		if (r) return r;
		var b:PackageInfo = c.getRoot();
		var a:Object = b.getPackage();
		_global.ASSetPropFlags(a, null, 0, true);
		findAndStore(b, d);
		return r;
	}
	
	private function findAndStore(a:PackageInfo, d):Boolean {
		var p = a.getPackage();
		var i:String;
		for (i in p) {
			var f = p[i];
			if (typeof(f) == "function") {
				if (d == f || d.__proto__ === f.prototype) {
				/*if (typeof(d) == "function" && d.prototype === f.prototype
						|| d.__proto__ === f.prototype) {*/
					// flex stores every class in _global and in its actual package
					// e.g. org.as2lib.core.BasicClass is stored in _global with name org_as2lib_core_BasicClass
					// this if-clause excludes these extra stored classes
					if (!eval("_global." + i.split("_").join(".")) || i.indexOf("_") < 0) {
						r = new ClassInfo(i, f, a);
						c.addClass(r);
						return true;
					}
				}
			} else if (typeof(f) == "object") {
				var e:PackageInfo = c.getPackage(f);
				if (!e) {
					e = c.addPackage(new PackageInfo(i, f, a));
				}
				if (!e.isParentPackage(a)) {
					// replace recursion with loop
					if (findAndStore(e, d)) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * Returns the class info representing the class corresponding to the
	 * passed-in class name.
	 *
	 * <p>The class name must be fully qualified, that means it must consist
	 * of the class's path (namespace) as well as its name. For example
	 * 'org.as2lib.core.BasicClass'.
	 *
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The passed-in name is null, undefined or a blank string.</li>
	 *   <li>There is no class with the given name, starting from the root 'package' that is by default _global.</li>
	 *   <li>The object corresponding to the name is not of type function.</li>
	 * </ul>
	 *
	 * @param n the fully qualified name of the class
	 * @return the class info representing the class corresponding to the name
	 */
	public function executeByName(n:String):ClassInfo {
		if (!n) return null;
		var p:PackageInfo = getCache().getRoot();
		var f:Function = eval(p.getFullName() + "." + n);
		if (!f) return null;
		var r:ClassInfo = c.getClass(f);
		if (r) return r;
		if (typeof(f) != "function") return null;
		var a:Array = n.split(".");
		var g:Object = p.getPackage();
		for (var i:Number = 0; i < a.length; i++) {
			if (i == a.length-1) {
				return c.addClass(new ClassInfo(a[i], f, p));
			} else {
				g = g[a[i]];
				p = c.addPackage(new PackageInfo(a[i], g, p));
			}
		}
		return null;
	}
	
}