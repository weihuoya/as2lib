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

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.AbstractPointcut extends BasicClass {
	
	/** Stores the pattern that represents the join point. */
	private var joinPointPattern:String;
	
	/**
	 * Private constructor to prevent initialization.
	 */
	private function AbstractPointcut(Void) {
	}
	
	/**
	 * Sets a new join point pattern.
	 *
	 * @param pattern the pattern to be set
	 */
	private function setJoinPointPattern(pattern:String):Void {
		joinPointPattern = pattern;
	}
	
	/**
	 * Returns the set join point pattern.
	 *
	 * @return the set join point pattern
	 */
	private function getJoinPointPattern(Void):String {
		return joinPointPattern;
	}
	
}