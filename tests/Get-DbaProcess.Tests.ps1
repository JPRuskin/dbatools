$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {

        [array]$knownParameters = 'SqlInstance', 'SqlCredential', 'Spid', 'ExcludeSpid', 'Database', 'Login', 'Hostname', 'Program', 'ExcludeSystemSpids', 'EnableException'
        [array]$params = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Function')).Parameters.Keys

        It "Should only contain our specific parameters" {
            Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params | Should -BeNullOrEmpty
        }
    }
}

Describe "$CommandName Integration Tests" -Tags "IntegrationTests" {
    Context "Testing Get-DbaProcess results" {
        $results = Get-DbaProcess -SqlInstance $script:instance1

        It "matches self as a login at least once" {
            $matching = $results | Where-Object Login -match $env:username
            $matching.Length | Should BeGreaterThan 0
        }

        $results = Get-DbaProcess -SqlInstance $script:instance1 -Program 'dbatools PowerShell module - dbatools.io'

        foreach ($result in $results) {
            It "returns only dbatools processes" {
                $result.Program -eq 'dbatools PowerShell module - dbatools.io' | Should Be $true
            }
        }

        $results = Get-DbaProcess -SqlInstance $script:instance1 -Database master

        foreach ($result in $results) {
            It "returns only processes from master database" {
                $result.Database -eq 'master' | Should Be $true
            }
        }
    }
}