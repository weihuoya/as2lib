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

import org.as2lib.env.log.logger.SimpleHierarchicalLogger;
//import org.as2lib.env.log.logger.TraceLogger;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.handler.FlashoutHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.stringifier.FlashoutLogMessageStringifier;
import main.Configuration;

/**
 * Example class for a configuration in a MTASC & Flashout context.
 * Configuration File for the execution of Testcases with MTASC & Flashout to set up the 
 * logging settings and run the testcases.
 * 
 * @author Martin Heidegger.
 */
class main.Mtasc {
	
	/**
	 * Initialisation method for the configuration
	 */
	public static function main():Void {
		// Set up for logging
		setUpLogging();
		
		// Execute the non-plattform specific configuration
		Configuration.init();
	}
	
	/**
	 * Mtasc specific Logging settings.
	 */
	private static function setUpLogging(Void:Void):Void {
		
		// Setting special stringifier in a Flashout system
		LogMessage.setStringifier(new FlashoutLogMessageStringifier());

		// Use a LoggerHierarchy as repository and take a TraceLogger by default
		var loggerHierarchy:LoggerHierarchy = new LoggerHierarchy(new RootLogger(AbstractLogLevel.ALL));
		  
		// Tell the Logger Repository to use the loggerHierarchy for default.
		LogManager.setLoggerRepository(loggerHierarchy); 
		  
		var traceLogger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib");
		traceLogger.addHandler(new FlashoutHandler());
		  
		// Log to trace console in org.as2lib package
		loggerHierarchy.addLogger(traceLogger);
		  
		var exceptLogger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib.env.except");
		exceptLogger.setLevel(AbstractLogLevel.NONE);
		  
		// Disables logging of exceptions.
		loggerHierarchy.addLogger(exceptLogger);
	}
}