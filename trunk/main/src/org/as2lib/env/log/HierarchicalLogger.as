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

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogLevel;

/**
 * HierarchicalLogger gets implemented to enable to logger to take part
 * in a hierarchy.
 *
 * <p>This functionality is needed by the {@link LoggerHierarchy}, a repository
 * that stores loggers hierarchical.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.log.HierarchicalLogger extends Logger {
	
	/**
	 * Returns the parent of this logger that must also be a hierarchical
	 * logger.
	 *
	 * <p>This logger normally uses the parent to get the log level, if no
	 * one has been set to this logger manually and to get the handlers of
	 * its parents to write the log messages.
	 *
	 * @return the parent of this logger
	 */
	public function getParent(Void):HierarchicalLogger;
	
	/**
	 * Returns the name of this logger.
	 *
	 * <p>The name is a fully qualified name and the different parts must
	 * be separated by periods or other characters depending on the usage.
	 * The name could for example be 'org.as2lib.core.BasicClass'.
	 *
	 * @return the name of this logger
	 */
	public function getName(Void):String;
	
	/**
	 * Returns the level of this or the one of the parent logger.
	 *
	 * @return the level of this or the one of the parent logger.
	 */
	public function getLevel(Void):LogLevel;
	
	/**
	 * Returns all handlers this logger broadcasts to when logging a message.
	 *
	 * <p>These handlers are the once directly added to this logger and the
	 * once of the parents.
	 *
	 * <p>Note that this is no basic rule but rather the normal functionality.
	 * There are also hierarchical loggers that do not return the handlers
	 * of parents or do not return any handlers at all.
	 *
	 * @return all added log handlers and the ones of the parents
	 */
	public function getAllHandlers(Void):Array;
	
}