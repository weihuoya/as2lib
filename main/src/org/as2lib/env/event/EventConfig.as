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
import org.as2lib.env.out.OutAccess;
import org.as2lib.util.ObjectUtil;
import org.as2lib.env.EnvConfig;

/**
 * EventConfig contains operations to configure functionality from the org.as2lib.env.event
 * package.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.EventConfig extends BasicClass {
	/** The OutAccess instance used by classes of the org.as2lib.env.event package. */
	private static var out:OutAccess;
	
	/**
	 * Private constructor.
	 */
	private function EventConfig(Void) {
	}
	
	/**
	 * Sets a new OutAccess instance.
	 *
	 * @param out the new OutAcces instance
	 */
	public static function setOut(newOut:OutAccess):Void {
		out = newOut;
	}
	
	/**
	 * Returns the OutAccess instance currently used. If no OutAccess instance
	 * has been set manually the OutAccess instance returned by EnvConifg#getOut()
	 * will be used.
	 *
	 * @return the OutAccess instance used
	 */
	public static function getOut(Void):OutAccess {
		if (ObjectUtil.isEmpty(out)) {
			return EnvConfig.getOut();
		}
		return out;
	}
}