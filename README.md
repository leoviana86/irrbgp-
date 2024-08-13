Texto para Iniciantes: Geração "Enzo"

Antigamente, por volta de 2024, trabalhávamos com algumas operadoras T1 e precisávamos preencher uma planilha para liberar nossos prefixos e dos nossos clientes. Essa planilha precisava listar tanto os prefixos próprios quanto os dos downstreans. Sempre que um cliente passava a ser transito pra alguém ou qualquer outra mudança ocorria nas listas de prefixos, a planilha precisava ser preenchida e atualizada novamente.

Para tornar esse processo mais eficiente, decidi usar a ajuda da IA para ajustar um script que já utilizava para gerar minhas listas.

Para essa tarefa, utilizei uma máquina com Debian 12 com os seguintes packs:

    bgpq4
    sshpass
    Mutt

O objetivo do script é atualizar automaticamente a política de prefixos sempre que houver uma alteração IN/OUT nos AS-SETs contidos no Cone de ASNs. Na primeira execução do script, ele gera três arquivos:

    arquivo-01 - raiz
    arquivo-02 - atualização
    arquivo-03 - diferença entre os arquivos-01 e 02

Sempre que o script for executado, o arquivo-02 é "alimentado" e comparado ao arquivo-01. Se houver remoção ou inserção, essa diferença é adicionada ao arquivo-03, que por sua vez é commitado no roteador. Após esse commit, o script enviará um email dizendo: "Ô folgado, se liga aí que o cliente atualizou o cone dele ;)". Isso é útil em caso de ainda existir algum transito que a liberação não seja via IRR aí vc não fica cego sem saber quem alterou seus respectivos as-sets, este exemplo é para juniper mas pode escrever para qualquer outro vendor!
