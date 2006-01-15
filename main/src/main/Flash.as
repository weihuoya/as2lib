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

import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.repository.LoggerHierarchy;

import main.Configuration;

/**
 * {@code Flash} is intended for configuration of applications compiled with Flash.
 * 
 * <p>All Flash specific configuration should be done in this class.
 * 
 * <p>This sample class uses a common configuration that suffices for small applications.
 * If you need another configuration override (not extend!) this class in the {@code main}
 * package in your application directory. The only method that must be declared to be
 * compatible is {@link #init}.
 * 
 * <p>Configuration that is the same for Flash, Flex and Mtasc is sourced-out into the
 * {@link Configuration} class.
 * 
 * @author Martin Heidegger
 * @author Simon Wacker
 * @version 2.0
 */
class main.Flash extends Configuration {
	
	/**
	 * Constructs a new {@code Flash} instance.
	 */
	public function Flash(Void) {
	}
	
	/**
	 * Configures and starts the application for Flash.
	 * 
	 * @see org.as2lib.app.conf.FlashApplication
	 */
	public function init(Void):Void {
		setUpLogging();
		super.init();
	}
	
	/**
	 * Sets up logging as common in the Flash environment using {@code trace}.
	 */
	private function setUpLogging(Void):Void {
		var root:RootLogger = new RootLogger(AbstractLogLevel.ALL);
		root.addHandler(new TraceHandler());
		LogManager.setLoggerRepository(new LoggerHierarchy(root)); 
	}
	
}