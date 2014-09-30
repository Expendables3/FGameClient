package GUI.EventBirthDay.EventGUI 
{
	import Effect.EffectMgr;
	import flash.text.TextField;
	import GUI.EventBirthDay.EventLogic.MagicLampItemInfo;
	import GUI.EventBirthDay.EventPackage.SendGetGiftMagicLamp;
	import GUI.GUIChooseElementAbstract;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	import Logic.User;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIChooseElementBirthDay extends GUIChooseElementAbstract 
	{
		private var _data:MagicLampItemInfo;
		private var GuiMagicLamp:GUIMagicLamp;
		public function GUIChooseElementBirthDay(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChooseElementBirthDay";
		}
		
		public function initData(data:MagicLampItemInfo, guiMagicLamp:GUIMagicLamp):void 
		{
			if (data.HitGift.ClassName=="GiftNormal")
			{
				IdMaterial = data.HitGift["ItemId"];
			}
			GuiMagicLamp = guiMagicLamp;
			_data = data;
		}
		
		override public function receiveGift(element:int):void 
		{
			/*gửi lên server*/
			var gift:AbstractGift;
			var id:int = _data.Id;
			var imgName:String;
			var isGen:Boolean = false;
			
			var pk:SendGetGiftMagicLamp = new SendGetGiftMagicLamp(false, id, element);
			Exchange.GetInstance().Send(pk);
			if (Type == "Element")
			{
				gift = _data.HitGift;
				isGen = true;
				(gift as GiftSpecial).Element = element;
				imgName = (gift as GiftSpecial).getImageName();
			}
			else if (Type == "Material")
			{
				var user:User = GameLogic.getInstance().user;
				switch(element) {
					case MONEY:
						gift = _data.GiftObj["Money"] as GiftNormal;
						user.UpdateUserMoney((gift as GiftNormal).Num, true);
					break;
					case EXP:
						gift = _data.GiftObj["Exp"] as GiftNormal;
						user.SetUserExp(user.GetExp() + (gift as GiftNormal).Num, false, true);
					break;
					case MATERIAL:
						gift = _data.GiftObj["Material"] as GiftNormal;
					break;
				}
				imgName = (gift as GiftNormal).getImageName();
			}
			/*vẽ ảnh ra và cho rơi quà xuống*/
			EffectMgr.setEffBounceDown("Nhận Thành Công", imgName, 330, 280, onCompFallSpecialGift);
			//var user:User = GameLogic.getInstance().user;
			//switch(element) {
				//case MONEY:
					//user.UpdateUserMoney((gift as GiftNormal).Num, true);
				//break;
				//case EXP:
					//user.SetUserExp(user.GetExp() + (gift as GiftNormal).Num);
				//break;
			//}
			function onCompFallSpecialGift():void
			{
				if (isGen) {
					GameLogic.getInstance().user.GenerateNextID();
				}
				Hide();
				GuiMagicLamp.Hide();
				_data.IsReceived = true;
			}
		}
		override protected function addNumGift():void 
		{
			if (Type == "Material")
			{
				var numExp:int = _data.GiftObj["Exp"]["Num"];
				var numMoney:int = _data.GiftObj["Money"]["Num"];
				var numMat:int = _data.GiftObj["Material"]["Num"];
				var tf1:TextField = AddLabel(Ultility.StandardNumber(numMoney), 10, 112, 0xffffff, 1, 0x000000);
				var tf2:TextField = AddLabel(Ultility.StandardNumber(numExp), 125, 112, 0xffffff, 1, 0x000000);
				var tf3:TextField = AddLabel(numMat.toString(), 240, 112, 0xffffff, 1, 0x000000);
				tf1.scaleX = tf1.scaleY = tf2.scaleX = tf2.scaleY = tf3.scaleX = tf3.scaleY = 1.5;
			}
		}
	}
}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
