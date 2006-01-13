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
import org.as2lib.util.ClassUtil;
import org.as2lib.bean.PropertyValueConverter;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.PropertyValueConverterHolder extends BasicClass {
	
	private var propertyValueConverter:PropertyValueConverter;
	private var registeredType:Function;
	
	public function PropertyValueConverterHolder(propertyValueConverter:PropertyValueConverter, registeredType:Function) {
		this.propertyValueConverter = propertyValueConverter;
		this.registeredType = registeredType;
	}
	
	public function getRegisteredType(Void):Function {
		return registeredType;
	}
	
	public function getPropertyValueConverter(requiredType:Function):PropertyValueConverter {
		if (!registeredType || !requiredType
				|| ClassUtil.isSubClassOf(requiredType, registeredType)
				|| ClassUtil.isImplementationOf(requiredType, registeredType)) {
			return propertyValueConverter;
		}
		return null;
	}
	
}