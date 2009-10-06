#!/usr/bin/python

import wx


class MyFrame(wx.Frame):
  def __init__(self, parent, id, title, initial):
    size = 40 + 10 
    wx.Frame.__init__(self, parent, id, title, (-1, -1), wx.Size(size*8 + 5, size*8 + 5))
    panel = wx.Panel(self, -1)
    vert = wx.BoxSizer(wx.VERTICAL)
    imageEmpty = 'empty-circle.png'
    imageRed = 'red-circle.png'
    imageGreen = 'green-circle.png'
    imageOrange = 'orange-circle.png'
    self.states = initial[:]
    self.startId = 100
    self.imageEmpty = wx.Image(imageEmpty, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
    self.imageRed = wx.Image(imageRed, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
    self.imageGreen = wx.Image(imageGreen, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
    self.imageOrange = wx.Image(imageOrange, wx.BITMAP_TYPE_ANY).ConvertToBitmap()
    self.imageToState = {
      ' ' : self.imageEmpty,
      'R' : self.imageRed,
      'G' : self.imageGreen,
      'O' : self.imageOrange,
    }
    for row in range(8):
      horz = wx.BoxSizer(wx.HORIZONTAL)
      for col in range(8):
        buttonId = self.startId + row * 8 + col
        off = 10 
        state = self.states[row * 8 + col]
        button = wx.BitmapButton(panel, id=buttonId, bitmap=self.imageToState[state],
          size=(self.imageEmpty.GetWidth() + off, self.imageEmpty.GetHeight() + off),
          style=wx.BU_EXACTFIT)
        horz.Add(button, 1)
        button.Bind(wx.EVT_BUTTON, self.buttonClick)
      vert.Add(horz)

    panel.SetSizer(vert)
    self.Center()
    self.Bind(wx.EVT_CLOSE, self.onClose)

  def buttonClick(self, event):
    curId = event.GetId() - self.startId
    state = self.states[curId]
    stateTransition = { ' ':'R', 'R':'G', 'G':'O', 'O':' ' }
    state = stateTransition[state]
    self.states[curId] = state
    event.GetEventObject().SetBitmapLabel(self.imageToState[state])

  def onClose(self, evt):
    lines = []
    for row in range(8):
      line = []
      for col in range(8):
        line.append(self.states[row * 8 + col])
      lines.append(''.join(line))
   
    for line in lines:
      print '    "%s",' % line
    self.Destroy()

class MyApp(wx.App):
  def OnInit(self):
    import sys
    if len(sys.argv) > 1 and sys.argv[1] == '-i':
      initial = sys.stdin.read()
      initial = initial.replace('\n', '').replace('\r', '')
      initial = list(initial)
    else:
      initial = [' ' for i in range(8*8)]
    frame = MyFrame(None, -1, 'LED Grid', initial)
    frame.Show(True)
    return True

if __name__ == '__main__':
  app = MyApp(0)
  app.MainLoop()

