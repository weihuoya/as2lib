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
import org.as2lib.env.reflect.PropertyInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorithm.ContentAlgorithm;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.HashMap;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.PropertyAlgorithm extends BasicClass implements ContentAlgorithm {
	private var r:Map;
	private var g:Map;
	private var s:Map;
	private var c:ClassInfo;
	private var a:Boolean;
	
	public function PropertyAlgorithm(Void) {
	}
	
	public function execute(c:CompositeMemberInfo):Map {
		this.c = ClassInfo(c);
		this.r = new HashMap();
		this.g = new HashMap();
		this.s = new HashMap();
		
		this.a = true;
		var b:Function = this.c.getType();
		search(b);
		
		this.a = false;
		var d:Object = b.prototype;
		_global.ASSetPropFlags(d, null, 0, true);
		_global.ASSetPropFlags(d, ["__proto__", "constructor", "__constructor__"], 7, true);
		search(d);
		_global.ASSetPropFlags(d, null, 1, true);
		
		return r;
	}
	
	public function search(t):Void {
		var i:String;
		for (i in t) {
			if (typeof(t[i]) == "function") {
				var n = i.substring(7);
				if (i.indexOf("__get__") == 0) {
					g.put(n, true);
					if (!s.get(n)) {
						r.put(n, new PropertyInfo(n, t["__set__" + n], t[i], c, a));
					}
				} else if (i.indexOf("__set__") == 0) {
					s.put(n, true);
					if (!g.get(n)) {
						r.put(n, new PropertyInfo(n, t[i], t["__get__" + n], c, a));
					}
				}
			}
		}
	}
}