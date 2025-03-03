ICSNPP-ROCPLUS
Industrial Control Systems Network Protocol Parsers (ICSNPP) - Emerson ROCPlus

Overview
ICSNPP-ROCPlus is a Spicy based Zeek plugin for parsing and logging fields within the ROCPlus protocol.

ROCPlus is a protocol created by Emerson for communication between Emerson devices in industrial automation systems. It is widely used in industrial applications such as oil and gas operations.

This parser targets the ROCPlus commands specified in the publicly available 2022 version of the spec.

Installation
Package Manager
This script is available as a package for Zeek Package Manager. It requires Spicy and the Zeek Spicy plugin.

$ zkg refresh
$ zkg install icsnpp-rocplus
If this package is installed from ZKG, it will be added to the available plugins. This can be tested by running zeek -NN. If installed correctly, users will see ANALYZER_SPICY_ROC_PLUS under the list of Zeek::Spicy analyzers.

If users have ZKG configured to load packages (see @load packages in the( ZKG Quickstart Guide), this plugin and these scripts will automatically be loaded and ready to go.)

If users are compiling the code manually, use clang as the compiler by compiling zeek with clang. Installing the package with zkg is not impacted.


TODO:

Fill out additional details
