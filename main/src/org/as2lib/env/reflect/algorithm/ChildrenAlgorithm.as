﻿/*
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
import org.as2lib.env.reflect.PackageInfo;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.reflect.Cache;
import org.as2lib.env.reflect.algorithm.ContentAlgorithm;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.reflect.ReflectConfig;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.reflect.algorithm.ChildrenAlgorithm extends BasicClass implements ContentAlgorithm {
	public function ChildrenAlgorithm(Void) {
	}
	
	public function execute(g:CompositeMemberInfo):Array {
		var c:Cache = ReflectConfig.getCache();
		
		var p:PackageInfo = PackageInfo(g);
		var r:Array = new Array();
		
		var t:Object = p.getPackage();
		
		var i:String;
		for (i in t) {
			if (typeof(t[i]) == "function") {
				var b:ClassInfo = c.getClass(t[i]);
				if (!b) {
					b = new ClassInfo(i, t[i], p);
					c.addClass(b);
				}
				r[r.length] = b;
			} else if (typeof(t[i]) == "object") {
				var a:PackageInfo = c.getPackage(t[i]);
				if (!a) {
					a = new PackageInfo(i, t[i], p);
					c.addPackage(a);
				}
				r[r.length] = a;
			}
		}
		
		return r;
	}
}