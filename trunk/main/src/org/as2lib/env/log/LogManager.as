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
import org.as2lib.env.log.LoggerRepository;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * LogManager is the core access point in the logging api.
 *
 * <p>You use it to set the underlying repository that stores and releases
 * loggers and to obtain a logger according to a logger's name of the
 * repository.
 *
 * <p>The repository must be set before anything else using the LogManager
 * as access point to obtain loggers. There is no default repository.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.LogManager extends BasicClass {
	
	/** Repository that stores already retrieved loggers. */
	private static var repository:LoggerRepository;
	
	/**
	 * Returns the logger according the name.
	 *
	 * <p>Uses the set logger repository to receive the logger that gets
	 * returned.
	 *
	 * @param loggerName the name of the logger to return
	 * @return the logger according to the name
	 */
	public static function getLogger(loggerName:String):Logger {
		return getLoggerRepository().getLogger(loggerName);
	}
	
	/**
	 * Reutrns the logger repository set via #setLoggerRepository(LoggerRepository):Void.
	 *
	 * <p>There is no default logger repository, so you must set it before
	 * anything else.
	 *
	 * @return the set logger repository
	 */
	public static function getLoggerRepository(Void):LoggerRepository {
		return repository;
	}
	
	/**
	 * Sets a new repositroy returned by #getLoggerRepositroy(Void):LoggerRepository.
	 *
	 * @param loggerRepository the new logger repository
	 */
	public static function setLoggerRepository(loggerRepository:LoggerRepository):Void {
		repository = loggerRepository;
	}
	
	/**
	 * Private constructor.
	 */
	private function LogManager(Void) {
	}
	
}