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
 
import org.as2lib.core.BasicClass;
import org.as2lib.util.StringUtil;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.log.LoggerRepository;
import org.as2lib.env.log.ConfigurableHierarchicalLogger;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.repository.ConfigurableHierarchicalLoggerFactory;
import org.as2lib.env.log.logger.SimpleLogger;

/**
 * @author Simon Wacker
 */
class org.as2lib.env.log.repository.LoggerHierarchy extends BasicClass implements LoggerRepository {
	
	/** Stores the root of the hierarchy. */
	private var root:ConfigurableHierarchicalLogger;
	
	/** Stores added loggers. */
	private var loggers:Map;
	
	/** This factory gets used when no custom factory is specified. */
	private var defaultFactory:ConfigurableHierarchicalLoggerFactory;
	
	/**
	 * Constructs a new instance.
	 *
	 * @param root the root of the hierarchy
	 */
	public function LoggerHierarchy(root:ConfigurableHierarchicalLogger) {
		this.root = root;
		loggers = new PrimitiveTypeMap();
		loggers.put(root.getName(), root);
	}
	
	
	/**
	 * Returns either the factory set via #setDefaultFactory() or the
	 * default one.
	 *
	 * @return the factory used as default
	 */
	public function getDefaultFactory(Void):ConfigurableHierarchicalLoggerFactory {
		if (!defaultFactory) defaultFactory = getNormalFactory();
		return defaultFactory;
	}
	
	/**
	 * @return the normal factory
	 */
	private function getNormalFactory(Void):ConfigurableHierarchicalLoggerFactory {
		var result:ConfigurableHierarchicalLoggerFactory = new ConfigurableHierarchicalLoggerFactory();
		result.getLogger = function(Void):ConfigurableHierarchicalLogger {
			return new SimpleLogger();
		}
		return result;
	}
	
	/**
	 * Sets the factory used when obtaining an out that has not been set
	 * before.
	 *
	 * @param defaultFactory the factory to be used as default
	 */
	public function setDefaultFactory(defaultFactory:ConfigurableHierarchicalLoggerFactory):Void {
		this.defaultFactory = defaultFactory;
	}
	
	/**
	 * Returns a logger depending on the specified name.
	 * The name can exist of a path as well as the actual specifier,
	 * e.g. org.as2lib.core.BasicClass. In case no logger instance has
	 * been put for the passed-in name a new will be created by the set
	 * factory, that by default obtains all its configuration from the
	 * parent.
	 *
	 * @param name the specifier of the logger to obtain
	 * @return a specific logger depending on the name
	 * @see LoggerRepository#getLogger()
	 */
	public function getLogger(name:String):Logger {
		return getLoggerByFactory(name, getDefaultFactory());
	}
	
	/**
	 * @return the root logger of the hierarchy
	 */
	public function getRootLogger(Void):Logger {
		return root;
	}
	
	/**
	 * Adds a new logger to the hierarchical repository. It will be
	 * automatically integrated into the hierarchy.
	 *
	 * @param name the name under which the logger to add shall be referenced
	 * @param logger the logger to be registered with the passed-in name
	 * @throws IllegalArgumentException if the given name is reserved
	 */
	public function putLogger(name:String, logger:ConfigurableHierarchicalLogger):Void {
		if (!logger) throw new IllegalArgumentException("Passed-in logger [" + logger + "] is not allowed to be null or undefined.", this, arguments);
		if (loggers.containsValue(name) && loggers.get(name) instanceof ConfigurableHierarchicalLogger)
			throw new IllegalArgumentException("Name [" + name + "] is already in use.", this, arguments);
		getLoggerByFactory(name, getSingletonFactory(logger));
	}
	
	/**
	 * Returns a factory used to obtain the passed-in logger.
	 *
	 * @param logger that shall be returned when asked for
	 * @return a factory that returns the passed-in logger
	 */
	private function getSingletonFactory(logger:ConfigurableHierarchicalLogger):ConfigurableHierarchicalLoggerFactory {
		var result:ConfigurableHierarchicalLoggerFactory = new ConfigurableHierarchicalLoggerFactory();
		result.getLogger = function(Void):ConfigurableHierarchicalLogger {
			return logger;
		}
		return result;
	}
	
	/**
	 * Does the same as the #getLogger() method but uses the explicitely passed-in
	 * factory to obtain the appropriate logger if necessary.
	 *
	 * @see #getOut()
	 */
	public function getLoggerByFactory(name:String, factory:ConfigurableHierarchicalLoggerFactory):Logger {
		var result = loggers.get(name);
		if (!result) {
			result = factory.getLogger();
			result.setName(name);
			loggers.put(name, result);
			updateParents(result);
		} else if (result instanceof Array) {
			var children:Array = result;
			result = factory.getLogger();
			result.setName(name);
			loggers.put(name, result);
			updateChildren(children, result);
			updateParents(result);
		}
		return result;
	}
	
	/**
	 * Updates the affected parents.
	 *
	 * @param logger the newly added logger
	 */
	private function updateParents(logger:ConfigurableHierarchicalLogger):Void {
		var name:String = logger.getName();
		var parentFound:Boolean = false;
		var length:Number = name.length;
		for (var i:Number = name.lastIndexOf(".", length-1); i >= 0; i = name.lastIndexOf(".", i-1)) {
			var substring:String = name.substring(0, i);
			var object = loggers.get(substring);
			if (!object) {
				loggers.put(substring, [logger]);
			} else if (object instanceof Logger) {
				parentFound = true;
				logger.setParent(object);
				break;
			} else if (object instanceof Array) {
				object.push(logger);
			} else {
				throw new IllegalStateException("Obtained object [" + object + "] is of an unexpected type.", this, arguments);
			}
		}
		if (!parentFound) logger.setParent(root);
	}
	
	/**
	 * Updates the affected children of the node.
	 *
	 * @param array contains the children to update
	 * @param logger the logger that now replaces the node
	 */
	private function updateChildren(children:Array, logger:ConfigurableHierarchicalLogger):Void {
		var length:Number = children.length;
		for (var i:Number = 0; i < length; i++) {
			var child:ConfigurableHierarchicalLogger = children[i];
			if (!StringUtil.startsWith(child.getParent().getName(), logger.getName())) {
				logger.setParent(child.getParent());
				child.setParent(logger);
			}
		}
	}
	
}