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

import org.as2lib.context.ApplicationEventPublisher;
import org.as2lib.context.MessageSource;
import org.as2lib.bean.factory.ListableBeanFactory;

/**
 * @author Simon Wacker
 */
interface org.as2lib.context.ApplicationContext extends ListableBeanFactory {
	
	/**
	 * Returns a display name for this context.
	 * 
	 * @return this context's display name
	 */
	public function getDisplayName(Void):String;
	
	/**
	 * Returns the parent context, or {@code null} if there is no parent context and
	 * this is the root of the context hierarchy.
	 * 
	 * @return the parent of this context
	 */
	public function getParent(Void):ApplicationContext;
	
	/**
	 * Returns the event publisher to notify application listeners of events.
	 * 
	 * @return the event publisher
	 */
	public function getEventPublisher(Void):ApplicationEventPublisher;
	
	/**
	 * Returns the message source to resolve messages. This enables parameterization
	 * and internationalization of messages.
	 * 
	 * @return the message source to resolve messages
	 */
	public function getMessageSource(Void):MessageSource;
	
}