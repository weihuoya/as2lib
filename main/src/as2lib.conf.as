import org.as2lib.env.log.logger.SimpleLogger;
import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LoggerRepositoryManager;

var loggerHierarchy:LoggerHierarchy = new LoggerHierarchy(new SimpleLogger("root"));
var as2libLogger:SimpleLogger = new SimpleLogger("org.as2lib");
as2libLogger.addHandler(new TraceHandler());
loggerHierarchy.putLogger(as2libLogger);
LoggerRepositoryManager.setRepository(loggerHierarchy);