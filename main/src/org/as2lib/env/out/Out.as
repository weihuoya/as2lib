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

import org.as2lib.env.out.ConfigurableOut;
import org.as2lib.env.out.HierarchicalOut;
import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.OutLevel;
import org.as2lib.env.out.OutHandler;
import org.as2lib.env.out.OutConfig;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.env.out.level.*;
import org.as2lib.env.out.OutRepository;
import org.as2lib.env.out.OutHierarchy;
import org.as2lib.env.out.OutFactory;
import org.as2lib.env.out.OutRepositoryManager;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.event.SimpleEventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.reflect.ClassInfo;
import org.as2lib.env.overload.Overload;

/**
 * Out is the main output class. You use this class to make your output.
 * Output can be made in different OutLevels. You use these OutLevels to enable
 * or prevent specific output. OutLevels are:
 * Out.ALL, Out.DEBUG, Out.INFO, Out.WARNING, Out.ERROR, Out.FATAL, Out.NONE
 * These OutLevels are ordered in a specific order. Out.ALL will enable all output
 * to be made. Out.DEBUG only allows output that is at a lower OutLevel and so on.
 * If you for example want to prevent all output other than Exceptions and FatalExceptions
 * you would set the OutLevel to Out.ERROR with the #setLevel(OutLevel) operation.
 * You can also add your own OutHandler. To write for example to a textfile. You do this
 * with the #addHandler(OutHandler) operation.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.Out extends BasicClass implements ConfigurableOut, HierarchicalOut {
	
	/** All output will be made. */
	public static var ALL:OutLevel = new AllLevel();
	
	/** All output that is at a lower output level than DebugLevel will be made. */
	public static var DEBUG:OutLevel = new DebugLevel();
	
	/** All output that is at a lower output level than InfoLevel will be made. */
	public static var INFO:OutLevel = new InfoLevel();
	
	/** All output that is at a lower output level than WarningLevel will be made. */
	public static var WARNING:OutLevel = new WarningLevel();
	
	/** All output that is at a lower output level than ErrorLevel will be made. */
	public static var ERROR:OutLevel = new ErrorLevel();
	
	/** All output that is at a lower output level than FatalLevel will be made. */
	public static var FATAL:OutLevel = new FatalLevel();
	
	/** No output will be made. */
	public static var NONE:OutLevel = new NoneLevel();
	
	/** The EventBroadcaster that is used to dispatch to all static registered OutHandlers. */
	private static var staticBroadcaster:EventBroadcaster;
	
	/** The actual OutLevel of the Out instance. */
	private var level:OutLevel;
	
	/** The EventBroadcaster that is used to dispatch to all registered OutHandlers. */
	private var broadcaster:EventBroadcaster;
	
	/** Stores the parent of this Out instance. */
	private var parent:HierarchicalOut;
	
	/** The name of this Out instance. */
	private var name:String;
	
	/**
	 * @see OutRepository#getOut()
	 */
	public static function getOut():Out {
		var o:Overload = new Overload(eval("th" + "is"));
		o.addHandler([String], getOutByName);
		o.addHandler([String, OutFactory], getOutByNameAndFactory);
		return o.forward(arguments);
	}
	
	/**
	 * @see OutRepository#getOutByName()
	 */
	public static function getOutByName(name:String):Out {
		return OutRepositoryManager.getRepository().getOutByName(name);
	}
	
	/**
	 * @see OutRepository#getOutByNameAndFactory()
	 */
	public static function getOutByNameAndFactory(name:String, factory:OutFactory):Out {
		return OutRepositoryManager.getRepository().getOutByNameAndFactory(name, factory);
	}
	
	/**
	 * @see OutRepository#getRootOut()
	 */
	public static function getRootOut(Void):Out {
		return OutRepositoryManager.getRepository().getRootOut();
	}
	 
	/**
	 * Adds a new OutHandler to the static list of handlers. These OutHandlers will be used
	 * to make the output of all instances. They get invoked when output shall be made.
	 *
	 * @param handler the new OutHandler that shall handle output
	 */
	public static function addStaticHandler(aHandler:OutHandler):Void {
		if(!staticBroadcaster) {
			staticBroadcaster = OutConfig.getEventBroadcasterFactory().createEventBroadcaster();
		}
		staticBroadcaster.addListener(aHandler);
	}
	
	/**
	 * Removes the specified OutHandler from the list of static handlers. If the OutHandler
	 * does not exist in the list the IllegalArgumentException will be thrown.
	 *
	 * @param handler the OutHandler to be removed from the list
	 * @throws IllegalArgumentException the exception will be thrown when the OutHandler does not exist on the list
	 */
	public static function removeStaticHandler(aHandler:OutHandler):Void {
		staticBroadcaster.removeListener(aHandler);
	}
	
	/**
	 * Constructs a new Out instance and sets the default OutLevel, ALL.
	 */
	public function Out(name:String) {
		// Stays here until all classes in the current API have been rewritten to use the
		// new Output API.
		if (name === undefined) level = ALL;
		this.name = name;
		broadcaster = OutConfig.getEventBroadcasterFactory().createEventBroadcaster();
	}
	
	/**
	 * @see HierarchicalOut#getParent()
	 */
	public function getParent(Void):HierarchicalOut {
		return parent;
	}
	
	/**
	 * @see HierarchicalOut#setParent()
	 */
	public function setParent(parent:HierarchicalOut):Void {
		this.parent = parent;
	}
	
	/**
	 * @see HierarchicalOut#getName()
	 */
	public function getName(Void):String {
		return name;
	}
	
	/**
	 * @see ConfigurableOut#setLevel()
	 */
	public function setLevel(newLevel:OutLevel):Void {
		level = newLevel;
	}
	
	/**
	 * @see OutAccess#getLevel()
	 */
	public function getLevel(Void):OutLevel {
		if (!level) return getParent().getLevel();
		return level;
	}
	
	/**
	 * @see ConfigurableOut#addHandler()
	 */
	public function addHandler(aHandler:OutHandler):Void {
		broadcaster.addListener(aHandler);
	}
	
	/**
	 * @see ConfigurableOut#removeHandler()
	 */
	public function removeHandler(aHandler:OutHandler):Void {
		broadcaster.removeListener(aHandler);
	}
	
	/**
	 * @see ConfigurableOut#removeAllHandler()
	 */
	public function removeAllHandler(Void):Void {
		broadcaster.removeAllListener();
	}
	
	/**
	 * @see HierarchicalOut#getAllHandler()
	 */
	public function getAllHandler(Void):Array {
		return broadcaster.getAllListener();
	}
	
	/**
	 * @see OutAccess#isEnabled()
	 */
	public function isEnabled(level:OutLevel):Boolean {
		if (getLevel() == level) return true;
		return (getLevel() instanceof ClassInfo.forInstance(level).getType());
	}
	
	/**
	 * @see OutAccess#isLogEnabled()
	 */
	public function isLogEnabled(Void):Boolean {
		return isEnabled(ALL);
	}
	
	/**
	 * @see OutAccess#isDebugEnabled()
	 */
	public function isDebugEnabled(Void):Boolean {
		return isEnabled(DEBUG);
	}
	
	/**
	 * @see OutAccess#isInfoEnabled()
	 */
	public function isInfoEnabled(Void):Boolean {
		return isEnabled(INFO);
	}
	
	/**
	 * @see OutAccess#isWarningEnabled()
	 */
	public function isWarningEnabled(Void):Boolean {
		return isEnabled(WARNING);
	}
	
	/**
	 * @see OutAccess#isErrorEnabled()
	 */
	public function isErrorEnabled(Void):Boolean {
		return isEnabled(ERROR);
	}
	
	/**
	 * @see OutAccess#isFatalEnabled()
	 */
	public function isFatalEnabled(Void):Boolean {
		return isEnabled(FATAL);
	}
	
	/**
	 * @see OutAccess#log()
	 */
	public function log(message):Void {
		level.log(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see OutAccess#debug()
	 */
	public function debug(message):Void {
		level.debug(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see OutAccess#info()
	 */
	public function info(message):Void {
		level.info(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see org.as2lib.core.OutAccess
	 */
	public function warning(message):Void {
		level.warning(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see OutAccess#error()
	 */
	public function error(message):Void {
		level.error(message, broadcaster, staticBroadcaster);
	}
	
	/**
	 * @see OutAccess#fatal()
	 */
	public function fatal(message):Void {
		level.fatal(message, broadcaster, staticBroadcaster);
	}
	
}