### Setting up Cairo 0.10
1. Make sure you have Anaconda installed.
2. Spin up a environment with Python 3.9 e.g. `conda create --name py39 python=3.9`
3. Hop into the environment e.g. `conda activate py39`
4. Install Cairo 0.10.0 by following the official instructions at https://www.cairo-lang.org/docs/quickstart.html

### 2. Examine the contract
1. Study `sine.cairo` for how to create storage, create getter and setter for storage, function with single felt as return type (`-> felt`) which allows for function chaining etc.
2. Study Cairo 0.10 syntax changes at https://github.com/starkware-libs/cairo-lang/releases

### 3. Run the test
1. Examine `test.py`
2. Run `pytest -s test.py` to see results.

### 4. Modify the test
Try feeding different radiant values as input argument to test the behavior of `sine_7th()`.
