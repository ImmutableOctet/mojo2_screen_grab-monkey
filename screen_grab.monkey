Strict

Public

' Imports:
Import mojo2

Import brl.databuffer

' Classes:
Class Application Extends App
	' Methods:
	Method OnCreate:Int()
		SetUpdateRate(0) ' 60 ' 30
		
		graphics = New Canvas(Null)
		
		screenCapture = New Image(DeviceWidth(), DeviceHeight())
		
		redraw = False
		
		Return 0
	End
	
	Method OnUpdate:Int()
		If (KeyHit(KEY_SPACE) Or KeyDown(KEY_A)) Then
			redraw = True
		Endif
		
		Return 0
	End
	
	Method OnRender:Int()
		Const RW:= 64.0
		Const RH:= 64.0
		
		If (Not redraw) Then
			graphics.Clear(0.0, 0.0, 0.0)
			
			graphics.DrawImage(screenCapture, DeviceWidth()/2, DeviceHeight()/2, 0.0, 1.0, 1.0)
		Else
			Local lastSeed:= Seed
			
			Seed = Millisecs()
			
			graphics.Clear(0.8 * Rnd(0.0, 1.0), 0.53 * Rnd(0.0, 1.0), 0.88 * Rnd(0.0, 1.0))
			
			For Local Y:= 0 Until (DeviceHeight() / RH)
				For Local X:= 0 Until (DeviceWidth() / RW)
					graphics.SetColor(Rnd(0.0, 1.0), Sin(X*Y), Cos(Y+(X*RH))*Rnd(0.0, 1.0))
					
					graphics.DrawRect(X*RW, Y*RH, RW, RH)
				Next
			Next
			
			graphics.SetAlpha(Rnd(0.0, 1.25) * 0.75)
			
			graphics.DrawImage(screenCapture, DeviceWidth()/2, DeviceHeight()/2, 0.0, Rnd(0.25, 2.0), Rnd(0.25, 2.0))
			
			graphics.SetAlpha(1.0)
			
			Local pixelData:= New DataBuffer(screenCapture.Width*screenCapture.Height*4)
			
			graphics.ReadPixels(0, 0, screenCapture.Width, screenCapture.Height, pixelData)
			
			screenCapture.WritePixels(0, 0, screenCapture.Width, screenCapture.Height, pixelData)
			
			Seed = lastSeed
			
			redraw = False
		Endif
		
		graphics.DrawText("Press SPACE to go crazy, hold A to go further.", 8.0, 8.0)
		
		graphics.Flush()
		
		Return 0
	End
	
	' Fields:
	Field screenCapture:Image
	Field graphics:Canvas
	
	Field redraw:Bool
End

' Functions:
Function Main:Int()
	New Application()
	
	Return 0
End