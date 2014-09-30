package Event.EventIceCream 
{
	import adobe.utils.CustomActions;
	import Effect.ImageEffect;
	import Event.EventIceCream.NetworkPacket.SendIceCreamDeleteSlot;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.LayerMgr;
	import particleSys.myFish.IceCreamEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIDestroyIceCream extends BaseGUI 
	{
		public var BTN_CLOSE:String = "BtnThoat";
		public var BTN_DESTROY:String = "BtnDestroy";
		public var idCream:int;
		
		public function GUIDestroyIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDestroyIceCream";
		}
		
		public function init(_idCream:int):void 
		{
			idCream = _idCream;
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit.destroy();
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = null;
			}
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(200, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 410, 20, this);
				OpenRoomOut();
			}
			LoadRes("EventIceCream_ImgBgDestroyIceCream");
		}
		
		override public function EndingRoomOut():void 
		{
			AddImage("EventIceCream_ImgBgSlot", "EventIceCream_ImgBgSlot", 237, 216, true, ALIGN_LEFT_TOP);
			var imgContent:Image = AddImage("EventIceCream_ImgIceCream", "EventIceCream_Item" + idCream, 267, 196, true, ALIGN_LEFT_TOP);
			(imgContent.img as MovieClip).gotoAndStop(1);
			AddButton(BTN_DESTROY, "EventIceCream_BtnDestroy", 233, 275, this);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_DESTROY:
					ProcessDestroyIceCream();
				break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit == null)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = new IceCreamEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			}
			var str:String = GuiMgr.getInstance().GuiMainEventIceCream.idCurProcess;
			var ctn:Container = GuiMgr.getInstance().GuiMainEventIceCream.GetContainer(str);
			(ctn.ButtonArr[0] as Button).SetVisible(false);
			GuiMgr.getInstance().GuiMainEventIceCream.idCurProcess = "";
		}
		
		public function ProcessDestroyIceCream():void 
		{
			var DataIceCream:Object = GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream;
			var arrText:Array = GuiMgr.getInstance().GuiMainEventIceCream.arrTextTimeNeed;
			var arrPrg:Array = GuiMgr.getInstance().GuiMainEventIceCream.arrProgressBarIceCream;
			var arrCtn:Array = GuiMgr.getInstance().GuiMainEventIceCream.arrCtnSlotIcream;
			var idCtn:String = GuiMgr.getInstance().GuiMainEventIceCream.idCurProcess;
			var ctn:Container = GuiMgr.getInstance().GuiMainEventIceCream.GetContainer(idCtn);
			var data:Object;
			var txtTextTime:TextField = ctn.LabelArr[0];
			var slotId:int = int(idCtn.split("_")[1]) + 1;
			DataIceCream[slotId.toString()] = new Array();
			
			var indexText:int = arrText.indexOf(txtTextTime);
			arrText.splice(indexText, 1);
			
			var prg:ProgressBar = arrPrg[indexText];
			prg.RemoveAllEvent();
			prg.removeChild(prg.img);
			prg.parent.removeChild(prg);
			prg.img = null;
			arrPrg.splice(indexText, 1);
			ctn.ProgressArr.splice(0, ctn.ProgressArr.length);
			
			ctn.LabelArr.splice(0, ctn.LabelArr.length);
			txtTextTime.parent.removeChild(txtTextTime);
			var imgContents:Image = ctn.GetImage(GuiMgr.getInstance().GuiMainEventIceCream.IMG_CONTENT_ICE_CREAM);
			ctn.ImageArr.splice(ctn.ImageArr.indexOf(imgContents), 1);
			imgContents.img.parent.removeChild(imgContents.img);
			imgContents.Destructor();
			for (var j:int = 0; j < ctn.LabelArr.length; j++) 
			{
				ctn.img.removeChild(ctn.LabelArr[j]);
			}
			Exchange.GetInstance().Send(new SendIceCreamDeleteSlot(int(idCtn.split("_")[1]) + 1));
			Hide();
		}
	}

}