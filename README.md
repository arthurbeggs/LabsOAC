# LabsOAC
Our development of Computer Organization and Architecture laboratories.


## Uso básico do Git
Passo a passo de como utilizar o Git por linha de comando

### Escolhendo o branch a ser trabalhado
```
git checkout <nome do branch>
```


### Criando um novo branch
```
git checkout -b <nome do branch>
git push -u origin <nome do branch>
```


### Criando um commit
```
git add "arquivo.ext"       // Para adicionar todos os arquivos: git add .
git commit -m "<mensagem>"
```


### Enviando commits para o remoto
```
git pull                    // Mescla as alterações do remoto no repo local
                            // Se houverem merge conflicts, reslovê-los
git push                    // Envia as alterações do repo local para o remoto
```
Observação: **NUNCA** dê um push sem antes dar um pull


### Mesclando branches no master
```
git checkout master
git pull
git merge --no-ff <nome do branch a ser mesclado>
git add .
git commit -m "<mensagem>"
git push
```
