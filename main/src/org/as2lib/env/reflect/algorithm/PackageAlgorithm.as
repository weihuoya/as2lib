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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.PackageNotFoundException;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * PackageAlgorithm searches for the specified package and returns a
 * PackageInfo representing the found package.
 *
 * <p>To obtain the package info corresponding to package you use the
 * PackageAlgorithm class as follows.
 *
 * <code>var packageAlgorithm:PackageAlgorithm = new PackageAlgorithm();
 * var packageInfoByPackage:PackageInfo = packageAlgorithm.execute(org.as2lib.core);</code>
 *
 * <p>It is also possible to retrieve a package info by name.
 *
 * <code>packageInfoByName:PackageInfo = packageAlgorithm.executeByName("org.as2lib.core");</code>
 *
 * <p>Already retrieved package infos are stored in a cache. There thus 
 * exists only one PackageInfo instance per package. The following returns
 * true.
 *
 * <code>trace(packageInfoByPackage == packageInfoByName);</code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.PackageAlgorithm extends BasicClass {
	
	private var c:Cache;
	private var p;
	
	/**
	 * Constructs a new instance.
	 */
	public function PackageAlgorithm(Void) {
	}
	
	/**
	 * Sets the cache that gets used by the #execute(Object) method to
	 * look whether the package the shall be found is already stored.
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
	 * Executes the search for the passed-in package and returns information
	 * about that package.
	 *
	 * <p>The returned object has the following properties:
	 * <dl>
	 *   <dt>package</dt>
	 *   <dd>The package as Object that has been searched for, that is the
	 *       passed-in package.</dd>
	 *   <dt>name</dt>
	 *   <dd>The name as String of the searched for package.</dd>
	 *   <dt>parent</dt>
	 *   <dd>The parent represented by a {@ling PackageInfo} instance the
	 *       package is declared in / resides in.</dd>
	 * </dl>
	 *
	 * <p>Null will be returned if:
	 * <ul>
	 *   <li>The passed-in package is null or undefined.</li>
	 *   <li>The searched for package could not be found.</li>
	 * </ul>
	 *
	 * <p>The search starts on the package returned by the cache's getRoot()
	 * method, that is by default _global.
	 *
	 * @param o the package to return information about
	 * @return an object that contains information about the passed-in package
	 */
	public function execute(o) {
		if (o == null) return null;
		p = null;
		findAndStore(getCache().getRoot(), o);
		return p;
	}
	
	private function findAndStore(a:PackageInfo, o):Boolean {
		var b = a.getPackage();
		var i:String;
		for (i in b) {
			var e:Object = b[i];
			if (typeof(e) == "object") {
				if (e == o) {
					p = new Object();
					p.package = o;
					p.name = i;
					p.parent = a;
					return true;
				}
				var d:PackageInfo = c.getPackage(e);
				if (!d) {
					d = c.addPackage(new PackageInfo(e, i, a));
				}
				if (!d.isParentPackage(a)) {
					// todo: replace recursion with loop
					if (findAndStore(d, o)) {
						return true;
					}
				}
			}
		}
		return false;
	}
	
	/**
	 * Returns the package info representing the package corresponding to the
	 * passed-in package name.
	 *
	 * <p>The name must be fully qualified, that means it must consist
	 * of the package's path as well as its name. For example
	 * 'org.as2lib.core'.
	 *
	 * <p>The search starts on the package returned by the {@link Cache#getRoot}
	 * method. If this method returns a package info whose getFullName method
	 * returns null, undefined or an empty string '_global' is used instead
	 *
	 * @param n the fully qualified name of the package
	 * @return the package info representing the package corresponding to the name
	 * @throws IllegalArgumentException if the passed-in name is null or undefined or an empty string or
	 *                                  if the object corresponding to the passed-in name is not of type object
	 * @throws PackageNotFoundException if a package with the passed-in name could not be found or
	 */
	public function executeByName(n:String):PackageInfo {
		if (!n) throw new IllegalArgumentException("The passed-in package name '" + n + "' is not allowed to be null, undefined or an empty string.", this, arguments);
		var p:PackageInfo = getCache().getRoot();
		var x:String = p.getFullName();
		if (!x) x = "_global";
		var f:Object = eval(x + "." + n);
		if (!f) throw new PackageNotFoundException("A package with the name '" + n + "' could not be found.", this, arguments);
		if (typeof(f) != "object") throw new IllegalArgumentException("The object corresponding to the passed-in package name '" + n + "' is not of type object.", this, arguments);
		var r:PackageInfo = c.getPackage(f);
		if (r) return r;
		var a:Array = n.split(".");
		var g:Object = p.getPackage();
		for (var i:Number = 0; i < a.length; i++) {
			g = g[a[i]];
			p = c.addPackage(new PackageInfo(g, a[i], p));
		}
		return p;
	}
	
}