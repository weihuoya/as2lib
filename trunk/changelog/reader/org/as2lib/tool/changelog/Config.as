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

import org.as2lib.env.out.OutAccess;
import org.as2lib.env.out.Out;
import org.as2lib.env.out.handler.TraceHandler;
import org.as2lib.tool.changelog.ChangelogView;
import org.as2lib.tool.changelog.EntryFilter;

/**
 * Configuration class for the Changelog Reader.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.Config {
	
	/** Out instance for output during process. */
	private static var out:OutAccess;
	
	/**
	 * Setter for the out holder.
	 *
	 * @param out Output that should be taken to display messages.
	 */
	public static function setOut(out:OutAccess):Void {
		out = out;
	}
	
	/**
	 * Getter for the out holder.
	 *
	 * @retrun Currently configured OutAccess.
	 */
	public static function getOut(Void):OutAccess {
		if(!out) {
			out = new Out();
			Out(out).addHandler(new TraceHandler());
		}
		return out;
	}
}
