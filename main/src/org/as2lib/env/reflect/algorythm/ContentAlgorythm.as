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

import org.as2lib.env.reflect.CacheInfo;
import org.as2lib.data.holder.Map;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.reflect.algorythm.ContentAlgorythm {
	/**
	 * Executes the algorythm and returns a HashMap containing the searched for
	 * values.
	 *
	 * @param info a CacheInfo used as the basis of the search
	 * @return a HashMap containing the searched for values
	 */
	public function execute(info:CacheInfo):Map;
}