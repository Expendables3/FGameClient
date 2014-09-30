package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import com.adobe.utils.IntUtil;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Effect.EffectMgr;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishOceanHappy;
	import Logic.GameLogic;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author Quangvh
	 */
	public class GUIGameOceanHappy extends BaseGUI 
	{
		private const PIECE:String = "ctnPiece_";
		private const RESULT:String = "ctnResult_";
		private const BTN_CLOSE:String = "btnClose";
		
		private var fishOceanHappy:FishOceanHappy;
		
		private var arrPointResult:Array;		// Mảng chứa các mảng point của kết quả
		private var arrPointOther:Array;		
		private var arrDirResult:Array;
		private var arrDirOther:Array;	
		private var alpha0:Number;
		//private var arrRotation:Array;
		private var arrImgAndData:Array;
		private var numSplit:int;
		private var numPieceHave:int;
		private var numPieceUserChoose:int;
		
		private var ctnResult:Container;
		private var arrPiece:Array;
		
		private var StartPieceX:int = 45;
		private var StartPieceY:int = 325;
		private var DistancePieceX:int = 130;
		
		private const PosResultX:int = 280;
		private const PosResultY:int = 110;
		
		private var isFlying:Boolean = false;
		private var isEffect:Boolean = false;
		
		private var isProcessRotation:Boolean = false;
		private var isProcessZoomInOut:Boolean = false;
		private var isMovePiece:Boolean = false;
		private var isProcess:Boolean = false;
		private var CountDown:int = -1;
		private var CountZoomInOut:int = 0;
		private var ImageProcessRotation:Image;
		private var ImageProcessZoomInOut:Image;
		private var SpriteProcessZoom:Sprite;
		private var oldColorHightLight:int;
		private var ctnProcess:Container;
		private var idProcess:int;
		private var isSpeedUp:Boolean = true;
		private var V_Rotation_0:Number;
		private var Rotation_Now:Number;
		private var V_Rotation_Max:Number;
		private var A_Rotation:Number;
		//private var 
		private var DeltaRotation:Number;			// Goc ma hinh quay qua
		private var DeltaFrameEnd:int;				// số frame để khi quay quá thì trở lại vị trí đúng
		private var DeltaFrameFirst:int;
		private var DeltaFrameMid:int;
		
		// Các biến check độ khó của game
		private var numPointBase:int;
		private var numPointDelta:int;
		private var limitDistance:int;
		private var numPiece:int;
		
		public function GUIGameOceanHappy(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGameOceanHappy";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			LoadRes("ImgBgGUIGameOceanHappy");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			
			// Khởi tạo các biến điều khiển
			isFlying = false;
			isEffect = false;
			isProcessRotation = false;
			isProcessZoomInOut = false;
			isMovePiece = false;
			numSplit = 3;
			numPieceHave = 1;
			numPieceUserChoose = 0;
			//numPiece = Math.round(numSplit + Math.random() * (5 - numSplit));
			numPiece = 5;
			arrDirOther = [];
			arrDirResult = [];
			arrPointOther = [];
			arrPointResult = [];
			alpha0 = Math.random() * 360;
			arrPiece = [];
			//arrRotation = new Array();
			
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 33, 18, this);
			ctnResult = AddContainer(RESULT, "CtnElementHeart", 280, 110);
			
			var imageBg:Image =ctnResult.AddImage("Image0", "ImgHearInGameOceanHappy_bg", ctnResult.img.width, ctnResult.img.height);
			imageBg.SetPos(ctnResult.img.width / 2 + imageBg.img.width / 2, ctnResult.img.height / 2 + imageBg.img.height / 2);
			CreatePiece(ctnResult, 0, true, true);
			GenLineGuide();
			ctnResult.SetScaleXY(1.5);
			
			var i:int = 0;
			var j:int = 0;
			arrImgAndData = new Array();
			StartPieceX = (700 - numPiece * 121) / (numPiece + 1) + 20;
			DistancePieceX = 121 + StartPieceX - 20;
			
			// Khởi tạo mảng các id đúng
			var arrIdTrue:Array = [];
			var idExist:Boolean = false;
			var arr1:Array = [0 , 1 , 2 , 3 , 4];
			for (i = 0; i < numSplit - 1; i++)
			{
				var idTrueTemp:int;
				//idTrueTemp = Math.floor((i + Math.random()) * (numPiece - 1) / (numSplit - 1));
				var indexTrueTemp:int = int(Math.random() * arr1.length)
				idTrueTemp = arr1[indexTrueTemp];
				arr1.splice(indexTrueTemp, 1);
				arrIdTrue.push(idTrueTemp);
			}
			fishOceanHappy.idTrue = arrIdTrue;
			
			var countOther:int = 0;
			var isDraw:Boolean = false;
			for (j = 0; j < numPiece; j++) 
			{
				for (i = 0; i < numSplit - 1; i++) 
				{
					if(fishOceanHappy.idTrue[i] == j)
					{
						DrawCtnPiece(fishOceanHappy.idTrue[i], i + 1, true);
						isDraw = true;
					}
				}
				if (isDraw)
				{
					isDraw = false;
				}
				else 
				{
					DrawCtnPiece(j, countOther);
					countOther ++;
				}
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var ctn:Container;
			if (buttonID.search(PIECE) >= 0) 
			{
				ctn = GetContainer(buttonID);
				ctn.SetHighLight();
				CountZoomInOut = 0;
				ImageProcessZoomInOut = ctn.ImageArr[0] as Image;
				if (!isProcess) 
				{
					isMovePiece = true;
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var ctn:Container;
			if (buttonID.search(PIECE) >= 0) 
			{
				ctn = GetContainer(buttonID);
				ctn.SetHighLight( -1);
				if (isMovePiece)
				{
					isMovePiece = false;
					CountZoomInOut = 0;
					ImageProcessZoomInOut.SetScaleXY(1);
					ImageProcessZoomInOut = null;
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					if (isEffect || isFlying || isProcessRotation || isProcessZoomInOut) 
					{
						return;
					}
					Hide();
				break;
				default:
					if (buttonID.search(PIECE) >= 0) 
					{
						if(GameLogic.getInstance().user.GetMyInfo().Energy >= GetEnergyNeed(numPieceUserChoose))
						{
							isProcess = true;
							if(isMovePiece)
							{
								isMovePiece = false;
								var ctn:Container = GetContainer(buttonID);
								ctn.SetHighLight( -1);
								ImageProcessZoomInOut.SetScaleXY(1.5);
								ImageProcessZoomInOut = null;
								CountZoomInOut = 0;
							}
							doCheckResult(buttonID.split("_")[1]);
						}
						else 
						{
							GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER);
						}
					}
				break;
			}
		}
		
		/**
		 * Sinh ra đường hướng dẫn màu vàng
		 */
		private function GenLineGuide():void 
		{
			var image:Image = ctnResult.GetImage("Image0");
			var mask:Image = new Image(img, "IcHeart");
			var sp:Sprite = new Sprite();
			
			var posEnd:Point = new Point();
			var posControl:Point = new Point();
			
			for (var i:int = 0; i < arrPointResult.length; i++) 
			{
				var item:Array = arrPointResult[i];
				sp.graphics.moveTo(0, 0);
				sp.graphics.lineStyle(2, 0xFFFF33);
				for (var j:int = item.length - 2; j >= 1; j--) 
				{
					if(j == 1)
					{
						posEnd = item[0];
					}
					else 
					{
						posEnd = new Point((item[j].x + item[j -1].x) / 2, (item[j].y + item[j -1].y) / 2);
					}
					posControl = item[j];
					sp.graphics.curveTo(posControl.x, posControl.y, posEnd.x, posEnd.y);
				}
			}
			
			sp.addChild(mask.img);
			sp.mask = mask.img;
			image.img.addChild(sp);
		}
		
		private function doCheckResult(id:int):void 
		{
			if (isFlying || isEffect || isProcessRotation || isProcessZoomInOut) 
			{
				return;
			}
			//var mc:Sprite = new Sprite();
			var ctn:Container = GetContainer(PIECE + id);
			//var imgTemp:Image = BeginCut(arrImgAndData[id]);
			var imgTemp:Image = ctn.ImageArr[0];
			//var iRotation:Number = arrRotation[id];
			ResetRotation(imgTemp, ctn, id);
			//imgTemp.img.rotation = 0;
			imgTemp.SetScaleXY(1.5);
			img.addChild(imgTemp.img);
			var pD:Point = img.globalToLocal(ctn.img.localToGlobal(new Point(0 , 0)));
			imgTemp.img.x = pD.x + ctn.img.width / 2;
			imgTemp.img.y = pD.y + ctn.img.height / 2;
		}
		
		private function ResetRotation(ImageReset:Image, ctn:Container, id:int):void 
		{
			ImageProcessRotation = ImageReset;
			ctnProcess = ctn;
			idProcess = id;
			
			isSpeedUp = true;
			
			DeltaFrameEnd = 12;
			DeltaFrameFirst = 16;
			DeltaFrameMid = 4;
			
			Rotation_Now = ImageProcessRotation.img.rotation;
			if (Rotation_Now > 0)	Rotation_Now = Rotation_Now - 360;
			
			// nhanh dan -> deu -> quay lai
			//DeltaRotation = Math.abs(Rotation_Now / 9);
			//var x:Number = 1 / 2 * (DeltaFrameFirst * DeltaFrameFirst + 2 * DeltaFrameFirst * DeltaFrameMid) * (1 + DeltaRotation / Rotation_Now);
			
			// nhanh dan -> deu -> chậm dần
			DeltaRotation = - Math.abs(2 * Rotation_Now / 5);
			var x:Number = 1 / 2 * (DeltaFrameFirst * DeltaFrameFirst + 2 * DeltaFrameFirst * DeltaFrameMid) * (1 - DeltaRotation / Rotation_Now);
			
			//nhanh dan -> deu -> dừng lại
			//DeltaRotation = 0;
			//var x:Number = 1 / 2 * (DeltaFrameFirst * DeltaFrameFirst + 2 * DeltaFrameFirst * DeltaFrameMid);
			
			V_Rotation_Max = Math.abs(Rotation_Now / x * DeltaFrameFirst);
			
			//Có gia tốc
			A_Rotation = Math.abs(Rotation_Now / x);
			V_Rotation_0 = 0;
			
			// Không có gia tốc
			//A_Rotation = 0;
			//V_Rotation_0 = V_Rotation_Max;
			
			isProcessRotation = true;
		}
		
		public function update():void 
		{
			if (isProcessRotation)
			{
				if (isSpeedUp)
				{
					if(Rotation_Now < DeltaRotation)
					{
						Rotation_Now = Rotation_Now + V_Rotation_0 + A_Rotation / 2;
						ImageProcessRotation.img.rotation = Rotation_Now;
						V_Rotation_0 = V_Rotation_0 + A_Rotation;
						if (V_Rotation_0 >= V_Rotation_Max)
						{
							V_Rotation_0 = V_Rotation_Max;
							A_Rotation = 0;
						}
					}
					else 
					{
						Rotation_Now = DeltaRotation;
						A_Rotation = - 2 * DeltaRotation / (DeltaFrameEnd * DeltaFrameEnd);
						isSpeedUp = false;
						if(DeltaRotation > 0)
							V_Rotation_0 = 0;
					}
				}
				else 
				{
					if (Math.abs(DeltaRotation) / DeltaRotation * Rotation_Now > 0)
					{
						Rotation_Now = Rotation_Now + V_Rotation_0 + A_Rotation / 2;
						ImageProcessRotation.img.rotation = Rotation_Now;
						V_Rotation_0 = V_Rotation_0 + A_Rotation;
						if (V_Rotation_0 >= V_Rotation_Max)
						{
							V_Rotation_0 = V_Rotation_Max;
							A_Rotation = 0;
						}
					}
					else 
					{
						Rotation_Now = 0;
						V_Rotation_0 = 0;
						V_Rotation_Max = 0;
						A_Rotation = 0;
						DeltaRotation = 0;
						DeltaFrameEnd = 0;
						ImageProcessRotation.img.rotation = Rotation_Now;
						var pDes:Point = img.globalToLocal(ctnResult.img.localToGlobal(new Point(0, 0)));
						isFlying = true;
						isProcessRotation = false;
						var midle:Point = new Point();
						midle.x = (ImageProcessRotation.img.x + pDes.x + ctnResult.img.width / 2) / 2;
						midle.x = midle.x * (0.5 + Math.random());
						midle.y = (ImageProcessRotation.img.y + pDes.y + ctnResult.img.height / 2) / 2;
						TweenMax.to(ImageProcessRotation.img, 1, {bezier:[{x:midle.x, y:midle.y}, {x:pDes.x + ctnResult.img.width / 2, y:pDes.y + ctnResult.img.height / 2}], orientToBezier:false, scaleX:1.5, scaleY:1.5,
							ease:Expo.easeOut, onComplete:onFinishTweenRaw, onCompleteParams:[idProcess, ImageProcessRotation.img, ctnProcess] } );
					}
				}
			}
			
			if (!isProcess && !isMovePiece && ImageProcessZoomInOut) 
			{
				isMovePiece = true;
			}
			
			if(isMovePiece)
			{
				CountZoomInOut ++;
				ImageProcessZoomInOut.SetScaleXY(1 + 0.1 * Math.sin(CountZoomInOut / 15 * Math.PI));
				if (CountZoomInOut >= 30) 
				{
					CountZoomInOut = 0;
				}
			}
			
			var isTrueResult:Boolean = false;
			var i:int = 0;
			if (isProcessZoomInOut)
			{
				for (i = 0; i < fishOceanHappy.idTrue.length; i++)
				{
					if (idProcess == fishOceanHappy.idTrue[i])
					{
						isTrueResult = true;
						break;
					}
				}
				CountDown ++;
				SpriteProcessZoom.scaleX += 0.04;
				SpriteProcessZoom.scaleY += 0.04;
				if(isTrueResult)
				{
					SetHighLightSprite(SpriteProcessZoom, CountDown * 2);
				}
				else 
				{
					SetHighLightSprite(SpriteProcessZoom, CountDown * 2, 0x000000);
				}
				if (SpriteProcessZoom.scaleX >= 1.8)
				{
					isProcessZoomInOut = false;
				}
			}
			else 
			{
				if (CountDown >= 0)
				{
					for (i = 0; i < fishOceanHappy.idTrue.length; i++)
					{
						if (idProcess == fishOceanHappy.idTrue[i])
						{
							isTrueResult = true;
							break;
						}
					}
					SpriteProcessZoom.scaleX -= 0.04;
					SpriteProcessZoom.scaleY -= 0.04;
					CountDown --;
					if (isTrueResult) 
					{
						SetHighLightSprite(SpriteProcessZoom, CountDown * 2);
					}
					else 
					{
						SetHighLightSprite(SpriteProcessZoom, CountDown * 2, 0x000000);
					}
					if (CountDown < 0)
					{
						onFinishZoomInOut();
					}
				}
			}
		}
		
		private function SetHighLightSprite(sp:Sprite, delta:int = 8, color:Number = 0x00FF00, turnBack:Boolean = false):void
		{
			if (img == null)
			{
				return;
			}
			
			var glow:GlowFilter;
			if (color < 0)
			{
				if (turnBack && oldColorHightLight >0)
				{
					glow = new GlowFilter(oldColorHightLight, 1, delta, delta, delta);
					sp.filters = [glow];
				}
				else
				{
					sp.filters = null;
				}
				return;
			}
			
			if (!turnBack)
			{
				oldColorHightLight = color;			
			}
			glow = new GlowFilter(color, 1, delta, delta, delta);
			sp.filters = [glow];
		}
		
		
		private function onFinishTweenRaw(id:int, mc:Sprite, ctn:Container):void 
		{
			var i:int = 0;
			isEffect = true;
			isFlying = false;
			CountDown = -1;
			SpriteProcessZoom = mc;
			isProcessZoomInOut = true;
			
			for (i = 0; i < ctnResult.ImageArr.length; i++) 
			{
				var item:Image = ctnResult.ImageArr[i];
				item.img.visible = true;
			}
			
			ctn.img.visible = false;
		}
		private function onFinishZoomInOut():void 
		{
			var i:int = 0;
			var arr:Array = [];
			SpriteProcessZoom.visible = false;
			var isTrueResult:Boolean = false;
			for (i = 0; i < fishOceanHappy.idTrue.length; i++)
			{
				if (idProcess == fishOceanHappy.idTrue[i])
				{
					isTrueResult = true;
					break;
				}
			}
			
			if (isTrueResult)
			{
				if(numPieceHave == numSplit - 1)
				{
					arr.push("IcHeart");
					ctnResult.RemoveAllImage();
					numPieceHave = 1;
					GameLogic.getInstance().user.UpdateEnergy( -GetEnergyNeed(numPieceUserChoose));
					numPieceUserChoose = 0;
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffRawSucces", arr, ctnResult.img.x + ctnResult.img.width / 2 * 1.5, 
											ctnResult.img.y + ctnResult.img.height / 2 * 1.5, false, false, null, function():void{EndChoose()});
				}
				else 
				{
					var idImageNew:int = 0;
					for (var j:int = 0; j < fishOceanHappy.idTrue.length; j++) 
					{
						if(fishOceanHappy.idTrue[j] == idProcess)
						{
							idImageNew = j + 1;
							break;
						}
					}
					ctnResult.SetScaleXY(1);
					CreatePiece(ctnResult, idImageNew, true, true)
					ctnResult.SetScaleXY(1.5);
					isEffect = false;
					GenLineGuide();
					numPieceHave++;
					GameLogic.getInstance().user.UpdateEnergy( -GetEnergyNeed(numPieceUserChoose));
					numPieceUserChoose ++;
					isProcess = false;
				}
			}
			else 
			{
				GameLogic.getInstance().user.UpdateEnergy( -GetEnergyNeed(numPieceUserChoose));
				numPieceUserChoose++;
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffRawFail", arr, ctnResult.img.x + ctnResult.img.width / 2 * 1.5, 
										ctnResult.img.y + ctnResult.img.height / 2 * 1.5, false, false, null, function():void{HideChoose(idProcess)});
			}
			ctnProcess = null;
			idProcess = 0;
			ImageProcessRotation = null;
		}
		
		private function EndChoose():void 
		{
			isEffect = false;
			ctnResult.ClearComponent();
			fishOceanHappy.LastPlayMiniGame = GameLogic.getInstance().CurServerTime;
			fishOceanHappy.auxiliaryFish.LastPlayMiniGame = fishOceanHappy.LastPlayMiniGame;
			fishOceanHappy.SetEmotion(Fish.IDLE);
			
			var addScore:int = Math.ceil(Math.random() * 5);
			var addExp:int = Math.ceil(Math.random() * 5);
			EffectMgr.getInstance().fallFlyScoreInFishWorld(fishOceanHappy.CurPos.x, fishOceanHappy.CurPos.y, addScore);
			EffectMgr.getInstance().fallFlyXP(fishOceanHappy.CurPos.x, fishOceanHappy.CurPos.y, addExp);
			
			isProcess = false;
			GuiMgr.getInstance().GuiMainFishWorld.level ++;
			GuiMgr.getInstance().GuiMainFishWorld.txtLevel.text = GuiMgr.getInstance().GuiMainFishWorld.level.toString();
			
			Hide();
		}
		
		private function HideChoose(id:int):void 
		{
			isEffect = false;
			for (var i:int = 0; i < ctnResult.ImageArr.length; i++) 
			{
				var item:Image = ctnResult.ImageArr[i];
				item.img.visible = true;
			}
			isProcess = false;
		}
		
		public function SetInfo(fish:FishOceanHappy):void 
		{
			fishOceanHappy = fish;	
		}
		
		/**
		 * Vẽ các container chứa các miếng trái tim
		 * @param	id: từ 0 - 4, chính là index trong mảng arrPiece
		 */
		private function DrawCtnPiece(idCtn:int, idImage:int, isResult:Boolean = false):void 
		{
			var ctn:Container = AddContainer(PIECE + idCtn, "CtnElementHeart", StartPieceX + idCtn * DistancePieceX, StartPieceY, true, this);
			CreatePiece(ctn, idImage, isResult);
		}
		
		/**
		 * Khởi tạo các mảng lưu trữ các điểm sẽ cắt ra
		 * @param	RecX	:	1/2 chiều rộng ảnh
		 * @param	RecY	:	1/2 chiều cao ảnh
		 */
		private function InitData(RecX:Number, RecY:Number):void 
		{
			GenResultArr(RecX, RecY, numSplit);
			arrPointOther = [];
			arrDirOther = [];
			for (var i:int = 0; i < numPiece - numSplit + 1; i++) 
			{
				arrPointOther.push(GenOtherArr(RecX, RecY));
			}
		}
		
		/**
		 * Hàm thực hiện tạo ra ảnh bị cắt
		 * @param	ctn				:	Container chứa ảnh
		 * @param	idImage			:	id để xác định ảnh trong các mảng đã gen ra từ trước
		 * @param	isResult		:	có phải là phần nằm trong kết quả không
		 * @param	isDontRotation	: 	có xoay ảnh đi không
		 */
		private function CreatePiece(ctn:Container, idImage:int, isResult:Boolean = false, isDontRotation:Boolean = false):void 
		{
			var image:Image = ctn.AddImage("Image" + ctn.ImageArr.length, "IcHeart", ctn.img.width, ctn.img.height);
			var RecY:Number = image.img.height / 2;
			var RecX:Number = image.img.width / 2;
			var dir1:Number = 0;
			var dir2:Number = 0;
			image.SetPos(ctn.img.width / 2 + image.img.width / 2, ctn.img.height / 2 + image.img.height / 2);
			if (!arrPointResult || arrPointResult.length == 0)
			{
				InitData(RecX, RecY);
			}
			
			var arrSplit1:Array = [];
			var arrSplit2:Array = [];
			if (isResult) 
			{
				arrSplit1 = arrPointResult[idImage];
				dir1 = arrDirResult[idImage];
				if(idImage + 1 >= arrPointResult.length)
				{
					arrSplit2 = arrPointResult[0];
					dir2 = arrDirResult[0];
				}
				else 
				{
					arrSplit2 = arrPointResult[idImage + 1];
					dir2 = arrDirResult[idImage + 1];
				}
			}
			else 
			{
				arrSplit1 = arrPointOther[idImage][0];
				arrSplit2 = arrPointOther[idImage][1];
				dir1 = arrDirOther[idImage][0];
				dir2 = arrDirOther[idImage][0];
			}
			image = CutImage(image, RecX, RecY, arrSplit1, arrSplit2, dir1, dir2, isDontRotation);
		}
		/**
		 * Hàm thực hiện cắt ảnh
		 * @param	image			:	Ảnh gốc vào
		 * @param	RecX			:	1/2 chiều rộng ảnh
		 * @param	RecY			:	1/2 chiều cao ảnh
		 * @param	arrSplit1		:	Mảng các điểm 1
		 * @param	arrSplit2		:	Mảng các điểm 2
		 * @param	Dir1			:	góc của hướng đi của các điểm arrSplit1 
		 * @param	Dir2			:	góc của hướng đi của các điểm arrSplit2
		 * @param	isDontRotation	:	có quay hình đi không
		 * @return
		 */
		private function CutImage(image:Image, RecX:Number, RecY:Number, arrSplit1:Array, arrSplit2:Array, Dir1:Number, Dir2:Number, isDontRotation:Boolean = false):Image
		{
			var sp:Sprite = GetMask(RecX, RecY, arrSplit1, arrSplit2, Dir1, Dir2);
			image.img.addChild(sp);
			image.img.mask = sp;
			if (!isDontRotation)
			{
				image.img.rotation = 90 + Math.random() * 180;
			}
			else 
			{
				SetHighLightSprite(image.img);
			}
			return image;
		}
		
		/**
		 * 
		 * @param	PosN	: Tọa độ điểm cuối cùng trong hình zich zắc, điểm đâu là tâm hình trái tim
		 * @param	m		: Số điểm nằm giữa điểm đầu và cuối nên nằm trong khoảng 3 -> 5
		 * @param	RecX	: 1/2 chiều rộng ảnh
		 * @param	RecY	: 1/2 chiều cao ảnh
		 * @return			: Mảng gồm các điểm từ PosN đến PosO
		 */
		private function GenArrPoint(PosN:Point, m:int, RecX:Number, RecY:Number):Array
		{
			var deltaX:Number = 0;
			var deltaY:Number = 0;
			var arr:Array = [];
			var limitX:Number = RecX / m;
			var limitY:Number = RecY / m;
			//do
			//{
				arr = [];
				arr.push(PosN);
				for (var i:int = 0; i < m; i++) 
				{
					var item:Point = new Point();
					var itemOld:Point = new Point();
					var deltaDistance:Number = 0;
					
					if (i == 0)
					{
						itemOld = PosN;
					}
					else 
					{
						itemOld = arr[i - 1];
					}
					
					do
					{
						deltaX = PosN.x * Math.random();
						deltaY = PosN.y * Math.random();
						//deltaX = PosN.x / m * (i + 0.5 + 0.5 * Math.random());
						//deltaY = PosN.y / m * (i + 0.5 + 0.5 * Math.random());
						deltaDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
					}
					while(deltaDistance < PosN.length / m || deltaDistance > PosN.length / (m-1))
					//item.x = PosN.x - deltaX;
					//item.y = PosN.y - deltaY;
					item.x = itemOld.x - deltaX;
					item.y = itemOld.y - deltaY;
					
					arr.push(item);
				}
				arr.push(new Point(0, 0));
			//}
			//while (!CheckArrVsResult(arr))
			return arr;
		}
		
		/**
		 * Kiểm tra xem mảng arr có thỏa mãn điều kiện là khác với các mảng điểm của kết quả không
		 * @param	arr
		 * @return
		 */
		private function CheckArrVsResult(arr:Array):Boolean
		{
			var i:int = 0;
			//var base:Number = 6 - numSplit;
			var base:Number = 5;
			for (i = 0; i < arrPointResult.length; i++) 
			{
				var item:Array = arrPointResult[i];
				var pos0:Point = new Point();
				var pos1:Point = new Point();
				var pos2:Point = new Point();
				if (item.length == arr.length)
				{
					var sum:Number = 0;
					for (var j:int = 0; j < item.length; j++) 
					{
						pos1 = item[j];
						pos2 = arr[j];
						pos0 = new Point(pos1.x - pos2.x, pos1.y - pos2.y);
						sum = sum + pos0.length;
					}
					if (sum < item.length * base)
					{
						return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * Trả kết quả vào mảng arrPointResult chứa các mảng con arr, các mảng con arr chứa các điểm trong các đoạn M0-Min
		 * @param	RecX	:	1/2 Chiều rộng của bức ảnh
		 * @param	RecY	:	1/2 Chiều cao của bức ảnh
		 * @param	n	:	Số mảnh mà mình break ra
		 */
		private function GenResultArr(RecX:Number, RecY:Number, n:int):void 
		{
			var deltaAlpha:Number = 360 / n;
			arrPointResult = [];
			arrDirResult = [];
			for (var i:int = 0; i < n; i++) 
			{
				var arr:Array = [];
				var arrDir:Array = [];
				//var m:int = Math.round(3 + 2 * Math.random());
				var m:int = 5;
				var posN:Point = new Point();
				//var alphaI:Number = alpha0 + deltaAlpha * i - deltaAlpha / 2  + deltaAlpha * Math.random();
				var alphaI:Number = alpha0 + deltaAlpha * i + deltaAlpha / 2 * Math.random();
				arrDirResult.push(alphaI);
				posN = GetPosInSquare(alphaI, RecX, RecY);
				arr = GenArrPoint(posN, m, RecX, RecY);
				arrPointResult.push(arr);
			}
		}
		
		/**
		 * 
		 * @param	alphaI	:	Góc của điểm cần xác định
		 * @param	RecX	:	1/2 chiều rộng
		 * @param	RecY	:	1/2 chiều cao
		 * @return
		 */
		private function GetPosInSquare(alphaI:Number, RecX:Number, RecY:Number):Point
		{
			var posN:Point = new Point();
			alphaI = alphaI - int(int(alphaI) / 360) * 360;
			if (alphaI < 45) 
			{
				posN.y = RecX * Math.tan(alphaI * Math.PI / 180);
				posN.x = RecX;
			}
			else if (alphaI < 135) 
			{
				posN.y = RecY;
				posN.x = RecY / (Math.tan(alphaI * Math.PI / 180));
			}
			else if (alphaI < 225) 
			{
				posN.x = -RecX;
				posN.y = -RecX * (Math.tan(alphaI * Math.PI / 180));
			}
			else if (alphaI < 315) 
			{
				posN.y = -RecY;
				posN.x = -RecY / (Math.tan(alphaI * Math.PI / 180));
			}
			else 
			{
				posN.y = RecX * Math.tan(alphaI * Math.PI / 180);
				posN.x = RecX;
			}
			return posN;
		}
		
		/**
		 * Sinh ra mảng các điểm fake
		 * @param	Rec	: bán kính - chính là bán kính khi sinh ra mảng kết quả
		 * @return
		 */
		private function GenOtherArr(RecX:Number, RecY:Number):Array
		{
			var n:int = arrPointResult.length;
			var deltaAlpha:Number = 360 / n;
			var i:int = Math.floor(Math.random() * n);
			var m:int;
			var posN:Point;
			var alphaI1:Number = 0;
			var alphaI2:Number = 0;
			var arr:Array;
			var arrOther:Array = [];
			var arrDir:Array = [];
			
			var deltaAlphaMax:Number = Number.MIN_VALUE;
			var deltaAlphaMin:Number = Number.MAX_VALUE;
			var deltaAlphaDistance:Number = 0.5;
			do
			{
				arr = new Array();
				//m = Math.round(3 + 2 * Math.random());
				m = 5;
				posN = new Point();
				alphaI1 = arrDirResult[1] + (arrDirOther.length + 0.5 * Math.random()) * ((360 - (arrDirResult[1] - arrDirResult[0])) / (numSplit - 1));
				posN = GetPosInSquare(alphaI1, RecX, RecY);
				arr = GenArrPoint(posN, m, RecX, RecY);
				arrDir.push(alphaI1);
				arrOther.push(arr);
				i = i + 1 >= n ? 0 : i + 1;
				
				arr = new Array();
				m = Math.round(3 + 2 * Math.random());
				posN = new Point();
				//alphaI2 = alpha0 + deltaAlphaMin + Math.random() * deltaAlphaDistance * 2;
				//alphaI2 = alphaI1 + deltaAlphaMin + deltaAlphaMin + (deltaAlphaMax - deltaAlphaMin) * Math.random();
				//alphaI2 = alphaI1 + deltaAlpha / 2 * (1 + Math.random());
				alphaI2 = arrDirResult[1] + (arrDirOther.length + 1 + 0.5 * Math.random()) * ((360 - (arrDirResult[1] - arrDirResult[0])) / (numSplit - 1));
				posN = GetPosInSquare(alphaI2, RecX, RecY);
				arrDir.push(alphaI2);
				arr = GenArrPoint(posN, m, RecX, RecY);
			}
			while (!CheckArrVsResult(arr))
			arrOther.push(arr);
			
			arrDirOther.push(arrDir);
			return arrOther;
		}
		
		/**
		 * Trả về năng lượng cần dùng cho lầm chọn thứ time
		 * @param	time	:	0 -> vô numpiece
		 */
		private function GetEnergyNeed(time:int):int
		{
			return Math.round(1 + 1 / 2 * time + 1 / 3 * time * time);
		}
		
		/**
		 * Hàm lấy mặt nạ của phần hình giới hạn bởi 2 tia tạo từ arrSplit1 đến arrSplit2
		 * @param	RecX		:	1/2 chiều rộng hình
		 * @param	RecY		: 	1/2 chiều cao ảnh
		 * @param	arrSplit1	:	dãy các điểm tao nên tia đầu tiên
		 * @param	arrSplit2	:	dãy các điểm tao nên tia thứ 2
		 * @param	Dir1		: 	góc tạo bởi tia đầu tiên
		 * @param	Dir2		:	góc tạo bởi tia thứ 2
		 * @return
		 */
		private function GetMask(RecX:Number, RecY:Number, arrSplit1:Array, arrSplit2:Array, Dir1:Number, Dir2:Number):Sprite
		{
			var i:int = 0;
			var Pos:Point = new Point;
			var Pos1:Point = arrSplit1[0];
			var Pos2:Point = arrSplit2[0];
			
			var posStart:Point = new Point();
			var posEnd:Point = new Point();
			var posControl:Point = new Point();
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000);
			
			sp.graphics.moveTo(0, 0);
			for (i = arrSplit1.length - 2; i > 0; i--) 
			{
				if (i == arrSplit1.length - 2)
				{
					posStart = new Point(0, 0);
					posEnd = new Point((arrSplit1[i].x + arrSplit1[i - 1].x) / 2, (arrSplit1[i].y + arrSplit1[i - 1].y) / 2);
					posControl = arrSplit1[i];
				}
				else if(i == 1)
				{
					posEnd = arrSplit1[0]
					posStart = new Point((arrSplit1[i].x + arrSplit1[i + 1].x) / 2, (arrSplit1[i].y + arrSplit1[i + 1].y) / 2);
					posControl = arrSplit1[i];
				}
				else 
				{
					posStart = new Point((arrSplit1[i].x + arrSplit1[i + 1].x) / 2, (arrSplit1[i].y + arrSplit1[i + 1].y) / 2);
					posEnd = new Point((arrSplit1[i].x + arrSplit1[i - 1].x) / 2, (arrSplit1[i].y + arrSplit1[i - 1].y) / 2);
					posControl = arrSplit1[i];
				}
				sp.graphics.curveTo(posControl.x, posControl.y, posEnd.x, posEnd.y);
			}
			
			var arrPosMid:Array = new Array();
			arrPosMid = GetPointMidle(RecX, RecY, Pos1, Pos2, Dir1, Dir2);
			for (i = 0; i < arrPosMid.length; i++) 
			{
				Pos = new Point();
				Pos = arrPosMid[i] as Point;
				sp.graphics.lineTo(Pos.x, Pos.y);
			}
			
			sp.graphics.lineTo(arrSplit2[0].x, arrSplit2[0].y);
			for (i = 1; i < arrSplit2.length - 1; i++) 
			{
				if (i == arrSplit2.length - 2)
				{
					posEnd = new Point(0, 0);
				}
				else 
				{
					posEnd = new Point((arrSplit2[i].x + arrSplit2[i + 1].x) / 2, (arrSplit2[i].y + arrSplit2[i + 1].y) / 2);
				}
				posControl = arrSplit2[i];
				sp.graphics.curveTo(posControl.x, posControl.y, posEnd.x, posEnd.y);
			}
			return sp;
		}
		//private function GetMask(RecX:Number, RecY:Number, arrSplit1:Array, arrSplit2:Array, Dir1:Number, Dir2:Number):Sprite
		//{
			//var i:int = 0;
			//var Pos:Point = new Point;
			//var Pos1:Point = arrSplit1[0];
			//var Pos2:Point = arrSplit2[0];
			//
			//var sp:Sprite = new Sprite();
			//sp.graphics.beginFill(0x000000);
			//
			//sp.graphics.moveTo(0, 0);
			//for (i = arrSplit1.length - 2; i >= 0; i--) 
			//{
				//Pos = new Point();
				//Pos = arrSplit1[i] as Point;
				//sp.graphics.lineTo(Pos.x, Pos.y);
			//}
			//
			//var arrPosMid:Array = new Array();
			//arrPosMid = GetPointMidle(RecX, RecY, Pos1, Pos2, Dir1, Dir2);
			//for (i = 0; i < arrPosMid.length; i++) 
			//{
				//Pos = new Point();
				//Pos = arrPosMid[i] as Point;
				//sp.graphics.lineTo(Pos.x, Pos.y);
			//}
			//
			//for (i = 0; i < arrSplit2.length; i++) 
			//{
				//Pos = arrSplit2[i] as Point;
				//sp.graphics.lineTo(Pos.x, Pos.y);
			//}
			//return sp;
		//}
		/**
		 * Hàm trả về các điểm trung gian mà mask đi qua
		 * @param	RecX	:	1/2 chiều rộng
		 * @param	RecY	: 	1/2 chiều cao
		 * @param	Pos1	:	vị trí của điểm bắt đầu
		 * @param	Pos2	:	Vị trí điểm kết thúc
		 * @param	Dir1	: 	góc của điểm bắt đầu
		 * @param	Dir2	: 	góc của điểm kết thúc
		 * @return
		 */
		private function GetPointMidle(RecX:Number, RecY:Number, Pos1:Point, Pos2:Point, Dir1:Number, Dir2:Number):Array
		{
			var arr:Array = [];
			switch (Pos1.x) 
			{
				case RecX:
					switch (Pos2.x) 
					{
						case RecX:
							if (Pos1.y > Pos2.y)
							{
								arr.push(new Point(RecX, RecY));
								arr.push(new Point(-RecX, RecY));
								arr.push(new Point(-RecX, -RecY));
								arr.push(new Point(RecX, -RecY));
								return arr;
							}
							else if(Pos1.y	< Pos2.y)
							{
								return arr;
							}
						break;
						case - RecX:
							arr.push(new Point(RecX, RecY));
							arr.push(new Point(-RecX, RecY));
							return arr;
						break;
						default:
							if (Pos2.y == RecY)
							{
								arr.push(new Point(RecX, RecY));
								return arr;
							}
							else if (Pos2.y == -RecY)
							{
								arr.push(new Point(RecX, RecY));
								arr.push(new Point(-RecX, RecY));
								arr.push(new Point(-RecX, -RecY));
								return arr;
							}
						break;
					}
				break;
				
				case -RecX:
					switch (Pos2.x) 
					{
						case -RecX:
							if (Pos1.y < Pos2.y)
							{
								arr.push(new Point(-RecX, -RecY));
								arr.push(new Point(RecX, -RecY));
								arr.push(new Point(RecX, RecY));
								arr.push(new Point(-RecX, RecY));
								return arr;
							}
							else if(Pos1.y	> Pos2.y)
							{
								return arr;
							}
						break;
						case RecX:
							arr.push(new Point(-RecX, -RecY));
							arr.push(new Point(RecX, -RecY));
							return arr;
						break;
						default:
							if (Pos2.y == -RecY)
							{
								arr.push(new Point(-RecX, -RecY));
								return arr;
							}
							else if (Pos2.y == RecY)
							{
								arr.push(new Point(-RecX, -RecY));
								arr.push(new Point(RecX, -RecY));
								arr.push(new Point(RecX, RecY));
								return arr;
							}
						break;
					}
				break;
				
				default:
					if (Pos1.y == RecY)
					{
						switch (Pos2.y) 
						{
							case RecY:
								if (Pos1.x > Pos2.x)
								{
									return arr;
								}
								else if(Pos1.x < Pos2.x)
								{
									arr.push(new Point(-RecX, RecY));
									arr.push(new Point(-RecX, -RecY));
									arr.push(new Point(RecX, -RecY));
									arr.push(new Point(RecX, RecY));
									return arr;
								}
							break;
							case -RecY:
								arr.push(new Point(-RecX, RecY));
								arr.push(new Point(-RecX, -RecY));
								return arr;
							break;
							default:
								if (Pos2.x == -RecX)
								{
									arr.push(new Point(-RecX, RecY));
									return arr;
								}
								else if(Pos2.x == RecX)
								{
									arr.push(new Point(-RecX, RecY));
									arr.push(new Point(-RecX, -RecY));
									arr.push(new Point(RecX, -RecY));
									return arr;
								}
							break;
						}
					}
					else if (Pos1.y == -RecY)
					{
						switch (Pos2.y) 
						{
							case -RecY:
								if (Pos1.x < Pos2.x)
								{
									return arr;
								}
								else if(Pos1.x > Pos2.x)
								{
									arr.push(new Point(RecX, -RecY));
									arr.push(new Point(RecX, RecY));
									arr.push(new Point(-RecX, RecY));
									arr.push(new Point(-RecX, -RecY));
									return arr;
								}
							break;
							case RecY:
									arr.push(new Point(RecX, -RecY));
									arr.push(new Point(RecX, RecY));
									return arr;
							break;
							default:
								if (Pos2.x == RecX)
								{
									arr.push(new Point(RecX, -RecY));
									return arr;
								}
								else if(Pos2.x == -RecX)
								{
									arr.push(new Point(RecX, -RecY));
									arr.push(new Point(RecX, RecY));
									arr.push(new Point(-RecX, RecY));
									return arr;
								}
							break;
						}
					}
				break;
			}
			return arr;
		}
	}
}