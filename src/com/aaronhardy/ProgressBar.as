// Copyright (c) 2011 Aaron Hardy
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
package com.aaronhardy
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	/**
	 * A spark-based progress bar component.
	 */
	public class ProgressBar extends SkinnableComponent
	{
		[SkinPart(type="mx.core.IVisualElement", required="true")]
		/**
		 * The track for the progress bar.
		 */
		public var track:IVisualElement;
		
		[SkinPart(type="mx.core.IVisualElement", required="true")]
		/**
		 * The bar for the progress bar.  This is bill positioned and sized in relation to the
		 * track.
		 */
		public var bar:IVisualElement;
		
		private var _value:Number = 0;
		
		[Bindable]
		/**
		 * The value of the progress bar.  Must be between 0 and <code>maximum</code>.
		 */
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * @private
		 */
		public function set value(val:Number):void
		{
			if (_value != val)
			{
				_value = val;
				invalidateDisplayList();
			}
		}
		
		private var _maximum:Number = 1;
		
		[Bindable]
		/**
		 * The largest value for the progress bar.
		 */
		public function get maximum():Number
		{
			return _maximum;
		}
		
		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			if (_maximum != value)
			{
				_maximum = value;
				invalidateDisplayList();
			}
		}
		
		private var _eventSource:IEventDispatcher;
		
		/**
		 * An optional IEventDispatcher dispatching progress events.  The progress events will
		 * be used to update the <code>value</code> and <code>maximum</code> properties.
		 */
		public function get eventSource():IEventDispatcher
		{
			return _eventSource;
		}
		
		/**
		 * @private
		 */
		public function set eventSource(value:IEventDispatcher):void
		{
			if (_eventSource != value)
			{
				removeEventSourceListeners();
				_eventSource = value;
				addEventSourceListeners();
			}
		}
		
		/**
		 * @private
		 * Removes listeners from the event source.
		 */
		protected function removeEventSourceListeners():void
		{
			if (eventSource)
			{
				eventSource.removeEventListener(ProgressEvent.PROGRESS, eventSource_progressHandler);
			}
		}
		
		/**
		 * @private
		 * Adds listeners to the event source.
		 */
		protected function addEventSourceListeners():void
		{
			if (eventSource)
			{
				eventSource.addEventListener(ProgressEvent.PROGRESS, eventSource_progressHandler, 
					false, 0, true);
			}
		}
		
		/**
		 * @private
		 * Updates the <code>value</code> and <code>maximum</code> properties when progress
		 * events are dispatched from the <code>eventSource</code>.
		 */
		protected function eventSource_progressHandler(event:ProgressEvent):void
		{
			value = event.bytesLoaded;
			maximum = event.bytesTotal;
		}
	}
}