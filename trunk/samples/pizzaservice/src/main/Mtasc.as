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
import org.as2lib.app.exec.BatchStartListener;
import org.as2lib.app.exec.BatchUpdateListener;
import org.as2lib.app.exec.NextProcessListener;
import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.context.support.AsWingApplicationContext;
import org.as2lib.context.support.LoadingApplicationContext;
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
class main.Mtasc extends BasicClass implements BatchStartListener, NextProcessListener,
		BatchUpdateListener, BatchErrorListener, BatchFinishListener {

	private static var logger:Logger = LogManager.getLogger("main.Mtasc");

	public static var LOG_CONFIGURATION_URI:String = "logging.xml";
	public static var APPLICATION_CONTEXT_URI:String = "applicationContext.xml";
	public static var ASWING_VIEW_URI:String = "aswing/View.xml";
	public static var ACTIONSTEP_VIEW_URI:String = "actionstep/View.xml";
	public static var ENFLASH_VIEW_URI:String = "enflash/View.xml";

	private var rootApplicationContext:XmlApplicationContext;
	private var childApplicationContext:LoadingApplicationContext;

	public function Mtasc(Void) {
		System.useCodepage = true;
	}

	public function init(Void):Void {
		Debug.write("Initializing.");
		var batchProcess:SimpleBatch = new SimpleBatch();
		batchProcess.addListener(this);
		var logConfigurationProcess:LogConfigurationProcess =
				new LogConfigurationProcess(LOG_CONFIGURATION_URI, new XmlLogConfigurationParser());
		rootApplicationContext = new XmlApplicationContext(APPLICATION_CONTEXT_URI);
		//childApplicationContext = new ActionStepApplicationContext(ACTIONSTEP_VIEW_URI, rootApplicationContext);
		childApplicationContext = new AsWingApplicationContext(ASWING_VIEW_URI, rootApplicationContext);
		//childApplicationContext = new EnFlashApplicationContext(ENFLASH_VIEW_URI, rootApplicationContext);
		batchProcess.addProcess(logConfigurationProcess);
		batchProcess.addProcess(rootApplicationContext);
		batchProcess.addProcess(childApplicationContext);
		batchProcess.start();
	}

	public function onBatchStart(batch:Batch):Void {
		Debug.write("Batch started.");
	}

	public function onNextProcess(batch:Batch):Void {
		Debug.write("Next process: " + batch.getCurrentProcess().getName());
	}

	public function onBatchUpdate(batch:Batch):Void {
		Debug.write("Batch percentage: " + batch.getPercentage());
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