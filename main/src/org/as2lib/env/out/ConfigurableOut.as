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
import org.as2lib.env.out.OutHandler;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.out.ConfigurableOut extends OutAccess {
	
	/**
	 * Sets a new OutLevel. The OutLevel determines which output will be made.
	 * Default OutLevels are: 
	 * Out.ALL, Out.DEBUG, Out.INFO, Out.WARNING, Out.ERROR, Out.FATAL, Out.NONE
	 *
	 * @param level the new OutLevel to control the output
	 */
	public function setLevel(newLevel:OutLevel):Void;
	
	/**
	 * Adds a new OutHandler to the list of handlers. These OutHandlers will be used
	 * to make the actual output. They get invoked when output shall be made.
	 *
	 * @param handler the new OutHandler that shall handle output
	 */
	public function addHandler(handler:OutHandler):Void;
	
	/**
	 * Removes the specified OutHandler from the list of handlers.
	 *
	 * @param handler the OutHandler to be removed from the list
	 */
	public function removeHandler(aHandler:OutHandler):Void;
	
	/**
	 * Removes all registered handlers.
	 */
	public function removeAllHandler(Void):Void;
	
}