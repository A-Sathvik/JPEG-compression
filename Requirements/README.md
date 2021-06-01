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

