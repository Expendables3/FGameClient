package GUI.FishMeridian 
{
	import com.adobe.serialization.json.JSON;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendUpgradeMeridian;
	import particleSys.myFish.CometEmit;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMeridian extends BaseGUI 
	{
		private var emitStar:Array = [];
		private var progressBar:ProgressBar;
		private var labelPercent:TextField;
		private var labelName:TextField;
		private var curSoldier:FishSoldier;
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		private var imageSolider:Image;
		private var ctnMeridian:Container;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BACK_SOLIDER:String = "btnBackSolider";
		static public const BTN_NEXT_SOLIDER:String = "btnNextSolider";
		static public const BTN_MERIDIAN:String = "btnMeridian";
		static public const CTN_MERIDIAN:String = "ctnMeridian";
		static public const LINE_MERIDIAN:String = "lineMeridian";
		static public const POINT_MERIDIAN:String = "pointMeridian";
		static public const CTN_INFO:String = "ctnInfo";
		static public const BTN_STING:String = "btnSting";
		static public const BTN_BACK_MERIDIAN:String = "btnBackMeridian";
		static public const BTN_NEXT_MERIDIAN:String = "btnNextMeridian";
		static public const MAX_RANK:int = 20;
		static public const MAX_MERIDIAN_POINT:int = 10;
		static public const IC_LOCK:String = "icLock";
		static public const BTN_ACHIEVEMENT:String = "btnAchievement";
		
		private var ctnInfoMeridian:Container;
		private var configPoint:Object = 
		{
			5:[new Point(167, 35), new Point(220, 33), new Point(207, 80), new Point(233, 113), new Point(185, 116), new Point(150, 84),
			new Point(102, 71), new Point(127, 138), new Point(83, 153), new Point(71, 196)],
			4:[new Point(194, 72), new Point(205, 114), new Point(175, 174), new Point(161, 134), new Point(158, 93), new Point(121, 127),
			new Point(105, 83), new Point(121, 40), new Point(78, 35), new Point(28, 56)],
			3:[new Point(196, 127), new Point(185, 72), new Point(139, 75), new Point(93, 37), new Point(75, 86), new Point(112, 117),
			new Point(87, 163), new Point(143, 175), new Point(101, 207), new Point(33, 210)],
			2:[new Point(223, 60), new Point(228, 103), new Point(193, 142), new Point(158, 104), new Point(189, 71), new Point(151, 49),
			new Point(104, 70), new Point(108, 118), new Point(78, 155), new Point(16, 135)], 
			1:[new Point(231, 42), new Point(179, 62), new Point(134, 57), new Point(140, 105), new Point(191, 107), new Point(200, 158),
			new Point(144, 156), new Point(86, 143), new Point(88, 97), new Point(35, 125)]
		}
		
		private var configPosition:Object = 
		{ 
			"1": 
			{ 
				"1": { "1": { "y":36.4, "x":227.6 }, "2": { "y":58, "x":180 }, "3": { "y":55, "x":137 }, "4": { "y":105, "x":136 }, "5": { "y":107, "x":194 }, "6": { "y":160, "x":196 }, "7": { "y":159, "x":140 }, "8": { "y":145, "x":85 }, "9": { "y":99, "x":92 }, "10": { "y":123, "x":36 }},
				"2": { "1": { "y":109.4, "x":154.65 }, "2": { "y":99.45, "x":120.65 }, "3": { "y":69.45, "x":140.65 }, "4": { "y":83, "x":191 }, "5": { "y":158.4, "x":158.6 }, "6": { "y":108, "x":78 }, "7": { "y":11, "x":156 }, "8": { "y":46, "x":238 }, "9": { "y":216, "x":200 }, "10": { "y":121, "x":32 }}, 
				"3": { "1": { "y":54.4, "x":213.65 }, "2": { "y":117.4, "x":59.65 }, "3": { "y":150.4, "x":100.65 }, "4": { "y":206, "x":183 }, "5": { "y":230, "x":226 }, "6": { "y":118, "x":121 }, "7": { "y":150, "x":167 }, "8": { "y":96, "x":162 }, "9": { "y":140, "x":204 }, "10": { "y":76, "x":206 }}, 
				"4": { "1": { "y":92.4, "x":155.65 }, "2": { "y":92, "x":208 }, "3": { "y":47, "x":179 }, "4": { "y":67, "x":118 }, "5": { "y":116, "x":114 }, "6": { "y":120, "x":194 }, "7": { "y":165, "x":199 }, "8": { "y":161, "x":120 }, "9": { "y":123, "x":87 }, "10": { "y":117, "x":36 }}, 
				"5": { "1": { "y":54, "x":214 }, "2": { "y":76, "x":184 }, "3": { "y":63.05, "x":133 }, "4": { "y":139, "x":204 }, "5": { "y":118.05, "x":145.05 }, "6": { "y":148, "x":110 }, "7": { "y":104, "x":91 }, "8": { "y":126, "x":67 }, "9": { "y":126, "x":40 }, "10": { "y":117, "x":15 }}, 
				"6": { "1": { "y":72.45, "x":161.65 }, "2": { "y":118, "x":162 }, "3": { "y":77, "x":116 }, "4": { "y":37, "x":167 }, "5": { "y":72, "x":215 }, "6": { "y":157, "x":189 }, "7": { "y":145, "x":128 }, "8": { "y":111, "x":87 }, "9": { "y":160, "x":118 }, "10": { "y":119, "x":29 }},
				"7": { "1": { "y":43.4, "x":232.6 }, "2": { "y":60.9, "x":204.95 }, "3": { "y":57, "x":176 }, "4": { "y":101, "x":171 }, "5": { "y":90, "x":123 }, "6": { "y":136, "x":133 }, "7": { "y":99, "x":92 }, "8": { "y":142, "x":86 }, "9": { "y":128, "x":55 }, "10": { "y":112, "x":9 }}, 
				"8": { "1": { "y":69, "x":205 }, "2": { "y":58, "x":162 }, "3": { "y":78, "x":138 }, "4": { "y":117, "x":193 }, "5": { "y":146, "x":183 }, "6": { "y":90, "x":97 }, "7": { "y":134, "x":79 }, "8": { "y":175.05, "x":142.95 }, "9": { "y":205, "x":184 }, "10": { "y":224, "x":211 }}, 
				"9": { "1": { "y":93, "x":177 }, "2": { "y":93.4, "x":137.65 }, "3": { "y":61.4, "x":127.65 }, "4": { "y":45, "x":178 }, "5": { "y":92, "x":214 }, "6": { "y":158, "x":195 }, "7": { "y":112, "x":89 }, "8": { "y":127, "x":39 }, "9": { "y":186.95, "x":158 }, "10": { "y":227, "x":216 }}, 
				"10": { "1": { "y":57.35, "x":214.65 }, "2": { "y":49, "x":138 }, "3": { "y":105, "x":200 }, "4": { "y":79, "x":122 }, "5": { "y":122, "x":157 }, "6": { "y":107, "x":115 }, "7": { "y":142, "x":130 }, "8": { "y":125, "x":93.05 }, "9": { "y":145, "x":91 }, "10": { "y":125, "x":26 }},
				11: { 1: { y:114.3, x:26.55 }, 2: { y:160, x:196 }, 3: { y:121, x:201 }, 4: { y:138, x:184 }, 5: { y:135, x:163 }, 6: { y:54, x:207 }, 7: { y:116.9, x:153.05 }, 8: { y:109, x:138 }, 9: { y:61, x:157 }, 10: { y:96, x:117 }}, 
				12: { 1: { y:127.35, x:30.6 }, 2: { y:45, x:178 }, 3: { y:216, x:198 }, 4: { y:137, x:65 }, 5: { y:80, x:165 }, 6: { y:178, x:171 }, 7: { y:98, x:109 }, 8: { y:128, x:180 }, 9: { y:139, x:97 }, 10: { y:102, x:149 }}, 
				13: { 1: { y:113.4, x:38.6 }, 2: { y:100, x:167 }, 3: { y:68, x:161 }, 4: { y:115, x:215 }, 5: { y:170, x:175 }, 6: { y:139, x:178 }, 7: { y:128, x:52 }, 8: { y:101, x:83 }, 9: { y:138, x:126 }, 10: { y:90, x:134 }}, 
				14: { 1: { y:190, x:195 }, 2: { y:46, x:153 }, 3: { y:56, x:181 }, 4: { y:68, x:143 }, 5: { y:83, x:196 }, 6: { y:92, x:140 }, 7: { y:110, x:197.95 }, 8: { y:123, x:127 }, 9: { y:146, x:194 }, 10: { y:146, x:114 }}, 
				15: {1: { y:31, x:228 }, 2: { y:114, x:19 }, 3: { y:213, x:196 }, 4: { y:121, x:63 }, 5: { y:64, x:221 }, 6: { y:123, x:113 }, 7: { y:162, x:205 }, 8: { y:124.1, x:162 }, 9: { y:109, x:202 }, 10: { y:126.05, x:189.95 }}
			}, 
			"2": 
			{ 
				"1": { "1": { "y":62.4, "x":216.6 }, "2": { "y":100, "x":226 }, "3": { "y":138, "x":191 }, "4": { "y":105, "x":158 }, "5": { "y":67, "x":190 }, "6": { "y":49, "x":154 }, "7": { "y":66, "x":101 }, "8": { "y":113, "x":108 }, "9": { "y":156, "x":76 }, "10": { "y":133, "x":18 }}, 
				"2": { "1": { "y":65, "x":231 }, "2": { "y":84, "x":197 }, "3": { "y":100, "x":228 }, "4": { "y":140, "x":196 }, "5": { "y":131, "x":154 }, "6": { "y":40, "x":161 }, "7": { "y":52, "x":107 }, "8": { "y":101, "x":117 }, "9": { "y":138, "x":89 }, "10": { "y":138, "x":18 }}, 
				"3": { "1": { "y":39, "x":247 }, "2": { "y":72, "x":218 }, "3": { "y":39, "x":163 }, "4": { "y":62, "x":130 }, "5": { "y":98, "x":142 }, "6": { "y":100, "x":221 }, "7": { "y":144, "x":197 }, "8": { "y":163, "x":133 }, "9": { "y":148, "x":82 }, "10": { "y":128, "x":13 }}, 
				"4": { "1": { "y":73, "x":226 }, "2": { "y":39, "x":162 }, "3": { "y":69, "x":108 }, "4": { "y":99, "x":79 }, "5": { "y":135, "x":9 }, "6": { "y":153, "x":76 }, "7": { "y":112, "x":120 }, "8": { "y":157, "x":136 }, "9": { "y":133.95, "x":199.95 }, "10": { "y":100, "x":181 }}, 
				"5": { "1": { "y":35, "x":146 }, "2": { "y":76, "x":114 }, "3": { "y":94, "x":144 }, "4": { "y":64, "x":202 }, "5": { "y":100, "x":217 }, "6": { "y":143, "x":177 }, "7": { "y":158, "x":136 }, "8": { "y":150, "x":84 }, "9": { "y":135, "x":28 }, "10": { "y":118, "x":1 }}, 
				"6": { "1": { "y":65, "x":207 }, "2": { "y":37, "x":157 }, "3": { "y":51, "x":111 }, "4": { "y":91, "x":86 }, "5": { "y":132, "x":91 }, "6": { "y":155, "x":137 }, "7": { "y":138, "x":179 }, "8": { "y":103, "x":200 }, "9": { "y":83, "x":153 }, "10": { "y":114, "x":145 }}, 
				"7": { "1": { "y":94, "x":229 }, "2": { "y":50, "x":197 }, "3": { "y":121, "x":201 }, "4": { "y":54, "x":154 }, "5": { "y":141, "x":159 }, "6": { "y":55, "x":123 }, "7": { "y":155, "x":127 }, "8": { "y":94, "x":89 }, "9": { "y":152, "x":89 }, "10": { "y":126, "x":34 }}, 
				"8": { "1": { "y":66.35, "x":232.65 }, "2": { "y":42, "x":153 }, "3": { "y":87, "x":218 }, "4": { "y":61, "x":121 }, "5": { "y":123, "x":197 }, "6": { "y":90, "x":99 }, "7": { "y":147, "x":187 }, "8": { "y":138, "x":90 }, "9": { "y":177, "x":127 }, "10": { "y":144, "x":16 }}, 
				"9": { "1": { "y":141.4, "x":195.6 }, "2": { "y":98, "x":222 }, "3": { "y":65, "x":206 }, "4": { "y":121, "x":176 }, "5": { "y":102, "x":131 }, "6": { "y":71, "x":167 }, "7": { "y":34, "x":148 }, "8": { "y":63, "x":109 }, "9": { "y":133, "x":28 }, "10": { "y":159, "x":138 }}, 
				"10": { "1": { "y":104, "x":159 }, "2": { "y":82.05, "x":132.05 }, "3": { "y":113, "x":107 }, "4": { "y":146, "x":164 }, "5": { "y":101, "x":224 }, "6": { "y":64, "x":191 }, "7": { "y":79, "x":168 }, "8": { "y":47, "x":141 }, "9": { "y":135, "x":20 }, "10": { "y":159, "x":46 }},
				11: { 1: { y:125.4, x:205.65 }, 2: { y:136, x:190 }, 3: { y:142, x:175 }, 4: { y:148, x:42 }, 5: { y:142, x:31 }, 6: { y:129, x:16 }, 7: { y:52, x:131 }, 8: { y:47, x:146 }, 9: { y:48, x:164 }, 10: { y:76, x:206 }}, 
				12: { 1: { y:159, x:139 }, 2: { y:76, x:229 }, 3: { y:155, x:18 }, 4: { y:77, x:190 }, 5: { y:69, x:147 }, 6: { y:43, x:133 }, 7: { y:78, x:118 }, 8: { y:70, x:104 }, 9: { y:83, x:88 }, 10: { y:108, x:70 }}, 
				13: { 1: { y:57, x:243 }, 2: { y:158, x:34 }, 3: { y:105, x:76 }, 4: { y:171, x:134 }, 5: { y:78, x:121 }, 6: { y:141, x:162 }, 7: { y:72, x:160 }, 8: { y:104, x:203 }, 9: { y:58, x:193 }, 10: { y:78, x:215 }}, 
				14: { 1: { y:143, x:23 }, 2: { y:32, x:133 }, 3: { y:147, x:213 }, 4: { y:57, x:134 }, 5: { y:146, x:53 }, 6: { y:77, x:131 }, 7: { y:147, x:185 }, 8: { y:93, x:130 }, 9: { y:152, x:93 }, 10: { y:123, x:142 }}, 
				15: {1: { y:154.35, x:117.65 }, 2: { y:136, x:19 }, 3: { y:29, x:135 }, 4: { y:97, x:236 }, 5: { y:150, x:145 }, 6: { y:112, x:78 }, 7: { y:57, x:136 }, 8: { y:100, x:190 }, 9: { y:127, x:139 }, 10: { y:88, x:136 }}
			}, 
			"3": 
			{ 
				"1": { "1": { "y":128.4, "x":200.65 }, "2": { "y":73, "x":187 }, "3": { "y":72, "x":138 }, "4": { "y":39, "x":93 }, "5": { "y":82, "x":70 }, "6": { "y":117, "x":114 }, "7": { "y":159, "x":88 }, "8": { "y":172, "x":141 }, "9": { "y":206, "x":99 }, "10": { "y":209, "x":33 }}, 
				"2": { "1": { "y":123.45, "x":197.65 }, "2": { "y":106, "x":134 }, "3": { "y":74, "x":187 }, "4": { "y":71, "x":139 }, "5": { "y":78, "x":75 }, "6": { "y":118, "x":63 }, "7": { "y":121, "x":102 }, "8": { "y":164, "x":138 }, "9": { "y":199, "x":130 }, "10": { "y":168, "x":77 }}, 
				"3": { "1": { "y":121, "x":177 }, "2": { "y":99, "x":168 }, "3": { "y":84, "x":141 }, "4": { "y":90, "x":112 }, "5": { "y":111, "x":80 }, "6": { "y":142, "x":86 }, "7": { "y":162, "x":103 }, "8": { "y":178, "x":138 }, "9": { "y":198, "x":122 }, "10": { "y":208, "x":60 }}, 
				"4": { "1": { "y":58.4, "x":221.65 }, "2": { "y":101.4, "x":218.65 }, "3": { "y":159.4, "x":134.65 }, "4": { "y":138, "x":23 }, "5": { "y":48, "x":119 }, "6": { "y":67, "x":190 }, "7": { "y":97, "x":183 }, "8": { "y":122, "x":123 }, "9": { "y":103, "x":89 }, "10": { "y":70, "x":135.05 }}, 
				"5": { "1": { "y":43.4, "x":163.65 }, "2": { "y":41, "x":130 }, "3": { "y":82.45, "x":104.65 }, "4": { "y":123, "x":111 }, "5": { "y":93, "x":155 }, "6": { "y":73, "x":160 }, "7": { "y":70, "x":207 }, "8": { "y":103, "x":214 }, "9": { "y":160, "x":141 }, "10": { "y":141, "x":17 }}, 
				"6": { "1": { "y":44, "x":162 }, "2": { "y":93, "x":172 }, "3": { "y":69, "x":116 }, "4": { "y":91, "x":65 }, "5": { "y":128, "x":21 }, "6": { "y":158, "x":113 }, "7": { "y":198, "x":221 }, "8": { "y":202, "x":103 }, "9": { "y":208, "x":36 }, "10": { "y":169, "x":33 }}, 
				"7": { "1": { "y":100, "x":176 }, "2": { "y":125, "x":187 }, "3": { "y":121, "x":142 }, "4": { "y":67, "x":115 }, "5": { "y":93, "x":65 }, "6": { "y":127, "x":23 }, "7": { "y":158, "x":108 }, "8": { "y":179, "x":124 }, "9": { "y":209, "x":57 }, "10": { "y":202, "x":220 }}, 
				"8": { "1": { "y":89, "x":155 }, "2": { "y":95, "x":131 }, "3": { "y":68, "x":125 }, "4": { "y":62, "x":165 }, "5": { "y":98, "x":193 }, "6": { "y":123, "x":145 }, "7": { "y":82.05, "x":94 }, "8": { "y":100, "x":60 }, "9": { "y":159, "x":98 }, "10": { "y":195, "x":211 }}, 
				"9": { "1": { "y":83.45, "x":115.65 }, "2": { "y":33.4, "x":131.65 }, "3": { "y":66.95, "x":166 }, "4": { "y":50, "x":214 }, "5": { "y":90, "x":184 }, "6": { "y":140, "x":206 }, "7": { "y":111, "x":152 }, "8": { "y":152, "x":138 }, "9": { "y":102, "x":124 }, "10": { "y":142, "x":32 }}, 
				"10": { "1": { "y":124, "x":194 }, "2": { "y":60, "x":121 }, "3": { "y":97, "x":72 }, "4": { "y":126, "x":106 }, "5": { "y":146, "x":73 }, "6": { "y":154, "x":140 }, "7": { "y":168, "x":95 }, "8": { "y":181, "x":138 }, "9": { "y":191, "x":207 }, "10": { "y":212, "x":98 }},
				11: { 1: { y:42.35, x:101.55 }, 2: { y:100, x:192 }, 3: { y:192, x:141 }, 4: { y:162, x:51 }, 5: { y:89, x:82 }, 6: { y:113, x:152 }, 7: { y:171, x:134 }, 8: { y:157, x:91 }, 9: { y:123, x:96 }, 10: { y:196, x:220 }}, 
				12: { 1: { y:188, x:209 }, 2: { y:164.35, x:212.6 }, 3: { y:210, x:260 }, 4: { y:214, x:189 }, 5: { y:181, x:176 }, 6: { y:119, x:10 }, 7: { y:173, x:188 }, 8: { y:109, x:150 }, 9: { y:195, x:113 }, 10: { y:117, x:100 }}, 
				13: { 1: { y:121.4, x:11.6 }, 2: { y:196, x:229 }, 3: { y:82, x:157 }, 4: { y:99, x:136 }, 5: { y:120, x:150 }, 6: { y:93, x:189 }, 7: { y:66, x:180 }, 8: { y:58, x:127 }, 9: { y:84, x:103 }, 10: { y:114, x:96 }}, 
				14: { 1: { y:42.4, x:108.6 }, 2: { y:201, x:232 }, 3: { y:208, x:29 }, 4: { y:178, x:186 }, 5: { y:64, x:92 }, 6: { y:166, x:151 }, 7: { y:179, x:47 }, 8: { y:156, x:126 }, 9: { y:85, x:75 }, 10: { y:143, x:98 }}, 
				15: {1: { y:209.4, x:30.65 }, 2: { y:31, x:82 }, 3: { y:211, x:234 }, 4: { y:216, x:49 }, 5: { y:73, x:86 }, 6: { y:187, x:195 }, 7: { y:179, x:74 }, 8: { y:112, x:97 }, 9: { y:166.5, x:153.4 }, 10: { y:167, x:102 }} 
			}, 
			"4": 
			{ 
				"1": { "1": { "y":72.45, "x":196.65 }, "2": { "y":112, "x":206 }, "3": { "y":169, "x":171 }, "4": { "y":133, "x":158 }, "5": { "y":98, "x":158 }, "6": { "y":129, "x":116 }, "7": { "y":85, "x":108 }, "8": { "y":40, "x":117 }, "9": { "y":34, "x":81 }, "10": { "y":52, "x":28 }}, 
				"2": { "1": { "y":94, "x":176 }, "2": { "y":120, "x":141 }, "3": { "y":89, "x":93 }, "4": { "y":43, "x":108 }, "5": { "y":48, "x":171 }, "6": { "y":103, "x":212 }, "7": { "y":145, "x":139 }, "8": { "y":97, "x":64 }, "9": { "y":26, "x":85 }, "10": { "y":24.4, "x":48.65 }}, 
				"3": { "1": { "y":118, "x":188 }, "2": { "y":133, "x":159 }, "3": { "y":99, "x":144 }, "4": { "y":79, "x":182 }, "5": { "y":124, "x":216 }, "6": { "y":178, "x":158 }, "7": { "y":99, "x":104 }, "8": { "y":56, "x":149 }, "9": { "y":26, "x":82 }, "10": { "y":48, "x":25 }}, 
				"4": { "1": { "y":48.45, "x":183.65 }, "2": { "y":70, "x":140 }, "3": { "y":22, "x":104 }, "4": { "y":50, "x":39 }, "5": { "y":86, "x":104 }, "6": { "y":137, "x":127 }, "7": { "y":98, "x":187 }, "8": { "y":148, "x":188 }, "9": { "y":194, "x":154 }, "10": { "y":216, "x":100 }}, 
				"5": { "1": { "y":110, "x":149 }, "2": { "y":50, "x":38 }, "3": { "y":25, "x":87 }, "4": { "y":49, "x":175 }, "5": { "y":103, "x":209 }, "6": { "y":140, "x":205 }, "7": { "y":183, "x":169 }, "8": { "y":179.1, "x":107.95 }, "9": { "y":158.05, "x":73.95 }, "10": { "y":123, "x":67 }}, 
				"6": { "1": { "y":117, "x":152 }, "2": { "y":126, "x":73 }, "3": { "y":151, "x":82 }, "4": { "y":169, "x":117 }, "5": { "y":207, "x":125 }, "6": { "y":81, "x":194 }, "7": { "y":119, "x":54 }, "8": { "y":156, "x":42 }, "9": { "y":188, "x":81 }, "10": { "y":216, "x":96 }}, 
				"7": { "1": { "y":176.45, "x":158.65 }, "2": { "y":117, "x":212 }, "3": { "y":62, "x":160 }, "4": { "y":111, "x":173 }, "5": { "y":24, "x":113 }, "6": { "y":103.05, "x":141.95 }, "7": { "y":29, "x":22 }, "8": { "y":121, "x":128 }, "9": { "y":153, "x":63 }, "10": { "y":154, "x":120 }}, 
				"8": { "1": { "y":138, "x":203 }, "2": { "y":17, "x":33 }, "3": { "y":47, "x":99 }, "4": { "y":81.05, "x":150.95 }, "5": { "y":62, "x":175 }, "6": { "y":95, "x":182 }, "7": { "y":137, "x":156 }, "8": { "y":151, "x":123 }, "9": { "y":121, "x":137 }, "10": { "y":73.95, "x":87.05 }}, 
				"9": { "1": { "y":142, "x":203 }, "2": { "y":106, "x":198 }, "3": { "y":73, "x":188 }, "4": { "y":95, "x":163 }, "5": { "y":54.95, "x":101 }, "6": { "y":21, "x":26 }, "7": { "y":68, "x":79 }, "8": { "y":131, "x":140 }, "9": { "y":157, "x":129 }, "10": { "y":147, "x":184 }}, 
				"10": { "1": { "y":105.4, "x":69.65 }, "2": { "y":92.95, "x":111 }, "3": { "y":50, "x":133 }, "4": { "y":77, "x":161 }, "5": { "y":70, "x":202 }, "6": { "y":97, "x":177 }, "7": { "y":147, "x":199.95 }, "8": { "y":130, "x":152 }, "9": { "y":176, "x":111 }, "10": { "y":119, "x":117 }},
				11: { 1: { y:39, x:21 }, 2: { y:131, x:204 }, 3: { y:176, x:170 }, 4: { y:91, x:202 }, 5: { y:143, x:161 }, 6: { y:73, x:187 }, 7: { y:120, x:150 }, 8: { y:79, x:153 }, 9: { y:108, x:117 }, 10: { y:64, x:117 }}, 
				12: { 1: { y:27.35, x:24.65 }, 2: { y:54, x:201 }, 3: { y:186, x:143 }, 4: { y:57, x:37 }, 5: { y:92, x:201 }, 6: { y:168, x:169 }, 7: { y:96, x:216 }, 8: { y:140, x:207 }, 9: { y:110, x:140 }, 10: { y:93, x:94 }}, 
				13: { 1: { y:95, x:146 }, 2: { y:118, x:133 }, 3: { y:75, x:117 }, 4: { y:90, x:171 }, 5: { y:162, x:122 }, 6: { y:39, x:82 }, 7: { y:78, x:206 }, 8: { y:204, x:118 }, 9: { y:30, x:34 }, 10: { y:10, x:93 }}, 
				14: { 1: { y:182, x:112 }, 2: { y:78, x:182 }, 3: { y:55, x:34 }, 4: { y:191, x:146 }, 5: { y:133, x:199 }, 6: { y:94, x:84 }, 7: { y:161, x:159 }, 8: { y:108, x:201 }, 9: { y:88, x:128 }, 10: { y:173, x:187 }}, 
				15: {1: { y:30, x:93 }, 2: { y:73, x:181 }, 3: { y:118, x:196 }, 4: { y:151, x:182 }, 5: { y:150, x:139 }, 6: { y:115, x:106 }, 7: { y:66.95, x:116 }, 8: { y:83, x:157 }, 9: { y:118, x:158 }, 10: { y:97, x:130 }}
			}, 
			"5": 
			{ 
				"1": { "1": { "y":36.35, "x":164.65 }, "2": { "y":32, "x":218 }, "3": { "y":79, "x":206 }, "4": { "y":111, "x":231 }, "5": { "y":113, "x":183 }, "6": { "y":84, "x":148 }, "7": { "y":69, "x":101 }, "8": { "y":138, "x":127 }, "9": { "y":151, "x":82 }, "10": { "y":197, "x":69 }}, 
				"2": { "1": { "y":36, "x":217 }, "2": { "y":97.4, "x":215.65 }, "3": { "y":45, "x":186 }, "4": { "y":77, "x":160 }, "5": { "y":32, "x":58 }, "6": { "y":132, "x":189 }, "7": { "y":116, "x":131 }, "8": { "y":158, "x":133 }, "9": { "y":156, "x":88 }, "10": { "y":190, "x":72 }}, 
				"3": { "1": { "y":95, "x":179 }, "2": { "y":113, "x":217 }, "3": { "y":54, "x":218 }, "4": { "y":45, "x":184 }, "5": { "y":81, "x":130 }, "6": { "y":132, "x":144 }, "7": { "y":136, "x":113 }, "8": { "y":150, "x":89 }, "9": { "y":189, "x":75 }, "10": { "y":200, "x":36 }}, 
				"4": { "1": { "y":24.35, "x":30.7 }, "2": { "y":142, "x":200 }, "3": { "y":69, "x":146 }, "4": { "y":50, "x":223 }, "5": { "y":126, "x":113 }, "6": { "y":151, "x":146 }, "7": { "y":139, "x":103 }, "8": { "y":166, "x":128 }, "9": { "y":168, "x":82 }, "10": { "y":198.05, "x":58 }}, 
				"5": { "1": { "y":79.4, "x":198.65 }, "2": { "y":101, "x":176 }, "3": { "y":106, "x":223 }, "4": { "y":60, "x":222 }, "5": { "y":40, "x":184 }, "6": { "y":61, "x":157 }, "7": { "y":81, "x":125 }, "8": { "y":138, "x":138 }, "9": { "y":141, "x":101 }, "10": { "y":190, "x":67 }}, 
				"6": { "1": { "y":33.4, "x":179.65 }, "2": { "y":189, "x":66 }, "3": { "y":146, "x":112 }, "4": { "y":145, "x":151 }, "5": { "y":108, "x":136 }, "6": { "y":122, "x":204 }, "7": { "y":89, "x":168 }, "8": { "y":108, "x":222 }, "9": { "y":48, "x":214 }, "10": { "y":64, "x":186 }}, 
				"7": { "1": { "y":77.4, "x":181.7 }, "2": { "y":48, "x":210 }, "3": { "y":98, "x":214 }, "4": { "y":97, "x":168 }, "5": { "y":71, "x":146 }, "6": { "y":22, "x":25 }, "7": { "y":84, "x":130 }, "8": { "y":145, "x":143 }, "9": { "y":146, "x":99 }, "10": { "y":192, "x":70 }}, 
				"8": { "1": { "y":39, "x":227 }, "2": { "y":46, "x":194 }, "3": { "y":111.4, "x":230.65 }, "4": { "y":8, "x":19 }, "5": { "y":133, "x":191 }, "6": { "y":117, "x":110 }, "7": { "y":153, "x":149 }, "8": { "y":136, "x":88 }, "9": { "y":172, "x":124 }, "10": { "y":190, "x":70 }}, 
				"9": { "1": { "y":73, "x":181 }, "2": { "y":63, "x":135 }, "3": { "y":34, "x":187 }, "4": { "y":79, "x":217 }, "5": { "y":104, "x":176 }, "6": { "y":83, "x":143 }, "7": { "y":117, "x":124 }, "8": { "y":147, "x":144 }, "9": { "y":138, "x":103 }, "10": { "y":185.4, "x":72.65 }}, 
				"10": { "1": { "y":44, "x":221 }, "2": { "y":42, "x":64 }, "3": { "y":148, "x":211 }, "4": { "y":5, "x":141 }, "5": { "y":181, "x":76 }, "6": { "y":58.05, "x":193 }, "7": { "y":57, "x":138 }, "8": { "y":126, "x":109 }, "9": { "y":74, "x":148 }, "10": { "y":100, "x":168 }},
				11: { 1: { y:62, x:213 }, 2: { y:60, x:189 }, 3: { y:97, x:183 }, 4: { y:93, x:146 }, 5: { y:138, x:142 }, 6: { y:132, x:118 }, 7: { y:160, x:116 }, 8: { y:154, x:89 }, 9: { y:189, x:79 }, 10: { y:192.35, x:58.65 } },
				12: { 1: { y:22.35, x:26.6 }, 2: { y:41, x:217 }, 3: { y:196, x:109 }, 4: { y:50, x:61 }, 5: { y:58, x:185 }, 6: { y:153, x:116 }, 7: { y:77, x:87 }, 8: { y:77, x:147 }, 9: { y:113, x:120 }, 10: { y:91, x:114 } },
				13: { 1: { y:47.35, x:167.6 }, 2: { y:71, x:119 }, 3: { y:127, x:121 }, 4: { y:106, x:186 }, 5: { y:68, x:179 }, 6: { y:101, x:94 }, 7: { y:174, x:93 }, 8: { y:115, x:221 }, 9: { y:18.9, x:192.9 }, 10: { y:54, x:80 } }, 
				14: { 1: { y:93, x:217 }, 2: { y:36, x:183 }, 3: { y:36, x:69 }, 4: { y:186, x:55 }, 5: { y:152, x:141 }, 6: { y:67, x:137 }, 7: { y:107, x:188 }, 8: { y:112, x:121 }, 9: { y:67.1, x:176.05 }, 10: { y:132, x:152.05 } }, 
				15: { 1: { y:85.35, x:118.6 }, 2: { y:111, x:137 }, 3: { y:188, x:50 }, 4: { y:116.1, x:214.95 }, 5: { y:85, x:184 }, 6: { y:74, x:172 }, 7: { y:61, x:224 }, 8: { y:22, x:184 }, 9: { y:41, x:158 }, 10: { y:61, x:128 } }
			}
		};
		private var labelMeridianName:TextField;
		private var listMeridian:Array;
		private var labelMeridianPoint:TextField;
		private var _meridianPoint:int;
		private var btnSting:Button;
		private var rankImage:Image;
		private var labelDamage:TextField;
		private var labelDefence:TextField;
		private var labelCritical:TextField;
		private var labelVitality:TextField;
		private var i:int;
		//private var configPosition:Object;
		private var newDamage:int;
		private var newDefence:int;
		private var newCritical:int;
		private var newVitality:int;
		private var _damage:int;
		private var _defence:int;
		private var _critical:int;
		private var _vitality:int;
		private var isEffecting:Boolean = false;
		private var deltaDamage:int = 1;
		private var deltaCritical:int = 1;
		private var deltaDefence:int = 1;
		private var deltaVitality:int = 1;
		private const forConfig:Boolean = false;//Dùng bật điền config
		
		public function GUIMeridian(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(60, 30);
				OpenRoomOut();
			}
			LoadRes("GuiMeridian_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			configPosition = configPosition;// ConfigJSON.getInstance().GetItemList("MeridianPosition");
			//var st:String = JSON.encode(configPosition);
			//trace(st);
			
			AddLabel("Click vào điểm mạch để đả thông", 153 - 21 + 12, 355 + 106, 0xffff00, 1, 0x000000);
			AddButton(BTN_CLOSE, "BtnThoat", 664 - 15, 19);
			AddButton(BTN_BACK_MERIDIAN, "GuiMeridian_BtnBack", 100 - 35, 432);
			AddButton(BTN_NEXT_MERIDIAN, "GuiMeridian_BtnNext", 100 + 196, 432);
			AddButton(BTN_ACHIEVEMENT, "GuiMeridian_BtnMeridianAchievement", 144, 95); 
			progressBar = AddProgress("", "GuiMeridian_PrgRank", 3 + 358 + 96, 238 + 88+ 30);
			progressBar.SetBackGround("GuiMeridian_PrgRank_Bg");
			AddImage("", "GuiMeridian_IcRank", 360 + 91, 253+110).FitRect(30, 30, new Point(471 - 37, 363 - 14));
			rankImage = AddImage("", "", 100 + 307, 257 + 100);
			
			var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffff00, true);
			labelName = AddLabel("", 150 + 234 + 78, 334, 0xffffff, 1, 0x000000);
			labelName.defaultTextFormat = txtFormat;
			txtFormat.size = 13;
			txtFormat.color = 0x000000;
			labelPercent = AddLabel("", 110 + 358 - 3, 5 + 88 +26 + 234, 0xffffff, 1);
			labelPercent.defaultTextFormat = txtFormat;
			txtFormat.size = 17;
			labelMeridianPoint = AddLabel("", 300 + 223 - 68, 90 + 32, 0xff0000, 1, 0x000000);
			txtFormat.color = 0xffffff;
			labelMeridianPoint.defaultTextFormat = txtFormat;
			
			labelDamage = AddLabel("", 500, 386, 0xffffff, 0, 0x000000);
			labelDefence = AddLabel("", 500, 386 + 21, 0xffffff, 0, 0x000000);
			labelCritical = AddLabel("", 500, 386 + 42, 0xffffff, 0, 0x000000);
			labelVitality = AddLabel("", 500, 386 + 63, 0xffffff, 0, 0x000000);
			
			//Danh sách các mạch của ngư thủ
			listMeridian = new Array();
			txtFormat.size = 14;
			txtFormat.color = 0x000000;
			labelMeridianName = AddLabel("", 400 - 258, 432, 0x000000, 1);
			labelMeridianName.setTextFormat(txtFormat);
			labelMeridianName.defaultTextFormat = txtFormat;
			
			var arrFishSoldier:Array;
			if (!GameLogic.getInstance().user.IsViewer())
			{
				arrFishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			}
			else
			{
				arrFishSoldier = GameLogic.getInstance().user.FishSoldierAllArr;
			}
			if (curSoldier == null && arrFishSoldier.length > 0)
			{
				curSoldier = arrFishSoldier[0];
			}
			
			if (curSoldier != null)
			{
				showSoldier(curSoldier);
			}
			
			if (arrFishSoldier.length > 1)
			{
				btnBackSolider = AddButton(BTN_BACK_SOLIDER, "GuiMeridian_BtnBack", 68 + 83 + 201, 426 - 208, this);
				btnNextSolider = AddButton(BTN_NEXT_SOLIDER, "GuiMeridian_BtnNext", 285 + 322, 426 - 208, this);
			}
		}
		
		private function showSoldier(soldier:FishSoldier):void
		{
			if (imageSolider != null)
			{
				RemoveImage(imageSolider);
			}
			//Thông tin cá lính
			var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var config:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
			var reputationVitality:Number = 0;
			var reputationDamage:Number = 0;
			var reputationDefence:Number = 0;
			var reputationCritical:Number = 0;
			if(config[reputation] != null)
			{
				reputationVitality = config[reputation]["Vitality"];
				reputationDamage = config[reputation]["Damage"];
				reputationDefence = config[reputation]["Defence"];
				reputationCritical = config[reputation]["Critical"];
			}
			damage = curSoldier.Damage + curSoldier.bonusEquipment.Damage + curSoldier.meridianDamage + reputationDamage;
			newDamage = damage;
			defence = curSoldier.Defence + curSoldier.bonusEquipment.Defence + curSoldier.meridianDefence + reputationDefence;
			newDefence = defence;
			critical = curSoldier.Critical + curSoldier.bonusEquipment.Critical + curSoldier.meridianCritical + reputationCritical;
			newCritical = critical;
			vitality = curSoldier.Vitality + curSoldier.bonusEquipment.Vitality + curSoldier.meridianVitality + reputationVitality;
			newVitality = vitality;
			
			var rankName:String;
			if (soldier.Rank > 13)
			{
				rankName = "Rank13";
			}
			else
			{
				rankName = "Rank" + soldier.Rank;
			}
			rankImage.LoadRes(rankName);
			rankImage.FitRect(60, 60, new Point(100 + 307 - 35 + 5, 257 - 42 + 111));
			imageSolider = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 535, 285);
			imageSolider.FitRect(150, 150, new Point(535 - 124, 285 - 135));
			UpdateFishContent(curSoldier, imageSolider);
			
			labelName.text = "Cấp " + curSoldier.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + curSoldier.Rank);
			labelPercent.text = Ultility.StandardNumber(Math.floor(curSoldier.RankPoint)) + "/" + Ultility.StandardNumber(curSoldier.MaxRankPoint);
			progressBar.setStatus(curSoldier.RankPoint / curSoldier.MaxRankPoint);
			meridianPoint = curSoldier.meridianPoint;
			
			//Tạo danh sách các mạch
			listMeridian = new Array();
			for (var j:int = 1; j <= curSoldier.meridianRank; j++)
			{
				listMeridian.push(Localization.getInstance().getString("FishSoldierRank" + j) + " Mạch");
			}
			labelMeridianName.text = listMeridian[curSoldier.meridianRank - 1];
			
			updateMeridian(curSoldier.meridianRank, curSoldier.meridianPosition);
			updateNextBackMeridian();
		}
		
		/**
		 * Vẽ lại dây chằng
		 * @param	meridianRank cấp dây chằng
		 * @param	meridianPosition điểm mạch
		 */
		private function updateMeridian(meridianRank:int, meridianPosition:int):void
		{
			//Vẽ bảng mạch cá lính
			if (ctnMeridian != null)
			{
				RemoveContainer(CTN_MERIDIAN);
			}
			ctnMeridian = AddContainer(CTN_MERIDIAN, "GuiMeridian_SoldierShape_" + curSoldier.Element, 31, 153);
			ctnMeridian.FitRect(265, 265, new Point(198 - 140, 263 - 141));
			
			var arrPoint:Array;
			//Dung config điểm
			if (forConfig)
			{
				arrPoint = configPoint[curSoldier.Element];
				var str:String = "Start element: " + curSoldier.Element + "\n";
				for (var k:int ; k < arrPoint.length; k++)
				{
					str += (k+1) + ": { y:" + arrPoint[k].y + ", x:" + arrPoint[k].x + " }, ";
				}
				str += "\nEnd element:" + curSoldier.Element + "\n";
				trace(str);
			}
			else
			{
				arrPoint = new Array();
				var config:Object = configPosition[curSoldier.Element][(meridianRank-1)%15+ 1];
				for (var s:String in config)
				{
					var p:Point = new Point(config[s]["x"], config[s]["y"]);
					arrPoint.push(p);
				}
			}
			var i:int;
			for (i = 0; i < arrPoint.length; i++)
			{
				if( i != arrPoint.length -1)
				{
					drawMeridianLine(ctnMeridian, LINE_MERIDIAN + "_" + i.toString(), arrPoint[i], arrPoint[i+1]);
				}
				var meridianPointImage:Container = ctnMeridian.AddContainer(POINT_MERIDIAN + "_" + i.toString(), "GuiMeridian_MeridianPoint", arrPoint[i].x, arrPoint[i].y, true, this);
				if (i == curSoldier.meridianPosition)
				{
					meridianPointImage.img.buttonMode = true;
					meridianPointImage.setHelper("StingMeridian");
				}
				meridianPointImage.GoToAndStop(1);
			}
			
			var tooltipFormat:TooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Bạn phải lên cấp ngư thủ\nđể mở mạch này"
			ctnMeridian.AddContainer(IC_LOCK, "GuiMeridian_IcLock", 400 - 284 - 13, 400 - 169 - 20).setTooltip(tooltipFormat);
			
			//Mạch chưa được mở
			if (meridianRank > curSoldier.Rank)
			{
				meridianPosition = -1;
				ctnMeridian.GetContainer(IC_LOCK).SetVisible(true);
			}
			else
			{
				ctnMeridian.GetContainer(IC_LOCK).SetVisible(false);
			}
			
			for (i = 0; i < 10; i++)
			{
				//Các điểm mạch đã kích hoạt
				if (i < meridianPosition)
				{
					if(i > 0)
					{
						ctnMeridian.GetImage(LINE_MERIDIAN + "_" + (i-1)).GoToAndStop(6);
					}
					ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + i).GoToAndStop(3);
				}
				//Điểm mạch chưa kích hoạt
				else
				{
					if(i > 0)
					{
						ctnMeridian.GetImage(LINE_MERIDIAN + "_" + (i-1)).GoToAndStop(curSoldier.Element);
					}
					ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + i).GoToAndStop(1);
				}
				ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + i).img.buttonMode = false;
			}
			//Điểm mạch tiếp theo cần kích hoạt
			if(meridianPosition < 10 && meridianPosition != -1)
			{
				ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + meridianPosition).GoToAndStop(2);
				ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + meridianPosition).img.buttonMode = true;
			}
			
			//updateInfoMeridian(meridianRank, meridianPosition + 1);
		}
		
		public function drawMeridianLine(ctn:Container, idLine:String, from:Point, to:Point):void
		{
			var lineImage:Image = ctn.AddImage(idLine, "GuiMeridian_MeridianLine", (from.x + to.x) / 2, (from.y + to.y) / 2, true, ALIGN_LEFT_TOP);
			lineImage.img.height = 5;
			lineImage.img.width = Math.sqrt(Math.pow(to.x - from.x, 2) + Math.pow(to.y - from.y, 2));
			var angle:Number = 180 * Math.atan2(Math.abs(to.y - from.y), Math.abs(to.x - from.x)) / Math.PI;
			if ((from.x > to.x && from.y < to.y) || (from.x < to.x && from.y > to.y))
			{
				lineImage.img.rotation = -angle;
			}
			else
			{
				lineImage.img.rotation = angle;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(POINT_MERIDIAN) >= 0)
			{
				var meridianPosition:int = int(buttonID.split("_")[1]) + 1;
				var meridianRank:int = listMeridian.indexOf(labelMeridianName.text) + 1;
				GuiMgr.getInstance().guiMeridianInfo.showGUI(event.stageX, event.stageY, curSoldier.Element, meridianRank, meridianPosition);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			GuiMgr.getInstance().guiMeridianInfo.Hide();
		}
		
		private function updateNextBackMeridian():void
		{
			var index:int = listMeridian.indexOf(labelMeridianName.text);
			if (index == 0)
			{
				GetButton(BTN_BACK_MERIDIAN).SetEnable(false);
			}
			else
			{
				GetButton(BTN_BACK_MERIDIAN).SetEnable(true);
			}
			if (index == listMeridian.length - 1)
			{
				GetButton(BTN_NEXT_MERIDIAN).SetEnable(false);
			}
			else
			{
				GetButton(BTN_NEXT_MERIDIAN).SetEnable(true);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var arrFishSoldier:Array;
			var index:int;
			
			if (buttonID != BTN_ACHIEVEMENT && buttonID != BTN_NEXT_SOLIDER && buttonID != BTN_BACK_SOLIDER)
			{
				GuiMgr.getInstance().guiMeridianAchievement.Hide();
			}
			switch(buttonID)
			{
				case BTN_ACHIEVEMENT:
					if (GuiMgr.getInstance().guiMeridianAchievement.IsVisible)
					{
						GuiMgr.getInstance().guiMeridianAchievement.Hide();
					}
					else
					{
						GuiMgr.getInstance().guiMeridianAchievement.showGUI(curSoldier);
					}
					break;
				case BTN_BACK_MERIDIAN:
					if (listMeridian == null || listMeridian.length == 0)
					{
						return;
					}
					index = listMeridian.indexOf(labelMeridianName.text);
					index --;
					labelMeridianName.text = listMeridian[index];
					updateNextBackMeridian();
					
					if (index+1 < curSoldier.meridianRank)
					{
						updateMeridian(index + 1, MAX_MERIDIAN_POINT);
					}
					else
					{
						updateMeridian(index + 1, curSoldier.meridianPosition);
					}
					break;
				case BTN_NEXT_MERIDIAN:
					if (listMeridian == null || listMeridian.length == 0)
					{
						return;
					}
					index = listMeridian.indexOf(labelMeridianName.text);
					index ++;
					labelMeridianName.text = listMeridian[index];
					updateNextBackMeridian();
					if (index+1 < curSoldier.meridianRank)
					{
						updateMeridian(index + 1, MAX_MERIDIAN_POINT);
					}
					else
					{
						updateMeridian(index + 1, curSoldier.meridianPosition);
					}
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_NEXT_SOLIDER:
					if(!GameLogic.getInstance().user.IsViewer())
					{
						arrFishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
					}
					else
					{
						arrFishSoldier = GameLogic.getInstance().user.FishSoldierAllArr;
					}
					var indexNext:int = arrFishSoldier.indexOf(curSoldier);
					if (indexNext == arrFishSoldier.length - 1)
					{
						indexNext = 0;
					}
					else
					{
						indexNext ++;
					}
					curSoldier = arrFishSoldier[indexNext];
					showSoldier(curSoldier);
					if (GuiMgr.getInstance().guiMeridianAchievement.IsVisible)
					{
						GuiMgr.getInstance().guiMeridianAchievement.Hide();
						GuiMgr.getInstance().guiMeridianAchievement.showGUI(curSoldier);
						
					}
					break;
				case BTN_BACK_SOLIDER:
					if(!GameLogic.getInstance().user.IsViewer())
					{
						arrFishSoldier = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
					}
					else
					{
						arrFishSoldier = GameLogic.getInstance().user.FishSoldierAllArr;
					}
					var indexBack:int = arrFishSoldier.indexOf(curSoldier);
					if (indexBack == 0)
					{
						indexBack = arrFishSoldier.length -1;
					}
					else
					{
						indexBack --;
					}
					curSoldier = arrFishSoldier[indexBack];
					showSoldier(curSoldier);
					if (GuiMgr.getInstance().guiMeridianAchievement.IsVisible)
					{
						GuiMgr.getInstance().guiMeridianAchievement.Hide();
						GuiMgr.getInstance().guiMeridianAchievement.showGUI(curSoldier);
						
					}
					break;
				default:
					if (buttonID.search(POINT_MERIDIAN) >= 0 && !GameLogic.getInstance().user.IsViewer())
					{
						var i:int = buttonID.split("_")[1];
						if (i == curSoldier.meridianPosition)
						{
							//Kiem tra dieu kien da thong
							var config:Object = ConfigJSON.getInstance().GetItemList("MeridianPointRequire");
							var txtFormat:TextFormat = new TextFormat("arial", 13, 0xff0000, true);
							txtFormat.align = "center";
							if (config[curSoldier.meridianRank][curSoldier.meridianPosition + 1] > curSoldier.meridianPoint)
							{
								EffectMgr.getInstance().textFly("Không đủ điểm ngư mạch!", new Point(event.stageX, event.stageY), txtFormat);
								break;
							}
							if(curSoldier.Rank < curSoldier.meridianRank)
							{
								EffectMgr.getInstance().textFly("Bạn phải lên cấp cá lính đã!", new Point(event.stageX, event.stageY), txtFormat);
								break;
							}
							if ( curSoldier.meridianRank == MAX_RANK && curSoldier.meridianPosition == 9)
							{
								EffectMgr.getInstance().textFly("Sắp ra mắt mạch tiếp theo!", new Point(event.stageX, event.stageY), txtFormat);
								break;
							}
							if (isEffecting)
							{
								break;
							}
							//Gửi gói tin
							isEffecting = true;
							Exchange.GetInstance().Send(new SendUpgradeMeridian(curSoldier.LakeId, curSoldier.Id));
								
							//Cập nhật cho cá
							curSoldier.meridianPoint = meridianPoint - config[curSoldier.meridianRank][curSoldier.meridianPosition + 1];
							meridianPoint = curSoldier.meridianPoint;
							var point:Point = new Point(labelMeridianPoint.x + labelMeridianPoint.width + 50, 16 + labelMeridianPoint.y + labelMeridianPoint.height);
							point = img.localToGlobal(point);
							EffectMgr.getInstance().textFly("- " + Ultility.StandardNumber(int(config[curSoldier.meridianRank][curSoldier.meridianPosition + 1])), point, new TextFormat("arial", 15, 0xffffff, true));
							config = ConfigJSON.getInstance().GetItemList("ActiveMeridian");
							config = config[curSoldier.Element][curSoldier.meridianRank][curSoldier.meridianPosition + 1];
							for (var s:String in config)
							{
								curSoldier["meridian" + s] += config[s];
								trace(s, config[s]);
								//EffectMgr.getInstance().textFly("+" + config[s] + " " + Localization.getInstance().getString(s), new Point(400 + 213 - 52, 220));
							}
							
							//Cap nhat ngu mach
							var lastPosition:int = curSoldier.meridianPosition;
							if (curSoldier.meridianPosition < 9)
							{
								curSoldier.meridianPosition ++;
							}
							else
							{
								curSoldier.meridianRank++;
								curSoldier.meridianPosition = 0;
							}
							
							//Cap nhat ca ngoai ho
							var arrSoldier:Array = GameLogic.getInstance().user.FishSoldierArr;
							for each(var soldier:FishSoldier in arrSoldier)
							{
								if (soldier.Id == curSoldier.Id)
								{
									soldier.meridianCritical = curSoldier.meridianCritical;
									soldier.meridianDamage = curSoldier.meridianDamage;
									soldier.meridianDefence = curSoldier.meridianDefence;
									soldier.meridianVitality = curSoldier.meridianVitality;
									
									soldier.meridianPoint = curSoldier.meridianPoint;
									soldier.meridianPosition = curSoldier.meridianPosition;
									soldier.meridianRank = curSoldier.meridianRank;
									soldier.RefreshImg();
									//trace("damage", soldier.Damage);
									//trace("vital", soldier.Vitality);
									//trace("critical", soldier.Critical);
									//trace("defence", soldier.Defence);
									break;
								}
							}
							
							//Effect
							GetButton(BTN_CLOSE).SetEnable(false);
							var meridianPosition:Point = ctnMeridian.GetContainer(POINT_MERIDIAN + "_" + lastPosition).CurPos;
							meridianPosition = ctnMeridian.img.localToGlobal(meridianPosition);
							EffectMgr.getInstance().AddSwfEffect(Constant.TopLayer, "GuiMeridian_EffectMeridian", null, meridianPosition.x, meridianPosition.y, false, false, null, function f():void
							{
								if (IsVisible)
								{
									if (curSoldier.meridianPosition == 0)
									{
										showSoldier(curSoldier);
									}
									else
									{
										updateMeridian(curSoldier.meridianRank, curSoldier.meridianPosition);
									}
								}
							});
							var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
							var p:Point = new Point(layer.x, layer.y);
							TweenMax.to(layer, 0.5, { bezierThrough:[ { x:p.x, y:p.y -30 }, { x:p.x, y:p.y +30 }, { x:p.x, y:p.y -30 }, { x:p.x, y:p.y } ], ease:Expo.easeIn } );
							p = new Point(img.x, img.y);
							TweenMax.to(this.img, 0.5, { bezierThrough:[ { x:p.x, y:p.y -30 }, { x:p.x, y:p.y +30 }, { x:p.x, y:p.y -30 }, { x:p.x, y:p.y } ], ease:Expo.easeIn, onComplete:completeVibration });
							
							function completeVibration():void
							{
								for (s in config)
								{
									switch(s)
									{
										case "Damage":
											p = new Point(labelDamage.x + labelDamage.width/2, labelDamage.y + labelDamage.height/2);
											break;
										case "Vitality":
											p = new Point(labelVitality.x + labelVitality.width/2, labelVitality.y + labelVitality.height/2);
											break;
										case "Critical":
											p = new Point(labelCritical.x + labelCritical.width/2, labelCritical.y + labelCritical.height/2);
											break;
										case "Defence":
											p = new Point(labelDefence.x + labelDefence.width/2, labelDefence.y + labelCritical.height/2);
											break;
									}
									p = img.localToGlobal(p);
									particalStar(meridianPosition, p, new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), function f(obj:Object):void
									{
										if (IsVisible)
										{
											GetButton(BTN_CLOSE).SetEnable(true);
											isEffecting = false;
											var reputation:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
											var configReputation:Object = ConfigJSON.getInstance().GetItemList("ReputationBuff");
											var reputationVitality:Number = 0;
											var reputationDamage:Number = 0;
											var reputationDefence:Number = 0;
											var reputationCritical:Number = 0;
											if(configReputation[reputation] != null)
											{
												reputationVitality = configReputation[reputation]["Vitality"];
												reputationDamage = configReputation[reputation]["Damage"];
												reputationDefence = configReputation[reputation]["Defence"];
												reputationCritical = configReputation[reputation]["Critical"];
											}
											newDamage = curSoldier.Damage + curSoldier.bonusEquipment.Damage + curSoldier.meridianDamage + reputationDamage;
											newDefence = curSoldier.Defence + curSoldier.bonusEquipment.Defence + curSoldier.meridianDefence + reputationDefence;
											newCritical = curSoldier.Critical + curSoldier.bonusEquipment.Critical + curSoldier.meridianCritical + reputationCritical;
											newVitality = curSoldier.Vitality + curSoldier.bonusEquipment.Vitality + curSoldier.meridianVitality + reputationVitality;
											deltaDamage = (newDamage-damage) / 50;
											if (deltaDamage < 1)
											{
												deltaDamage = 1;
											}
											deltaDefence = (newDefence-defence) / 50;
											if (deltaDefence < 1)
											{
												deltaDefence = 1;
											}
											deltaCritical = (newCritical - critical) / 50;
											if (deltaCritical < 1)
											{
												deltaCritical = 1;
											}
											deltaVitality = (newVitality - vitality) / 50;
											if (deltaVitality < 1)
											{
												deltaVitality = 1;
											}
											EffectMgr.getInstance().textFly("+" + config[obj["name"]] + " " + Localization.getInstance().getString(obj["name"]), obj["position"]);
										}
									}, {"name":s, "position":p});
								}
							}
						}
					}
			}
		}
		
		/**
		 * Dung cho design click để config vị trí dây chằng
		 * @param	event
		 */
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if(!forConfig)
			{
				return;
			}
			if (i == 0)
			{
				configPoint[curSoldier.Element] = new Array();
				trace("Bat dau luu mach con", curSoldier.Element);
			}
			var p:Point = new Point(event.stageX, event.stageY);
			p = ctnMeridian.img.globalToLocal(p);
			trace(p.x, p.y);
			configPoint[curSoldier.Element].push(p);
			i++;
			if (i == 10)
			{
				showSoldier(curSoldier);
				i = 0;
			}
		}
		
		public function showGUI(soldier:FishSoldier = null):void
		{
			curSoldier = soldier;
			Show(Constant.GUI_MIN_LAYER, 6);
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
					ChangeEquipment(curSoldierImg, eq);
				}
			}
			
			var txtField:TextField = new TextField();
			if(curSoldier.nameSoldier != null)
			{
				txtField.text = curSoldier.nameSoldier;
			}
			var txtFormat:TextFormat = new TextFormat("arial", 16, 0xffff00, true);
			txtFormat.align = "center";
			txtField.setTextFormat(txtFormat);
			txtField.y = -62;
			txtField.x = -35;
			txtField.selectable = false;
			txtField.autoSize = "center";
			curSoldierImg.img.addChild(txtField);
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, equip:FishEquipment):void
		{
			var Type:String = equip.Type;
			var resName:String = equip.imageName;
			var color:int = equip.Color;
			
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
					try
					{
						var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
						dob.name = Type;
						child.parent.removeChild(child);
						FishSoldier.EquipmentEffect(dob, color);
					}
					catch (e:*)
					{
						
					}
				}
				eq.loadRes(resName);
			}
		}
		
		public function get meridianPoint():int 
		{
			return _meridianPoint;
		}
		
		public function set meridianPoint(value:int):void 
		{
			_meridianPoint = value;
			labelMeridianPoint.text = Ultility.StandardNumber(value);
		}
		
		public function get damage():int 
		{
			return _damage;
		}
		
		public function set damage(value:int):void 
		{
			_damage = value;
			if(labelDamage != null)
			labelDamage.text = Ultility.StandardNumber(value);
		}
		
		public function get defence():int 
		{
			return _defence;
		}
		
		public function set defence(value:int):void 
		{
			_defence = value;
			if(labelDefence != null)
			labelDefence.text = Ultility.StandardNumber(value);
		}
		
		public function get critical():int 
		{
			return _critical;
		}
		
		public function set critical(value:int):void 
		{
			_critical = value;
			if(labelCritical != null)
			labelCritical.text = Ultility.StandardNumber(value);
		}
		
		public function get vitality():int 
		{
			return _vitality;
		}
		
		public function set vitality(value:int):void 
		{
			_vitality = value;
			if(labelVitality != null)
			labelVitality.text = Ultility.StandardNumber(value);
		}
		
		override public function UpdateObject():void 
		{
			if (newDamage > damage)
			{
				damage += deltaDamage;
			}
			else if(newDamage < damage)
			{
				damage = newDamage;
			}
			
			if (newCritical > critical)
			{
				critical += deltaCritical;
			}
			else if(newCritical < critical)
			{
				critical = newCritical;
			}
			
			if (newVitality > vitality)
			{
				vitality += deltaVitality;
			}
			else if(newVitality < vitality)
			{
				vitality = newVitality;
			}
			
			if (newDefence > defence)
			{
				defence += deltaDefence;
			}
			else if(newDefence < defence)
			{
				defence = newDefence;
			}
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				}
			}			
		}
		
		override public function OnHideGUI():void 
		{
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].destroy();
				emitStar.splice(i, 1);
				i--;	
			}		
			
			//tắt đi thì mới bật phần nhận thưởng quest
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
			if (GuiMgr.getInstance().GuiTrainingTower.IsVisible)
			{
				GuiMgr.getInstance().GuiTrainingTower.updateMeridianForCurrentSoldier();
			}
		}
		
		/**
		 * Hàm tạo effect 1 chùm sao bay theo đường cong từ điểm này tới điểm kia
		 * @param	fromPoint : điểm bắt đầu
		 * @param	toPoint : điểm kết thúc
		 * @param	colorTransform : transform màu cho sao
		 * @param	isReverse : có bay ngược từ toPoint đến fromPoint hay không, mặc định là không
		 * @param	completeFunction : hàm thưc hiện khi xong effect
		 * @param	params : tham số cho hàm completeFunction
		 * @param	mid : chọn điểm giữa, 0 là random, 1 là hướng vòng lên, -1 là hướng vòng xuống, 2 là bay thẳng
		 * @param	spawnCount : số sao bay
		 */
		private function particalStar(fromPoint:Point, toPoint:Point, colorTransform:ColorTransform, completeFunction:Function = null, params:Object = null, time:Number = 0.5, isReverse:Boolean = false, mid:int = 0, spawnCount:int = 7):void
		{
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			emit.spawnCount = spawnCount;
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = colorTransform;
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (isReverse)
			{
				var temp:Point = toPoint.clone();
				toPoint = fromPoint.clone();
				fromPoint = temp;
			}
			
			var midPoint:Point = midPoint = getThroughPoint(fromPoint, toPoint, mid);
			
			if (emit)
			{
				img.addChild(emit.sp);
				emit.sp.x = fromPoint.x;
				emit.sp.y = fromPoint.y;
				if(mid != 2)
				{
					emit.velTolerance = new Point(1.5, 1.5);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:midPoint.x, y:midPoint.y }, { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction,params]} );					
				}
				else
				{
					emit.velTolerance = new Point(1.2, 1.2);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction, params] } );					
				}
			}
			
			function onCompleteTween():void
			{
				if (IsVisible)
				{
					if (emit)
					{
						emit.stopSpawn();
					}
					img.removeChild(emit.sp);	
				}
				if(completeFunction != null)
				{
					completeFunction(params);
				}
			}
		}
		
				/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point, mid:int = 0):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if(mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
	}

}