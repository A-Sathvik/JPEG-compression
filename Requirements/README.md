# Requirements

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
