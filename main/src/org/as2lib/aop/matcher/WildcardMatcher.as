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
import org.as2lib.aop.Matcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.WildcardMatcher extends BasicClass implements Matcher {
	
	/**
	 * Constructs a new WildcardMatcher instance.
	 */
	public function WildcardMatcher(Void) {
	}
	
	/**
	 * Checks if the passed join point represented by a string
	 * matches the given pattern. 
	 *
	 * <p>Supported wildcards are '*' and '..'.
	 *
	 * <p>False will be returned if:
	 * <ul>
	 *   <li>The passed-in join point is null, undefined or a blank string.</li>
	 *   <li>The pattern does not match the join point.</li>
	 * </ul>
	 *
	 * <p>A pattern of value null, undefined or blank string matches every
	 * join point.
	 *
	 * @param joinPoint the join point represented as a string used as the base of the match
	 * @param pattern the pattern that shall match the join point
	 * 
	 * @see Matcher#match(String, String):Boolean
	 */
	public function match(joinPoint:String, pattern:String):Boolean {
		if (!joinPoint) return false;
		if (!pattern) return true;
		if (pattern.indexOf("*") < 0
				&& pattern.indexOf("..") < -1) {
			return (joinPoint == pattern);
		}
		return wildcardMatch(joinPoint, pattern);
	}
	
	/**
	 * TODO: Documentation
	 */
	private function wildcardMatch(jp:String, p:String):Boolean {
		var a:Array = jp.split(".");
		var b:Array = p.split(".");
		var d:Number = a.length;
		var e:Number = b.length;
		if (p.indexOf("..") < 0 && d != e) return false;
		if (b[0] == "") b.shift();
		for (var i:Number = 0; i < d; i++) {
			var f:String = b[i];
			if (f == "") {
				f = b[i+1];
				var g:Boolean = false;
				for (var k:Number = i; k < d; k++) {
					if (matchString(a[k], f)) {
						if (k == i) b.shift();
						g = true;
						i = k;
						break;
					}
					if (k > i) b.unshift("");
				}
				if (!g) return false;
			} else {
				if (!matchString(a[i], f)) return false;
			}
		}
		if (a.length != b.length) return false;
		return true;
	}
	
	/**
	 * TODO: Documentation
	 */
	private static function matchString(s:String, p:String):Boolean {
		if (p == "*") return true;
		if (p.indexOf("*") > -1) {
			var a:Array = p.split("*");
			var b:Number = a.length;
			var z:Number = -1;
			for (var i:Number = 0; i < b; i++) {
				var c:String = a[i];
				if (c == "") continue;
				var d:Number = s.indexOf(c);
				if (d < 0) return false;
				if (d < z) return false;
				z = d;
			}
			return true;
		} else {
			return (s == p);
		}
	}
	
}