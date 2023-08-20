
<#
No PowerShell, existem várias maneiras de baixar um arquivo. 
Vou fornecer algumas opções com comentários explicativos:
#>

#####################################################################################################
# Utilizando o cmdlet Invoke-WebRequest ou curl (disponível no Windows 10 e versões mais recentes): #
#####################################################################################################
    <#
    - É um cmdlet nativo do PowerShell que permite fazer solicitações HTTP.
    - Oferece mais flexibilidade, permitindo definir cabeçalhos personalizados, autenticação, etc.
    - Suporta diferentes métodos HTTP, como GET, POST, PUT, DELETE, entre outros.
    - É útil quando você precisa interagir com serviços web ou APIs.
    #>


    $url = "URL_DO_ARQUIVO"
    $outputPath = "C:\Caminho\para\o\arquivo.extensao"

    # Baixa o arquivo usando o cmdlet Invoke-WebRequest
    Invoke-WebRequest -Uri $url -OutFile $outputPath

    # Baixa o arquivo usando o cmdlet curl
    curl -Uri $url -OutFile $outputPath


#############################################
# Utilizando o cmdlet System.Net.WebClient: #
#############################################

    <#
    - É uma classe do namespace System.Net que fornece métodos para download de arquivos.
    - É mais simples de usar em comparação com o Invoke-WebRequest.
    - Não oferece tanta flexibilidade em termos de configurações de solicitação HTTP.
    - É adequado para downloads básicos de arquivos quando não é necessário personalizar a solicitação.
    #>

    $url = "URL_DO_ARQUIVO"
    $outputPath = "C:\Caminho\para\o\arquivo.extensao"

    # Cria uma instância do WebClient
    $client = New-Object System.Net.WebClient

    # Baixa o arquivo usando o método DownloadFile
    $client.DownloadFile($url, $outputPath)
    
##########################################################################
# Utilizando o cmdlet Start-BitsTransfer (requer o módulo BitsTransfer): #
##########################################################################

    <#
    - Usa o serviço de Transferência Inteligente de Plano de Fundo (BITS) do Windows.
    - Permite o gerenciamento de transferências de arquivos em segundo plano.
    - Pode ser pausado, reiniciado e monitorado.
    - É útil quando você precisa controlar e gerenciar o processo de transferência de forma mais avançada.
    #>


    $url = "URL_DO_ARQUIVO"
    $outputPath = "C:\Caminho\para\o\arquivo.extensao"

    # Baixa o arquivo usando o cmdlet Start-BitsTransfer
    Start-BitsTransfer -Source $url -Destination $outputPath


#################################################################################
# Usando Invoke-RestMethod para APIs RESTful:                                  #
#################################################################################

    <#
    - É um cmdlet nativo do PowerShell que permite fazer solicitações HTTP em APIs RESTful.
    - É mais direcionado para interações com APIs, mas também pode ser usado para download de arquivos.
    - Oferece suporte a autenticação e manipulação de formatos como JSON e XML.
    - É especialmente útil quando você está trabalhando com serviços web que oferecem endpoints REST.
    #>

    $url = "URL_DO_ARQUIVO"
    $outputPath = "C:\Caminho\para\o\arquivo.extensao"

    # Baixa o arquivo usando o cmdlet Invoke-RestMethod
    $response = Invoke-RestMethod -Uri $url -OutFile $outputPath

####################################################################################
# Usando .NET HttpWebRequest (Biblioteca Padrão):                                 #
####################################################################################

    <#
    - Usa a classe HttpWebRequest da biblioteca .NET para fazer solicitações HTTP.
    - Oferece um alto nível de controle sobre a solicitação, mas a sintaxe é mais complexa.
    - É útil quando você precisa de um controle detalhado sobre a solicitação e a resposta HTTP.
    - Requer uma abordagem mais manual e envolve mais código do que os cmdlets nativos.
    #>

    $url = "URL_DO_ARQUIVO"
    $outputPath = "C:\Caminho\para\o\arquivo.extensao"

    # Cria uma instância de HttpWebRequest
    $request = [System.Net.HttpWebRequest]::Create($url)

    # Obtém a resposta da solicitação
    $response = $request.GetResponse()

    # Abre o fluxo de resposta
    $responseStream = $response.GetResponseStream()

    # Cria um stream para o arquivo local
    $fileStream = [System.IO.File]::Create($outputPath)

    # Copia o conteúdo do fluxo de resposta para o stream do arquivo
    $responseStream.CopyTo($fileStream)

    # Fecha os fluxos
    $responseStream.Close()
    $fileStream.Close()
    $response.Close()

<#
Essas são algumas das formas mais comuns de baixar um arquivo usando PowerShell. 
Você pode escolher a opção que melhor se adequa às suas necessidades e ao ambiente em que 
está trabalhando. Certifique-se de substituir "URL_DO_ARQUIVO" pelo URL real do arquivo 
que deseja baixar e "C:\Caminho\para\o\arquivo.extensao" pelo caminho de destino
e nome do arquivo que deseja salvar.

Cada uma das opções tem seus casos de uso adequados, dependendo dos requisitos
específicos do seu script ou aplicativo. Se você precisa de recursos avançados de
solicitação HTTP, como autenticação ou manipulação de cabeçalhos, o Invoke-WebRequest
é a melhor opção. Se você precisa de simplicidade e apenas deseja fazer o download 
básico de um arquivo, o System.Net.WebClient é uma escolha sólida. O Start-BitsTransfer 
é útil quando você deseja gerenciar e monitorar as transferências de arquivos em segundo plano.
O curl (alias para Invoke-WebRequest no PowerShell 7 e versões mais recentes) é uma 
opção alternativa para aqueles familiarizados com o comando curl do Linux/Unix e preferem 
uma sintaxe semelhante. O Invoke-RestMethod também é uma alternativa poderosa, especialmente 
ao lidar com APIs RESTful, oferecendo suporte à autenticação e manipulação de formatos como 
JSON e XML. O .NET HttpWebRequest da biblioteca padrão fornece um alto nível de controle 
sobre a solicitação, mas requer uma abordagem mais manual e envolve mais código do que os 
cmdlets nativos.
#>