# **Leitor de Nota Fiscal Eletrônica**

Este projeto é uma aplicação web desenvolvida em Ruby on Rails para processar e analisar documentos fiscais eletrônicos (XML de NF-e). A aplicação permite o upload de arquivos XML, processamento em background utilizando Sidekiq, e a geração de relatórios detalhados com informações extraídas dos documentos fiscais.

## **Funcionalidades**

- **Autenticação de Usuário**: Sistema de login seguro para garantir que apenas usuários autenticados possam acessar a aplicação.
- **Upload de Documentos**: Interface para envio de arquivos XML.
- **Processamento em Background**: Processamento dos arquivos XML em segundo plano utilizando Sidekiq.
- **Relatório Detalhado**: Geração de relatório com dados fiscais, produtos, impostos e totalizadores.
- **Filtros**: Implementação de filtros para facilitar a busca e a visualização das informações no relatório.
- **Exportação de Relatório**: Exportação do relatório gerado em formato Excel.

## **Tecnologias Utilizadas**

- **Ruby on Rails**: Framework principal da aplicação.
- **Tailwind CSS**: Framework CSS utilizado para estilização das páginas.
- **Sidekiq**: Para processamento de tarefas em background.
- **Redis**: Utilizado como backend para o Sidekiq.
- **CarrierWave**: Gem para upload e gerenciamento de arquivos.
- **Rspec**: Para testes automatizados.

## **Configuração do Ambiente**

### **Pré-requisitos**

- **Ruby 3.x**
- **Rails 7.x**
- **Redis**
- **Sidekiq**
- **PostgreSQL**

### **Instalação**

1. **Clone o repositório**:
     

        git clone https://github.com/seu-usuario/leitor-nfe.git


2. **Instale as dependências**:


       bundle install
   
3. **Configure o banco de dados**:
   
       rails db:create
       rails db:migrate

5. **Configure o Redis e Sidekiq**:    
   Certifique-se de que o Redis esteja em execução:
     
       redis-server

   Inicie o Sidekiq:
   
        bundle exec sidekiq
   
6. **Inicie o servidor**:

        rails server


# Uso

## Upload de Documentos

1. Faça login na aplicação.
2. Navegue até a página de upload de documentos.
3. Selecione ou arraste e solte um arquivo XML.
4. Clique no botão de upload e aguarde o processamento.
5. Após o processamento, clique no botão "Ver Relatório" para visualizar os dados extraídos.

## Exportação de Relatório

Após a geração do relatório, há uma opção para exportá-lo em formato Excel, que pode ser baixado diretamente para o seu dispositivo.

# Contribuição

1. Fork o repositório.
2. Crie uma nova branch: `git checkout -b minha-nova-funcionalidade`.
3. Faça as suas alterações e commit: `git commit -am 'Adiciona nova funcionalidade'`.
4. Envie para a branch principal: `git push origin minha-nova-funcionalidade`.
5. Crie um Pull Request.

# Licença

Este projeto está licenciado sob a MIT License. Veja o arquivo `LICENSE` para mais detalhes.

# Contatos

- **Autor**: Daiane Maria de Gouvea
- **E-mail**: daianegouvea.dev@gmail.com
- **LinkedIn**: [Daiane Gouvea](https://www.linkedin.com/mwlite/in/daiane-gouv%C3%AAa-ti)
