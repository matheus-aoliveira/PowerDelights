
## While Loop:

### Usando o cmdlet Invoke-WebRequest ou o alias curl (disponível no PS 6.x ou superior):

A condição do while está verificando se a 
variável $response é igual a $null. A ideia por trás disso é criar 
um loop que continua executando enquanto a variável $response 
ainda é nula, ou seja, enquanto o download do arquivo não foi concluído.

Ao atribuir o resultado do Invoke-RestMethod à variável 
$response, você está armazenando o status dessa solicitação. 
Enquanto o download ainda não estiver concluído, o $response 
provavelmente será $null.

O loop while com a condição $response -eq $null serve para
esperar até que a variável $response não seja mais nula, o que 
indicaria que o download foi concluído e o resultado da solicitação 
HTTP foi retornado. Durante esse período, o loop fica repetindo a 
instrução Start-Sleep -Seconds 1 a cada segundo para evitar uma 
verificação contínua e intensiva da condição, economizando recursos do sistema.

Em resumo, esse trecho de código está esperando até que a 
solicitação HTTP de download do arquivo seja concluída, 
monitorando a variável $response para isso. Uma vez que o 
download esteja completo, o loop será interrompido e o código 
subsequente poderá prosseguir com segurança, sabendo que o 
arquivo foi totalmente baixado e que o resultado da solicitação HTTP 
está disponível na variável $response.

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"
```

Invoke-WebRequest:

> [!NOTE]
> A propriedade .IsCompleted é usada para verificar se uma tarefa foi concluída, 
ou seja, se a operação assíncrona associada a ela foi finalizada. Ela geralmente 
retorna um valor booleano: true se a tarefa estiver completa e false se ainda 
estiver em andamento.

```
# Inicia o download 
$response = Invoke-WebRequest -Uri $url -OutFile $outputPath

# Aguardar até que o arquivo seja totalmente baixado 
while ($response.IsCompleted -eq $false) {
    Start-Sleep -Seconds 1
}
```

Curl:

```
# Inicia o download
curl -Uri $url -OutFile $outputPath

# Aguardar até que o arquivo seja totalmente baixado
$initialSize = -1  # Tamanho inicial do arquivo, definido como -1 para entrar no loop
while ($true) {
    $currentSize = (Get-Item $outputPath).Length  # Obtém o tamanho atual do arquivo

    if ($currentSize -eq $initialSize) {
        # Se o tamanho atual do arquivo não mudou, aguarda um segundo e verifica novamente
        Start-Sleep -Seconds 1
    } else {
        # Se o tamanho atual do arquivo mudou, atualiza o tamanho inicial e continua verificando
        $initialSize = $currentSize
    }

    # Se o tamanho inicial for -1, isso significa que ainda não foi definido, então continuamos a verificar
    if ($initialSize -ne -1) {
        break  # Sai do loop quando o tamanho inicial for atualizado
    }
}
```

### Usando o cmdlet System.Net.WebClient:

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Cria uma instância do WebClient
$client = New-Object System.Net.WebClient

# Inicia o download
$client.DownloadFile($url, $outputPath)

# Aguardar até que o arquivo seja totalmente baixado
while ($client.IsBusy) {
    Start-Sleep -Seconds 1
}
```

### Usando o cmdlet Start-BitsTransfer (requer o módulo BitsTransfer):

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Inicia o download
Start-BitsTransfer -Source $url -Destination $outputPath

# Aguardar até que o arquivo seja totalmente baixado
while ((Get-BitsTransfer | Where-Object { $_.JobState -eq "Transferring" }) -ne $null) {
    Start-Sleep -Seconds 1
}
```


### Usando Invoke-RestMethod para APIs RESTful:

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Inicia o download
$response = Invoke-RestMethod -Uri $url -OutFile $outputPath

# Aguardar até que o arquivo seja totalmente baixado
while ($response -eq $null) {
    Start-Sleep -Seconds 1
}
```


