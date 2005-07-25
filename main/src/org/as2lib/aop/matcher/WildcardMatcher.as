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
import org.as2lib.aop.Matcher;

/**
 * {@code WildcardMatcher} matches a join point with a pattern that may contain
 * wildcards.
 * 
 * TODO: Add a list of supported wildcards and how they can be used.
 * 
 * @author Simon Wacker
 */
class org.as2lib.aop.matcher.WildcardMatcher extends BasicClass implements Matcher {
	
	/**
	 * Constructs a new {@code WildcardMatcher} instance.
	 */
	public function WildcardMatcher(Void) {
	}
	
	/**
	 * Checks if the passed {@code joinPoint} represented by a string matches the
	 * given {@code pattern}. 
	 *
	 * <p>Supported wildcards are '*' and '..'.
	 *
	 * <p>{@code false} will be returned if:
	 * <ul>
	 *   <li>
	 *     The passed-in {@code joinPoint} is {@code null}, {@code undefined} or an
	 *     empty string.
	 *   </li>
	 *   <li>The given {@code pattern} does not match the given {@code joinPoint}.</li>
	 * </ul>
	 *
	 * <p>A {@code pattern} of value {@code null}, {@code undefined} or empty string
	 * matches every join point.
	 *
	 * @param joinPoint the string representation of the join point to match with the
	 * given {@code pattern}
	 * @param pattern the pattern to match with the {@code joinPoint}
	 * @return {@code true} if the {@code joinPoint} matches the {@code pattern} else
	 * {@code false}
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