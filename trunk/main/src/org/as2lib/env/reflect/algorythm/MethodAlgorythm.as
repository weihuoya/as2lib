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
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorythm.ContentAlgorythm;
import org.as2lib.env.reflect.algorythm.AbstractContentAlgorythm;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;
import org.as2lib.util.ObjectUtil;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorythm.MethodAlgorythm extends AbstractContentAlgorythm implements ContentAlgorythm {
	private var result:Map;
	private var info:ClassInfo;
	private var staticFlag:Boolean;
	
	public function MethodAlgorythm(Void) {
	}
	
	public function execute(info:CompositeMemberInfo):Map {
		this.info = ClassInfo(info);
		this.result = new HashMap();
		
		this.staticFlag = true;
		var clazz:Function = this.info.getRepresentedType();
		search(clazz);
		
		this.staticFlag = false;
		ObjectUtil.setAccessPermission(clazz.prototype, null, ObjectUtil.ACCESS_ALL_ALLOWED);
		ObjectUtil.setAccessPermission(clazz.prototype, ["__proto__", "constructor", "__constructor__"], ObjectUtil.ACCESS_NOTHING_ALLOWED);
		search(clazz.prototype);
		ObjectUtil.setAccessPermission(clazz.prototype, null, ObjectUtil.ACCESS_IS_HIDDEN);
		
		return result;
	}
	
	private function validate(target, name:String):Boolean {
		if (ObjectUtil.isTypeOf(target[name], "function")) {
			if (!StringUtil.startsWith(name, "__get__")
					&& !StringUtil.startsWith(name, "__set__")) {
				return true;
			}
		}
		return false;
	}
	
	private function store(name:String, target):Void {
		var method:MethodInfo = new MethodInfo(name, target[name], info, staticFlag);
		result.put(name, method);
	}
}