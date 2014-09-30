package Event.Factory.FactoryGui 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelGui.Team.RoundScene;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelPacket.SendFastComplete;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiFinishEventAuto extends BaseGUI 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_COMPLETE:String = "cmdComplete";
		
		private var _listGift:Array;
		public var inHide:Boolean;
		public function GuiFinishEventAuto(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiFinishEventAuto";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				inHide = false;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 702 , 18);
				var price:int;
				var fm:TextFormat;
				var tfPrice:TextField;
				var tfTip:TextField;
				var config:Object = ConfigJSON.getInstance().getItemInfo("Noel_Bonus");							//change here
				fm = new TextFormat("Arial", 16);
				AddButton(CMD_COMPLETE + "_ZMoney_N", "GuiFinishEventAuto_BtnComplete", 143 + 9, 518 - 29);
				price = config["NoelAutoN"]["Price"]["ZMoney"];													//change here
				tfPrice = AddLabel("", 145, 523-30, 0xffffff, 1, 0x000000);
				tfPrice.defaultTextFormat = fm;
				tfPrice.text = Ultility.StandardNumber(price);
				tfTip = AddLabel("", 90, 140, 0x003333, 0, -1);
				tfTip.defaultTextFormat = fm;
				tfTip.text = "Bỏ qua một số phần thưởng";
				AddButton(CMD_COMPLETE + "_ZMoney_S", "GuiFinishEventAuto_BtnComplete", 488 + 9, 518 - 29);
				price = config["NoelAutoS"]["Price"]["ZMoney"];													//change here
				tfPrice = AddLabel("", 490, 523-30, 0xffffff, 1, 0x000000);
				tfPrice.defaultTextFormat = fm;
				tfTip = AddLabel("", 420, 140, 0x003333, 0, -1);
				tfTip.defaultTextFormat = fm;
				tfTip.text = "Nhận được tất cả phần thưởng";
				tfPrice.text = Ultility.StandardNumber(price);
				
				var x:int = 90, y:int = 190, i:String,obj:Object,info:AbstractGift,itGift:AbstractItemGift,count:int;
				var data:Object;
				/*vẽ quà bên quà thường*/
				data = config["NoelAutoN"]["Gift"];
				count = 0;
				_listGift = [];
				for (i in data)
				{
					count++;
					obj = data[i];
					switch(obj["ItemType"])
					{
						case "Weapon":
							obj["ItemType"] = "EquipmentChest";
							break;
					}
					info = AbstractGift.createGift(obj["ItemType"]);
					info.setInfo(obj);
					itGift = AbstractItemGift.createItemGift(info.ItemType, this.img, "GuiFinishEventAuto_ImgSlot", x, y, true);
					itGift.initData(info, "", 69, 74, false);
					itGift.hasNum = true;
					itGift.hasTooltipImg = false;
					itGift.hasTooltipText = true;
					itGift.drawGift();
					itGift.SetScaleXY(0.88);																	//change here
					_listGift.push(itGift);
					x += 85;
					if (count % 3 == 0)
					{
						x = 90;
						y += 77;
					}
				}
				
				x = 420; 
				y = 190; 
				count = 0;
				/*vẽ quà bên quà VIP*/
				data = config["NoelAutoS"]["Gift"];
				count = 0;
				for (i in data)
				{
					count++;
					obj = data[i];
					switch(obj["ItemType"])
					{
						case "Weapon":
							obj["ItemType"] = "EquipmentChest";
							break;
					}
					info = AbstractGift.createGift(obj["ItemType"]);
					info.setInfo(obj);
					itGift = AbstractItemGift.createItemGift(info.ItemType, this.img, "GuiFinishEventAuto_ImgSlot", x, y, true);
					itGift.initData(info, "", 69, 74, false);
					itGift.hasNum = true;
					itGift.hasTooltipImg = false;
					itGift.hasTooltipText = true;
					itGift.drawGift();
					itGift.SetScaleXY(0.88);																						//change here
					_listGift.push(itGift);
					x += 85;
					if (count % 3 == 0)
					{
						x = 420;
						y += 77;
					}
				}
			}
			LoadRes("GuiFinishEventAuto_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_COMPLETE:
					var type:String = data[2];
					var priceType:String = data[1];
					var price:int = ConfigJSON.getInstance().getItemInfo("Noel_Bonus")["NoelAuto" + type]["Price"][priceType];
					if (Ultility.payMoney(priceType, price))
					{
						var pk:SendFastComplete = new SendFastComplete(type);
						Exchange.GetInstance().Send(pk);
						EventNoelMgr.getInstance().LastTimeFinish = GameLogic.getInstance().CurServerTime;
						EventNoelMgr.getInstance().StartTimeGame = -1;
						
						GuiMgr.getInstance().guiHuntFish.Hide();
						
						//GameLogic.getInstance().MouseTransform("");
						//Mouse.show();
					}
					break;
			}
		}
		
		override public function ClearComponent():void 
		{
			if (_listGift != null)
			{
				var itGift:AbstractItemGift;
				for (var i:int = 0; i < _listGift.length; i++)
				{
					itGift = _listGift[i];
					itGift.Destructor();
				}
				_listGift.splice(0, _listGift.length);
			}
			super.ClearComponent();
		}
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			{
				GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
				Mouse.hide();
			}
			inHide = true;
		}
	}

}