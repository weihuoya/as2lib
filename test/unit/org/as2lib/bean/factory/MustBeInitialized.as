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

import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.Exception;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.MustBeInitialized extends BasicClass implements InitializingBean {
	
	private var inited:Boolean; 
	
	/**
	 * @see org.springframework.beans.factory.InitializingBean#afterPropertiesSet()
	 */
	public function afterPropertiesSet(Void):Void {
		this.inited = true;
	}
	
	/**
	 * Dummy business method that will fail unless the factory
	 * managed the bean's lifecycle correctly
	 */
	public function businessMethod(Void):Void {
		if (!this.inited)
			throw new Exception("Factory didn't call afterPropertiesSet() on MustBeInitialized object", this, arguments);
	}

}