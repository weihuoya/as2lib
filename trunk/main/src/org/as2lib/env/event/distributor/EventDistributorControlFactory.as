
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

import org.as2lib.core.BasicInterface;
import org.as2lib.env.event.distributor.EventDistributorControl;

/**
 * {@code EventDistributorControlFactory} is a factory to create implementations
 * of {@link EventDistributorControl}
 *
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.env.event.distributor.EventDistributorControlFactory extends BasicInterface {
	
	/**
	 * Creates a new instance of {@code EventDistributorControl}
	 * 
	 * @param type Type of the generated {@code EventDistributorControl}
	 * @return Implementation of {@code EventDistributorControl} with the specific type.
	 */
	public function createEventDistributorControl(type:Function):EventDistributorControl;
}