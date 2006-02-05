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

import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceResolvable;
import org.as2lib.context.NoSuchMessageException;
import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.except.AbstractOperationException;
import org.as2lib.env.overload.Overload;
import org.as2lib.lang.Locale;
import org.as2lib.lang.LocaleManager;
import org.as2lib.lang.MessageFormat;

/**
 * @author Simon Wacker
 */
class org.as2lib.context.support.AbstractMessageSource extends BasicClass {
	
	private var parentMessageSource:MessageSource;
	
	private var useCodeAsDefaultMessage:Boolean;
	
	private var alwaysUseMessageFormat:Boolean;
	
	/**
	 * Cache to hold already generated MessageFormats per message.
	 * Used for passed-in default messages. MessageFormats for resolved
	 * codes are cached on a specific basis in subclasses.
	 */
	private var cachedMessageFormats:Map;
	
	/** This instance properly typed. */
	private var thiz:MessageSource;
	
	/**
	 * Constructs a new {@code AbstractMessageSource} instance.
	 */
	private function AbstractMessageSource(Void) {
		thiz = MessageSource(this);
		useCodeAsDefaultMessage = false;
		alwaysUseMessageFormat = false;
		cachedMessageFormats = new PrimitiveTypeMap();
	}
	
	public function setParentMessageSource(parentMessageSource:MessageSource):Void {
		this.parentMessageSource = parentMessageSource;
	}
	
	public function getParentMessageSource(Void):MessageSource {
		return parentMessageSource;
	}
	
	/**
	 * Set whether to use the message code as default message instead of
	 * throwing a NoSuchMessageException. Useful for development and debugging.
	 * Default is "false".
	 * <p>Note: In case of a MessageSourceResolvable with multiple codes
	 * (like a FieldError) and a MessageSource that has a parent MessageSource,
	 * do <i>not</i> activate "useCodeAsDefaultMessage" in the <i>parent</i>:
	 * Else, you'll get the first code returned as message by the parent,
	 * without attempts to check further codes.
	 * <p>To be able to work with "useCodeAsDefaultMessage" turned on in the parent,
	 * AbstractMessageSource and AbstractApplicationContext contain special checks
	 * to delegate to the internal <code>getMessageInternal</code> method if available.
	 * In general, it is recommended to just use "useCodeAsDefaultMessage" during
	 * development and not rely on it in production in the first place, though.
	 * @see #getMessage(String, Object[], Locale)
	 * @see #getMessageInternal
	 * @see org.springframework.validation.FieldError
	 */
	public function setUseCodeAsDefaultMessage(useCodeAsDefaultMessage:Boolean):Void {
		this.useCodeAsDefaultMessage = useCodeAsDefaultMessage;
	}
	
	/**
	 * Return whether to use the message code as default message instead of
	 * throwing a NoSuchMessageException. Useful for development and debugging.
	 * Default is "false".
	 * <p>Alternatively, consider overriding the <code>getDefaultMessage</code>
	 * method to return a custom fallback message for an unresolvable code.
	 * @see #getDefaultMessage(String)
	 */
	public function isUseCodeAsDefaultMessage(Void):Boolean {
		return useCodeAsDefaultMessage;
	}
	
	/**
	 * Set whether to always apply the MessageFormat rules, parsing even
	 * messages without arguments.
	 * <p>Default is "false": Messages without arguments are by default
	 * returned as-is, without parsing them through MessageFormat.
	 * Set this to "true" to enforce MessageFormat for all messages,
	 * expecting all message texts to be written with MessageFormat escaping.
	 * <p>For example, MessageFormat expects a single quote to be escaped
	 * as "''". If your message texts are all written with such escaping,
	 * even when not defining argument placeholders, you need to set this
	 * flag to "true". Else, only message texts with actual arguments
	 * are supposed to be written with MessageFormat escaping.
	 * @see java.text.MessageFormat
	 */
	public function setAlwaysUseMessageFormat(alwaysUseMessageFormat:Boolean):Void {
		this.alwaysUseMessageFormat = alwaysUseMessageFormat;
	}
	
	/**
	 * Return whether to always apply the MessageFormat rules, parsing even
	 * messages without arguments.
	 */
	public function isAlwaysUseMessageFormat(Void):Boolean {
		return alwaysUseMessageFormat;
	}
	
	public function getMessage():String {
		var o:Overload = new Overload(this);
		o.addHandler([MessageSourceResolvable], thiz.getMessageByResolvable);
		o.addHandler([MessageSourceResolvable, Locale], thiz.getMessageByResolvable);
		o.addHandler([String, Array], thiz.getMessageByCodeAndArguments);
		o.addHandler([String, Array, Locale], thiz.getMessageByCodeAndArguments);
		o.addHandler([String, Array, String], thiz.getMessageWithDefaultMessage);
		o.addHandler([String, Array, String, Locale], thiz.getMessageWithDefaultMessage);
		return o.forward(arguments);
	}
	
