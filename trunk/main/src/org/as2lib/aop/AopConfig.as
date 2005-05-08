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
import org.as2lib.aop.advice.DynamicAdviceFactory;
import org.as2lib.aop.advice.SimpleDynamicAdviceFactory;
import org.as2lib.aop.Matcher;
import org.as2lib.aop.matcher.DefaultMatcher;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.AopConfig extends BasicClass {
	
	/** Stores the set pointcut factory. */
	private static var pointcutFactory:PointcutFactory;
	
	/** Stores the set DynamicAdviceFactory. */
	private static var dynamicAdviceFactory:DynamicAdviceFactory;
	
	private static var matcher:Matcher;
	
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
	
	public static function setMatcher(newMatcher:Matcher):Void {
		matcher = newMatcher;
	}
	
	public static function getMatcher(Void):Matcher {
		if (!matcher) matcher = new DefaultMatcher();
		return matcher;
	}
	
	/**
	 * Private constructor to prevent instantiation.
	 */
	private function AopConfig(Void) {
	}
	
}