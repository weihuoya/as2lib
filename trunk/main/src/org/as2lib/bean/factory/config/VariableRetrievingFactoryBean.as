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

import org.as2lib.bean.factory.BeanNameAware;
import org.as2lib.bean.factory.FactoryBean;
import org.as2lib.bean.factory.InitializingBean;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.reflect.ClassNotFoundException;
import org.as2lib.util.TrimUtil;

/**
 * {@code VariableRetrievingFactoryBean} retrieves a static or non-static variable
 * value. Typically used for retrieving constants.
 * 
 * <p>Usage example:
 * <pre>
 *   // standard definition for exposing a static variable, specifying the "staticVariable" property
 *   &lt;bean id="myVariable" class="org.as2lib.bean.factory.config.VariableRetrievingFactoryBean"&gt;
 *     &lt;property name="staticVariable"&gt;&lt;value&gt;org.aswing.BoxLayout.Y_AXIS&lt;/value&gt;&lt;/property&gt;
 *   &lt;/bean&gt;
 *   
 *   // convenience version that specifies a static field pattern as bean name
 *   &lt;bean id="org.aswing.BoxLayout.Y_AXIS" class="org.as2lib.bean.factory.config.VariableRetrievingFactoryBean"/&gt;</pre>
 * </pre>
 * 
 * @author Simon Wacker
 */
class org.as2lib.bean.factory.config.VariableRetrievingFactoryBean extends BasicClass implements FactoryBean, BeanNameAware, InitializingBean {
	
	private var targetClass:Function;
	
	private var targetBean;
	
	private var targetVariable:String;
	
	private var staticVariable:String;
	
	private var beanName:String;
	
	private var resultType:Function;
	
	/**
	 * Constructs a new {@code VariableRetrievingFactoryBean} instance.
	 */
	public function VariableRetrievingFactoryBean(Void) {
	}
	
	/**
	 * Sets the target class on which the variable is defined. Only necessary when
	 * the target variable is static; else, a target bean needs to be specified anyway.
	 * 
	 * @param targetClass the target class on which the variable is defined
	 * @see #setTargetBean
	 * @see #setTargetVariable
	 */
	public function setTargetClass(targetClass:Function):Void {
		this.targetClass = targetClass;
	}
	
	/**
	 * Returns the target class on which the variable is defined.
	 * 
	 * @return the target class that defines the variable
	 */
	public function getTargetClass(Void):Function {
		return targetClass;
	}
	
	/**
	 * Sets the target bean on which the variable is defined. Only necessary when
	 * the target variable is not static; else, a target class is sufficient.
	 * 
	 * @param targetBean the target bean on which the variable is defined
	 * @see #setTargetClass
	 * @see #setTargetVariable
	 */
	public function setTargetBean(targetBean):Void {
		this.targetBean = targetBean;
	}
	
	/**
	 * Returns the target bean on which the variable is defined.
	 * 
	 * @return the target bean
	 */
	public function getTargetBean(Void) {
		return targetBean;
	}
	
	/**
	 * Sets the name of the variable to be retrieved. Refers to either a static
	 * variable or a non-static variable depending on whether a target bean is set.
	 * 
	 * @param targetVariable the name of the target variable
	 * @see #setTargetClass
	 * @see #setTargetBean
	 */
	public function setTargetVariable(targetVariable:String):Void {
		this.targetVariable = TrimUtil.trim(targetVariable);
	}
	
	/**
	 * Returns the name of the variable to be retrieved.
	 * 
	 * @return the name of the variable
	 */
	public function getTargetVariable(Void):String {
		return targetVariable;
	}
	
	/**
	 * Sets a fully qualified static variable name to retrieve, e.g.
	 * "example.MyExampleClass.MY_EXAMPLE_FIELD". Convenient alternative to specifying
	 * targetClass and targetVariable.
	 * 
	 * @param staticVariable the fully qualifed static variable name
	 * @see #setTargetClass
	 * @see #setTargetVariable
	 */
	public function setStaticVariable(staticVariable:String):Void {
		this.staticVariable = TrimUtil.trim(staticVariable);
	}
	
	/**
	 * Specifies the type of the result from evaluating the variable. The result type
	 * is needed if you need matching by type.
	 * 
	 * @param resultType the result type
	 */
	public function setResultType(resultType:Function):Void {
		this.resultType = resultType;
	}
	
	/**
	 * Sets the bean name of this bean. It will be interpreted as "staticVariable"
	 * pattern, if neither "targetClass" nor "targetBean" nor "targetVariable" have
	 * been specified. This allows for concise bean definitions with just an id/name.
	 * 
	 * @param beanName the name of this bean
	 */
	public function setBeanName(beanName:String):Void {
		this.beanName = beanName;
	}
	
	public function afterPropertiesSet(Void):Void {
		if (targetClass != null && targetBean != null) {
			throw new IllegalArgumentException("Specify either 'targetClass' or 'targetBean', not both.", this, arguments);
		}
		if (targetClass == null && targetBean == null) {
			if (targetVariable != null) {
				throw new IllegalArgumentException(
					"Specify 'targetClass' or 'targetBean' in combination with 'targetVariable'.", this, arguments);
			}
			// If no other property specified, consider bean name as static variable expression.
			if (staticVariable == null) {
				staticVariable = beanName;
			}
			// try to parse static variable into class and variable
			var lastDotIndex:Number = staticVariable.lastIndexOf(".");
			if (lastDotIndex == -1 || lastDotIndex == staticVariable.length) {
				throw new IllegalArgumentException(
						"'staticVariable' must be a fully qualified class plus method name: " +
						"e.g. 'example.MyExampleClass.MY_EXAMPLE_VARIABLE'", this, arguments);
			}
			var className:String = staticVariable.substring(0, lastDotIndex);
			var variableName:String = staticVariable.substring(lastDotIndex + 1);
			targetClass = eval("_global." + className);
			if (targetClass == null) {
				throw new ClassNotFoundException("Class with name '" + className + "' could not be found.", this, arguments);
			}
			targetVariable = variableName;
		}
		else if (targetVariable == null) {
			// either targetClass or targetObject specified
			throw new IllegalArgumentException("'targetVariable' is required.", this, arguments);
		}
		// TODO: Shall we check whether the variable on targetBean or targetClass is === undefined and throw an exception in that case? This may help to find errors more quickly, but it requires that variables are initialized with null.
	}
	
	public function getObject(Void) {
		if (targetBean != null) {
			// instance variable
			return targetBean[targetVariable];
		}
		else{
			// class variable
			return targetClass[targetVariable];
		}
	}
	
	public function getObjectType(Void):Function {
		return resultType;
	}
	
	public function isSingleton(Void):Boolean {
		return true;
	}
	
}