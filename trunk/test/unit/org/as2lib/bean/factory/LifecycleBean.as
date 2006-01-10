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

/*
 * Copyright 2002-2005 the original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.bean.factory.BeanFactory;
import org.as2lib.bean.factory.BeanFactoryAware;
import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.DisposableBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.env.except.Exception;
import org.as2lib.env.except.IllegalStateException;

/**
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.LifecycleBean implements BeanNameAware, BeanFactoryAware, InitializingBean, DisposableBean {

	private var beanName:String;
	
	private var initMethodDeclared:Boolean = false;

	private var owningFactory:BeanFactory;

	private var postProcessedBeforeInit:Boolean;

	private var inited:Boolean;
	private var initedViaDeclaredInitMethod:Boolean;

	private var postProcessedAfterInit:Boolean;

	private var destroyed:Boolean;
	
	public function isInitMethodDeclared(Void):Boolean {
		return initMethodDeclared;
	}
	public function setInitMethodDeclared(initMethodDeclared:Boolean):Void {
		this.initMethodDeclared = initMethodDeclared;
	}

	public function setBeanName(name:String):Void {
		this.beanName = name;
	}
	public function getBeanName(Void):String {
		return beanName;
	}

	public function setBeanFactory(beanFactory:BeanFactory):Void {
		this.owningFactory = beanFactory;
	}

	public function postProcessBeforeInit(Void):Void {
		if (this.inited || this.initedViaDeclaredInitMethod) {
			throw new Exception("Factory called postProcessBeforeInit after afterPropertiesSet");
		}
		if (this.postProcessedBeforeInit) {
			throw new Exception("Factory called postProcessBeforeInit twice");
		}
		this.postProcessedBeforeInit = true;
	}

	public function afterPropertiesSet(Void):Void {
		if (this.owningFactory == null) {
			throw new Exception("Factory didn't call setBeanFactory before afterPropertiesSet on lifecycle bean");
		}
		if (!this.postProcessedBeforeInit) {
			throw new Exception("Factory didn't call postProcessBeforeInit before afterPropertiesSet on lifecycle bean");
		}
		if (this.initedViaDeclaredInitMethod) {
			throw new Exception("Factory initialized via declared init method before initializing via afterPropertiesSet");
		}
		if (this.inited) {
			throw new Exception("Factory called afterPropertiesSet twice");
		}
		this.inited = true;
	}
	
	public function declaredInitMethod(Void):Void {
		if (!this.inited) {
			throw new Exception("Factory didn't call afterPropertiesSet before declared init method");
		}		
		
		if (this.initedViaDeclaredInitMethod) {
			throw new Exception("Factory called declared init method twice");
		}
		this.initedViaDeclaredInitMethod = true;
	}

	public function postProcessAfterInit(Void):Void {
		if (!this.inited) {
			throw new Exception("Factory called postProcessAfterInit before afterPropertiesSet");
		}
		if (this.initMethodDeclared && !this.initedViaDeclaredInitMethod) {
			throw new Exception("Factory called postProcessAfterInit before calling declared init method");
		}
		if (this.postProcessedAfterInit) {
			throw new Exception("Factory called postProcessAfterInit twice");
		}
		this.postProcessedAfterInit = true;
	}

	/**
	 * Dummy business method that will fail unless the factory
	 * managed the bean's lifecycle correctly
	 */
	public function businessMethod(Void):Void {
		if (!this.inited || (this.initMethodDeclared && !this.initedViaDeclaredInitMethod)
				|| !this.postProcessedAfterInit) {
			throw new Exception("Factory didn't initialize lifecycle object correctly");
		}
	}

	public function destroy(Void):Void {
		if (this.destroyed) {
			throw new IllegalStateException("Already destroyed");
		}
		this.destroyed = true;
	}

	public function isDestroyed(Void):Boolean {
		return destroyed;
	}
	
}