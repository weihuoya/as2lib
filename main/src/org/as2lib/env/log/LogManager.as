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
 * {@code LogManager} is the core access point of the As2lib Logging API.
 *
 * <p>You use it to set the underlying repository that stores and releases loggers
 * and to obtain a logger according to a logger's name of the repository.
 * 
 * <p>The repository must be set before anything else using this class as access
 * point to obtain loggers. There is no default repository.
 *
 * <p>This class could be used as follows with a non-singleton repository. Note
 * that you can of course also use any other kind of logger repository.
 *
 * <code>
 *   // configuration: when setting everything up
 *   var loggerHierarchy:LoggerHierarchy = new LoggerHierarchy();
 *   var traceLogger:Logger = new SimpleHierarchicalLogger("org.mydomain");
 *   traceLogger.addHandler(new TraceHandler());
 *   loggerHierarchy.addLogger(traceLogger);
 *   LogManager.setLoggerRepository(loggerHierarchy);
 *   // usage: in the class org.mydomain.MyClass
 *   var myLogger:Logger = LogManager.getLogger("org.mydomain.MyClass");
 *   if (myLogger.isInfoEnabled()) {
 *       myLogger.info("This is an informative log message.");
 *   }
 * </code>
 *
 * <p>If you have one logger that shall always be returned you can use the
 * convenience method {@link #setLogger} that does all the work with the repository
 * for you.
 *
 * <code>
 *   // configuration: when setting everything up
 *   var traceLogger:Logger = new SimpleLogger();
 *   traceLogger.addHandler(new TraceHandler());
 *   LogManager.setLogger(traceLogger);
 *   // usage: in the class org.mydomain.MyClass
 *   var myLogger:Logger = LogManager.getLogger("org.mydomain.MyClass");
 *   if (myLogger.isInfoEnabled()) {
 *       myLogger.info("This is an informative log message.");
 *   }
 * </code>
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.LogManager extends BasicClass {
	
	/** Repository that stores already retrieved loggers. */
	private static var repository:LoggerRepository;
	
	/**
	 * Returns the logger according the passed-in {@code loggerName}.
	 * 
	 * <p>Uses the set logger repository to receive the logger that is returned.
	 *
	 * <p>{@code null} is returned if the logger repository returns {@code null} or
	 * {@code undefined}.
	 *
	 * @param loggerName the name of the logger to return
	 * @return the logger according to the passed-in {@code name}
	 */
	public static function getLogger(loggerName:String):Logger {
		var result:Logger = getLoggerRepository().getLogger(loggerName);
		if (result) return result;
		return null;
	}
	
	/**
	 * Sets the {@code logger} that is returned on calls to the {@link #getLogger}
	 * method.
	 *
	 * <p>This method actually sets a singleton repository via the static
	 * {@link #setLoggerRepository} that always returns the passed-in {@code logger}
	 * and ignores the name.
	 *
	 * <p>You could also set the repository by hand, this is just an easier way of
	 * doing it if you always want the same logger to be returned.
	 *
	 * @param logger the logger to return on calls to the {@code #getLogger} method
	 */
	public static function setLogger(logger:Logger):Void {
		repository = getBlankLoggerRepository();
		repository.getLogger = function(loggerName:String):Logger {
			return logger;
		}
	}
	
	/**
	 * Returns a blank logger repository.
	 *
	 * <p>This is a {@code LoggerRepository} instance with no implemented methods.
	 *
	 * @return a blank logger repository
	 */
	private static function getBlankLoggerRepository(Void):LoggerRepository {
		var result = new Object();
		result.__proto__ = LoggerRepository["prototype"];
		result.__constructor__ = LoggerRepository;
		return result;
	}
	
	/**
	 * Reutrns the logger repository set via {@link #setLoggerRepository}.
	 *
	 * <p>There is no default logger repository, so you must set it before anything
	 * else.
	 *
	 * @return the set logger repository
	 */
	public static function getLoggerRepository(Void):LoggerRepository {
		return repository;
	}
	
	/**
	 * Sets a new repositroy returned by {@link #getLoggerRepositroy}.
	 *
	 * <p>The {@link #getLogger} method uses this repository to obtain the logger for
	 * the passed-in name.
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