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
import org.as2lib.util.ObjectUtil;
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
	private var cache:Cache;
	private var info:ClassInfo;
	
	public function ClassAlgorithm(Void) {
	}
	
	public function execute(object):CompositeMemberInfo {
		cache = ReflectConfig.getCache();
		info = null;
		ObjectUtil.setAccessPermission(cache.getRoot().getPackage(), null, ObjectUtil.ACCESS_ALL_ALLOWED);
		findAndStore(cache.getRoot(), object);
		ObjectUtil.setAccessPermission(cache.getRoot().getPackage(), null, ObjectUtil.ACCESS_IS_HIDDEN);
		if (ObjectUtil.isEmpty(info)) {
			throw new ReferenceNotFoundException("The class corresponding to the instance [" + object + "] could not be found.",
												 this,
												 arguments);
		}
		return info;
	}
	
	public function findAndStore(info:PackageInfo, object):Boolean {
		var package = info.getPackage();
		var i:String;
		for (i in package) {
			if (ObjectUtil.isTypeOf(package[i], "function")) {
				if (validateAndStoreClass(i, package[i], info, object)) {
					return true;
				}
			} else if (ObjectUtil.isTypeOf(package[i], "object")) {
				if (validateAndStorePackage(i, package[i], info, object)) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function validateAndStoreClass(name:String, clazz:Function, parent:PackageInfo, object):Boolean {
		if (ObjectUtil.isTypeOf(object, "object")) {
			if (object.__proto__ === clazz.prototype) {
				storeClass(name, clazz, parent);
				return true;
			}
		}
		if (ObjectUtil.isTypeOf(object, "function")) {
			if (object.prototype === clazz.prototype) {
				storeClass(name, clazz, parent);
				return true;
			}
		}
		return false;
	}
	
	private function storeClass(name:String, clazz:Function, parent:PackageInfo):Void {
		info = new ClassInfo(name, clazz, parent)
	}
	
	private function validateAndStorePackage(name:String, package, parent:PackageInfo, object):Boolean {
		var sp:PackageInfo = cache.getPackage(package);
		if (ObjectUtil.isEmpty(sp)) {
			sp = storePackage(name, package, parent);
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