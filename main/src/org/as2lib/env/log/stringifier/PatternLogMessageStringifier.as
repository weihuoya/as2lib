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
import org.as2lib.util.Stringifier;
import org.as2lib.lang.DateFormat;
import org.as2lib.env.log.LogMessage;
import org.as2lib.env.log.LogLevel;

/**
 * {@code PatternLogMessageStringifier} stringifies {@link LogMessage} instances
 * based on configuration and a pattern.
 * 
 * @author Simon Wacker
 */
class org.as2lib.env.log.stringifier.PatternLogMessageStringifier extends BasicClass implements Stringifier {
    
    /** Determines whether to show the level. */
    private var showLevel:Boolean;
    
    /** Determines whether to show the name of the logger. */
    private var showLoggerName:Boolean;
    
    /** The time formatter to format the time stamp if desired. */
    private var timeFormat:DateFormat;
    
    /** Determines whether to show the source method name. */
    private var showSourceMethodName:Boolean;
    
    /**
     * Constructs a new {@code PatternLogMessageStringifier} instance.
     *
     * <p>Level, logger name and source method name are shown by default.
     * 
     * <p>If {@code timeFormat} is not passed-in or is {@code null} the date-time is not
     * shown in the log message.
     * 
     * @param showLevel determines whether to show levels in the string representation
     * @param shoLoggerName determines whether to show the logger name in the string
     * representation
     * @param timeFormat (optional) the time format pattern used to format the time
     * stamp
     * @param showSourceMethodName determines whether to show the source method name
     * @see org.as2lib.util.DateFormatter
     */
    public function PatternLogMessageStringifier(showLevel:Boolean, showLoggerName:Boolean, timeFormat:String, showSourceMethodName:Boolean) {
        this.showLevel = showLevel == null ? true : showLevel;
        this.showLoggerName = showLoggerName == null ? true : showLoggerName;
        if (timeFormat != null) this.timeFormat = new DateFormat(timeFormat);
        this.showSourceMethodName = showSourceMethodName == null ? true : showSourceMethodName;
    }
    
    /**
     * Returns the string representation of the passed-in {@link LogMessage} instance.
     *
     * <p>The returned string is composed as follows:
     * <pre>
     *   theTime  theLogLevel  theLoggerName.theSourceMethodName - theMessage
     * </pre>
     *
     * <p>Depending on your custom settings, which information to show and which not, a
     * few parts may be left out.
     *
     * @param target the {@code LogMessage} instance to stringify
     * @return the string representation of the passed-in {@code target}
     */
    public function execute(target):String {
        var message:LogMessage = target;
        var info:String = "";
        if (timeFormat) {
            var timeStamp:Number = message.getTimeStamp();
            if (timeStamp != null) {
                info += timeFormat.format(new Date(timeStamp));
            }
        }
        if (showLevel) {
            var level:LogLevel = message.getLevel();
            if (level) {
                if (info != "") info += "  ";
                info += level.toString();
            }
        }
        if (showLoggerName) {
            var name:String = message.getLoggerName();
            if (name != null) {
                if (info != "") info += "  ";
                info += name;
            }
        }
        if (showSourceMethodName) {
            var name:String = message.getSourceMethodName();
            if (name != null) {
                if (info != "") {
                    if (showLoggerName && message.getLoggerName() != null) {
                        info += ".";
                    } else {
                        info += "  ";
                    }
                }
                info += name;
            }
        }
        if (info != "") info += " - ";
        return (info + message.getMessage());
    }
    
}