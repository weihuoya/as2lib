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
 
import org.as2lib.env.log.LogLevel;
import org.as2lib.env.log.level.AbstractLogLevel;

/**
 * DynamicLogLevel lets you dynamically create your own levels.
 *
 * <p>The default levels {@link #ALL}, {@link #DEBUG, {@link #INFO},
 * {@link #WARNING}, {@link #ERROR, {@link #FATAL and {@link #NONE} normally
 * meet all requirements.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.log.level.DynamicLogLevel extends AbstractLogLevel implements LogLevel {
	
	/** Makes the static variables of the super-class accessible through this class. */
	private static var __proto__:Function = AbstractLogLevel;
	
	/**
	 * Constructs a new DynamicLogLevel instance.
	 *
	 * @param level the level represented by a number
	 * @param name the name of the level
	 * @throws IllegalArgumentException if passed-in level is null or undefined
	 */
	public function DynamicLogLevel(level:Number, name:String) {
		super (level, name);
	}
	
}