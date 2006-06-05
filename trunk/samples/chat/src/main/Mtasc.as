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
import org.as2lib.app.exec.NextProcessListener;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.bean.factory.parser.UiBeanDefinitionParser;
import org.as2lib.context.support.LoadingApplicationContext;
import org.as2lib.core.BasicClass;
import org.as2lib.sample.chat.Login;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class main.Mtasc extends BasicClass implements BatchStartListener,
		NextProcessListener, BatchErrorListener, BatchFinishListener {

	public static var APPLICATION_CONTEXT_URI:String = "applicationContext.xml";

	private var applicationContext:LoadingApplicationContext;

	public function Mtasc(Void) {
		System.useCodepage = true;
	}

	public function init(Void):Void {
		trace("Initializing.");
		var beanDefinitionParser:BeanDefinitionParser = new UiBeanDefinitionParser();
		applicationContext = new LoadingApplicationContext(
				APPLICATION_CONTEXT_URI, beanDefinitionParser);
		applicationContext.addListener(this);
		applicationContext.start();
	}

	public function onBatchStart(batch:Batch):Void {
		trace("Batch started.");
	}

	public function onNextProcess(batch:Batch):Void {
		trace("Next process: " + batch.getName());
	}

	public function onBatchError(batch:Batch, error):Boolean {
		trace("Batch failed:\n" + StringUtil.addSpaceIndent(error.toString(), 2));
		return false;
	}

	public function onBatchFinish(batch:Batch):Void {
		trace("Batch finished.");
		try {
			var login:Login = applicationContext.getBean("login");
			login.show();
		}
		catch (exception) {
			trace("Initializing chat failed with error:\n" +
					StringUtil.addSpaceIndent(exception.toString(), 2));
		}
	}

}