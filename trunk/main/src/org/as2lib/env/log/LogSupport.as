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
import org.as2lib.env.log.Logger;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.env.log.LogManager;

/**
 * {@code LogSupport} is the class to access the logging system.
 * <p>If its possible to extend this class it allows you to access the {@code Logger}
 * for your instance with the private variable {@code logger}. {@code logger}
 * is a property that is only readable and redirects to {@code getLogger}.
 * 
 * <p>Example:
 * <code>
 *   class MyClass extends LogSupport {
 *   
 *   	public function test() {
 *   		logger.info("hi");
 *   	}
 *   }
 * </code>
 * 
 * <p>{@code logger} is a getter property, that means its a function call to
 * {@code getLogger}. You can't reset the logger.
 * 
 * @author Martin Heidegger
 * @version 2
 */
class org.as2lib.env.log.LogSupport extends BasicClass {
	
	/** Logger to access is automatically filled */
	public var logger:Logger;
	
	/** Internal holder for the logger, don't access it directly, use {@code logger} instead */
	private var _logger:Logger;
	
	/**
	 * Constructs a new {@code LogSupport} instance.
	 */
	public function LogSupport(Void) {
		// Create property within constructor, Macromedia Scope bug.
		addProperty("logger", getLogger, null);
	}
	
	public static function getLoggerByInstance(instance):Logger {
		var p = instance.__proto__;
		
		if (p._logger !== null && p._logger === p.__proto__._logger) {
			return saveLoggerToPrototype(p, LogManager.getLogger(
				ReflectUtil.getTypeNameForInstance(instance)));
		}
		
		return p._logger;
	}
	
	public static function getLoggerByClass(clazz:Function):Logger {	var prototype;
		
		var	p = clazz["prototype"];
		
		if (p._logger !== null && p._logger === p.__proto__._logger) {
			return saveLoggerToPrototype(p, LogManager.getLogger(
				ReflectUtil.getTypeNameForType(clazz)));
		}
		
		return p._logger;
	}
	
	private static function saveLoggerToPrototype(proto, logger:Logger):Logger {
		proto._logger = logger;
		
		// Sets the logger dedicated to null if it didn't exist
		if (!proto._logger) {
			proto._logger = null;
		}
		
		return logger;
	}
	
	public static function getLoggerByScope(scope):Logger {
		if (typeof scope == "function") {
			return getLoggerByClass(scope);
		} else {
			return getLoggerByInstance(scope);
		}
	}
	
	/**
	 * 
	 */
	public function getLogger(Void):Logger {
		return getLoggerByInstance(this);
	}
}