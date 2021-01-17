$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {

        [array]$knownParameters = 'SqlInstance', 'SqlCredential', 'Login', 'NewLogin', 'EnableException'
        [array]$params = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Function')).Parameters.Keys

        It "Should only contain our specific parameters" {
            Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params | Should -BeNullOrEmpty
        }
    }
}

Describe "$CommandName Integration Tests" -Tags "IntegrationTests" {
    BeforeAll {
        $login = "dbatoolsci_renamelogin"
        $renamed = "dbatoolsci_renamelogin2"
        $password = 'MyV3ry$ecur3P@ssw0rd'
        $securePassword = ConvertTo-SecureString $password -AsPlainText -Force
        $newlogin = New-DbaLogin -SqlInstance $script:instance1 -Login $login -Password $securePassword
    }
    AfterAll {
        $null = Stop-DbaProcess -SqlInstance $script:instance1 -Login $renamed
        $null = Remove-DbaLogin -SqlInstance $script:instance1 -Login $renamed -Confirm:$false
    }

    Context "renames the login" {
        $results = Rename-DbaLogin -SqlInstance $script:instance1 -Login $login -NewLogin $renamed
        It "rename is successful" {
            $results.Status | Should Be "Successful"
        }
        It "output for previous login is correct" {
            $results.PreviousLogin | Should Be $login
        }
        It "output for new login is correct" {
            $results.NewLogin | Should Be $renamed
        }
        It "results aren't null" {
            Get-DbaLogin -SqlInstance $script:instance1 -login $renamed | Should Not BeNullOrEmpty
        }
    }
}