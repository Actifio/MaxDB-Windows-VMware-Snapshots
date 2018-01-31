@echo on

@set "AppsLog=c:\tmp\vmtools.log"
@set DATABASE=MAXDB1
@set USERNAME=DBADMIN
@set PASSWORD=passw0rd

@echo ------------------------------------------ >>  %AppsLog%
@echo About to thaw %DATABASE% >>  %AppsLog%
@echo Date and time: %date% %time% >>  %AppsLog%

@echo ***** log active state  >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active >>  %AppsLog%
@echo ***** issue resume >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c util_execute resume logwriter >>  %AppsLog%
@echo ***** log active state after resume >>  %AppsLog%
@dbmcli.exe -d %DATABASE% -u %USERNAME%,%PASSWORD% -uUTL -c show active >>  %AppsLog%