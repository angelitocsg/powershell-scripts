$boxes = Get-ChildItem -Directory -n
$global:input = ""

function Show-Menu {
    cls
    Write-Host ""
    $Title = 'Vagrant - Environments Manager'
    Write-Host " === $Title ========================"
    Write-Host ""

    Get-ChildItem -Directory -n | foreach -Begin {$i=0} -Process {
        if ($_ -eq '_screenshots') { return }
        $i++
        " {0:D1}) Box => {1}" -f $i, $_
    }

    Write-Host " X) Exit"
    Write-Host ""
    $global:input = Read-Host " Please type a number or X to exit"
    $text = $global:input;

    if ($text -eq 'x') { return }

    $boxName = $boxes[$text - 1];
    Show-Actions $boxName
}

function Show-Actions($boxName) {
    Write-Host ""
    Write-Host " Selected-Box: $boxName"
    Write-Host ""
    Write-Host " 1) vagrant up"
    Write-Host " 2) vagrant up --provision"
    Write-Host " 3) vagrant ssh"
    Write-Host " 4) vagrant provision"
    Write-Host " 5) vagrant halt"

    Write-Host " X) Exit"
    Write-Host ""
    $global:input = Read-Host " Please type a number or X to exit"
    $text = $global:input;

    if ($text -eq 'x') { return }

    Exec-Action $boxName $text
}

function Exec-Action($boxName, $action) {
    Write-Host ""
    Write-Host " Selected-Box: $boxName"
    Write-Host " Selected-Action: $action"
    Write-Host ""
    Write-Host " Executing. Wait..."
    cd $boxName
    if ($action -eq 1) { vagrant up > run_up.log}
    if ($action -eq 2) { vagrant up --provision  > run_up_provision.log}
    if ($action -eq 3) { vagrant ssh}
    if ($action -eq 4) { vagrant provision > run_provision.log}
    if ($action -eq 5) { vagrant halt > run_halt.log }
    Write-Host " Done!"
    cd ..
    pause
}

do
{
    Show-Menu
}
until ($global:input -eq 'x')

cls