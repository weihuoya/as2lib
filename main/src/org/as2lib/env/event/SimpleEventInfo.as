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
import org.as2lib.env.event.EventInfo;

/**
 * A simple implementation of the EventInfo interface. You can use this class
 * if you do not want to pass any specific information to the EventListener.
 *
 * @author Simon Wacker
 */
class org.as2lib.env.event.SimpleEventInfo extends BasicClass implements EventInfo {
	/** Name of the event */
	private var name:String;
	
	/**
	 * Constructs a SimpleEventInfo.
	 */
	public function SimpleEventInfo(name:String) {
		this.name = name;
	}
	
	/**
	 * @see org.as2lib.env.event.EventInfo
	 */
	public function getName(Void):String {
		return this.name;
	}
}