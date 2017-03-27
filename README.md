## Crubus

**Crubus** is a **CRU**de **BU**ild **S**ystem for PHP projects.

This is a bash script `build.sh` providing a very crude but usable framework for producing a single PHP from from a PHP project. Future releases will include a simple documentation generation and test building features.

Crubus searches all PHP files in a source directory for `require_once` and `include_once` statements, extracts the file names and concatenates all of those files together to produce a single PHP file.


## Why should I care?

Don't know. Maybe you just like delivering your PHP projects in a nice neat single file package.


## How do I install this thing?

Clone the repo to your desktop.

`git clone https://github.com/sh3rmy/crubus.git`

Place the build.sh file into your project root directory.

`cp crubus/build.sh YOUR_PROJECT_ROOT/`

Open build.sh with your favourite editor.

`nano YOUR_PROJECT_ROOT/build.sh`

Set your project details.

```
PROJECT_NAME="Soap"
PROJECT_VERSION="0.1.0"
PROJECT_AUTHOR="Tyler Durden"
PROJECT_EMAIL="tyler@paperstsoapcompany.com"
PROJECT_WEBSITE="https://github.com/tyler/soap"
```

Save and exit then make sure the script is executable.

`chmod +x YOUR_PROJECT_ROOT/build.sh`


## How do I build my project?

#### Setup build environment

Now that your project details are in, you or others can copy/clone your project and then run setup.

`./build.sh -s` or `./build.sh --setup`

This will ask for project root, output and source directories.

Ideally your project root might look like this.

```
- YOUR_PROJECT_ROOT/
  - build.sh
  - output/
  - source/
    -  main.php
    -  etc..
```

In which case you just need to mash the enter key through these prompts.


#### Build your PHP file

To build your PHP file, run build.

`./build.sh -b` or `./build.sh --build`

It will search for PHP files in your source directory, look for any `require_once` or `include_once` statements, extract the file names from those statements and concatenate the contents of those files together (removing the `require_once`/`include_once` first) and producing a single PHP file in the format `PROJECT_NAME-PROJECT_VERSION.php` in the output directory. 

It will remove all empty lines. But will add back empty lines after lines just containing `}`, `<?php` or `*/`.

It will not edit any of the original files, they can be read-only.


#### Clean your project directory

To remove build config and output file, run clean.

`./build.sh -c` or `./build.sh --clean`


#### See available commands

To see the script usage screen, run help.

`./build.sh -h` or `./build.sh --help`


## Still stuck?

If you still having no idea what this does check out the example project in the tests folder.

```
git clone https://github.com/sh3rmy/crubus.git
cd crubus/tests/example
chmod +x build.sh
./build.sh --setup
```

[ENTER] [ENTER] [ENTER]

```
./build.sh --build
php output/example-0.1.0.php
```


## Want to help?

Awesome! To fix a bug or make script better, follow these steps.


#### Contributing

- Clone the repo `git clone https://github.com/sh3rmy/crubus.git && cd crubus`
- Checkout develop branch `git checkout develop`
- Pull from origin `git pull origin develop`
- Create a new branch `git checkout -b improve-feature develop`
- Make the appropriate changes in the script
- Commit your changes `git commit -a -m 'Improve feature'`
- Push to origin `git push origin +improve-feature`
- Create a Pull Request


#### Bug / Feature Request

If you find a bug kindly open an issue [here](https://github.com/sh3rmy/crubus/issues/new) by including details.

Similarly, if you'd like to request a new feature, feel free to do so by opening an issue [here](https://github.com/sh3rmy/crubus/issues/new) including some examples of required output.


## Version history

- 0.1.3: Fixed bug which produced empty deliverable if no require_once or include_once found, even if main.php contained code.
- 0.1.2: Fixed up more errors in README.md.
- 0.1.1: Fixed up some errors in README.md.
- 0.1.0: Initial release.


## License

>You can check out the full license [here](https://github.com/sh3rmy/crubus/blob/master/LICENSE)

This project is licensed under the terms of the **GPLv3** license.

Copyright (C) 2017 Michael David Edwards (sh3rmy).