### Usando .NET HttpWebRequest (Biblioteca Padrão):

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Cria uma solicitação HttpWebRequest
$request = [System.Net.HttpWebRequest]::Create($url)
$response = $request.GetResponse()

# Aguardar até que a resposta seja recebida
while ($response.IsCompleted -eq $false) {
    Start-Sleep -Seconds 1
}
$response.Close()
```

## Using Wait:

Quando você chama o método .Wait() em uma tarefa, o programa
fica bloqueado e não avança para as próximas instruções até que a
tarefa seja completada. Isso é útil quando você precisa garantir que
uma tarefa seja totalmente finalizada antes de prosseguir para a 
próxima etapa do código.

### Usando o cmdlet Invoke-WebRequest:

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Inicia o download e armazena a tarefa em uma variável
$downloadTask = Invoke-WebRequest -Uri $url -OutFile $outputPath

# Aguarda até que o download seja concluído
$downloadTask.Wait()

# Inicia o download e armazena a tarefa em uma variável
$downloadTask = Start-Process -NoNewWindow curl -ArgumentList "-Uri '$url' -OutFile '$outputPath'"

# Aguarda até que o download seja concluído
$downloadTask.WaitForExit()
```

### Usando o cmdlet System.Net.WebClient:

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Cria uma instância do WebClient
$client = New-Object System.Net.WebClient

# Inicia o download assíncrono e armazena a tarefa em uma variável
$downloadTask = $client.DownloadFileTaskAsync($url, $outputPath)

# Aguarda até que o download seja concluído
$downloadTask.Wait()
```

### Usando o cmdlet Start-BitsTransfer (requer o módulo BitsTransfer):

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Inicia o download e armazena a tarefa em uma variável
$downloadTask = Start-BitsTransfer -Source $url -Destination $outputPath

# Aguarda até que o download seja concluído
$downloadTask.Wait()
```

### Usando Invoke-RestMethod para APIs RESTful:

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Inicia o download e armazena a tarefa em uma variável
$downloadTask = Invoke-RestMethod -Uri $url -OutFile $outputPath

# Aguarda até que o download seja concluído
$downloadTask.Wait()
```

### Usando .NET HttpWebRequest (Biblioteca Padrão):

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Cria uma solicitação HttpWebRequest
$request = [System.Net.HttpWebRequest]::Create($url)

# Inicia o download assíncrono e armazena a tarefa em uma variável
$downloadTask = $request.GetResponseAsync()

# Aguarda até que o download seja concluído
$downloadTask.Wait()
```

## Using JobState:

A propriedade .JobState geralmente contém um valor que indica 
o estado atual do trabalho, que pode ser um dos seguintes:

NotStarted: O trabalho ainda não foi iniciado.
Running: O trabalho está em execução.
Completed: O trabalho foi concluído com sucesso.
Failed: O trabalho falhou durante a execução.
Stopped: O trabalho foi interrompido ou cancelado manualmente.
Blocked: O trabalho está aguardando algum recurso ou condição para continuar.

Ao verificar o valor da propriedade .JobState, você pode 
determinar em qual estado o trabalho se encontra e tomar ações 
apropriadas com base nesse estado. Isso é especialmente útil 
quando você está lidando com tarefas assíncronas ou paralelas e 
deseja acompanhar seu progresso e resultado.

```
$url = "URL_DO_ARQUIVO"
$outputPath = "C:\Caminho\para\o\arquivo.extensao"

# Iniciar a transferência usando BitsTransfer
$transferJob = Start-BitsTransfer -Source $url -Destination $outputPath

# Aguardar até que a transferência seja concluída
do {
    Start-Sleep -Seconds 1
} while ($transferJob.JobState -eq "Transferring")
```

Lembrando que a escolha da abordagem depende das suas necessidades específicas e do nível 
de controle que você deseja sobre o processo de download. Além disso, a maioria das abordagens 
inclui um loop que verifica regularmente se o download está completo, permitindo que o script 
aguarde até que o arquivo seja totalmente baixado.