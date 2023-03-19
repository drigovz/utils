$user = $env:UserName
$dotnetVersion = '6.0.100'
$netcoreapp = "net6.0"
Write-Host "Hello $user!"

Write-Host " ====================== Init creation of projects and folders ====================== " -ForegroundColor "Green"
$userAppName = Read-Host "What is application name"

if ([string]::IsNullOrEmpty($userAppName)) {
    Write-Host "`nName not valid!" -ForegroundColor "Red"
}
else {

    $UpperAppName = (Get-Culture).TextInfo.ToTitleCase("$userAppName")
    $appName = $UpperAppName.replace(' ','')

    Write-Host "`nSelected name is $appName!" -ForegroundColor "Green"

    $projectOptionInput = Read-Host "`nWhat kind of project do you like to create? `n   A) ASP.NET Core Web API `n   B) ASP.NET Core MVC `nChoose one"
    $projectOptionSelected = (Get-Culture).TextInfo.ToTitleCase("$projectOptionInput")
    if ([string]::IsNullOrEmpty($projectOptionSelected)) {
        Write-Host "`nProject option not valid!" -ForegroundColor "Red"
        Exit
    } else {
        if ($projectOptionSelected -eq "A") {
            Write-Host "API!" -ForegroundColor "Green"
        } elseif ($projectOptionSelected -eq "B") {
            Write-Host "MVC!" -ForegroundColor "Green"
        } else {
            Write-Host "`nProject option not valid!" -ForegroundColor "Red"
            Exit
        }
    }

    $unitTestOption = Read-Host "`nDo like to add Unit Tests on this project? `n   Y) YES `n   N) NO `nChosse one"
    $unitTest = (Get-Culture).TextInfo.ToTitleCase("$unitTestOption")
    if ([string]::IsNullOrEmpty($projectOptionSelected)) { 
        Write-Host "`nOption not valid!" -ForegroundColor "Red"
        Exit
    }

    # create directory for application
    mkdir $appName
    cd $appName

    # add global.json file
    echo global.json
    Add-Content -Path global.json -Value "{"  
    Add-Content -Path global.json -Value "  ""sdk"": { "  
    Add-Content -Path global.json -Value "    ""version"": ""$dotnetVersion"""  
    Add-Content -Path global.json -Value "  }"  
    Add-Content -Path global.json -Value "}"  

    # create solution
    dotnet new sln -n $appName

    mkdir src

    # ============================ Presentation layer ============================
    # create presentation project
    if ($projectOptionSelected -eq "A") {
        dotnet new webapi -n "$appName.Api" -o "src\$appName.Api" --no-https -f $netcoreapp
    } elseif ($projectOptionSelected -eq "B") {
        dotnet new mvc -n "$appName.Api" -o "src\$appName.Api" --no-https -f $netcoreapp
    } 

    # add solution
    dotnet sln add .\"src\$appName.Api"\

    # ============================ Domain layer ============================
    # create domain layer
    dotnet new classlib -n "$appName.Domain" -o "src\$appName.Domain" -f $netcoreapp

    # add domain in solution
    dotnet sln add .\"src\$appName.Domain"\

    mkdir -p "src\$appName.Domain\Entities"
    mkdir -p "src\$appName.Domain\Enums"
    mkdir -p "src\$appName.Domain\Validations"
    mkdir -p "src\$appName.Domain\Interfaces"
    mkdir -p "src\$appName.Domain\Interfaces\Repository"

    # ============================ INFRA.DATA ============================
    # create Infra.Data layer
    dotnet new classlib -n "$appName.Infra.Data" -o "src\$appName.Infra.Data" -f $netcoreapp

    # add infra.data in solution
    dotnet sln add .\"src\$appName.Infra.Data"\

    mkdir -p "src\$appName.Infra.Data\Context"
    mkdir -p "src\$appName.Infra.Data\Mappings"
    mkdir -p "src\$appName.Infra.Data\Repository"

    # ============================ INFRA.IOC ============================
    # create Infra.Ioc layer
    dotnet new classlib -n "$appName.Infra.IoC" -o "src\$appName.Infra.IoC" -f $netcoreapp

    # add infra.ioc in solution
    dotnet sln add .\"src\$appName.Infra.IoC"\

    mkdir -p "src\$appName.Infra.IoC\DependencyInjection"

    # ============================ APPLICATION ============================
    # create Application layer
    dotnet new classlib -n "$appName.Application" -o "src\$appName.Application" -f $netcoreapp

    # add application in solution
    dotnet sln add .\"src\$appName.Application"\

    mkdir -p "src\$appName.Application\Core"
    mkdir -p "src\$appName.Application\Notifications"

    # ============================ Add references on projects ============================
    # application 
    dotnet add .\"src\$appName.Application"\ reference .\"src\$appName.Domain"\

    # infra.data 
    dotnet add .\"src\$appName.Infra.Data"\ reference .\"src\$appName.Domain"\

    # infra.ioc 
    dotnet add .\"src\$appName.Infra.IoC"\ reference .\"src\$appName.Domain"\
    dotnet add .\"src\$appName.Infra.IoC"\ reference .\"src\$appName.Application"\
    dotnet add .\"src\$appName.Infra.IoC"\ reference .\"src\$appName.Infra.Data"\

    # api
    dotnet add .\"src\$appName.Api"\ reference .\"src\$appName.Infra.IoC"\

    # ============================ Remove unnecessary classes ============================
    # init remotion of classes Class1.cs of projects

    $classFileName = "Class1.cs"
    $classAppName = "WeatherForecast.cs"

    $location = Get-Location

    cd .\"src\$appName.Application"\
    if ($NULL -ne "$location\src\$appName.Application\$classFileName") {
        Remove-Item "$location\src\$appName.Application\$classFileName" | out-null
    }
    cd ..
    cd ..

    cd .\"src\$appName.Domain"\
    if ($NULL -ne "$location\src\$appName.Domain\$classFileName") {
        Remove-Item "$location\src\$appName.Domain\$classFileName" | out-null
    }
    cd ..
    cd ..

    cd .\"src\$appName.Infra.Data"\
    if ($NULL -ne "$location\src\$appName.Infra.Data\$classFileName") {
        Remove-Item "$location\src\$appName.Infra.Data\$classFileName" | out-null
    }
    cd ..
    cd ..

    cd .\"src\$appName.Infra.IoC"\
    if ($NULL -ne "$location\src\$appName.Infra.IoC\$classFileName") {
        Remove-Item "$location\src\$appName.Infra.IoC\$classFileName" | out-null
    }
    cd ..
    cd ..

    if ($projectOptionSelected -eq "A") { 
        cd .\"src\$appName.Api"\
        if ($NULL -ne "$location\src\$appName.Api\$classAppName") {
            Remove-Item "$location\src\$appName.Api\$classAppName" | out-null
        }
        cd .\Controllers\
        if ($NULL -ne "$location\src\$appName.Api\WeatherForecastController.cs") {
            Remove-Item "$location\src\$appName.Api\Controllers\WeatherForecastController.cs" | out-null
        }
        cd ..
        cd ..
        cd ..
    }

    # ============================ Add dependencies on projects ============================
    # application
    cd .\"src\$appName.Application"\

    dotnet add package FluentValidation --version 10.3.6
    dotnet add package MediatR --version 9.0.0

    cd ..
    cd ..

    # domain
    cd .\"src\$appName.Domain"\

    dotnet add package FluentValidation --version 10.3.6

    cd ..
    cd ..

    # infra.data
    cd .\"src\$appName.Infra.Data"\

    dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 6.0.0
    dotnet add package Microsoft.EntityFrameworkCore.Tools --version 6.0.0
    dotnet add package Microsoft.EntityFrameworkCore.Design --version 6.0.0

    cd ..
    cd ..
    
    # infra.ioc
    cd .\"src\$appName.Infra.IoC"\

    dotnet add package MediatR.Extensions.Microsoft.DependencyInjection --version 9.0.0

    cd ..
    cd ..

    # api
    cd .\"src\$appName.Api"\

    dotnet add package FluentValidation.AspNetCore --version 10.3.3

    cd ..
    cd ..

    dotnet restore
	dotnet build

    # ============================ Add xUnit Projects ============================
    if ($unitTest -eq "Y") {
        Write-Host "Add Unit Tests" -ForegroundColor "Green"

        mkdir tests

        # create unit tests for domain
        dotnet new xunit -n "$appName.Domain.Test" -o "tests\$appName.Domain.Test"

        # add project in solution
        dotnet sln add .\"tests\$appName.Domain.Test"\

        # add reference to domain
        dotnet add .\"tests\$appName.Domain.Test"\ reference .\"src\$appName.Domain"\

        mkdir -p "tests\$appName.Domain.Test\Builders"
        mkdir -p "tests\$appName.Domain.Test\Entities"

        # delete unnecessary class
        if ($NULL -ne "$location\tests\$appName.Domain.Test\UnitTest1.cs") {
            Remove-Item "$location\tests\$appName.Domain.Test\UnitTest1.cs" | out-null
        }

        cd .\"tests\$appName.Domain.Test"\

        # add project packages 
        dotnet add package Bogus --version 33.1.1
        dotnet add package FluentAssertions --version 6.1.0

        cd ..
        cd ..
    }

    # rebuild application
    dotnet clean 
    dotnet build
    dotnet restore

    # ============================ Add .gitattributes ============================
    # add .gitignore
    dotnet new gitignore

    # add .gitattributes
    echo .gitattributes
    Add-Content -Path .gitattributes "# Set default behavior to automatically normalize line endings. > .gitattributes"          
    Add-Content -Path .gitattributes "* text=auto"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "*.doc  diff=astextplain"
    Add-Content -Path .gitattributes "*.DOC	 diff=astextplain"
    Add-Content -Path .gitattributes "*.docx diff=astextplain"
    Add-Content -Path .gitattributes "*.DOCX diff=astextplain"
    Add-Content -Path .gitattributes "*.dot	 diff=astextplain"
    Add-Content -Path .gitattributes "*.DOT	 diff=astextplain"
    Add-Content -Path .gitattributes "*.pdf	 diff=astextplain"
    Add-Content -Path .gitattributes "*.PDF	 diff=astextplain"
    Add-Content -Path .gitattributes "*.rtf	 diff=astextplain"
    Add-Content -Path .gitattributes "*.RTF	 diff=astextplain"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "*.jpg  binary"
    Add-Content -Path .gitattributes "*.png  binary"
    Add-Content -Path .gitattributes "*.gif  binary"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "# Force bash scripts to always use lf line endings so that if a repo is accessed"
    Add-Content -Path .gitattributes "# in Unix via a file share from Windows, the scripts will work."
    Add-Content -Path .gitattributes "*.in text eol=lf"
    Add-Content -Path .gitattributes "*.sh text eol=lf"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "Likewise, force cmd and batch scripts to always use crlf"
    Add-Content -Path .gitattributes "*.cmd text eol=crlf"
    Add-Content -Path .gitattributes "*.bat text eol=crlf"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "*.cs text=auto diff=csharp"
    Add-Content -Path .gitattributes "*.vb text=auto"
    Add-Content -Path .gitattributes "*.resx text=auto"
    Add-Content -Path .gitattributes "*.c text=auto"
    Add-Content -Path .gitattributes "*.cpp text=auto"
    Add-Content -Path .gitattributes "*.cxx text=auto"
    Add-Content -Path .gitattributes "*.h text=auto"
    Add-Content -Path .gitattributes "*.hxx text=auto"
    Add-Content -Path .gitattributes "*.py text=auto"
    Add-Content -Path .gitattributes "*.rb text=auto"
    Add-Content -Path .gitattributes "*.java text=auto"
    Add-Content -Path .gitattributes "*.html text=auto"
    Add-Content -Path .gitattributes "*.htm text=auto"
    Add-Content -Path .gitattributes "*.css text=auto"
    Add-Content -Path .gitattributes "*.scss text=auto"
    Add-Content -Path .gitattributes "*.sass text=auto"
    Add-Content -Path .gitattributes "*.less text=auto"
    Add-Content -Path .gitattributes "*.js text=auto"
    Add-Content -Path .gitattributes "*.lisp text=auto"
    Add-Content -Path .gitattributes "*.clj text=auto"
    Add-Content -Path .gitattributes "*.sql text=auto"
    Add-Content -Path .gitattributes "*.php text=auto"
    Add-Content -Path .gitattributes "*.lua text=auto"
    Add-Content -Path .gitattributes "*.m text=auto"
    Add-Content -Path .gitattributes "*.asm text=auto"
    Add-Content -Path .gitattributes "*.erl text=auto"
    Add-Content -Path .gitattributes "*.fs text=auto"
    Add-Content -Path .gitattributes "*.fsx text=auto"
    Add-Content -Path .gitattributes "*.hs text=auto"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "*.csproj text=auto"
    Add-Content -Path .gitattributes "*.vbproj text=auto"
    Add-Content -Path .gitattributes "*.fsproj text=auto"
    Add-Content -Path .gitattributes "*.dbproj text=auto"
    Add-Content -Path .gitattributes "*.sln text=auto eol=crlf"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "# Set linguist language for .h files explicitly based on"
    Add-Content -Path .gitattributes "# https://github.com/github/linguist/issues/1626#issuecomment-401442069"
    Add-Content -Path .gitattributes "# this only affects the repo's language statistics"
    Add-Content -Path .gitattributes "*.h linguist-language=C"
    Add-Content -Path .gitattributes " "

    Add-Content -Path .gitattributes "# CLR specific"
    Add-Content -Path .gitattributes "src/coreclr/src/pal/tests/palsuite/paltestlist.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/src/pal/tests/palsuite/paltestlist_to_be_reviewed.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regexdna/regexdna-input25.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regexdna/regexdna-input25000.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regex-redux/regexdna-input25.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regex-redux/regexdna-input25000.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/reverse-complement/revcomp-input25.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/reverse-complement/revcomp-input25000.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/k-nucleotide/knucleotide-input.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/k-nucleotide/knucleotide-input-big.txt text eol=lf"
    Add-Content -Path .gitattributes "src/coreclr/tests/src/performance/Scenario/JitBench/Resources/word2vecnet.patch text eol=lf"
    Add-Content -Path .gitattributes " "

    # add .env file 
	echo .env
	Add-Content -Path .env "SQL_SERVER_ADDRESS= "
	Add-Content -Path .env "SQL_CATALOG= "
	Add-Content -Path .env "SQL_USER_ID= "
	Add-Content -Path .env "SQL_PASSWORD= "
	Add-Content -Path .env "SQL_PID=Express "
	Add-Content -Path .env " "
	
	# add .env.exemple file 
	echo .env.exemple
	Add-Content -Path .env.exemple "SQL_SERVER_ADDRESS= "
	Add-Content -Path .env.exemple "SQL_CATALOG= "
	Add-Content -Path .env.exemple "SQL_USER_ID= "
	Add-Content -Path .env.exemple "SQL_PASSWORD= "
	Add-Content -Path .env.exemple "SQL_PID=Express "
	Add-Content -Path .env.exemple " "

    # init Git repo
    git init

    # open project on Visual Studio
    $solutionFinished = -join($appName, ".sln")
    start $solutionFinished

    Exit 
}

Exit