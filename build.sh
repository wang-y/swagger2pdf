#!/usr/bin/env bash

# 自定义工程名及URL
prjnames=("bdcommunication" "bdemailmsg" "bdevent" "cloud" "distributepushlog" "distributerestfullog" "electronicfencewarning" "mobile" "nonbdposition" "operation" "transmitlog" "usercenter" "bdposition" "doc" "doc_admin")
prjurls=("10.30.0.20/bdcommunication" "10.30.0.20/bdemailmsg" "10.30.0.20/bdevent" "10.30.0.20/cloud" "10.30.0.20/distributepushlog" "10.30.0.20/distributerestfullog" "10.30.0.20/electronicfencewarning" "10.30.0.20/mobile" "10.30.0.20/nonbdposition" "10.30.0.20/operation" "10.30.0.20/transmitlog" "10.30.0.20/usercenter" "10.30.0.20/bdposition" "10.30.0.43:8080/doc" "10.30.0.43:8081/admin")
prjgroups=("" ""  ""  ""  ""  ""  ""  ""  ""  ""  ""  ""  ""  "Document Center API"  "Document Center Admin API")

# 默认参数
datestr=`date +%Y%m%d`
srcdir_html=./target/asciidoc/html
destdir_html=./src/docs/html/${datestr}
srcdir_pdf=./target/asciidoc/pdf
destdir_pdf=./src/docs/pdf/${datestr}
srcdir_md=./target/swagger
destdir_md=./src/docs/md/${datestr}

cd `dirname $0`
BASE_DIR=`pwd`

cd $BASE_DIR/src/docs

rm -rf html pdf md

mkdir html
mkdir pdf
mkdir md

cd $BASE_DIR/src/docs/html
mkdir $datestr

cd $BASE_DIR/src/docs/pdf
mkdir $datestr

cd $BASE_DIR/src/docs/md
mkdir $datestr

cd $BASE_DIR


# 循环生成文档
for prjname in ${prjnames[@]}
do
    prjurl=${prjurls[${i}]}
    prjgroup=${prjgroups[${i}]}
    echo "文档生成开始 - ${prjname} - ${prjurl} - ${prjgroup}"

    mvn clean test -Dcustom.baseurl=${prjurl} -Dcustom.group="${prjgroup}"
    cp ${srcdir_html}/index.html ${destdir_html}/${prjname}.html
    cp ${srcdir_pdf}/index.pdf ${destdir_pdf}/${prjname}.pdf
    cp ${srcdir_md}/swagger.md ${destdir_md}/${prjname}.md

    i=$((i+1))
done