@echo off
setlocal enabledelayedexpansion

for %%F in ("*.nar") do (
    echo Processing file: %%F
    lumia_nar_to_gif.cmd %%F
)

endlocal