*** Settings ***
Documentation       Cadastro de Jogos

Resource            resources/keywords.robot
Suite Setup         Inicia Sessao
Suite Teardown      Encerra Sessao
Test Teardown       Apos O Teste


*** Test Cases ***
Cadastrar novo Jogo
    [tags]      smoke
    Dado que eu tenho o seguinte produto
    ...     Pitfall     Jogo de Plataforma      19.99       10
    E acesso o portal de cadastro de jogos
    Quando eu faco o cadastro desse item
    Então vejo a mensagem de sucesso "Produto cadastrado com sucesso."
    E vejo este novo jogo na lista

Jogo não pode ser duplicado
    [tags]      dup
    Dado que eu tenho o seguinte produto
    ...     Enduro     Clássico de Corrida      29.99       20
    E acesso o portal de cadastro de jogos
    Mas este produto ja foi cadastrado
    Quando eu faco o cadastro desse item
    Então devo ver a mensagem de alerta "Nome já está em uso"

Nome deve ser obrigatório
    [Template]      Tentar Cadastrar
    ${EMPTY}   19.99        10              Nome não pode ficar em branco

Preço deve ser obrigatório
    [Template]      Tentar Cadastrar
    Pitfall     ${EMPTY}     10             Preço não pode ficar em branco

Quantidade deve ser obrigatório
    [Template]      Tentar Cadastrar
    Pitfall     19.99        ${EMPTY}       Quantidade não pode ficar em branco

*** Keywords ***

Tentar Cadastrar
    [Arguments]     ${nome}     ${preco}     ${quantidade}      ${mensagem}

    Dado que eu tenho o seguinte produto
    ...     ${nome}     Jogo de Plataforma      ${preco}       ${quantidade}
    E acesso o portal de cadastro de jogos
    Quando eu faco o cadastro desse item
    Então devo ver a mensagem de alerta "${mensagem}"
