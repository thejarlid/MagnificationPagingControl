# MagnificationPagingControl
Custom paging control based off what is seen in the Moleskine Timepage app, this was developed based off what I could see so the effect is not exact, but it is the desired control effect I need for my upcoming app

This control can be used for many cases, but it was built as an attempt at a new form of navigation between screens

## Usage

The control is very simple to use and is modeled after the UIPagingControl. Each individual dot can be assigned a colour using a delegate method and notification of user events within the control will be sent to the delegate of the control.
Create the control in Storyboard by dragging a UIView and changing the class or creating it in code as follows: 

```Swift
  let startWidth = self.view.frame.width*0.1
  let startHeight = self.view.frame.height*0.1
  let pagingControl = MagnificationPagingControl(frame: CGRect(x: self.view.frame.width - startWidth,
                                                           y: self.view.frame.height/2 - startHeight/2,
                                                           width: startWidth, height: startHeight), numberOfDots:4)
  pagingControl.delegate = self
  pagingControl.setCurrentIndex(index: 0)
```

## Demo 

<img src='https://i.imgur.com/fvFUWCF.gif' title='Demo' width='' alt='Demo' />

## Notes

Let me know of any issues or improvements that can be made on the control

## License

    MIT License

    Copyright (c) 2017 Dilraj Devgun

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

