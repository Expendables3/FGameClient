package GUI.GUIGemRefine.unused 
{
	import adobe.utils.ProductManager;
	import com.bit101.components.IndicatorLight;
	import com.bit101.components.Text;
	import fl.containers.ScrollPane;
	import fl.events.ScrollEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.LocalConnection;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import Data.ResMgr;
	import flash.geom.ColorTransform;
	import GUI.component.ScrollBar;
	import GUI.component.SpriteExt;
	import GUI.GUIGemRefine.GemGUI.GUIGuidePearlRefine;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Balloon;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIPearlRefine extends BaseGUI 
	{
		public var BTN_CLOSE:String = "btnClose";
		
		// ID BUTTON
		public const BTN_RECEIVE:String = "btnReceive";
		public const BTN_DELETE:String = "btnDeleteP";
		public const BTN_REFINE:String = "btnRefineP";
		public const BTN_BUY_G:String = "btnBuyGBlu";
		public const BTN_BUY_GOLD:String = "btnBuyGold";
		public const BTN_TACH:String = "btnTach";
		public const BTN_GUIDE:String = "btnGuide";
		private static const MAX_LEVEL:int = 20;
		
		public const PROGRESS:String = "progress";
		public const IMG_PEARL:String = "img_Pearll";
		public const CTN_PEARL:String = "ctn_Pearll";
		
		public const CTN_SCROLL_BAR:String = "ctnScrollBar";
		
		public const TEMP_CNT:String="ctn_temp";
		
		public const CTN_CELL_RIGHT1:String = "ctn_cell_right1";
		public const CTN_CELL_RIGHT2:String = "ctn_cell_right2";
		public const IMG_ADD:String = "imgAddRigh";
		
		public const IMG_REFINED:String = "imgRefined";
		
		public var contentLeft:Sprite = new Sprite();
		
		public const BTN_ARRANGE_AUTO:String = "btnArrangeAuto";
		public const BTN_DELETE_PEARL:String = "btnDeletePearl";
		public const BTN_RECOVER_PEARL:String = "btnRecoverPearl";
		
		public var imgListLeft:Array = [];
		public var imgListLeftTemp:Array = [];

		public var mashFog:Sprite;
		
		private var temp1:int = 0;
		private var temp2:int = 0;
		private var tempID:String;
		private var delta:int = 0;
		
		private const DOUBLE_CLICK_TIMER:Number = 0.5;
		private var clickTimer:Number=-1;
		private var img1:Image;
		
		// các ô luyện ngọc
		private var cellRefineList:Array = [];
		
		private var idPearl:int = -1;	// id của ngọc focus
		
		private var idPearl0:int = -1;
		private var textList:Array = [];
		
		// gui
		private var guiRecoverPearl:GUIRecoverPearl = new GUIRecoverPearl(null, "");
		private var guiDeletePearl:GUIDeletePearl = new GUIDeletePearl(null, "");
		private var guiHuyDanLuyen:GUIAskDelPearl = new GUIAskDelPearl(null, "");
		private var guiGuide:GUIGuidePearlRefine = new GUIGuidePearlRefine(null, "");
		
		public var pearlList:Array = [];
		
		private const SLOT_UPGRADE:int = 3;
		private var arrow:Image = null;
		
		private var isSendList:Array = [];
		
		// bar
		private var ctnScrollBar:Container;
		private var scrollBarCtn:ScrollBar;
		
		public function GUIPearlRefine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
	
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddObj();
				AddButtons();
				AddImgs();	
				arrow = new Image(img, "IcHelper", 315, 430);
				hideArrow();
			}
			
			LoadRes("GuiPearlRefine_Theme");
		}
		
		private function showArrow():void 
		{
			arrow.img.visible = true;
		}
		
		private function hideArrow():void 
		{
			arrow.img.visible = false;
		}
		public function ShowGui():void 
		{
			var flag:Boolean = false;
			var o:SharedObject = SharedObject.getLocal("uIdGuidePearl");
			var id:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var obj:Object;
			obj = o.data;
			if (obj)
			{
				for (var s:String in obj) 
				{
					var item:int = obj[s];
					if (item ==id )
					{
						flag = true;
						break;
					}
				}
				if (!flag)
				{
					obj["uId" + id] = id;
				}
			}
			if (flag)
			{
				Show();
				ShowDisableScreen(0.5);
				SetPos(40, 40);
			}
			else 
			{
				obj["uId"+id] = id;
				Show();
				ShowDisableScreen(0.5);
				SetPos(40, 40);
				guiGuide.ShowGui();
			}
			Ultility.FlushData(o);
			
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 706, 18, this);
			AddButton(BTN_GUIDE, "GuiPearlRefine_BtnGuide", 670, 19, this);
			AddButton(BTN_ARRANGE_AUTO, "GuiPearlRefine_Btn_TuXep_TuLuyenNgoc", 50, 447, this);
			AddButton(BTN_DELETE_PEARL, "GuiPearlRefine_Btn_HuyNgoc_TuLuyenNgoc", 167, 447, this);
			AddButton(BTN_RECOVER_PEARL, "GuiPearlRefine_Btn_KhoiPhuc_TuLuyenNgoc", 283, 447, this);	
		}
		
		private function AddObj():void 
		{
			var p:Pearl;
			var i:int;
			var flag:Boolean = false;
			var ini:Boolean = false;
			var a:Array = [];
			pearlList = [];
			pearlList = GameLogic.getInstance().user.pearlMgr.copyPearlList();
			GameLogic.getInstance().user.pearlMgr.cleanUpgradeList();	
			isSendList = [];
			for (var j:int = 0; j < SLOT_UPGRADE; j++) 
			{
				isSendList.push(0);
			}
		}
		
		public function setIsSendList(index:int):void 
		{
			if (index > 0)
			{
				isSendList[index-1] = 0;
			}
		}
		
		private function ProcessClickButtonRefine(index:int):void 
		{
			var bt3:Button;
			var bt4:Button;
			var a:Array;
			var p:Pearl;
			var format:TextFormat = new TextFormat();
			var s:String;
			format.size = 14;
			format.color = 0x000000;
			format.bold = true;
			GetButton(BTN_REFINE+index).SetVisible(false);
			GetButton(BTN_DELETE + index).SetVisible(true);
			// button G or gold 
			 a = GameLogic.getInstance().user.pearlMgr.upgradingList[index-1];
			 if (a)
			 {
				p =a[0]  as Pearl;
				if (p)
				{
					if (p.zmoneyQuickUpgrade > 0)
					{
						bt4 = GetButton(BTN_BUY_G + index);
						bt4.SetText(p.zmoneyQuickUpgrade.toString());
					}
					
					if (p.moneyQuickUpgrade > 0)
					{
						 bt3 = GetButton(BTN_BUY_GOLD + index);
						 s = Ultility.StandardNumber(p.moneyQuickUpgrade);
						 bt3.SetText(s);
					}
					
					if (bt3)
					{	format.size = 14;
						bt3.text.x = bt3.img.x+22;
						bt3.text.y = bt3.img.y;
						bt3.text.mouseEnabled = false;
						bt3.text.setTextFormat(format);
						bt3.SetVisible(true);
						bt3.SetEnable();
					}
					if (bt4)
					{	
						format.size = 14;
						bt4.text.x = bt4.img.x+35;
						bt4.text.y = bt4.img.y;
						bt4.text.mouseEnabled = false;
						bt4.text.setTextFormat(format);
						bt4.SetVisible(true);
						bt4.SetEnable();
					}
					cellRefineList[index-1] = 1;		
					
					// add img Right
					var imgName:String = Ultility.GetNameImgPearl(p.element, p.level+1);
					var ctn:Container = GetContainer(CTN_CELL_RIGHT2 + index );
					var imgN1:Image = ctn.AddImage(IMG_REFINED + index, imgName, 2, 2, true, ALIGN_LEFT_TOP);
					imgN1.img.alpha = 0.8;
					imgN1.FitRect(40, 45, new Point(0, 0));
					ctn.AddLabel(Ultility.GetNamePearl(p.element, p.level + 1), -25, -20);
					//ctn.AddLabel("Luyện ngay", -130, 30);
					ctn.AddLabel("x1", 3, 20);
				}
			}	
		}
		
		private function SortAutoPearl():void 
		{
			pearlList.sortOn(["level", "number"], Array.NUMERIC);	
		}
		
		public function DeletePearl(id:int,num:int=0):void 
		{
			var p:Pearl =pearlList[id];
			GameLogic.getInstance().user.pearlMgr.SendDeletePearl(p.element, p.timeLife, num, p.level);
			GameLogic.getInstance().user.pearlMgr.DeletePearl(p.element, p.timeLife, num, p.level);
			if (p.number == num)
			{
				pearlList.splice(id, 1);
			}
			else
			{
				if (p.number > num)
				{
					p.number -= num;
				}
			}
			UpdateContentLeft();
		}
		
		public function RecoverPearl(id:int,num:int):void 
		{
			var p:Pearl = pearlList[id];
			if (p.number == num)
			{
				p.timeLife = GameLogic.getInstance().user.pearlMgr.NUM_GEM_DAY;
			}
			else 
			{
				if (p.number > num)
				{
					p.number = p.number - num;
					var q:Pearl = new Pearl();
					q.asignPearl(p);
					q.number = num;
					q.timeLife = GameLogic.getInstance().user.pearlMgr.NUM_GEM_DAY;
					
					// tìm trong obj
					for (var i:int = 0; i < pearlList.length; i++) 
					{
						var item:Pearl =pearlList[i];
						if (item.timeLife == q.timeLife && item.level == q.level && item.element == q.element)
						{
							item.number = item.number + num;
							return;
						}
					}
					// push mới vào mảng
					pearlList.push(q);
				}
			}
		
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var p:Pearl;
			switch (buttonID) 
			{
				case BTN_CLOSE:
					for (var i:int = 0; i < isSendList.length; i++) 
					{
						if (isSendList[i] == 1)
						return;
					}
					cea();
					Hide();
					HideDisableScreen();
					if (idPearl>-1)
					{
						var temp:Container;
						temp = imgListLeft[idPearl - 1];
						if(temp)
						temp.SetHighLight( -1);
					}
					idPearl = -1;
					return;
					break;
				case BTN_ARRANGE_AUTO:
					hideArrow();
					SortAutoPearl();
					UpdateContentLeft();
				return;
				break;
				case BTN_DELETE_PEARL:
					if (idPearl > -1)
					{
						hideArrow();
						p = pearlList[idPearl - 1];
						if (p)
						{
							if (p.number>=1)
							{
								guiDeletePearl.ShowGui(idPearl - 1);
							}
						}
					}	
				return;
				break;
				case  BTN_RECOVER_PEARL:
					if (idPearl>-1)
					{
						hideArrow();
						 p = pearlList[idPearl - 1];
						 if (p)
						 {
							if (p.timeLife < 1)
							{
								guiRecoverPearl.ShowGui(idPearl - 1);
							}
						 }
					}
				return;
				break;
				case BTN_GUIDE:
					guiGuide.ShowGui();
				break;
			}
			
				
			var s:String = buttonID.substr(0, 10);
			var index:int = parseInt(buttonID.substr(10));
			var bt1:Button;
			var bt2:Button;
			var bt3:Button;
			var bt4:Button;
			var a:Array;

			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.color = 0x000000;
			format.bold = true;
			
			switch (s) 
			{
				case BTN_REFINE:
				
					if (index > 0)
					{
						if (isSendList[index - 1] == 0)
						{
							// gửi server
							GameLogic.getInstance().user.pearlMgr.SendRefinePearl(index - 1);
							var ctn1:Container = GetContainer(CTN_CELL_RIGHT1 + index);
							if (ctn1)
							{
								var ctn2:Container = ctn1.GetContainer(IMG_ADD +index);
								if (ctn2)
								{
									ctn2.EventHandler = null;
								}
							}
							isSendList[index - 1] = 1;
						}
					}
					break;
				case BTN_RECEIVE:
					if (index > 0)
					{
						if (isSendList[index - 1] == 0)
						{
							GameLogic.getInstance().user.pearlMgr.SendReceivePearl(index - 1);
							isSendList[index - 1] = 1;
							// Feed
						}
					}
				break;
				case BTN_BUY_G:
					if (index > 0)
					{
						p= GameLogic.getInstance().user.pearlMgr.upgradingList[index - 1][0];
						var xu:int = GameLogic.getInstance().user.GetZMoney();
						var xuRequire:int = p.zmoneyQuickUpgrade;
						// Nếu đủ xu thì cho chọn lại
						if (isSendList[index-1]==0) 
						{
							if (xu >= xuRequire)
							{
								
								GameLogic.getInstance().user.pearlMgr.SendQuickRefinePearl(index - 1,false);
								GameLogic.getInstance().user.UpdateUserZMoney( -xuRequire);
								isSendList[index - 1] = 1;
							}
							// Không đủ thì bắt nạp xu
							else
							{
								GuiMgr.getInstance().GuiNapG.Init();
							}
						}
					}
				break;
				case BTN_BUY_GOLD:
					if (index)
					{
						p = GameLogic.getInstance().user.pearlMgr.upgradingList[index - 1][0];
						var money:Number = GameLogic.getInstance().user.GetMoney();
						var moneyRequire:int = p.moneyQuickUpgrade;
						// Nếu đủ xu thì cho chọn lại
						if (isSendList[index - 1] == 0)
						{
							if (money >= moneyRequire)
							{
								GameLogic.getInstance().user.pearlMgr.SendQuickRefinePearl(index - 1,true);
								GameLogic.getInstance().user.UpdateUserMoney( -moneyRequire);
								isSendList[index-1]=1;
							}
							// Không đủ thì show
							else
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không có đủ vàng. ",310,215, GUIMessageBox.NPC_MERMAID_NORMAL);
								// hết tiền
							}	
						}
					}
				break;
				case BTN_DELETE:
					if (index)
					{
						guiHuyDanLuyen.ShowGui(index-1);
					}
				break;
			
			}
		}
		
		private var tmpID1:String = "";
		private function cea():void 
		{
			var i:int;
			for (i= 0; i < imgListLeftTemp.length; i++) 
			{
				var ctnn:Container = imgListLeftTemp[i] as Container;
				ctnn.Destructor();
				if (ctnn.img != null)
				{
					while (ctnn.img.numChildren>0) 
					{
						delete(ctnn.img.getChildAt(0));
						ctnn.img.removeChildAt(0);
					}
					if (ctnn.Parent != null)
					{
						ctnn.img.parent.removeChild(ctnn.img);
					}
					ctnn.img = null;
				}
			}
			imgListLeftTemp = [];
			for (i= 0; i < imgListLeft.length; i++) 
			{
				var ctn:Container = imgListLeft[i] as Container;
				ctn.Destructor();
				if (ctn.img != null)
				{
					while (ctn.img.numChildren>0) 
					{
						delete(ctn.img.getChildAt(0));
						ctn.img.removeChildAt(0);
					}
					if (ctn.Parent != null)
					{
						ctn.img.parent.removeChild(ctn.img);
					}
					ctn.img = null;
				}
			}
			imgListLeft = [];
			while (contentLeft.numChildren>0) 
			{
				delete(contentLeft.getChildAt(0));
				contentLeft.removeChildAt(0);
			}
			gc();
		}
		
		private function gc():void 
		{
			try 
			{
				new LocalConnection().connect('foo');
				new LocalConnection().connect('foo');
			}
			catch (err:*) { }
		}
		
		public function ShowGuiClickBuyG(index:int):void 
		{
			GameLogic.getInstance().user.pearlMgr.QuickRefine(index - 1);
			UpdateProgress(index, 1);	
		}
		
		public function ShowGuiRecoverPearl(list:Array,idPearl:int):void 
		{
			var o:Object = list[0];
			if(o)
			{
				GameLogic.getInstance().user.pearlMgr.RecoverPearl(o.Element, o.Day, o.Num, o.GemId);
				GuiMgr.getInstance().GuiPearlRefine.RecoverPearl(idPearl, o.Num);
				GuiMgr.getInstance().GuiPearlRefine.UpdateContentLeft();
			}	
		}
		
		public function ShowGuiClickReceive(index:int):void 
		{
			var bt2:Button;
			// xóa các ảnh trên container
			var ctn1:Container = GetContainer(CTN_CELL_RIGHT1 + index);
			ctn1.ClearLabel();
			ctn1.RemoveAllContainer();
			var ctn2:Container = GetContainer(CTN_CELL_RIGHT2 + index);
			ctn2.ClearLabel();
			ctn2.RemoveAllImage();
			// cell list
			cellRefineList[index - 1] = 0;
			
			//progress
			UpdateProgress(index, 0);
			// logic nâng cấp ngọc 
			ReceivePearlRefine(index - 1);
			GameLogic.getInstance().user.pearlMgr.RefineFinishPearl(index - 1);
			
			// show button luyen
			bt2 = GetButton(BTN_REFINE + index);
			bt2.SetVisible(true);
			bt2.SetDisable();
			
		}
		
		public function ShowGuiClickRefine(index:int):void 
		{
			// logic
			GameLogic.getInstance().user.pearlMgr.RefinePearl(index - 1);
			ProcessClickButtonRefine(index);
			// cập nhập lại content bên trái
			UpdateContentLeft();	
		}
		
		private function ReceivePearlRefine(index:int):Boolean 
		{
			var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[index] ;
			var flag:Boolean = false;
			var item:Pearl = a[0];
			
			// Feed lên tường nếu đc cấp 5 hoặc 10
			if (item.level + 1 == 5 || item.level + 1 == 10)
			{
				GuiMgr.getInstance().GuiFeedWall.ShowFeed("PearlRefine@" + int((item.level + 1)/5), int(item.level + 1) + "");
			}
			
			// tìm item trong PearlList xem có chưa
			for (var j:int = 0; j < pearlList.length; j++) 
			{
				var p:Pearl = pearlList[j];
				if (p.element == item.element && p.level == (item.level+1) && p.timeLife==item.timeLife)
				{
					flag = true;
					p.number = p.number + 1;
					break;
				}
				
			}
			if (!flag)
			{
				// nạp  vào list
				var tmp:Pearl = new Pearl();
				tmp.asignPearl(item);
				tmp.level++;
				tmp.SetInfoFromConfig();
				pearlList.push(tmp);
			}
			UpdateContentLeft();	
			return flag;
		}
		

		
		public function DeleteRefinePearl(index:int):void 
		{
			
			var j:int = index + 1;
			cellRefineList[index] = 0;
			// gửi lên server
			// cập nhập lại content của container bên phải
			var ctn:Container = GetContainer(CTN_CELL_RIGHT1 + j);
			ctn.ClearLabel();
			ctn.RemoveAllContainer();
			var ctn1:Container = GetContainer(CTN_CELL_RIGHT2 + j);
			ctn1.ClearLabel();
			ctn1.RemoveAllImage();
			
			UpdateProgress(index+1, 0);

			var bt:Button = GetButton(BTN_REFINE + j);
			if(bt)
			{
				bt.SetVisible(true);
				bt.SetDisable();
			}
			
				//logic
			GameLogic.getInstance().user.pearlMgr.UnRefinePearl(index);		
			
			UnRefinePearl(index);
			
			// clear khỏi upgrading list
			GameLogic.getInstance().user.pearlMgr.upgradingList[index] = [];
		
		}
		
		private function comeBackPearl(index:int):void 
		{
			
			var j:int = index + 1;
			cellRefineList[index] = 0;

			// cập nhập lại content của container bên phải
			var ctn:Container = GetContainer(CTN_CELL_RIGHT1 + j);
			ctn.ClearLabel();
			ctn.RemoveAllContainer();

			var bt:Button = GetButton(BTN_REFINE + j);
			if(bt)
			{
				bt.SetVisible(true);
				bt.SetDisable();
			}
						
			UnRefinePearl(index);
			
			// clear khỏi upgrading list
			GameLogic.getInstance().user.pearlMgr.upgradingList[index] = [];
		}
		
		private function UnRefinePearl(index:int):void 
		{
			var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[index] ;
			var flag:Boolean = false;			
			
			// tìm item trong PearlList xem có chưa
			for (var i:int = 0; i < a.length; i++) 
			{
				var item:Pearl = a[i];
				if (item.timeLife > -7)
				{
					for (var j:int = 0; j < pearlList.length; j++) 
					{
						var p:Pearl = pearlList[j];
						if (p.element == item.element && p.level == item.level && p.timeLife==item.timeLife)
						{
							flag = true;
							p.number = p.number + 1;
							break;
						}
					}
					if (!flag)
					{
						// nạp  vào list
						var tmp:Pearl = new Pearl();
						tmp.asignPearl(item);
						pearlList.push(tmp);
					}
					else 
					{
						flag = false;
					}
				}
			}
			// cập nhập lại container bên trái
			UpdateContentLeft();
		}
			
		private function ProcessButton(buttonID:String,Id1:String,index:int,Id2:String=""):void 
		{
			var s:String = buttonID.substr(0, index);
			var index:int = parseInt(buttonID.substr(index));
		
			if (s ==Id1)
			{
				if (index > 0)
				{
					var bt1:Button = GetButton(buttonID);
					if (bt1)
					{
						bt1.SetVisible(false);
						if (Id2 != "")
						{
							var bt2:Button = GetButton(Id2 + index);
							if (bt2)
							{
								bt2.SetVisible(true);
								bt2.SetEnable();
							}
						}
					}
				}	
			}
		}
		
		public function AddImgs():void 
		{
			//InitScroll();
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff, 0);
			sp.graphics.drawRect(40, 108, 315, 320);
			sp.graphics.endFill();
			img.addChild(sp);		
			ctnScrollBar = AddContainer(CTN_SCROLL_BAR, "GuiPearlRefine_CtnBarTuLuyenNgoc", 43, 96);
			scrollBarCtn = ctnScrollBar.AddScroll("SCRLL", "GuiPearlRefine_ScrollBarExtendDeco", 280, 7);
			ctnScrollBar.img.addChild(contentLeft);
			contentLeft.mask = sp;
			scrollBarCtn.setScrollImage(contentLeft, 0, 270);

			showContentLeft();
			//scroll.source = contentLeft;
			AddContentRight();
			LoadContentRightData();
			//	ShowFogContainerRight();
		}
		
		
		public function LoadContentRightData():void 
		{
			var j:int;
			for (var i:int = 0; i < SLOT_UPGRADE; i++) 
			{
				j = i + 1;
				var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[i];
				if (a.length > 0)
				{
					cellRefineList[i] = 1;
					var imgName:String = "Key1";
					var p:Pearl = a[0] as Pearl;
					imgName = Ultility.GetNameImgPearl(p.element, p.level);
					var ctn2:Container = GetContainer(CTN_CELL_RIGHT1 + j);		
					var ctn3:Container = ctn2.AddContainer(IMG_ADD + j, imgName, 2, 2, true, null);
					ctn3.FitRect(40, 45, new Point(0, 0));
					ctn2.ClearLabel();
					ctn2.AddLabel(Ultility.GetNamePearl(p.element, p.level ), -25, -20);
					ctn2.AddLabel("x" + a.length, 5, 20);
					switch (p.isRefining) 
					{
						case 0:
							ProcessClickButtonRefine(i+1);
						break;
						case 1:
							UpdateProgress(i + 1, 1);
						break;
					}
				}
			}
			
		}
		
		private function AddContentRight():void 
		{
			var x:int = 393;
			var y:int = 107;
			var j:int = 0;
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0xffffff;
			for (var i:int = 0; i < SLOT_UPGRADE; i++) 
			{
				y = 107 + 120 * i;
				j = i + 1;
				var ctn1:Container = AddContainer(CTN_CELL_RIGHT1+j, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", x + 20, y + 27, true); // ALIGN_LEFT_TOP);
				var ctn2:Container = AddContainer(CTN_CELL_RIGHT2+j, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", x +230 , y +27 , true);// , ALIGN_LEFT_TOP);
				
				var btn1:Button = AddButton( BTN_REFINE+j , "GuiPearlRefine_Btn_Luyen_TuLuyenNgoc", x + 8, y + 80, this);
				btn1.SetDisable();
				
				var btn2:Button = AddButton(BTN_DELETE+j, "GuiPearlRefine_Btn_Huy_TuLuyenNgoc", x + 8, y + 80, this);
				btn2.SetVisible(false);
				
				var btn3:Button = AddButton(BTN_BUY_GOLD+j, "GuiPearlRefine_Btn_BuyGold_TuLuyenNgoc_1", x +100, y + 80, this);
				btn3.SetVisible(false);

				var btn4:Button = AddButton(BTN_BUY_G+j, "GuiPearlRefine_Btn_BuyG_TuLuyenNgoc_1", x + 100, y + 80, this);
				btn4.SetVisible(false);
				
				var btn5:Button=AddButton(BTN_RECEIVE+j, "GuiPearlRefine_Btn_Nhan_TuLuyenNgoc", x + 210, y + 80, this);
				btn5.SetVisible(false);
				
				var pr:ProgressBar = AddProgress(PROGRESS+j, "GuiPearlRefine_ProbarTuLuyenNgoc", x + 95, y + 40,null,true);
				pr.setStatus(0);	
				AddLabel("", x + 100, y + 15);
			}
		}
		
		public function UpdateProgress(index:int,percent:Number,time:Number=-1):void 
		{
			var id:String = PROGRESS + index;
			var pg:ProgressBar = this.GetProgress(id);
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.color = 0xffffff;
			if (pg)
			{
				pg.setStatus(percent);
				var lb:TextField = LabelArr[index-1];
				lb.text = "";
				
				if (time > -1)
				{	
					var t:int;
					t = time;
					var hour:int = t / (60 * 60);
					var min:int = (t -hour*60*60)/60;
					var sec:int = t - min * 60-hour*60*60;
					var minSt:String = min.toString();
					var secSt:String = sec.toString();
					var hourSt:String = hour.toString();
					if (hour <10)
					{
						hourSt = "0" + hour.toString();
						
					}

					if (min < 10)
					{
						minSt = "0" + min.toString();
					}
					if (sec < 10)
					{
						secSt = "0" + sec.toString();
					}
					var cooldown:String = hourSt+":"+minSt + ":" + secSt;
					lb.text = "Còn " + cooldown + " giây";
				}
					
				if (percent >= 1||percent==0)
				{
					lb.text = "Xong";
					// ẩn button làm nhanh
					var bt1:Button = GetButton(BTN_BUY_GOLD + index);
					if (bt1.text)
					{
						bt1.text.text = "";
					}
					bt1.SetVisible(false);
				
					var bt2:Button = GetButton(BTN_BUY_G + index);
					if(bt2.text)
					{
						bt2.text.text = "";
					}
					bt2.SetVisible(false);
					
					// show button nhận
					GetButton(BTN_RECEIVE +index).SetVisible(true);
					GetButton(BTN_DELETE + index).SetVisible(false);
					GetButton(BTN_REFINE + index).SetVisible(false);
					if (percent >= 1)
					{
						GameLogic.getInstance().user.pearlMgr.FinishRefine(index - 1);
						var a:Array=GameLogic.getInstance().user.pearlMgr.upgradingList[index-1];
						var p:Pearl = a[0];
						var ctn:Container = GetContainer(CTN_CELL_RIGHT2 + index);
						var img1:Image = ctn.GetImage(IMG_REFINED + index);
						var imgName:String = Ultility.GetNameImgPearl(p.element, p.level + 1);
						if (img1)
						{
							img1.img.alpha = 1;
							ctn.ClearLabel();
							ctn.AddLabel(Ultility.GetNamePearl(p.element, p.level + 1), -25, -20);
						}
						else 
						{
							img1 = ctn.AddImage(IMG_REFINED + index, imgName, 2, 2, true, ALIGN_LEFT_TOP);
							img1.FitRect(40, 45, new Point(0, 0));
							ctn.AddLabel(Ultility.GetNamePearl(p.element, p.level + 1), -25, -20);
						}
					}
					if (percent == 0)
					{
						lb.text = "";
						// ẩn các button buy G , hủy
						GetButton(BTN_RECEIVE + index).SetVisible(false);
						
					}
				}
			}
		}
			
		override public function OnButtonDown(event:MouseEvent, buttonID:String):void 
		{
			var x:int = 0;
			var y:int = 0;
			var j:int;
	
			var idButton:String = "";
			if (tempID != buttonID)
			{
				hideArrow();
			}
			if (GameLogic.getInstance().CurServerTime-clickTimer < DOUBLE_CLICK_TIMER)
			{
				if (tempID==buttonID)
				{
					buttonDoubleClick(buttonID);
					clickTimer = -1;
					return;
				}
			}
			clickTimer = -1;
			tempID = buttonID;
			var s:String = buttonID.substr(0, 10);
			var temp:Container;
			var ctn:Container ;
			var ctn1:Container;
			switch (s) 
			{
				case CTN_PEARL:
					j = parseInt(buttonID.substr(10));
					idButton = IMG_PEARL + j;
					if (idPearl>-1)
					{
						temp = imgListLeft[idPearl - 1];
						if(temp)
						temp.SetHighLight( -1);
					}
					idPearl = j;
					if (idPearl>-1)
					{
						temp = imgListLeft[idPearl - 1];
						temp.SetHighLight(0xFF8040);
					}
					
					if (j > 0 && j < imgListLeft.length + 1)
					{
						var p:Pearl = pearlList[ j - 1] ; 
						if (p)
						{
							if (p.timeLife < 1)
							{
								showArrow();
							}
							else 
							{
								hideArrow();
							}
							if (p.level == MAX_LEVEL&&p.timeLife>0)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Không luyện được nữa!\n Sử dụng cho ngư chiến thui!", 310, 215, GUIMessageBox.NPC_MERMAID_WAR);
								return;
							}
						}
			
						if (p.level < MAX_LEVEL&&p.timeLife>0)
						{
							ctn= imgListLeft[j-1] as Container;
							if(ctn)
							{
								ctn1 = ctn.GetContainer(idButton);
								img1 = new Image(this.img, ctn1.ImgName);
								img1.img.startDrag();
								x = ctn1.img.x;
								y = ctn1.img.y;
							
								img1.img.x = event.stageX-CurPos.x-ctn1.img.width/2;
								img1.img.y = event.stageY-CurPos.y-ctn1.img.height/2;
								img.addEventListener(MouseEvent.MOUSE_UP, FinishMovePearl);
								temp1 = x;
								temp2 = y;
							}
							
						}
						
					}
				break;
				case IMG_ADD:
					j = parseInt(buttonID.substr(10));
					idButton = CTN_CELL_RIGHT1 + j;		
					ctn = GetContainer(idButton);
					if (ctn)
					{
						idButton = IMG_ADD + j;
						ctn1 = ctn.GetContainer(idButton);
						ctn1.img.visible = false;
						img1 = new Image(this.img, ctn1.ImgName);
						img1.img.startDrag();
						x = ctn1.img.x;
						y = ctn1.img.y;
						img1.img.x =  x + ctn.img.x ;
						img1.img.y = y  + ctn.img.y ;
						img.addEventListener(MouseEvent.MOUSE_UP, FinishBackPearl);
						temp1 = x;
						temp2 = y;
					}
				break;
			
			}
			
		}
		
		private function FinishBackPearl(e:MouseEvent):void 
		{
			var index:int = parseInt(tempID.substr(10));
			var ctn:Container = GetContainer(CTN_CELL_RIGHT1 + index);
			img1.img.stopDrag();
			if (contentLeft.hitTestObject(img1.img))
			{
				comeBackPearl(index - 1);	
			}
			else 
			{
				var ctn1:Container = ctn.GetContainer(IMG_ADD + index);
				if (ctn1)
				{
					ctn1.img.visible = true;
				}
			}
			img1.img.parent.removeChild(img1.img);
			clickTimer = GameLogic.getInstance().CurServerTime;
			img.removeEventListener(MouseEvent.MOUSE_UP, FinishBackPearl);
			
		}
			
		private function FinishMovePearl(event:MouseEvent):void 
		{
			var index:int = parseInt(tempID.substr(10));
			var ctn:Container = imgListLeft[index - 1] as Container;	
			var tmp:Pearl =pearlList[index - 1];
			var j:int = 0;
			img1.img.stopDrag();
			
			for (var i:int = 0; i <SLOT_UPGRADE; i++) 
			{
				j = i + 1;
				var ctn2:Container = GetContainer(CTN_CELL_RIGHT1 + j);
				var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[i];
				if (ctn2.img.hitTestObject(img1.img))
				{
					if((tmp.level>0&&a.length==0)|| (tmp.level==0&&a.length<10))
					{
						
						if (a.length == 0 || ((a[0] as Pearl).level == 0&&a.length>0&&(a[0] as Pearl).element==tmp.element))
						{

							PickPearlRefine(index - 1, i);
							if (ctn2.ContainerArr.length == 0)
							{
								var ctn3:Container = ctn2.AddContainer(IMG_ADD + j, img1.ImgName, 2, 2,true, this);
								ctn3.FitRect(40, 45, new Point(0, 0));
							}
							if (tmp.level > 0 || (tmp.level == 0 && a.length == 10))
							{
								GetButton(BTN_REFINE + j).SetEnable();
							}
							ctn2.ClearLabel();
							ctn2.AddLabel(Ultility.GetNamePearl(tmp.element, tmp.level ), -25, -20);
							ctn2.AddLabel("x" + a.length, 5, 20);
						}
					}
				}
			}
			img1.img.parent.removeChild(img1.img);
			clickTimer = GameLogic.getInstance().CurServerTime;
			img.removeEventListener(MouseEvent.MOUSE_UP, FinishMovePearl);
		}
		
		private function ProcessDestroy(index:int):void 
		{
			var ctn:Container = imgListLeft[index] as Container;
			var ctn1:CTNPearl = ctn.GetContainer(IMG_PEARL + (index + 1))  as CTNPearl;
			if (ctn1)
			{
				if(!ctn1.isPhe)
				{
					ctn1.AddDestroy();
					ctn1.isPhe = true;
				}
			}
			// get out khỏi kho
			var p:Pearl = pearlList[index];
			if(p)
			{
				GameLogic.getInstance().user.pearlMgr.UpdateStoreGui(p.element, p.level, p.timeLife ,-p.number);
			}	
		}
		public function UpdateGui():void 
		{
			var time:Number = GameLogic.getInstance().CurServerTime;
			var percent:Number = 0;
			var temp:Number = 0;
			for (var i:int = 0; i < cellRefineList.length; i++) 
			{
				if (cellRefineList[i])
				{
					percent = 0;
					var a:Array =GameLogic.getInstance().user.pearlMgr.upgradingList[i];
					var p:Pearl = a[0];
					if (p)
					{
						if (p.isRefining==0)
						{
							temp = (time-p.timeStartRefine);
							percent = temp / p.timeRefining;
							if (percent <= 1.5)
							{
								UpdateProgress(i + 1, percent, p.timeRefining - temp);	
							}
						}
						else 
						{
							if (p.isRefining == 1 &&GetButton(BTN_DELETE + (i+1)).img.visible)
							{
								//trace("percent", percent);
								UpdateProgress(i + 1, 1);
								temp = (time-p.timeStartRefine);
								percent = temp / p.timeRefining;
								if (percent <= 1.5)
								{
									UpdateProgress(i + 1, percent, p.timeRefining - temp);	
								}
							}
						}
					}
				}
			}
			
			// xử lý thời gian ngày qua ngày;
			ProcessUpdateDay();
			
		}
			
		private function ProcessUpdateDay():void 
		{
			var time:Number = GameLogic.getInstance().CurServerTime;
			var temp:Number = GameLogic.getInstance().user.pearlMgr.lastUpdateTime;
			var datLast:Date = new Date(temp * 1000);
			var datCur:Date = new Date(time * 1000);
			if (datLast.getDate() != datCur.getDate() || (datLast.getDate() == datCur.getDate() && datCur.getMonth() != datLast.getMonth()))
			{
				// thực hiện việc update
				for (var j:int = 0; j < pearlList.length; j++) 
				{
					var item:Pearl = pearlList[j];
					item.timeLife--;

					// update store
					GameLogic.getInstance().user.pearlMgr.UpdateStoreGui(item.element, item.level, item.timeLife + 1, -item.number);
					GameLogic.getInstance().user.pearlMgr.UpdateStoreGui(item.element, item.level, item.timeLife, item.number);
					
					// thực hiện add icon phế và loại ra khỏi kho
					if (item.timeLife < 1)
					{
						ProcessDestroy(j);
					}
					// cập nhập lại tooltip
					var ctn:Container = imgListLeft[j] as Container;
					var ctn1:CTNPearl = ctn.GetContainer(IMG_PEARL + (j + 1))  as CTNPearl;
					ctn1.SetToolTip();
					
					// hủy đan nếu quá thời hạn phế
					if (item.timeLife <= -7)
					{
						pearlList.splice(j, 1);
						j--;
						UpdateContentLeft();
						// update lại content 
					}
				}
				GameLogic.getInstance().user.pearlMgr.lastUpdateTime = GameLogic.getInstance().CurServerTime;
			}
		}
			
		/**
		 * lấy 1 pearl sang slot bên tay phải
		 * @param	index
		 * @param	slot
		 */
		private function PickPearlRefine(index:int, slot:int):void	
		{
			var p:Pearl = pearlList[index];
			var temp:int = 1;
			var tmp:int = 0;
			if (p)
			{
				var b:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[slot];
				for (var j:int = 0; j < b.length; j++) 
				{
					var item:Pearl = b[j];
					if (item.number >= 0)
					{
						tmp += item.number;
					}
				}
				if (p.number > 0)
				{
					p.number = p.number - 1;
					// nạp vào upgrading
					var q:Pearl = new Pearl();
					q.asignPearl(p as Pearl);
						// xử lý riêng với p.level==0
					if (p.level == 0)
					{	
						if (p.number >= (9 - tmp))
						{
							p.number = p.number + tmp -9;
							temp = 10 - tmp;
						}
						else
						{
							temp = p.number + 1;
							p.number = 0;
						}
					}
					
					for (var i:int = 0; i < temp; i++) 
					{
						GameLogic.getInstance().user.pearlMgr.upgradingList[slot].push(q);
					}
			
					// xóa khỏi pearlList
					if (p.number == 0)
					{
						pearlList.splice(index, 1);
					}

					UpdateContentLeft();
				}
			}
		}
		
		public function GetPearlIndex(index:int,obj:SharedObject):Pearl 
		{
			var p:Object = obj.data.pearlList[index];
			var q:Pearl = new Pearl();
			q.isRefining = p.isRefining;					
			q.timeLife=p.timeLife;
			q.timeRefining=p.timeRefining;
			q.element=p.element;
			q.level=p.level;
			q.timeStartRefine=p.timeStartRefine;
			q.number=p.number;
			q.moneyQuickUpgrade=p.moneyQuickUpgrade;
			q.moneyRecover=p.moneyRecover;
			q.zmoneyRecover=p.zmoneyRecover;
			q.numGem=p.numGem;
			q.zmoneyQuickUpgrade=p.zmoneyQuickUpgrade;
			q.agencyPoint = p.agencyPoint;
			
			return q;
		}
		
		private function buttonDoubleClick(buttonID:String):void 
		{
			trace(buttonID);
			var s:String = buttonID.substr(0, 10);
			var idButton:String = "";
			var index:int = parseInt(buttonID.substr(10));
			if (pearlList)
			{
				switch (s) 
				{
					case  CTN_PEARL:
						idButton = IMG_PEARL + index;
						var tmp:Pearl = pearlList[index - 1];
						var j:int = 0;
						var ctn:Container = imgListLeft[index - 1] as Container;	
						for (var i:int = 0; i <SLOT_UPGRADE; i++) 
						{
							j = i + 1;
							var ctn2:Container = GetContainer(CTN_CELL_RIGHT1 + j);
							var a:Array = GameLogic.getInstance().user.pearlMgr.upgradingList[i];
							if(((tmp.level>0&&a.length==0)|| (tmp.level==0&&a.length<10))&& tmp.timeLife>0)
							{
								if (a.length == 0 || ((a[0] as Pearl).level == 0&&(a[0] as Pearl).element==tmp.element))
								{
									PickPearlRefine(index - 1, i);
									if(ctn2.ContainerArr.length == 0)
									{
										var ctn3:Container = ctn2.AddContainer(IMG_ADD +j , img1.ImgName, 2, 2, true,this);
										ctn3.FitRect(40, 45, new Point(0, 0));
									}
									if (tmp.level > 0 || (tmp.level == 0 && a.length == 10))
									{
										GetButton(BTN_REFINE + j).SetEnable();
									}
									ctn2.ClearLabel();
									ctn2.AddLabel(Ultility.GetNamePearl(tmp.element, tmp.level ), -25, -20);
									ctn2.AddLabel("x" + a.length, 5, 20);
									return;
								}
							}
						}
					break;
					case  IMG_ADD:
						comeBackPearl(index - 1);								
					break;
				}
			}
		}
		
		private function showContentLeft():void 
		{
			UpdateContentLeft();
			scrollBarCtn.img.visible = true;
			if (pearlList.length > 25)
			{
				scrollBarCtn.img.visible = true;
			}
			else 
			{
				scrollBarCtn.img.visible = false;
			}
		}
		public function UpdateContentLeft():void 
		{
			// remove all  child in content left
			cea();
			var f:TextFormat = new TextFormat();
			f.size = 12;
			f.color = 0x000000;
			var n:int = pearlList.length;
			var x:int;
			var y:int;
			var i:int;
			if (pearlList)
			{
				/*add vào các contener chứa ảnh đan theo đúng số lượng hiện có*/
				x= 15;
				y= 10;
				imgListLeft = [];
				for (i= 0; i < n; i++) 
				{
					if (i > 0)
					{
						x =x + 54;
					}
					if (i % 5 == 0)
					{
						y =  55 * (i / 5) + 10;
						x = 15;
					}		
					var ctn:Container = new Container(contentLeft, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", x, y); 
					ctn.EventHandler = this;
					ctn.IdObject = CTN_PEARL + (i + 1);
					ctn.img.buttonMode = true;
					imgListLeft.push(ctn);
				}
				if (n > 0)
				{
					/** add cái ảnh ngọc + số lượng lại chính là 1 container vào các container ở trên
					 *  id của cái container đó = IMG_PEARL + j
					 * */
					var j:int = 0;
					var imgName:String = "Key1";
					for (i= 0; i < imgListLeft.length; i++) 
					{
						j = i + 1;
						var ctn1:Container = imgListLeft[i] as Container;
						var p:Pearl = pearlList[i] as Pearl;
						imgName = Ultility.GetNameImgPearl(p.element, p.level);
						var ctnp:CTNPearl = new CTNPearl(i, ctn1.img, imgName);
						var ts:Container = ctn1.AddContainer2(ctnp, 0, 0, this); 
						ts.EventHandler = ctn1;
						ctnp.FitRect(40, 45, new Point(0, 0));
						ts.IdObject = IMG_PEARL + j;
						if(p.number > 0)
						{//add vào hiển thị số lượng
							ctn1.AddLabel(p.number.toString() , -30, 40, 0xFF0000).setTextFormat(f);
						}
					}
				}
				if (n < 30)
				{
					/*add các container mà ko có ảnh đan vào bắt đầu từ n đến 30*/
					for (i = n; i < 30; i++) 
					{
						if (i > 0)
						{
							x =x + 54;
						}
						if (i % 5 == 0)
						{
							y =  55 * (i / 5)+10;
							x = 15;
						}
						var ctn2:Container = new Container(contentLeft, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", x, y); 
						imgListLeftTemp.push(ctn2);
						ctn2.IdObject = TEMP_CNT + (i + 1);
					}		
				}
			}
			
			if (pearlList.length > 25)
			{
				scrollBarCtn.img.visible = true;
			}
		}
	}
}