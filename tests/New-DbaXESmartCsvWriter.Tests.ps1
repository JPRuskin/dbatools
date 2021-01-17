$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {

        [array]$knownParameters = 'OutputFile', 'Overwrite', 'Event', 'OutputColumn', 'Filter', 'EnableException'
        [array]$params = ([Management.Automation.CommandMetaData]$ExecutionContext.SessionState.InvokeCommand.GetCommand($CommandName, 'Function')).Parameters.Keys

        It "Should only contain our specific parameters" {
            Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params | Should -BeNullOrEmpty
        }
    }
}

Describe "$commandname Integration Tests" -Tags "IntegrationTests" {
    Context "Creates a smart object" {
        It "returns the object with all of the correct properties" {
            $results = New-DbaXESmartCsvWriter -Event abc -OutputColumn one, two -Filter What -OutputFile C:\temp\abc.csv
            $results.OutputFile | Should -Be 'C:\temp\abc.csv'
            $results.Overwrite | Should -Be $false
            $results.OutputColumns | Should -Contain 'one'
            $results.Filter | Should -Be 'What'
            $results.Events | Should -Contain 'abc'
        }
    }
}