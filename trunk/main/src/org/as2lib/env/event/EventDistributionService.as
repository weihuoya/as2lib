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

import org.as2lib.env.event.EventListenerSource;

/**
 * {@code EventDistributionService} services the distribution of events by declaring
 * methods to add, remove and get listeners and to get a distributor that handles
 * the actual distribution in a type-safe manner.
 * 
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.EventDistributionService extends EventListenerSource {
	
	/**
	 * Returns the distributor to distribute the event to all added listeners.
	 *
	 * <p>The returned distributor can be casted to the type all added listeners have.
	 * You can then invoke the event method on it to distribute it to all added
	 * listeners. This event distribution approach has the advantage of proper
	 * compile-time type-checking.
	 * 
	 * @return the distributor to distribute the event
	 */
	public function getDistributor(Void);
	
}