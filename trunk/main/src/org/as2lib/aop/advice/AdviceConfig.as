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
import org.as2lib.aop.advice.AdviceFactory;
import org.as2lib.aop.advice.DynamicAdviceFactory;
import org.as2lib.aop.advice.SimpleDynamicAdviceFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.advice.AdviceConfig extends BasicClass {
	
	/** Stores the set DynamicAdviceFactory. */
	private static var dynamicAdviceFactory:DynamicAdviceFactory;
	
	/**
	 * Sets a new DynamicAdviceFactory.
	 *
	 * @param factory the new DynamicAdviceFactory
	 */
	public static function setDynamicAdviceFactory(factory:DynamicAdviceFactory):Void {
		dynamicAdviceFactory = factory;
	}
	
	/**
	 * Returns the set or the default DynamicAdviceFactory. The defult factory
	 * is SimpleDynamicAdviceFactory.
	 *
	 * @return the set or the default DynamicAdviceFactory
	 */
	public static function getDynamicAdviceFactory(Void):DynamicAdviceFactory {
		if (!dynamicAdviceFactory) dynamicAdviceFactory = new SimpleDynamicAdviceFactory();
		return dynamicAdviceFactory;
	}
	
	/**
	 * Private constructor.
	 */
	private function AdviceConfig(Void) {
	}
	
}