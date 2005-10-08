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
 *   	
 *   }
 * </code>
 * 
 * <p>The real instance is saved in the class at the static field "logger".
 * 
 * <p>If you define the static field "classLogger" for yourself it will not replace it
 * if its not "undefined". And return your custom logger.
 * 
 * <p>Example:
 * <code>
 *   import org.as2lib.env.log.Logger;
 *   import org.as2lib.env.log.LogManager;
 * 
 * 	 class MyClass extends LogSupport {
 * 	 	private static var classLogger:Logger = LogManager.getLogger("MyClass");
 * 	 	
 * 	 	public function test() {
 * 	 		logger.info("hi");
 * 	 	}
 * 	 }
 * </code>
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.env.log.LogSupport extends BasicClass {
	
	/**
	 * Returns the matching {@code Logger} for the passed-in class.
	 * <p>It creates a {@code Logger} instance and saves it at the static field
	 * "classLogger" of the class if its not available.
	 * 
	 * @param clazz Class that requests the logger.
	 * @return {@code Logger} related to the class.
	 */
	public static function getLoggerByClass(clazz:Function):Logger {
		var logger:Logger = clazz.classLogger;
		if (!logger) {
			// Use ClassInfo if ClassInfo has been compiled (because its faster), else use ReflectUtil
			var ClassInfo:Function = ReflectUtil.getTypeByName("org.as2lib.env.reflect.ClassInfo");
			if (ClassInfo != undefined) {
				var typeInfo = ClassInfo.forObject(clazz);
				logger = clazz.classLogger = LogManager.getLogger(typeInfo.getFullName());
			} else {
				logger = clazz.classLogger = LogManager.getLogger(ReflectUtil.getTypeNameForType(clazz));
			}
			// Set the value to null to dedicated have undefined replaced
			if (!logger) {
				logger = clazz.classLogger = null;
			}
		}
		return logger;
	}	
	
	/**
	 * Constructs a new LogSupport instance.
	 */
	public function LogSupport(Void) {
		// Create property within constructor, Macromedia Scope bug.
		addProperty("logger", getLogger, null);
	}
	
	/**
	 * Returns the {@code Logger} related to the class.
	 * 
	 * @return {@code Logger} related to the class.
	 */
	public function getLogger(Void):Logger {
		var t:Number = getTimer();
		var logger:Logger = eval("th" + "is.__constructor__.classLogger");
		if (logger === undefined) {
			logger = getLoggerByClass(eval("th" + "is.__constructor__"));
		}
		return logger;
	}
	
	/** Logger to access is automatically filled */
	public var logger:Logger;
}