﻿/*
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
import org.as2lib.env.log.LogHandler;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;

import LuminicBox.Log.ConsolePublisher;
import LuminicBox.Log.LogEvent;
import LuminicBox.Log.Level;

/**
 * LuminicBoxHandler is a wrapper of the {@code ConsolePublisher} class
 * from the LuminicBox Logging API. It can be used to write log messages
 * to the LuminicBox console.
 *
 * @author Simon Wacker
 * @see <a href="http://www.luminicbox.com/dev/flash/log">LuminicBox Logging API</a>
 */
class org.as2lib.env.log.handler.LuminicBoxHandler extends BasicClass implements LogHandler {
	
	/** Holds a luminic box handler. */
	private static var luminicBoxHandler:LuminicBoxHandler;
	
	/**
	 * Returns an instance of this class.
	 *
	 * <p>This method always returns the same instance.
	 *
	 * <p>The {@code maximalInspectionDepth} is only recognized when this
	 * method is invoked the first time.
	 *
	 * @param maximalInspectionDepth (optional) the maximal depth of object
	 * inspection
	 * @return a luminic box handler
	 */
	public static function getInstance(maximalInspectionDepth:Number):LuminicBoxHandler {
		if (!luminicBoxHandler) luminicBoxHandler = new LuminicBoxHandler(maximalInspectionDepth);
		return luminicBoxHandler;
	}
	
	/** The wrapped console publisher. */
	private var consolePublisher:ConsolePublisher;
	
	/**	
	 * Constructs a new LuminicBoxHandler instance.
	 *
	 * <p>You can use one and the same instance for multiple loggers. So
	 * think about using the handler returned by the static {@link #getInstance}
	 * method. Using this instance prevents the instantiation of unnecessary
	 * luminic box handlers and and saves storage.
	 *
	 * @param maximalInspectionDepth (optional) the maximal depth of object
	 * inspection
	 */
	public function LuminicBoxHandler(maximalInspectionDepth:Number) {
		consolePublisher = new ConsolePublisher();
		if (maximalInspectionDepth != null) {
			consolePublisher.maxDepth = maximalInspectionDepth;
		}
	}
	
	/**
	 * Writes directly to the LuminicBox console.
	 *
	 * <p>Uses the {@link LogMessage#toString} method to obtain the string
	 * to write out.
	 *
	 * @param message the log message to write out
	 */
	public function write(message:LogMessage):Void {
		var event:LogEvent = new LogEvent(message.getLoggerName(), message.getMessage(), convertLevel(message.getLevel()));
		// todo: ask Pablo to allow time to be set manually
		event["time"] = new Date(message.getTimeStamp());
		consolePublisher.publish(event);
	}
	
	/**
	 * Converts the As2lib {@code LogLevel} into a LuminicBox {@code Level}.
	 *
	 * @param level the As2lib log level to convert
	 * @return the equivalent LuminicBox level
	 */
	private function convertLevel(level:LogLevel):Level {
		switch (level) {
			case AbstractLogLevel.ALL:
				return Level.ALL;
			case AbstractLogLevel.DEBUG:
				return Level.DEBUG;
			case AbstractLogLevel.INFO:
				return Level.INFO;
			case AbstractLogLevel.WARNING:
				return Level.WARN;
			case AbstractLogLevel.ERROR:
				return Level.ERROR;
			case AbstractLogLevel.FATAL:
				return Level.FATAL;
			case AbstractLogLevel.NONE:
				return Level.NONE;
			default:
				return null;
		}
	}
	
}