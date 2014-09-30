package GUI.EventWarChampion 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.AvatarImage;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemLuckyUser extends Container 
	{
		static public const BTN_GET_GIFT:String = "btnGetGift";
		
		public function ItemLuckyUser(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function init(data:Object):void
		{
			LoadRes("");
			var avatarURL:String;
			var name:String;
			var soldier:FishSoldier;
			if (data != null)
			{
				avatarURL = data["AvatarLink"];
				if (avatarURL == null || avatarURL == "")
				{
					avatarURL = Main.staticURL + "/avatar.png";
				}
				if(data["Name"] != null)
				{
					name = data["Name"];
				}
				else
				{
					name = "No Name";
				}
				
				if (data["maxSoldier"] != null)
				{
					soldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Fish" + data["maxSoldier"]["FishTypeId"] + "_Old_Idle");
					soldier.SetInfo(data["maxSoldier"]);
					var imageSoldier:Image = AddImage("", soldier.ImgName, 0, 115);
					UpdateFishContent(soldier, imageSoldier);
				}
			}
			else
			{
				avatarURL = Main.staticURL + "/avatar.png";
				name = "Chưa có";
			}
			
			//var imageAvatar:Image = AddImage("", avatarURL, 0, 10, false);
			//imageAvatar.FitRect(60, 60, new Point(-90, -80));
			
			var avatar:AvatarImage = new AvatarImage(this.img);
			avatar.initAvatar(avatarURL , loadAvatarComplete);
			
			function loadAvatarComplete():void
			{
				this.FitRect(60, 60, new Point(-90, -80));
			}
			//avatar.SetPos( -90, -80);
			
			var txtFieldName:TextField = AddLabel(Ultility.StandardString(name, 10), -108, -20);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffff00, true);
			txtFormat.align = "center";
			txtFieldName.setTextFormat(txtFormat);	
			
			
		}
		
		private function UpdateFishContent(curSoldier:FishSoldier, curSoldierImg:Image):void
		{
			var s:String;
			var i:int;
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(curSoldierImg, eq.Type, eq.imageName);
				}
			}
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, Type:String, resName:String = ""):void
		{
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
					dob.name = Type;
					child.parent.removeChild(child);
				}
				eq.loadRes(resName);
			}
		}
		
	}

}