	public function getMessageWithDefaultMessage(code:String, args:Array, defaultMessage:String, locale:Locale):String {
		var message:String = getMessageInternal(code, args, locale);
		if (message != null) {
			return message;
		}
		if (defaultMessage == null) {
			var fallback:String = getDefaultMessage(code);
			if (fallback != null) {
				return fallback;
			}
		}
		return renderDefaultMessage(defaultMessage, args, locale);
	}
	
	public function getMessageByCodeAndArguments(code:String, args:Array, locale:Locale):String {
		var message:String = getMessageInternal(code, args, locale);
		if (message != null) {
			return message;
		}
		var fallback:String = getDefaultMessage(code);
		if (fallback != null) {
			return fallback;
		}
		throw new NoSuchMessageException(code, locale, this, arguments);
	}

	public function getMessageByResolvable(resolvable:MessageSourceResolvable, locale:Locale):String {
		var codes:Array = resolvable.getCodes();
		if (codes == null) {
			codes = new Array();
		}
		var arguments:Array = resolvable.getArguments();
		for (var i:Number = 0; i < codes.length; i++) {
			var message:String = getMessageInternal(codes[i], arguments, locale);
			if (message != null) {
				return message;
			}
		}
		if (resolvable.getDefaultMessage() != null) {
			return renderDefaultMessage(resolvable.getDefaultMessage(), arguments, locale);
		}
		if (codes.length > 0) {
			var fallback:String = getDefaultMessage(codes[0]);
			if (fallback != null) {
				return fallback;
			}
		}
		throw new NoSuchMessageException(codes.length > 0 ? codes[codes.length - 1] : null, locale, this, arguments);
	}
	
	/**
	 * Resolve the given code and arguments as message in the given Locale,
	 * returning null if not found. Does <i>not</i> fall back to the code
	 * as default message. Invoked by getMessage methods.
	 * @param code the code to lookup up, such as 'calculator.noRateSet'
	 * @param args array of arguments that will be filled in for params
	 * within the message
	 * @param locale the Locale in which to do the lookup
	 * @return the resolved message, or <code>null</code> if not found
	 * @see #getMessage(String, Object[], String, Locale)
	 * @see #getMessage(String, Object[], Locale)
	 * @see #getMessage(MessageSourceResolvable, Locale)
	 * @see #setUseCodeAsDefaultMessage
	 */
	private function getMessageInternal(code:String, args:Array, locale:Locale):String {
		if (code == null) {
			return null;
		}
		if (locale == null) {
			locale = LocaleManager.getInstance();
		}
		if (args == null || args.length == 0) {
			// Optimized resolution: no arguments to apply,
			// therefore no MessageFormat needs to be involved.
			// Note that the default implementation still uses MessageFormat;
			// this can be overridden in specific subclasses.
			var message:String = resolveCodeWithoutArguments(code, locale);
			if (message != null) {
				return message;
			}
		}
		else {
			var messageFormat:MessageFormat = resolveCode(code, locale);
			if (messageFormat != null) {
				return messageFormat.format(resolveArguments(args, locale));
			}
		}
		// Not found -> check parent, if any.
		return getMessageFromParent(code, args, locale);
	}
	
	/**
	 * Try to retrieve the given message from the parent MessageSource, if any.
	 * @param code the code to lookup up, such as 'calculator.noRateSet'
	 * @param args array of arguments that will be filled in for params
	 * within the message
	 * @param locale the Locale in which to do the lookup
	 * @return the resolved message, or <code>null</code> if not found
	 * @see #getParentMessageSource()
	 */
	private function getMessageFromParent(code:String, args:Array, locale:Locale):String {
		if (parentMessageSource != null) {
			if (parentMessageSource instanceof AbstractMessageSource) {
				// Call internal method to avoid getting the default code back
				// in case of "useCodeAsDefaultMessage" being activated.
				return AbstractMessageSource(parentMessageSource).getMessageInternal(code, args, locale);
			}
			else {
				// Check parent MessageSource, returning null if not found there.
				return parentMessageSource.getMessage(code, args, null, locale);
			}
		}
		return null;
	}
	
	/**
	 * Return a fallback default message for the given code, if any.
	 * <p>Default is to return the code itself if "useCodeAsDefaultMessage"
	 * is activated, or return no fallback else. In case of no fallback,
	 * the caller will usually receive a NoSuchMessageException from
	 * <code>getMessage</code>.
	 * @param code the message code that we couldn't resolve
	 * and that we didn't receive an explicit default message for
	 * @return the default message to use, or <code>null</code> if none
	 * @see #setUseCodeAsDefaultMessage
	 */
	private function getDefaultMessage(code:String):String {
		if (isUseCodeAsDefaultMessage()) {
			return code;
		}
		return null;
	}
	
