<#
    The below statement stays in for every test you build.
#>
$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

<#
    Unit test is required for any command added
#>
Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {

        [array]$knownParameters = 'SqlInstance', 'SqlCredential', 'ServerRole', 'ExcludeServerRole', 'ExcludeFixedRole', 'EnableException'
        [array]$params = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Function')).Parameters.Keys

        It "Should only contain our specific parameters" {
            Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params | Should -BeNullOrEmpty
        }
    }
}

Describe "$CommandName Integration Tests" -Tags "IntegrationTests" {
    Context "Command actually works" {
        $results = Get-DbaServerRole -SqlInstance $script:instance2
        It "Should have correct properties" {
            $ExpectedProps = 'ComputerName,DatabaseEngineEdition,DatabaseEngineType,DateCreated,DateModified,Events,ExecutionManager,ID,InstanceName,IsFixedRole,Login,Name,Owner,Parent,ParentCollection,Properties,Role,ServerRole,ServerVersion,SqlInstance,State,Urn,UserData'.Split(',')
            ($results[0].PsObject.Properties.Name | Sort-Object) | Should Be ($ExpectedProps | Sort-Object)
        }

        It "Shows only one value with ServerRole parameter" {
            $results = Get-DbaServerRole -SqlInstance $script:instance2 -ServerRole sysadmin
            $results[0].Role | Should Be "sysadmin"
        }

        It "Should exclude sysadmin from output" {
            $results = Get-DbaServerRole -SqlInstance $script:instance2 -ExcludeServerRole sysadmin
            'sysadmin' -NotIn $results.Role | Should Be $true
        }

        It "Should exclude fixed server-level roles" {
            $results = Get-DbaServerRole -SqlInstance $script:instance2 -ExcludeFixedRole
            'sysadmin' -NotIn $results.Role | Should Be $true
        }

    }
}