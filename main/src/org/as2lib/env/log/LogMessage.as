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
	
	/** Stringifier to stringify messages for MTASC. */
	private static var mtascStringifier:Stringifier;
	
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

	/**
	 * Returns either the stringifier set via {@link #setMtascStringifier} or the default
	 * MTASC stringifier which is an instance of class {@link PatternLogMessageStringifier}
	 * and uses {@link PatternLogMessageStringifier#MTASC_PATTERN} pattern.
	 *
	 * @return the currently used MTASC stringifier
	 */
	public static function getMtascStringifier(Void):Stringifier {
		if (!mtascStringifier) mtascStringifier = new PatternLogMessageStringifier(PatternLogMessageStringifier.MTASC_PATTERN);
		return mtascStringifier;
	}
	
	/**
	 * Sets a new MTASC stringifier to be used by the {@link #toMtascString} method.
	 *
	 * <p>If {@code newMtascStringifier} is {@code null} the {@link #getMtascStringifier} method
	 * will return the default MTASC stringifier.
	 *
	 * @param newMtascStringifier the new MTASC stringifier to be used
	 */
	public static function setMtascStringifier(newMtascStringifier:Stringifier):Void {
		mtascStringifier = newMtascStringifier;
	}
	
	/** 
	 * Creates new {@code LogMessage} instance for MTASC with the MTASC-specified arguments.
	 * 
	 * @param message the message object to log
	 * @param location the fully qualified class name and the method name separated by "::"
	 * @param fileName the name of the file defining the class
	 * @param lineNumber the line number at which the message was logged
	 * @return the {@code LogMessage} instance for MTASC 
	 */
	public static function forMtasc(message, location:String, fileName:String, lineNumber:Number):LogMessage {
		var m:LogMessage = new LogMessage(message);
		m.setSourceClassAndMethodNames(location);
		m.setFileName(fileName);
		m.setLineNumber(lineNumber);
		return m;	
	}
	
	/** The message object to log. */
	private var message;
	
	/** The level the of the log message. */
	private var level:LogLevel;
	
	/** The name of the logger that logs the message. */
	private var loggerName:String;
	
	/** The number of milliseconds elapsed from 1/1/1970 until log message was created. */
	private var timeStamp:Number;
	
	/** The name of the source class. */
	private var sourceClassName:String;
	
	/** The object whose method that logs this message (the method's this-scope). */
	private var sourceObject;
	
	/** The name of the source method of this message. */
	private var sourceMethodName:String;
	
	/** The method that logs this message. */
	private var sourceMethod:Function;
	
	/** The name of the file containing the class that logs this message. */
	private var fileName:String;
	
	/** The line number in the file where the log is being made. */
	private var lineNumber:Number;
	
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
	 * Sets the source class name and the source method name. The given class and
	 * method name must be separated by "::". This is a convenience method to split
	 * the class and method name passed to MTASC trace methods.
	 * 
	 * @param sourceClassAndMethodNames source class and method names separacted by
	 * "::"
	 */
	public function setSourceClassAndMethodNames(sourceClassAndMethodNames:String):Void {
		var names:Array = sourceClassAndMethodNames.split("::");
		sourceClassName = names[0];
		sourceMethodName = names[1];
	}
	
	/**
	 * Returns the source class name.
	 * 
	 * @return the source class name
	 */
	public function getSourceClassName(Void):String {
		return sourceClassName;
	}
	
	/**
	 * Sets the name of the source class.
	 * 
	 * @param sourceClassName the name of the source class
	 */
	public function setSourceClassName(sourceClassName:String):Void {
		this.sourceClassName = sourceClassName;
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
	 * Returns the object whose method logs this message (the methods this-scope).
	 * 
	 * @return the object whose method logs this message
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
	 * Returns the name of the file containing the class that logs this message.
	 * 
	 * @return thre file name
	 */
	public function getFileName(Void):String {
		return fileName;
	}
	
	/**
	 * Sets the name of the file containing the class that logs this message.
	 * 
	 * @param fileName the file name
	 */
	public function setFileName(fileName:String):Void {
		this.fileName = fileName;
	}
	
	/**
	 * Returns the line number at which the log is being made.
	 * 
	 * @return the line number
	 */
	public function getLineNumber(Void):Number {
		return lineNumber;
	}
	
	/**
	 * Sets the line number at which the log is being made.
	 * 
	 * @param lineNumber the line number
	 */
	public function setLineNumber(lineNumber:Number):Void {
		this.lineNumber = lineNumber;
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

	/**
	 * Uses the MTASC stringifier to stringify this instance.
	 *
	 * @return the string representation of this log message
	 */
	public function toMtascString():String {
		return getMtascStringifier().execute(this);
	}
	
}