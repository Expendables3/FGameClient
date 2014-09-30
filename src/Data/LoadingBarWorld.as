package Data 
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	[Embed(source = '../../content/loading.swf', symbol = 'LoadingBar')]
	
	/**
	 * ...
	 * @author ...
	 */
	public class LoadingBarWorld extends MovieClip 
	{
		public function LoadingBarWorld() 
		{
			SetPercent(0);
			//this.x = 210;
			//this.y = 500;
			this.x = 223;
			this.y = 521;
		}
		
		/**
		 * đặt trạng thái load hiện thời cho thanh loading
		 * @param percent phần trăm load hiện thời (0 - 100)
		 */
		public function SetPercent(percent:int):void
		{
			this.gotoAndStop(percent);
		}
	}

}