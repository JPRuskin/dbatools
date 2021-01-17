$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {

        [array]$knownParameters = 'SqlInstance', 'SqlCredential', 'Database', 'InputObject', 'Table', 'Schema', 'BatchSize', 'NotifyAfter', 'AutoCreateTable', 'NoTableLock', 'CheckConstraints', 'FireTriggers', 'KeepIdentity', 'KeepNulls', 'Truncate', 'bulkCopyTimeOut', 'EnableException', 'UseDynamicStringLength'
        [array]$params = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Function')).Parameters.Keys

        It "Should only contain our specific parameters" {
            Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params | Should -BeNullOrEmpty
        }
    }
}

Describe "$CommandName Integration Tests" -Tags "IntegrationTests" {
    BeforeAll {
        $server = Connect-DbaInstance -SqlInstance $script:instance1
        $random = Get-Random
        $db = "dbatoolsci_writedbadaatable$random"
        $server.Query("CREATE DATABASE $db")
    }
    AfterAll {
        $null = Get-DbaDatabase -SqlInstance $server -Database $db | Remove-DbaDatabase -Confirm:$false
    }

    # calling random function to throw data into a table
    It "defaults to dbo if no schema is specified" {
        $results = Get-ChildItem | ConvertTo-DbaDataTable
        $results | Write-DbaDbTableData -SqlInstance $script:instance1 -Database $db -Table 'childitem' -AutoCreateTable

        ($server.Databases[$db].Tables | Where-Object { $_.Schema -eq 'dbo' -and $_.Name -eq 'childitem' }).Count | Should Be 1
    }
}