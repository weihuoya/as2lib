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
import org.as2lib.util.ObjectUtil;
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
	private var cache:Cache;
	private var info:PackageInfo;
	
	public function PackageAlgorithm(Void) {
	}
	
	public function execute(object):CompositeMemberInfo {
		cache = ReflectConfig.getCache();
		info = null;
		findAndStore(cache.getRoot(), object);
		if (ObjectUtil.isEmpty(info)) {
			throw new ReferenceNotFoundException("The package [" + object + "] could not be found.",
												 this,
												 arguments);
		}
		return info;
	}
	
	public function findAndStore(info:PackageInfo, object):Boolean {
		var package = info.getPackage();
		var i:String;
		for (i in package) {
			if (ObjectUtil.isTypeOf(package[i], "object")) {
				if (validateAndStorePackage(i, package[i], info, object)) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function validateAndStorePackage(name:String, package, parent:PackageInfo, object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
		}
		if (package == object) {
			info = sp;
			return true;
		}
		if (findAndStore(sp, object)) {
			return true;
		}
		return false;
	}
	
	private function storePackage(name:String, package, parent:PackageInfo):PackageInfo {
		return cache.addPackage(new PackageInfo(name, package, parent));
	}
}