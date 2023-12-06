# Cashback ICMS
O Cashback ICMS é uma aplicação desenvolvida para carregar notas fiscais, calcular impostos pagos indevidamente pelo contribuinte através de substituição tributária e gerar o arquivo texto exigido para a solicitação de restituição  dos valores junto à secretaria de fazenda.

O arquivo é formatado de acordo com o [Manual de orientação de formação  do arquivo digital para apuração do complemento ou ressarcimento do ICMS retiro por substituição tributária](https://www.substituicaotributaria.ms.gov.br/wp-content/uploads/2023/02/Manual-do-Ressarcimento-ICMS-ST-versao-17-atualizado-em-17_02_2023.docx), fornecido pela Secretaria de Estado de Fazenda de Mato Grosso do Sul, através da superintendência de Administração Tribuária - SAT e da Coordenaroria Especial de Tecnologia da Informação - COTIN.

## Instalação e configuração
Clone este repo:

    git clone https://github.com/GeBender/cashback-icms.git
   
\
Crie a base de dados, execute as migrations e popule o banco com o seed básico:

    docker build .
    docker-compose run web bundle install

\
Agora, acesse o container e conclua a instalação:

    docker exec -it cashback-icms_web_1 /bin/bash
    rake db:create
    rake db:migrate
    rake db:seed


\
**Guard**: Para trabalhar com o guard ativado e facilitar o acompanhamento dos seus testes, rode o Guard em um novo terminal, a partir do container:

    bundle exec guard


Abra o projeto dentro do container utilizando sua ferramenta de trabalho, para o VsCode: ```code .``` e utilize a extensão Dev Containers para dar sequência ao desenvolvimento.

## Importação das notas fiscais
O Primeiro passo é a importação das notas fiscais. No **Seed** já criamos uma *Company* com a Inscrição Estadual **283426055**. A inscrição Estadual é a chave neste contexto.

Utilizaremos um endpoint que pode ser acionado por exeplo pelo Postman, onde informaremos a inscrição estadual e a pasta onde estão as notas fiscais no seu dispositivo. Esta rotina utilizará um Delayed Job pois em uma grande massa de dados pode levar muitos minutos para concluir a tarefa, possibilitando assim que o servidor fique liberado para outras atividades.

O serviço de importação irá ler todos os arquivos XML de maneira recursiva e salvará os dados relevantes para o pedido de ressarcimento no banco de dados.

\
```POST http://localhost:3001/import/```
 
```Content-Type: application/json```
    
```Body raw (json)```

```json
{
    "ie" : "283426055",
    "path" : "/sample-invoices",
}
```