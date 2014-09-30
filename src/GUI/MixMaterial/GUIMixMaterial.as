package GUI.MixMaterial 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMixMaterial extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnClose";
		public const MATERIAL:String = "Material_";
		public const SUPPER:String = "_S";
		public const BTN_NEXT:String = "btnNext";
		public const BTN_BACK:String = "btnBack";
		public const BTN_ADD:String = "btnAdd";
		public const BTN_SUB:String = "btnSub";
		public const BTN_MIX_GOLD:String = "btnMixGold";
		public const BTN_MIX_G:String = "btnMixG";
		
		public var MAX_TYPE_CAN_USE:int = 12;
		public const MAX_TYPE_MATERIAL:Number = MAX_TYPE_CAN_USE * 2 + 2;
		
		public var listMaterial:ListBox;	
		public var arrMaterial:Array = [];
		private var labelPage:TextField;
		private var btnMixGold:Button;
		private var btnMixG:Button;
		private var ctnMix:Container;
		private var txtNumMaterial:TextField;
		private var txtBox:TextBox;
		private var txtCostG:TextField;
		private var txtCostGold:TextField;
		private var numMaterial:int;
		private var numNewMaterial:int;
		private var index:int;
		private var isSuper:Boolean = false;
		private var prevId:String = "";
		private var curPage:int;
		public function GUIMixMaterial(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiMixMaterial";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				SetPos(60, 10);
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
					sound.play();
				addContent();
				var cmd1:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd1);
			}
			LoadRes("GuiMixMaterial_Bg");
		}
		
		private function addContent():void 
		{
			ctnMix = AddContainer("CtnMix", "CtnMixBg", 375, 105, true, this);
			AddButton(BTN_CLOSE, "BtnThoat", 663, 19, this);
			AddButton(BTN_BACK, "BtnBackMix", 100, 520, this);
			AddButton(BTN_NEXT, "BtnNextMix", 255, 520, this);
			btnMixG = AddButton(BTN_MIX_G, "BtnMixG", 520, 507, this);
			btnMixGold = AddButton(BTN_MIX_GOLD, "BtnMixGold", 390, 507, this);
			btnMixGold.SetEnable(false);
			btnMixG.SetEnable(false);
			
			listMaterial = AddListBox(ListBox.LIST_X, 4, 3, 20, 35, true);
			listMaterial.setPos(60, 100);
			
			labelPage = AddLabel("1/1", 175, 527, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			labelPage.setTextFormat(txtFormat);
			labelPage.defaultTextFormat = txtFormat;
			
		}
		public function updateGUI():void
		{
			InitListMaterial(GameLogic.getInstance().user.StockThingsArr.Material);
			InitListBox(arrMaterial);
		}
		public function InitListMaterial(ArrUserMaterial:Array):void 
		{
			arrMaterial = [];
			var i:int = 0;
			for (i = 0; i < ArrUserMaterial.length; i++) 
			{
				var index:int = int(ArrUserMaterial[i]["Id"]);
				if(index < 100)
				{
					arrMaterial[2 * (index - 1)] = ArrUserMaterial[i]["Num"];
				}
				else 
				{
					arrMaterial[2 * (index - 100 - 1) + 1] = ArrUserMaterial[i]["Num"];
				}
			}
		}
		
		public function InitListBox(arr:Array):void
		{
			var type:int;		// Loai material nao
			var ctn:Container;
			listMaterial.removeAllItem();
			for (var i:int = 0; i < arr.length; i++)
			{
				if (i % 2 == 0)
				{
					type = i / 2 + 1;
					if (arr[i] > 0)
					{	
						ctn = DrawMaterial(type, arr[2 * (type - 1)], false);
						listMaterial.addItem(MATERIAL + type.toString() , ctn, this)
					}
				}
				else 
				{
					type = (i - 1) / 2 + 1;
					if (arr[i] > 0)
					{	
						ctn = DrawMaterial(type, arr[2 * (type - 1) + 1], true);
						listMaterial.addItem(MATERIAL + type.toString() + SUPPER, ctn, this)
					}
				}
			}
			if (listMaterial.getNumPage() <= 1)	curPage = 0;
			listMaterial.showPage(curPage);
			updateNextBackBtn();
		}
		
		private function sortOn(list:ListBox):ListBox
		{
			var arr:Array = list.itemList;
			var arrNew:Array = [];
			var obj:Object;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:Container = arr[i] as Container;
				var id:String = item.IdObject.split("_")[1].toString();
				for (var j:int = 0; j < 2 - id.length; j++) 
				{
					id = "0" + id;					
				}
				obj = new Object();
				obj["key"] = id;
				obj["Object"] = item;
				arrNew.push(obj);
			}
			arrNew.sortOn("key");
			list.itemList.splice(0, list.itemList.length);
			for (var k:int = 0; k < arrNew.length; k++) 
			{
				list.itemList.push(arrNew[k]["Object"]);
			}
			list.updateAllItemPos();
			return list;
		}
		
		public function DrawMaterial(type:int, num:int, isS:Boolean = false):Container
		{
			var obj:Object;
			var ctn:Container = new Container(listMaterial, "ItemBg");
			var imageSlot:Image;
			if (isS)
			{
				imageSlot = ctn.AddImage(MATERIAL, "Material" + (type % 100).toString() + "S", 35, 30, true, ALIGN_LEFT_TOP);
				obj = ConfigJSON.getInstance().getItemInfo("Material", type + 100);
			}
			else 
			{
				imageSlot = ctn.AddImage(MATERIAL, "Material" + type, 35, 30, true, ALIGN_LEFT_TOP);
				obj = ConfigJSON.getInstance().getItemInfo("Material", type);
			}
			ctn.AddLabel(Ultility.StandardNumber(num), -15, 45, 0xffffff, 1, 0x26709C);
			
			var txtFormat:TextFormat = new TextFormat()
			txtFormat.bold = true;
			txtFormat.color = 0xF37621;
			var toolTip:TooltipFormat = new TooltipFormat();
			toolTip.text = obj["Name"];
			if(obj["Name"].length > 0)
				toolTip.setTextFormat(txtFormat, 0, obj["Name"].length);
			ctn.setTooltip(toolTip);
			return ctn;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_BACK:
					listMaterial.showPrePage();
					curPage = listMaterial.curPage;
					updateNextBackBtn();
					break;
				case BTN_NEXT:
					listMaterial.showNextPage();
					curPage = listMaterial.curPage;
					updateNextBackBtn();
					break;
				case BTN_ADD:
					var n:int = Ultility.ConvertStringToInt(txtBox.GetText()) + 1;
					txtBox.SetText(Ultility.StandardNumber(n));
					txtBox.textField.stage.focus = txtBox.textField;
					txtBox.textField.setSelection(0, txtBox.textField.length);
					updateAddSubBtn(n);
					break;
				case BTN_SUB:
					var n1:int = Ultility.ConvertStringToInt(txtBox.GetText()) - 1;
					txtBox.SetText(Ultility.StandardNumber(n1));
					txtBox.textField.stage.focus = txtBox.textField;
					txtBox.textField.setSelection(0, txtBox.textField.length);
					updateAddSubBtn(n1);
					break;
				case BTN_MIX_GOLD:
				case BTN_MIX_G:
					mixMaterial(buttonID);
					break;
				default:
					var a:Array = buttonID.split("_");
					if(a[0] == "Material")
					{
						if (GameLogic.getInstance().user.GetLevel() < 7)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn cần đạt cấp 7 để ép ngư thạch.");
							return;
						}
						if (int(a[1]) > MAX_TYPE_CAN_USE)
						{
							var posStart:Point = GameInput.getInstance().MousePos;
							var posEnd:Point = new Point(posStart.x, posStart.y - 100);
							var txtFormat1:TextFormat = new TextFormat("arial", 14, 0xFFFF00, true, null, null, null, null, "center");
							var str:String = "Ngư thạch đã đạt cấp tối đa\nKhông thể ép được nữa"
							Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat1, 1, 0x000000);
							return;
						}
						updateDataMix(buttonID);
					}
					break;
			}
		}
		
		private function mixMaterial(buttonID:String):void 
		{
			var pwState:String = GameLogic.getInstance().user.passwordState;
			if (pwState == Constant.PW_STATE_IS_LOCK || pwState == Constant.PW_STATE_IS_CRACKING || pwState == Constant.PW_STATE_IS_BLOCKED)
			{
				GuiMgr.getInstance().guiPassword.showGUI();
				return;
			}
			if (index <= 0)	
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chưa chọn ngư thạch.");
			}
			var cmd:SendMixMaterial = new SendMixMaterial();
			cmd.Num = Ultility.ConvertStringToInt(txtNumMaterial.text);
			if (isSuper)	cmd.TypeId = index + 100;
			else	cmd.TypeId = index;
			var cost:int;
			if (buttonID == BTN_MIX_G)
			{
				cost = Ultility.ConvertStringToInt(txtCostG.text);
				if (GameLogic.getInstance().user.GetZMoney() < cost)
				{
					GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
					return;
				}
				enableButton(false);
				cmd.PriceType = "ZMoney";
				Exchange.GetInstance().Send(cmd);
				GameLogic.getInstance().user.UpdateUserZMoney( -cost);
			}
			else
			{
				cost = Ultility.ConvertStringToInt(txtCostGold.text);
				cmd.PriceType = "Money";
				Exchange.GetInstance().Send(cmd);
				GameLogic.getInstance().user.UpdateUserMoney( -cost);
				enableButton(false);
			}
		}
		
		private function enableButton(isEnable:Boolean = true):void 
		{
			GetButton(BTN_CLOSE).SetEnable(isEnable);
			ctnMix.GetButton(BTN_SUB).SetEnable(isEnable);
			ctnMix.GetButton(BTN_ADD).SetEnable(isEnable);
			btnMixGold.SetEnable(isEnable);
			btnMixG.SetEnable(isEnable);
			if (index <= 0)
			{
				btnMixGold.SetEnable(false);
				btnMixG.SetEnable(false);
			}
			for (var i:int = 0; i < listMaterial.length; i++ )
			{
				var ctn:Container = listMaterial.itemList[i] as Container;
				ctn.enable = isEnable;
			}
		}
		
		private function updateDataMix(buttonID:String):void 
		{
			ctnMix.ClearComponent();
			var arr:Array = buttonID.split("_");
			index = arr[1];
			var ctn:Container;
			if (prevId != "")
			{
				ctn = listMaterial.getItemById(prevId);
				if (ctn)	ctn.SetHighLight(-1);
			}
			ctn = listMaterial.getItemById(buttonID);
			prevId = buttonID;
			if (ctn)	ctn.SetHighLight(0x00FF00, true);
			var num:int;
			var img1:Container;
			var img2:Container;
			var obj1:Object;
			var obj2:Object;
			if (arr[2] == "S")
			{
				img1 = ctnMix.AddContainer("", "Material" + arr[1] + "S", 128, 50, true, this);
				obj1 = ConfigJSON.getInstance().getItemInfo("Material", int(arr[1]) + 100);
				num = arrMaterial[2 * (arr[1] - 1) + 1];
				isSuper = true;
			}
			else
			{
				img1 = ctnMix.AddContainer("", "Material" + arr[1], 128, 50, true, this);
				obj1 = ConfigJSON.getInstance().getItemInfo("Material", int(arr[1]));
				num = arrMaterial[2 * (arr[1] - 1)];
				isSuper = false;
			}
			img2 = ctnMix.AddContainer("", "Material" + (int(arr[1]) + 1).toString(), 128, 240, true, this);
			obj2 = ConfigJSON.getInstance().getItemInfo("Material", int(arr[1]) + 1);
			img1.SetScaleXY(1.2);
			img2.SetScaleXY(1.2);
			
			var tFormat:TextFormat = new TextFormat()
			tFormat.bold = true;
			tFormat.color = 0xF37621;
			var toolTip1:TooltipFormat = new TooltipFormat();
			toolTip1.text = obj1["Name"];
			if(obj1["Name"].length > 0)		toolTip1.setTextFormat(tFormat, 0, obj1["Name"].length);
			img1.setTooltip(toolTip1);
			
			var toolTip2:TooltipFormat = new TooltipFormat();
			toolTip2.text = obj2["Name"];
			if(obj2["Name"].length > 0)		toolTip2.setTextFormat(tFormat, 0, obj2["Name"].length);
			img2.setTooltip(toolTip2);
			
			if (num >= 5)	numMaterial = num - num % 5;
			else	numMaterial = num;
			if (num < 5)
				txtNumMaterial = ctnMix.AddLabel(Ultility.StandardNumber(num), 80, 100, 0xffffff, 1, 0x26709C);
			else
				txtNumMaterial = ctnMix.AddLabel(Ultility.StandardNumber(numMaterial), 80, 100, 0xffffff, 1, 0x26709C);
			if (isSuper)	numNewMaterial = num;
			else			numNewMaterial = num / 5;
			txtBox = ctnMix.AddTextBox("TextBox", "1", 80, 302, 100, 30, this);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtFormat.align = "center";
			txtBox.SetTextFormat(txtFormat);
			txtBox.SetDefaultFormat(txtFormat);
			txtNumMaterial.setTextFormat(txtFormat);
			txtNumMaterial.defaultTextFormat = txtFormat;
			txtBox.textField.selectable = true;
			txtBox.SetText(Ultility.StandardNumber(numNewMaterial));
			txtBox.textField.stage.focus = txtBox.textField;
			txtBox.textField.setSelection(0, txtBox.textField.length);
			
			var cf:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial", index + 1);
			txtCostG = ctnMix.AddLabel(Ultility.StandardNumber(cf["ZMoney"] * numNewMaterial), 143, 378, 0x00DF00, 1, 0x26709C);
			var rate:Number = 1;
			if (GameLogic.getInstance().isMonday())	rate = 0.5;
			txtCostGold = ctnMix.AddLabel(Ultility.StandardNumber(cf["Money"] * numNewMaterial * rate), 18, 378, 0xFBFB00, 1, 0x26709C);
			ctnMix.AddButton(BTN_SUB, "BtnSub", 65, 305, this);
			ctnMix.AddButton(BTN_ADD, "BtnAdd", 185, 305, this);
			updateAddSubBtn(numNewMaterial);
		}
		
		private function updateAddSubBtn(num:int):void 
		{
			ctnMix.GetButton(BTN_ADD).SetDisable();
			ctnMix.GetButton(BTN_SUB).SetDisable();
			if (num < numNewMaterial)
			{
				ctnMix.GetButton(BTN_ADD).SetEnable();
			}
			if (num > 1)
			{				
				ctnMix.GetButton(BTN_SUB).SetEnable();
			}
			var cf:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial", index + 1);
			if (!isSuper)	
			{
				if (num > 0)	txtNumMaterial.text = Ultility.StandardNumber(num * 5);
			}
			else
			{
				txtNumMaterial.text = Ultility.StandardNumber(num);
			}
			txtCostG.text = Ultility.StandardNumber(num * cf["ZMoney"]);
			var rate:Number = 1;
			if (GameLogic.getInstance().isMonday())	rate = 0.5;
			txtCostGold.text = Ultility.StandardNumber(num * cf["Money"] * rate);
			if (num < 1)
			{
				btnMixG.SetEnable(false);
				btnMixGold.SetEnable(false);
				ctnMix.AddLabel("Số lượng mang đi ghép cần ít nhất 5 viên.", 80, 340, 0x00FF00, 1, 0x000000);
			}
			else
			{
				btnMixG.SetEnable();
				btnMixGold.SetEnable(false);
				if (GameLogic.getInstance().user.GetMoney() >= Ultility.ConvertStringToInt(txtCostGold.text))
					btnMixGold.SetEnable();
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			if (txtID == "TextBox")
			{
				var num:int = Ultility.ConvertStringToInt(txtBox.GetText());
				if (num < 1) num = 1;
				if (num > numNewMaterial) num = numNewMaterial;
				txtBox.SetText(Ultility.StandardNumber(num));
				updateAddSubBtn(num);
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID) 
			{
				default:
					if(buttonID.split("_")[0] == "Material")
					{
						var ctn:Container = listMaterial.getItemById(buttonID);
						if (ctn)
						{
							ctn.SetHighLight(0x00FF00, true);
						}
					}
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{	
				default:								
					if(buttonID.split("_")[0] == "Material")
					{
						var ctn:Container = listMaterial.getItemById(buttonID);
						if (ctn && buttonID != prevId)
						{
							ctn.SetHighLight( -1);
						}
					}
					break;
			}
		}
		
		public function updateNextBackBtn():void
		{
			labelPage.text = String(curPage + 1) + "/" + listMaterial.getNumPage();
			//labelPage.text = String(listMaterial.curPage + 1) + "/" + listMaterial.getNumPage();
			GetButton(BTN_NEXT).SetDisable();
			GetButton(BTN_BACK).SetDisable();
			if (listMaterial.curPage < listMaterial.getNumPage() - 1)
			{
				GetButton(BTN_NEXT).SetEnable();
			}
			if (listMaterial.curPage > 0)
			{				
				GetButton(BTN_BACK).SetEnable();
			}
		}
		
		public function processMixMaterial(data1:Object):void 
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffMixMaterial", null, 435, 115, false, false, null, endEff);
			function endEff():void
			{
				var numSub:int = Ultility.ConvertStringToInt(txtNumMaterial.text);
				var n:int;
				if (isSuper)
				{	
					n = (index - 1) * 2 + 1;
					index = index + 100;
				}
				else
				{
					n = (index - 1) * 2;
				}
				arrMaterial[n] -= numSub;
				n = (data1["TypeId"] - 1) * 2;
				if (isNaN(arrMaterial[n]))	arrMaterial[n] = 0;
				arrMaterial[n] += data1["Num"];
				GameLogic.getInstance().user.UpdateStockThing("Material", index, -numSub);
				GameLogic.getInstance().user.UpdateStockThing("Material", data1["TypeId"], data1["Num"]);
				index = 0;
				enableButton();
				ctnMix.ClearComponent();
				InitListBox(arrMaterial);
				GuiMgr.getInstance().guiReceiveMaterial.showGift(data1);
			}
		}
	}
}