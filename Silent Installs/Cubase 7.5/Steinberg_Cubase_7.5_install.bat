certutil -addstore "TrustedPublisher" "Cubase_7.5 Network Install\Cert\Steinberg.cer"
"Cubase_7.5 Network Install\eLicenserControlSetup.exe" --mode unattended --unattendedmodeui none

msiexec /i "Cubase_7.5 Network Install\Cubase 7.5 64bit\Cubase75_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\HALion Sonic SE 64bit\HALionSonicSE_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Groove Agent SE 64bit\GrooveAgentSE_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Eucon Adapter 6.5 64bit\EuconAdapter65_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Padshop 64bit\Padshop_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Retrologue 64bit\Retrologue_64bit.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\LoopMash Content\LoopMash_Content.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Groove Agent SE Content\GrooveAgentSE_Content.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Groove Agent ONE Vintage Beatboxes\Groove_Agent_ONE_Vintage_Beatboxes.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\VST Amp Rack Content 01\VSTAmp_Content_01.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\REVerence Content 01\Reverence_Content_01.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\LoopMash Content 2\LoopMash_Content2.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Groove Agent ONE Content\Groove_Agent_ONE_Content.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Midi Loop Library\Steinberg_Midi_Loop_Library.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\EDM Toolbox MIDI Loops\Steinberg_EDM_Toolbox_MIDI_Loops.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Drum Loop Expansion 01\Steinberg_Drum_Loop_Expansion_01.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Groove Agent ONE Allen Morgan Signature Drums\Groove_Agent_ONE_Allen_Morgan_Signature_Drums.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\HALion Sonic SE Content\HALionSonicSE_Content.msi" /qr ALLUSERS=1
msiexec /i "Cubase_7.5 Network Install\Upload Manager\UploadManager.msi" /qr ALLUSERS=1

msiexec /p "Cubase 7.5 Update\Cubase_7.5.40_64bit_Update.msp" /qb
msiexec /p "Cubase 7.5 Update\Groove_Agent_SE_4.1.0_64bit_Update.msp" /qb
msiexec /p "Cubase 7.5 Update\GrooveAgentSE_Content_Update_1.2.0.msp" /qb
msiexec /p "Cubase 7.5 Update\HALion_Sonic_SE_2.0.2_64bit_Update.msp" /qb


