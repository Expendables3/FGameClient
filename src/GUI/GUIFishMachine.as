package GUI 
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import Logic.Balloon;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Lake;
	import Logic.Pocket;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendBuyFairyDrop;
	import NetworkPacket.PacketSend.SendExchangeFairyDrop;
	
	/**
	 * Máy hút cá.
	 * @author HiepNM
	 */
	public class GUIFishMachine extends BaseGUI 
	{
		//thuộc tính gui
		//const
		public static const SEPARATE:String = "_";
		private const GUI_FISHMAC_BTN_CLOSE:String = "btnClose";
		private const GUI_FISHMAC_BTN_GUIDE:String = "btnGuide";
		private const GUI_FISHMAC_BTN_NEXT_FISH:String = "btnNextFish";
		private const GUI_FISHMAC_BTN_PREV_FISH:String = "btnPrevFish";
		private const GUI_FISHMAC_BTN_CRUSH_FISH:String = "btnCrushFish";
		private const GUI_FISHMAC_BTNEX_BOARD_SCR:String = "markboardScr";
		private const GUI_FISHMAC_BTNEX_BOARD_DES:String = "markboardDes";
		
		private const BUFF_TYPE_EXP:String = "Exp";
		private const BUFF_TYPE_MIXFISH:String = "MixFish";
		private const BUFF_TYPE_MIXSPECIAL:String = "MixSpecial";
		private const BUFF_TYPE_MONEY:String = "Money";
		private const BUFF_TYPE_TIME:String = "Time";
		
		//var
		private var lstXFish:ListBox;			//danh sách cá quý
		private var lstThing:Array = [];
		private var btnClose:Button;
		private var btnGuide:Button;
		private var btnNext:Button;
		private var btnPrev:Button;		
		private var btnCrush:Button;
		private var btnBoardScr:ButtonEx;
		private var btnBoardDes:ButtonEx;
		private var txtPearlSrc:TextField;
		private var txtPearlDes:TextField;
		private var _format:TextFormat;
		private var _format2:TextFormat;
		private var _tooltip:TooltipFormat;
		private var strTooltipBoardScr:String;
		private var strTooltipBoardDes:String;
		private var effCrushFish:SwfEffect;
		private var imgIdle:Image;
		
		//thuộc tính logic
		private const BEGIN_ROW_Y:int = 360;
		private const BEGIN_ROW_X:int = 335;
		private const HEIGHT_ROW:int = 35;
		private const WIDTH_ROW:int = 545;
		private const BUFF_ROW:int = HEIGHT_ROW + 39;
		private var FishXArr:Array = [];
		private var curPoint:int;
		private var curFish:Fish;
		private var curThing:String;
		private var _user:User;
		
		private var _stPoint:Number;
		private var _tgPoint:Number;
		
		private var isEffCrushRunning:Boolean = false;
		private var bFinishEff:Boolean = false;
		private var isEffBuyRunning:Boolean = false;
		private var isRecData:Boolean;
		
		public function GUIFishMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIFisMachine";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//khởi tạo thuộc tính logic
				_user = GameLogic.getInstance().user;
				_format = new TextFormat();
				_format.size = 14;
				_format.color = 0xFFFFFF;
				_format2 = new TextFormat();
				_format2.size = 14;
				_format2.bold = true;
				_format2.color = 0xFF0000;
				strTooltipBoardScr = Localization.getInstance().getString("Tooltip57");
				strTooltipBoardDes = Localization.getInstance().getString("Tooltip58");
				FishXArr = [];
				
				
				SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
				AddBgr();
				//khởi tạo về danh sách cá và danh sách hàng hóa
				InitXFishList(_user.AllFishArr, true);
				ShowByJson();
			}
			//khởi tạo GUI
			LoadRes("GuiFishMachine_Theme");
		}
		
		/**
		 * add những gì liên quan đến GUI
		 */
		public function AddBgr():void
		{
			//hệ ảnh
			AddImage("", "GuiFishMachine_ImgTitleFM", 200, 34);
			AddImage("", "GuiFishMachine_ImgMachineBoard", 49 + 102 +200 - 10, 82 + 295 - 193 + 10);	//bảng chứa cái máy
			imgIdle = AddImage("", "GuiFishMachine_ImgMachine", 328, 170);						//ảnh cái máy
			btnBoardDes = AddButtonEx("markboardDes", "GuiFishMachine_ImgMarkBoard", 476 + 35 - 35, 268 - 13);					//bảng chứa ngọc của con cá
			btnBoardScr = AddButtonEx("markboardScr", "GuiFishMachine_ImgMarkBoard", 161 + 35 - 35, 268 - 13);				//bảng chứa ngọc hiện có
			//số ngọc của cá và người chơi
			txtPearlDes = AddLabel(_user.GetFairyDrop().toString(), 500 - 41, 260);
			txtPearlSrc = AddLabel("0", 145, 260);
			txtPearlDes.setTextFormat(_format);
			txtPearlSrc.setTextFormat(_format);
			//hệ nút bấm
			btnClose = AddButton(GUI_FISHMAC_BTN_CLOSE, "BtnThoat", 685 - 33, 18);
			btnGuide = AddButton(GUI_FISHMAC_BTN_GUIDE, "GuiFishMachine_BtnGuide", 685 - 75, 18);
			btnCrush = AddButton(GUI_FISHMAC_BTN_CRUSH_FISH, "GuiFishMachine_BtnExchangePearl", 343, 263);
			//list cá
			lstXFish = AddListBox(ListBox.LIST_X, 1, 1, 10, 10);		//list Fish
			lstXFish.setPos(114 , 125);
			//tootip
			SetToolTipBoardPoint(GUI_FISHMAC_BTNEX_BOARD_DES);
		}
		/**
		 * thực hiện refesh lại toàn bộ GUI
		 * refesh về hàng hóa, danh sách cá, hệ nút bấm
		 */
		public function RefreshComponent():void
		{
			isEffBuyRunning = false;
			isEffCrushRunning = false;
			ClearComponent();
			FishXArr = [];
			AddBgr();
			//khởi tạo về danh sách cá và danh sách hàng hóa
			InitXFishList(_user.AllFishArr, true);
			ShowByJson();
		}
		
		
		/**
		 * thực hiện lấy, add item vào theo đúng file JSon
		 */
		public function ShowByJson():void
		{
			//lấy tất cả hàng về
			var total:Object = ConfigJSON.getInstance().getItemInfo("FishMachineExchange");
			var itemArr:Array = [];
			var row:int = 0;//trỏ đến dòng hàng hiện tại
			
			/*phần này nó không theo đúng thứ tự Material, EnergyItem, RebornMedicien nên phải add tay*/
			row++;
			itemArr = getListFM(total, "Material");
			AddRow(row, itemArr);
			
			row++;
			itemArr = getListFM(total, "EnergyItem");
			AddRow(row, itemArr);
			
			row++;
			itemArr = getListFM(total, "RebornMedicine");
			AddRow(row, itemArr);
		}
		
		/**
		 * add hàng vào row
		 * @param	row: số thứ tự của row
		 * @param	ItemArr: hàng cần add vào row
		 */
		public function AddRow(row:int, ItemArr:Array):void
		{
			var i:int;
			var len:int = ItemArr.length;
			//add vao 1 list Box
			AddImage("idRow" + row.toString(), "GuiFishMachine_ImgRowSpecial", BEGIN_ROW_X, BEGIN_ROW_Y + (row - 1) * BUFF_ROW);
			var lstRow:ListBox = AddListBox(ListBox.LIST_X, 1, 6, 20, 0);
			lstRow.IdObject = "lst" + row.toString();
			lstRow.setPos(75, (row - 1) * BUFF_ROW + 300);
			lstThing.push(lstRow);
			
			for (i = 0; i < len; i++)
			{
				AddThing(row, ItemArr[i], lstRow);
			}
			
			//trong trường hợp có thêm config
			if (len > 6)
			{//Hiển thị 2 nút next và back
				var btnCurBack:Button = AddButton("idBtnRow_" + row.toString() + "_back", "GuiFishMachine_BtnBackFish", 40, (row - 1) * BUFF_ROW + 20 + 322);
				btnCurBack.SetDisable();
				AddButton("idBtnRow_" + row.toString() + "_next", "GuiFishMachine_BtnNextFish", 40 + WIDTH_ROW + 30, (row - 1) * BUFF_ROW + 20 + 322);
			}
		}
		
		/**
		 * add hàng vào row nè, có set là mua được không để disable hợp lý nhá.
		 * @param	row : row nào?
		 * @param	item: hàng gì
		 * @param	listRow: cái listBox cần add item đó vào
		 */
		public function AddThing(row:int, item:Object, listRow:ListBox):void
		{
			var ctn:Container = new Container(listRow, "GuiFishMachine_CtnThing");//container chứa đồ
			var ctnSize:Point = new Point(ctn.img.width, ctn.img.height);
			var suffixId:String = "lst" + row.toString() + 		//1: IdListBox
									SEPARATE + item.type + 		//2: type
									SEPARATE +  item.Id + 		//3: id
									SEPARATE + item.ItemType + 	//4: itemType
									SEPARATE +item.ItemId + 	//5: itemId
									SEPARATE + item.Point ;		//6: Point
			var CtnId:String = "ctn" + SEPARATE + suffixId;
			var btnExId:String = "btnEx" + SEPARATE + suffixId;
			ctn.IdObject = CtnId;
			ctn.AddImage("", "GuiFishMachine_ImgDisc", 28 , 60);							//add vào cái đĩa để đồ
			if (item["UnlockType"] == 1)
			{
				ctn.AddImage("", "GuiFishMachine_ImgPriceTable", 25, 80);
				ctn.AddImage("", "GuiFishMachine_ImgPearl", 43, 80);
				var lblPrice:TextField = ctn.AddLabel(item.Point, -30, 70);
				var format:TextFormat = new TextFormat();
				format.color = 0xFFFFFF;
				format.size = 13;
				lblPrice.setTextFormat(format);
			}
			
			
			var btnEx:ButtonEx = ctn.AddButtonEx(btnExId, item.ItemType + item.ItemId, 29, 42,this);//add hàng vào container
			if (!CheckPoint(item.Point) || item["UnlockType"] == 6)
			{
				btnEx.SetDisable2();
			}
			var align1:String = ALIGN_LEFT_TOP;
			if (item.ItemType == "EnergyItem" || item.ItemType == "RebornMedicine"||item.ItemType=="MagicBag")
			{
				align1 = ALIGN_CENTER_CENTER;
				btnEx.SetAlign(align1);
			}
			//tooltip
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = GetToolTip(item);
			var iEnd:int = tooltip.text.search("\r");
			tooltip.setTextFormat(_format2, 0, iEnd);
			btnEx.setTooltip(tooltip);
			
			listRow.addItem(CtnId, ctn, null);
		}
		
		/**
		 * Lấy về danh sách item của 1 row
		 * @param	total: tất cả các hàng dùng trong gui này
		 * @param	ListName: tên của row
		 * @return mảng item
		 */
		private function getListFM(total:Object, ListName:String):Array
		{
			var a:Array = [];
			var i:String;
			for (i in total[ListName])
			{
				if (i != "Id" && i != "Name" && i != "type")
				{
					var o:Object = new Object();
					o["Id"] = i;
					o["type"] = ListName;
					o["ItemId"] = total[ListName][i]["ItemId"];
					o["ItemType"] = total[ListName][i]["ItemType"];
					o["Num"] = total[ListName][i]["Num"];
					o["Point"] = total[ListName][i]["Point"];
					o["UnlockType"] = total[ListName][i]["UnlockType"];
					a.push(o);
				}
			}
			return a;
		}
		
		/**
		 * lấy tooltip của một đồ mua
		 * @param	item: đồ mua cần lấy tooltip
		 * @return tooltip.text
		 */
		public function GetToolTip(item:Object):String
		{
			var str:String;
			var sReplace:String;
			switch(item.ItemType)
			{
				case "Material":
					str = Localization.getInstance().getString("Tooltip52");
					sReplace = item.ItemId.toString();
					str = str.replace("@LevelMaterial", sReplace);
					break;
				case "EnergyItem":
					str = Localization.getInstance().getString("Tooltip53");
					switch(item.ItemId)
					{
						case 1:
							sReplace = "1";
							break;
						case 2:
							sReplace = "5";
							break;
						case 3:
							sReplace = "10";
							break;
						case 4:
							sReplace = "50";
							break;
					}
					str = str.replace("@EnergyType", sReplace);
					str = str.replace("@EnergyUp", sReplace);
					break;
				case "RebornMedicine":
					str = Localization.getInstance().getString("Tooltip54");
					switch(item.ItemId)
					{
						case 1:
							sReplace = "5 phút";
							break;
						case 2:
							sReplace = "5 tiếng";
							break;
						case 3:
							sReplace = "7 ngày";
					}
					str = str.replace("@Time", sReplace);
					str = str.replace("@Time", sReplace);
					break;
				case "MagicBag":
				{
					str = GetTooltipMagicBag(item.ItemId, item.UnlockType);
					break;
				}
			}
			return str;
		}
		
		/**
		 * Vẽ một con cá vào container
		 * @param	f: con cá cần vẽ vào
		 * @return container chứa con cá đó
		 */
		public function DrawCtnXFish(f:Fish):Container
		{
			var ctn:Container = new Container(lstXFish, "GuiFishMachine_CtnFish2");
			ctn.SetScaleXY(1.2);
			var ctnSize:Point = new Point(ctn.img.width, ctn.img.height);
			var aboveContent:Sprite;
			var imgFish:Image = Ultility.PutFishIntoCtn(f, ctn, ctn.img.width / 2, ctn.img.height / 2);
			var domain:int = -1;
			var imgDomain:Image;
			if (f.FishTypeId >= Constant.FISH_TYPE_DISTANCE_DOMAIN)
			{
				domain = (f.FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
			}
			if(f.FishType == Fish.FISHTYPE_SPECIAL)
			{
				aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10;
					aboveContent.height = ctnSize.y - 10;
				}
				ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 -10, ctn.img.height / 2 + 8);
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
			if (domain > 0)
			{
				aboveContent = ResMgr.getInstance().GetRes(Fish.DOMAIN + domain) as Sprite;
				if (aboveContent.width > ctnSize.x || aboveContent.height > ctnSize.y)
				{
					aboveContent.width = ctnSize.x - 10 ;
					aboveContent.height = ctnSize.y - 10;
				}
				imgDomain = ctn.AddImageBySprite(aboveContent, ctn.img.width / 2, 5);
				imgDomain.FitRect(30, 30, new Point(ctn.img.width / 2 + 15, -5));
			}
			return ctn;
		}
		
		/**
		 * Khởi tạo mảng cá: thực hiện add các con cá và list box để dễ quản lý
		 * @param	arrFish: mảng cá logic
		 * @param	init : nếu init = true thì hàm đc gọi lúc khởi tạo gui, nếu init = false nghĩa là update danh sách cá sau khi hút
		 */
		public function InitXFishList(arrFish:Array,init:Boolean = false):void
		{
			//init rare fish array
			var i:int = 0;
			var ctn:Container;
			var f:Fish;
			var imgName:String;
			var growth:Number;
			for (i = 0; i < arrFish.length; i++)
			{
				if ((arrFish[i].FishType == Fish.FISHTYPE_RARE || arrFish[i].FishType == Fish.FISHTYPE_SPECIAL) && arrFish[i].RateOption)//nếu thuộc loại cá quý vaf cá đặc biệt thì add vào FishXArr
				{
					imgName = Fish.ItemType + arrFish[i].FishTypeId + SEPARATE + Fish.OLD + SEPARATE + Fish.IDLE;
					f = new Fish(this.img, imgName);
					f.SetInfo(arrFish[i]);
					f.Init(0, 0);
					//GuiMgr.getInstance().GuiMixFish.UpdateHavertTime(f);
					Ultility.updateHarvestTime(f);
					//f.UpdateHavestTime();
					growth = f.Growth();
					if (growth < 0 || f.IsEgg)	//nếu là trứng thì ko add vào
					{
						continue;
					}
					else if (growth < 1)	//nếu còn bé thì ko add vào
					{
						f.Destructor();
						continue;
					}
					f.RefreshEmotion();
					f.Hide();
					FishXArr.push(f);
					ctn = DrawCtnXFish(f);
					var sTitle :String = Localization.getInstance().getString("Tooltip59");
					var sNameFish:String;
					var sTypeFish:String = "Thường thôi";
					var sContent:String = "";
					sNameFish = Localization.getInstance().getString(Fish.ItemType + f.FishTypeId);
					sTitle = sTitle.replace("@Name", sNameFish);
					if (f.FishType == Fish.FISHTYPE_RARE)
					{
						sTypeFish = "Quý";
					}
					else
					{
						sTypeFish = "Đặc biệt";
					}
					sTitle = sTitle.replace("@Type", sTypeFish);
					if (f.RateOption[BUFF_TYPE_EXP])
					{
						sContent += "\n" + Localization.getInstance().getString("TooltipFM" + BUFF_TYPE_EXP);
						sContent = sContent.replace("@num", f.RateOption[BUFF_TYPE_EXP]);
					}
					if (f.RateOption[BUFF_TYPE_MONEY])
					{
						sContent += "\n" + Localization.getInstance().getString("TooltipFM" + BUFF_TYPE_MONEY);
						sContent = sContent.replace("@num", f.RateOption[BUFF_TYPE_MONEY]);
					}
					if (f.RateOption[BUFF_TYPE_TIME])
					{
						sContent += "\n" + Localization.getInstance().getString("TooltipFM" + BUFF_TYPE_TIME);
						sContent = sContent.replace("@num", f.RateOption[BUFF_TYPE_TIME]);
					}
					if (f.RateOption[BUFF_TYPE_MIXSPECIAL])
					{
						sContent += "\n" + Localization.getInstance().getString("TooltipFM" + BUFF_TYPE_MIXSPECIAL);
						sContent = sContent.replace("@num", f.RateOption[BUFF_TYPE_MIXSPECIAL]);
					}
					if (f.RateOption[BUFF_TYPE_MIXFISH])
					{
						sContent += "\n" + Localization.getInstance().getString("TooltipFM" + BUFF_TYPE_MIXFISH);
						sContent = sContent.replace("@num", f.RateOption[BUFF_TYPE_MIXFISH]);
					}
					
					//for (var si:String in f.RateOption)
					//{
						//sContent += "\n" + Localization.getInstance().getString("TooltipFM" + si);
						//sContent = sContent.replace("@num", f.RateOption[si]);
					//}
					
					var tooltipFish:TooltipFormat = new TooltipFormat();
					tooltipFish.text = sTitle + sContent;
					ctn.setTooltip(tooltipFish);
					lstXFish.addItem(f.Id.toString(), ctn, this);
				}
			}
			if (FishXArr.length > 1)
			{
				btnNext = AddButton(GUI_FISHMAC_BTN_NEXT_FISH, "GuiFishMachine_BtnNextFish", 270, 151);	//2 cai nut next va prev
				btnPrev = AddButton(GUI_FISHMAC_BTN_PREV_FISH, "GuiFishMachine_BtnBackFish", 103, 151);
				btnPrev.SetDisable();
				
			}
			if (FishXArr.length > 0)
			{
				btnCrush.SetEnable();
				var stPoint:Number = GetPoint(FishXArr[lstXFish.curPage]);
				var tgPoint:Number = stPoint + stPoint * 0.1;
				txtPearlSrc.text = Math.round(stPoint).toString() + " - " + Math.ceil(tgPoint).toString();
				//if (Math.round(stPoint) == Math.round(tgPoint))
					//txtPearlSrc.text = Math.round(stPoint).toString();
				txtPearlSrc.setTextFormat(_format); 
				SetToolTipBoardPoint(GUI_FISHMAC_BTNEX_BOARD_SCR);
			}
			else
			{
				
				btnCrush.SetDisable();
			}
			
		}
		
		public function SetToolTipBoardPoint(sWhere:String):void
		{
			_tooltip = new TooltipFormat();
			var btnEx:ButtonEx = GetButtonEx(sWhere);
			var sReplace:String;
			var str:String;
			switch(sWhere)
			{
				case GUI_FISHMAC_BTNEX_BOARD_SCR:
					str = strTooltipBoardScr;
					var stPoint:Number = GetPoint(FishXArr[lstXFish.curPage]);
					var tgPoint:Number = stPoint + stPoint * 0.1;
					sReplace = Math.round(stPoint).toString();
					str = str.replace("@num", sReplace);
					sReplace = Math.ceil(tgPoint).toString();
					str = str.replace("@num", sReplace);
					break;
				case GUI_FISHMAC_BTNEX_BOARD_DES:
					str = strTooltipBoardDes;
					sReplace = txtPearlDes.text;
					str = str.replace("@num", sReplace);
					break;
			}
			_tooltip.text = str;
			btnEx.setTooltip(_tooltip);
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search("btnEx_") >= 0)
			{
				var data:Array = buttonID.split(SEPARATE);
				var lstId:String = data[1];
				var suffixId:String = data[1] + SEPARATE + 
										data[2] + SEPARATE + 
										data[3] + SEPARATE + 
										data[4] + SEPARATE +
										data[5] + SEPARATE +
										data[6];
				var ctnId:String = "ctn_" + suffixId;
				var lst:ListBox = GetListBox(lstId);
				var con:Container = lst.getItemById(ctnId);
				var btnX:ButtonEx = con.GetButtonEx(buttonID);
				Mouse.cursor = "auto";
				GameLogic.getInstance().MouseTransform("");
				
				if(btnX.isEnable)
					btnX.SetHighLight(-1);
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search("btnEx_") >= 0)
			{
				var data:Array = buttonID.split(SEPARATE);
				var lstId:String = data[1];
				var suffixId:String = data[1] + SEPARATE + 
										data[2] + SEPARATE + 
										data[3] + SEPARATE + 
										data[4] + SEPARATE +
										data[5] + SEPARATE +
										data[6];
				var ctnId:String = "ctn_" + suffixId;
				var lst:ListBox = GetListBox(lstId);
				var con:Container = lst.getItemById(ctnId);
				var btnX:ButtonEx = con.GetButtonEx(buttonID);
				//GameLogic.getInstance().MouseTransform("imgHand");;
				Mouse.cursor = "button";
				GameLogic.getInstance().MouseTransform("ImgXeHang1");
				if(btnX.isEnable)
					btnX.SetHighLight();
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case GUI_FISHMAC_BTN_CLOSE:
					Hide();
					break;
				case GUI_FISHMAC_BTN_GUIDE:
					ShowGuide();
					break;
				case GUI_FISHMAC_BTN_NEXT_FISH:
					lstXFish.showNextPage();
					GetButton(GUI_FISHMAC_BTN_PREV_FISH).SetEnable(true);
					if (lstXFish.curPage == lstXFish.getNumPage() - 1)
						GetButton(GUI_FISHMAC_BTN_NEXT_FISH).SetEnable(false);
					else
						GetButton(GUI_FISHMAC_BTN_NEXT_FISH).SetEnable(true);
					
					var stPoint:Number = GetPoint(FishXArr[lstXFish.curPage]);
					var tgPoint:Number = stPoint + stPoint * 0.1;
					txtPearlSrc.text = Math.round(stPoint).toString() + " - " + Math.ceil(tgPoint).toString();
					//if (Math.round(stPoint) == Math.round(tgPoint))
						//txtPearlSrc.text = Math.round(stPoint).toString();
					txtPearlSrc.setTextFormat(_format);
					SetToolTipBoardPoint(GUI_FISHMAC_BTNEX_BOARD_SCR);
					break;
				case GUI_FISHMAC_BTN_PREV_FISH:
					lstXFish.showPrePage();
					GetButton(GUI_FISHMAC_BTN_NEXT_FISH).SetEnable(true);
					if (lstXFish.curPage == 0)
						GetButton(GUI_FISHMAC_BTN_PREV_FISH).SetEnable(false);
					else
						GetButton(GUI_FISHMAC_BTN_PREV_FISH).SetEnable(true);
					stPoint = GetPoint(FishXArr[lstXFish.curPage]);
					tgPoint = stPoint + stPoint * 0.1;
					txtPearlSrc.text = Math.round(stPoint).toString() + " - " + Math.ceil(tgPoint).toString();
					//if (Math.round(stPoint) == Math.round(tgPoint))
						//txtPearlSrc.text = Math.round(stPoint).toString();
					txtPearlSrc.setTextFormat(_format);
					SetToolTipBoardPoint(GUI_FISHMAC_BTNEX_BOARD_SCR);
					break;
				case GUI_FISHMAC_BTN_CRUSH_FISH:
				{
					DoCrushFish1();
					break;
				}
				default:
				{
					DoSomeThing(buttonID);
				}
			}
		}
		
		public function ShowGuide():void
		{
			GuiMgr.getInstance().GuiGuideFishMac.Show(Constant.GUI_MIN_LAYER, 3);
		}
		public function DoSomeThing(sData:String):void
		{
			var data:Array = sData.split("_");
			var work:String = data[0];
			switch (work)
			{
				case "idBtnRow":	//nút bấm
					ProcessList(data[1],data[2]);
					break;
				case "btnEx":
					BuySomeThing1(sData);
					break;
				default:
			}
		}
		
		/**
		 * thực hiện xử lý các nút next và back của các list hàng
		 * @param	idRow: hàng nào?
		 * @param	direction: nút "next" hay nút "back"
		 */
		public function ProcessList(idRow:String, direction:String):void
		{
			var side:String;
			var idButtonSide:String = "idBtnRow" + SEPARATE + idRow + SEPARATE;
			var idButton:String = "idBtnRow" + SEPARATE + idRow + SEPARATE + direction;
			var idListBox:String = "lst" + idRow;
			var curList:ListBox = GetListBox(idListBox);
			if (direction == "next")
			{
				side = "back";
				idButtonSide += side;
				curList.showNextPage();
				GetButton(idButtonSide).SetEnable(true);
				if (curList.curPage == curList.getNumPage() - 1)
					GetButton(idButton).SetEnable(false);
				else
					GetButton(idButton).SetEnable(true);
			}
			else if (direction == "back")
			{
				side = "next";
				curList.showPrePage();
				GetButton(idButtonSide).SetEnable(true);
				if (curList.curPage == 0)
					GetButton(idButton).SetEnable(false);
				else
					GetButton(idButton).SetEnable(true);
			}
		}
		
		/**
		 * mua đồ vật gì đó ở shop, nhưng chưa bít có thành công hay chưa
		 * @param	sData: thông tin về đồ vật
		 */
		public function BuySomeThing1(sData:String):void
		{
			var data:Array = sData.split("_");
			var lstId:String = data[1];
			var suffixId:String = data[1] + SEPARATE + 
									data[2] + SEPARATE + 
									data[3] + SEPARATE + 
									data[4] + SEPARATE +
									data[5] + SEPARATE +
									data[6];
			var ctnId:String = "ctn_" + suffixId;
			var lst:ListBox = GetListBox(lstId);
			var con:Container = lst.getItemById(ctnId);
			var btnX:ButtonEx = con.GetButtonEx(sData);
			if (!btnX.isEnable)
			{
				return;
			}
			var Type:String = data[2];
			var Id:int = (int)(data[3]);
			var itemType:String = data[4];			//đồ mua được
			var itemId:int = (int)(data[5]);
			var itemPoint:int = (int)(data[6]);
			//trace("Mua đồ " + sData);
			
			if (CheckPoint(itemPoint))
			{
				//send lên server
				var cmd:SendBuyFairyDrop = new SendBuyFairyDrop(Type, Id);
				Exchange.GetInstance().Send(cmd);
				//show luôn effect mua thành công
				EffectMgr.setEffBounceDown("Mua thành công", itemType + itemId, 330, 280);
				//và effect tru diem
				ShowEffPoint( -itemPoint,false);
				//trừ điểm luôn xem nào
				_user.UpdateFairyDrop( -itemPoint);
				//cập nhật đồ vào kho
				_user.UpdateStockThing(itemType, itemId, 1);
			}
			if(!isEffCrushRunning)
				RefreshComponent();
		}
		
		/**
		 * Thực hiện việc mua thành công: sau khi nhận error=0 từ server về
		 * @param	isHasMessage: Có hiển thị effect mua thành công hay không?
		 */
		//public function BuySomeThing2():void
		//{
			//var data:Array = curThing.split("_");
			//var itemType:String = data[4];			//đồ mua được
			//var itemId:int = (int)(data[5]);
			//var itemPoint:int = (int)(data[6]);//điểm bị trừ đi
			//trace("Mua đồ thành công" + curThing);
			//
			//
			//
			//refesh component để cập nhật lại các đồ có thể mua được
			//RefreshComponent();
		//}
		
		/**
		 * Hiển thị effect trừ điểm khi mà mua đồ thành công
		 * @param	subPoint
		 */
		public function ShowEffPoint(iPoint:int, isHot:Boolean):void
		{
			//tọa độ
			isEffBuyRunning = true;
			var toX:int = btnBoardDes.img.x + btnBoardDes.img.width / 2 + 35;
			var toY:int = btnBoardDes.img.y + btnBoardDes.img.height + 40;
			var fromX:int = toX;
			var fromY:int = toY + 50;
			
			var speed:int = 10;
			//chữ effect
			var st:String;
			if (iPoint < 0)
				st = Ultility.StandardNumber(iPoint);
			else
				st = "+" + Ultility.StandardNumber(iPoint);
			var txtFormat :TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.color = 0xF6A921;
			txtFormat.font = "SansationBold";
			txtFormat.align = "left"
			var tmp1:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
			if (isHot)
			{
				tmp1.scaleX = 2;
				tmp1.scaleY = 2;
			}
			//thực hiện
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1) as ImgEffectFly;
			eff.SetInfo(fromX, fromY, toX, toY, speed);
		}
		
		/**
		 * thực hiện effect hút cá thành công
		 */
		public function ShowEffCrushFish():void
		{
			imgIdle.img.visible = false;
			isEffCrushRunning = true;
			bFinishEff = false;
			effCrushFish = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, 
																"GuiFishMachine_EffExchangePearl", 
																null, 
																190, 108.5, 
																false, false, null, finishEff);
			function finishEff():void
			{
				bFinishEff = true;
				imgIdle.img.visible = true;
				if (isRecData)
				{
					RefreshComponent();
				}
			}
		}
		
		override public function Hide():void 
		{
			super.Hide();
		}
		
		/**
		 * Kiểm tra điểm giữa người chơi và đồ vật
		 * @param	point
		 * @return
		 */
		public function CheckPoint(point:int):Boolean
		{
			var curPoint:int = _user.GetFairyDrop();
			return (curPoint < point?false:true);
		}
		
		/**
		 * Thực hiện hành động đổi ngọc trước server
		 * 3 nhiệm vụ: gửi dữ liệu lên server, disable nút, effect hút cá
		 */
		public function DoCrushFish1():void
		{
			//Send dữ liệu lên server
			var f:Fish = FishXArr[lstXFish.curPage] as Fish;
			curFish = f;
			_stPoint = GetPoint(curFish);
			_tgPoint = _stPoint + _stPoint * 0.1;
			isRecData = false;
			var cmd:SendExchangeFairyDrop = new SendExchangeFairyDrop(f.Id, f.LakeId);
			Exchange.GetInstance().Send(cmd);
			//disable nút Đổi và Close
			btnCrush.SetEnable(false);
			btnClose.SetEnable(false);
			txtPearlSrc.text = "";
			btnBoardScr.SetDisable();
			if(btnNext)
			if (btnNext.img)
				btnNext.SetDisable();
			if(btnPrev)
			if (btnPrev.img)
				btnPrev.SetDisable();
			lstXFish.visible = false;
			//lstXFish.removeAllItem();
			//cộng điểm, trừ buff
			var bonusPoint:int = GetPoint(curFish);
			
			//effect hút cá thành công
			ShowEffCrushFish();
		}
		
		/**
		 * Thực hiện đổi ngọc sau khi gửi lên server
		 * cộng ngọc cho user, trừ buff hồ, effect + ngọc, enable nút, enable đồ mua.
		 * @param	data: dữ liệu nhận về từ server
		 */
		public function DoCrushFish2(data:Object):void
		{
			isRecData = true;
			var serverPoint:int = data.FairyDrop;
			//cộng điểm, trừ buff
			PlushPoint(curFish,serverPoint);
			//xóa con cá đó trong mảng và listbox và trong bể chứa nó
			DelFish(curFish);
			/*gộp đống này lại = refesh component*/
			//effect số điểm hiện tại tăng lên
			if (serverPoint == Math.round(_stPoint))
			{
				//show normal
				ShowEffPoint(serverPoint,false);
			}
			else if(serverPoint == Math.ceil(_tgPoint))
			{
				//show hot
				ShowEffPoint(serverPoint,true);
			}
			if (bFinishEff)
			{
				RefreshComponent();
			}
		}
		
		public function RefreshAllRow():void
		{
			//xóa tất cả đồ đạc cũ
			
		}
		/**
		 * Thực hiện hành động cộng điểm và trừ buff hồ sau khi hút cá thành công
		 * @param	f: con cá hút vào
		 */
		private function PlushPoint(f:Fish, serverPoint:Number):void
		{
			var stPoint:int = 0;
			var tgPoint:int = 0;
			var bonusPoint:int;
			var nPoint:Number = GetPoint(f);
			stPoint = Math.round(nPoint);
			tgPoint = Math.ceil(nPoint * 1.1);
			
			if (f.RateOption)
			{
				//if (serverPoint==stPoint || serverPoint==tgPoint)//so sánh với kết quả server trả về
				{
					_user.UpdateFairyDrop(serverPoint, true);
					txtPearlDes.text = _user.GetFairyDrop().toString();
					txtPearlDes.setTextFormat(_format);
				}
			}
		}
		
		/**
		 * xóa con cá khỏi hồ và lstXFish
		 * @param	f: con cá cần xóa
		 */
		private function DelFish(f:Fish):void
		{
			var index:int
			//xóa trong lst và trong FishXArr
			index = GetXFishIndex(f.Id);			
			FishXArr.splice(index, 1);				//xóa logic - trong FishXArr
			lstXFish.removeItem(f.Id.toString());
			
			// xóa thông tin khỏi mảng AllFishArr trong user
			var obj:Object = _user.getFishInfo(f.Id);
			var idx:int = _user.AllFishArr.indexOf(obj);
			_user.AllFishArr.splice(idx, 1);
			_user.GetLake(f.LakeId).NumFish--;
			
			//xóa trong hồ hien tai neu no o ho hien tai
			var fish:Fish = _user.GetFish(f.Id);//lấy cá ở chính hồ hiện tại
			if (fish == null)
			{
				return;
			}
			
			//Thu hoạch bong bóng trước
			var balloonArr:Array = GameLogic.getInstance().balloonArr;
			for (var i:int = 0; i < balloonArr.length; i++)
			{
				var balloon:Balloon = balloonArr[i];
				if (balloon.myFish.Id == fish.Id)
				{
					balloon.collect(false, false);
					i--;
				}
			}
			
			
			
			//Cong tien cho user
			//var money:int = fish.GetValue();
			//var p:Point = fish.CurPos;
			//EffectMgr.getInstance().fallFlyMoney(p.x, p.y, money);//effect tiền rơi ra
			// Cập nhật lại các biến mà con cá đặc biệt có thể ảnh hưởng
			_user.UpdateOptionLakeObject( -1, fish.RateOption, _user.CurLake.Id);
			fish.Clear();
			index = _user.GetFishIndex(fish.Id);
			var fishArr:Array = _user.GetFishArr();
			fishArr.splice(index, 1);
			//Cap nhat thong tin tren guimain
			//_user.UpdateHavestTime();

		}
		
		private function GetXFishIndex(id:int):int
		{
			for (var i:int = 0; i < FishXArr.length; i++)
			{
				if (FishXArr[i].Id == id)
				{
					return i;
				}
			}
			return -1;
		}
		/**
		 * tính điểm của con cá
		 * @param	f: cá cần tính điểm
		 * @return Điểm của cá.
		 */
		public function GetPoint(f:Fish):Number
		{
			var _config:ConfigJSON = ConfigJSON.getInstance();
			var levelRequire:int = _config.getLevelRequired(f.FishTypeId);
			var rate:Number = _config.getRateBuff(levelRequire);
			var str:String;
			var bonusPoint:Number = 0;
			if (f.RateOption)
			{
				for (str in f.RateOption)
				{
					if(f && f.RateOption && f.RateOption[str] > 0)
						bonusPoint += _config.getPointBuff(f.RateOption[str], str);
				}
				bonusPoint *= rate;
			}
			return bonusPoint;
		}
		
		public function GetPoint2(f:Fish, stPoint:int = 0, tgPoint:int = 0):void
		{
			var nPoint:Number = GetPoint(f);
			stPoint = Math.round(nPoint);
			tgPoint = Math.ceil(nPoint * 1.1);
		}
		
		public static function GetTooltipMagicBag(id:int,unlockType:int):String
		{
			var str:String;
			var sReplace:String;
			if (unlockType == 1)
			{
				var sGift1:String;
				var sGift2:String;
				var sGift3:String;
				str = Localization.getInstance().getString("Tooltip55");
				switch(id)
				{
					case 1:
						sGift1 = "1 Ngư thạch cấp 3";
						sGift2 = "1 Ngư thạch cấp 4";
						sGift3 = "1 Ngư thạch cấp 5";
						break;
					case 2:
						sGift1 = "1 Ngư thạch cấp 4";
						sGift2 = "1 Ngư thạch cấp 5";
						sGift3 = "1 Ngư thạch cấp 6";
						break;
					case 3:
						sGift1 = "1 Ngư thạch cấp 5";
						sGift2 = "1 Ngư thạch cấp 6";
						sGift3 = "1 Ngư thạch cấp 7";
						break;
					case 20:
						sGift1 = "1 Bình năng lượng 5";
						sGift2 = "1 Bình năng lượng 10";
						sGift3 = "1 Bình năng lượng 50";
						break;
					case 21:
						sGift1 = "1 Bình năng lượng 10";
						sGift2 = "1 Bình năng lượng 50";
						sGift3 = "1 Bình năng lượng 100";
						break;
					case 22:
						sGift1 = "1 Bình năng lượng 5";
						sGift2 = "1 Bình năng lượng 10";
						sGift3 = "Năng lượng Full";
						break;
					case 40:
						sGift1 = "1 Thuốc hồi sinh 5 phút";
						sGift2 = "1 Thuốc hồi sinh 5 tiếng";
						sGift3 = "1 Thuốc hồi sinh 7 ngày";
						break;
					case 41:
						sGift1 = "1 Thuốc hồi sinh 5 tiếng";
						sGift2 = "1 Thuốc hồi sinh 7 ngày";
						sGift3 = "1 Thuốc hồi sinh 14 ngày";
						break;
					case 42:
						sGift1 = "1 Thuốc hồi sinh 7 ngày";
						sGift2 = "1 Thuốc hồi sinh 14 ngày";
						sGift3 = "1 Thuốc hồi sinh 30 ngày";
						break;
					
				}
				str = str.replace("@gift1", sGift1);
				str = str.replace("@gift2", sGift2);
				str = str.replace("@gift3", sGift3);
				if (id == 2 || id == 21 || id == 41)
				{
					sReplace = "vừa";
				}
				else if (id == 3 || id == 22 || id == 42)
				{
					sReplace = "lớn";
				}
				else if (id == 1 || id == 20 || id == 40)
				{
					sReplace = "nhỏ";
				}
				str = str.replace("@type", sReplace);
			}
			else if (unlockType == 6)
			{
				str = Localization.getInstance().getString("Tooltip56");
				if (id == 2 || id == 21 || id == 41)
				{
					sReplace = "vừa";
				}
				else if (id == 3 || id == 22 || id == 42)
				{
					sReplace = "lớn";
				}
				str = str.replace("@type", sReplace);
			}
			return str;
		}
	}

}