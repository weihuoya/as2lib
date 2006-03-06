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

import org.as2lib.app.exec.Batch;
import org.as2lib.app.exec.BatchErrorListener;
import org.as2lib.app.exec.BatchFinishListener;
import org.as2lib.app.exec.BatchProcess;
import org.as2lib.app.exec.BatchStartListener;
import org.as2lib.context.support.AsWingApplicationContext;
import org.as2lib.context.support.XmlApplicationContext;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.parser.LogConfigurationProcess;
import org.as2lib.env.log.parser.XmlLogConfigurationParser;
import org.as2lib.util.StringUtil;

import com.interactiveAlchemy.utils.Debug;

/**
 * @author Simon Wacker
 */
class main.Mtasc extends BasicClass implements BatchStartListener, BatchErrorListener, BatchFinishListener {
	
	private static var logger:Logger = LogManager.getLogger("main.Mtasc");
	
	public static var LOG_CONFIGURATION_URI:String = "logging.xml";
	public static var ROOT_APPLICATION_CONTEXT_URI:String = "applicationContext.xml";
	public static var ASWING_APPLICATION_CONTEXT_URI:String = "asWingContext.xml";
	
	private var rootApplicationContext:XmlApplicationContext;
	private var childApplicationContext:AsWingApplicationContext;
	
	public function Mtasc(Void) {
		System.useCodepage = true;
	}
	
	public function init(Void):Void {
		Debug.write("Initializing.");
		// TODO: Give every batch process a name. Use onBatchUpdate event to display name to user.
		var batchProcess:BatchProcess = new BatchProcess();
		batchProcess.addListener(this);
		var logConfigurationProcess:LogConfigurationProcess =
				new LogConfigurationProcess(LOG_CONFIGURATION_URI, new XmlLogConfigurationParser());
		rootApplicationContext = new XmlApplicationContext(ROOT_APPLICATION_CONTEXT_URI);
		childApplicationContext = new AsWingApplicationContext(ASWING_APPLICATION_CONTEXT_URI, rootApplicationContext);
		batchProcess.addProcess(logConfigurationProcess);
		batchProcess.addProcess(rootApplicationContext);
		batchProcess.addProcess(childApplicationContext);
		batchProcess.start();
	}
	
	public function onBatchStart(batch:Batch):Void {
		Debug.write("Batch started.");
	}
	
	public function onBatchError(batch:Batch, error):Boolean {
		Debug.write("Running batch process failed with error: \n" +
				StringUtil.addSpaceIndent(error.toString(), 2));
		return false;
	}
	
	public function onBatchFinish(batch:Batch):Void {
		if (logger.isDebugEnabled()) {
			logger.debug("Batch finished.");
		}
	}
	
}