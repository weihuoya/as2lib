﻿import org.as2lib.reflect.ClassInfo;

/**
 * Interface for each as2lib class.
 * This interface shows the basic Methods a class within the as2lib should have.
 * @see org.as2lib.basic.BasicClass
 */
interface org.as2lib.basic.BasicInterface {       
     /** 
      * Returns a ClassInformation generated by the acutal instance. 
      * @throws org.as2lib.reflect.ReferenceNotFoundException if no reference of the class was found. 
      */ 
     public function getClass(Void):ClassInfo; 
}