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
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.pointcut.DynamicPointcutFactory;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.PointcutConfig extends BasicClass {
	
	/** Stores the set pointcut factory. */
	private static var pointcutFactory:PointcutFactory;
	
	/**
	 * Private constructor to prevent instantiation.
	 */
	private function PointcutFactory(Void) {
	}
	
	/**
	 * Sets a new PointcutFactory.
	 *
	 * @param factory the PointcutFactory to be set
	 */
	public static function setPointcutFactory(factory:PointcutFactory):Void {
		pointcutFactory = factory;
	}
	
	/**
	 * Returns the set PointcutFactory or the default DynamicPointcutFactory.
	 *
	 * @return the set or default PointcutFactory
	 */
	public static function getPointcutFactory(Void):PointcutFactory {
		if (!pointcutFactory) pointcutFactory = new DynamicPointcutFactory();
		return pointcutFactory;
	}
	
}