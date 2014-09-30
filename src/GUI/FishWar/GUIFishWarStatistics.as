package GUI.FishWar 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI thống kê thông tin liên quan đến chọi cá
	 * @author longpt
	 */
	public class GUIFishWarStatistics extends BaseGUI 
	{
		private static const BTN_CLOSE:String = "BtnClose";
		private static const BTN_FEED:String = "BtnFeed";
		
		public var BattleStat:Object;
		public var TotalWar:int = 0;
		public var Freq:int = 0;
		public var WinRate:String = "0";
		
		public function GUIFishWarStatistics(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishWarStatistics";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(120, 90);
				OpenRoomOut();
			}
			LoadRes("GuiStatistics_Theme");	
		}
		
		public override function EndingRoomOut():void
		{
			InitData();
			RefreshComponent();
		}
		
		public function InitData():void
		{
			BattleStat = GameLogic.getInstance().user.GetBattleStat();
			
			TotalWar = BattleStat.Win + BattleStat.Lose;
			if (TotalWar != 0)
			{
				//var str:String = String(BattleStat.Win / TotalWar);
				//str = str.substr(0, 4);
				//WinRate = Number(str) * 100 + "";
				//WinRate = WinRate.substr(0, WinRate.search(".") + 4) + "%";
				WinRate = Math.floor(BattleStat.Win / TotalWar * 100) + "%";
			}
			else
			{
				WinRate = "0%";
			}
			
			if (BattleStat.FirstTimeAttack == 0)
			{
				Freq = 0;
			}
			else
			{
				var firstTime:Date = new Date(BattleStat.FirstTimeAttack * 1000);
				var curTime:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
				var firstTimeStamp:Number = BattleStat.FirstTimeAttack - firstTime.hours * 3600 - firstTime.minutes * 60 - firstTime.seconds;
				var dayNum:int = Math.floor((GameLogic.getInstance().CurServerTime - firstTimeStamp) / (60 * 60 * 24));
				if (dayNum > 0)
				{
					Freq = TotalWar / dayNum;
				}
			}
		}
		
		public function RefreshComponent():void
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 22;
			txtFormat.color = 0x0000ff;
			txtFormat.bold = true;
			txtField = AddLabel(WinRate, 220, 120, 0x000000, 1, 0xffffff);					// Tỷ lệ thắng
			txtField.setTextFormat(txtFormat);
			
			txtFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.color = 0x000000;
			txtFormat.bold = true;
			
			var txtField:TextField;
			txtField = AddLabel(BattleStat.Win, 200, 183);						// Số trận thắng
			txtField.setTextFormat(txtFormat);
			txtField = AddLabel(BattleStat.Lose, 200, 228);						// Số trận thua
			txtField.setTextFormat(txtFormat);
			txtField = AddLabel(Freq + " trận/ngày", 220, 270);					// Số trận/ngày
			txtField.setTextFormat(txtFormat);
			//txtField = AddLabel(String(BattleStat.AverageWinRate).substr(0, 5) + "%", 210, 285);			// Tỷ lệ thắng trung bình
			//txtField.setTextFormat(txtFormat);
			AddButton(BTN_CLOSE, "BtnThoat", 541, 21);
			
			var fs:FishSoldier;
			if (GameLogic.getInstance().user.IsViewer())
			{
				fs = FishSoldier.FindBestSoldier(GameLogic.getInstance().user.FishSoldierAllArr, false);
			}
			else
			{
				fs = FishSoldier.FindBestSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr);
			}
			
			var fishCtn:Container = AddContainer("", "GuiStatistics_Ctn", 390, 110);
			
			if (fs != null)
			{
				fs.UpdateCombatSkill();
				
				var curSoldierImg:Image;
				
				if (fs.EquipmentList && fs.EquipmentList.Mask && fs.EquipmentList.Mask[0])
				{
					curSoldierImg = fishCtn.AddImage("", fs.EquipmentList.Mask[0].TransformName, 500, 240);
					curSoldierImg.FitRect(120, 120, new Point(0, 0));
					FishSoldier.EquipmentEffect(curSoldierImg.img, fs.EquipmentList.Mask[0].Color);
				}
				else
				{
					curSoldierImg = fishCtn.AddImage("", Fish.ItemType + fs.FishTypeId + "_Old_Idle", 500, 240);
					curSoldierImg.FitRect(120, 120, GetDeltaPos(fs.FishTypeId));
					UpdateFishContent(fs, curSoldierImg);
				}
				
				var dmg:int = fs.getTotalDamage();
				txtField = AddLabel(dmg + "", 450, 230, 0x000000, 0);
				txtField.setTextFormat(txtFormat);
				
				var def:int = fs.getTotalDefence();
				txtField = AddLabel(def + "", 450, 260, 0x000000, 0);
				txtField.setTextFormat(txtFormat);
				
				var crit:int = fs.getTotalCritical();
				txtField = AddLabel(crit + "", 450, 290, 0x000000, 0);
				txtField.setTextFormat(txtFormat);
				
				var vit:int = fs.getTotalVitality();
				txtField = AddLabel(vit + "", 450, 320, 0x000000, 0);
				txtField.setTextFormat(txtFormat);
			}
		}
		
		/**
		 * Lấy delta để fix tọa độ cho điẹp
		 * @param	id
		 * @return
		 */
		private function GetDeltaPos(id:int):Point
		{
			switch (id)
			{
				case 300:
					return new Point( -5, -5);
				case 301:
					return new Point( 0, 5);
				case 302:
					return new Point( -5, -5);
				case 303:
					return new Point( 5, -15);
				case 304:
					return new Point( 0, -10);
				case 320:
					return new Point( -15, 5);
				case 330:
					return new Point( -10, 0);
				case 340:
					return new Point( 5, 5);
				case 350:
					break;
			}
			return new Point();
		}
		
		private function UpdateFishContent(curSoldier:FishSoldier, curSoldierImg:Image):void
		{
			var s:String;
			var i:int;
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(curSoldierImg, eq.Type, eq.imageName);
				}
			}
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, Type:String, resName:String = ""):void
		{
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
					dob.name = Type;
					child.parent.removeChild(child);
				}
				eq.loadRes(resName);
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					this.Hide();
					break;
				default:
					break;
			}
		}
	}

}