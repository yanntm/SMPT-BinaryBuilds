# SMPT-BinaryBuilds

A repository hosting GitHub Actions CI to rebuild SMPT binaries and dependencies from source.

The goal of this repository is to package as binaries :
* SMPT https://github.com/nicolasAmat/SMPT The model-checker itself, which is python with a lot of dependencies. Fortunately cx_freeze can build a portable binary + dependent libraries. Note that the tool is normally distributed as a pip install package; this project uses a hacked build.py to construct a dependency less binary for linux x64.
* 4ti2 https://github.com/4ti2/4ti2 This is a dependency of SMPT through its dependency 'struct' from the Tina package https://projects.laas.fr/tina/index.php In practice, Tina invokes many variants of `qsolve` and `zsolve`. We built a statically linked binary (for better portability) of required parts of `4ti2` only.

The result of this repository is the "linux" branch https://github.com/yanntm/SMPT-BinaryBuilds/tree/linux that contains the actual artefacts built using Github actions (which we thank for providing hosting, bandwidth and build time as well as high auditability and reproducibility).

Both of these binaries should end up on the path, related MCC-Driver for SMPT https://github.com/yanntm/MCC-drivers/tree/master/smpt contains a full install script to install the rest of the dependencies.

The point is that we'd like to avoid having to install build dependencies on a machine where we simply want to run the tool.
This build is also configured to e.g. respect the "westmere cpu" constraint of the MCC and tries to build portable binaries that will run anywhere.

This repository is provided in the hope it may prove useful with GPL v3 license.

Originally built in April 2023 by Yann Thierry-Mieg, LIP6, CNRS & Sorbonne Université.

Last built Feb 2026.


