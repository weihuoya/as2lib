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
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;
import org.as2lib.env.reflect.ReferenceNotFoundException;

/**
 * PackageAlgorithm searches for the specified package and returns a PackageInfo
 * representing the found package.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.PackageAlgorithm extends BasicClass implements CacheAlgorithm {
	private var c:Cache;
	private var p:PackageInfo;
	
	public function PackageAlgorithm(Void) {
	}
	
	public function execute(o):CompositeMemberInfo {
		c = ReflectConfig.getCache();
		p = null;
		findAndStore(c.getRoot(), o);
		if (!p) {
			throw new ReferenceNotFoundException("The package [" + o + "] could not be found.", this, arguments);
		}
		return p;
	}
	
	public function findAndStore(a:PackageInfo, o):Boolean {
		var b = a.getPackage();
		var i:String;
		for (i in b) {
			var e:Object = b[i];
			if (typeof(e) == "object") {
				var d:PackageInfo = c.getPackage(e);
				if (!d) {
					d = c.addPackage(new PackageInfo(i, e, a));
				}
				if (e == o) {
					p = d;
					return true;
				}
				// replace recursion with loop
				if (findAndStore(d, o)) {
					return true;
				}
			}
		}
		return false;
	}
}