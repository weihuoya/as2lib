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

import org.as2lib.env.out.OutLevel;
import org.as2lib.env.event.EventBroadcaster;
import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicClass;

/**
 * @author Martin Heidegger
 * @author Simon Wacker
 */
class org.as2lib.env.out.level.NoneLevel extends BasicClass implements OutLevel {
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function log(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function debug(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function info(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function warning(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function error(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
	
	/**
	 * @see org.as2lib.env.out.OutLevel
	 */
	public function fatal(m, b:EventBroadcaster, s:EventBroadcaster):Void {
	}
}