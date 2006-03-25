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

import org.as2lib.app.exec.SimpleBatch;
import org.as2lib.bean.factory.parser.BeanDefinitionParser;
import org.as2lib.context.ApplicationContext;
import org.as2lib.context.support.DefaultApplicationContext;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.FileLoaderProcess;
import org.as2lib.io.file.TextFile;
import org.as2lib.io.file.TextFileLoader;

/**
 * {@code LoadingApplicationContext} loads a bean definition file and parses it. The
 * parsed ben definition file may not define its own {@code "batchProcess"} bean.
 * 
 * <p>Note that after the loaded bean definition file has been parsed, this context
 * will automatically add all {@link Process} beans to the batch process and start
 * it.
 * 
 * @author Simon Wacker
 * TODO: Enable multiple refreshes for this context!
 */
class org.as2lib.context.support.LoadingApplicationContext extends DefaultApplicationContext {
	
	/** The logger for this application context. */
	private static var logger:Logger = LogManager.getLogger("org.as2lib.context.support.LoadingApplicationContext");
	
	/** The uri to the bean definition file. */
	private var beanDefinitionUri:String;
	
	/** The bean definition parser to parse the loaded bean definitions with. */
	private var beanDefinitionParser:BeanDefinitionParser;
	
	/**
	 * Constructs a new {@code ProcessableApplicationContext} instance.
	 * 
	 * @param beanDefinitionUri the uri to the bean definition file to load the
	 * bean definitions to populate this application context with from
	 * @param beanDefitionParser the bean definition parser to use to parse the loaded
	 * bean definition file
	 * @param parent the parent of this application context
	 */
	public function LoadingApplicationContext(beanDefinitionUri:String, beanDefitionParser:BeanDefinitionParser, parent:ApplicationContext) {
		super(parent);
		// TODO: Add support for specifying multiple URIs for the same application context!
		this.beanDefinitionUri = beanDefinitionUri;
		this.beanDefinitionParser = beanDefitionParser;
		setBatchProcess(new SimpleBatch());
	}
	
	public function start() {
		initFileLoaderProcess();
		getBatchProcess().start();
	}
	
	/**
	 * Initializes the file loader process; creates and adds it to the batch process.
	 */
	private function initFileLoaderProcess(Void):Void {
		var fileLoader:FileLoader = new TextFileLoader();
		var fileLoaderProcess:FileLoaderProcess = new FileLoaderProcess(fileLoader);
		fileLoaderProcess.setUri(beanDefinitionUri);
		// TODO: Find a solution for the following ugly workaround.
		var owner:LoadingApplicationContext = this;
		fileLoaderProcess.onLoadComplete = function(fl:FileLoader):Void {
			try {
				owner["onLoadComplete"](fl);
			}
			catch (exception) {
				this.distributeErrorEvent(exception);
			}
			// finish the loading process after possible process beans have been added
			// otherwise the batch process distributes a finish event before possible
			// processes in the bean factory have been run
			// TODO: Shall onLoadComplete event even be published if an exception was thrown?
			this.__proto__.onLoadComplete.apply(this, [fl]);
		};
		getBatchProcess().addProcess(fileLoaderProcess);
	}
	
	/**
	 * Gets invoked when the bean definition file was successfully loaded.
	 * 
	 * <p>It parses the file loaded by the given file loader with the parser
	 * specified on construction and registers the {@link Process} beans with
	 * the batch process of this context, that is currently running.
	 * 
	 * @param fileLoader the file laoder that loaded the bean definition file
	 */
	private function onLoadComplete(fileLoader:FileLoader):Void {
		var textFile:TextFile = TextFileLoader(fileLoader).getTextFile();
		beanDefinitionParser.parse(textFile.getContent(), beanFactory);
		super.start();
	}
	
	/**
	 * Returns the uri to the bean definition file.
	 * 
	 * @return the uri to the bean definition file
	 */
	public function getBeanDefinitionUri(Void):String {
		return beanDefinitionUri;
	}
	
	/**
	 * Sets the uri of the bean definition file to load.
	 * 
	 * @param beanDefinitionUri the uri of the bean definition to load
	 */
	public function setBeanDefinitionUri(beanDefinitionUri:String):Void {
		this.beanDefinitionUri = beanDefinitionUri;
	}
	
	/**
	 * Returns the bean definition parser used to parse the loaded bean definition
	 * file.
	 * 
	 * @return the bean definition parser
	 */
	public function getBeanDefinitionParser(Void):BeanDefinitionParser {
		return beanDefinitionParser;
	}
	
	/**
	 * Sets the bean definition parser used to parse the loaded bean definition file.
	 * 
	 * @param beanDefinitionParser the bean definition parser
	 */
	public function setBeanDefinitionParser(beanDefinitionParser:BeanDefinitionParser):Void {
		this.beanDefinitionParser = beanDefinitionParser;
	}
	
}