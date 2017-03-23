#!/bin/sh
#
# CRUBUS v0.1.2
#
#-----------------------------------------------------------------------------
#
# project config
#
PROJECT_NAME="example"
PROJECT_VERSION="0.1.0"
PROJECT_AUTHOR="John Doe"
PROJECT_EMAIL="john@example.com"
PROJECT_WEBSITE="https://github.com/john/example"
#
#-----------------------------------------------------------------------------
#
# check project config
#
if [ "$PROJECT_NAME" = "" -o "$PROJECT_VERSION" = "" ];
then
    /bin/echo "./build.sh: Invalid build.sh. See project owner for valid build.sh"
    exit
fi
#
#-----------------------------------------------------------------------------
#
# load build config file if exists
#
if [ -f '.crubus' ];
then
    export DIR_ROOT=$(/bin/grep -oP "(?<=DIR_ROOT=).*$" .crubus)
    export DIR_SOURCE=$(/bin/grep -oP "(?<=DIR_SOURCE=).*$" .crubus)
    export DIR_OUTPUT=$(/bin/grep -oP "(?<=DIR_OUTPUT=).*$" .crubus)
    export FILE_OUTPUT=$DIR_OUTPUT/$PROJECT_NAME\-$PROJECT_VERSION.php
    export FILE_MAIN=$DIR_SOURCE/main.php
fi
#
#-----------------------------------------------------------------------------
#
# project header
#
if [ "$2" != "-" ];
then
    if [ "$PROJECT_WEBSITE" = "" ];
    then
        /bin/echo "$PROJECT_NAME $PROJECT_VERSION Build"
    else
        /bin/echo "$PROJECT_NAME $PROJECT_VERSION Build ( $PROJECT_WEBSITE )"
    fi
fi
#
#-----------------------------------------------------------------------------
#
# help command
#
if [ "$1" = "-h" -o "$1" = "--help" ];
then
    /bin/echo ""
    /bin/echo "Usage: ./build.sh COMMAND"
    /bin/echo "Commands:"
    /bin/echo "  -b, --build             Build deliverable."
    /bin/echo "  -c, --clean             Remove build config and deliverable."
    /bin/echo "  -s, --setup             Setup build environment."
    if [ ! "$PROJECT_EMAIL" = "" ];
    then
        /bin/echo ""
        /bin/echo "Report bugs to $PROJECT_EMAIL"
    fi
    exit
fi
#
#-----------------------------------------------------------------------------
#
# build command
#
if [ "$1" = "-b" -o "$1" = "--build" ];
then
    if [ "$DIR_ROOT" = "" ];
    then
        /bin/echo ""
        /bin/echo "./build.sh: No build config. Run './build.sh --setup' to configure build."
        exit
    fi
    if [ ! -d "$DIR_SOURCE" ];
    then
        /bin/echo ""
        /bin/echo "./build.sh: Source directory $DIR_SOURCE not found."
        exit
    fi
    if [ ! -d "$DIR_OUTPUT" ];
    then
        /bin/echo ""
        /bin/echo "Creating output directory.."
        /bin/mkdir $DIR_OUTPUT 2> /dev/null
        if [ "$?" = "0" ];
        then
            /bin/echo "done."
        else
            /bin/echo "failed!"
        fi
    fi
    /bin/touch $FILE_MAIN 2> /dev/null
    /bin/echo ""
    /bin/echo "Building $PROJECT_NAME-$PROJECT_VERSION.php.."
    #
    # cat all php files in source directory together
    #
    /usr/bin/find $DIR_SOURCE -iname "*.php" -exec /bin/cat {} + | \
    #
    # find all php files that are require_once or include_once
    #
    /bin/sed "s/^require_once/include_once/" | \
    /bin/grep -oP "(?<=include_once\(').*(?='\);)" | \
    #
    # remove duplicates and add main.php to top of list
    #
    /usr/bin/sort -u | \
    /bin/sed "1 i main.php" | \
    #
    # remove first 2 lines all files on list and cat together
    #
    /bin/sed 's/^/\/usr\/bin\/tail -n +2 -q "$DIR_SOURCE\//;s/$/";/' | \
    /bin/sh | \
    #
    # remove require_once & include_once lines, and remove empty lines
    #
    /bin/sed "s/^require_once/include_once/;/^include_once.*$/d;/^$/d" | \
    #
    # add <?php to start
    #
    /bin/sed "1 i <?php" | \
    #
    # add empty lines after <?php, after functions and after comment blocks
    #
    /bin/sed "/<?php/G;/}/G;/\*\//G" | \
    #
    # save to output file
    #
    /bin/cat - > $FILE_OUTPUT 2> /dev/null
    #
    # done
    #
    if [ "$?" = "0" ];
    then
        /bin/echo "done."
    else
        /bin/echo "failed!"
    fi
    if [ ! -s "$FILE_MAIN" ];
    then
        /bin/rm $FILE_MAIN 2> /dev/null
    fi
    exit
