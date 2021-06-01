  # Test plan
  ## Integration test
  * Module **Image** should call module **MCU**
  * Module **MCU** should call **DCT**, **Quantisation**, **Run length**, and **Huffman encoding** modules
  
  ## Individual test
  * Module **DCT** should return forward DCT transformed matrix after 71 clock cycles
  * Module **Quantisation** should calculate the quantised matrix parallelly with **DCT** module and should provide output at cycle-72
  
  # Test output results
  | Module | Integration tests |
  | ------ | ----------------- |
  | `MCU`  | Passing           |


| Module | Individual tests |
  | ------ | ---------------- |
  | `DCT`  | Passing          |
  | `Quantisation`| Passing   |
  | `Run length`  | Passing   |
  | `Huffman encoding`| Passing |
  