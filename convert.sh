#!/bin/bash

set -e
set -u

rm -rf out
mkdir out

for f in 20*/*/*/*.rst; do
#for f in 2012/12/07/sql-vs-orm.rst; do
    echo $f
    mkdir -p out/$(dirname $f)

    dest=out/$(dirname $f)/$(basename $f .rst).md
    year=$(echo $f | cut -d / -f 1)
    month=$(echo $f | cut -d / -f 2)
    day=$(echo $f | cut -d / -f 3)


    title=$(pandoc -f rst -t markdown_github $f | while read line; do
        if echo $line | grep -E '=+' > /dev/null; then
            echo $prev
            break
        fi
        prev=$line
    done)

    # Front matters
    echo "+++" > $dest

    echo "title = \"$title\"" >> $dest
    echo "date = \"${year}-${month}-${day}\"" >> $dest

    more_prev=$(cat $f | while read line; do
        if echo $line | grep tags > /dev/null ; then
            tags=$(echo $line | cut -d : -f 3 | ruby -ne 'puts $_.split(",").map(&:strip).map{|s|%("#{s}")}.join(", ")')
            echo "tags = [${tags}]" >> $dest
        fi

        if echo $line | grep categories > /dev/null ; then
            categories=$(echo $line | cut -d : -f 3 | ruby -ne 'puts $_.split(",").map(&:strip).map{|s|%("#{s}")}.join(", ")')
            echo "categories = [${categories}]" >> $dest
        fi

        if echo $line | grep ".. more::" > /dev/null ; then
            echo $prev | ruby -ne 'print $_.size > 7 ? $_[-10...-1] : $_[-7...-1]'
            break
        fi

        if [ -n "$line" ]; then
            prev=$line
        fi
    done)


    echo "+++" >> $dest

    # convert from rst to markdown
    pandoc -f rst -t markdown_github $f | while read line; do
        if [ "$line" = "$title" ] ; then
            continue
        fi

        if echo $line | grep -E '=+' > /dev/null; then
            continue
        fi

        echo $line

        if [ -n "$more_prev" ]; then
            if echo "$line" | grep "$more_prev" > /dev/null; then
                echo
                echo "<!--more-->"
                echo
            fi
        fi
    done >> $dest
done
