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
	private var p:PackageInfo;
	
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
	 * Executes the search for the package.
	 *
	 * <p>This method will return null if:
	 * <ul>
	 *   <li>The argument is null or undefined.</li>
	 *   <li>The searched for package could not be found.</li>
	 * </ul>
	 *
	 * <p>The search starts on the package returned by the cache's getRoot()
	 * method. That is by default _global.
	 *
	 * <p>In case the cache already contains the wanted package info it will
	 * be returned.
	 *
	 * @param o the package to find
	 * @return a PckageInfo instance representing the package or null
	 */
	public function execute(o):PackageInfo {
		if (o == null) return null;
		p = getCache().getPackage(o);
		if (p) return p;
		findAndStore(c.getRoot(), o);
		return p;
	}
	
	private function findAndStore(a:PackageInfo, o):Boolean {
		var b = a.getPackage();
		var i:String;
		for (i in b) {
			var e:Object = b[i];
			if (typeof(e) == "object") {
				var d:PackageInfo = c.addPackage(new PackageInfo(i, e, a));
				if (e == o) {
					p = d;
					return true;
				}
				if (!d.isParentPackage(a)) {
					// replace recursion with loop
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
	 * <p>Null gets returned if:
	 * <ul>
	 *   <li>The passed-in name is null, undefined or a blank string.</li>
	 *   <li>There is no package with the given name, starting from the root 'package' that is by default _global.</li>
	 * </ul>
	 *
	 * @param n the fully qualified name of the package
	 * @return the package info representing the package corresponding to the name
	 */
	public function executeByName(n:String):PackageInfo {
		if (!n) return null;
		var p:PackageInfo = getCache().getRoot();
		var f:Function = eval(p.getFullName() + "." + n);
		if (!f) return null;
		var r:PackageInfo = c.getPackage(f);
		if (r) return r;
		var a:Array = n.split(".");
		var g:Object = p.getPackage();
		for (var i:Number = 0; i < a.length; i++) {
			g = g[a[i]];
			p = c.addPackage(new PackageInfo(a[i], g, p));
		}
		return p;
	}
	
}