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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.HashMap;
import org.as2lib.data.holder.Iterator;
import org.as2lib.data.holder.array.ArrayIterator;
import org.as2lib.aop.Pointcut;
import org.as2lib.aop.pointcut.OrCompositePointcut;
import org.as2lib.aop.pointcut.AndCompositePointcut;
import org.as2lib.aop.pointcut.KindedPointcut;
//import org.as2lib.aop.pointcut.WithinPointcut;
import org.as2lib.aop.pointcut.PointcutFactory;
import org.as2lib.aop.pointcut.PointcutRule;
import org.as2lib.aop.joinpoint.AbstractJoinPoint;

/**
 * @author Simon Wacker
 */
class org.as2lib.aop.pointcut.DynamicPointcutFactory extends BasicClass implements PointcutFactory {
	
	/** Contains all bound factories. */
	private var factoryMap:Map;
	
	/**
	 * Constructs a new DynamicPointcutFactory.
	 */
	public function DynamicPointcutFactory(Void) {
		factoryMap = new HashMap();
		bindOrCompositePointcut();
		bindAndCompositePointcut();
		bindMethodPointcut();
		bindSetPropertyPointcut();
		bindGetPropertyPointcut();
		//bindWithinPointcut();
	}
	
	/**
	 * TODO: Documentation
	 */
	private function bindOrCompositePointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf(" || ") != -1);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			return (new OrCompositePointcut(pattern));
		}
		bindPointcutFactory(rule, factory);
	}
	
	/**
	 * TODO: Documentation
	 */
	private function bindAndCompositePointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf(" && ") != -1);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			return (new AndCompositePointcut(pattern));
		}
		bindPointcutFactory(rule, factory);
	}
	
	/**
	 * TODO: Documentation
	 */
	private function bindMethodPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf("execution") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			pattern = pattern.substring(10, pattern.length - 3);
			return (new KindedPointcut(pattern, AbstractJoinPoint.TYPE_METHOD));
		}
		bindPointcutFactory(rule, factory);
	}
	
	/**
	 * TODO: Documentation
	 */
	private function bindSetPropertyPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf("set") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			pattern = pattern.substring(4, pattern.length - 1);
			return (new KindedPointcut(pattern, AbstractJoinPoint.TYPE_SET_PROPERTY));
		}
		bindPointcutFactory(rule, factory);
	}
	
	/**
	 * TODO: Documentation
	 */
	private function bindGetPropertyPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf("get") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			pattern = pattern.substring(4, pattern.length - 1);
			return (new KindedPointcut(pattern, AbstractJoinPoint.TYPE_GET_PROPERTY));
		}
		bindPointcutFactory(rule, factory);
	}
	
	/*private function bindWithinPointcut(Void):Void {
		var rule:PointcutRule = new PointcutRule();
		rule.execute = function(pattern:String):Boolean {
			return (pattern.indexOf("within") == 0);
		}
		var factory:PointcutFactory = new PointcutFactory();
		factory.getPointcut = function(pattern:String):Pointcut {
			pattern = pattern.substring(7, pattern.length - 1);
			return (new WithinPointcut(pattern));
		}
		bindPointcutFactory(rule, factory);
	}*/
	
	/**
	 * @see org.as2lib.aop.pointcut.PointcutFactory#getPointcut(String):Pointcut
	 */
	public function getPointcut(pattern:String):Pointcut {
		if (!pattern) return null;
		var iterator:Iterator = new ArrayIterator(factoryMap.getKeys());
		while (iterator.hasNext()) {
			var rule:PointcutRule = iterator.next();
			if (rule.execute(pattern)) {
				return factoryMap.get(rule).getPointcut(pattern);
			}
		}
		return null;
	}
	
	/**
	 * Binds a new factory.
	 *
	 * @param rule the rule that must evaluate to true to indicate the right factory
	 * @param factory the factory to be added
	 * @throws IllegalArgumentException if rule is null or undefined or
	 *                                  if factory is null or undefined
	 */
	public function bindPointcutFactory(rule:PointcutRule, factory:PointcutFactory):Void {
		if (!rule || !factory) throw new IllegalArgumentException("Rule and factory are not allowed to be null or undefined.", this, arguments);
		factoryMap.put(rule, factory);
	}
}