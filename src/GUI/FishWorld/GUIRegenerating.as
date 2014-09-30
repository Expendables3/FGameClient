package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.Config;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.FishWar.FishWar;
	import GUI.FishWorld.Network.SendUseLotus;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIRegenerating extends BaseGUI 
	{
		private const BTN_CLOSE:String = "BtnClose";
		private const BTN_USE:String = "BtnUse";
		private var arrFish:Array = [];
		private var useWhenKillSubBoss:Boolean = false;
		private var ZXu:int;
		public function GUIRegenerating(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiRegenerating";
		}
		
		public function initGUI(arrFishSoldier:Array, isSubBoss:Boolean = false):void 
		{
			arrFish = [];
			for (var i:int = 0; i < arrFishSoldier.length; i++) 
			{
				arrFish.push(arrFishSoldier[i]);
			}
			ZXu = ConfigJSON.getInstance().getItemInfo("LotusFlower", 1).ZMoney * arrFish.length;
			useWhenKillSubBoss = isSubBoss;
			Show(Constant.GUI_MIN_LAYER, 2);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//super.InitGUI();
				SetPos(320, 155);
				OpenRoomOut();
			}			
			LoadRes("GuiGenerating_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			RefreshAllComponent();
		}
		
		public function RefreshAllComponent():void 
		{
			ClearComponent();
			var tf:TextFormat = new TextFormat();
			var tl:TextField;
			tl = AddLabel("x" + arrFish.length, 170, 155, 0xCC0000, 0);
			tf.size = 20;
			tl.setTextFormat(tf);
			
			AddButton(BTN_CLOSE, "GuiGenerating_Btn_BoQua", 147, 195);
			AddButton(BTN_USE, "GuiGenerating_BtnBuyG", 52, 195);
			if (GameLogic.getInstance().user.GetZMoney() < ZXu)
			{
				GetButton(BTN_USE).SetDisable();
			}
			var ImgG:Image = AddImage("", "IcZingXu", 122, 205);
			tl = AddLabel("Mua " + ZXu, 60, 195, 0x264904, 0);
			tf = new TextFormat();
			tf.size = 15;
			tf.color = 0x264904;
			tf.bold = true;
			tl.setTextFormat(tf);
			tl.defaultTextFormat = tf;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					for (var j:int = 0; j < arrFish.length; j++) 
					{
						(arrFish[j] as FishSoldier).IsDie = true;
						for (var k:int = 0; k < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; k++) 
						{
							if (GameLogic.getInstance().user.GetMyInfo().MySoldierArr[k].Id == arrFish[j].Id)
							{
								GameLogic.getInstance().user.GetMyInfo().MySoldierArr[k].IsDie = true;
								break;
							}
						}
					}
					if (!Ultility.IsInMyFish() && !Ultility.IsKillBoss())
					{
						FishWar.RemoveFishSoldierInWorld(arrFish[0]);
					}
					else 
					{
						if(!useWhenKillSubBoss)
						{
							for (var i:int = 0; i < BossMgr.getInstance().BossArr.length; i++) 
							{
								(BossMgr.getInstance().BossArr[i] as Boss).DeleteFishSolider();
								(BossMgr.getInstance().BossArr[i] as Boss).ClearPrg();
							}
							GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
						}
						else
						{
							FishWar.RemoveFishSoldierInWorld(arrFish[0]);
						}
					}
				break;
				case BTN_USE:
					UseLotus();
					Hide();
				break;
			}
		}
		
		private function UseLotus():void 
		{
			var i:int = 0;
			GetButton(BTN_USE).SetDisable();
			var obj:Object = new Object();
			for (i = 0; i < arrFish.length; i++) 
			{
				var fs:FishSoldier = arrFish[i];
				var idLake:int = fs.LakeId;
				if (obj[idLake.toString()] == null)
				{
					obj[idLake.toString()] = [];
					obj[idLake.toString()].push(fs.Id);
				}
				else 
				{
					obj[idLake.toString()].push(fs.Id);
				}
				fs.SwimTo(fs.standbyPos.x, fs.standbyPos.y, 10);
			}
			if (Ultility.IsKillBoss())
			{
				var boss:Boss;
				for (i = 0; i < BossMgr.getInstance().BossArr.length; i++) 
				{
					boss = BossMgr.getInstance().BossArr[i] as Boss;
					//boss.DeleteFishSolider();
					//boss.UpdateVitalityAllFishSoldier();
					//boss.UpdateStateAllFishSoldier();	// Cập nhật vị trí các con cá và vùng bơi cho chúng
					boss.CurHp = boss.MaxHp;
					boss.SetHornInfo();
					boss.SetStateBoss(Boss.BOSS_STATE_IDLE);
				}
				GameLogic.getInstance().isAttacking = false;
				
				if (GameLogic.getInstance().user.bossMetal)
				{
					GameLogic.getInstance().user.bossMetal.CurHp = GameLogic.getInstance().user.bossMetal.MaxHp;
					GameLogic.getInstance().user.bossMetal.SetHornInfo();
					GameLogic.getInstance().user.bossMetal.SetStateBoss(BossMetal.BOSS_STATE_IDLE_NORMAL);
				}
				
				if (GameLogic.getInstance().user.bossIce)
				{
					GameLogic.getInstance().user.bossIce.CurHp = GameLogic.getInstance().user.bossIce.MaxHp;
					GameLogic.getInstance().user.bossIce.SetHornInfo();
					GameLogic.getInstance().user.bossIce.SetStateBoss(BossMetal.BOSS_STATE_IDLE_NORMAL);
				}
			}
			GameLogic.getInstance().user.UpdateUserZMoney( -ZXu);
			var cmd:SendUseLotus = new SendUseLotus(obj);
			Exchange.GetInstance().Send(cmd);
		}
	}

}