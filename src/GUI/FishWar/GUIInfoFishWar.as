package GUI.FishWar 
{
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Lake;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIInfoFishWar extends BaseGUI 
	{
		
		public function GUIInfoFishWar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIInfoFishWar";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiInfoFishWar");	
			SetPos(280, 40);
			//SetInfo();
		}
		
		public function SetInfo():void
		{
			var lakeInfo:Lake = GameLogic.getInstance().user.CurLake;
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var numAttack:int;
			
			var lastTime:Number = lakeInfo.Attack.LastTimeAttack;
			var lastDate:Date = new Date(lastTime * 1000);
			var curDate:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			
			if (lastDate.day == curDate.day && lastDate.month == curDate.month && lastDate.fullYear == curDate.fullYear
				&& lakeInfo.Attack.ListAttack[String(myId)])
			{
				numAttack = lakeInfo.Attack.ListAttack[String(myId)];
			}
			else
			{
				numAttack = 0;
			}
			AddLabel(numAttack.toString(), 100, 100, 0x000000, 1, 0xffffff);
		}
	}

}