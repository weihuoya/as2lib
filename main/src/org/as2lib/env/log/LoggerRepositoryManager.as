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
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.logger.RootLogger;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.LoggerRepositoryManager extends BasicClass {
	
	/** Repository that stores already retrieved loggers. */
	private static var repository:LoggerRepository;
	
	/**
	 * Reutrns the currently used repository. That is either the default
	 * one or a repository set via #setRepository().
	 *
	 * @return the currently used repository
	 */
	public static function getRepository(Void):LoggerRepository {
		if (!repository) repository = new LoggerHierarchy(new RootLogger(AbstractLogLevel.ALL));
		return repository;
	}
	
	/**
	 * Sets a new repositroy returned by #getRepositroy().
	 *
	 * @param repository the new repository
	 */
	public static function setRepository(newRepository:LoggerRepository):Void {
		repository = newRepository;
	}
	
	/**
	 * Private constructor.
	 */
	private function LoggerRepositoryManager(Void) {
	}
	
}