Function New-MultipassVM ($name, $config) {
  curl "https://raw.githubusercontent.com/j0rtiz/multipass-cloud-init/main/vm.ps1" -o ".\vm.ps1"
  powershell.exe ".\vm.ps1" $name $config
}

Function Open-MultipassVM ($name) {
  powershell.exe "multipass sh" $name
}

Set-Alias -Name vmnew -Value New-MultipassVM
Set-Alias -Name vmopen -Value Open-MultipassVM
