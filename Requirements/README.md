# Requirements

## High level requirements
| ID | Description | Status |
| -- | ----------- | ------ |
| HR_1 | Black and white image | Implemented |
| HR_2 | Colored image | Future |
| HR_3 | Quality factor (Q) | Implemented |
| HR_4 | Brightness quality (Q_B) and Chrominance quality (Q_C) | Future |


## Low level requirements
| ID | Description | HR ID | Status |
| -- | ----------- | ----- | ------ |
| LR_1 | Image with padded pixels | HR_1 | Implemented |
| LR_2 | File containng row-wise pixel information | HR_1 | Implemented |
| LR_3 | Quantisation matrix | HR_3 | Implemented |
| LR_4 | Huffman table | HR_3 | Implemented |
| LR_5 | Brightness, chrominance quantisation matrices | HR_4 | Future |
| LR_6 | Brightness, chrominance Huffman tables | HR_4 | Future |


## Technical
* Understanding the representation of pixel
> RGB (Red, Green, Blue)

> Y,Cb,Cr (Luminance, Chrominance)

* Understanding the details that can be neglected
> Human visual system is less sensitive to high frequency variations
![System-Diagram](https://github.com/A-Sathvik/LTTS_Mini_project/blob/main/Requirements/Frequency%20variation.JPG)

* Finding a transformation to separate the high frequency content
> Discrete Cosine Transform

## SWOT analysis
* Strengths
> Remotely accessed
>
> Cost effective

* Weaknesses
> Image quality factor/compression ratio cannot be altered remotely
> 
> Received compressed output requires software code for image reconstruction

* Opportunities
> FPGA can be attached to aerial vehicles
> 
> Implementation can be extended to video streaming

* Threats
> Compressed image is not encrypted
> 
> Signal can be altered by an eavesdropper

## 4W's and 1'H

### Who:
The setup can remotely capture video/images and transmits the compressed version.

### What:
An FPGA programmed to perform image compression and transmit the same efficiently.

### When:
When a human intervention is not much required to watch a location. When storing a original quality image is not required.

### Where:
Can be deployed in toxic places or in UAVs.

### How:
The algorithm is based on Joint Photographic Experts Group compression, discards high frequency content of the images. 


