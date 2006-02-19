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
import org.as2lib.util.Stringifier;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.stringifier.PatternLogMessageStringifier;

/**
 * {@code LogMessage} is a dumb data holder that contains all the information about
 * the message to log.
 * 
 * <p>These information are the the message to log, its level and the name of the
 * logger that is responsible for logging the message.
 * 
 * <p>The {@link #toString} method uses the set stringifier to obtain its string
 * representation. If you want a different appearance of the log message you can
 * use the static {@link #setStringifier} method to set your custom stringifier.
 *
 * <p>The {@link PatternLogMessageStringifier} supports different presentation styles.
 * It allows to switch the log level, the logger name and the time on and off.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.LogMessage extends BasicClass {
	
	/** The currently used stringifier. */
	private static var stringifier:Stringifier;
	
	/**
	 * Returns either the stringifier set via {@link #setStringifier} or the default
	 * one which is an instance of class {@link PatternLogMessageStringifier}.
	 *
	 * @return the currently used stringifier
	 */
	public static function getStringifier(Void):Stringifier {
		if (!stringifier) stringifier = new PatternLogMessageStringifier();
		return stringifier;
	}
	
	/**
	 * Sets a new stringifier to be used by the {@link #toString} method.
	 *
	 * <p>If {@code newStringifier} is {@code null} the {@link #getStringifier} method
	 * will return the default stringifier.
	 *
	 * @param newStringifier the new stringifier to be used
	 */
	public static function setStringifier(newStringifier:Stringifier):Void {
		stringifier = newStringifier;
	}
	
	/** The message object to log. */
	private var message;
	
	/** The level the of the log message. */
	private var level:LogLevel;
	
	/** The name of the logger that logs the message. */
	private var loggerName:String;
	
	/** The number of milliseconds elapsed from 1/1/1970 until log message was created. */
	private var timeStamp:Number;
	
	/** The name of the source method of this message. */
	private var sourceMethodName:String;
	
	/** The method that logs this message. */
	private var sourceMethod:Function;
	
	/** The object that implements the method that logs this message. */
	private var sourceObject;
	
	/**
	 * Constructs a new {@code LogMessage} instance.
	 * 
	 * <p>If {@code timeStamp} is {@code null} or {@code undefined} this constructor
	 * sets it by itself using the current time.
	 *
	 * @param message the message object to log
	 * @param level the level of the passed-in {@code message}
	 * @param loggerName the name of the logger that logs the {@code message}
	 * @param timeStamp the number of milliseconds elapsed from 1/1/1970 until this
	 * message was created
	 * @param sourceMethod the method that logs this message
	 * @param sourceObject the object of the logging method
	 */
	public function LogMessage(message, level:LogLevel, loggerName:String, timeStamp:Number, sourceMethod:Function, sourceObject) {
		this.message = message;
		this.level = level;
		this.loggerName = loggerName;
		// new Date().getTime() is not mtasc compatible
		this.timeStamp = timeStamp == null ? (new Date()).getTime() : timeStamp;
		this.sourceMethod = sourceMethod;
		this.sourceObject = sourceObject;
	}
	
	/**
	 * Returns the message object to log
	 *
	 * @return message the message object to log
	 */
	public function getMessage(Void) {
		return message;
	}
	
	/**
	 * Returns the level of the message.
	 *
	 * @return the level of the message
	 */
	public function getLevel(Void):LogLevel {
		return level;
	}
	
	/**
	 * Returns the name of the logger that logs the message.
	 *
	 * @return the name of the logging logger
	 */
	public function getLoggerName(Void):String {
		return loggerName;
	}
	
	/**
	 * Returns the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 *
	 * @return the number of milliseconds elapsed from 1/1/1970 until message was
	 * created.
	 */
	public function getTimeStamp(Void):Number {
		return timeStamp;
	}
	
	/**
	 * Returns the name of the source method of this message.
	 * 
	 * @return the name of the source method of this message
	 */
	public function getSourceMethodName(Void):String {
		return sourceMethodName;
	}
	
	/**
	 * Sets the name of the source method.
	 * 
	 * @param sourceMethodName the name of the source method
	 */
	public function setSourceMethodName(sourceMethodName:String):Void {
		this.sourceMethodName = sourceMethodName;
	}
	
	/**
	 * Returns the method that logs this message.
	 * 
	 * @return the method that logs this message
	 */
	public function getSourceMethod(Void):Function {
		return sourceMethod;
	}
	
	/**
	 * Returns the object that implements the method that logs this message.
	 * 
	 * @return the object that implements the source method
	 */
	public function getSourceObject(Void) {
		return sourceObject;
	}
	
	/**
	 * Sets the source object.
	 * 
	 * @param sourceObject the source object
	 */
	public function setSourceObject(sourceObject):Void {
		this.sourceObject = sourceObject;
	}
	
	/**
	 * Uses the stringifier returned by the static {@link #getStringifier} method
	 * to stringify this instance.
	 *
	 * @return the string representation of this log message
	 */
	public function toString():String {
		return getStringifier().execute(this);
	}
	
}