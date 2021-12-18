echo "# VM..."
$vm = $args[0]
if ($vm -eq $null) {
  $vm = "dev"
}

echo "# Config..."
$config = $args[1]
if ($config -eq $null) {
  $config = (curl "https://raw.githubusercontent.com/j0rtiz/multipass-cloud-init/main/vm.yaml").Content
  ($Env:AZURE | ConvertFrom-Json).psobject.Properties | foreach {
    $config = $config -replace "{$($_.Name)}", $_.Value
  }
  $config | Out-File .\vm.yaml
  $config = "vm.yaml"
}

echo "# Delete..."
multipass delete -p $vm

echo "# Launch..."
multipass launch -n $vm -c 2 -m 2G -d 20G --cloud-init $config

echo "# IP..."
$ip = (multipass info $vm --format csv | ConvertFrom-Csv).Ipv4

echo "# Browser..."
start https://${ip}:3000/api/docs/

echo "# Shell..."
multipass sh $vm

echo "# Fim!"
