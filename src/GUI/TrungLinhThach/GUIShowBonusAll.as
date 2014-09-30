package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.TooltipFormat;
	import Logic.LayerMgr;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIShowBonusAll extends BaseGUI 
	{
		//static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BACK:String = "BtnBackList";
		static public const BTN_NEXT:String = "BtnNextList";
		static public const BTN_RECIEVE:String = "BtnReceive";
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public var buttonClose:Button;
		private var buttonBack:Button;
		private var buttonNext:Button;
		private var buttonReceive:Button;
		
		public var IsInitFinish:Boolean = false;
		private var isDataReady:Boolean;
		private var ObjData:Array = new Array();
		private var OldData:Object = new Object();
		
		private var currentList:ListBox;
		private var listCustom:ListBox;
		private var dataSever:Array = new Array();
		private var dataEquip:Array = new Array();
		private var oEquip:Object;
		private var curPage:int;
		private	var numPage:int;
		private var itemPage:int = 10;
		
		public function GUIShowBonusAll(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiBonusTrungLinhThach";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				isDataReady = true;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
				
			}
			LoadRes("GuiBonusTrungLinhThach_bg");
			
		}
		
		public function showGUI(Obj:Array, Old:Object):void
		{
			ObjData = Obj;
			OldData = Old;
			
			isDataReady = false;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			IsInitFinish = true;
			
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			dataSever.splice(0, dataSever.length);
			
			isDataReady = dataAvailable;
			
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			dataSever = ObjData;
			addContent();
		}
		
		private function addContent():void
		{
			dataEquip.splice(0, dataEquip.length);
			
			listCustom = AddListBox(ListBox.LIST_X, 2, 5, 10, 5);
			listCustom.setPos(130, 322);
			
			/*buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 690, 55);
			buttonClose.setTooltipText("Đóng lại");*/
			
			AddImage("", "GuiBonusTrungLinhThach_" + OldData.EggType, 375, 195);
			
			buttonBack = AddButton(BTN_BACK, "GuiBonusTrungLinhThach_BtnPreviewList", 95, 400, this);
			buttonNext = AddButton(BTN_NEXT, "GuiBonusTrungLinhThach_BtnNextList", 615, 400, this);
			
			buttonReceive = AddButton(BTN_RECIEVE, "GuiBonusTrungLinhThach_BtnNhan", 330, 518, this);
			
			var quartzPurpleAr:Array = new Array();
			var quartzYellowAr:Array = new Array();
			var quartzGreenAr:Array = new Array();
			var quartzWhiteAr:Array = new Array();
			for (var i:int = 0; i < dataSever.length; i++)
			{
				if (dataSever[i].Type == "QWhite")
				{
					quartzWhiteAr.push(dataSever[i]);
				}
				
				if (dataSever[i].Type == "QGreen")
				{
					quartzGreenAr.push(dataSever[i]);
				}
				
				if (dataSever[i].Type == "QYellow")
				{
					quartzYellowAr.push(dataSever[i]);
				}
				
				if (dataSever[i].Type == "QPurple")
				{
					quartzPurpleAr.push(dataSever[i]);
				}
				
				if (dataSever[i].Type == "QVIP")
				{
					quartzPurpleAr.push(dataSever[i]);
				}
			}
			dataEquip = dataEquip.concat(updateArr(quartzPurpleAr), updateArr(quartzYellowAr), updateArr(quartzGreenAr), updateArr(quartzWhiteAr));
			
			filterListEquip(false);
			currentList = listCustom;
		}
		
		private function updateArr(dataView:Array):Array
		{
			var arrNew:Array = new Array();
			var levelOne:int;
			if (dataView.length > 0)
			{
				levelOne = dataView[0].Level;
			}
			else
			{
				levelOne = 0;
			}
			
			for (var i:int = 0; i < dataView.length; i++)
			{
				if (dataView[i].Level > levelOne)
				{
					levelOne = dataView[i].Level;
				}
			}
			
			var arrLevel:Array = new Array;
			var itemIdOne:int = 0;
			for (var k:int = levelOne + 1; k > 0; k--)
			{
				arrLevel.splice(0, arrLevel.length);
				for (var j:int = 0; j < dataView.length; j++)
				{
					if (dataView[j].Level == k)
					{
						if (dataView[j].ItemId > itemIdOne)
						{
							itemIdOne = dataView[j].ItemId;
						}
						arrLevel.push(dataView[j]);
					}
				}
				for (var h:int = itemIdOne + 1; h > 0; h--)
				{
					for (var m:int = 0; m < arrLevel.length; m++)
					{
						if (arrLevel[m].ItemId == h)
						{
							arrNew.push(arrLevel[m]);
						}
					}
				}
			}
			
			return arrNew;
		}
		
		private function filterListEquip(changeTab:Boolean = false):void 
		{
			var type:String;
			var element:int;
			var color:int;
			var s:int;
			var numElementInList:int;

			if (dataEquip.length > 0)
			{
				oEquip = dataEquip;
				for (s = 0; s < dataEquip.length; s++ )
				{
					numElementInList++;
				}
			}
			else
			{
				oEquip = dataEquip;
			}
			
			numPage = numElementInList / itemPage + 1;
			if (numElementInList % itemPage == 0)
				numPage = numElementInList / itemPage;
			
			if (changeTab)
			{
				if (curPage > numPage)
				{
					curPage = numPage;
				}
				addList(listCustom, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
			}
			else
			{
				addList(listCustom, oEquip, 1, itemPage);
				curPage = 1;
			}
			
			if (numPage > 1)
			{
				buttonBack.SetVisible(true);
				buttonNext.SetVisible(true);
				if (curPage <= 1)
				{
					buttonBack.SetVisible(false);
					buttonNext.SetVisible(true);
				}
				
				if (curPage == numPage)
				{
					buttonBack.SetVisible(true);
					buttonNext.SetVisible(false);
				}
			}
			else
			{
				buttonBack.SetVisible(false);
				buttonNext.SetVisible(false);
			}
			
		}
		
		private function addList(listBox:ListBox, data:Object, fromE:int, toE:int):void
		{
			var checkPage:Boolean = false;
			var indexPage:int = ((fromE - 1) / itemPage) + 1;
			
			listBox.removeAllItem(); 
			if (data != null)
			{
				var i:int = 0;
				for (var j:String in data)
				{
					i++; 
					if (i >= fromE && i <= toE)
					{
						var ctn:Container = new Container(img, "GuiBonusTrungLinhThach_ItemBonusBg", 0, 0);
						ctn.img.cacheAsBitmap = false;
						
						var imagName:String = data[j].Type + data[j].ItemId;
						var imag1:Image = ctn.AddImage(data[j].Id, imagName, 43, 45);
						
						listBox.addItem("CtnItemTrung" + "_" + data[j].Id + "_" + data[j].Level + "_" + data[j].Type, ctn, this);
						ContainerArr.splice(ContainerArr.length - 1, 1);
						
						var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
						GuiToolTip.Init(data[j]);
						GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctn.setGUITooltip(GuiToolTip);
					}
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				/*case BTN_CLOSE:
					Hide();
					break;*/
				case BTN_RECIEVE:
					Hide();
					break;
				case BTN_BACK:
					if (curPage > 1)
					{
						curPage--;
						
						addList(currentList, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
						buttonBack.SetVisible(true);
						buttonNext.SetVisible(true);
						if (curPage <= 1)
						{
							buttonBack.SetVisible(false);
							buttonNext.SetVisible(true);
						}
					}
					break;
				case BTN_NEXT:
					if (curPage < numPage)
					{
						curPage++;
						
						addList(currentList, oEquip, (curPage -1 ) * itemPage + 1, curPage * itemPage);
						buttonBack.SetVisible(true);
						buttonNext.SetVisible(true);
						if (curPage == numPage)
						{
							buttonBack.SetVisible(true);
							buttonNext.SetVisible(false);
						}
					}
					break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			
		}
		
	}
}