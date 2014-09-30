package Logic 
{
	import adobe.utils.CustomActions;
	import com.adobe.utils.IntUtil;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.NetStatusEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.adobe.crypto.MD5;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.system.Capabilities;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import GameControl.GameController;
	import GUI.BossServer.Soldier;
	import GUI.BossServer.SoldierEquipment;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.SpriteExt;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWorld.FishWorldController;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class Ultility
	{		
		public function Ultility() 
		{
			
		}
		
		// tăng dung lượng Share Object trong flash
		private static var so:SharedObject = SharedObject.getLocal("objTestClient");
		public static function FlushData(shareObject:SharedObject):void 
		{
			so = shareObject;
			var flusStatus:String = null;
			try 
			{
				flusStatus = so.flush();
			}
			catch (err:Error)
			{
				trace("Lỗi không ghi được vào ShareObject");
			}
			if (flusStatus != null)
			{
				switch (flusStatus) 
				{
					case SharedObjectFlushStatus.FLUSHED:
						//trace("Đã ghi vào log");
					break;
					case SharedObjectFlushStatus.PENDING:
						so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
					break;
				}
			}
		}
		/**
		 * 
		 * @param	number		: Số cần làm tròn 
		 * @param	numRound	: Số chữ số còn giữ lại sau dấu phẩy
		 * @return
		 */
		public static function RoundNumber(number:Number, numRound:int):Number
		{
			var i:int = 0
			for (i = 0; i < numRound; i++) 
			{
				number = number * 10;
			}
			number = Math.round(number);
			for (i = 0; i < numRound; i++) 
			{
				number = number / 10;
			}
			return number;
		}
		
		public static function ShowEffText(str:String, parentEff:DisplayObject, posStart:Point, posEnd:Point, txtFormat:TextFormat = null, OutLine:Number = 1, OutLineColor:int = 0x000000, speed:Number = 1, FadeSpeed:Number = -0.05, isEmbedFont:Boolean = false):void 
		{
			if (txtFormat == null)
			{
				//txtFormat = new TextFormat(null, 12, 0xFF0000);
				txtFormat = new TextFormat(null, 12, 0xFFFF00);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
			}
			// Eff không được dùng bay lên
			var child:Sprite = new Sprite();	
			child.addChild(Ultility.CreateSpriteText(str, txtFormat, OutLine, OutLineColor, isEmbedFont));		
			var eff:ImgEffectFly;
			eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
			eff.SetInfo(int(posStart.x), int(posStart.y), int(posEnd.x), int(posEnd.y), speed, FadeSpeed);
		}
		
		public static function GetFishSoldierCanWarFromLogic():Array
		{
			//var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var arrReturn:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i] as FishSoldier;
				if (item.Status == FishSoldier.STATUS_HEALTHY && item.Health >= item.AttackPoint)
				{
					arrReturn.push(item);
				}
			}
			return arrReturn;
		}
		
		public static function GetFishSoldierCanGoToWorld():Array
		{
			//var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var arrReturn:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i] as FishSoldier;
				if (item.Status == FishSoldier.STATUS_HEALTHY)
				{
					arrReturn.push(item);
				}
			}
			return arrReturn;
		}
		
		public static function GetFishSoldierCanWar():Array
		{
			//var arr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var arr:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var arrReturn:Array = [];
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i] as FishSoldier;
				if (item.Status == FishSoldier.STATUS_HEALTHY && item.Health >= item.AttackPoint)
				{
					arrReturn.push(item);
				}
			}
			return arrReturn;
		}
		
		public static function IsKillBoss():Boolean
		{
			if (IsInMyFish()) 
			{
				return false;
			}
			else 
			{
				if (FishWorldController.GetRound() < Constant.SEA_ROUND_4)
				{
					return false;
				}
				else 
				{
					return true;
				}
			}
		}
		
		public static function GetNameElement(element:int):String
		{
			var s:String = "";
			switch (element) 
			{
				case 1:
					s = "Kim";
				break;
				case 2:
					s = "Mộc";
				break;
				case 3:
					s = "Thổ";
				break;
				case 4:
					s = "Thủy";
				break;
				case 5:
					s = "Hỏa";
				break;
				default:
					s = "";
				break;
			}
			return s;
		}
		
		public static function IsInMyFish():Boolean
		{
			if (GameController.getInstance().typeFishWorld == Constant.TYPE_MYFISH)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public static function PanScreenView(isinFishWorld:Boolean = false):void 
		{
			var layerBg:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			var layerGui:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			if(!isinFishWorld)
			{
				GameController.getInstance().PanScreenX( -(Constant.MAX_WIDTH - Constant.STAGE_WIDTH)/2);
				GameController.getInstance().PanScreenY( -(Constant.MAX_HEIGHT - Constant.STAGE_HEIGHT) / 2 - 100);
				
			}
			else 
			{
				GameController.getInstance().PanScreenX( (Constant.MAX_WIDTH - Constant.STAGE_WIDTH)/2);
				GameController.getInstance().PanScreenY( (Constant.MAX_HEIGHT - Constant.STAGE_HEIGHT)/2 - 100);
			}
		}
		
		private static function onFlushStatus(event:NetStatusEvent):void 
		{
			so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
			switch (event.info.code) 
			{
				case "SharedObject.Flush.Failed":
					FlushData(so);
				break;
				case "SharedObject.Flush.Success":
					trace("Đã tăng giới hạn bộ nhớ");
				break;
			}
		}
		
		/**
		 * Lấy 1 số ngẫu nhiên trong khoảng [low,high]
		 * @param low giá trị min nhất có thể được trả về
		 * @param high giá trị max nhất có thể được trả về
		 */
		public static function RandomNumber(low:Number=0, high:Number=1):Number
		{			
			return Math.floor(Math.random() * (1+high-low)) + low;
		}
		
		public static function PosScreenToLake(x:int, y :int):Point
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			var pos:Point;				
			pos = new Point(x, y);
			pos = layer.globalToLocal(pos);
			return pos;
		}
		
		public static function PosLakeToScreen(x:int, y:int):Point
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			var pos:Point;				
			pos = new Point(x, y);
			pos = layer.localToGlobal(pos);
			return pos;
		}
		
		/**
		 * Hàm kiểm tra xem timeStamp có phải là 1 thời điểm trong ngày hiện tại không
		 * @param	timeStamp
		 * @return
		 */
		public static function CheckDate(timeStamp:Number, secondsDelay:Number = 0):Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime - secondsDelay;
			var curDate:Date = new Date(curTime * 1000);
			var checkDate:Date = new Date(timeStamp * 1000);
			
			//var hourUTCCheck:int = checkDate.hoursUTC;
			//var minUTCCheck:int = checkDate.minutesUTC;
			//var secUTCCheck:int = checkDate.secondsUTC;
			
			var dateUTCCur:int = curDate.dateUTC;
			var hourUTCCur:int = curDate.hoursUTC;
			hourUTCCur += Constant.TIME_ZONE_SERVER;
			if (hourUTCCur >= 24)
			{
				hourUTCCur -= 24;
				dateUTCCur ++;
			}
			if (	curDate.getFullYear() == checkDate.getFullYear()
					&& curDate.getMonth() == checkDate.getMonth()
					&& curDate.getDate() == checkDate.getDate())
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public static function getImgNameDomainFish(FishTypeId:int):String
		{
			var domain:int = DomainFish(FishTypeId);
			if (domain > 0)
			{
				return Fish.DOMAIN + domain.toString();
			}
			else 
			{
				return "";
			}
		}
		
		public static function getImgNameFish(FishTypeId:int):String
		{
			var domain:int = DomainFish(FishTypeId);
			var id:int = FishTypeId - Math.max(0, domain);
			return "Fish" + id + "_" + Fish.OLD + "_" + Fish.HAPPY;
		}
		
		public static function DomainFish(FishTypeId:int):int 
		{
			var domain:int;
			if (FishTypeId < Constant.FISH_TYPE_START_DOMAIN)
			{
				domain = -1;
			}
			else 
			{
				domain = (FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
			}
			return domain;
		}
		
		public static function MD5Hash(st:String):String
		{
			return MD5.hash(st);
		}
		
		public static function CreateSpriteText(text:String, textFormat:TextFormat, Outline:int = 0, OutlineColor:int = 0,  IsEmbedFont:Boolean = false):Sprite
		{
			var sprite:Sprite = new Sprite;
			var txt:TextField = new TextField();
			txt.text = text;
			if (textFormat.align)
			{
				txt.autoSize = textFormat.align;
			}
			txt.embedFonts = IsEmbedFont;
			txt.defaultTextFormat = textFormat;
			txt.setTextFormat(textFormat);			
			txt.mouseEnabled = false;
			if (Outline != 0)
			{
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.strength = Outline;
				outline.color = OutlineColor;
				var arr:Array = [];
				arr.push(outline);
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.filters = arr;
			}
			sprite.addChild(txt);
			sprite.mouseChildren = false;
			sprite.mouseEnabled = false;
			var r:Rectangle = txt.getBounds(sprite);
			switch (textFormat.align)
			{
				case "left":
					txt.x = 0;
					break;
				default:
					txt.x = -r.width / 2;
					break;
			}			
			txt.y = -r.height / 2;
			return sprite;
		}
		
		/**
		 * Hàm tạo sprite từ text viết lại hàm CreateSpriteText vì hàm này tạo ra sprite kích thước quá lớn so với text
		 * @param	value giá trị text
		 * @param	txtFormat
		 * @param	outlineColor
		 * @return
		 */
		public static function createSpriteFromText(value:String, txtFormat:TextFormat = null, outlineColor:int = -1):Sprite
		{
			var textField:TextField = new TextField();
			textField.text = value;
			if(txtFormat == null)
			{
				txtFormat = new TextFormat("Arial", 14, 0xffffff, true);
			}
			textField.setTextFormat(txtFormat);
			textField.autoSize = TextFieldAutoSize.LEFT;
			if (outlineColor != -1)
			{
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.color = outlineColor;
				var arr:Array = [];
				arr.push(outline);
				textField.antiAliasType = AntiAliasType.ADVANCED;
				textField.filters = arr;
			}
			var sprite:Sprite = new Sprite();
			sprite.addChild(textField);
			sprite.mouseChildren = false;
			sprite.mouseEnabled = false;
			
			return sprite;
		}
		
		public static function CheckNameFish(name:String):Boolean
		{
			if (name == "")
			{
				return false;
			}
			return true;
		}		
		
		/**
		 * Xác đinh xem ngư thạch thuộc loại nào loại 1 hay
		 * @param	typeMat: là typeId của ngư thạch 1 - 101 - 2 - 102 - ...
		 * @return	index của ngư thạch trong mảng ngư thạch 0 - 1 - 2 - 3 - ...
		 */
		public static function GetIndexMatInArrMat(typeMat:int):int
		{
			return (typeMat % 100 - 1) * 2 + int(typeMat / 100);
		}
		
		public static function GetTypeMatFromIndex(index:int):int
		{
			return (index % 2) * 100 + int(index / 2) + 1;
		}
		
		public static function SetEnableSprite(img:Sprite, IsEnable:Boolean = true, brightness:Number = 0.43):void
		{
			if (!IsEnable)
			{
				img.mouseEnabled = false;
				img.mouseChildren = false;
				var elements:Array =
				[brightness, brightness, brightness, 0, 0,
				brightness, brightness, brightness, 0, 0,
				brightness, brightness, brightness, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
			}
			else
			{
				img.mouseEnabled = true;
				img.mouseChildren = true;
				img.filters = null;
			}
		}
		
		public static function GetNameMatFromType(typeMat:int):String
		{
			var str:String = "Material";
			if (typeMat > 100)
			{
				str = str + int(typeMat % 100).toString() + "S";
			}
			else 
			{
				str = str + typeMat.toString();
			}
			return str;
		}
		
		public static function GetNameMatFromIndex(index:int):String 
		{
			var typeMat:int = GetTypeMatFromIndex(index);
			return GetNameMatFromType(typeMat);
		}
		
		public static function CheckMatSupreFromType(typeMat:int):Boolean 
		{
			if (typeMat > 100)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		public static function CheckMatSupreFromIndex(index:int):Boolean 
		{
			if (int(index % 2) == 0)
			{
				return false;
			}
			else 
			{
				return true;
			}
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean = true):void
		{
			return;
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.addChild(mark);
			}
		}
		
		public static function SetHightLight(img:Object, color:Number = 0x000000):void
		{
			if ("filters" in img)
			{
				if (color < 0)
				{
					img.filters = null;
					return;
				}
				
				var glow:GlowFilter = new GlowFilter(color, 1, 5, 5, 5);
				img.filters = [glow];
			}
		}
		
		public static function EffExpMoneyEnergy(type:String, value:int):Sprite
		{
			var st:String = StandardNumber(value);
			if (value > 0)
			{
				st = "+" + StandardNumber(value);
			}
			//else if (value == 0)
			//{
				//return null;
			//}
			var arr:Array = [];
			var child:Sprite = new Sprite();
			var icon:Sprite;
			
			switch(type)
			{
				case "money":
					icon = ResMgr.getInstance().GetRes("IcGold") as Sprite;
					break;
				case "exp":
					icon = ResMgr.getInstance().GetRes("ImgEXP") as Sprite;
					break;
				case "energy":
					icon = ResMgr.getInstance().GetRes("IcEnergy") as Sprite;
					break;
				
			}
			
			var txtFormat :TextFormat = new TextFormat("Arial", 12, 0xffffff, true);
			txtFormat.align = "left";
			
			child.addChild(icon);
			icon.x = -icon.width;
			icon.y = -16;			
			var txt:Sprite = Ultility.CreateSpriteText(st, txtFormat);
			child.addChild(txt);
			
			return child;
			//arr.push(child);			
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffExp", arr, x, y);
		}
		
		public static function findChild(ImgObj:DisplayObjectContainer, key:String):DisplayObject
		{
			if (ImgObj == null)
			{
				return null;
			}
			
			var obj:DisplayObject;
			obj = ImgObj.getChildByName(key);
			if (obj != null)
			{
				
			}
				
			for (var j:int = 0; j < ImgObj.numChildren; ++j)
			{ 
				obj = ImgObj.getChildAt(j) as DisplayObject;
				if (obj.name == key)
				{
					return obj;
				}
				if (obj is DisplayObjectContainer)
				{
					var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
					if (doc.numChildren > 0)
					{
						var ret:DisplayObject = findChild(doc, key);
						if (ret != null)
						{
							return ret;
						}
					}
				} 
			}
			return null;
		}		
		
		public static function ChangeButtonColor(ImgObj:DisplayObjectContainer, Color:ColorTransform, Key:String):void
		{
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(ImgObj, Key + i);
			while (child != null)
			{
				child.transform.colorTransform = Color;
				i++;
				child = Ultility.findChild(ImgObj, Key + i);
			}

		}		
		
		/**
		 * Clone 1 sprite
		 * @param	src
		 * @return
		 */
		public static function CloneImage(src:Sprite):Sprite
		{
			var image:Sprite = new Sprite;
			
			var targetClass:Class = Object(src).constructor;
			image = new targetClass() as Sprite;
			image.transform = src.transform;
			image.transform.colorTransform = src.transform.colorTransform;
			image.filters = src.filters;
			image.cacheAsBitmap = src.cacheAsBitmap;
			image.opaqueBackground = src.opaqueBackground;
			if (src.scale9Grid)
			{
				var rect:Rectangle = src.scale9Grid;			
				if (Capabilities.version.split(" ")[1] == "9,0,16,0"){
				//Flash 9 bug where returned scale9Grid as twips
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				}			
				image.scale9Grid = rect;
			}
			image.graphics.copyFrom(src.graphics);
			
			return image;
		}
		
		public static function UpdateColor(ImgObj:DisplayObjectContainer, FishTypeId:int, ColorLevel:int):void
		{
			var a:Array = Config.getInstance().GetFishColor(FishTypeId, ColorLevel);
			var i:int;
			var c:ColorTransform;
			
			for (i = 0; i < a.length; i++)
			{
				var obj:Object = a[i];
				c = new ColorTransform(1, 1, 1, 1, obj["Red"], obj["Green"], obj["Blue"], obj["Alpha"]);
				ChangeButtonColor(ImgObj, c, obj["Key"]);
			}
		}
		
		/**
		 * Chuyển 1 khoảng thời gian thành String
		 * @param	time khoảng thời gian tính theo milisecond
		 * @return chuỗi thời gian
		 */
		public static function ConvertTimeToString(time:Number, returnDay:Boolean = true, returnHour:Boolean = true, returnMinute:Boolean = true):String
		{
			var hour:int = time / 3600;
			var minute:int = (time % 3600)/60;		
			var day:int = hour / 24;
			hour = hour % 24;
			
			var st:String = "";
			if (day > 0 && returnDay)	st += day + " ngày ";
			if (hour > 0 && returnHour)	st += hour + " giờ ";
			if (minute > 0 && returnMinute)	st += minute + " phút";			
				
			return st;
		}
		
		static public function ConvertStringToInt(text:String):Number
		{
			var s:String = "";
			var a:Array = text.split(",")
			for (var i:int = 0; i < a.length; i++ )
			{
				s = s + a[i];
			}
			return Number(s);
		}
		
		/**
		 * Định dạng số theo chuẩn
		 * @param	num: số cần chuẩn hóa
		 * @return	Số sau khi đã chuẩn hóa
		 */
		public static function StandardNumber(num:Number):String
		{
			var i:int;			
			var absNum:Number = Math.abs(num);
			var st:String = absNum.toString();
			var result:String = "";
			if (absNum >= 1000)
			{
				st = st.split("").reverse().join("");
				for (i = 0; i <= st.length; i += 3)
				{					
					result = result.concat(st.substr(i, 3));
					if (st.substr(i+3).length > 0)
					{
						result = result.concat(",");
					}
				}
				st = result.split("").reverse().join("");
			}
			
			if (num < 0)
			{
				st = "-" + st;
			}
			return st;
		}
		public static function StandardNumber2(num:Number):String
		{
			if (num / 1000000 >= 1)
			{
				var n:int = int(num / 1000000);
				var du:int = int(num) % 1000000;
				var n2:int = du / 100000;
				if (n2 > 0)
				{
					return n + "." + n2 + "tr";
				}
				else
				{
					return n + "tr";
				}
			}
			else
			{
				return StandardNumber(num);
			}
			var i:int;			
			var absNum:Number = Math.abs(num);
			var st:String = absNum.toString();
			var result:String = "";
			if (absNum >= 1000)
			{
				st = st.split("").reverse().join("");
				for (i = 0; i <= st.length; i += 3)
				{					
					result = result.concat(st.substr(i, 3));
					if (st.substr(i+3).length > 0)
					{
						result = result.concat(",");
					}
				}
				st = result.split("").reverse().join("");
			}
			
			if (num < 0)
			{
				st = "-" + st;
			}
			return st;
		}
		
		/** LocLv
		 *  lọc những kí tự tiếng Việt
		 */
		public static function filterVietnameseCharacter(value:String, toLowerCase:Boolean = false):String {
			var _value:String = value;
			if(toLowerCase)_value = value.toLowerCase();
			_value = _value.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g,"a");  
			_value = _value.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g,"e");  
			_value = _value.replace(/ì|í|ị|ỉ|ĩ/g,"i");  
			_value = _value.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g,"o");  
			_value = _value.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g,"u");  
			_value = _value.replace(/ỳ|ý|ỵ|ỷ|ỹ/g,"y");  
			_value = _value.replace(/đ/g, "d");
			return _value;
		}
		
		public static function StandardString(str:String, limitLength:int = 20):String
		{
			var st:String = "";
			if (str == null) return "";
			if (str.length > limitLength)
			{
				st = str.substr(0, limitLength).concat("...");
				return st;
			}
			return str;
		}
		
		public static function PutFishIntoCtn(f:Fish, ctn:Container, x:int = 0, y:int = 0):Image
		{
			var img:Image;
			var imgName:String = f.ImgName;
			
			var ctnSize:Point = new Point(ctn.img.width, ctn.img.height);
			
			//Hàm đổi màu ảnh của Image sẽ được gọi trong lớp Image khi loadRes và reloadRes
			var setInfo:Function = function():void
			{
				var a:Array = Config.getInstance().GetFishColor(f.FishTypeId, f.ColorLevel);
				var i:int;
				var c:ColorTransform;

				for (i = 0; i < a.length; i++)
				{
					var object:Object = a[i];
					c = new ColorTransform(1, 1, 1, 1, object["Red"], object["Green"], object["Blue"], object["Alpha"]);
					this.ChangeColor(c, object["Key"]);
				}
				this.SetScaleX(Math.min(f.Scale, 1));
				this.SetScaleY(Math.min(f.Scale, 1));
				(this as Image).img.mouseEnabled = false;
				(this as Image).img.mouseChildren = false;
				if (this.img.width > ctnSize.x || this.img.height > ctnSize.y)
				{
					(this as Image).FitRect(ctnSize.x, ctnSize.y, new Point());					
				}
			}
			
			img = ctn.AddImage("", imgName, x, y, true, Image.ALIGN_LEFT_TOP, false, setInfo);
			return img;
		}	
		
		public static function GetFishByLevelUser(level:int):String
		{
			/*hard code vì chưa có ảnh cá có levelrequire > 68*/
			if (level > 68)
				level = 68;
			////////////////////////////////////////////////////
			var sName:String = "";
			var min:int = 10000;
			var distance:int;
			var id:int;
			//var i:int = 0;
			var fObj:Object = ConfigJSON.getInstance().getItemInfo("Fish");
			for (var i:String in fObj)
			{
				if (!fObj[i])
					return sName;
				if ((int)(i) >= 200)
					continue;
				distance = Math.abs(level - fObj[i]["LevelRequire"]);
				if (distance <= min)
				{
					min = distance;
					id = fObj[i]["Id"];
				}
			}
			
			//xet domain
			var domain:int = -1;
			var imgDomain:String;
			if (id >= Constant.FISH_TYPE_START_DOMAIN)
			{
				domain = (id - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
				if (domain > 0)
				{
					id = id - domain;
					sName = "Fish" + id + "_" + Fish.OLD + "_" + Fish.IDLE + "+" + Fish.DOMAIN + domain;
				}
			}
			if (domain <= 0)
			{
				sName = "Fish" + id + "_" + Fish.OLD + "_" + Fish.IDLE;
			}
			
			return sName;
		}
		
		public static function loadFish(f:Fish, ctn:Container, x:int = 0, y:int = 0):Sprite
		{
			var spriteExt:SpriteExt = new SpriteExt();
			var image:Image;
			//Hàm đổi màu ảnh của Image sẽ được gọi trong lớp Image khi loadRes và reloadRes
			spriteExt.loadComp = function ():void
			{
				if (ctn.img == null)
				{
					return;
				}
				image = ctn.AddImageBySprite(this.img, x, y);
				var a:Array = Config.getInstance().GetFishColor(f.FishTypeId, f.ColorLevel);
				var i:int;
				var c:ColorTransform;
				
				for (i = 0; i < a.length; i++)
				{
					var object:Object = a[i];
					c = new ColorTransform(1, 1, 1, 1, object["Red"], object["Green"], object["Blue"], object["Alpha"]);
					image.ChangeColor(c, object["Key"]);
				}
				
				if(f.Sex == 0)
				{
					image.img.scaleX = (-Math.min(f.Scale, 1));
				}
				else
				{
					image.img.scaleX = Math.min(f.Scale, 1);
				}
				image.img.scaleY = (Math.min(f.Scale, 1));
				
				image.FitRect(110, 100, new Point(20, 0));
			}
			
			spriteExt.loadRes(f.ImgName);
			
			return spriteExt.img;
		}
		
		static public function updateHarvestTime(fish:Fish):void 
		{
			fish.HarvestTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish);
			var LakeId:int = fish.LakeId;
			var buffTimeLake:Object = GameLogic.getInstance().user.buffTimeAllLake;
			fish.HarvestTime = fish.HarvestTime * ( 1 - Math.min(buffTimeLake[LakeId.toString()]["Time"], Constant.MAX_BUFF_TIME) / 100);
		}
		
		/**
		 * Hàm thực hiện cập nhật lại trạng thái đã bị chết ở thế giới cá chưa
		 */
		public static function ResetStateIsDie():void 
		{
			for (var i:int = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++) 
			{
				var item:FishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i];
				item.IsDie = false;
			}
		}
		
		/**
		 * Cập nhật các thông số của cá lính khi gói tin đánh nhau dc gửi trả về (trong suốt cả user)
		 */
		public static function UpdateFishSoldier(srcArr:Object, equipArr:Object, desArr:Array, isMyArr:Boolean = true):void
		{
			var lakeId:String;	// Id hồ chứa con cá này
			var fsId:String;	// Id của con cá này
			
			var i:int;			// Chỉ để duyệt mảng
			var s:String;		// Chỉ để duyệt mảng
			var posX:int;
			var posY:int;
			
			var listCheckedFish:Object = new Object();	// Chứa thông tin những con cá đã duyệt, dùng để check con nào đã bị bán -> xóa
			
			// Cập nhật lại TOÀN BỘ thông tin của cá lính
			for (lakeId in srcArr)
			{
				// Duyệt từng con cá trong mảng nguồn
				for (fsId in srcArr[lakeId])
				{
					// Check lại là có con này hiện tại
					listCheckedFish[fsId] = 1;
				}
			}
			
			//  Xóa các con cá ko còn trong hồ
			if (isMyArr)
			{
				if (!listCheckedFish[GameLogic.getInstance().user.CurSoldier[0].Id])
				{
					GameLogic.getInstance().user.CurSoldier[0].isChoose = false;
					GameLogic.getInstance().user.CurSoldier[0] = null;
				}
				
				for (i = 0; i < desArr.length; i++)
				{
					if (!listCheckedFish[desArr[i].Id])
					{
						desArr[i].Destructor();
						desArr.splice(i, 1);
					}
				}
			}
			else
			{
				for (i = 0; i < desArr.length; i++)
				{
					if (!listCheckedFish[desArr[i].Id])
					{
						desArr[i].Destructor();
						desArr.splice(i, 1);
					}
				}
			}
			
			for (lakeId in srcArr)
			{
				// Duyệt từng con cá trong mảng nguồn
				for (fsId in srcArr[lakeId])
				{
					// Tìm con cá trong mảng đích
					var fishDes:FishSoldier = FindFishInArr(int(fsId), desArr);
					
					var a:Array = GameLogic.getInstance().user.CurSoldier;
					
					if (fishDes)
					{
						fishDes.SetInfo(srcArr[lakeId][fsId]);
						if (equipArr == null)
						{
							equipArr = new Object();
						}
						if (equipArr["listMeridian"] != null && equipArr["listMeridian"][fishDes.Id] != null)
						{
							
							fishDes.meridianVitality = int(equipArr["listMeridian"][fishDes.Id]["Vitality"]);
							fishDes.meridianDamage = int(equipArr["listMeridian"][fishDes.Id]["Damage"]);
							fishDes.meridianCritical = int(equipArr["listMeridian"][fishDes.Id]["Critical"]);
							fishDes.meridianDefence = int(equipArr["listMeridian"][fishDes.Id]["Defence"]);
						}
							
						//if (equipArr["SoldierList"] == null)
						//{
							//equipArr["SoldierList"] = new Object();
						//}
						//if (equipArr["SoldierList"][fsId] == null)
						//{
							//equipArr["SoldierList"][fsId] = new Object();
							//equipArr["SoldierList"][fsId].Equipment = new Object();
						//}
						if (equipArr[fsId] == null)
						{
							equipArr[fsId] = new Object();
							equipArr[fsId].Equipment = new Object();
						}
						fishDes.SetEquipmentInfo(equipArr[fsId].Equipment);
						fishDes.SetSoldierInfo();
						if (fishDes.img)
						{
							fishDes.RefreshImg();
						}
					}
					else if (IsInMyFish())
					{
						// Nếu không có thì tạo ra 1 con mới tinh
						var f:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER),
							Fish.ItemType + srcArr[lakeId][fsId].FishTypeId + "_Old_Idle");
						//f.SetInfo(srcArr[lakeId][fsId]);
						//f.SetSoldierInfo();
						//f.SetAgeState(Fish.OLD);
						
						if (isMyArr)
						{
							f.SetInfo(srcArr[lakeId][fsId]);
							f.SetSoldierInfo();
							
							if (equipArr == null)
							{
								equipArr = new Object();
							}
							if (equipArr[fsId] == null)
							{
								equipArr[fsId] = new Object();
								equipArr[fsId].Equipment = new Object();
							}
							
							//Update bonus tu ngu mach
							if (equipArr["listMeridian"] != null && equipArr["listMeridian"][f.Id] != null)
							{
								f.meridianVitality = int(equipArr["listMeridian"][f.Id]["Vitality"]);
								f.meridianDamage = int(equipArr["listMeridian"][f.Id]["Damage"]);
								f.meridianCritical = int(equipArr["listMeridian"][f.Id]["Critical"]);
								f.meridianDefence = int(equipArr["listMeridian"][f.Id]["Defence"]);
							}
							
							f.SetEquipmentInfo(equipArr["SoldierList"][fsId].Equipment);
							f.UpdateCombatSkill();
							f.SetAgeState(Fish.OLD);
							
							posX = Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - f.img.width - 50;
							posY = GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE / 2;
							f.Init(posX,posY);
							f.SwimTo(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 + f.img.width + 50, posY, 20);
							GameLogic.getInstance().user.FishSoldierActorMine.push(f);
						}
						else
						{
							// Set lại khoảng bơi cho xông xênh không là cá bị va vào khung dội lại
							//f.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 200));
							
							f.SetSwimingArea(new Rectangle(0, 0, Constant.MAX_WIDTH, Constant.MAX_HEIGHT));
							f.SetInfo(srcArr[lakeId][fsId]);
							f.SetSoldierInfo();
							
							//Update bonus tu ngu mach
							if (equipArr["listMeridian"] != null && equipArr["listMeridian"][f.Id] != null)
							{
								f.meridianVitality = int(equipArr["listMeridian"][f.Id]["Vitality"]);
								f.meridianDamage = int(equipArr["listMeridian"][f.Id]["Damage"]);
								f.meridianCritical = int(equipArr["listMeridian"][f.Id]["Critical"]);
								f.meridianDefence = int(equipArr["listMeridian"][f.Id]["Defence"]);
							}
							
							if (equipArr["SoldierList"] == null)
							{
								equipArr["SoldierList"] = new Object();
							}
							if (equipArr["SoldierList"][fsId] == null)
							{
								equipArr["SoldierList"][fsId] = new Object();
								equipArr["SoldierList"][fsId].Equipment = new Object();
							}
							
							f.SetEquipmentInfo(equipArr["SoldierList"][fsId].Equipment);
							f.UpdateCombatSkill();
							f.SetAgeState(Fish.OLD);
							
							posX = Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2 + f.img.width + 50;
							posY = GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE / 2;
							
							f.Init(posX, posY);
							f.standbyPos = GameController.getInstance().theirSoldierPos[desArr.length];
							f.SwimTo(f.standbyPos.x, f.standbyPos.y, 20);
								
							if (int(lakeId) == GameLogic.getInstance().user.CurLake.Id)
							{
								GameLogic.getInstance().user.GetFishSoldierArr().push(f);
							}
							else
							{
								GameLogic.getInstance().user.FishSoldierActorTheirs.push(f);
							}
							desArr.push(f);
						}
						//desArr.push(f);
					}
				}
			}
			
			// Tìm lại con cá mạnh nhất - Chỉ giải quyết trong trại cá
			if(IsInMyFish())
			{
				if (isMyArr)
				{
					if (!GameLogic.getInstance().user.CurSoldier[0]
						&& GameLogic.getInstance().user.CurSoldier[0].Status == FishSoldier.STATUS_HEALTHY
						&& GameLogic.getInstance().user.CurSoldier[0].Health >= GameLogic.getInstance().user.CurSoldier[0].AttackPoint)
					{
						GameLogic.getInstance().user.CurSoldier[0] = FishSoldier.FindBestSoldier(desArr, true);
					}
						
					if (GameLogic.getInstance().user.CurSoldier[0])
					{
						GameLogic.getInstance().user.CurSoldier[0].isChoose = true;
					}
				}
				else
				{
					var bestSoldier:FishSoldier = FishSoldier.FindBestSoldier(desArr, false);
					if (GameLogic.getInstance().user.CurSoldier[1] is FishSoldier 
						&& GameLogic.getInstance().user.CurSoldier[1].Status == FishSoldier.STATUS_HEALTHY
						&& GameLogic.getInstance().user.CurSoldier[1].Health >= GameLogic.getInstance().user.CurSoldier[1].AttackPoint)
					{
						if (bestSoldier)
						{
							GameLogic.getInstance().user.CurSoldier[1].isChoose = false;
							GameLogic.getInstance().user.CurSoldier[1] = null;
							GameLogic.getInstance().user.CurSoldier[1] = bestSoldier;
							GameLogic.getInstance().user.CurSoldier[1].isChoose = true;
						}
						else
						{
							// Đánh cá thường
						}
					}
					else	// Cá thường
					{
						if (bestSoldier)	// Có cá lính
						{
							GameLogic.getInstance().user.CurSoldier[1] = bestSoldier;
							GameLogic.getInstance().user.CurSoldier[1].isChoose = true;
							
							// Các con cá thường về trạng thái mặc định
							for (i = 0; i < GameLogic.getInstance().user.GetFishArr().length; i++)
							{
								var normalFish:Fish = GameLogic.getInstance().user.GetFishArr()[i];
								normalFish.SetEmotion(Fish.IDLE);
							}
						}
					}
				}
			}
		}
		
		public static function FindFishInArr(id:int, arr:Array):FishSoldier
		{
			var i:int;
			for (i = 0; i < arr.length; i++)
			{
				if ((arr[i] as FishSoldier).Id == id)
				{
					return arr[i];
				}
			}
			return null;			
		}
		
		public static function SetScreen():void 
		{
			if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN)
			{	
				Main.imgRoot.stage.scaleMode = StageScaleMode.NO_SCALE;
				Main.imgRoot.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{				
				Main.imgRoot.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * Hàm check đã qua ngày mới chưa, nếu qua ngày thì cập nhật lại 1 số item liên quan đến qua ngày
		 * @author	longpt
		 */
		public static function CheckNewDay():void
		{
			var i:int;
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var lastTime:Number = GameLogic.getInstance().user.GetMyInfo().LastInitRun;
			var curDay:Date = new Date(curTime * 1000);
			var lastDay:Date = new Date(lastTime * 1000);
			
			if (curDay.month == lastDay.month && curDay.day == lastDay.day && curDay.fullYear == lastDay.fullYear)
			{
				return;
			}
			
			GameLogic.getInstance().user.GetMyInfo().LastInitRun = curTime;
			
			// Đan, tán
			var GemList:Array = GameLogic.getInstance().user.GetStore("Gem");
			for (i = 0;  i < GemList.length; i++)
			{
				GemList[i].Id = GemList[i].Id - 1;
			}
			
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_OTHER_BUFF_SOLDIER && GameLogic.getInstance().cursorImg.search("Gem") != -1)
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
				GameLogic.getInstance().MouseTransform("");
			}
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
			{
				GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
				GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
			}
		}
		/*
		 * Tính khoảng thời gian: chỉ cho về 1 trong các đơn vị: ngày, giờ, phút, giây
		 * ví dụ trả về đúng: 8 ngày trước, 4 tiếng trước, 6 phút trước, 45 giây trước
		 * ví dụ trả về sai: 4 giờ 15 phút 04 giây trước.
		 * @nTime: mốc thời gian trước đó (đưa vào để tính)
		 * return: khoảng thời gian từ hiện tại đến nTime = curTime - nTime => trả ra theo kiểu string ngày/giờ/phút/giây
		 * @author HiepNM
		 * 
		 */
		public static function GetRemainTime(nTime:Number):String
		{
			var nDay:Number;
			var iHour:int;
			var iMin:int;
			var iSec:int;
			var rMin:int;
			var rSec:int;
			var strResult:String = "FAIL";
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = (int)((curTime - nTime));		//lấy second (đang là minisecond)
			nDay = (int)(remainTime / 86400);
			if (nDay > 0)
			{
				strResult = nDay.toString() + " ngày";
			}
			else
			{
				iHour = (int)(remainTime / 3600);
				if (iHour > 0)
				{
					strResult = iHour.toString() + " giờ";
				}
				else
				{
					iMin = (int)(remainTime / 60);
					if (iMin > 0)
					{
						strResult = iMin.toString() + " phút";
					}
					else
					{
						iSec = (int)(remainTime);
						strResult = iSec.toString() + " giây";
					};
				};
			};
			return strResult;
		};
		
		public static function CheckNewFeatureIcon(dayOffsetMin:int = 0, dayOffsetMax:int = -1):Boolean
		{
			//return true;
			// Hardcode add chữ New
			var StartDate:Date = new Date(2012, 1, 27, 23, 59, 59);		// sang 24 up build
			var boundStampMin:Number = StartDate.getTime() + dayOffsetMin * 86400000;
			var boundStampMax:Number = StartDate.getTime() + dayOffsetMax * 86400000;
			//var CurDate:Date = new Date(GameLogic.getInstance().CurServerTime);
			
			if (dayOffsetMax < 0)
			{
				if (boundStampMin < GameLogic.getInstance().CurServerTime * 1000)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			
			if (boundStampMin < GameLogic.getInstance().CurServerTime * 1000 && boundStampMax > GameLogic.getInstance().CurServerTime * 1000)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function GetNamePearl(element:int,level:int):String
		{
			var s:String = "";
			switch (element) 
			{
				case 1:
					s = "Kim";
				break;
				case 2:
					s = "Mộc";
				break;
				case 3:
					s = "Thổ";
				break;
				case 4:
					s = "Thủy";
				break;
				case 5:
					s = "Hỏa";
				break;
				case 6://trong eventhalloween
					s = "5 viên Đan cấp " + level + "\nMỗi hệ một đan";
				return s;
				default:
					s = "";
				break;
			}
			if (level == 0)
			{
				s += " " + "tán";
			}
			else
			{
				s += " " + "đan " + "C" + level;
			}
			return s;
		}
		
		public static function GetNameImgPearl(el:int,lv:int):String 
		{
			return "Gem" + "_" + el + "_" + lv;
		}
		
		/**
		 * chuyển 1 lượng thời gian sang dạng giờ : phút : giây . Ví dụ: 123445 => "05 : 48: 03"
		 * @param	time : lượng thời gian muốn convert sang string
		 * @param	hasHour : có hiển thị giờ hay không
		 * @param	hasMinutes : có hiển thị phút hay không
		 * @param	hasSecond : có hiển thị giấy hay không
		 * @return
		 */
		public static function convertToTime(time:int,
										hasHour:Boolean = true,
										hasMinutes:Boolean = true,
										hasSecond:Boolean = true):String
		{
			if (time <= 0) 
			{
				if (hasHour)
				{
					return "00:00:00";
				}
				else
				{
					if (hasMinutes)
					{
						return "00:00";
					}
					else
					{
						return "00";
					}
				}
			}
			var h:int = time / 3600;
			var dH:int = time % 3600;
			var m:int = dH / 60;
			var dM:int = dH % 60;
			var s:int = dM;
			var sh:String = (h < 10)?"0" + h:h.toString();
			var sm:String = (m < 10)?"0" + m:m.toString();
			var ss:String = (s < 10)?"0" + s:s.toString();
			var strResult:String;
			if (hasHour) {
				strResult = sh + ":" + sm + ":" + ss;
			}
			else {
				if (hasMinutes) {
					strResult = sm + ":" + ss;
				}
				else {
					strResult = ss;
				}
			}
			return strResult;
		}
		/**
		 * Kiểm tra xem source của đồ có cho bán hay ko
			static public const EQUIPMENT_SOURCE_SHOP:int = 1;
			static public const EQUIPMENT_SOURCE_FISHWORLD:int = 2;
			static public const EQUIPMENT_SOURCE_DAILYGIFT:int = 3;
			static public const EQUIPMENT_SOURCE_COLLECTION:int = 4;
			static public const EQUIPMENT_SOURCE_DAILYQUEST:int = 5;
			static public const EQUIPMENT_SOURCE_EVENT:int = 6;
			static public const EQUIPMENT_SOURCE_LUCKYMACHINE:int = 7;
			static public const EQUIPMENT_SOURCE_CREATE:int = 8;
		 * @param	source
		 * @return true nếu bán được
		 */
		public static function checkSource(source:int):Boolean
		{
			var config:Array = ConfigJSON.getInstance().GetItemList("Param")["CanSellEquipment"];
			for (var i:int = 0; i < config.length; i++)
			{
				if (config[i] == source)
				{
					return true;
				}
			}
			return false;
		}
		
		public static function getActiveRowSeal(seal:FishEquipment, soldier:FishSoldier):int
		{
			if (seal == null || soldier == null)
			{
				return 0;
			}
			var config:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
			config = config[seal.Rank][seal.Color];
			var arrConfig:Array = []
			for (var s:String in config)
			{
				var obj:Object = config[s];
				obj["sort"] = int(s);
				arrConfig.push(obj);
			}
			arrConfig.sortOn("sort", Array.NUMERIC);
			for (var i:int = arrConfig.length -1; i >= 0; i--)
			{
				var numEquip:int = arrConfig[i]["Require"]["NumEquip"];
				var enchantLevel:int = arrConfig[i]["Require"]["EnchantLevel"];
				var count:int = 0;
				for (var h:String in soldier.EquipmentList)
				{
					if (h != "Seal" && h != "Mask")
					{
						for (var j:int = 0; j < soldier.EquipmentList[h].length; j++)
						{
							var equip:FishEquipment = soldier.EquipmentList[h][j] as FishEquipment;
							if ((equip.Durability > 0) && ((seal.Color <= 4 &&((equip.Color == seal.Color) || (equip.Color >= 4))) 
											|| (seal.Color >= 5 && ((equip.Color >= 4 && i != arrConfig.length -1) || (i == arrConfig.length - 1 && equip.Color == 6)))) && equip.EnchantLevel >= enchantLevel)
							{
								count ++;
							}
						}
					}
				}
				if (count >= numEquip)
				{
					return i + 1;
				}
			}
			return 0;
		}
		
		public static function getRowSeal(seal:SoldierEquipment, soldier:Soldier):int
		{
			if (seal == null || soldier == null)
			{
				return 0;
			}
			var config:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
			config = config[seal.Rank][seal.Color];
			var arrConfig:Array = []
			for (var s:String in config)
			{
				var obj:Object = config[s];
				obj["sort"] = int(s);
				arrConfig.push(obj);
			}
			arrConfig.sortOn("sort", Array.NUMERIC);
			for (var i:int = arrConfig.length -1; i >= 0; i--)
			{
				var numEquip:int = arrConfig[i]["Require"]["NumEquip"];
				var enchantLevel:int = arrConfig[i]["Require"]["EnchantLevel"];
				var count:int = 0;
				for each(var equip:SoldierEquipment in soldier.Equipments)
				{
					if ((equip.Durability > 0) && ((seal.Color <= 4 &&((equip.Color == seal.Color) || (equip.Color >= 4))) 
											|| (seal.Color >= 5 && ((equip.Color >= 4 && i != arrConfig.length -1) || (i == arrConfig.length - 1 && equip.Color == 6)))) && equip.EnchantLevel >= enchantLevel)
					{
						count ++;
					}
				}
				if (count >= numEquip)
				{
					return i + 1;
				}
			}
			return 0;
		}
		
		public static function getHappyMondayTip():String
		{
			const baseStr:String = "TooltipLuckyMonday_";
			var data:Object = ConfigJSON.getInstance().getItemInfo("HappyWeekDay", 1);
			var energy:int = data["energy"];
			var rate:Number = data["boostItemCostRate"] * 100;
			var takePhoto:int = data["takePhotoExpRate"];
			
			var strResult:String = Localization.getInstance().getString(baseStr + "FeedFish");
			strResult = strResult.replace("@num@", energy);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "HitSoldierFriend");
			strResult = strResult.replace("@num@", energy);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "FishWorld");
			strResult = strResult.replace("@num@", energy);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "Fishing");
			strResult = strResult.replace("@num@", energy);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "RawMaterial");
			strResult = strResult.replace("@rate@", rate);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "Snapshot");
			strResult = strResult.replace("@num@", takePhoto);
			strResult += "\n" + Localization.getInstance().getString(baseStr + "DailyQuest");
			
			return strResult;
		}
		
		public static function CheckOldDate(lastTime:Number):Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var curDate:Date = new Date(curTime * 1000);
			var curHour:int = curDate.getUTCHours() + Constant.TIME_ZONE_SERVER;
			if (curHour > 24)
			{
				curHour -= 24;
			}
			var curMin:int = curDate.getUTCMinutes();
			var curSec:int = curDate.getUTCSeconds();
			var curDayZero:Number = curTime - curHour * 3600 - curMin * 60 - curSec;
			
			if (curDayZero > lastTime)
			{
				return true;
			}
			else
			{
				return false;
			}
			return false;
		}
		
		/**
		 * xét thời điểm truyền vào có thuộc ngày hôm nay không
		 * @param	time: thời điểm được xét
		 */
		static public function checkInDay(time:Number):Boolean 
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var lastDay:Date = new Date(time * 1000);
			var curDay:Date = new Date(curTime * 1000);
			if (curDay.day == lastDay.day && 
				curDay.month == lastDay.month && 
				curDay.fullYear == lastDay.fullYear)
			{
				return true;
			}
			else {
				return false;
			}
		}
		
		static public function maxArr(arr:Array):int {
			var max:int = -1;
			for (var i:int = 0; i < arr.length; i++) {
				if (arr[i] > max) {
					max = arr[i];
				}
			}
			return max;
		}
		/**
		 * Tính số sao từ công thức lai
		 * @param	receiptType
		 * @return
		 */
		static public function getStarByReceiptType(receiptType:String):int
		{
			switch(receiptType)
			{
				case "Draft":
					return 1;
				case "Paper":
					return 2;
				case "GoatSkin":
					return 3;
				case "Blessing":
					return 4;
			}
			return 0;
		}
		
		/**
		 * Tìm min max của 1 mảng nguyên
		 * @param	arr : mảng đầu vào
		 * @return obj["min"] obj["max"]
		 */
		static public function searchBound(arr:Array):Object
		{
			var min:int  = 10000;
			var max:int = -1;
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				if (min > arr[i])
				{
					min = arr[i];
				}
				if (arr[i] > max)
				{
					max = arr[i];
				}
			}
			var obj:Object = new Object();
			obj["min"] = min;
			obj["max"] = max;
			return obj;
		}
		
		/**
		 * So sanh 2 object
		 * @param	obj1
		 * @param	obj2
		 * @return
		 */
		static public function compareObject(obj1:Object, obj2:Object):Boolean
		{
			var buffer1:ByteArray  = new ByteArray();
			buffer1.writeObject(obj1);
			var buffer2:ByteArray = new ByteArray();
			buffer2.writeObject(obj2);
			
			var size:uint = buffer1.length;
			if (buffer1.length == buffer2.length)
			{
				buffer1.position = 0;
				buffer2.position = 0;
				
				while (buffer1.position < size)
				{
					var v1:int = buffer1.readByte();
					if (v1 != buffer2.readByte())
					{
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		/**
		 * Chuyển time sang thứ ngày, tháng, năm, 
		 * @param	time
		 * @return
		 */
		static public function convertTimeToDate(time:Number, getDay:Boolean = true, getTime:Boolean = true):String
		{
			var result:String = "";
			var date:Date = new Date();
			date.setTime((time + 7*3600)*1000);
			//trace(date);
			//trace(date.toLocaleString());
			//trace(date.toUTCString());
			if (getTime)
			{
				var minute:String;
				if (date.getUTCMinutes() < 10)
				{
					minute = "0" + date.getUTCMinutes();
				}
				else
				{
					minute = date.getUTCMinutes().toString();
				}
				var hour:String;
				if (date.getUTCHours() < 10)
				{
					hour = "0" + date.getUTCHours();
				}
				else
				{
					hour = date.getUTCHours().toString();
				}
				result += hour + ":" + minute;
				if (getDay)
				{
					result += " ";
				}
			}
			if (getDay == true)
			{
				switch(date.getUTCDay())
				{
					case 0:
						result += "Chủ Nhật, ";
						break;
					case 1:
						result += "Thứ Hai, ";
						break;
					case 2:
						result += "Thứ Ba, ";
						break;
					case 3:
						result += "Thứ Tư, ";
						break;
					case 4:
						result += "Thứ Năm, ";
						break;
					case 5:
						result += "Thứ Sáu, ";
						break;
					case 6:
						result += "Thứ Bảy, ";
						break;
				}
				result += "ngày " + date.getUTCDate() + "/" + (date.getUTCMonth()+1); 
			}
			return result;
		}
		/**
		 * ẩn hiện các đối tượng trong hồ
		 * @param	object : đối tượng cần ẩn hiện
		 * @param	isVisible : ẩn hay hiện
		 */
		static public function setVisibleActiveObject(object:Object, isVisible:Boolean = true):void
		{
			switch(object.ClassName) {
				case "Fish":
				case "FishSpartan":
				case "FishSoldier":
					if (isVisible) {
						object.Show();
					}
					else {
						//object["GuiFishStatus"].Hide();
						object.Hide();
					}
				break;
				case "FishSoldier"://cá lính thì nên hủy đi vì cái GuiFishStatus rất khó quản lý
					var soldier:FishSoldier = object as FishSoldier;
					var FishSoldierArr:Array = GameLogic.getInstance().user.FishSoldierArr;
					if (!isVisible) {
						var index:int = FishSoldierArr.indexOf(soldier);
						soldier.Destructor();
					}
				break;
				case "TuiTanThu"://xóa và tạo mới
					var bag:TuiTanThu = object as TuiTanThu;
					if (!isVisible)
					{
						bag.loop = false;
						bag.Clear();
					}
					else {
						trace("tạo lại túi tân thủ");
						var data:Object = new Object();
						data["LastGetGiftTime"] = bag.lastTimeOpenBag;
						data["Gave"] = bag.timesOpen - 1;
						GameLogic.getInstance().user.initTuiTanThu(false, data);
					}
				break;
				default:
					object["img"]["visible"] = isVisible;
				//case "Decorator":
				//case "Food":
				//case "Dirty":
				//case "FallingObject":
				//case "Balloon":
				//case "TuiTanThu":
				//break;
				
			}
		}
		static public function clone(source:Object):Object {
			var myBA:ByteArray = new ByteArray();
			myBA.writeObject(source);
			myBA.position = 0;
			return (myBA.readObject());
		}
		
		/**
		 * 
		 * @param	Type
		 * @return 1: Special Gift, 0: Normal Gift
		 */
		static public function categoriesGift(Type:String):int
		{
			var kind:int = -1;
			switch(Type)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
				case "Ring":
				case "Necklace":
				case "Belt":
				case "Bracelet":
				case "Bracelet":
				case "Mask":
				case "Seal":
				case "JewelChest":
				case "EquipmentChest":
				case "AllChest":
					kind = 1;
				break;
				default:
					kind = 0;
			}
			return kind;
		}
		
		/**
		 * 
		 * @param	btn
		 * @param	featureName
		 * @param	levelUnlock
		 */
		public static function updateUnlockBtn(btn:Object, featureName:String, levelUnlock:int):void
		{
			var levelUser:int = GameLogic.getInstance().user.GetLevel(true);
			var tooltipFormat:TooltipFormat = new TooltipFormat();
			if (levelUser < levelUnlock)
			{
				if(btn is Button)
				{
					btn.SetDisable();
				}
				else if(btn is ButtonEx)
				{
					ButtonEx(btn).SetDisable2();
				}
				tooltipFormat.htmlText = "<font size = '18'>" + featureName + "</font>\n<font size = '15' color ='#ff0000'>Mở khi đạt cấp độ " + levelUnlock + "</font>";
				btn.setTooltip(tooltipFormat);
			}
			else
			{
				btn.SetEnable(true);
				tooltipFormat.htmlText = "<font size = '12'>" + featureName + "</font>";
				btn.setTooltip(tooltipFormat);
			}
		}
		
		/**
		 * lấy tên loại khi enchant
		 * @param	type: loại trang bị
		 * @return : Major hay Minor
		 */
		public static function GetConfigListNameSuffix(type:String):String
		{
			//switch (type)
			//{
				//case "Helmet":
				//case "Armor":
				//case "Weapon":
					//return "Major";
				//default:
					//return "Minor";
			//}
			return "Minor";
		}
		
		public static function payMoney(priceType:String, price:int):Boolean
		{
			var user:User = GameLogic.getInstance().user;
			switch(priceType)
			{
				case "Diamond":
					if (user.getDiamond() < price)
					{
						GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 5);
						return false;
					}
					user.updateDiamond( -price);
					break;
				case "Money":
					if (user.GetMoney() < price)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng", 310, 200, 1);
						return false;
					}
					user.UpdateUserMoney( -price);
					break;
				case "ZMoney":
					if (user.GetZMoney() < price)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						return false;
					}
					user.UpdateUserZMoney( -price);
					break;
				default:
					return false;
			}
			return true;
		}
		/**
		 * số bay ra
		 * @param	num
		 * @param	xScr
		 * @param	yScr
		 * @param	xDes
		 * @param	yDes
		 * @param	speed
		 * @param	sAssign
		 */
		public static function flyNumber(num:int, 
										xScr:int, yScr:int, xDes:int, yDes:int, speed:int, 
										color:Number = 0xffffff,
										sAssign:String = "+"):void
		{
			var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			txtFormat.color = color;
			var st:String = sAssign + StandardNumber(num);
			var tmp:Sprite = CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
			eff.SetInfo(xScr, yScr, xDes, yDes, speed);
		}
		/**
		 * trả về mốc 0h giờ Việt Nam của ngày gần nhất (tính ngược lại thời gian)
		 * @param	unixTime : thời điểm tính theo giờ Anh
		 * @return
		 */
		public static function getHourZeroVietnamese(unixTime:int):int
		{
			var second:int = unixTime % 86400; //thời điểm 0h của Anh
			var zeroHourEnglish:int = unixTime - second;
			var curHourEnglish:int = int(second / 3600);
			if (curHourEnglish >= 17)//quá 17h ở Anh => quá 0h ở Việt Nam => ở Việt Nam sang ngày mới cần lấy mốc 0h của việt nam tại đây (17h Anh)
			{
				return zeroHourEnglish + 17 * 3600;
			}
			else//chưa quá 17h ở Anh => ở Việt Nam chưa đến 0h ngày hôm sau
			{
				return zeroHourEnglish - 7 * 3600;
			}
		}
		public static function IsOtherDay(preTime:Number, curTime:Number):Boolean
		{
			return !(getHourZeroVietnamese(int(preTime)) == getHourZeroVietnamese(int(curTime)));
		}
		
		static public function getFileName(fileName:String, version:String, useMD5:Boolean):String 
		{
			var name:String = useMD5 ? MD5Hash(fileName + version) : (fileName + version);
			switch(fileName)
			{
				case"FishCommon1":
				case"FishCommon2":
				case"FishCommon3":
				case"FishCommon4":
				case"FishCommon5":
				case"FishFast1":
				case"FishBoss1":
					return "Event/EventNoel/FishNoel/" + name;
				case"GuiExchangeNoelItem":
				case"GuiExchangeCandy":
				case"GuiHuntFish":
				case"GuiShocksNoel":
				case"GuiGiftEventNoel":
				case"GuiFinishRound":
				case"GuiStoreNoel":
					return "Event/EventNoel/" + name;
				case "GuiCollectionTeacher":
				case "GuiGuideTeacher":
				case "GuiOnlineGift":
					return "Event/EventTet2013/" + name;
				default:
					return name;
						
			}
		}
		static public function fitRec(img:DisplayObject, width:Number, height:Number, x:Number, y:Number):void
		{
			var scale:Number = 1;
			if (img.width > width)
			{
				scale = width / img.width;
			}
			img.scaleX = img.scaleY = scale;
			if (img.height > height)
			{
				scale *= height / img.height;
			}
			img.scaleX = img.scaleY = scale;
			try
			{
				img.x = x /*- img["originalPosition"]["x"] * scale*/ + width / 2 - img.width / 2;
				img.y = y /*- img["originalPosition"]["y"] * scale*/ + height / 2 - img.height / 2;
			}
			catch (e:*)
			{
				img.x = x + width / 2 - img.width / 2;
				img.y = y + height / 2 - img.height / 2;
			}
		}
		public static function getTooltipText(itemType:String, itemId:int, color:int, rank:int):String 
		{
			var sName:String;
			switch(itemType)
			{
				case "AllChest":
					sName = "Đồ";
					break;
				case "Armor":
					sName = "Áo Giáp";
					break;
				case "Helmet":
					sName = "Mũ Giáp";
					break;
				case "Weapon":
					sName = "Vũ Khí";
					break;
			}
			var sColor:String;
			switch(color)
			{
				case 1:
					sColor = "Thường";
					break;
				case 2:
					sColor = "Đặc biệt";
					break;
				case 3:
					sColor = "Quý";
					break;
				case 4:
					sColor = "Thần";
					break;
				case 5:
					sColor = "Vip";
					break;
				case 6:
					sColor = "VipMax";
					break;
			}
			var sRank:String;
			switch(rank)
			{
				case 1:
					sRank = "lưỡng cực";
					break;
				case 2:
					sRank = "Anh Hùng";
					break;
				case 3:
					sRank = "Vô Song";
					break;
				case 4:
					sRank = "Phượng Hoàng";
					break;
			}
			return sName + " " + sRank + " " + sColor;
		}
		
	}

};













