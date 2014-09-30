package GUI.ZingMeWallet 
{
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendUpdateG;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIAddZMoney extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var waiting:MovieClip = new DataLoading();
		
		private var ctnZingWallet:Container;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_PAYMENT:String = "btnPayment";
		static public const BTN_ZING_WALLET:String = "btnZingWallet";
		static public const BTN_TYPE_PRICE:String = "btnTypePrice";
		static public const IMAGE_CHOSEN:String = "imageChosen";
		static public const BTN_WALLET_GUIDE:String = "btnWalletGuide";
		
		public function GUIAddZMoney(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				img.addChild(waiting);
				waiting.x = img.width / 2;
				waiting.y = img.height / 2 - 10;
				
				AddButton(BTN_CLOSE, "BtnThoat", 300 + 270, 17);
				SetPos(100, 40);
				AddImage("", "GuiAddZMoney_SelectedPayment", 45, 26, true, ALIGN_LEFT_TOP);
				AddImage("", "GuiAddZMoney_SelectedZingWallet", 170, 26, true, ALIGN_LEFT_TOP);
				AddButton(BTN_PAYMENT, "GuiAddZMoney_BtnPayment", 45, 26);
				AddButton(BTN_ZING_WALLET, "GuiAddZMoney_BtnZingWallet", 170, 26);
				var name:String = GameLogic.getInstance().user.GetMyInfo().Name;
				if (name == null)
				{
					name = "Unknown";
				}
				AddLabel(name, 386, 28, 0xffff00, 0, 0x000000);
				
				ctnZingWallet = AddContainer("", "GuiAddZMoney_BgZingWallet", 31.5, 64.5);
				var arr:Array = [10, 20, 50, 100, 200, 600, 1200]; 
				for (var i:int = 0; i < arr.length ; i++)
				{
					ctnZingWallet.AddButton(BTN_TYPE_PRICE + "_" + arr[i].toString() , "GuiAddZMoney_Btn" + arr[i] + "G", (i % 4) * 120 + 47, Math.floor(i / 4) * 70 +57, this);
				}
				ctnZingWallet.AddButton(BTN_WALLET_GUIDE, "GuiAddZMoney_BtnGuide", 223, 230, this);
				//ctnZingWallet.AddLabel("Chức năng đang được xây dựng!", 225, 91, 0xffff00, 1, 0x000000).setTextFormat(new TextFormat("arial", 20, 0xffff00, true));
				ctnZingWallet.SetVisible(false);
				showTab(BTN_PAYMENT);
				
				if (Main.imgRoot.stage.displayState == StageDisplayState.FULL_SCREEN)
				{	
					img.stage.displayState = StageDisplayState.NORMAL;
				}
			}
			LoadRes("GuiAddZMoney_Theme");
		}
		
		public function showTab(tabName:String):void
		{
			switch(tabName)
			{
				case BTN_PAYMENT:
					GetButton(BTN_PAYMENT).SetFocus(true);
					GetButton(BTN_ZING_WALLET).SetFocus(false);
					ctnZingWallet.SetVisible(false);
					try
					{
						ExternalInterface.addCallback("updateG", function ():void {
							Exchange.GetInstance().Send(new SendUpdateG());
							//GuiMgr.getInstance().GuiTopInfo.GetButton(GUITopInfo.BTN_QUICK_PAY).SetEnable(true);
						});
						ExternalInterface.call("payment", GameLogic.getInstance().user.GetMyInfo().UserName);
					}
					catch (e:*)
					{
						
					}
					break;
				case BTN_ZING_WALLET:
					GetButton(BTN_ZING_WALLET).SetFocus(true);
					GetButton(BTN_PAYMENT).SetFocus(false);
					try
					{
						ExternalInterface.call("hideGuiPay");
					}
					catch (e:*)
					{
						
					}
					ctnZingWallet.SetVisible(true);
					break;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_WALLET_GUIDE:
					var url:URLRequest = new URLRequest("http://me.zing.vn/apps/blog?params=fish_gsn/blog/detail/id/749776202?from=feed");
					navigateToURL(url);		
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_PAYMENT:
				case BTN_ZING_WALLET:
					showTab(buttonID);
					break;
				default:
					if (buttonID.search(BTN_TYPE_PRICE) >= 0)
					{
						var id:int = buttonID.split("_")[1];
						trace(id);
						exchangeBillingURL(id);
					}
			}
		}
		
		override public function OnHideGUI():void 
		{
			try
			{
				ExternalInterface.call("hideGuiPay");
			}
			catch (e:*)
			{
				
			}
		}
		
		public function exchangeBillingURL(typePrice:int):void
		{
			var variables:URLVariables = new URLVariables();
			//var send:URLRequest = new URLRequest("http://10.198.48.63/Test/index.php?uId=100");
			//var send:URLRequest = new URLRequest("http://myfish-pre.apps.zing.vn/web/index.php?uId=20800525");
			var uId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var userName:String = GameLogic.getInstance().user.GetMyInfo().UserName;
			var url:String;
			if (Constant.DEV_MODE)
			{
				url = "http://120.138.65.118/myfish/zcredit/build_billing_url.php?uId=" + uId + "&quantity=" + typePrice + "&username=" + userName;
			}
			else
			{
				url = "http://fish.apps.zing.vn/zcredit/build_billing_url.php?uId=" + uId + "&quantity=" + typePrice + "&username=" + userName;
			}
			var send:URLRequest = new URLRequest(url);
			send.method = URLRequestMethod.POST;
			send.data = variables;
			var loader:URLLoader = new URLLoader();
			loader.load(send);
			loader.addEventListener(Event.COMPLETE, loadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
		}
		
		private function loadError(e:IOErrorEvent):void 
		{
			trace("load error");
			GuiMgr.getInstance().GuiMessageBox.ShowOK("Load trang bi loi");
		}
		
		private function loadComplete(e:Event):void 
		{
			trace(e.target.data);
			var linkRespond:String = e.target.data.toString();
			//navigateToURL(new URLRequest(linkRespond), "iframePay");
			ExternalInterface.call("showZingWallet", linkRespond);
		}
	}

}