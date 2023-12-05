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
    docker-compose run web rake db:create
    docker-compose run web rake db:migrate
    docker-compose run web rake db:seed
    docker-compose up

\
**Guard**: Para trabalhar com o guard ativado e facilitar o acompanhamento dos seus testes:  

    docker-compose run web bundle exec guard

