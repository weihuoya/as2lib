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

import org.as2lib.bean.factory.parser.XmlBeanDefinitionParser;
import org.as2lib.context.support.GenericApplicationContext;
import org.as2lib.core.BasicClass;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.log.parser.XmlLogConfigurationParser;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.XmlFile;
import org.as2lib.io.file.XmlFileLoader;
import org.as2lib.sample.filebrowser.FileBrowser;
import org.as2lib.util.StringUtil;

/**
 * @author Simon Wacker
 */
class main.Configuration extends BasicClass implements LoadErrorListener, LoadCompleteListener {
	
	private static var logger:Logger = LogManager.getLogger("main.Configuration");
	
	private static var LOG_CONFIGURATION:String = "logging.xml";
	private static var APPLICATION_CONTEXT:String = "applicationContext.xml";
	
	private var applicationContext:GenericApplicationContext;
	private var beanDefinitionParser:XmlBeanDefinitionParser;
	private var logConfigurationParser:XmlLogConfigurationParser;
	
	public function Configuration(Void) {
		applicationContext = new GenericApplicationContext();
		logConfigurationParser = new XmlLogConfigurationParser();
		beanDefinitionParser = new XmlBeanDefinitionParser();
	}
	
	public function init(Void):Void {
		// TODO: Composite file loader that handles multiple loaders by priority.
		var logConfigurationLoader:FileLoader = new XmlFileLoader();
		logConfigurationLoader.addListener(this);
		logConfigurationLoader.load(LOG_CONFIGURATION);
		var applicationContextLoader:FileLoader = new XmlFileLoader();
		applicationContextLoader.addListener(this);
		applicationContextLoader.load(APPLICATION_CONTEXT);
	}
	
	private function run(Void):Void {
		try {
			var fileBrowser:FileBrowser = applicationContext.getBean("fileBrowser");
			fileBrowser.browse("files.xml");
		}
		catch (exception:org.as2lib.bean.BeanException) {
			if (logger.isErrorEnabled()) {
				logger.error("Getting bean 'fileBrowser' failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
			}
		}
		catch (exception:org.as2lib.sample.filebrowser.FileBrowserException) {
			if (logger.isErrorEnabled()) {
				logger.error("Running file browser failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
			}
		}
		catch (exception:org.as2lib.env.except.Throwable) {
			if (logger.isFatalEnabled()) {
				logger.fatal("Running or getting file browser failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
			}
		}
	}
	
	public function onLoadComplete(fileLoader:FileLoader):Void {
		var xmlFile:XmlFile = XmlFile(fileLoader.getFile());
		if (fileLoader.getUri() == LOG_CONFIGURATION) {
			try {
				logConfigurationParser.parse(xmlFile.getContent());
			}
			catch (exception:org.as2lib.env.log.parser.LogConfigurationParseException) {
				if (logger.isErrorEnabled()) {
					logger.error("Parsing log configuration failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
				}
			}
		}
		if (fileLoader.getUri() == APPLICATION_CONTEXT) {
			try {
				beanDefinitionParser.parse(xmlFile.getContent(), applicationContext);
				applicationContext.refresh();
				run();
			}
			catch (exception:org.as2lib.env.except.Throwable) {
				if (logger.isErrorEnabled()) {
					logger.error("Parsing or initializing application context failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
				}
			}
		}
	}
	
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		if (logger.isErrorEnabled()) {
			logger.error("Loading file '" + fileLoader.getUri() + "' failed with error: " + errorCode + ".");
		}
		return false;
	}
	
}