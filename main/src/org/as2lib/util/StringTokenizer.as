/**
*
*	@project : as2Lib
* 	@file : StringTokenizer
*	@version : 2.2.1
*	@author : Yome - yomec@free.fr/ real.yome@wanadoo.fr
*	@date : 15/09/2003 - revised 11.03
*	@copyright : as2Lib
*
*/

// import lang.NullPointerException;
import org.as2lib.basic.exceptions.NoSuchElementException;

class org.as2lib.util.StringTokenizer
{

	/****************************************
	*
	*	Properties
	*
	*****************************************/

	static var className:String = "org.as2lib.util.StringTokenizer";

    private var _currentPosition:Number;
    private var _newPosition:Number;
    private var _maxPosition:Number;
    private var _str:String;
    private var _delimiters:String;
    private var _retDelims:Boolean;
    private var _delimsChanged:Boolean;
	private var _maxDelimChar:String;

	public var instanceName:String = "StringTokenizer";

	/****************************************
	*
	*	Constructor
	*
	*	@param str a string to be parsed
	*	@param delim the delimiters.
	*	@param returnDelims flag indicating whether to return the delimiters as tokens.
	*
	*****************************************/
	function StringTokenizer(str:String, delim:String, returnDelims:Boolean)
	{
		_currentPosition = 0;
		_newPosition = -1;
		_delimsChanged = false;
		_str = str;
		_maxPosition = _str.length;
		_delimiters = (null==delim || ""==delim) ? " \t\n\r\f" : delim;
		_retDelims = (true==returnDelims);
		_setMaxDelimChar();
	}

	/****************************************
	*
	*	Public Methods
	*
	*****************************************/
	/*
	* Tests if there are more tokens available from this tokenizer's string.
	* If this method returns true, then a subsequent call to nextToken with no argument will successfully return a token.
	*
	* @return true if and only if there is at least one token in the string after the current position; false otherwise.
	*
	*/
    public function hasMoreTokens():Boolean
	{
		_newPosition = _skipDelimiters(_currentPosition);
		return (_newPosition < _maxPosition);
    }

	/*
	* Returns the next token from this string tokenizer.
	*
	* @return the next token from this string tokenizer, as a String.
	*
	*/
    public function nextToken():String
	{
		_currentPosition = (_newPosition >= 0 && !_delimsChanged) ? _newPosition : _skipDelimiters(_currentPosition);
		_delimsChanged = false;
		_newPosition = -1;
		if (_currentPosition >= _maxPosition) throw new NoSuchElementException("There are no more elements in the enumeration", StringTokenizer.className, "nextToken", null);
		var start:Number = _currentPosition;
		_currentPosition = _scanToken(_currentPosition);
		return _str.substring(start, _currentPosition);
    }

	/*
	* Returns the same value as the hasMoreTokens method.
	*
	* @return true if there are more tokens; false otherwise.
	*
	*/
    public function hasMoreElements():Boolean
	{
		return hasMoreTokens();
    }

	/*
	* Returns the same value as the nextToken method, except that its declared return value is Object rather than String.
	* It exists so that this class can implement the Enumeration interface.
	*
	* @return the next token in the string, as an Object
	*
	*/
    public function nextElement():Object
	{
		return nextToken();
    }

	/**
	* Calculates the number of times that this tokenizer's nextToken method can be called before it generates an exception.
	* The current position is not advanced
	*
	* @return the number of tokens remaining in the string using the current delimiter set; as Number
	*
	*/
    public function countTokens():Number
	{
		var count:Number = 0;
		var currpos:Number = _currentPosition;
		while (currpos < _maxPosition)
		{
			currpos = _skipDelimiters(currpos);
			if (currpos >= _maxPosition) break;
			currpos = _scanToken(currpos);
			count++;
		}
		return count;
    }

	/****************************************
	*
	*	Private Methods
	*
	*****************************************/
	/**
	* Skips ahead from startPos and returns the index of the next delimiter
	* character encountered, or maxPosition if no such delimiter is found.
	*/
    private function _scanToken(startPos:Number):Number
	{
        var position:Number = startPos;
		var c:String = "";
        while (position < _maxPosition) {
            c = _str.charAt(position);
            if ((c <= _maxDelimChar) && (_delimiters.indexOf(c) >= 0)) break;
            position++;
		}
		if (_retDelims && (startPos == position)) {
			c = _str.charAt(position);
			if ((c <= _maxDelimChar) && (_delimiters.indexOf(c) >= 0)) position++;
		}
		return position;
    }

	/**
	* Skips delimiters starting from the specified position. If retDelims
	* is false, returns the index of the first non-delimiter character at or
	* after startPos. If retDelims is true, startPos is returned.
	*/
	private function _skipDelimiters(startPos:Number):Number
	{
//         if (null==_delimiters) throw new NullPointerException();
        var position:Number = startPos;
		var c:String = "";
		while (!_retDelims && position < _maxPosition)
		{
				c = _str.charAt(position);
				if ((c > _maxDelimChar) || (_delimiters.indexOf(c) < 0)) break;
			position++;
		}
        return position;
    }


	/**
	* Set maxDelimChar to the highest char in the delimiter set.
	*/
	private function _setMaxDelimChar():Void
	{
        if (null==_delimiters) {
            _maxDelimChar = "";
            return;
        }
		var m:String = "";
		var c:String = "";
		for (var i:Number = 0; i < _delimiters.length; i++)
		{
			c = _delimiters.charAt(i);
			if (m < c) m = c;
		}
		_maxDelimChar = m;
    }
}