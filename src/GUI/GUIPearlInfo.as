package GUI 
{
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.SpriteExt;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIPearlInfo extends BaseGUI 
	{
		private static var _instance:GUIPearlInfo;
		private const PEARLWHITE:int = 1;
		private const PEARLGREEN:int = 2;
		private const PEARLYELLOW:int = 3;
		//Thứ tự của các quà khủng trong Object nhận về
		private const GIFTTYPENO:int = 3;
		private const HOT_1_1:String = "3";
		private const HOT_1_2:String = "6";
		private const HOT_1_3:String = "7";
		private const HOT_1_4:String = "8";
		//private const HOT_1_5:String = "9";
		
		private const HOT_2_1:String = "3";
		private const HOT_2_2:String = "6";
		private const HOT_2_3:String = "7";
		private const HOT_2_4:String = "9";
		private const HOT_2_5:String = "10";
		private const HOT_2_6:String = "11";
		private const HOT_2_7:String = "12";
		
		private const HOT_3_1:String = "3";
		private const HOT_3_2:String = "5";
		private const HOT_3_3:String = "6";
		private const HOT_3_4:String = "8";
		private const HOT_3_5:String = "9";
		private const HOT_3_6:String = "10";
		private const HOT_3_7:String = "11";
		
		private var img1:Image;
		private var img2:Image;
		private var GiftArr1:Array=[];
		private var GiftArr2:Array=[];
		private var GiftArr3:Array=[];
		private var GiftImgArr1:Array=[];
		private var GiftImgArr2:Array=[];
		private var GiftImgArr3:Array = [];
		private var _format:TextFormat;
		
		
		public function GUIPearlInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiPearlInfo";
		}
		override public function InitGUI():void 
		{
			LoadRes("GUIPearlInfo");
			//AddImage("", "ImgPearlNote", 185, 38);
			_format = new TextFormat();
			_format.size = 14;
			_format.color = 0x013467;
			_format.align = "center";
			var txtPearlNote:TextField = AddLabel("Mang đổi cho các bác trai trong hồ\n sẽ ngẫu nhiên nhận được các phần thưởng", 125, 23);
			txtPearlNote.setTextFormat(_format);
			FilterGiftToShow();
			InitGiftImageArr();
		}
		private function FilterGiftToShow():void
		{
			GiftArr1 = [];
			GiftArr2 = [];
			GiftArr3 = [];
			var AllGift:Object = ConfigJSON.getInstance().getItemInfo("EventGift");
			//ngọc trắng cho 4 quà khủng
			GiftArr1.push(AllGift["1"][HOT_1_1]);//material
			GiftArr1.push(AllGift["1"][HOT_1_2]);
			GiftArr1.push(AllGift["1"][HOT_1_3]);
			GiftArr1.push(AllGift["1"][HOT_1_4]);
			//GiftArr1.push(AllGift["1"][HOT_1_5]);
			//ngọc xanh cho 6 quà khủng
			GiftArr2.push(AllGift["2"][HOT_2_1]);//material
			GiftArr2.push(AllGift["2"][HOT_2_2]);
			GiftArr2.push(AllGift["2"][HOT_2_3]);
			GiftArr2.push(AllGift["2"][HOT_2_4]);
			GiftArr2.push(AllGift["2"][HOT_2_5]);
			GiftArr2.push(AllGift["2"][HOT_2_6]);
			GiftArr2.push(AllGift["2"][HOT_2_7]);
			//ngọc vàng cho 6 quà khủng
			GiftArr3.push(AllGift["3"][HOT_3_1]);//material
			GiftArr3.push(AllGift["3"][HOT_3_2]);
			GiftArr3.push(AllGift["3"][HOT_3_3]);
			GiftArr3.push(AllGift["3"][HOT_3_4]);
			GiftArr3.push(AllGift["3"][HOT_3_5]);
			GiftArr3.push(AllGift["3"][HOT_3_6]);
			GiftArr3.push(AllGift["3"][HOT_3_7]);
		}
		
		
		private function InitGiftImageArr():void
		{
			var level:int = GameLogic.getInstance().user.GetLevel();
			var sFishImg:String = Ultility.GetFishByLevelUser(level);
			GiftImgArr1 = [];
			GiftImgArr2 = [];
			GiftImgArr3 = [];
			//mảng quà của ngọc trắng
			GiftImgArr1.push(Ultility.GetNameMatFromType(GiftArr1[0].ItemId));
			GiftImgArr1.push(GiftArr1[1].ItemType + GiftArr1[1].ItemId);
			GiftImgArr1.push(GiftArr1[2].ItemType + GiftArr1[2].ItemId);
			GiftImgArr1.push(GiftArr1[3].ItemType + GiftArr1[3].ItemId);
			//GiftImgArr1.push(GiftArr1[4].ItemType);
			
			GiftImgArr2.push(Ultility.GetNameMatFromType(GiftArr2[0].ItemId));
			GiftImgArr2.push(GiftArr2[1].ItemType + GiftArr2[1].ItemId);
			GiftImgArr2.push(GiftArr2[2].ItemType + GiftArr2[2].ItemId);
			GiftImgArr2.push(GiftArr2[3].ItemType + GiftArr2[3].ItemId);
			GiftImgArr2.push(sFishImg/*GiftArr2[4].ItemType + GiftArr2[4].ItemId GiftArr2[5].ItemType*/);
			GiftImgArr2.push(GiftArr2[5].ItemType);
			GiftImgArr2.push(GiftArr2[6].ItemType);
			
			GiftImgArr3.push(Ultility.GetNameMatFromType(GiftArr3[0].ItemId));
			GiftImgArr3.push(GiftArr3[1].ItemType + GiftArr3[1].ItemId);
			GiftImgArr3.push(GiftArr3[2].ItemType + GiftArr3[2].ItemId);
			GiftImgArr3.push(GiftArr3[3].ItemType + GiftArr3[3].ItemId);
			GiftImgArr3.push(sFishImg/*GiftArr3[4].ItemType + GiftArr3[4].ItemId GiftArr3[5].ItemType*/);
			GiftImgArr3.push(GiftArr3[5].ItemType);
			GiftImgArr3.push(GiftArr3[6].ItemType);
		}

		public static function GetInstacne():GUIPearlInfo
		{
			if (_instance == null)
				_instance = new GUIPearlInfo(null, "");
			return _instance;
		}
		public function ShowGUI(type:int):void
		{
			RemoveAllButtonEx();
			RemoveAllContainer();
			RemoveAllImage();
			Show(Constant.GUI_MIN_LAYER, 0);
			var fishImage:SpriteExt;
			var cl:int;
			var img2Domain:Image;
			var data:Array;
			var sp:Sprite;
			var imgXFish:Image;
			switch(type)
			{
				case PEARLWHITE:
					img1 = AddImage("", "Img2SlotGift", 180, 105);
					img2 = AddImage("", "Img2SlotGift", 180, 181);
					AddImage("", GiftImgArr1[0], 165, 131);
					AddImage("", GiftImgArr1[1], 216, 107);
					AddImage("", GiftImgArr1[2], 150, 180);
					AddImage("", GiftImgArr1[3], 216, 180);
					SetPos(250, 5);
				break;
				case PEARLGREEN:
					img1 = AddImage("", "Img3SlotGift", 173, 105);
					img2 = AddImage("", "Img2SlotGift", img1.img.x + 30, 181);
					AddImage("", "Img2SlotGift", 245, 181);
					AddImage("", "Img2SlotGift", 245, 181);
					AddImage("", GiftImgArr2[0], 130, 126);
					AddImage("", GiftImgArr2[1], 171, 103);
					AddImage("", GiftImgArr2[2], 236, 106);
					AddImage("", GiftImgArr2[3], 69, 180);
					//add con cá quý.
					data = GiftImgArr2[4].split("+");
					
					fishImage = new SpriteExt();
					fishImage.loadComp = function f():void
					{
						AddImageBySprite(fishImage.img, 150, 180);
						//add glow
						cl = 0xffff00;
						TweenMax.to(fishImage.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
						if (data.length > 1)//co domain
						{
							//add domain
							fishImage.img.y = 190;
							img2Domain = AddImage("imgDomain", data[1], fishImage.img.x - 10, fishImage.img.y - 30);
							img2Domain.FitRect(30, 30);
						}
						else
						{
							fishImage.img.x = 135;
						}
						sp = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
						fishImage.img.addChild(sp);
						fishImage.img.width = 70;
						fishImage.img.height = 70;
					}			
					fishImage.loadRes(data[0]);
					
					imgXFish = AddImage("", GiftImgArr2[5], 265, 205);
					imgXFish.FitRect(70, 70);
					imgXFish = AddImage("", GiftImgArr2[6], 327, 210);
					imgXFish.FitRect(60, 60);
					/*
					AddImage("", GiftImgArr2[0], 107, 103);
					AddImage("", GiftImgArr2[1], 171, 103);
					AddImage("", GiftImgArr2[2], 236, 106);
					AddImage("", GiftImgArr2[3], 109, 180);
					//add con cá quý.
					data = GiftImgArr2[4].split("+");
					
					fishImage = new SpriteExt();
					fishImage.loadComp = function f():void
					{
						AddImageBySprite(fishImage.img, 190, 180);
					}			
					fishImage.loadRes(data[0]);
					//add glow
					cl = 0xffff00;
					TweenMax.to(fishImage.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
					if (data.length > 1)//co domain
					{
						//add domain
						fishImage.img.y = 190;
						img2Domain = AddImage("imgDomain", data[1], fishImage.img.x - 10, fishImage.img.y - 30);
						img2Domain.FitRect(30, 30);
						
					}
					else
					{
						fishImage.img.x = 180;
					}
					sp = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
					fishImage.img.addChild(sp);
					fishImage.img.width = 70;
					fishImage.img.height = 70;
					//fsImage.FitRect(70, 70);
					//AddImage("", GiftImgArr2[4], 227, 210);
					imgXFish = AddImage("", GiftImgArr2[5], 300, 205);
					imgXFish.FitRect(75, 75);
					*/
					SetPos(250, 160);
				break;
				case PEARLYELLOW:
					img1 = AddImage("", "Img3SlotGift", 173, 105);
					img2 = AddImage("", "Img2SlotGift", img1.img.x + 30, 181);
					AddImage("", "Img2SlotGift", 245, 181);
					AddImage("", GiftImgArr3[0], 130, 126);
					AddImage("", GiftImgArr3[1], 171, 103);
					AddImage("", GiftImgArr3[2], 236, 106);
					AddImage("", GiftImgArr3[3], 69, 180);
					//add con cá quý.
					data = GiftImgArr2[4].split("+");
					
					fishImage = new SpriteExt();
					fishImage.loadComp = function f():void
					{
						AddImageBySprite(fishImage.img, 150, 180);
						//add glow
						cl = 0xffff00;
						TweenMax.to(fishImage.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
						if (data.length > 1)//co domain
						{
							//add domain
							fishImage.img.y = 190;
							img2Domain = AddImage("imgDomain", data[1], fishImage.img.x - 10, fishImage.img.y - 30);
							img2Domain.FitRect(30, 30);
						}
						else
						{
							fishImage.img.x = 135;
						}
						sp = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
						fishImage.img.addChild(sp);
						fishImage.img.width = 70;
						fishImage.img.height = 70;
					}			
					fishImage.loadRes(data[0]);
					
					imgXFish = AddImage("", GiftImgArr3[5], 260, 210);
					imgXFish.FitRect(60, 60);
					imgXFish = AddImage("", GiftImgArr3[6], 327, 210);
					imgXFish.FitRect(60, 60);
					SetPos(250, 320);
				break;
			}
		}
	}

}






































