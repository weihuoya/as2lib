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
import org.as2lib.env.reflect.algorithm.CacheAlgorithm;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.ReferenceNotFoundException;

/**
 * ClassAlgorithm searches for the class of a specific instance and returns a
 * ClassInfo representing the found class.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.ClassAlgorithm extends BasicClass implements CacheAlgorithm {
	private var c:Cache;
	private var r:ClassInfo;
	
	public function ClassAlgorithm(Void) {
	}
	
	public function execute(d):CompositeMemberInfo {
		c = ReflectConfig.getCache();
		r = null;
		var b:PackageInfo = c.getRoot();
		var a:Object = b.getPackage();
		_global.ASSetPropFlags(a, null, 0, true);
		findAndStore(b, d);
		_global.ASSetPropFlags(a, null, 1, true);
		if (!r) {
			throw new ReferenceNotFoundException("The class corresponding to the instance [" + d + "] could not be found.", this, arguments);
		}
		return r;
	}
	
	public function findAndStore(a:PackageInfo, d):Boolean {
		var p = a.getPackage();
		var i:String;
		for (i in p) {
			var f = p[i];
			if (typeof(f) == "function") {
				if (typeof(d) == "function" && d.prototype === f.prototype
						|| /*(d instanceof Object) typeof(d) == "object" &&*/ d.__proto__ === f.prototype) {
					r = new ClassInfo(i, f, a);
					return true;
				}
			} else if (typeof(f) == "object") {
				var e:PackageInfo = c.getPackage(f);
				if (!e) {
					e = c.addPackage(new PackageInfo(i, f, a));
				}
				// replace recursion with loop
				if (findAndStore(e, d)) {
					return true;
				}
			}
		}
		return false;
	}
}