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
import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.bean.factory.parser.UiBeanDefinitionParser;
import org.as2lib.context.support.LoadingApplicationContext;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.parser.LogConfigurationProcess;
import org.as2lib.env.log.parser.XmlLogConfigurationParser;
import org.as2lib.sample.filebrowser.FileBrowser;
import org.as2lib.test.speed.TestSuite;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class main.Configuration extends BasicClass implements BatchStartListener, BatchErrorListener, BatchFinishListener {

	private static var LOG_CONFIGURATION_URI:String = "logging.xml";
	private static var APPLICATION_CONTEXT_URI:String = "applicationContext.xml";

	private var applicationContext:LoadingApplicationContext;
	private var logConfigurationProcess:LogConfigurationProcess;
	private var logConfigurationParser:XmlLogConfigurationParser;

	private var testSuite:TestSuite;

	public function Configuration(Void) {
		applicationContext = new LoadingApplicationContext(APPLICATION_CONTEXT_URI, new UiBeanDefinitionParser());
		logConfigurationParser = new XmlLogConfigurationParser();
		logConfigurationProcess = new LogConfigurationProcess(LOG_CONFIGURATION_URI, logConfigurationParser);
	}

	public function init(Void):Void {
		var batch:SimpleBatch = new SimpleBatch();
		batch.addListener(this);
		batch.addProcess(logConfigurationProcess);
		batch.addProcess(applicationContext);
		batch.start();
	}

	public function onBatchStart(batch:Batch):Void {
		trace("Batch started.");
	}

	public function onBatchError(batch:Batch, error):Boolean {
		trace("Running batch failed with error: \n" + StringUtil.addSpaceIndent(error.toString(), 2));
		return false;
	}

	public function onBatchFinish(batch:Batch):Void {
		trace("Batch finished.");
		try {
			var fileBrowser:FileBrowser = applicationContext.getBean("fileBrowser");
			fileBrowser.browse("files.xml");
		}
		catch (exception:org.as2lib.env.except.Throwable) {
			trace("Running or getting file browser failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
		}
	}

}