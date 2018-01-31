# Background

If you have a Windows VM running in ESX which is hosting a MaxDB database and you want to create VMware Snapshots where the database is in an Application Consistent state then we can use these scripts.
VMware tools must be installed and running on the VMware VM.

Effectively the order of events will be:

1)  Actifio requests an Application Consistent VMware snapshot of the VM
2)  ESX requests VMware tools running in the VM to run any script located in c:\windows\pre-freeze-script.bat
3)  ESX takes a snapshot of the VM
4)  ESX requests VMware tools running in the VM to run any script located in c:\windows\post-thaw-script.bat
5)  Actifio creates an image of the VMware snapshot
6)  Actifio requests the VMware snapshot be removed

# Customizing the Scripts

The two scripts need three settings customized.   The password is stored in the clear.

```
@SET DATABASE=MAXDB1
@SET USERNAME=DBADMIN
@SET PASSWORD=passw0rd
```
The script also directs logging to c:\tmp\vmtools.log so please ensure the c:\tmp folder exists or choose a different folder.

# Installing the Scripts

Once the scripts are customized place them in the following locations:
```
c:\windows\pre-freeze-script.bat
c:\windows\post-thaw-script.bat
```
Ensure the logging folder exists (C:\tmp is the default)

# Testing the Scripts

Open a command prompt using 'Run as Administrator' and run these two commands:
```
cd c:\windows
pre-freeze-script.bat
```
Now check the log file.   Expected output is as follows.
The database state should have no state.  After the freeze the state should be USR HOLD
```
------------------------------------------ 
About to freeze MAXDB1 
Date and time: Tue 01/30/2018 20:36:58.54 
***** log active state 
OK
        

SERVERDB: MAXDB1

ID   UKT  Win   TASK       APPL Current         Timeout Region     Wait 
          tid   type        pid state          priority cnt try    item 

Console command finished (2018-01-30 20:36:58).
***** issue suspend 
OK
IO SEQUENCE                    = 29664
***** log active state after suspend 
OK
        

SERVERDB: MAXDB1

ID   UKT  Win   TASK       APPL Current         Timeout Region     Wait 
          tid   type        pid state          priority cnt try    item 
T2     2  0x68C Logwr           USR HOLD (248)  2     0 0               10(s)

Console command finished (2018-01-30 20:36:59).
```

Now run this command:
```
post-thaw-script.bat
```
Now check the log file.   Expected output is as follows.
The database state should be USR HOLD.  After the resume there should be no state.

```
------------------------------------------ 
About to thaw MAXDB1 
Date and time: Tue 01/30/2018 20:37:45.69 
***** log active state  
OK
        

SERVERDB: MAXDB1

ID   UKT  Win   TASK       APPL Current         Timeout Region     Wait 
          tid   type        pid state          priority cnt try    item 
T2     2  0x68C Logwr           USR HOLD (248)  2     0 0               10(s)

Console command finished (2018-01-30 20:37:45).
***** issue resume 
OK
***** log active state after resume 
OK
        

SERVERDB: MAXDB1

ID   UKT  Win   TASK       APPL Current         Timeout Region     Wait 
          tid   type        pid state          priority cnt try    item 

Console command finished (2018-01-30 20:37:46).
```

You are now ready to begin creating Application Consistent Snapshots of this VM.

# Troubleshooting

1)  The scripts do not run - location and name

Check their file location and naming.    Some versions of ESX require the files to be in different locations
```
ESX/ESXi 3.5 Update 1 or earlier
C:\Windows\<pre-freeze-script.bat>
C:\Windows\<post-thaw-script.bat></pre-freeze-script.bat>

ESX/ESXi 3.5 Update 2 or later	
C:\Program Files\VMware\VMware Tools\backupScripts.d\

ESX/ESXi 4.x	
C:\Windows\backupScripts.d\

ESXi 5.0	
C:\Windows\
C:\Program Files\VMware\VMware Tools\backupScripts.d\

ESXi 5.1 or later
C:\Windows\<pre-freeze-script.bat>
C:\Windows\<post-thaw-script.bat></pre-freeze-script.bat>
```
2)  The scripts do not run - check SLA Template

The Scripts will only be run if an Application Consistent snapshot is requested.   If the snapshot policy requests crash consistent snapshots then the request will never be sent to VMware tools to run the scripts.