fi
#
#-----------------------------------------------------------------------------
#
# clean command
#
if [ "$1" = "-c" -o "$1" = "--clean" ];
then
    if [ "$DIR_ROOT" = "" ];
    then
        /bin/echo ""
        /bin/echo "./build.sh: No build config. Run './build.sh --setup' to configure build."
        exit
    fi
    /bin/echo ""
    /bin/echo "Removing $PROJECT_NAME-$PROJECT_VERSION.php.."
    if [ -f $FILE_OUTPUT ];
    then
        /bin/rm $FILE_OUTPUT
        if [ "$?" = "0" ];
        then
            /bin/echo "done."
        else
            /bin/echo "failed!"
        fi
    else
        /bin/echo "failed!"
    fi
    /bin/echo ""
    /bin/echo "Removing build config.."
    if [ -f ".crubus" ];
    then
        /bin/rm '.crubus'
        if [ "$?" = "0" ];
        then
            /bin/echo "done."
        else
            /bin/echo "failed!"
        fi
    else
        /bin/echo "failed!"
    fi
    exit
fi
#
#-----------------------------------------------------------------------------
#
# setup command
#
if [ "$1" = "-s" -o "$1" = "--setup" ];
then
    if [ -f ".crubus" ];
    then
        /bin/rm ".crubus"
    fi
    /bin/echo ""
    /bin/echo "Enter $PROJECT_NAME root directory"
    read -p "[$PWD] " READ_DIR_ROOT
    export DIR_ROOT=$(/usr/bin/realpath ${READ_DIR_ROOT:-$PWD} 2> /dev/null)
    /bin/echo ""
    /bin/echo "Enter $PROJECT_NAME output directory"
    read -p "[$DIR_ROOT/output] " READ_DIR_OUTPUT
    export DIR_OUTPUT=$(/usr/bin/realpath ${READ_DIR_OUTPUT:-$DIR_ROOT/output} 2> /dev/null)
    /bin/echo ""
    /bin/echo "Enter $PROJECT_NAME source directory"
    read -p "[$DIR_ROOT/source] " READ_DIR_SOURCE
    export DIR_SOURCE=$(/usr/bin/realpath ${READ_DIR_SOURCE:-$DIR_ROOT/source} 2> /dev/null)
    /bin/echo ""
    /bin/echo "Creating build config.."
    /bin/echo "DIR_ROOT=$DIR_ROOT" >> .crubus 2> /dev/null
    /bin/echo "DIR_OUTPUT=$DIR_OUTPUT" >> .crubus 2> /dev/null
    /bin/echo "DIR_SOURCE=$DIR_SOURCE" >> .crubus 2> /dev/null
    if [ "$?" = "0" ];
    then
        /bin/echo "done."
    else
        /bin/echo "failed!"
    fi
    exit
fi
#
#-----------------------------------------------------------------------------
#
# invalid command
#
/bin/echo ""
/bin/echo "./build.sh: Invalid command '$1'. Run './build.sh --help' for help."
exit
