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
import org.as2lib.env.except.ThrowableStringifier;
import org.as2lib.env.except.StackTraceElementStringifier;
import org.as2lib.env.except.StackTraceStringifier;
import org.as2lib.env.except.StackTraceElementFactory;
import org.as2lib.env.except.SimpleStackTraceElementFactory;
import org.as2lib.env.except.Throwable;
import org.as2lib.util.Stringifier;

/**
 * ExceptConfig is the base configuration file for the exceptions. It allows you
 * to configure key parts of the whole exception handling process.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.except.ExceptConfig extends BasicClass {
	
	/** The Stringifier used to stringify a Throwable. */
	private static var throwableStringifier:Stringifier;
	
	/** Used to stringify a StackTraceElement */
	private static var stackTraceElementStringifier:Stringifier;
	
	/** Used to stringify the StackTrace returned by Throwable#getStackTrace(). */
	private static var stackTraceStringifier:Stringifier;
	
	/** Stores the StackTraceElementFactory used to obtain StackTraceElement instances. */
	private static var stackTraceElementFactory:StackTraceElementFactory;
	
	/**
	 * Private constructor.
	 */
	private function ExceptConfig(Void) {
	}
	
	/**
	 * Sets a new Stringifier that shall be used to stringify Throwables.
	 *
	 * @param stringifier the new Stringifier used to stringify Throwables
	 */
	public static function setThrowableStringifier(newStringifier:Stringifier):Void {
		throwableStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify Throwables.
	 *
	 * @return the Stringifier that stringifies Throwables
	 */
	public static function getThrowableStringifier(Void):Stringifier {
		if (!throwableStringifier) throwableStringifier = new ThrowableStringifier();
		return throwableStringifier;
	}
	
	/**
	 * Sets a new Stringifier that shall be used to stringify StackTraceElements.
	 *
	 * @param stringifier the new Stringifier used to stringify StackTraceElements
	 */
	public static function setStackTraceElementStringifier(newStringifier:Stringifier):Void {
		stackTraceElementStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify StackTraceElements.
	 *
	 * @return the Stringifier that stringifies StackTraceElements
	 */
	public static function getStackTraceElementStringifier(Void):Stringifier {
		if (!stackTraceElementStringifier) stackTraceElementStringifier = new StackTraceElementStringifier();
		return stackTraceElementStringifier;
	}
	
	/**
	 * Sets a new Stringifier used to stringify Stack traces.
	 *
	 * @param stringifier the new Stringifier
	 */
	public static function setStackTraceStringifier(newStringifier:Stringifier):Void {
		stackTraceStringifier = newStringifier;
	}
	
	/**
	 * Returns the Stringifier used to stringify StackTraces. A StackTrace is
	 * a Stack that is returned from the Throwable#getStackTrace() operation.
	 *
	 * @return the Stringifier that stringifies StackTraceElements
	 */
	public static function getStackTraceStringifier(Void):Stringifier {
		if (!stackTraceStringifier) stackTraceStringifier = new StackTraceStringifier();
		return stackTraceStringifier;
	}
	
	/**
	 * Sets a new StackTraceElementFactory used to obtain StackTraceElement
	 * instances.
	 *
	 * @param factory the new StackTraceElementFactory
	 */
	public static function setStackTraceElementFactory(factory:StackTraceElementFactory):Void {
		stackTraceElementFactory = factory;
	}
	
	/**
	 * Returns the set StackTraceElementFactory or the default
	 * SimpleStackTraceElementFactory.
	 *
	 * @return the StackTraceElementFactory used to obtain StackTraceElement instances
	 */
	public static function getStackTraceElementFactory(Void):StackTraceElementFactory {
		if (!stackTraceElementFactory) stackTraceElementFactory = new SimpleStackTraceElementFactory();
		return stackTraceElementFactory;
	}
	
}