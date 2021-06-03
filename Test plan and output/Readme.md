  # Test plan
  ## Integration test
  * Module **tb** should call module **DCT_2D**.
  * Module **DCT_2D** however performs discrete cosine transform, quantisation, arranges elements in zigzag pattern, and implements Run-length encoding.
  * Module **DCT_2D** should call **Huffman_encoding** module.
  * An [example](https://www.projectrhea.org/rhea/index.php/Homework3ECE438JPEG) is considered, its compressed output is verfied against the output of `tb` module.
  
  ## Individual test
  * Module **DCT** should return forward DCT transformed matrix after 71 clock cycles
  * Module **Quantisation** should calculate the quantised matrix parallelly with **DCT** module and should provide output at cycle-72
  
  # Test output results
  | Module | Integration tests | Result |
  | ------ | ----------------- | ------ |
  | `MCU`  | Passing           | Matching |


| Steps | Individual tests |
  | ------ | ---------------- |
  | `DCT`  | Passing          |
  | `Quantisation`| Passing   |
  | `Run length`  | Passing   |
  | `Huffman encoding`| Passing |
  
The following image is compressed with quality factor 50 (this factor may not affect the file size directly)
File size: 108 KB
![](https://github.com/A-Sathvik/JPEG-compression/blob/6baf6f3900bad3028c1a21d4dd0cd23b20f80235/Test%20plan%20and%20output/Actual%20image.jpg)
Reconstructed image, file size: 93.4 KB
![](https://github.com/A-Sathvik/JPEG-compression/blob/6baf6f3900bad3028c1a21d4dd0cd23b20f80235/Test%20plan%20and%20output/Compressed%20image.jpg)
