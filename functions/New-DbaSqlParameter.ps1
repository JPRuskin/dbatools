function New-DbaSqlParameter {
    <#
    .SYNOPSIS
        Creates a new SQL parameter.

    .DESCRIPTION
        Creates a new SQL parameter.

    .PARAMETER CompareInfo
        Sets the CompareInfo object that defines how string comparisons should be performed for this parameter.

    .PARAMETER DbType
        Sets the SqlDbType of the parameter.

    .PARAMETER Direction
        Sets a value that indicates whether the parameter is input-only, output-only, bidirectional, or a stored procedure return value parameter.

    .PARAMETER ForceColumnEncryption
        Enforces encryption of a parameter when using Always Encrypted.

        If SQL Server informs the driver that the parameter does not need to be encrypted, the query using the parameter will fail.

        This property provides additional protection against security attacks that involve a compromised SQL Server providing incorrect encryption metadata to the client, which may lead to data disclosure.

    .PARAMETER IsNullable
        Sets a value that indicates whether the parameter accepts null values.

        IsNullable is not used to validate the parameter's value and will not prevent sending or receiving a null value when executing a command.

    .PARAMETER LocaleId
        Sets the locale identifier that determines conventions and language for a particular region.

    .PARAMETER Offset
        Sets the offset to the Value property.

    .PARAMETER ParameterName
        Sets the name of the SqlParameter.

    .PARAMETER Precision
        Sets the maximum number of digits used to represent the Value property.

    .PARAMETER Scale
        Sets the number of decimal places to which Value is resolved.

    .PARAMETER Size
        Sets the maximum size, in bytes, of the data within the column.

    .PARAMETER SourceColumn
        Sets the name of the source column mapped to the DataSet and used for loading or returning the Value.

    .PARAMETER SourceColumnNullMapping
        Sets a value which indicates whether the source column is nullable. This allows SqlCommandBuilder to correctly generate Update statements for nullable columns.

    .PARAMETER SourceVersion
        Sets the DataRowVersion to use when you load Value.

    .PARAMETER SqlDbType
        Sets the SqlDbType of the parameter.

    .PARAMETER SqlValue
        Sets the value of the parameter as an SQL type.

    .PARAMETER TypeName
        Sets the type name for a table-valued parameter.

    .PARAMETER UdtTypeName
        Sets a string that represents a user-defined type as a parameter.

    .PARAMETER Value
        Sets the value of the parameter.

    .PARAMETER EnableException
        By default, when something goes wrong we try to catch it, interpret it and give you a friendly warning message.
        This avoids overwhelming you with "sea of red" exceptions, but is inconvenient because it basically disables advanced scripting.
        Using this switch turns this "nice by default" feature off and enables you to catch exceptions with your own try/catch.

    .NOTES
        Tags: Query
        Author: Chrissy LeMaire (@cl), netnerds.net
        Website: https://dbatools.io
        Copyright: (c) 2021 by dbatools, licensed under MIT
        License: MIT https://opensource.org/licenses/MIT

    .LINK
        https://dbatools.io/New-DbaSqlParameter

    .EXAMPLE
        PS C:\> $output = New-DbaSqlParameter -ParameterName json_result -SqlDbType NVarChar -Size -1 -Direction Output
        PS C:\> Invoke-DbaQuery -SqlInstance localhost -Database master -CommandType StoredProcedure -Query my_proc -SqlParameters $output
        PS C:\> $output.Value

        No idea lol
    #>
    [CmdletBinding()]
    param(
        [ValidateSet("None", "IgnoreCase", "IgnoreNonSpace", "IgnoreKanaType", "IgnoreWidth", "BinarySort2", "BinarySort")]
        [string]$CompareInfo,
        [ValidateSet("AnsiString", "Binary", "Byte", "Boolean", "Currency", "Date", "DateTime", "Decimal", "Double", "Guid", "Int16", "Int32", "Int64", "Object,
        SByte", "Single", "String", "Time", "UInt16", "UInt32", "UInt64", "VarNumeric", "AnsiStringFixedLength", "StringFixedLength", "Xml,
        DateTime2", "DateTimeOffset")]
        [string]$DbType,
        [ValidateSet("Input", "Output", "InputOutput", "ReturnValue")]
        [string]$Direction,
        [switch]$ForceColumnEncryption,
        [switch]$IsNullable,
        [int]$LocaleId,
        [string]$Offset,
        [Alias("Name")]
        [string]$ParameterName,
        [string]$Precision,
        [string]$Scale,
        [int]$Size,
        [string]$SourceColumn,
        [switch]$SourceColumnNullMapping,
        [ValidateSet("Original", "Current", "Proposed", "Default")]
        [string]$SourceVersion,
        [ValidateSet("BigInt", "Binary", "Bit", "Char", "DateTime", "Decimal", "Float", "Image", "Int", "Money", "NChar", "NText", "NVarChar", "Real,
        UniqueIdentifier", "SmallDateTime", "SmallInt", "SmallMoney", "Text", "Timestamp", "TinyInt", "VarBinary", "VarChar", "Variant", "Xml,
        Udt", "Structured", "Date", "Time", "DateTime2", "DateTimeOffset")]
        [string]$SqlDbType,
        [string]$SqlValue,
        [string]$TypeName,
        [string]$UdtTypeName,
        [object]$Value,
        [switch]$EnableException
    )
    $param = New-Object Microsoft.Data.SqlClient.SqlParameter

    try {
        if ($PSBoundParameters.CompareInfo) {
            $param.CompareInfo = $CompareInfo
        }

        if ($PSBoundParameters.DbType) {
            $param.DbType = $DbType
        }

        if ($PSBoundParameters.Direction) {
            $param.Direction = $Direction
        }

        if ($PSBoundParameters.ForceColumnEncryption) {
            $param.ForceColumnEncryption = $ForceColumnEncryption
        }

        if ($PSBoundParameters.IsNullable) {
            $param.IsNullable = $IsNullable
        }

        if ($PSBoundParameters.LocaleId) {
            $param.LocaleId = $LocaleId
        }

        if ($PSBoundParameters.Offset) {
            $param.Offset = $Offset
        }

        if ($PSBoundParameters.ParameterName) {
            $param.ParameterName = $ParameterName
        }

        if ($PSBoundParameters.Precision) {
            $param.Precision = $Precision
        }

        if ($PSBoundParameters.Scale) {
            $param.Scale = $Scale
        }

        if ($PSBoundParameters.Size) {
            $param.Size = $Size
        }

        if ($PSBoundParameters.SourceColumn) {
            $param.SourceColumn = $SourceColumn
        }

        if ($PSBoundParameters.SourceColumnNullMapping) {
            $param.SourceColumnNullMapping = $SourceColumnNullMapping
        }

        if ($PSBoundParameters.SourceVersion) {
            $param.SourceVersion = $SourceVersion
        }

        if ($PSBoundParameters.SqlDbType) {
            $param.SqlDbType = $SqlDbType
        }

        if ($PSBoundParameters.SqlValue) {
            $param.SqlValue = $SqlValue
        }

        if ($PSBoundParameters.TypeName) {
            $param.TypeName = $TypeName
        }

        if ($PSBoundParameters.UdtTypeName) {
            $param.UdtTypeName = $UdtTypeName
        }

        if ($PSBoundParameters.Value) {
            $param.Value = $Value
        }
        $param
    } catch {
        Stop-Function -Message "Failure" -ErrorRecord $_
        return
    }
}