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
class org.as2lib.env.log.LogUtil extends BasicClass {
	
	private static var loggers:Object = new Object();
	private static var logManager:Function;
	
	public static function getLogManager(Void) {
		if (logManager === undefined) {
			logManager = eval("_global." + "org.as2lib.env.log.LogManager");
			if (!logManager) logManager = null;
		}
		return logManager;
	}
	
	public static function getLogger(loggerName:String) {
		if (getLogManager()) {
			if (loggers[loggerName]) {
				return loggers[loggerName];
			}
			return (loggers[loggerName] = logManager.getLogger(loggerName));
		}
		return null;
	}
	
	public static function debug(message, loggerName:String):Void {
		getLogger(loggerName).debug(message)
	}
	
	public static function info(message, loggerName:String):Void {
		getLogger(loggerName).info(message);
	}
	
	public static function warning(message, loggerName:String):Void {
		getLogger(loggerName).warning(message);
	}
	
	public static function error(message, loggerName:String):Void {
		getLogger(loggerName).error(message);
	}
	
	public static function fatal(message, loggerName:String):Void {
		getLogger(loggerName).fatal(message);
	}
	
	public static function isDebugEnabled(loggerName:String):Boolean {
		return getLogger(loggerName).isDebugEnabled();
	}

	public static function isInfoEnabled(loggerName:String):Boolean {
		return getLogger(loggerName).isInfoEnabled();
	}

	public static function isWarningEnabled(loggerName:String):Boolean {
		return getLogger(loggerName).isWarningEnabled();
	}
	
	public static function isErrorEnabled(loggerName:String):Boolean {
		return getLogger(loggerName).isErrorEnabled();
	}

	public static function isFatalEnabled(loggerName:String):Boolean {
		return getLogger(loggerName).isFatalEnabled();
	}
	
	/**
	 * Private constructor.
	 */
	private function LogUtil(Void) {
	}
	
}