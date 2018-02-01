function Test-Script {
    param (
        [Object]$script
    )

    $parse_errs = $null
    $tokens = [System.Management.Automation.PSParser]::Tokenize($script,[ref] $parse_errs)
    foreach ($err in $parse_errs) 
    {
        'ERROR on line ' + 
        $err.Token.Startline + 
        ': ' + $err.Message + "`n"
    }
    foreach ($token in $tokens) 
    {
        if ($token.Type -eq 'CommandArgument')
        {
            $gcmerr = Get-Command $Token.Content 2>&1
            if (! $? ) 
            {
                'WARNING on line ' +
                $gcmerr.InvocationInfo.ScriptLineNumber +
                ': ' + $gcmerr.Exception.Message + "`n"
            }
        }
    }
}
