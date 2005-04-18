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

import org.as2lib.env.event.EventDistributionService;

/**
 * {@code ConsumableEventDistributionService} services the distribution of events
 * by declaring methods to add, remove and get listeners and to get a distributor
 * that handles the actual distribution in a type-safe manner.
 *
 * <p>The difference to the {@code EventDistributionService} interface is that a
 * distribution service that implements this interface allows for consumable events.
 * This means that the event distribution is stopped as soon as an event is
 * consumed.
 *
 * <p>An event is consumed if a listener's event method returns {@code true}. If it
 * returns nothing, {@code null} or {@code undefined} or {@code false} the event
 * will further be distributed.
 *
 * @author Simon Wacker
 * @author Martin Heidegger
 */
interface org.as2lib.env.event.ConsumableEventDistributionService extends EventDistributionService {
	
}