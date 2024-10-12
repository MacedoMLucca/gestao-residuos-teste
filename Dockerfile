# Use uma imagem base do Maven para compilar o projeto
FROM maven:3.9.4-eclipse-temurin-17 AS build

# Defina o diretório de trabalho no container
WORKDIR /app

# Copie o arquivo pom.xml e baixe as dependências necessárias (otimiza cache)
COPY pom.xml .

# Baixa as dependências do projeto
RUN mvn dependency:go-offline -B

# Copie o restante dos arquivos do projeto para o container
COPY src ./src

# Construa o projeto usando Maven
RUN mvn clean package -DskipTests

# Use uma imagem base leve do OpenJDK para rodar a aplicação
FROM eclipse-temurin:17-jdk-jammy

# Defina o diretório de trabalho no container
WORKDIR /app

# Copie o arquivo JAR gerado no estágio de build para o container
COPY --from=build /app/target/app-gestao-residuos.jar app.jar

# Expõe a porta 8080 para acesso externo
EXPOSE 8080

# Defina a entrada para rodar o aplicativo
ENTRYPOINT ["java", "-jar", "app.jar"]
