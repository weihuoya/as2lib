﻿/*
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

import org.as2lib.env.except.Throwable;
import org.as2lib.core.BasicInterface;

/**
 * OutAccess defines all possible operations to write output at specific OutLevels.
 *
 * @author Simon Wacker
 */
interface org.as2lib.env.out.OutAccess extends BasicInterface {
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set
	 * to Out.ALL.
	 *
	 * @param message the message object to be written out
	 */
	public function log(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.DEBUG or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function debug(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.INFO or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function info(message):Void;
	
	/**
	 * Outputs a message object. The output will only be made when the OutLevel is set to
	 * Out.WARNING or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param message the message object to be written out
	 */
	public function warning(message):Void;
	
	/**
	 * Outputs an error object. The output will only be made when the OutLevel is set to
	 * Out.ERROR or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param error the error object to be written out
	 */
	public function error(error):Void;
	
	/**
	 * Outputs an error object. The output will only be made when the OutLevel is set to
	 * Out.FATAL or an above OutLevel. Refer to Out to see the correct order of OutLevels.
	 *
	 * @param error the error object to be written out
	 */
	public function fatal(error):Void;
}