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

import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.logger.SimpleHierarchicalLogger;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.logger.RootLogger extends SimpleHierarchicalLogger {
	
	/**
	 * Constructs a new instance. The name will be automatically set to
	 * 'root'.
	 *
	 * @param level the level to use, null is not allowed
	 */
	public function RootLogger(level:LogLevel) {
		super("root");
		setLevel(level);
	}
	
	/**
	 * Prevents null levels.
	 *
	 * @param level the level to use, null is not allowed
	 * @throws IllegalArgumentException when you try to set a level with value null
	 * @see org.as2lib.env.log.ConfigurableLogger
	 */
	public function setLevel(level:LogLevel):Void {
		if (!level) throw new IllegalArgumentException("The instance [" + this + "] is not allowed to have a level value of null.", this, arguments);
		super.setLevel(level);
	}
	
}