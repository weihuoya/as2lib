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

import org.as2lib.app.conf.AbstractConfiguration;
import org.as2lib.app.conf.TestExecution;

/**
 * Basic Configuration of the Application.
 * This class is a basic configuration class for the TestApplication.
 * It contains the references to all Testcases and the start of the execution.
 * 
 * @author Martin Heidegger.
 */
class main.Configuration extends AbstractConfiguration {

    public static function init(Void):Void {
		initProcess(new TestExecution());
    }
    
	private function setReferences(Void):Void {
		// Execution Tests
		//use(org.as2lib.app.exec.TTimeout);
		
		// Data Holder tests
		use(org.as2lib.data.holder.array.TArrayIterator);
		use(org.as2lib.data.holder.array.TTypedArray);
		//use(org.as2lib.data.holder.list.TPriorityList);
		use(org.as2lib.data.holder.list.TArrayList);
		use(org.as2lib.data.holder.TProtectedIterator);
		use(org.as2lib.data.holder.map.TValueMapIterator);
		use(org.as2lib.data.holder.map.THashMap);
		//use(org.as2lib.data.holder.map.TPriorityMap);
		use(org.as2lib.data.holder.map.TTypedMap);
		use(org.as2lib.data.holder.map.TPrimitiveTypeMap);
		use(org.as2lib.data.holder.stack.TSimpleStack);
		use(org.as2lib.data.holder.stack.TTypedStack);
		use(org.as2lib.data.holder.queue.TLinearQueue);
		use(org.as2lib.data.holder.queue.TTypedQueue);
		
		// Data Type Tests
		use(org.as2lib.data.type.TInteger);
		use(org.as2lib.data.type.TDegree);
		use(org.as2lib.data.type.TRadian);
		use(org.as2lib.data.type.TNaturalNumber);
		use(org.as2lib.data.type.TNaturalNumberIncludingZero);
		
		
		// File tests
		//use(org.as2lib.io.file.TFile);
		//use(org.as2lib.io.file.TBitAndByteFormat);
		
		// Util tests
		use(org.as2lib.util.TArrayUtil);
		use(org.as2lib.util.TObjectUtil);
		use(org.as2lib.util.TStringUtil);
		use(org.as2lib.util.TCall);
		use(org.as2lib.util.TClassUtil);
		use(org.as2lib.util.TStopWatch);
		use(org.as2lib.util.TObjectUtil);
		use(org.as2lib.util.TArrayUtil);
		use(org.as2lib.util.TMathUtil);
		use(org.as2lib.util.TAccessPermission);
		use(org.as2lib.util.TDateFormatter);
		
		// org.as2lib.test.mock
		use(org.as2lib.test.mock.TMethodCall);
		use(org.as2lib.test.mock.TMethodResponse);
		use(org.as2lib.test.mock.TMethodCallRange);
		
		// org.as2lib.test.mock.support
		use(org.as2lib.test.mock.support.TRecordState);
		use(org.as2lib.test.mock.support.TReplayState);
		use(org.as2lib.test.mock.support.TDefaultMethodBehavior);
		use(org.as2lib.test.mock.support.TDefaultBehavior);
		use(org.as2lib.test.mock.support.TDefaultArgumentsMatcher);
		
		// org.as2lib.aop.pointcut
		//use(org.as2lib.aop.pointcut.TKindedPointcut);
		//use(org.as2lib.aop.pointcut.TAndCompositePointcut);
		//use(org.as2lib.aop.pointcut.TOrCompositePointcut);
		//use(org.as2lib.aop.pointcut.TDynamicPointcutFactory);
		
		// org.as2lib.aop.joinpoint
		//use(org.as2lib.aop.joinpoint.TMethodJoinPoint);
		//use(org.as2lib.aop.joinpoint.TPropertyJoinPoint);
		//use(org.as2lib.aop.joinpoint.TGetPropertyJoinPoint);
		//use(org.as2lib.aop.joinpoint.TSetPropertyJoinPoint);
		
		// org.as2lib.aop.matcher
		use(org.as2lib.aop.matcher.TDefaultMatcher);
		
		// org.as2lib.io.conn.local.server
		use(org.as2lib.io.conn.local.server.TLocalServer);
		use(org.as2lib.io.conn.local.server.TLocalServerRegistry);
		use(org.as2lib.io.conn.local.server.TLocalServerServiceProxy);
		
		// org.as2lib.io.conn.local.client
		use(org.as2lib.io.conn.local.client.TLocalClientServiceProxy);
		use(org.as2lib.io.conn.local.client.TLocalClientServiceProxyFactory);
		
		// org.as2lib.env.overload
		use(org.as2lib.env.overload.TOverload);
		use(org.as2lib.env.overload.TSimpleOverloadHandler);
		
		// org.as2lib.env.reflect
		use(org.as2lib.env.reflect.TSimpleCache);
		// player breaks when you run TClassInfo test together with tests until org.as2lib.env.log
		use(org.as2lib.env.reflect.TClassInfo);
		use(org.as2lib.env.reflect.TClassInfo_Method);
		use(org.as2lib.env.reflect.TClassInfo_Property);
		use(org.as2lib.env.reflect.TPackageInfo);
		use(org.as2lib.env.reflect.TPackageInfo_Class);
		use(org.as2lib.env.reflect.TPackageInfo_Package);
		use(org.as2lib.env.reflect.TTypeProxyFactory);
		
		// org.as2lib.env.reflect.algorithm
		use(org.as2lib.env.reflect.algorithm.TClassAlgorithm);
		use(org.as2lib.env.reflect.algorithm.TPackageAlgorithm);
		use(org.as2lib.env.reflect.algorithm.TPackageMemberAlgorithm);
		use(org.as2lib.env.reflect.algorithm.TMethodAlgorithm);
		use(org.as2lib.env.reflect.algorithm.TPropertyAlgorithm);
		
		// org.as2lib.env.log
		use(org.as2lib.env.log.logger.TSimpleLogger);
		use(org.as2lib.env.log.logger.TSimpleHierarchicalLogger);
		use(org.as2lib.env.log.repository.TLoggerHierarchy);
		use(org.as2lib.env.log.level.TDynamicLogLevel);
		use(org.as2lib.env.log.handler.TLevelFilterHandler);
		
		// org.as2lib.env.event
		use(org.as2lib.env.event.TSimpleEventListenerSource);
		use(org.as2lib.env.event.TTypeSafeEventListenerSource);
		
		// org.as2lib.env.event.broadcaster
		use(org.as2lib.env.event.broadcaster.TSpeedEventBroadcaster);
		use(org.as2lib.env.event.broadcaster.TSimpleConsumableEventBroadcaster);
		
		// org.as2lib.env.event.multicaster
		use(org.as2lib.env.event.multicaster.TSimpleEventMulticaster);
		use(org.as2lib.env.event.multicaster.TSimpleConsumableEventMulticaster);
		
		// org.as2lib.env.event.distributor
		use(org.as2lib.env.event.distributor.TSimpleEventDistributorControl);
		use(org.as2lib.env.event.distributor.TSimpleConsumableEventDistributorControl);
		 
		// org.as2lib.env.except
		// - TODO some problem with TIllegalStateException and TUnsupportedOperationException exceeds 256 levels of recursion -
		use(org.as2lib.env.except.TException);
		use(org.as2lib.env.except.TFatalException);
		use(org.as2lib.env.except.TStackTraceElement);
		use(org.as2lib.env.except.TIllegalArgumentException);
		use(org.as2lib.env.except.TIllegalStateException);
		use(org.as2lib.env.except.TUnsupportedOperationException);
		
		// org.as2lib.env.bean
		//use(org.as2lib.env.bean.TMutablePropertyValueSet);
		//use(org.as2lib.env.bean.TPropertyValue);
		//use(org.as2lib.env.bean.TSimpleBeanWrapper);
		
		// org.as2lib.env.bean.factory.support
		//use(org.as2lib.env.bean.factory.support.TDefaultBeanFactory);
		//use(org.as2lib.env.bean.factory.support.TRootBeanDefinition);
	}
	
}