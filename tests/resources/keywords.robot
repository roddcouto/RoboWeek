*** Settings ***
Library             SeleniumLibrary
Library             DatabaseLibrary

Resource            elements.robot

*** Variables ***
${BASE_URL}         http://localhost:3000


*** Keywords ***


### Helpers
Conecta no Banco SQLite
    Connect To Database Using Custom Params     sqlite3     database="db/development.sqlite3", isolation_level=None

Deleta pelo nome
    [Arguments]     ${nome_produto}
    Conecta no Banco SQLite
    Execute SQL String          delete from produtos where nome = '${nome_produto}'


### Ganchos
Inicia Sessao
    Open Browser                    ${BASE_URL}         chrome
    
    Set Selenium Implicit Wait      8

Encerra Sessao
    Close Browser

Apos O Teste
    Capture Page Screenshot

### Steps

Dado que eu tenho o seguinte produto
    [Arguments]     ${nome}     ${descricao}     ${preco}     ${quantidade}

    Deleta Pelo Nome  ${nome}

    #Função do próprio Robot e não do selenium (Set Test Variable)
    Set Test Variable               ${nome}
    Set Test Variable               ${descricao}
    Set Test Variable               ${preco}
    Set Test Variable               ${quantidade}

E acesso o portal de cadastro de jogos
    Go To                           ${BASE_URL}/produtos/new

Quando eu faco o cadastro desse item
    Input Text                      ${CAMPO_NOME}               ${nome}
    Input Text                      ${CAMPO_DESC}               ${descricao}
    Input Text                      ${CAMPO_PRECO}              ${preco}
    Input Text                      ${CAMPO_QTDE}               ${quantidade}

    Click Element                   ${BT_CRIAR_PRODUTO}

Mas este produto ja foi cadastrado
    Quando eu faco o cadastro desse item
    E acesso o portal de cadastro de jogos

Então vejo a mensagem de sucesso "${mensagem_esperada}"
    Element Should Contain          ${ALERTA_SUCESSO}           ${mensagem_esperada}

E vejo este novo jogo na lista
    Element Should Contain          ${LISTA_JOGOS}              ${nome}
    
Então devo ver a mensagem de alerta "${mensagem_esperada}"
    Element Should Contain          ${ALERTA_ERRO}              ${mensagem_esperada}

