/**
* This is a sample class. It's only purpose is to show how Classes for as2lib should be written. 
* 
* @author						Michael Herrmann
* @date							1/11/04
* @version						1.0
* @since						1.0
* 
*/

class SampleClass {
	/**
	* Fields should be at the top of the class's body and should never be public. 
	* Even if you want a field to be fully change-, and gettable from the outside provide getters and setters.
	* Always specify a field's type, if specifiying the type is hard, use a more general type(a superclass for instance).
	*/
	
	/**The field "anyNumber" can hold any Number*/
	private var _anyNumber:Number;
	
	/**The field "numberGreaterOne" can hold any Number greater than 1*/
	private var _numberGreaterOne:Number;
	
	/**
	* The constructor follows after the fields. In this example it only sets anyNumber and numberGreaterOne.
	*
	* @param anyNumber			The desired value of anyNumber
	* @param numberGreaterOne	The desired value of numberGreaterOne
	*/
	public function SampleClass(anyNumber:Number, numberGreaterOne:Number) {
		this.anyNumber = anyNumber;
		this.numberGreaterOne = numberGreaterOne;
	}
	
	/**
	* Getter/Setter methods follow after the constructor.
	*/
	
	/**
	* Sets anyNumber to the given value.
	* 
	* @param anyNumber			The new value of anyNumber
	*/
	public function set anyNumber(anyNumber:Number):Void {
		this._anyNumber = anyNumber;
	}
	
	/**
	* Returns the value of anyNumber.
	* 
	* @return					The value of anyNumber
	*/
	public function get anyNumber():Number {
		return this._anyNumber;
	}
	
	/**
	* Sets numberGreaterOne to the given value. If the given value is <1, a SampleException is thrown.
	* 
	* @param numberGreaterOne	The new value of numberGreaterOne
	*
	* @throws					SampleException if the given value is <1
	* 
	* @see						SampleException
	*/
	public function set numberGreaterOne(numberGreaterOne:Number):Void {
		if(numberGreaterOne>1) {
			this._numberGreaterOne = numberGreaterOne;
		} else {
			throw new SampleException("Illegally Trying to set numberGreaterOne to a value <1", arguments);
		}
	}
	
	/**
	* Returns the value of numberGreaterOne.
	* 
	* @return					The value of numberGreaterOne
	*/
	public function get numberGreaterOne():Number {
		return this._numberGreaterOne;
	}
	
	/**
	* Every method but the constructor and getter/setter methods follows after the last mentioned. 
	*/
	
	/**
	* Returns the result of the multiplication of anyNumber with numberGreaterOne.
	* 
	* @return					The result of the multiplication of anyNumber with numberGreaterOne.
	*/
	public function multiplyNumbers():Number {
		return this.numberGreaterOne*this.anyNumber;
	}
	
	/**
	* Returns the result of the addition of anyNumber and numberGreaterOne.
	* 
	* @return					The result of the addition of anyNumber and numberGreaterOne.
	*/
	public function sumOfNumbers():Number {
		return this.numberGreaterOne+this.anyNumber;
	}
}