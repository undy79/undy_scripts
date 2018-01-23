function My-Function {
[CmdletBinding()] # Can be used to run debug flags on commands

param (
[Parameter(mandatory=$True, # A parameter is required to run 
ValueFromPipeline=$True, #string must come from pipeline  a parameter to be added to the script 
HelpMessage=‘Help Message for the cmdlets')]
[string]$string
)

# if an array is passed you can run a process for each variable in the array

begin {
}
    Process {
      write-host "$string"
    }

End {

}
}