	/**
	 * Render the given default message String. The default message is
	 * passed in as specified by the caller and can be rendered into
	 * a fully formatted default message shown to the user.
	 * <p>Default implementation passes the String to <code>formatMessage</code>,
	 * resolving any argument placeholders found in them. Subclasses may override
	 * this method to plug in custom processing of default messages.
	 * @param defaultMessage the passed-in default message String
	 * @param args array of arguments that will be filled in for params within
	 * the message, or <code>null</code> if none.
	 * @param locale the Locale used for formatting
	 * @return the rendered default message (with resolved arguments)
	 * @see #formatMessage(String, Object[], java.util.Locale)
	 */
	private function renderDefaultMessage(defaultMessage:String, args:Array, locale:Locale):String {
		return formatMessage(defaultMessage, args, locale);
	}
	
	/**
	 * Format the given message String, using cached MessageFormats.
	 * By default invoked for passed-in default messages, to resolve
	 * any argument placeholders found in them.
	 * @param msg the message to format
	 * @param args array of arguments that will be filled in for params within
	 * the message, or <code>null</code> if none.
	 * @param locale the Locale used for formatting
	 * @return the formatted message (with resolved arguments)
	 */
	private function formatMessage(message:String, args:Array, locale:Locale):String {
		if (message == null || (!alwaysUseMessageFormat && (args == null || args.length == 0))) {
			return message;
		}
		var messageFormat:MessageFormat = null;
		messageFormat = cachedMessageFormats.get(message);
		if (messageFormat == null) {
			messageFormat = createMessageFormat(message, locale);
			cachedMessageFormats.put(message, messageFormat);
		}
		return messageFormat.format(resolveArguments(args, locale));
	}
	
	/**
	 * Create a MessageFormat for the given message and Locale.
	 * <p>This implementation creates an empty MessageFormat first,
	 * populating it with Locale and pattern afterwards, to stay
	 * compatible with J2SE 1.3.
	 * @param msg the message to create a MessageFormat for
	 * @param locale the Locale to create a MessageFormat for
	 * @return the MessageFormat instance
	 */
	private function createMessageFormat(message:String, locale:Locale):MessageFormat {
		var messageFormat:MessageFormat = new MessageFormat();
		messageFormat.setLocale(locale);
		if (message != null) {
			messageFormat.applyPattern(message);
		}
		return messageFormat;
	}
	
	/**
	 * Search through the given array of objects, find any
	 * MessageSourceResolvable objects and resolve them.
	 * <p>Allows for messages to have MessageSourceResolvables as arguments.
	 * @param args array of arguments for a message
	 * @param locale the locale to resolve through
	 * @return an array of arguments with any MessageSourceResolvables resolved
	 */
	private function resolveArguments(args:Array, locale:Locale):Array {
		if (args == null) {
			return new Array();
		}
		var resolvedArgs:Array = new Array();
		for (var i:Number = 0; i < args.length; i++) {
			if (args[i] instanceof MessageSourceResolvable) {
				resolvedArgs.push(getMessageByResolvable(args[i], locale));
			}
			else {
				resolvedArgs.push(args[i]);
			}
		}
		return resolvedArgs;
	}
	
	/**
	 * Subclasses can override this method to resolve a message without
	 * arguments in an optimized fashion, i.e. to resolve a message
	 * without involving a MessageFormat.
	 * <p>The default implementation <i>does</i> use MessageFormat,
	 * through delegating to the <code>resolveCode</code> method.
	 * Subclasses are encouraged to replace this with optimized resolution.
	 * <p>Unfortunately, <code>java.text.MessageFormat</code> is not
	 * implemented in an efficient fashion. In particular, it does not
	 * detect that a message pattern doesn't contain argument placeholders
	 * in the first place. Therefore, it's advisable to circumvent
	 * MessageFormat completely for messages without arguments.
	 * @param code the code of the message to resolve
	 * @param locale the Locale to resolve the code for
	 * (subclasses are encouraged to support internationalization)
	 * @return the message String, or <code>null</code> if not found
	 * @see #resolveCode
	 * @see java.text.MessageFormat
	 */
	private function resolveCodeWithoutArguments(code:String, locale:Locale):String {
		var messageFormat:MessageFormat = resolveCode(code, locale);
		if (messageFormat != null) {
			return messageFormat.format();
		}
		return null;
	}
	
	/**
	 * Subclasses must implement this method to resolve a message.
	 * <p>Returns a MessageFormat instance rather than a message String,
	 * to allow for appropriate caching of MessageFormats in subclasses.
	 * <p><b>Subclasses are encouraged to provide optimized resolution
	 * for messages without arguments, not involving MessageFormat.</b>
	 * See <code>resolveCodeWithoutArguments</code> javadoc for details.
	 * @param code the code of the message to resolve
	 * @param locale the Locale to resolve the code for
	 * (subclasses are encouraged to support internationalization)
	 * @return the MessageFormat for the message, or <code>null</code> if not found
	 * @see #resolveCodeWithoutArguments(String, java.util.Locale)
	 */
	private function resolveCode(code:String, locale:Locale):MessageFormat {
		throw new AbstractOperationException("This method is marked as abstract and must be overridden by sub-classes.", this, arguments);
		return null;
	}
	
}