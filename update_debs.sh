#!/bin/bash
# 自动脚本执行 把本文件直接拖到终端 按Enter一步到位
# $ /Users/xlsn0w/debs/update_debs.sh
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPTPATH

# 手动终端执行
# cd 根目录路径
# cd /Users/xlsn0w/debs

# 删除之前Packages和Packages.bz2
rm ./Packages
rm ./Packages.bz2

# 创建新的Packages
dpkg-scanpackages debs / > Packages

# 创建新的Packages.bz2
bzip2 -fks Packages

# rm -rf /Users/ouo/Documents/GitHub/OuOp.GitHub.io/debs
# rm -rf /Users/ouo/Documents/GitHub/OuOp.GitHub.io/Packages
# rm -rf /Users/ouo/Documents/GitHub/OuOp.GitHub.io/Packages.bz2
# cp -r ./Packages /Users/ouo/Documents/GitHub/OuOp.GitHub.io/Packages
# cp -r ./Packages.bz2 /Users/ouo/Documents/GitHub/OuOp.GitHub.io/Packages.bz2
# cp -r ./debs /Users/ouo/Documents/GitHub/OuOp.GitHub.io/debs
#
# rm -rf /Users/ouo/Documents/Gitee/LakrOwO/repo/debs
# rm -rf /Users/ouo/Documents/Gitee/LakrOwO/repo/Packages
# rm -rf /Users/ouo/Documents/Gitee/LakrOwO/repo/Packages.bz2
# cp -r ./Packages /Users/ouo/Documents/Gitee/LakrOwO/repo/Packages
# cp -r ./Packages.bz2 /Users/ouo/Documents/Gitee/LakrOwO/repo/Packages.bz2
# cp -r ./debs /Users/ouo/Documents/Gitee/LakrOwO/repo/debs

