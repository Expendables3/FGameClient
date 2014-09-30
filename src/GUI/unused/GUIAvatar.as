package GUI.unused 
{
	import flash.net.SharedObject;
	import GUI.component.Button;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendChooseAvatar;
	import NetworkPacket.PacketSend.SendCreateUser;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIAvatar extends BaseGUI
	{
		private var containerBoy:Container;
		private var containerGirl:Container;
		private var BtnOk:Button;
		
		private const CTN_BOY:String = "CtnBoy";
		private const CTN_GIRL:String = "CtnGirl";
		private const BTN_OK:String = "BtnOk";
		public var chooseAvatar:Boolean = false;
		
		private var idAvatar:int = -1;
		
		public function GUIAvatar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAvatar";
		}
		public override function InitGUI() :void
		{
			LoadRes("ImgBgGUIChooseAvatar");
			SetPos((Constant.STAGE_WIDTH - this.img.width) / 2, (Constant.STAGE_HEIGHT - this.img.height) / 2);
			containerBoy = AddContainer(CTN_BOY, "ImgBackgroundChooseAvatar", 41 , 55, true, this);
			containerBoy.AddImage("img_Boy", "Character0", 75 + 26, 182 + 50);
			containerBoy.SetHighLight();
			containerGirl = AddContainer(CTN_GIRL, "ImgBackgroundChooseAvatar", 234, 55,true, this);
			//containerGirl.AddImage("img_Girl", "Character1", 75, 182);
			containerGirl.AddImage("img_Girl", "Character1", 90 + 26, 122 + 50);
			containerGirl.ImageArr[0].GoToAndStop(1);
			//AddImage("Label_Avatar", "NameSeriQuest1", 132, 20);
			BtnOk = AddButton(BTN_OK, "BtnAccept", 163, 275);
			BtnOk.img.height = 34;
			BtnOk.img.width = 108;
			idAvatar = 0;
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_OK:
						if (chooseAvatar)
						{
							if (GameLogic.getInstance().user.AvatarType != idAvatar)
							{
								var ChooseAvatar:SendChooseAvatar = new SendChooseAvatar(idAvatar);
								Exchange.GetInstance().Send(ChooseAvatar);
							}
							//SharedObject.getLocal("SavedInviteFriendSetting").clear();
						}
						else
						{
							var CreateUser:SendCreateUser = new SendCreateUser(idAvatar);
							Exchange.GetInstance().Send(CreateUser);
						}
						SharedObject.getLocal("SavedInviteFriendSetting").clear();
					Hide();
				break;
				
				default:
					if(buttonID == CTN_BOY)
					{
						containerBoy.SetHighLight();
						containerBoy.ImageArr[0].GoToAndPlay(1);
						containerGirl.SetHighLight( -1);
						containerGirl.ImageArr[0].GoToAndStop(1);
						idAvatar = 0;
					}
					if (buttonID == CTN_GIRL)
					{
						containerBoy.SetHighLight(-1);
						containerBoy.ImageArr[0].GoToAndStop(1);
						containerGirl.SetHighLight();
						containerGirl.ImageArr[0].GoToAndPlay(1);
						idAvatar = 1;
					}
				break;
			}
		}
	}

}