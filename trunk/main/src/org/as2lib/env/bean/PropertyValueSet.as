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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.bean.PropertyValue;

/**
 * @author Simon Wacker
 */
interface org.as2lib.env.bean.PropertyValueSet extends BasicInterface {
	
	public function contains(propertyName:String):Boolean;
	public function getPropertyValue(propertyName:String):PropertyValue;
	public function getPropertyValues(Void):Array;
	public function apply(bean):Void;
	
}