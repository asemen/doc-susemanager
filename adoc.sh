#!/bin/sh
export FILE=xml/MAIN-manager.xml
export NAME=`basename $FILE .xml`
#echo "Converting $NAME"
#rm -rf asciidoctor
#docbookrx --strict xml/$NAME.xml
#mkdir -p adoc
#mv xml/*adoc adoc
#asciidoctor -b html -d book -D asciidoctor/html xml/$NAME.adoc
asciidoctor -b docbook5 -d book -D asciidoctor/xml adoc/$NAME.adoc
# insert ENTITY
sed -i '2i <!DOCTYPE set [ <!ENTITY % entities SYSTEM "entity-decl.ent"> %entities; ]>' asciidoctor/$FILE
# replace {foo} (but not ${foo}) with &foo;
perl -p -i -e 's/([^\$])\{(\w+)\}/\1\&$2\;/g' asciidoctor/$FILE
# make .ent files available
cp entities/*ent asciidoctor/xml
daps -m asciidoctor/xml/$NAME.xml --verbosity=0 --styleroot /usr/share/xml/docbook/stylesheet/suse2013-ns html
rm -rf asciidoctor/build/$NAME/html/$NAME/images
ln -sf ../../../../../adoc/images asciidoctor/build/$NAME/html/$NAME
