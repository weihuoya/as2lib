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

import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.repository.LoggerHierarchy;

import main.Configuration;

/**
 * @author Simon Wacker
 */
class main.Flash extends Configuration {
	
	public function Flash(Void) {
	}
	
	public function init(movieClip:MovieClip):Void {
		setupLogging();
		super.init(movieClip);
	}
	
	private function setupLogging(Void):Void {
		var rootLogger:RootLogger = new RootLogger(RootLogger.ALL);
		rootLogger.addHandler(new TraceHandler());
		var hierarchy:LoggerHierarchy = new LoggerHierarchy(rootLogger);
		LogManager.setLoggerRepository(hierarchy); 
	}
	
}