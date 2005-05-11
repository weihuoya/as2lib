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

import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LogManager;

/**
 * {@code Flash} ist open for your configuration in a Flash context.
 * <p>It allows you to define all Flash specific configurations similar to the configuration
 * in {@link main.Configuration}.
 * 
 * <p>The current code contains a example that might match to usual cases. If you have additional
 * configuration you have to overwrite (not extend!) this class in your directory. All that has to
 * stay to be compatible is {@link #init}.
 * 
 * @see main.Configuration
 * @author Martin Heidegger
 * @version 1.0
 */
class main.Flash {
	
	/**
	 * Initialisation of the flash configuration.
	 * 
	 * @see org.as2lib.app.conf.FlashApplication
	 */
	public static function init(Void):Void {
		
		// Init of logging setup (abstrahation)
		setUpLogging();
	}
	
	/**
	 * Set up for common logging in a flash environment.
	 */
	private static function setUpLogging(Void):Void {

		// Trace Output in the environment.
		var root:RootLogger = new RootLogger(AbstractLogLevel.ALL);
		root.addHandler(new TraceHandler());
		  
		// Tell the Logger Repository to use the loggerHierarchy for default.
		LogManager.setLoggerRepository(new LoggerHierarchy(root)); 
	}
}