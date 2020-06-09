[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$rootPath = $args[0]
$search = Join-Path -Path $rootPath -ChildPath "*.json"
$files = Get-ChildItem -Path $rootPath  -Recurse -File
$files | ForEach-Object -Process {
	$path = Join-Path -Path $rootPath -ChildPath $_
	$json = Get-Content $path | ConvertFrom-Json 	
	$json.files | ForEach-Object -Process {
		if ($_.url_private)
		{
			$imageUrl = $_.url_private
			$outputFile = $_.timestamp.ToString() + "_" + $_.name
			$output = Join-Path -Path $rootPath -ChildPath $outputFile
			if (![System.IO.File]::Exists($output))
			{
				Invoke-WebRequest -Uri $imageUrl -OutFile $output
			}
		}	
	}
}
