# Gruppen Admin Tool
Tool zur Verwaltung von lokalen Windows Gruppe auf einem remote server

Verwendung:

1. Userlist.csv befüllen
	Format: <domain1>\<username1>
			<domain2>\<username2>
			
	z.B. ww002\z002mkum
		 ww002\MULLERSV
		
	(Diese Bezeichnungen sind nicht case senitive)
	
2. Run.bat ausführen (Notwendig für Admin Privilegien und um die Powershell Execution Policiy zu übergehen)
3. evt. Admin Berechtigungen bestätigen.
4. Prüfen ob Einstellungen korrekt sind und ob die User aus dem CSV richtig ausgelesen wurden
5. Aktivität wählen 
	(i.d.R     a - add um die User aus der Liste zur Gruppe hinzuzufügen)
	
6. Überprüfen ob die User korrekt hinzugefügt/entfernt werden konnten
	(Die Resultate werden auch in ein Logfile geschrieben. Das Logfile befindet sich im selben Verzeichnis wie das GroupManager.ps1 Script)
