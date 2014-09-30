package GUI 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.User;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIAbstractChangeGift extends BaseGUI 
	{
		static protected const CMD_CHANGE:String = "cmdChange";
		static protected const CMD_BUY:String = "cmdBuy";
		static protected const CMD_REMIND:String = "cmdRemind";
		static protected const ID_BTN_GUIDE:String = "idBtnGuide";
		static protected const ID_BTN_CLOSE:String = "idBtnClose";
		
		static protected const EVENT_ITEM_TYPE:String = "";
		
		public function GUIAbstractChangeGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIAbstractChangeGift";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addBgr();
				addAllGift();
				addAllItem();
			}
			LoadRes("GUIChangeGift_Theme");
		}
		
		private function addBgr():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 707, 19);
			AddButton(ID_BTN_GUIDE, "GUIChangeGift_BtnGuide", 663, 19);
		}
		
		protected virtual function addAllItem():void 
		{
			
		}
		
		protected virtual function addAllGift():void 
		{
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_GUIDE:
					
				break;
				case CMD_REMIND:
					remindFriend();
				break;
				case CMD_BUY:
					buyItem(id, int(data[2]));
				break;
				case CMD_CHANGE:
					changeGift(id);
				break;
			}
		}
		
		/**
		 * mua item
		 * @param	id			: idRow của item cần mua, ở dòng 2 thì id = 2
		 * @param	zMoney		: giá của đồ cần mua
		 */
		private function buyItem(id:int, zMoney:int):void 
		{
			var _user:User = GameLogic.getInstance().user;
			var myMoney:int = _user.GetMyInfo().ZMoney;
			if (myMoney < zMoney)
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
				
			}
			_user.UpdateUserZMoney(0 - zMoney);
			_user.UpdateStockThing(EVENT_ITEM_TYPE, id, 1);
			EffectMgr.setEffBounceDown("Mua thành công",EVENT_ITEM_TYPE, 330, 280);
			setBtnChangeState();
			/*send lên server cho lớp kế thừa*/
			processBuyItem(id, zMoney);
			
		}
		
		/**
		 * send dữ liệu lên server và update vào dataMgr
		 * @param	id: id của item
		 * @param	num: số lượng của item
		 */
		protected virtual function processBuyItem(id:int, num:int):void 
		{
			
		}
		
		
		private function changeGift(id:int):void 
		{
			
		}
		
		protected virtual function sendChangeGift(id:int):void
		{
			
		}
		
		private function setBtnChangeState():void 
		{
			
		}
		
		protected virtual function remindFriend():void 
		{
			
		}
		
		
	}

}


































