# System Development Life Cycle of Image Compression algorithm
## Phases
### Planning:
* Defining the scope of the system
> To compress a captured image on an FPGA.
* Feasibility study
* Estimate costs
> A ZedBoard Zynq-7000 ARM/FPGA SoC Development Board (449$)

### Analysis:
* Locating existing deficiencies
> Dicrete Cosine Transform (DCT) is challenging to implement in verilog
* Alternatives
> Vectorising DCT formula
* Define the requirements
> Compression ratio and image quality should be balanced.

### Design:
* Structuring the algorithm to be followed
> Number of modules, their functions, inputs and outputs
* Reviewing the design

### Implementation:
* Necessary modules are developed with appropriate testbenches

### Testing:
* Images under various light conditions are compressed, reconstructed and verified