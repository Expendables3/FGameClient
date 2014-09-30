package GUI.unused 
{
	import adobe.utils.CustomActions;
	import adobe.utils.ProductManager;
	import com.bit101.charts.PieChart;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quint;
	import com.greensock.loading.data.SWFLoaderVars;
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import fl.containers.ScrollPane;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.errors.ScriptTimeoutError;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendGetTotalFish;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendMateFish;
	import particleSys.Emitter;
	import Sound.SoundMgr;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUIMateFish extends BaseGUI 
	{		
		// Các kết quả kiểm tra cá trước khi lai
		public static const PASS:int = 0;			// đủ điều kiện
		public static const HUNGRY:int = 1;			// đói
		public static const BABY:int = 2;			// đang còn bé
		public static const ALREADY:int = 3;		// đã lai trong ngày rồi
		public static const NOT_EXIST:int = 4;		// cá ko tồn tại
		
		public static const SEPARATE:String = "_";
		public static const BTN_RAW_MATERIAL:String = "btnRawMaterial";
		public static const BTN_CLOSE:String = "btnClose";
		public static const BTN_HELP:String = "btnHelp";
		public static const BTN_MATE_GOLD:String = "btnMate";
		public static const BTN_MATE_ZXU:String = "btnMate";
		public static const BTN_BUY_MATERIAL:String = "btnBuy";
		
		public static const BTN_BACK_MATER_LIST:String = "btnBackMaterList";
		public static const BTN_NEXT_MATER_LIST:String = "btnNextMaterList";
		
		public static const BTN_BACK_RESULT_LIST:String = "btnBackResultList";
		public static const BTN_NEXT_RESULT_LIST:String = "btnNextResultList";
		
		public static const BTN_BACK_BOY_LIST:String = "btnBackBoyList";
		public static const BTN_NEXT_BOY_LIST:String = "btnNextBoyList";
		
		public static const BTN_BACK_GIRL_LIST:String = "btnBackGirlList";
		public static const BTN_NEXT_GIRL_LIST:String = "btnNextGirlList";
		
		public static const CTN_BOY:String = "ctnBoy_";
		public static const CTN_GIRL:String = "ctnGirl_";
		public static const CTN_MATERIAL:String = "ctnMaterial_";
		public static const CTN_RESULT:String = "ctnResult_";
		public static const CTN_SLOT_BOY:String = "ctnSlot1";
		public static const CTN_SLOT_GIRL:String = "ctnSlot2";
		public static const FISH:String = "fish_";
		public static const MATERIAL:String = "material_";
		public static const SLOT_MATERIAL:String = "slotMater_";
		public static var MAX_OVER_LEVEL:int = 5;
		public static var PERCENT_UNEQUAL_LEVEL:int = 10;
		public static var PERCENT_UNEQUAL_LEVEL_MAX:int = 50;
		public static var MAX_MATERIAL:int = 0;
		public static var SLOT_UNLOCK_MATERIAL:int = 0;
		public var IsLoadedStore:Boolean = false;
		public var IsXXXing:Boolean = false;
		public var ReceivedMatePacket:Boolean = false;
		public var ReceivedTotalFish:Boolean = false;
		private var BabyFish:Fish;
		
		// các biến check logic
		private var onFlying:Boolean;
		
		// list cá vừa lai ra
		public var listResult:ListBox
		
		// 2 list cá đực và cái
		public var txtCountBoy:TextField;
		public var txtCountGirl:TextField;
		public var listBoy:ListBox;
		public var listGirl:ListBox;
		public var boyArr:Array;
		public var girlArr:Array;
		public var allFishList:Array;
		
		// 2 slot đực cái dành cho cá đc chọn
		public var boySlot:Container;
		public var girlSlot:Container;
		public var father:Fish;
		public var mother:Fish;
		public var maxLevel:int
		
		// list nguyên liệu lai, loại và số lượng
		public var arrMaterial:Array = [];
		public var listMaterial:ListBox;
		
		// các slot cho nguyên liệu lai
		public var materSlot:Array;
		public var usedSlot:Array;
		
		// Các thanh chỉ số lai vượt cấp, tỉ lệ cá đặc biệt, cá quý
		public var prgUplevel:ProgressBar;
		public var prgSpecial:ProgressBar;
		public var prgRare:ProgressBar;
		public var txtUplevel:TextField;
		public var txtSpecial:TextField;
		public var txtRare:TextField;
		public var txtWarning:TextField;
		
		// Giá tiền khi lai
		public var txtPrice:TextField;
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitDataFish:Sprite = new DataLoading();
		private var WaitDataStore:Sprite = new DataLoading();
		
		public function GUIMateFish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMateFish";
		}
		
		public override function InitGUI() :void
		{			
			if (GameLogic.getInstance().user.IsViewer())
			{
				return;
			}
			
			var cmd1:SendLoadInventory = new SendLoadInventory();
			Exchange.GetInstance().Send(cmd1);
			var cmd2:SendGetTotalFish = new SendGetTotalFish();
			Exchange.GetInstance().Send(cmd2);
			
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			var format:TextFormat = new TextFormat();
			var i:int;
			LoadRes("bgMateFish");
			SetPos(70, 50);
			onFlying = false;
			
			img.addChild(WaitDataFish);
			WaitDataFish.x = 91;
			WaitDataFish.y = 270;
			img.addChild(WaitDataStore);
			WaitDataStore.x = 350;
			WaitDataStore.y = 465;
			
			// 2 list cá
			format.size = 20;
			format.bold = true;
			txtCountGirl = AddLabel("x0", 60, 125, 0xFFFF00, 0, 0x0000FF);
			txtCountBoy = AddLabel("x0", 135, 125, 0xFFFF00, 0, 0x0000FF);
			txtCountGirl.setTextFormat(format);
			txtCountBoy.setTextFormat(format);
			txtCountGirl.defaultTextFormat = format;
			txtCountBoy.defaultTextFormat = format;
			listBoy = AddListBox(ListBox.LIST_Y, 3, 1, 10, 5);
			listBoy.setPos(88, 175);
			listGirl = AddListBox(ListBox.LIST_Y, 3, 1, 10, 5);
			listGirl.setPos(15, 175);
			
			// list nguyên liệu lai
			listMaterial = AddListBox(ListBox.LIST_X, 1, 5, 16, 10, true);
			listMaterial.setPos(172, 432);
			
			// list cá thành phẩm ^o^
			listResult = AddListBox(ListBox.LIST_X, 1, 2, 5, 10, true);
			listResult.setPos(523, 291);
			
			// 2 slot dành cho cá đc chọn
			boySlot = AddContainer(CTN_SLOT_BOY, "ImgFrameFriend", 300, 212, true, this);
			girlSlot = AddContainer(CTN_SLOT_GIRL, "ImgFrameFriend", 390, 203, true, this);
			father = null;
			mother = null;
			
			// một đống slot dành cho nguyên liệu lai đc chọn
			var slot:Container;
			var x:int = 338;
			var y:int = 212;
			var d:int = 119;
			
			var arr:Array = ConfigJSON.getInstance().getUnlockedSlot(GameLogic.getInstance().user.GetLevel());
			MAX_MATERIAL = arr[0];
			SLOT_UNLOCK_MATERIAL = GameLogic.getInstance().user.GetMyInfo().SlotUnlock;
			materSlot = [];
			usedSlot = [];
			var txtFormat:TextFormat = new TextFormat("Arial", 14, 0x854F3D, true);
			for (i = 0; i < MAX_MATERIAL; i++)
			{
				slot = AddContainer(SLOT_MATERIAL + i.toString(), "ctnSlotMater", x + d * Math.sin(i * 2 * Math.PI / MAX_MATERIAL) , y - d * Math.cos(i * 2 * Math.PI / MAX_MATERIAL), true, this);				
				if (i >= SLOT_UNLOCK_MATERIAL)
				{
					slot.AddImage("", "ImgShopItemLock", -45, 0);
					var tip:TooltipFormat = new TooltipFormat();
					var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", i + 1);
					tip.text = Localization.getInstance().getString("GUILabe20");
					tip.text = tip.text.replace("@level", obj.LevelRequire);
					tip.setTextFormat(txtFormat);
					slot.setTooltip(tip);
				}
				materSlot.push(slot);
				usedSlot[i] = 0;
			}
			
			// các thanh chỉ số lai			
			prgUplevel = AddProgress("", "prgUplevel", 530, 129, this, true);
			prgUplevel.setStatus(0);
			prgSpecial = AddProgress("", "prgSpecial", 530, 164, this, true);
			prgSpecial.setStatus(0);
			prgRare = AddProgress("", "prgRare", 530, 202, this, true);
			prgRare.setStatus(0);
			txtUplevel = AddLabel((prgUplevel.GetStatus() * 100).toString() + "%", prgUplevel.x + prgUplevel.width, prgUplevel.y - 4, 0, 0, 0xffffff);
			txtSpecial = AddLabel((prgSpecial.GetStatus() * 100).toString() + "%", prgSpecial.x + prgSpecial.width, prgSpecial.y - 4, 0, 0, 0xffffff);
			txtRare = AddLabel((prgRare.GetStatus() * 100).toString() + "%", prgRare.x + prgRare.width, prgRare.y - 4, 0, 0, 0xffffff);			
			
			// Giá tiền khi lai
			//AddImage("", "IcGold", 558, 233, true, ALIGN_LEFT_TOP);
			//AddImage("", "IcZingXu", 558, 264, true, ALIGN_LEFT_TOP);
			txtPrice = AddLabel("0", 198, 394, 0x966904, 1, 0xffffff);
			format.size = 14;
			format.bold = true;
			txtPrice.defaultTextFormat = format;
			txtPrice.setTextFormat(format);
			AddLabel("0", 300, 394, 0x966904, 1, 0xffffff).setTextFormat(format);		
			
			// các thể loại nút			
			AddButtonEx("", "tabMateFish_clicked", 32, 1, this);
			AddButton(BTN_RAW_MATERIAL, "BtnGhepnguyenlieuHide", 184, 9, this)//.SetEnable(false);
			AddButton(BTN_CLOSE, "BtnThoat", 649, 0, this);				
			AddButton(BTN_MATE_GOLD, "BtnMateGold", 207, 360, this).SetEnable(false);
			AddButton(BTN_MATE_ZXU, "BtnMateZXu", 309, 362, this).SetEnable(false);
			AddButton(BTN_BUY_MATERIAL, "BtnBuyMaterial", 556, 434, this).SetEnable(false);
			
			AddButton(BTN_BACK_MATER_LIST, "BtnPrev", 142, 443, this).SetEnable(false);
			AddButton(BTN_NEXT_MATER_LIST, "BtnNext", 515, 443, this).SetEnable(false);			
			
			AddButton(BTN_BACK_BOY_LIST, "BtnUp", 126, 160, this).SetEnable(false);
			AddButton(BTN_NEXT_BOY_LIST, "BtnDown", 124, 394, this).SetEnable(false);
			
			AddButton(BTN_BACK_GIRL_LIST, "BtnUp", 54, 160, this).SetEnable(false);
			AddButton(BTN_NEXT_GIRL_LIST, "BtnDown", 52, 394, this).SetEnable(false);
			
			//AddButton(BTN_BACK_RESULT_LIST, "btnNextFish", 436, 400, this);
			//AddButton(BTN_NEXT_RESULT_LIST, "btnNextFish", 640, 400, this);
			
			txtWarning = AddLabel(Localization.getInstance().getString("Message25"), 300, 135, 0xffff00, 1, 0xff0000);
			format.size = 17;
			format.bold = true;
			format.align = "center";
			txtWarning.setTextFormat(format);
			txtWarning.visible = false;
		}		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					if(!IsXXXing)
					{
						Hide();
					}
					break;
				case BTN_RAW_MATERIAL:
					if(!IsXXXing)
					{
						Hide();
						GuiMgr.getInstance().GuiRawMaterials.Show(Constant.GUI_MIN_LAYER, 6);
					}
					break;
				case CTN_SLOT_BOY:
				case CTN_SLOT_GIRL:
					RemoveFish(buttonID)
					break;
				case BTN_MATE_GOLD:
					doMateFish();
					break;
				case BTN_BACK_BOY_LIST:
					listBoy.showPrePage();
					GetButton(BTN_NEXT_BOY_LIST).SetEnable(true);
					if (listBoy.curPage == 0)
					{
						GetButton(BTN_BACK_BOY_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_BOY_LIST).SetEnable(true);
					}
					break;
				case BTN_NEXT_BOY_LIST:
					listBoy.showNextPage();
					GetButton(BTN_BACK_BOY_LIST).SetEnable(true);
					if (listBoy.curPage == listBoy.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_BOY_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_BOY_LIST).SetEnable(true);
					}
					break;
				case BTN_BACK_GIRL_LIST:
					listGirl.showPrePage();
					GetButton(BTN_NEXT_GIRL_LIST).SetEnable(true);
					if (listGirl.curPage == 0)
					{
						GetButton(BTN_BACK_GIRL_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_GIRL_LIST).SetEnable(true);
					}
					break;
				case BTN_NEXT_GIRL_LIST:
					listGirl.showNextPage();
					GetButton(BTN_BACK_GIRL_LIST).SetEnable(true);
					if (listGirl.curPage == listGirl.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_GIRL_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_GIRL_LIST).SetEnable(true);
					}
					break;
				case BTN_BACK_MATER_LIST:
					listMaterial.showPrePage();
					break;
				case BTN_NEXT_MATER_LIST:
					listMaterial.showNextPage();
					break;
				case BTN_BACK_RESULT_LIST:
					listResult.showPrePage();
					break;
				case BTN_NEXT_RESULT_LIST:
					listResult.showNextPage();
					break;
				
				default:
					if (buttonID.search(FISH) >= 0)
					{
						ChooseFish(buttonID);
					}
					else if (buttonID.search(MATERIAL) >= 0)
					{
						ChooseMaterial(buttonID)
					}
					else if (buttonID.search(SLOT_MATERIAL) >= 0)
					{
						RemoveMaterial(buttonID);
					}
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				default:
					var ctn:Container;										
					if (buttonID.search(CTN_BOY) >= 0)
					{
						ctn = listBoy.getItemById(buttonID)
					}
					else if (buttonID.search(CTN_GIRL) >= 0)
					{
						ctn = listGirl.getItemById(buttonID);
					}
					else if (buttonID.search(CTN_MATERIAL) >= 0)
					{
						ctn = listMaterial.getItemById(buttonID);
					}
					else if (buttonID.search(CTN_RESULT) >= 0)
					{
						ctn = listResult.getItemById(buttonID);
					}
					else if (buttonID.search(SLOT_MATERIAL) >= 0)
					{
						ctn = GetContainer(buttonID);
					}
					
					if (ctn)
					{
						ctn.SetHighLight();
					}
					
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{			
				default:
					var ctn:Container;
					if (buttonID.search(CTN_BOY) >= 0)
					{
						ctn = listBoy.getItemById(buttonID)
					}
					else if (buttonID.search(CTN_GIRL) >= 0)
					{
						ctn = listGirl.getItemById(buttonID);
					}
					else if (buttonID.search(CTN_MATERIAL) >= 0)
					{
						ctn = listMaterial.getItemById(buttonID);
					}
					else if (buttonID.search(CTN_RESULT) >= 0)
					{
						ctn = listResult.getItemById(buttonID);
					}
					else if (buttonID.search(SLOT_MATERIAL) >= 0)
					{
						ctn = GetContainer(buttonID);
					}
					
					if (ctn)
					{
						ctn.SetHighLight(-1);
					}
					break;
			}
		}
		
		public override function OnButtonMouseWheel(e:MouseEvent):void 
		{
			//var listFish:ListBox;
			//switch(e.target)
			//{
				//case ctnBoy.img:
					//listFish = ctnBoy.ListboxArr[0];
					//listFish.OnMouseWheel(e);
					//break;
					//
				//case ctnGirl.img:
					//listFish = ctnGirl.ListboxArr[0];
					//listFish.OnMouseWheel(e);
					//break;
			//}
		}
		
		public function Check(f:Fish):int
		{
			if (!f)
			{
				return NOT_EXIST;
			}
			
			// Check tuổi
			f.UpdateHavestTime();
			if (f.Growth() < 1)
			{
				return BABY;
			}
			
			// check độ no
			if (f.Full() <= 0)
			{
				return HUNGRY;
			}
			
			// check time, 1 ngày sinh sản 1 lần
			var lastTime:Date = new Date(f.LastBirthTime * 1000);
			var curTime:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			if (curTime.getFullYear() == lastTime.getFullYear())
			{
				if (curTime.getMonth() == lastTime.getMonth())
				{
					if (curTime.getDate() == lastTime.getDate())
					{
						return ALREADY;
					}
					else
					{
						return PASS;
					}
				}
				else
				{
					return PASS;
				}
			}
			else
			{
				return PASS;
			}
		}
		
		public function InitFishlist(arr:Array):void
		{
			if (!this.IsVisible || !img)
			{
				return;
			}
			if (img.contains(WaitDataFish))
			{
				img.removeChild(WaitDataFish);
			}
			
			var i:int;
			var f:Fish;			
			var ctn:Container;
			var imgName:String
			
			boyArr = [];
			girlArr = [];
			allFishList = [];
			for (i = 0; i < arr.length; i++)
			{
				imgName = Fish.ItemType + arr[i].FishTypeId + SEPARATE + Fish.OLD + SEPARATE + Fish.IDLE;
				f = new Fish(this.img, imgName);				
				f.SetInfo(arr[i]);
				//trace(f.FishTypeId + "MateFish");
				f.Init(0, 0);				
				var growth:Number = f.Growth();
				if (growth < 0 || f.IsEgg)
				{
					f.SetAgeState(Fish.EGG);
				}
				else if (growth < 0.5)
				{
					f.SetAgeState(Fish.BABY);
				}
				else
				{
					f.SetAgeState(Fish.OLD);
				}
				f.RefreshImg();
				f.Hide();
				allFishList.push(f);
				if (f.Sex == 1)
				{
					boyArr.push(f);					
				}
				else
				{
					girlArr.push(f);
				}				
			}
			boyArr = SortFishList(boyArr);
			girlArr = SortFishList(girlArr);
			listBoy.removeAllItem();
			for (i = 0; i < boyArr.length; i++)
			{
				f = boyArr[i];
				ctn = DrawCtnFish(f);
				listBoy.addItem(CTN_BOY + FISH + f.Id.toString(), ctn, this);
			}
			if (boyArr.length <= listBoy.RowShow)
			{
				GetButton(BTN_NEXT_BOY_LIST).SetEnable(false);
				GetButton(BTN_BACK_BOY_LIST).SetEnable(false);
			}
			else
			{
				GetButton(BTN_NEXT_BOY_LIST).SetEnable(true);
			}
			txtCountBoy.text = "x" + boyArr.length;
			
			listGirl.removeAllItem();
			for (i = 0; i < girlArr.length; i++)
			{
				f = girlArr[i];
				ctn = DrawCtnFish(f);
				listGirl.addItem(CTN_GIRL + FISH + f.Id.toString(), ctn, this);
			}
			if (girlArr.length <= listGirl.RowShow)
			{
				GetButton(BTN_NEXT_GIRL_LIST).SetEnable(false);
				GetButton(BTN_BACK_GIRL_LIST).SetEnable(false);
			}
			else
			{
				GetButton(BTN_NEXT_GIRL_LIST).SetEnable(true);
			}
			txtCountGirl.text = "x" + girlArr.length;
		}
		
		public function SortFishList(arr:Array):Array
		{		
			if (!arr || arr.length <= 0)
			{
				return arr;
			}
			arr.sortOn(["FishType", "Level"], Array.DESCENDING | Array.NUMERIC);
			
			var can:Array = [];
			var cant:Array = [];
			var i:int;
			var f:Fish;
			for (i = 0; i < arr.length; i++)
			{
				f = arr[i];
				if (Check(f) == PASS)
				{
					can.push(f);
				}
				else
				{
					cant.push(f);					
				}
			}
			
			arr.splice(0, arr.length);
			arr = can.concat(cant);
			return arr;
		}
		
		public function GetFish(id:int):Fish
		{
			var f:Fish;
			var i:int;
			for (i = 0; i < allFishList.length; i++)
			{
				f = allFishList[i];
				if (f.Id == id)
				{
					return f;
				}
			}
			
			return null;
		}
		
		public function DrawCtnFish(f:Fish):Container
		{
			var ctn:Container = new Container(listGirl, "ctnFish");
			var ctnSize:Point = new Point(ctn.img.width, ctn.img.height);			
			var aboveContent:Sprite;			
			var imgFish:Image = Ultility.PutFishIntoCtn(f, ctn, ctn.img.width / 2, ctn.img.height / 2);
			if(f.FishType == Fish.FISHTYPE_SPECIAL)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 - 10, ctn.img.height / 2 + 8);
			}
			else if(f.FishType == Fish.FISHTYPE_RARE)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 - 10, ctn.img.height / 2 + 8);
				var cl:int = f.getAuraColor();
				TweenMax.to(imgFish.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
			}
			var tip:TooltipFormat;
			switch(Check(f))
			{
				case BABY:
					tip = new TooltipFormat();
					tip.text = "còn bé";
					ctn.setTooltip(tip);
					ctn.img.alpha = 0.5;
					break;
				case HUNGRY:
					tip = new TooltipFormat();
					tip.text = "đang đói";
					ctn.setTooltip(tip);
					ctn.img.alpha = 0.5;
					break;
				case ALREADY:
					tip = new TooltipFormat();
					tip.text = "vừa lai xong";
					ctn.setTooltip(tip);
					ctn.img.alpha = 0.5;
					break;
				case PASS:
					break;				
			}			
			return ctn;
		}
		
		public function InitMaterialList(arr:Array):void
		{
			if (!this.IsVisible || !img)
			{
				return;
			}
			if (img.contains(WaitDataStore))
			{
				img.removeChild(WaitDataStore);
			}
			var type:int;
			var ctn:Container;
			for (type = 1; type <= arr.length; type++)
			{
				if (arr[type-1] > 0)
				{
					ctn = DrawMaterial(type, arr[type-1]);
					listMaterial.addItem(CTN_MATERIAL + MATERIAL + type.toString() , ctn, this)
				}
			}
		}
		
		public function DrawMaterial(type:int, num:int):Container
		{
			var ctn:Container = new Container(listMaterial, "ctnMaterial");
			ctn.AddImage(MATERIAL, "Material" + type, 26, 27, true, ALIGN_LEFT_TOP);
			ctn.AddLabel(num.toString(), -ctn.img.width / 2, ctn.img.height / 1.4, 0xffffff, 1, 0x26709C);
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", type);
			var tooltip_:TooltipFormat = new TooltipFormat();
			tooltip_.text = obj["Name"];
			//if (obj["RateOverLevel"] != "")	tooltip_.text = tooltip_.text + "\nVượt cấp : " + obj["RateOverLevel"] + " %";
			//if (obj["RateSpecial"] != "")	tooltip_.text = tooltip_.text + "\nĐặc biệt : " + obj["RateSpecial"] + " %";
			//if (obj["RateRare"] != "")	tooltip_.text = tooltip_.text + "\nQuí hiếm : " + obj["RateRare"] + " %";
			var index:int = tooltip_.text.indexOf(obj["Name"]);
			var txtFormatMat:TextFormat = new TextFormat();
			txtFormatMat.bold = true;			
			txtFormatMat.color = 0xF37621;
			tooltip_.setTextFormat(txtFormatMat, index, index + obj["Name"].length);
			ctn.setTooltip(tooltip_);
			return ctn;
		}
		
		public function ChooseFish(buttonID:String):void
		{
			if (onFlying || IsXXXing)
			{
				return;
			}
			var id:int = buttonID.split(FISH)[1]
			var arr:Array = allFishList;
			//var arr:Array = GameLogic.getInstance().user.GetFishArr();
			var f:Fish = null;			
			var parentSlot:Container;
			var parentList:ListBox;	
			for (var i:int = 0; i < arr.length; i++)
			{
				f = arr[i];
				if (f.Id == id)
				{
					break;
				}
				else
				{
					f = null;
				}
			}
			if (f.Sex == 1)
			{	
				parentSlot = boySlot;
				parentList = listBoy;	
			}
			else
			{	
				parentSlot = girlSlot;
				parentList = listGirl;
			}
			var ctnFish:Container;
			ctnFish = parentList.getItemById(buttonID);
			switch (Check(f))
			{
				case HUNGRY:
				{
					if (!ctnFish.tooltip)
					{
						var tip:TooltipFormat = new TooltipFormat();
						tip.text = "đang đói";
						ctnFish.setTooltip(tip);
						ctnFish.img.alpha = 0.5;
					}
					return;
				}
				case BABY:
				{
					return;
				}
				case ALREADY:
				{
					return;
				}
				case NOT_EXIST:
				{
					return;
				}
			}			
			
			var pS:Point;
			var pD:Point;
			var pM:Point = new Point(Ultility.RandomNumber(0, 400), Ultility.RandomNumber(0, img.height));
			var mc:Sprite;			
			
			if (f.Sex == 1)
			{		
				father = GetFish(id);
				if (!mother || mother.Level - GameLogic.getInstance().user.GetLevel() < MAX_OVER_LEVEL)
				{
					txtWarning.visible = false;
				}
			}
			else
			{
				mother = GetFish(id);
				if (!father || father.Level - GameLogic.getInstance().user.GetLevel() < MAX_OVER_LEVEL)
				{
					txtWarning.visible = false;
				}
			}
			parentSlot.ClearComponent();
			if (f.Level - GameLogic.getInstance().user.GetLevel() >= MAX_OVER_LEVEL)
			{
				txtWarning.visible = true;
			}
			
			// effect			
			mc = Ultility.PutFishIntoCtn(f, this).img;
			mc.scaleX = mc.scaleY = f.Scale * 1.1;
			if (f.Sex == 0)
			{
				mc.scaleX = -mc.scaleX;
			}
			mc.rotation = 0;
			img.addChild(mc);
			pS = img.globalToLocal(ctnFish.img.localToGlobal(new Point(ctnFish.ImageArr[0].img.x, ctnFish.ImageArr[0].img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			pD = img.globalToLocal(parentSlot.img.localToGlobal(new Point(parentSlot.img.width / 2, parentSlot.img.height / 2)));
			TweenMax.to(mc, 0.75, { bezier:[ { x:pD.x, y:pD.y} ], ease:Expo.easeOut, onComplete:onFinishTween, onCompleteParams:[mc, parentSlot, parentSlot.img.width / 2, parentSlot.img.height / 2, f]} );
			
			parentList.restore();
			parentList.getItemById(buttonID).SetHighLight( -1);
			parentList.hideItem(buttonID);
			onFlying = true;
		}
		
		public function RemoveFish(idCtn:String, isUsed:Boolean = false):void
		{
			var ctn:Container = GetContainer(idCtn);
			if (ctn.ImageArr.length <= 0)
			{
				return;
			}
			
			var f:Fish;
			var pS:Point;
			var pD:Point;
			var pM:Point = new Point(Ultility.RandomNumber(0, 400), Ultility.RandomNumber(0, img.height));
			var mc:Sprite;
			var list:ListBox;
			
			switch(idCtn)
			{
				case CTN_SLOT_BOY:
					f = father;
					list = listBoy;
					father = null;
					if (!mother || mother.Level - GameLogic.getInstance().user.GetLevel() < MAX_OVER_LEVEL)
					{
						txtWarning.visible = false;
					}
					break;
				case CTN_SLOT_GIRL:
					f = mother;
					list = listGirl;
					mother = null;
					if (!father || father.Level - GameLogic.getInstance().user.GetLevel() < MAX_OVER_LEVEL)
					{
						txtWarning.visible = false;
					}
					break;			
			}
			mc = Ultility.PutFishIntoCtn(f, this).img;
			mc.scaleX = mc.scaleY = f.Scale;
			mc.rotation = 0;
			img.addChild(mc);
			pS = img.globalToLocal(ctn.img.localToGlobal(new Point(ctn.ImageArr[0].img.x, ctn.ImageArr[0].img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			//var num:int = list.numItem + 1;
			//if (num > list.RowShow)
			//{
				//num = list.RowShow + 1;
			//}
			//trace("num = ", num);
			//pD = new Point(list.x + 39, list.y + num * 68);
			pD = new Point(list.x + 39, list.y + 34);
			TweenMax.to(mc, 0.75, { bezier:[{ x:pD.x, y:pD.y } ], ease:Expo.easeOut, onComplete:onFinishRemoveFish, onCompleteParams:[mc, list, isUsed] } );
			onFlying = true;
			ctn.ClearComponent();
			
			// tính lại các chỉ số
			CalculateRate();
		}
		
		private function onFinishRemoveFish(mc:Sprite, list:ListBox, isUsed:Boolean):void 
		{
			if (!this.IsVisible)
			{
				return;
			}
			if(mc.parent)
			{
				mc.parent.removeChild(mc);
			}
			if(!isUsed)
			{
				list.restore();
			}
			else
			{
				InitFishlist(GameLogic.getInstance().user.AllFishArr);
			}
			onFlying = false;
		}
		
		private function onFinishTween(mc:Sprite, ctn:Container, x:int, y:int, f:Fish = null):void 
		{
			if (!this.IsVisible)
			{
				return;
			}
			
			ctn.ClearComponent();
			
			ctn.AddImageBySprite(mc, x, y);
			var aboveContent:Sprite;
			if (f && f.FishType == Fish.FISHTYPE_RARE)
			{
				var cl:int = f.getAuraColor();
				TweenMax.to(mc, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				aboveContent.scaleX = aboveContent.scaleY = 0.8;
				ctn.AddImageBySprite(aboveContent, x, y);
			}
			else if(f && f.FishType == Fish.FISHTYPE_SPECIAL)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;				
				aboveContent.scaleX = aboveContent.scaleY = 0.8;				
				ctn.AddImageBySprite(aboveContent, x, y);
			}
			onFlying = false;
			
			// tính lại các chỉ số
			CalculateRate();
		}
		
		public function ChooseMaterial(buttonID:String):void
		{		
			if (IsXXXing)
			{
				return;
			}
			if (!father || !mother)
			{
				//Tooltip.getInstance().ShowNewToolTip(Localization.getInstance().getString("Message20"), pos.x, pos.y, 0.7);
				//Too
				return;
			}
			var id:int = buttonID.split(MATERIAL)[1];
			var i:int;
			var slot:Container;
			var material:Container;
			var num:int;
			var pS:Point;
			var pM:Point = new Point(Ultility.RandomNumber(0, 400), Ultility.RandomNumber(0, img.height));
			var pD:Point;
			for (i = 0; i < SLOT_UNLOCK_MATERIAL; i++)
			{
				//slot = materSlot[i] as Container;
				//if (slot.ImageArr && slot.ImageArr.length == 0)
				if (usedSlot[i] == 0)
				{
					slot = materSlot[i] as Container;
					material = listMaterial.getItemById(buttonID);
					num = int((material.LabelArr[0] as TextField).text);
					num--;
					(material.LabelArr[0] as TextField).text = num.toString();
					
					// effect
					var mc:Sprite = Ultility.CloneImage(material.ImageArr[0].img);
					img.addChild(mc);
					pS = img.globalToLocal(material.img.localToGlobal(new Point(material.ImageArr[0].img.x, material.ImageArr[0].img.y)));
					mc.x = pS.x;
					mc.y = pS.y;
					pD = img.globalToLocal(slot.img.localToGlobal(new Point(0, 0)));
					TweenMax.to(mc, 0.5, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeInOut, onComplete:onFinishTween, onCompleteParams:[mc, slot, 0, 0] } );
					if (num <= 0)
					{
						listMaterial.hideItem(buttonID);
						listMaterial.sortById();
					}
					
					var typeMaterial:String = material.IdObject.split(MATERIAL)[1];
					slot.IdObject += SEPARATE + typeMaterial;
					usedSlot[i] = typeMaterial;
					break;
				}
			}
		}
		
		public function RemoveMaterial(id:String, isUsed:Boolean = false):void
		{
			if (IsXXXing)
			{
				return;
			}
			var arr:Array = id.split(SEPARATE);
			if (arr.length != 3)
			{
				if(arr[1] == SLOT_UNLOCK_MATERIAL)
				{
					var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", parseInt(arr[1]) + 1);
					
					// Hardcode chờ GD
					if (obj.Id > 6)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Chanh Ớt lỡ làm mất chìa khóa rùi, bạn quay lại sau nha ^x^", 310, 200, false);
						return;
					}
					//-----------------------------------
					
					if(GameLogic.getInstance().user.GetLevel() >= obj.LevelRequire)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowBuySlotMaterial(SLOT_UNLOCK_MATERIAL+1, false);
					}
				}
				return;
			}
			
			// Xóa nguyên liệu khỏi slot
			var type:int = arr[2];			
			var slotMater:Container = GetContainer(id);
			var index:int = materSlot.indexOf(slotMater);
			usedSlot[index] = 0;
			slotMater.IdObject = SLOT_MATERIAL + arr[1];
			slotMater.ClearComponent();
			// nhét lại vào list nguyên liệu
			if (!isUsed)
			{
				var ctn:Container = listMaterial.getItemById(CTN_MATERIAL + MATERIAL + type);
				if (ctn)
				{
					var num:int = int((ctn.LabelArr[0] as TextField).text);
					num++;
					(ctn.LabelArr[0] as TextField).text = num.toString();
					listMaterial.sortById();
				}
				else
				{
					ctn = DrawMaterial(type, 1);
					//trace("typeeee", type);
					listMaterial.addItemAt(CTN_MATERIAL + MATERIAL + type.toString() , ctn, type, this);
					listMaterial.sortById();
				}
			}
			
			// tính lại các chỉ số
			CalculateRate();
		}
		
		public function UnlockSlot(isGold:Boolean):void
		{
			var ctn:Container = GetContainer(SLOT_MATERIAL + SLOT_UNLOCK_MATERIAL);
			if (ctn)
			{
				ctn.tooltip = null;
				ctn.RemoveAllImage();
				GameLogic.getInstance().user.GetMyInfo().SlotUnlock++;
				SLOT_UNLOCK_MATERIAL++;
				var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", SLOT_UNLOCK_MATERIAL);
				var gold:int = obj.Money;
				var zxu:int = obj.ZMoney;
				if(isGold)
				{
					GameLogic.getInstance().user.UpdateUserMoney( -gold);
				}
				else
				{
					GameLogic.getInstance().user.UpdateUserZMoney( -zxu);
				}
			}
		}
		
		public function doMateFish():void
		{			
			GetButton(BTN_MATE_ZXU).SetEnable(false);
			GetButton(BTN_MATE_GOLD).SetEnable(false);
			if (IsXXXing || onFlying)
			{
				return;
			}
			
			var i:int;
			var fishList:Array = [];
			var materList:Array = [];
			var isMoney:Boolean;
			var obj:Object;
			var ctn:Container;
			var count:Array = [];
			var f:Fish;
			
			for (i = 0; i <= Constant.NUM_TYPE_MATERIAL; i++)
			{
				count[i] = 0;
			}
			
			for (i = 0; i < SLOT_UNLOCK_MATERIAL; i++)
			{
				ctn = materSlot[i];
				if (ctn.IdObject.split(SEPARATE)[2])
				{
					var j:int = ctn.IdObject.split(SEPARATE)[2];
					count[j]++;					
				}
			}
			
			obj = new Object();
			obj[ConfigJSON.KEY_ID] = father.Id;
			obj["LakeId"] = father.LakeId;
			fishList.push(obj);			
			f = GameLogic.getInstance().GetFishCurLake(father.Id)
			if (f)
			{
				f.LastBirthTime = GameLogic.getInstance().ServerTime;
			}
			
			obj = new Object();
			obj[ConfigJSON.KEY_ID] = mother.Id;
			obj["LakeId"] = mother.LakeId;
			fishList.push(obj);
			f = GameLogic.getInstance().GetFishCurLake(mother.Id)
			if (f)
			{
				f.LastBirthTime = GameLogic.getInstance().ServerTime;
			}
			
			// gán lại thời điểm sinh sản cho cá trong list tất cả các hồ
			for (i = 0; i < GameLogic.getInstance().user.AllFishArr.length; i++)
			{
				obj = GameLogic.getInstance().user.AllFishArr[i];
				if(obj.Id == father.Id || obj.Id == mother.Id)
				{
					obj.LastBirthTime = GameLogic.getInstance().ServerTime;
				}
			}
			
			// update lại số nguyên liệu trong kho
			for (i = 1; i < count.length; i++)
			{
				if (count[i] > 0)
				{
					obj = new Object();
					obj["TypeId"] = i;
					obj["Num"] = count[i];
					materList.push(obj);
					GameLogic.getInstance().user.UpdateStockThing("Material", i, -count[i]);
				}
			}
			
			GameLogic.getInstance().user.GenerateNextID();
			BabyFish = null;
			var cmd:SendMateFish = new SendMateFish();
			cmd.AddNew(fishList, materList, "Money");
			Exchange.GetInstance().Send(cmd);
			
			var price:String = txtPrice.text.replace(",", "");
			GameLogic.getInstance().user.UpdateUserMoney( -int(price), true);
			
			// Play effect xxx....
			IsXXXing = true;
			var arr:Array = [];
			var img1:Sprite = Ultility.PutFishIntoCtn(father, this).img;
			img1.scaleX = img1.scaleY = father.Scale * 1.1;
			img1.rotation = 0;
			var img2:Sprite = Ultility.PutFishIntoCtn(mother, this).img;
			img2.scaleX = img2.scaleY = mother.Scale * 1.1;
			img2.rotation = 0;
			arr.push(img1);
			arr.push(img2);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffMixFish", arr, this.CurPos.x + 340, this.CurPos.y + 210,
				false, false, null, function():void{AfterEffect()});
				
			for (i = 0; i < GetContainer(CTN_SLOT_BOY).ImageArr.length; i++)
			{
				GetContainer(CTN_SLOT_BOY).ImageArr[i].img.visible = false;
			}
			for (i = 0; i < GetContainer(CTN_SLOT_GIRL).ImageArr.length; i++)
			{
				GetContainer(CTN_SLOT_GIRL).ImageArr[i].img.visible = false;
			}	
		}
		
		public function AfterEffect():void
		{
			IsXXXing = false;
			if (!IsVisible)
			{
				return;
			}
			var ctn:Container;
			RemoveFish(CTN_SLOT_BOY, true);
			RemoveFish(CTN_SLOT_GIRL, true);
			for (var i:int = 0; i < SLOT_UNLOCK_MATERIAL; i++)
			{
				ctn = materSlot[i];
				RemoveMaterial(ctn.IdObject, true);
			}
			if (!IsXXXing && ReceivedMatePacket)
			{
				MakeBabyFish();
			}
		}
		
		public function ProcessMateFish(f:Fish):void
		{
			ReceivedMatePacket = true;
			BabyFish = f;
			if (!IsXXXing && ReceivedMatePacket)
			{
				MakeBabyFish();
			}
		}
		
		private function MakeBabyFish():void
		{
			if (!this.IsVisible)
			{
				return;
			}
			
			if (!BabyFish)
			{
				return;
			}
			var mc:Sprite = Ultility.PutFishIntoCtn(BabyFish, this).img;
			mc.scaleX = mc.scaleY = BabyFish.Scale;
			mc.rotation = 0;
			img.addChild(mc);
			var pS:Point = new Point(333, 227);
			mc.x = pS.x;
			mc.y = pS.y;
			var pD:Point = new Point(listResult.x + 27, listResult.y + 32);
			TweenMax.to(mc, 0.75, { bezier:[{ x:pD.x, y:pD.y }], ease:Expo.easeOut, onComplete:onFinishMakeFish, onCompleteParams:[mc] } );	
		}
		
		private function onFinishMakeFish(mc:Sprite):void 
		{
			if (!this.IsVisible)
			{
				return;
			}
			
			if(mc.parent)
			{
				mc.parent.removeChild(mc);
			}
			BabyFish.img.scaleX = BabyFish.img.scaleY = BabyFish.Scale;
			BabyFish.img.rotation = 0;
			BabyFish.img.mouseEnabled = false;
			BabyFish.img.mouseChildren = false;
			var ctn:Container = new Container(listResult, "ctnFishResult");
			var ctnSizeX:int = ctn.img.width;
			var ctnSizeY:int = ctn.img.height;
			//Hàm đổi màu ảnh của Image sẽ được gọi trong lớp Image khi loadRes và reloadRes
			var setInfo:Function = function():void
			{
				//var a:Array = Config.getInstance().GetFishColor(obj["FishTypeId"], obj["ColorLevel"]);
				var a:Array = Config.getInstance().GetFishColor(BabyFish.FishTypeId, BabyFish.ColorLevel);
				var i:int;
				var c:ColorTransform;

				for (i = 0; i < a.length; i++)
				{
					var object:Object = a[i];
					c = new ColorTransform(1, 1, 1, 1, object["Red"], object["Green"], object["Blue"], object["Alpha"]);
					this.ChangeColor(c, object["Key"]);
				}
				
				this.SetScaleX(BabyFish.Scale);
				this.SetScaleY(BabyFish.Scale);
				
				var v:int = 18;
				if (this.img.width > ctnSizeX || this.img.height > ctnSizeY)
				{
					(this as Image).FitRect(ctnSizeX - v, ctnSizeY - v, new Point(v/2, v/2));
				}				
			}
			var imgFish:Image = ctn.AddImage("", BabyFish.ImgName, ctn.img.width/2, ctn.img.height/2, true, Image.ALIGN_LEFT_TOP, false, setInfo);
			
			var aboveContent:Sprite;
			if(BabyFish.FishType == Fish.FISHTYPE_SPECIAL)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSizeX || aboveContent.height > ctnSizeY)
				{
					aboveContent.width = ctnSizeX - 10;
					aboveContent.height = ctnSizeY - 10;
				}
				ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 - 10, ctn.img.height / 2 + 8);
			}
			else if(BabyFish.FishType == Fish.FISHTYPE_RARE)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSizeX || aboveContent.height > ctnSizeY)
				{
					aboveContent.width = ctnSizeX - 10;
					aboveContent.height = ctnSizeY - 10;
				}
				ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 - 10, ctn.img.height / 2 + 8);			
				var cl:int = BabyFish.getAuraColor();
				TweenMax.to(imgFish.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
			}
			
			
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "cá con xinh xắn";
			ctn.setTooltip(tip);
			listResult.addItemAt(CTN_RESULT + BabyFish.Id, ctn, 0, this);
			
			// feed cá quý, cá đặc biệt
			if (BabyFish.FishType == Fish.FISHTYPE_SPECIAL)
			{
				//GuiMgr.getInstance().GuiFeedWall.SetRareInfo(BabyFish.FishTypeId, BabyFish.ColorLevel);
				GuiMgr.getInstance().GuiFeedWall.SetFishType(BabyFish.FishTypeId);
				GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SPECIAL_FISH);
			}
			else if (BabyFish.FishType == Fish.FISHTYPE_RARE)
			{
				//GuiMgr.getInstance().GuiFeedWall.SetRareInfo(BabyFish.FishTypeId, BabyFish.ColorLevel);
				GuiMgr.getInstance().GuiFeedWall.SetFishType(BabyFish.FishTypeId);
				GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_RARE_FISH);
			}
			else
			{
				// feed cá mới			
				var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, BabyFish.FishTypeId);
				var item_name:String = Localization.getInstance().getString("Fish" + BabyFish.FishTypeId);
				if (obj.UnlockType == GUIShop.UNLOCK_TYPE_MIX && GameLogic.getInstance().user.CheckFishUnlocked(BabyFish.FishTypeId) == 0)
				{
					GuiMgr.getInstance().GuiFeedWall.SetFishType(BabyFish.FishTypeId);
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_NEW_FISH, item_name);
				}
				else 
				{
					// feed	vượt cấp
					if (BabyFish.Level > maxLevel)
					{
						GuiMgr.getInstance().GuiFeedWall.SetFishType(BabyFish.FishTypeId);
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MIX_OVER_LEVEL, item_name);
					}
				}
			}
			
			// unlock cá trong shop
			var fish:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, BabyFish.FishTypeId);
			if (fish.UnlockType == GUIShop.UNLOCK_TYPE_MIX && GameLogic.getInstance().user.CheckFishUnlocked(BabyFish.FishTypeId) == 0)
			{
				GameLogic.getInstance().user.AddFishUnlock(BabyFish.FishTypeId, GUIShop.UNLOCK_TYPE_MIX);
			}
		}
		
		public function CalculateRate():void
		{
			if (IsXXXing)
			{
				return;
			}
			var rateUp:Number = 0;
			var rateSpecial:Number = 0;
			var rateRare:Number = 0;
			var i:int;
			var price:int = 0;
			
			// Cộng chỉ số của nguyên liệu
			var count:Array = [];
			var slotMater:Container;
			var obj:Object;
			for (i = 0; i <= Constant.NUM_TYPE_MATERIAL; i++)
			{
				count[i] = 0;
			}			
			for (i = 0; i < SLOT_UNLOCK_MATERIAL; i++)
			{
				slotMater = materSlot[i];
				if (slotMater.IdObject.split(SEPARATE)[2])
				{
					var j:int = slotMater.IdObject.split(SEPARATE)[2];
					count[j]++;
				}
			}
			for (i = 1; i <= count.length; i++)
			{
				if(count[i] > 0)
				{
					//obj = ConfigJSON.getInstance().getOptionMaterial(i);
					//rateUp += obj["Uplevel"] * count[i];
					//rateSpecial += obj["Special"] * count[i];
					//rateRare += obj["Rare"] * count[i];
				}
			}
			
			// Cộng chỉ số của cá bố mẹ
			price = 0;
			if (father)
			{
				rateSpecial += Number(father.RateMate["Special"]);
				rateRare += Number(father.RateMate["Rare"]);
				if (father.RateOption && father.RateOption[Fish.OPTION_MIX_RARE])
				{
					rateRare += father.RateOption[Fish.OPTION_MIX_RARE]
				}
			}
			if (mother)
			{
				rateSpecial += Number(mother.RateMate["Special"]);
				rateRare += Number(mother.RateMate["Rare"]);
				if (mother.RateOption && mother.RateOption[Fish.OPTION_MIX_RARE])
				{
					rateRare += mother.RateOption[Fish.OPTION_MIX_RARE]
				}
			}
			
			// bonus thêm tỉ lệ vượt cấp nếu level người chơi > level cá
			if (father && mother)
			{
				var f:Fish = (father.Level < mother.Level) ? father : mother;
				rateUp += Number(f.RateMate["Uplevel"]);
				var minLevel:int = (father.Level < mother.Level) ? father.Level : mother.Level;
				maxLevel = (father.Level > mother.Level) ? father.Level : mother.Level;				
				if (minLevel <= 17)
				{
					var bonus:Number = PERCENT_UNEQUAL_LEVEL * (GameLogic.getInstance().user.GetLevel() - minLevel);
					if (bonus > PERCENT_UNEQUAL_LEVEL_MAX)
						bonus = PERCENT_UNEQUAL_LEVEL_MAX;
					rateUp += bonus;		// tăng khi lai cá cấp thấp
				}
				else
				{
					if (minLevel > GameLogic.getInstance().user.GetLevel())
					{
						var minus:Number = (minLevel - GameLogic.getInstance().user.GetLevel()) * 2;
						rateUp -= minus;	// giảm khi lai cá cấp cao
					}
				}				
				rateUp = Math.min(rateUp, ConfigJSON.getInstance().getItemInfo("MixFish", f.FishTypeId).MaxOverLevel);
				if (rateUp < 0 || minLevel >= GameLogic.getInstance().user.GetLevel() + MAX_OVER_LEVEL)
				{
					rateUp = 0
				}
				// Tính giá lai
				var maxLevelBabyFish:int = Math.min(GameLogic.getInstance().user.GetLevel() + MAX_OVER_LEVEL, minLevel + 2);
				var minLevelBabyFish:int = minLevel;
				var listFish:Object = ConfigJSON.getInstance().GetItemList("MateFishCost");
				
				var maxPrice:int = listFish[minLevelBabyFish];
				for (i = minLevelBabyFish; i <= maxLevelBabyFish; i++)
				{
					if (listFish[i] > maxPrice)
					{
						maxPrice = listFish[i];
					}
				}
				price = maxPrice;
			}		
			
			// set giá trị cho các thanh chỉ số		
			prgUplevel.setStatus(rateUp/100);
			prgSpecial.setStatus(rateSpecial/100);
			prgRare.setStatus(rateRare/100);
			
			// Hiển thị số %
			rateUp = int(Math.round(rateUp * 10000)) / 10000;
			rateSpecial = int(Math.round(rateSpecial * 10000)) / 10000;
			rateRare = int(Math.round(rateRare * 10000)) / 10000;
			if (rateUp > 100) rateUp = 100;
			if (rateSpecial > 100) rateSpecial = 100;
			if (rateRare > 100) rateRare = 100;
			
			txtUplevel.text = (rateUp).toString() + "%";		
			txtSpecial.text = (rateSpecial).toString() + "%";		
			txtRare.text = (rateRare).toString() + "%";
			
			// giá lai
			txtPrice.text = Ultility.StandardNumber(price);
			
			if (father && mother && GameLogic.getInstance().user.GetMoney() >= price)
			{
				GetButton(BTN_MATE_GOLD).SetEnable(true);
			}
			else
			{
				GetButton(BTN_MATE_GOLD).SetEnable(false);
			}
			
		}
	}

}