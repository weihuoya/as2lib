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
test.unit.org.as2lib.data.holder.array.TArrayIterator;
test.unit.org.as2lib.data.holder.array.TTypedArray;
test.unit.org.as2lib.data.holder.list.TPriorityList;
test.unit.org.as2lib.data.holder.list.TArrayList;
test.unit.org.as2lib.data.holder.TProtectedIterator;
test.unit.org.as2lib.data.holder.map.TValueMapIterator;
test.unit.org.as2lib.data.holder.map.THashMap;
test.unit.org.as2lib.data.holder.map.TPriorityMap;
test.unit.org.as2lib.data.holder.map.TTypedMap;
test.unit.org.as2lib.data.holder.map.TPrimitiveTypeMap;
test.unit.org.as2lib.data.holder.stack.TSimpleStack;
test.unit.org.as2lib.data.holder.stack.TTypedStack;
test.unit.org.as2lib.data.holder.queue.TLinearQueue;
test.unit.org.as2lib.data.holder.queue.TTypedQueue;

// Data Type Tests
/*test.unit.org.as2lib.data.type.TInteger;
test.unit.org.as2lib.data.type.TDegree;
test.unit.org.as2lib.data.type.TRadian;
test.unit.org.as2lib.data.type.TNaturalNumber;
test.unit.org.as2lib.data.type.TNaturalNumberIncludingZero;

// File tests
test.unit.org.as2lib.io.file.TFile;
test.unit.org.as2lib.io.file.TBitAndByteFormat;

// Environment tests
test.unit.org.as2lib.env.out.TOutImplementation;

// org.as2lib.env.overload
test.unit.org.as2lib.env.overload.TOverload;
test.unit.org.as2lib.env.overload.TSimpleOverloadHandler;

// Util tests
test.unit.org.as2lib.util.TArrayUtil;
test.unit.org.as2lib.util.TObjectUtil;
test.unit.org.as2lib.util.TStringUtil;
test.unit.org.as2lib.util.TCall;
test.unit.org.as2lib.util.TClassUtil;
test.unit.org.as2lib.util.TStopWatch;
test.unit.org.as2lib.util.TObjectUtil;
test.unit.org.as2lib.util.TArrayUtil;
test.unit.org.as2lib.util.TMathUtil;

// org.as2lib.test.mock
test.unit.org.as2lib.test.mock.TMethodCall;
test.unit.org.as2lib.test.mock.TMethodResponse;
test.unit.org.as2lib.test.mock.TMethodCallRange;

// org.as2lib.test.mock.support
test.unit.org.as2lib.test.mock.support.TRecordState;
test.unit.org.as2lib.test.mock.support.TReplayState;
test.unit.org.as2lib.test.mock.support.TDefaultMethodBehavior;
test.unit.org.as2lib.test.mock.support.TDefaultBehavior;

// org.as2lib.aop.pointcut
test.unit.org.as2lib.aop.pointcut.TKindedPointcut;
test.unit.org.as2lib.aop.pointcut.TAndCompositePointcut;
test.unit.org.as2lib.aop.pointcut.TOrCompositePointcut;
test.unit.org.as2lib.aop.pointcut.TDynamicPointcutFactory;

// org.as2lib.aop.joinpoint
test.unit.org.as2lib.aop.joinpoint.TMethodJoinPoint;
test.unit.org.as2lib.aop.joinpoint.TPropertyJoinPoint;
test.unit.org.as2lib.aop.joinpoint.TGetPropertyJoinPoint;
test.unit.org.as2lib.aop.joinpoint.TSetPropertyJoinPoint;

// org.as2lib.aop.matcher
test.unit.org.as2lib.aop.matcher.TDefaultMatcher;

// org.as2lib.io.conn.local.server
test.unit.org.as2lib.io.conn.local.server.TLocalServer;
test.unit.org.as2lib.io.conn.local.server.TLocalServerRegistry;
test.unit.org.as2lib.io.conn.local.server.TLocalServerServiceProxy;

// org.as2lib.io.conn.local.client
test.unit.org.as2lib.io.conn.local.client.TLocalClientServiceProxy;
test.unit.org.as2lib.io.conn.local.client.TLocalClientServiceProxyFactory;

// org.as2lib.env.reflect
test.unit.org.as2lib.env.reflect.TSimpleCache;
test.unit.org.as2lib.env.reflect.TClassInfo;
test.unit.org.as2lib.env.reflect.TPackageInfo;
test.unit.org.as2lib.env.reflect.TResolveProxyFactory;

// org.as2lib.env.reflect.algorithm
test.unit.org.as2lib.env.reflect.algorithm.TClassAlgorithm;
test.unit.org.as2lib.env.reflect.algorithm.TPackageAlgorithm;
test.unit.org.as2lib.env.reflect.algorithm.TChildAlgorithm;
test.unit.org.as2lib.env.reflect.algorithm.TMethodAlgorithm;
test.unit.org.as2lib.env.reflect.algorithm.TPropertyAlgorithm;

// org.as2lib.env.log
test.unit.org.as2lib.env.log.logger.TSimpleLogger;
test.unit.org.as2lib.env.log.repository.TLoggerHierarchy;
test.unit.org.as2lib.env.log.level.TDynamicLogLevel;

// org.as2lib.env.bean
test.unit.org.as2lib.env.bean.TMutablePropertyValueSet;
test.unit.org.as2lib.env.bean.TPropertyValue;
test.unit.org.as2lib.env.bean.TSimpleBeanWrapper;

// org.as2lib.env.bean.factory.support
test.unit.org.as2lib.env.bean.factory.support.TDefaultBeanFactory;
test.unit.org.as2lib.env.bean.factory.support.TRootBeanDefinition;

// org.as2lib.env.event
test.unit.org.as2lib.env.event.TSpeedEventBroadcaster;
test.unit.org.as2lib.env.event.TSimpleEventBroadcaster;

 
// org.as2lib.env.except
// - TODO some problem with TIllegalStateException and TUnsupportedOperationException exceeds 256 levels of recursion -
/*
test.unit.org.as2lib.env.except.TException;
test.unit.org.as2lib.env.except.TFatalException;
test.unit.org.as2lib.env.except.TSimpleStackTraceElement;
test.unit.org.as2lib.env.except.TIllegalStateException;
test.unit.org.as2lib.env.except.TUnsupportedOperationException;
test.unit.org.as2lib.env.except.TSimpleStackTraceElement;
test.unit.org.as2lib.env.except.TIllegalArgumentException;
*/
