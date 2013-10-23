package 
{
	import assets.TileAsset;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	
	public class UVGen extends Sprite 
	{
		public function UVGen() 
		{
			makeImage(512,128,"UVTestPattern_512_128");
			makeImage(512,64,"UVTestPattern_512_64");
			makeImage(512,32,"UVTestPattern_512_32");
			makeImage(1024,128,"UVTestPattern_1024_128");
			makeImage(1024,64,"UVTestPattern_1024_64");
			makeImage(1024,32,"UVTestPattern_1024_32");
			makeImage(2048,128,"UVTestPattern_2048_128");
			makeImage(2048,64,"UVTestPattern_2048_64");
			makeImage(2048,32,"UVTestPattern_2048_32");
		}
		
		private function makeImage(size:int, tileSize:int, fileName:String)
		{
				
			var tile:TileAsset = new TileAsset();
			
			var cols:int = Math.floor(size/tileSize);
			var rows:int = cols;
			
			var tileScale:Number = tileSize/128;
			
			var bmd:BitmapData = new BitmapData(size,size,true,0x00000000);
			var matrix:Matrix = new Matrix();
			
			for(var r:int = 0; r<rows; r++)
			{
				for(var c:int = 0; c<cols; c++)
				{
					tile.textFieldA.text = r.toString();
					var char:int = c;
					tile.textFieldB.text = "";
					
					//DO A B C .. X Y Z AA BB CC etc.
					//Yes you could fit much more with a pattern like AA AB AC, 
					//but I find that this pattern easier to read at a glance
					while(char >= 0)
					{
						char -= 26;
						tile.textFieldB.appendText("ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(c%26));
					}
					
					tile.textFieldA.textColor = 0x0000FF;
					tile.textFieldB.textColor = 0xFF0000;
					matrix.createBox(tileScale,tileScale,0,c*tileSize,r*tileSize);
					
					var cp:Number = c/(cols-1);
					var rp:Number = r/(rows-1);
					var isGreenOn:Boolean = ((c+(r%2)) % 2) == 0;
					var green:Number = isGreenOn ? 0.66 : 1.0;
					
					var ct:ColorTransform = new ColorTransform(cp,green,rp,1);
					bmd.draw(tile,matrix,ct,null,null,true);
				}
			}
			
			//uncomment these lines to show it on screen if you want
			//var bitmap:Bitmap = new Bitmap(bmd);
			//addChild(bitmap);
			
			var pngBytes:ByteArray = PNGEncoder.encode(bmd);
			var outFile:File = File.applicationDirectory;
			outFile = outFile.resolvePath(fileName+".png");
			outFile = new File(outFile.nativePath);
			
			trace("Writing " + outFile.nativePath);
			
			var outStream:FileStream = new FileStream();
			
			outStream.open(outFile,FileMode.WRITE);
			outStream.writeBytes(pngBytes,0,pngBytes.length);
			outStream.close();
		}
	}
	
		
	
}



