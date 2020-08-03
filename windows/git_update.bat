#https://blog.csdn.net/u013788943/article/details/81629645 博客每日更新
@echo off
@title bat 交互执行git 每日提交命令
F:
cd F:\project\mygithub\linux-kernel
git status .
git add .
git commit -m update
git push origin master
pause