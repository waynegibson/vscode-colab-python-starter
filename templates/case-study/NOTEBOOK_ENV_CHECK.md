Add these as the first notebook cells.

Cell 1: Colab-only install bootstrap

- If running in Colab, install requirements.
- If local kernel, skip install.

Python snippet:
import os
IN_COLAB = "COLAB_GPU" in os.environ or "google.colab" in str(get_ipython())
if IN_COLAB:
%pip install -r requirements.txt

Cell 2: Environment check (run after every kernel switch)
Python snippet:
import platform, sys
import numpy, pandas, sklearn

print("python:", platform.python_version())
print("executable:", sys.executable)
print("numpy:", numpy.**version**)
print("pandas:", pandas.**version**)
print("sklearn:", sklearn.**version**)
