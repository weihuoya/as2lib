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

/**
 * This file works as list of all existing Testcases.
 * If you compile the 'test.fla' (in the same directory) it will
 * access this file and all testcases that are listed here will
 * be executed. Simple add your test to get it executed.
 */

// Data Holder tests
org.as2lib.data.holder.array.TArrayIterator;
org.as2lib.data.holder.array.TTypedArray;
//org.as2lib.data.holder.list.TPriorityList;
org.as2lib.data.holder.list.TArrayList;
org.as2lib.data.holder.TProtectedIterator;
org.as2lib.data.holder.map.TValueMapIterator;
org.as2lib.data.holder.map.THashMap;
//org.as2lib.data.holder.map.TPriorityMap;
org.as2lib.data.holder.map.TTypedMap;
org.as2lib.data.holder.map.TPrimitiveTypeMap;
org.as2lib.data.holder.stack.TSimpleStack;
org.as2lib.data.holder.stack.TTypedStack;
org.as2lib.data.holder.queue.TLinearQueue;
org.as2lib.data.holder.queue.TTypedQueue;

// Data Type Tests
org.as2lib.data.type.TInteger;
org.as2lib.data.type.TDegree;
org.as2lib.data.type.TRadian;
org.as2lib.data.type.TNaturalNumber;
org.as2lib.data.type.TNaturalNumberIncludingZero;

// File tests
org.as2lib.io.file.TFile;
org.as2lib.io.file.TBitAndByteFormat;

// org.as2lib.env.overload
org.as2lib.env.overload.TOverload;
org.as2lib.env.overload.TSimpleOverloadHandler;

// Util tests
org.as2lib.util.TArrayUtil;
org.as2lib.util.TObjectUtil;
org.as2lib.util.TStringUtil;
org.as2lib.util.TCall;
org.as2lib.util.TClassUtil;
org.as2lib.util.TStopWatch;
org.as2lib.util.TObjectUtil;
org.as2lib.util.TArrayUtil;
org.as2lib.util.TMathUtil;

// org.as2lib.test.mock
org.as2lib.test.mock.TMethodCall;
org.as2lib.test.mock.TMethodResponse;
org.as2lib.test.mock.TMethodCallRange;

// org.as2lib.test.mock.support
org.as2lib.test.mock.support.TRecordState;
org.as2lib.test.mock.support.TReplayState;
org.as2lib.test.mock.support.TDefaultMethodBehavior;
org.as2lib.test.mock.support.TDefaultBehavior;

// org.as2lib.aop.pointcut
org.as2lib.aop.pointcut.TKindedPointcut;
org.as2lib.aop.pointcut.TAndCompositePointcut;
org.as2lib.aop.pointcut.TOrCompositePointcut;
org.as2lib.aop.pointcut.TDynamicPointcutFactory;

// org.as2lib.aop.joinpoint
org.as2lib.aop.joinpoint.TMethodJoinPoint;
org.as2lib.aop.joinpoint.TPropertyJoinPoint;
org.as2lib.aop.joinpoint.TGetPropertyJoinPoint;
org.as2lib.aop.joinpoint.TSetPropertyJoinPoint;

// org.as2lib.aop.matcher
org.as2lib.aop.matcher.TDefaultMatcher;

// org.as2lib.io.conn.local.server
org.as2lib.io.conn.local.server.TLocalServer;
org.as2lib.io.conn.local.server.TLocalServerRegistry;
org.as2lib.io.conn.local.server.TLocalServerServiceProxy;

// org.as2lib.io.conn.local.client
org.as2lib.io.conn.local.client.TLocalClientServiceProxy;
org.as2lib.io.conn.local.client.TLocalClientServiceProxyFactory;

// org.as2lib.env.reflect
org.as2lib.env.reflect.TSimpleCache;
org.as2lib.env.reflect.TClassInfo;
org.as2lib.env.reflect.TPackageInfo;
org.as2lib.env.reflect.TResolveProxyFactory;

// org.as2lib.env.reflect.algorithm
org.as2lib.env.reflect.algorithm.TClassAlgorithm;
org.as2lib.env.reflect.algorithm.TPackageAlgorithm;
org.as2lib.env.reflect.algorithm.TChildAlgorithm;
org.as2lib.env.reflect.algorithm.TMethodAlgorithm;
org.as2lib.env.reflect.algorithm.TPropertyAlgorithm;

// org.as2lib.env.log
org.as2lib.env.log.logger.TSimpleLogger;
org.as2lib.env.log.repository.TLoggerHierarchy;
org.as2lib.env.log.level.TDynamicLogLevel;

// org.as2lib.env.bean
org.as2lib.env.bean.TMutablePropertyValueSet;
org.as2lib.env.bean.TPropertyValue;
org.as2lib.env.bean.TSimpleBeanWrapper;

// org.as2lib.env.bean.factory.support
org.as2lib.env.bean.factory.support.TDefaultBeanFactory;
org.as2lib.env.bean.factory.support.TRootBeanDefinition;

// org.as2lib.env.event
org.as2lib.env.event.TSpeedEventBroadcaster;
org.as2lib.env.event.TSimpleEventBroadcaster;
 
// org.as2lib.env.except
// - TODO some problem with TIllegalStateException and TUnsupportedOperationException exceeds 256 levels of recursion -
org.as2lib.env.except.TException;
org.as2lib.env.except.TFatalException;
org.as2lib.env.except.TStackTraceElement;
org.as2lib.env.except.TIllegalArgumentException;
/*org.as2lib.env.except.TIllegalStateException;
org.as2lib.env.except.TUnsupportedOperationException;*/