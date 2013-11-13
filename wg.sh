#! /bin/bash
#每十分钟一次用来同步终端网页
_date=`date +%Y%m%d%H%M`
_vdate=`date +%Y%m%d`
tmp=`ps -ef|grep -v grep|grep wget|wc -l `
_shanbo=`ps -ef|grep -v grep|grep backshanbo.sh|wc -l`
if [ $_shanbo -le 0 ]
then
if [ $tmp -le 0 ]
then
_shanlink="/opt/shanlink/www/shanlink_mobile"
_shanlink_back="/opt/xiangmu/shanlink_mobile"
_tmp="/opt/back/tmp"
_www="/opt/www"
mkdir ${_tmp}
cd $_tmp
###rm -rf  $_tmp/*
echo "strt wget---------------------------"
wget -npH -N -m -l5 --reject=php --user-agent="Wget/1.11.4 Red Hat modified"  -X html/video,uploadfile/2011/video,360/app http://m.shanlink.com/index.php?m=mobile
#python 脚本目录
mkdir shell
echo "#!/usr/bin/python">>shell/python.py
yes|cp $_tmp/index.php?m=mobile $_tmp/mindex.html
#删除原index.html
rm -rf $_tmp/index.html
#重新wget新index.html
wget --user-agent="Wget/1.11.4 Red Hat modified" http://m.shanlink.com
yes|cp $_tmp/index.html $_tmp/index.htm
##end
###rm -rf $_tmp/statics/images
_wgcron=`ps -ef|grep -v grep|grep wg_cron|wc -l`
_wgcronpid=`ps -ef|grep wg_cron|grep -v grep|awk '{print $2}'`
echo "wgcron: ${_wgcron} wgcrontpid: ${_wgcronpid}" >> /root/shell/log/testwgsh.log
if [ ${_wgcron} -eq 1 ]
then
kill -9 ${_wgcronpid}
fi
#rm -rf $_shanlink/html/video
#rm -rf $_shanlink/*.html
#rm -rf $_shanlink/*.htm
#rm -rf $_shanlink/uploadfile
#rm -rf $_shanlink/statics

#echo "$_vdate" >$_shanlink/html/v.html
cp -af ${_www}/statics ${_tmp}/
#cp -af ${_www}/html/box_local_data/* $_tmp/html/box_local_data/
cp -af ${_www}/tools ${_tmp}/
cp -af ${_www}/boxinfo.php ${_tmp}/boxinfo.php
cp -af ${_www}/setapacheenv.php ${_tmp}/setapacheenv.php
cp -af ${_www}/sl_shop/{css,image,index.php,js,protected,themes}  ${_tmp}/sl_shop/
cp -af ${_www}/sl_client ${_tmp}/sl_client
cp -af ${_www}/transport ${_tmp}/transport
# add yii by gang.song 20130620
cp -af ${_www}/html/yii  ${_tmp}/html/yii
cp -af /opt/xiangmu/s  ${_tmp}/
#复制U盘更新密码
cp -af ${_www}/password.html  ${_tmp}/
##比较两次wget文件是否有更新，有更新则更新版本信息，没有则使用原来的版本。
_rsdif=$(diff -r ${_tmp} ${_shanlink}|wc -l)
if [ ${_rsdif} -eq 0 ]
then
cat ${_shanlink}/coun.html >coun.html
cat "" >song.html
else
echo "$_date" >coun.html
echo "$(date)" >result.txt
echo "$_rsdif">diff.txt
fi
###备份shanlink_mobile移动tmp目录为shanlink_mobile
rm -rf ${_shanlink_back}
mv -v ${_shanlink}  ${_shanlink_back}
mv -v $_tmp ${_shanlink}
echo "################ mv tmp shanlink_mobile ########################"
chmod 777 -R ${_shanlink}
#rm -rf ${_shanlink_back}
fi
fi
