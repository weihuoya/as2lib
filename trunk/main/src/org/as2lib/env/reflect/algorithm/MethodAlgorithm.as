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
import org.as2lib.env.reflect.CompositeMemberInfo;
import org.as2lib.env.reflect.MethodInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.algorithm.ContentAlgorithm;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.PrimitiveTypeMap;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.MethodAlgorithm extends BasicClass implements ContentAlgorithm {
	private var r:Map;
	private var i:ClassInfo;
	private var s:Boolean;
	
	public function MethodAlgorithm(Void) {
	}
	
	public function execute(i:CompositeMemberInfo):Map {
		this.i = ClassInfo(i);
		this.r = new PrimitiveTypeMap();
		
		this.s = true;
		var c:Function = this.i.getType();
		search(c);
		
		this.s = false;
		var p:Object = c.prototype;
		_global.ASSetPropFlags(p, null, 0, true);
		_global.ASSetPropFlags(p, ["__proto__", "constructor", "__constructor__"], 7, true);
		search(p);
		_global.ASSetPropFlags(p, null, 1, true);
		
		return r;
	}
	
	private function search(t):Void {
		var k:String;
		for (k in t) {
			if (t[k] instanceof Function
					&& k.indexOf("__get__") < 0
					&& k.indexOf("__set__") < 0) {
				r.put(k, new MethodInfo(k, t[k], i, s));
			}
		}
	}
}