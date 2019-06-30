 
Inteference Signal Classification using Neural Network in Matlab  
Jun, 2019  
Jet Yu, ECE, Virginia Tech  
jianyuan@vt.edu  


# Slides
[performance Google slides](https://docs.google.com/presentation/d/1POVndvXnNvz2-mwR2zpuVd6MISutlEGou-EAwx-jbyw/edit?usp=sharing)

# News
(June 30) copyCat pass,    
(June 28) using downsample could reduce computation,    
(June 27) using FFT could reach accuracy 94%.  

# Roadmap
* get dataset from USRP


# Config
Matlab Machine Learning Toolbox  & GPU 


# Generate interfer type  
* awgn  
* awgn+tone  
* awgn+chirp  
* awgn+filtN(filtered noise, low-passed white noise) 
* copyCat Noise, with unknown modulation and pulse shaping scheme.   

# How to run
execute `main.m` file.

# Running Time
for default datasize of 16,000, data generation cost ~ 1min, and training takes ~8min.

# Bibliography
[Bibliography](./bib.md)
