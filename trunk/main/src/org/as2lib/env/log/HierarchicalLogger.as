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

/**
 * HierarchicalLogger gets implemented to enable to logger to take part
 * in a Hierarchy.
 *
 * <p>This functionality is needed by the LoggerHierarchy, a repository
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
	 * Returns all handlers that are directly registered at this logger.
	 *
	 * @return all registered log handlers
	 */
	public function getAllHandler(Void):Array;
	
}