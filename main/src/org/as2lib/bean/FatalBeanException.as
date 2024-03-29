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

import org.as2lib.bean.BeanException;

/**
 * {@code FatalBeanException} super-class for all fatal exceptions thrown in the
 * {@code bean} package and sub-packages.
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.FatalBeanException extends BeanException {
	
	/**
	 * Constructs a new {@code FatalBeanException} instance.
	 * 
	 * @param message the message describing this exception
	 * @param scope the scope on which the throwing method is invoked
	 * @param args the arguments passed-to the throwing method
	 */
	public function FatalBeanException(message:String, scope, args:Array) {
		super(message, scope, args);
	}
	
}