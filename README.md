openfl-samples
==============
[![Build Status](https://travis-ci.org/openfl/openfl-samples.png)](https://travis-ci.org/openfl/openfl-samples)

A collection of OpenFL sample projects which are installed using [Lime's](https://github.com/openfl/lime) project functionality.

[Official OpenFL Projects Docs](http://www.openfl.org/documentation/projects/)


Installation
------------

    haxelib install openfl-samples


###Listing Samples

OpenFL includes a number of samples, which you can duplicate to build or to use as a starting point. To list all of the available samples:

    lime create openfl


###Creating Samples

If you find a sample you would like to create, you can create it using the "create" command:

    lime create openfl:PiratePig

This will create a copy of the sample within the current directory, using the same name as the sample. If you prefer, you can also specify a custom target directory:

    lime create openfl:DisplayingABitmap BitmapTest


Development Builds
------------------

Clone the OpenFL repository:

    git clone https://github.com/openfl/openfl-samples


Tell haxelib where your development copy of OpenFL is installed:

    haxelib dev openfl-samples openfl-samples


To return to release builds:

    haxelib dev openfl-samples

