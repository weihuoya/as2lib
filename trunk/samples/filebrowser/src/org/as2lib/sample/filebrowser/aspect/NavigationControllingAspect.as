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

import org.as2lib.aop.advice.AbstractAdvice;
import org.as2lib.aop.Aspect;
import org.as2lib.aop.aspect.AbstractAspect;
import org.as2lib.aop.JoinPoint;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.reflect.ReflectUtil;
import org.as2lib.sample.filebrowser.control.Scene;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.aspect.NavigationControllingAspect extends AbstractAspect implements Aspect {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.aspect.NavigationControllingAspect");
	
	public function NavigationControllingAspect(Void) {
		addAdvice(AbstractAdvice.AROUND, getNextFilePointcut(), aroundNextFileAdvice);
		addAdvice(AbstractAdvice.AROUND, getPreviousFilePointcut(), aroundPreviousFileAdvice);
	}
	
	private function getNextFilePointcut(Void):String {
		return "execution(org.as2lib.sample.filebrowser.control.Scene.showFirstFile())";
	}
	
	private function aroundNextFileAdvice(joinPoint:JoinPoint, args:Array) {
		var thiz:Scene = joinPoint.getThis();
		if (thiz.hasNextFile()) {
			return joinPoint.proceed(args);
		} else {
			if (logger.isInfoEnabled()) {
				logger.info("Preventing execution of 'org.as2lib.sample.filebrowser.control.Scene.showFirstFile' to prohibit circle view.");
			}
		}
		return null;
	}
	
	private function getPreviousFilePointcut(Void):String {
		return "execution(org.as2lib.sample.filebrowser.control.Scene.showPreviousFile())";
	}
	
	private function aroundPreviousFileAdvice(joinPoint:JoinPoint, args:Array) {
		try {
			return joinPoint.proceed(args);
		} catch (exception:org.as2lib.sample.filebrowser.view.NoSuchFileException) {
			if (logger.isInfoEnabled()) {
				logger.info("Catching exception [" + ReflectUtil.getTypeNameForInstance(exception) + "] to mimic existence of previous file.");
			}
		}
		return null;
	}
	
}