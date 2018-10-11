$boxes = Get-ChildItem -Directory -n
$global:input = ""

function ShowMenu {
    Clear-Host
    Write-Host ""
    $Title = 'Vagrant - Environments Manager'
    Write-Host " === $Title ========================"
    Write-Host ""

    Get-ChildItem -Directory -n | ForEach-Object -Begin { $i = 0 } -Process {
        if ($_ -eq '_screenshots') { return }
        $i++
        " {0:D1}) Box => {1}" -f $i, $_
    }

    Write-Host " 0) vagrant global-status"
    Write-Host " X) Exit"
    Write-Host ""
    $global:input = Read-Host " Please type a number or X to exit"
    $text = $global:input;

    if ($text -eq '') { return }
    if ($text -eq '0') {
        ExecAction '-' 'vgs' 
        return
    }
    if ($text -eq 'x') { return }

    $boxName = $boxes[$text - 1];
    ShowActions $boxName
}

function ShowActions($boxName) {
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

    if ($text -eq '') { return }
    if ($text -eq 'x') { return }

    ExecAction $boxName $text
}

function ExecAction($boxName, $action) {
    Write-Host ""
    Write-Host " Selected-Box: $boxName"
    Write-Host " Selected-Action: $action"
    Write-Host ""
    Write-Host " Executing. Wait..."
    if ($boxName -ne '-') { Set-Location $boxName }
    if ($action -eq 1) {
        Write-Host " > vagrant up"
        vagrant up
    }
    if ($action -eq 2) {
        Write-Host " > vagrant up --provision"
        vagrant up --provision
    }
    if ($action -eq 3) {
        Write-Host " > vagrant ssh"
        vagrant ssh
    }
    if ($action -eq 4) {
        Write-Host " > vagrant provision"
        vagrant provision
    }
    if ($action -eq 5) {
        Write-Host " > vagrant halt"
        vagrant halt
    }
    if ($action -eq 'vgs') {
        Write-Host " > vagrant global-status"
        vagrant global-status
    }
    Write-Host " Done!"
    if ($boxName -ne '-') { Set-Location .. }
    pause
}

do {
    ShowMenu
}
until ($global:input -eq 'x')

Clear-Host