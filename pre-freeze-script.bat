@echo on

@SET "AppsLog=c:\tmp\vmtools.log"
@SET DATABASE=MAXDB1
@SET USERNAME=DBADMIN
@SET PASSWORD=passw0rd

@echo ------------------------------------------ >>  %AppsLog%
@echo About to freeze %DATABASE% >>  %AppsLog%
@echo Date and time: %date% %time% >>  %AppsLog%

@echo ***** log active state >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active >>  %AppsLog%
@echo ***** issue suspend >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c util_execute suspend logwriter >>  %AppsLog%
@echo ***** log active state after suspend >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active >>  %AppsLog%