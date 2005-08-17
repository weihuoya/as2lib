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
import org.as2lib.env.event.distributor.EventDistributorControlFactory;
import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;

/**
 * {@code SimpleEventDistributorControlFactory} is a factory to create
 * instances of {@link SimpleEventDistributorControl}
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
class org.as2lib.env.event.distributor.SimpleEventDistributorControlFactory extends BasicClass implements EventDistributorControlFactory {
	
	/**
	 * Creates a new instance of {@code SimpleConsumableEventDistributorControl}
	 * 
	 * @param type Type for the new instance.
	 * @return instance of SimpleConsumableEventDistributorControl;
	 */
	public function createEventDistributorControl(type:Function):EventDistributorControl {
		return new SimpleEventDistributorControl(type);
	}
}