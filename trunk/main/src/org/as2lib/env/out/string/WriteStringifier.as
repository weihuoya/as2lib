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

import org.as2lib.core.BasicClass;
import org.as2lib.core.string.Stringifier;
import org.as2lib.env.util.ReflectUtil;
import org.as2lib.env.out.info.OutWriteInfo;
import org.as2lib.env.out.OutLevel;

/**
 * WriteStringifier is the default Stringifier used by the OutUtil.stringifyWriteInfo()
 * operation.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.out.string.WriteStringifier extends BasicClass implements Stringifier {
	/**
	 * @see org.as2lib.core.string.Stringifier
	 */
	public function execute(target):String {
		var info:OutWriteInfo = OutWriteInfo(target);
		return ("** " + getLevelName(info.getLevel()) + " ** \n" 
				+ info.getMessage());
	}
	
	private function getLevelName(level:OutLevel):String {
		return ReflectUtil.getClassInfo(level).getName();
	}
}