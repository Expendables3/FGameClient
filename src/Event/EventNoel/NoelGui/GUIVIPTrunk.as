package Event.EventNoel.NoelGui 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.engine.ElementFormat;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendOpenTrunk;
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIVIPTrunk extends BaseGUI
	{
		private var labelNum:TextField;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_OPEN:String = "btnOpen";
		static public const BTN_BUY:String = "btnBuy";
		static public const CTN_EQUIP:String = "ctnEquip";
		private var config:Array = ["Weapon", "Armor", "Helmet", "Bracelet", "Ring", "Necklace", "Belt"];
		private var _numKey:int;
		private var loadComplete:Boolean;
		private var _numUse:int;
		public var requireKey:int;
		private var data:Object;
		private var labelCost:TextField;
		private var cost:int;
		
		[Embed(source="../../../../content/dataloading.swf", symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		public var trunk:Image;
		
		public function GUIVIPTrunk(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				trunk = this.AddImage("", "GuiVIPTrunk_Trunk", 307, 330, true, Image.ALIGN_LEFT_TOP);
				
				requireKey = ConfigJSON.getInstance().GetItemList("VipBox_Bonus")["Price"]["Num"];
		
				this.AddButton(BTN_CLOSE, "BtnThoat", 705, 19, this);
				this.AddButton(BTN_OPEN, "GuiVIPTrunk_BtnOpen", 258, 475, this);
				this.AddButton(BTN_BUY, "GuiVIPTrunk_BtnBuy", 381, 475, this).SetEnable(false);
				labelNum = this.AddLabel("0", 325, 434, 0xffffff, 1, 0x000000);
				var txtFormat:TextFormat = new TextFormat("arial", 21, 0xffffff, true);
				txtFormat.align = "right";
				labelNum.defaultTextFormat = txtFormat;
				labelCost = this.AddLabel("0", 422, 480, 0xffffff, 1, 0x000000);
				txtFormat.size = 14;
				labelCost.defaultTextFormat = txtFormat;
				this.SetPos(this.img.stage.width / 2 - this.img.width / 2, this.img.stage.height / 2 - this.img.height / 2);
				
				
				for (var i:int = 0; i < config.length; i++)
				{
					drawGiftCtn(config[i], 105 + i * 87, 147);
					drawGiftCtn(config[i], 105 + i * 87, 250, true);
				}
				this.img.addChild(WaitData);
				WaitData.x = this.img.width / 2;
				WaitData.y = this.img.height / 2;
				numKey = 0;
				numUse = 0;
				loadComplete = true;
				if (data != null)
				{
					updateData(data);
				}
			}
			loadComplete = false;
			Exchange.GetInstance().Send(new SendGetVIPBox());
			LoadRes("GuiVIPTrunk_Theme");
		}
		
		override public function OnHideGUI():void 
		{
			data = null;
			if (WaitData != null && this.img.contains(WaitData))
			{
				this.img.removeChild(WaitData);
			}
		}
		
		private function drawGiftCtn(type:String, _x:Number, _y:Number, _isMax:Boolean = false):void
		{
			var ctnGift:Container = new Container(this.img, "");
			if (_isMax)
			{
				ctnGift.IdObject = CTN_EQUIP + "_" +  type + "_MAX";
			}
			else
			{
				ctnGift.IdObject = CTN_EQUIP + "_" + type + "_NORMAL";
			}
			ctnGift.EventHandler = this;
			ctnGift.LoadRes("");
			ctnGift.AddImage("", FishEquipment.GetBackgroundName(5), _x, _y, true, Image.ALIGN_CENTER_CENTER, true);
			var rank:int;
			if (type == "Weapon" || type == "Armor" || type == "Helmet")
			{
				rank = 105;
			}
			else 
			{
				rank = 5;
			}
			var equipPic:Image = ctnGift.AddImage("", FishEquipment.GetEquipmentName(type, rank, 4) + "_Shop", 0, 0, true, "", false, function f():void
			{
				this.FitRect(72, 76, new Point(_x - 38, _y - 38));
				FishSoldier.EquipmentEffect(this.img, 5);
			});
			if (_isMax)
			{
				ctnGift.AddImage("", "IcMax", _x + 36, _y -13).SetScaleXY(0.7);
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var a:Array = buttonID.split("_");
			if (a[0] == CTN_EQUIP)
			{
				var type:String = a[1];
				var element:int = 1;
				var rank:int;
				if (type == "Weapon" || type == "Armor" || type == "Helmet")
				{
					rank = 105;
				}
				else 
				{
					rank = 5;
				}
				var color:int;
				if (a[2] == "MAX")
				{
					color = 6;
				}
				else
				{
					color = 5;
				}
				var idMix:String = rank + "$" + color;
				var obj:Object = ConfigJSON.getInstance().GetEquipmentInfo(type, idMix);
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_OPEN:
					if(data != null)
					{
						//GuiMgr.getInstance().guiDecideElement.showGUI(function f(_element:int):void
						{
							//trace(_element);
							trunk.img.visible = false;
							GetButton(BTN_OPEN).SetEnable(false);
							GetButton(BTN_BUY).SetEnable(false);
							EffectMgr.getInstance().AddBitmapEffect(Constant.GUI_MIN_LAYER, "GuiVIPTrunk_EffOpen", 336 + 12, 354, false, false, function f():void
							{
								Exchange.GetInstance().Send(new SendOpenVIPTrunk(0, 0));
								numKey -= requireKey;
								trunk.img.visible = true;
							});
						}//);
					
					}
					break;
				case BTN_BUY:
					if(data != null)
					{
						if(GameLogic.getInstance().user.GetZMoney() >= cost)
						{
							//GuiMgr.getInstance().guiDecideElement.showGUI(function f(_element:int):void
							{
								//trace(_element);
								trunk.img.visible = false;
								GetButton(BTN_BUY).SetEnable(false);
								GetButton(BTN_OPEN).SetEnable(false);
								EffectMgr.getInstance().AddBitmapEffect(Constant.GUI_MIN_LAYER, "GuiVIPTrunk_EffOpen", 348, 354, false, false, function f():void
								{
									trunk.img.visible = true;
									Exchange.GetInstance().Send(new SendOpenVIPTrunk(1, 0));
									GameLogic.getInstance().user.UpdateUserZMoney( -cost);
									numUse ++;
								});
							}//);
						}
						else
						{
							GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
						}
					}
					break;
			}
		}
		
		public function updateData(data1:Object):void 
		{
			data = data1;
			if (loadComplete)
			{
				WaitData.visible = false;
				numKey = data["NumKey"];
				numUse = data["NumOpen"];
				GetButton(BTN_BUY).SetEnable(true);
			}
		}
		
		public function get numKey():int 
		{
			return _numKey;
		}
		
		public function set numKey(value:int):void 
		{
			_numKey = value;
			labelNum.text = Ultility.StandardNumber(value) + "/" + Ultility.StandardNumber(requireKey);
			if (value >= requireKey)
			{
				GetButton(BTN_OPEN).SetEnable(true);
			}
			else
			{
				GetButton(BTN_OPEN).SetEnable(false);
			}
		}
		
		public function get numUse():int 
		{
			return _numUse;
		}
		
		public function set numUse(value:int):void 
		{
			_numUse = value;
			cost = ConfigJSON.getInstance().GetItemList("VipBox_Item")[Math.min(31, value +1)]["ZMoney"];			
			labelCost.text = Ultility.StandardNumber(cost);
		}
		
	}

}