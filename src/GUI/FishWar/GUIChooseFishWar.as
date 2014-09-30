package GUI.FishWar 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	
	/**
	 * GUI chọn cá chọi
	 * @author longpt
	 */
	public class GUIChooseFishWar extends BaseGUI 
	{
		public static const CHOOSE_FISH_WAR_NEXT:String = "Next";
		public static const CHOOSE_FISH_WAR_PREVIOUS:String = "Previous";
		public static const CONTAINER_FISH:String = "ContainerFish";
		
		public var idFish:int;
		public var numFish:int;
		public var curFish:FishSoldier;
		public var arrFish:Array = [];
		//public var reward:Array;
		public var ctn:Container;
		
		public var theirFishImg:Image;
		
		public function GUIChooseFishWar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseFishWar";
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgFrameFriend");
			SetPos(GuiMgr.getInstance().GuiMain.img.x + 310, GuiMgr.getInstance().GuiMain.img.y);
		}
		
		/**
		 * Init thông tin trên GUI
		 * @param	arr
		 * @param	id
		 */
		public function InitFish(arr:Array, id:int = 0):void
		{
			this.Show(Constant.GUI_MIN_LAYER, 0);
			ClearComponent();
			ctn = AddContainer(CONTAINER_FISH, "GuiChooseFishWar", 0, -67, true, this);
			if (arr.length == 0)
			{
				arr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			}
			arr = FishSoldier.SortFishSoldier(arr);
			
			idFish = id;
			numFish = arr.length;
			curFish = arr[id];
			arrFish = arr;
			
			var ButtonNext:Button = AddButton(CHOOSE_FISH_WAR_NEXT, "BtnNextCaLinh", 75, -12);
			var ButtonPrevious:Button = AddButton(CHOOSE_FISH_WAR_PREVIOUS, "BtnBackCaLinh", -15, -12); 
			
			if (arr.length != 0)
			{
				var imm:Image = AddImage("", "IcHelper", 0, 0);
				imm.img.rotation = -90;
				//imm.img.scaleX = imm.img.scaleY = 0.7;
			}
			
			// Ko có cá lính
			if (numFish)
			{
				ShowFish(arr[idFish]);
				
				if (idFish <= 0)
				{
					ButtonPrevious.SetDisable();
				}
				if (idFish >= arr.length - 1)
				{
					ButtonNext.SetDisable();
				}
			}
			else
			{
				ButtonNext.SetDisable();
				ButtonPrevious.SetDisable();
			}
		}
		
		
		
		/**
		 * Show con cá lính lên trên GUI chọn
		 * @param	f
		 */
		public function ShowFish(f:FishSoldier):void
		{
			var i:Image = ctn.AddImage("", "Element" + f.Element, 67, 15, true, ALIGN_LEFT_TOP);
			//i.img.scaleX = i.img.scaleY = 0.7;
			i.FitRect(25, 25);
			var image:Image = ctn.AddImage("", Fish.ItemType + f.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 75, 10, true, ALIGN_CENTER_CENTER);
			image.img.scaleX = image.img.scaleY = 0.6;
			
			// Hard code tọa độ, chán lắm rồi :(
			switch (f.FishTypeId)
			{
				case 300:
					image.SetPos(75, 62);
					break;
				case 301:
					image.SetPos(75, 75);
					break;
				case 302:
					image.SetPos(57, 62);
					break;
				case 303:
					image.SetPos(75, 75);
					break;
				case 304:
					image.SetPos(60, 60);
					break;
			}
			var txtF:TextField = AddLabel(String(f.Damage), 2, -73, 0xFFF100, 1, 0x603813);
			
			if (f.Health < f.AttackPoint * 2)
			{
				image.GoToAndStop(0);
			}
		}
		
		public function processWar(event:MouseEvent):void
		{
			// Nếu ko có cá lính 
			if (numFish == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn cần trang bị Ngư Thủ để có thể kích hoạt tính năng này!");
				return;
			}
			
			// Nếu có cá lính trong hồ nhà bạn
			if (FishSoldier.FindBestSoldier(GameLogic.getInstance().user.FishSoldierAllArr, false))
			{
				if (GameLogic.getInstance().user.FishArr[0])
				{
					if (curFish.Health < curFish.AttackPoint * 2)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ của bạn không còn đủ sức khỏe để Ngư chiến!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						return;
					}
					
					// Check đủ tiền cược cá hay ko
					var theirFList:Array = GameLogic.getInstance().user.FishArr;
					var moneyR:int = 0;
					for (var i:int = 0; i < theirFList.length; i++)
					{
						var cfg:Object = ConfigJSON.getInstance().getItemInfo("Fish", theirFList[i].FishTypeId);
						var trustPrice:int = cfg.TrustPrice;
						
						var thisTotal:int = trustPrice * 60 / 100;
						var thisLeft:int = thisTotal - theirFList[i].MoneyAttacked;
						
						var MoneyRequire:int = Math.ceil(Number(curFish.Damage / 1000) * curFish.Rate * trustPrice);
						if (thisLeft < MoneyRequire)
						{
							MoneyRequire = thisLeft;
						}
						moneyR += MoneyRequire;
					}
					GameLogic.getInstance().user.MoneyRequire = moneyR;
					if (GameLogic.getInstance().user.GetMyInfo().Money > moneyR)
					{
						//GuiMgr.getInstance().GuiFishWar.Init(curFish as FishSoldier);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn cần có ít nhất " + Ultility.StandardNumber(moneyR) + " vàng để ngư chiến!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Không thể tấn công hồ nhà bạn bè không có cá!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				}
			}
			else if (GameLogic.getInstance().user.FishArr[0])
			{
				if (curFish.Health < curFish.AttackPoint)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ của bạn không còn đủ sức khỏe để Ngư chiến!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
				
				var energyCost:int = Math.floor(arrFish[idFish].Damage / 2);
				if (energyCost > GameLogic.getInstance().user.GetEnergy())
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Không đủ năng lượng!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				}
				else
				{
					// Effect trừ năng lượng
					GameLogic.getInstance().user.UpdateEnergy( -energyCost);
					
					// Gửi gói tin oánh nhau lên
					var obj:Object = new Object();
					obj["myFishId"] = arrFish[idFish].Id;
					obj["myLakeId"] = arrFish[idFish].LakeId;
					obj["theirId"] = GameLogic.getInstance().user.Id;
					obj["theirLake"] = GameLogic.getInstance().user.CurLake.Id;
					obj["Item"] = [];
					var fight:SendAttackFriendLake = new SendAttackFriendLake(obj);
					Exchange.GetInstance().Send(fight);
			
					// Chiến luôn cá cùi
					//GuiMgr.getInstance().GuiFishWarMovie.Init(curFish as FishSoldier);
				}
			}
			else
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Không thể tấn công hồ nhà bạn bè không có cá!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
			}
		}
		
		/**
		 * Cập nhật sức khỏe của cả 2 con cá
		 * Effect trừ sức khỏe cá mình
		 */
		public function UpdateFishesHealth():void
		{
			var i:int;
			var str:String;
			// Thắng chắc: Cá mình bị trừ 1HP
			curFish.UpdateHealth( -curFish.AttackPoint);
			HealthEffect( -curFish.AttackPoint);
		}
		
		/**
		 * Effect trừ HP cá
		 * @param	num
		 */
		public function HealthEffect(num:int):void
		{
			var child:Sprite = new Sprite();
			var str:String = num.toString();
			var pos:Point = new Point(this.img.x, this.img.y);
			var txtFormat:TextFormat = new TextFormat(null, 26, 0xffff00); //0xFFF100, 0, 0x603813
			txtFormat.bold = true;
			txtFormat.align = "left";
			txtFormat.font = "Arial";
			child.addChild(Ultility.CreateSpriteText(str, txtFormat, 6, 0, false));		

			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null) as ImgEffectFly;
			eff.SetInfo(pos.x, pos.y, pos.x, pos.y + 30, 3);
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case CHOOSE_FISH_WAR_NEXT:
					if (idFish < numFish - 1)
					{
						++idFish;
						InitFish([], idFish);
					}
					break;
				case CHOOSE_FISH_WAR_PREVIOUS:
					if (idFish > 0)
					{
						--idFish;
						InitFish([], idFish);
					}
					break;
				case CONTAINER_FISH:
					processWar(event);
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{	
			switch (buttonID)
			{
				case CONTAINER_FISH:
					GetContainer(buttonID).SetHighLight(0x00ff00);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CONTAINER_FISH:
					GetContainer(buttonID).SetHighLight(-1);
					break;
			}
		}
	}

}