package GUI.Collection 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICompleteSetCollection extends BaseGUI 
	{
		private var labelName:TextField;
		private var rewardTab:String;
		private var rewardType:String;
		private var rewardId:int;
		private var rewardNum:int;
		//private var timer:Timer;
		
		public function GUICompleteSetCollection(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Complete_Collection");
			labelName = AddLabel("Bộ sưu tập ngư chiến", 105, 45, 0x1a6280);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0x1a6280, true);
			labelName.setTextFormat(txtFormat);
			AddButton("", "Btn_Change", 112, 70 + 118);
			SetPos(811, 25);
		}
		
		public function showGUI(_rewardTab:String, _rewardType:String, _rewardId:int, _rewardNum:int):void
		{
			Show();
			rewardTab = _rewardTab;
			rewardType = _rewardType;
			rewardId = _rewardId;
			rewardNum = _rewardNum;
			
			if (rewardType == "Money")
			{
				AddImage("", "IcGold", 156 - 18, 125 - 26).SetScaleXY(2);
			}
			else if (rewardType == "Exp")
			{
				AddImage("", "ImgEXP", 100 + 56 - 21, 50 + 75 - 22).SetScaleXY(2);
			}
			else 
			{
				AddImage("", rewardTab + "_Trunk_" + rewardId, 100 + 56, 50 + 75);
			}
			
			TweenMax.to(img , 1, { bezierThrough:[ { x:300, y:25}, { x:300, y:25} ], ease:Cubic.easeInOut, onComplete:onCompleteOut} );
		}
		
		private function onCompleteOut():void 
		{
			if(img != null)
			{
				TweenMax.to(img , 2, { bezierThrough:[ { x:300, y:25}, { x:300, y:25}, { x:300, y:25}, {x:811, y:25} ], ease:Cubic.easeInOut, onComplete:onCompleteIn} );
			}
		}
		
		private function onCompleteIn():void 
		{
			Hide();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			Hide();
			GuiMgr.getInstance().guiCollection.setFocusData(rewardTab, rewardType, rewardId, rewardNum);
			GuiMgr.getInstance().guiCollection.Show(Constant.GUI_MIN_LAYER, 10);
			//GameLogic.getInstance().completedCollection[rewardTab][rewardType + rewardId]  = true;
		}
	}

}