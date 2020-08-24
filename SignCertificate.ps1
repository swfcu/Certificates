 

$Password = Read-Host -Prompt 'Enter new password to protect certificate' -AsSecureString
$MyCertFromPfx = Get-PfxCertificate -FilePath D:\MyNewSigningCertificate.pfx 


Set-AuthenticodeSignature -PSPath .\ToBeSigned.ps1 -Certificate $MyCertFromPfx 

Invoke-Command -ComputerName  'is-support' -ScriptBlock  {Get-ChildItem Cert:\LocalMachine\My  | 

    Where {$_.NotAfter -lt  (Get-Date).AddDays(200)}} | ForEach {
  
    [pscustomobject]@{
  
    Computername =  $_.PSComputername
  
    Subject =  $_.Subject
  
    ExpiresOn =  $_.NotAfter
  
    DaysUntilExpired = Switch ((New-TimeSpan -End $_.NotAfter).Days) {
  
    {$_  -gt 0} {$_}
    Default  {'Expired'}

}

}

} 