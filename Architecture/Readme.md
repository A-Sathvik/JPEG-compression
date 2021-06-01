## Description
The image of MxN dimension is split into non-overlapping 8x8 pixel blocks (also known as Minimal Coded Unit). 
2D-DCT is applied on each MCU.
The outcome of the DCT is quantised to reduce the file size, this step is the only lossy aspect.
Later, lossless encoding schemes are employed.
* Run length encoding shortens the data if elements are repetitive and consecutive.
* Huffman encoding enhances the compression by assigning smaller codes for frequent elements.

## Behaviour diagram 

![](https://github.com/A-Sathvik/LTTS_Mini_project/blob/main/Architecture/Structure%20diagram%20high%20level.png)

## System diagram
### High level system diagram
![](https://github.com/A-Sathvik/LTTS_Mini_project/blob/main/Architecture/D4.png)

### Low level system diagram
![](https://github.com/A-Sathvik/LTTS_Mini_project/blob/main/Architecture/Behaviour%20Low%20level%20diagram.png)
