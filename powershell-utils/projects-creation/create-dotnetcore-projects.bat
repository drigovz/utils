@echo off
rem oculta o caminho relativo no cmd. Exemplo: C:/
echo " ====================== Iniciando criacao dos projetos ====================== "

set /p aplicacao=Informe o nome da aplicacao 

if [%aplicacao%] == [] (
    color 4
    echo "Nome da aplicacao nao informado"
) else (
    echo O nome escolhido foi %aplicacao%

    rem cria uma pasta para o projeto 
    md %aplicacao%

    cd %aplicacao%

    rem adicinando um arquivo global.json
    echo { > global.json
    echo   "sdk": { >> global.json
    echo     "version": "3.1.405" >> global.json
    echo   } >> global.json
    echo } >> global.json

    rem criando a solution
    dotnet new sln -n %aplicacao%

    rem ============================ APRESENTAÇÃO ============================
    rem criando o projeto de apresentação
    dotnet new webapi -n %aplicacao%.Application -o %aplicacao%.Application --no-https -f netcoreapp3.1

    rem adicionando a solução
    dotnet sln add .\%aplicacao%.Application\

    rem ============================ DOMíNIO ============================
    rem criando a camada de domínio
    dotnet new classlib -n %aplicacao%.Domain -o %aplicacao%.Domain -f netcoreapp3.1

    rem adicionando o domínio a solução
    dotnet sln add .\%aplicacao%.Domain\

    cd .\%aplicacao%.Domain\

    md DTOs
    md Entities
    md Interfaces
    cd .\Interfaces\
    md Repository
    md Services
    cd ..
    cd ..

    rem ============================ CROSS CUTTING ============================
    rem criando o projeto da camada CrossCutting
    dotnet new classlib -n %aplicacao%.Infra.CrossCutting -o %aplicacao%.Infra.CrossCutting -f netcoreapp3.1

    rem adionando a solução
    dotnet sln add .\%aplicacao%.Infra.CrossCutting\

    cd .\%aplicacao%.Infra.CrossCutting\

    md DependencyInjection
    md Mappings

    cd ..

    rem ============================ DATA ============================
    rem criando o projeto Data
    dotnet new classlib -n %aplicacao%.Infra.Data -o %aplicacao%.Infra.Data -f netcoreapp3.1

    rem adicionando a solução
    dotnet sln add %aplicacao%.Infra.Data\

    cd .\%aplicacao%.Infra.Data\

    md Context
    md Implementation
    md Mappings
    md Factory
    md Repository

    cd ..

    rem ============================ SERVICE ============================
    rem criando o projeto da camada de serviço
    dotnet new classlib -n %aplicacao%.Service -o %aplicacao%.Service -f netcoreapp3.1

    rem adicionando a solução
    dotnet sln add %aplicacao%.Service\

    cd .\%aplicacao%.Service\

    md Services

    cd ..

    rem ============================ ADICIONANDO AS REFERÊNCIAS NOS PROJETOS ============================
    dotnet add .\%aplicacao%.Infra.Data\ reference .\%aplicacao%.Domain\

    rem service
    dotnet add .\%aplicacao%.Service\ reference .\%aplicacao%.Domain\
    dotnet add .\%aplicacao%.Service\ reference .\%aplicacao%.Infra.Data\

    rem application
    dotnet add .\%aplicacao%.Application\ reference .\%aplicacao%.Domain\
    dotnet add .\%aplicacao%.Application\ reference .\%aplicacao%.Service\
    dotnet add .\%aplicacao%.Application\ reference .\%aplicacao%.Infra.CrossCutting\

    rem cross cutting
    dotnet add .\%aplicacao%.Infra.CrossCutting\ reference .\%aplicacao%.Domain\
    dotnet add .\%aplicacao%.Infra.CrossCutting\ reference .\%aplicacao%.Service\
    dotnet add .\%aplicacao%.Infra.CrossCutting\ reference .\%aplicacao%.Infra.Data\

    rem ============================ REMOVENDO CLASSES DESNECESSÁRIAS DOS PROJETOS ============================
    rem inicia remoção das classes Class1.cs dos projetos

    cd .\%aplicacao%.Service\
    if exist Class1.cs (
        del Class1.cs
    )
    cd ..

    cd .\%aplicacao%.Domain\
    if exist Class1.cs (
        del Class1.cs
    )
    cd ..

    cd .\%aplicacao%.Infra.Data\
    if exist Class1.cs (
        del Class1.cs
    )
    cd ..

    cd .\%aplicacao%.Infra.CrossCutting\
    if exist Class1.cs (
        del Class1.cs
    )
    cd ..

    cd .\%aplicacao%.Application\
    if exist WeatherForecast.cs (
        del WeatherForecast.cs
    )
    cd .\Controllers\
    if exist WeatherForecastController.cs (
        del WeatherForecastController.cs
    )
    cd ..
    cd ..

    rem ============================ ADICIONANDO AS DEPENDÊNCIAS NOS PROJETOS ============================
    rem inicia instalação de dependências dos projetos
    cd .\%aplicacao%.Infra.Data\

    dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 3.1.6
    dotnet add package Microsoft.EntityFrameworkCore.Tools --version 3.1.6
    dotnet add package Microsoft.EntityFrameworkCore.Design --version 3.1.6
    dotnet add package AutoMapper --version 10.1.1

    cd ..

    cd .\%aplicacao%.Infra.CrossCutting\

    dotnet add package AutoMapper.Extensions.Microsoft.DependencyInjection --version 8.1.0

    cd .\%aplicacao%.Service\

    dotnet add package AutoMapper --version 10.1.1

    cd ..

    dotnet restore
	dotnet build

    rem ============================ ADICIONANDO .GITATTRIBUTES ============================
    rem adicinando um arquivo .gitignore
    dotnet new gitignore
    
    rem adicinando um arquivo .gitattributes
    echo # Set default behavior to automatically normalize line endings. > .gitattributes          
    echo * text=auto >> .gitattributes
    echo. >> .gitattributes

    echo *.doc  diff=astextplain >> .gitattributes
    echo *.DOC	diff=astextplain >> .gitattributes
    echo *.docx	diff=astextplain >> .gitattributes
    echo *.DOCX	diff=astextplain >> .gitattributes
    echo *.dot	diff=astextplain >> .gitattributes
    echo *.DOT	diff=astextplain >> .gitattributes
    echo *.pdf	diff=astextplain >> .gitattributes
    echo *.PDF	diff=astextplain >> .gitattributes
    echo *.rtf	diff=astextplain >> .gitattributes
    echo *.RTF	diff=astextplain >> .gitattributes
    echo. >> .gitattributes

    echo *.jpg  binary >> .gitattributes
    echo *.png 	binary >> .gitattributes
    echo *.gif 	binary >> .gitattributes
    echo. >> .gitattributes

    echo # Force bash scripts to always use lf line endings so that if a repo is accessed >> .gitattributes
    echo # in Unix via a file share from Windows, the scripts will work. >> .gitattributes
    echo *.in text eol=lf >> .gitattributes
    echo *.sh text eol=lf >> .gitattributes
    echo. >> .gitattributes

    echo # Likewise, force cmd and batch scripts to always use crlf >> .gitattributes
    echo *.cmd text eol=crlf >> .gitattributes
    echo *.bat text eol=crlf >> .gitattributes
    echo. >> .gitattributes

    echo *.cs text=auto diff=csharp >> .gitattributes
    echo *.vb text=auto >> .gitattributes
    echo *.resx text=auto >> .gitattributes
    echo *.c text=auto >> .gitattributes
    echo *.cpp text=auto >> .gitattributes
    echo *.cxx text=auto >> .gitattributes
    echo *.h text=auto >> .gitattributes
    echo *.hxx text=auto >> .gitattributes
    echo *.py text=auto >> .gitattributes
    echo *.rb text=auto >> .gitattributes
    echo *.java text=auto >> .gitattributes
    echo *.html text=auto >> .gitattributes
    echo *.htm text=auto >> .gitattributes
    echo *.css text=auto >> .gitattributes
    echo *.scss text=auto >> .gitattributes
    echo *.sass text=auto >> .gitattributes
    echo *.less text=auto >> .gitattributes
    echo *.js text=auto >> .gitattributes
    echo *.lisp text=auto >> .gitattributes
    echo *.clj text=auto >> .gitattributes
    echo *.sql text=auto >> .gitattributes
    echo *.php text=auto >> .gitattributes
    echo *.lua text=auto >> .gitattributes
    echo *.m text=auto >> .gitattributes
    echo *.asm text=auto >> .gitattributes
    echo *.erl text=auto >> .gitattributes
    echo *.fs text=auto >> .gitattributes
    echo *.fsx text=auto >> .gitattributes
    echo *.hs text=auto >> .gitattributes
    echo. >> .gitattributes

    echo *.csproj text=auto >> .gitattributes
    echo *.vbproj text=auto >> .gitattributes
    echo *.fsproj text=auto >> .gitattributes
    echo *.dbproj text=auto >> .gitattributes
    echo *.sln text=auto eol=crlf >> .gitattributes
    echo. >> .gitattributes

    echo # Set linguist language for .h files explicitly based on >> .gitattributes
    echo # https://github.com/github/linguist/issues/1626#issuecomment-401442069 >> .gitattributes
    echo # this only affects the repo's language statistics >> .gitattributes
    echo *.h linguist-language=C >> .gitattributes
    echo. >> .gitattributes

    echo # CLR specific >> .gitattributes
    echo src/coreclr/src/pal/tests/palsuite/paltestlist.txt text eol=lf >> .gitattributes
    echo src/coreclr/src/pal/tests/palsuite/paltestlist_to_be_reviewed.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regexdna/regexdna-input25.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regexdna/regexdna-input25000.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regex-redux/regexdna-input25.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/regex-redux/regexdna-input25000.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/reverse-complement/revcomp-input25.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/reverse-complement/revcomp-input25000.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/k-nucleotide/knucleotide-input.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/JIT/Performance/CodeQuality/BenchmarksGame/k-nucleotide/knucleotide-input-big.txt text eol=lf >> .gitattributes
    echo src/coreclr/tests/src/performance/Scenario/JitBench/Resources/word2vecnet.patch text eol=lf >> .gitattributes
    echo. >> .gitattributes
    
    rem iniciando um repositório git no projeto
    echo "Iniciando um repositorio Git"
    git init
    
    color 2
    echo " ====================== Execucao do script finalizada ====================== "
    echo " ====================== Projetos criados ====================== "

    rem abrindo o projeto no vs code 
    .\%aplicacao%.sln
)

taskkill /F /IM cmd.exe