[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE.md) [![Haxelib Version](https://img.shields.io/github/tag/openfl/openfl-samples.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/openfl-samples) [![Build Status](https://img.shields.io/circleci/project/github/openfl/openfl-samples/master.svg)](https://circleci.com/gh/openfl/openfl-samples)

OpenFL Samples
==============

_Haxelib-based samples are located here, check out [https://github.com/openfl/openfl-samples-haxe](https://github.com/openfl/openfl-samples-haxe) for NPM-based samples._

A collection of sample projects illustrating different OpenFL features.


Installation
------------

    haxelib install openfl
    haxelib run openfl setup
    
The `openfl-samples` library will be installed automatically. If you need to install it alone, you can use the following command:

    haxelib install openfl-samples


### Listing Samples

You can browse the project directory, but it is generally simpler to use the following command to list available OpenFL samples:

    openfl create


### Creating Samples

Once you find a sample you would like to create, you can generate a copy using the "create" command:

    openfl create PiratePig

This creates a copy in the current directory, but you can also specify an output directory if you prefer:

    openfl create DisplayingABitmap BitmapTest


Development Builds
------------------

Clone the openfl-samples repository:

    git clone https://github.com/openfl/openfl-samples


Tell haxelib where your development copy of openfl-samples is installed:

    haxelib dev openfl-samples openfl-samples


To return to release builds:

    haxelib dev openfl-samples

