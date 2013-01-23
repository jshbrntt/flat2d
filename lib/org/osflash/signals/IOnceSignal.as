package org.osflash.signals
{
	/**
	 *
	 */
	public interface IOnceSignal
	{
		/**
		 * An optional array of classes defining the types of parameters sent to listeners.
		 */
		function get valueClasses():Array;
		function set valueClasses(value:Array):void;
		
		/** The current number of listeners for the signal. */
		function get numListeners():uint;
		
		/**
		 * Subscribes a one-time listener for this signal.
		 * The signal will remove the listener automatically the first time it is called,
		 * after the dispatch to all listeners is complete.
		 * @param	listener A function with arguments
		 * that matches the value classes dispatched by the signal.
		 * If value classes are not specified (e.g. via Signal constructor), dispatch() can be called without arguments.
		 * @return a ISlot, which contains the Function passed as the parameter
		 */
		function addOnce(listener:Function):ISlot;

		/**
		 * Dispatches an object to listeners.
		 * @param	valueObjects	Any number of parameters to send to listeners. Will be type-checked against valueClasses.
		 * @throws	ArgumentError	<code>ArgumentError</code>:	valueObjects are not compatible with valueClasses.
		 */
		function dispatch(...valueObjects):void;
		
		/**
		 * Unsubscribes a listener from the signal.
		 * @param	listener
		 * @return a ISlot, which contains the Function passed as the parameter
		 */
		function remove(listener:Function):ISlot;

		/**
		 * Unsubscribes all listeners from the signal.
		 */
		function removeAll():void
	}
}
