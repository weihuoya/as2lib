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
import org.as2lib.env.out.OutRepository;
import org.as2lib.env.out.OutHierachy;
import org.as2lib.env.out.Out;

/**
 * TODO: OutRepositoryManager should load from an XML configuration file
 *       when available.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.out.OutRepositoryManager extends BasicClass {
	
	/** OutRepository that stores already retrieved out instances. */
	private static var repository:OutRepository;
	
	/**
	 * Reutrns the currently used OutRepository. That is either the default
	 * OutHierachy of an OutRepository instance set via #setRepository().
	 *
	 * @return the currently used OutRepository instance
	 */
	public static function getRepository(Void):OutRepository {
		if (!repository) repository = new OutHierachy(new Out(""));
		return repository;
	}
	
	/**
	 * Sets a new OutRepository returned by #getRepositroy().
	 *
	 * @param repository the new OutRepository
	 */
	public static function setRepository(repository:OutRepository):Void {
		eval("th" + "is").repository = repository;
	}
	
	/**
	 * Private constructor.
	 */
	private function OutRepositoryManager(Void) {
	}
	
}