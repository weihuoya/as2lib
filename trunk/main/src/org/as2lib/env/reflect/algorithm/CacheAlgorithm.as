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

/**
 * Base interface for algorithms that search for classes, interfaces and
 * packages.
 * 
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.algorithm.CacheAlgorithm {
	
	/**
	 * Executes the algorithm and returns the searched for CompositeMemberInfo
	 * instance.
	 *
	 * @param object the object to search for
	 * @return the CompositeMemberInfo instance representing the searched for object
	 */
	public function execute(object):CompositeMemberInfo;
	
}