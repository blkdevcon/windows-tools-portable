!addplugindir `${PACKAGE}\Other\Source\Plugins`

${SegmentFile}

;=== START INTEGRITY CHECK 1.1 Var
	Var bolCustomIntegrityCheckStartUnsupported
	Var strCustomIntegrityCheckVersion
;=== END INTEGRITY CHECK

Var Exists_LEGACY_IOBITUNLOCKER
Var Exists_Services_IObitUnlocker

${Segment.OnInit}
	; Borrowed the following from PAL 2.2, Remove on release of PAL 2.2
		; Work out if it's 64-bit or 32-bit
	System::Call kernel32::GetCurrentProcess()i.s
	System::Call kernel32::IsWow64Process(is,*i.r0)
	${If} $0 == 0
		StrCpy $Bits 32
	${Else}
		StrCpy $Bits 64
	${EndIf}
	
	;=== START INTEGRITY CHECK 1.1 OnInit
	;Check for improper install/upgrade without running the PA.c Installer which can cause issues
	;Designed to not require ReadINIStrWithDefault which is not included in the PA.c Launcher code
	
	${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
		${If} ${FileExists} "$EXEDIR\App\AppInfo\pac_installer_log.ini"
			ReadINIStr $R0 "$EXEDIR\App\AppInfo\pac_installer_log.ini" "PortableApps.comInstaller" "Info2"
			${If} $R0 == "This file was generated by the PortableApps.com Installer wizard and modified by the official PortableApps.com Installer TM Rare Ideas, LLC as the app was installed."
				StrCpy $R1 "true"
			${Else}
				StrCpy $R1 "false"
			${EndIf}
		${Else}
			StrCpy $R1 "false"
		${EndIf}
	${Else}
		StrCpy $R1 "true"
	${EndIf}
	
	${If} $R1 == "false"
		;Upgrade or install sans the PortableApps.com Installer which can cause compatibility issues
		ClearErrors
		ReadINIStr $0 "$EXEDIR\App\AppInfo\appinfo.ini" "Version" "PackageVersion"
		${If} ${Errors}
		${OrIf} $0 == ""
			StrCpy $0 "0.0.0.1"
			ClearErrors
		${EndIf}

		ClearErrors
		ReadINIStr $1 "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown"
		${If} ${Errors}
		${OrIf} $1 == ""
			StrCpy $1 "0.0.0.0"
			ClearErrors
		${EndIf}

		${VersionCompare} $0 $1 $2
		${If} $2 == 1		
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON2 `Integrity Failure Warning: ${NamePortable} was installed or upgraded without using its installer and some critical files may have been modified.  This could cause data loss, personal data left behind on a shared PC, functionality issues, and/or may be a violation of the application's license. Neither the application publisher nor PortableApps.com will be responsible for any issues you encounter.$\r$\n$\r$\nWould you like to start ${NamePortable} in its current unsupported state?` IDYES CustomIntegrityCheckGotoStartAnyway IDNO CustomIntegrityCheckGotoDownloadQuestion
		
			CustomIntegrityCheckGotoDownloadQuestion:
			;Check to ensure we have a valid homepage before asking the user
			StrCpy $R0 ""
			${If} ${FileExists} "$EXEDIR\App\AppInfo\appinfo.ini"
				ReadINIStr $R0 "$EXEDIR\App\AppInfo\appinfo.ini" "Details" "Homepage"
			${EndIf}
			
			${If} $R0 == ""
				Abort
			${Else}
				StrCpy $R1 $R0 4
				${If} $R1 != "http"
				${AndIf} $R1 != "HTTP"
					StrCpy $R0 "http://$R0"
				${EndIf}
			${EndIf}
			
			MessageBox MB_YESNO|MB_ICONQUESTION|MB_DEFBUTTON1 `Would you like to visit the ${NamePortable} homepage to download the app and upgrade your current install?` IDYES CustomIntegrityCheckGotoURL IDNO CustomIntegrityCheckGotoAbort

			CustomIntegrityCheckGotoURL:		
			ExecShell "open" $R0
			Abort
						
			CustomIntegrityCheckGotoAbort:
			Abort
	
			CustomIntegrityCheckGotoStartAnyway:
			StrCpy $bolCustomIntegrityCheckStartUnsupported true
			StrCpy $strCustomIntegrityCheckVersion $0
		${EndIf}
	${EndIf}
	;=== END INTEGRITY CHECK
!macroend

${SegmentPrePrimary}
	;=== START INTEGRITY CHECK 1.1 PrePrimary
	${If} $bolCustomIntegrityCheckStartUnsupported == true
		WriteINIStr "$EXEDIR\Data\settings\${AppID}Settings.ini" "${AppID}Settings" "InvalidPackageWarningShown" $strCustomIntegrityCheckVersion
	${EndIf}	
	;=== END INTEGRITY CHECK
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
	${If} $R0 = 0
		StrCpy $Exists_LEGACY_IOBITUNLOCKER true
	${EndIf}
	
	${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
	${If} $R0 = 0
		StrCpy $Exists_Services_IObitUnlocker true
	${EndIf}

	Delete "$EXEDIR\App\IObitUnlocker\IObitUnlocker.sys"
	Delete "$EXEDIR\App\IObitUnlocker\IObitUnlockerExtension.dll"
    ${If} $Bits = 64
		${If} ${AtLeastWinVista}
			${If} ${AtLeastWin7}
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern64\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern64\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
			${Else}
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysVista64\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysVista64\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
			${EndIf}
		${Else}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysXP64\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysXP64\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${EndIf}
    ${Else}
		${If} ${AtLeastWinVista}
			${If} ${AtLeastWin7}
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern32\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysModern32\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
			${Else}
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysVista32\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
				CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysVista32\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
			${EndIf}
		${Else}
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysXP32\IObitUnlocker.sys" "$EXEDIR\App\IObitUnlocker"
			CopyFiles /SILENT "$EXEDIR\App\IObitUnlocker\SysXP32\IObitUnlockerExtension.dll" "$EXEDIR\App\IObitUnlocker"
		${EndIf}
    ${EndIf}
!macroend

${SegmentPostPrimary}	
	${IfNot} $Exists_LEGACY_IOBITUNLOCKER == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Enum\Root\LEGACY_IOBITUNLOCKER" $R0
			${EndIf}
		${EndIf}
	${EndIf}
	
	${IfNot} $Exists_Services_IObitUnlocker == true
		${registry::KeyExists} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
		${If} $R0 = 0
			AccessControl::GrantOnRegKey HKLM "SYSTEM\CurrentControlSet\Services\IObitUnlocker" "(BU)" "FullAccess"
			Pop $R0
			${If} $R0 == error
				Pop $R0
				;MessageBox MB_OK|MB_SETFOREGROUND|MB_ICONINFORMATION `AccessControl error: $R0`
			${Else}
				${registry::DeleteKey} "HKLM\SYSTEM\CurrentControlSet\Services\IObitUnlocker" $R0
			${EndIf}
		${EndIf}
	${EndIf}
!macroend