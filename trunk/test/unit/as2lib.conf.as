//
//  IMPORTANT: If you don't use this config, the as2lib may not work as expected!
// 
//  - DESCRIPTION -
//  Some classes in the as2lib can be configured to change the performance,
//  functionality and/or filesize. It's recommended to your work with the as2lib
//  to use this (or a similar) configs.
//
//  - USAGE -
//  Simply include this config in your first frame (at best in a single frame) and
//  change the Settings below, each setting has a description. You can use different
//  Implementations of the interfaces for different functionality and settings.
// 

import org.as2lib.env.log.logger.SimpleHierarchicalLogger;
import org.as2lib.env.log.logger.TraceLogger;
import org.as2lib.env.log.logger.VoidLogger;
import org.as2lib.env.log.logger.RootLogger;
import org.as2lib.env.log.handler.TraceHandler;
import org.as2lib.env.log.level.AbstractLogLevel;
import org.as2lib.env.log.repository.LoggerHierarchy;
import org.as2lib.env.log.LogManager;
import org.as2lib.test.unit.LoggerTestListener;
import org.as2lib.test.unit.TestRunner;
import org.as2lib.test.unit.TestSuiteFactory;

//
//  - LOG SETTINGS -
//  The log system (org.as2lib.env.log) works for pretty much parts of the as2lib.
//  The settings allow you to define the loggers of the different patsh.
//
//  Available Loggers:
//    * SimpleLogger - Redirects the messages to a configurable LogHandler (maximum configurable)
//    * TraceLogger - Redirects the messages to the output console
//    * VoidLogger - Desmisses the messages
//
//  You can read more about logging in the documentation of
//    * org.as2lib.env.log.Logger
//    * org.as2lib.env.log.LogManager
//
  
  // Use a LoggerHierarchy as repository and takes a RootLogger with level All
  var loggerHierarchy:LoggerHierarchy = new LoggerHierarchy(new RootLogger(AbstractLogLevel.ALL));
  
  // Tell the Logger Repository to use the loggerHierarchy for default.
  LogManager.setLoggerRepository(loggerHierarchy); 
  
  var logger:SimpleHierarchicalLogger = new SimpleHierarchicalLogger("org.as2lib");
  logger.addHandler(new TraceHandler());
  
  // Log to trace console in org.as2lib package
  loggerHierarchy.addLogger(logger);
  
  // Example for your package
  /*
  loggerHierarchy.addLogger(new TraceLogger("com.mypackage"));
  */
  
  // Example for a output to a XMLSocket & the output console
  /*
  var myPackageLogger:SimpleLogger = new SimpleLogger("com.mypackage.xml.support");
  myPackageLogger.addHandler(new XmlSocketHandler());
  myPackageLogger.addHandler(TraceHandler.getInstance());
  loggerHierarchy.addLogger(myPackageLogger);
  */
  
  // Example to hide a package
  /*
  loggerHierarchy.addLogger(new VoidLogger("com.mypackage.package.to.hide"));
  */
  
  // Example for a restricted LogLevel
  /*
  var myPackageLogger2:TraceLogger = new TraceLogger("com.mypackage.debug.level");
  myPackageLogger2.setLevel(AbstractLogLevel.DEBUG);
  loggerHierarchy.addLogger(myPackageLogger2);
  */
//
//  - TESTSYSTEM -
//  To use the Testsystem you simple have to remove the commentblock around those
//  lines. Then add simply all of your testcases (without using import) at the end
//  of the file or in another imported file or in the .fla so that they get compiled
//  and all will get executed.
//
//  It is recommended to use a seperate .fla/directory for the testcases to seperate
//  them from the original source (so the original source can't get in conflict because
//  of the testcases).
//
//  The Testsystem supports to have more than one listeners for the output. By default
//  there is only a listener for a output to the defined logger available.
//

  // Testrunner to work with
  var testRunner:TestRunner = new TestRunner();
  
  // Redirects the finished testoutput to the default logger
  testRunner.addListener(new LoggerTestListener());
  
  // Execute all Testcases that are available at runtime
  testRunner.runTestSuite(new TestSuiteFactory().collectAllTestCases());