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

import org.as2lib.core.BasicInterface;

/**
 * Aspect represents an aspect in AOP. The only method this
 * interface prescribes, getAdvices(Void):Array, is needed by
 * the weaver.
 * Refer to http://www.simonwacker.com/blog/archives/000041.php
 * for a short introduction of what an aspect is all about.
 *
 * @author Simon Wacker
 */
interface org.as2lib.aop.Aspect extends BasicInterface {
	
	/**
	 * Returns the advices add externally or internally to the
	 * aspect. These advices will be used for the weaving process.
	 *
	 * @returns the advices to be used by the weaver
	 */
	public function getAdvices(Void):Array;
	
}