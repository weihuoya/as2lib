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

import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorythm.ContentAlgorythm;
import org.as2lib.env.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorythm.ChildrenAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var cache:Cache;
	private var data:Map;
	private var info:PackageInfo;
	private var type:String;
	
	public function ChildrenAlgorythm(Void) {
	}
	
	public function execute(info:CompositeMemberInfo):Map {
		cache = ReflectConfig.getCache();
		type = null;
		
		this.info = PackageInfo(info);
		this.data = new HashMap();
		
		var package = this.info.getPackage();
		search(package);
		
		return data;
	}
	
	private function validate(target, name:String):Boolean {
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			type = "class";
			return true;
		}
		if (ObjectUtil.isTypeOf(target[name], "object")) {
			type = "package";
			return true;
		}
		return false;
	}
	
	private function store(name:String, target):Void {
		if (type == "class") {
			var clazz:ClassInfo = cache.getClass(target[name]);
			if (ObjectUtil.isEmpty(clazz)) {
				clazz = new ClassInfo(name, target[name], info);
				cache.addClass(clazz);
			}
			data.put(name, clazz);
			return;
		}
		if (type == "package") {
			var package:PackageInfo = cache.getPackage(target[name]);
			if (ObjectUtil.isEmpty(package)) {
				package = new PackageInfo(name, target[name], info);
				cache.addPackage(package);
			}
			data.put(name, package);
			return;
		}
	}
}