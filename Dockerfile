FROM php:8.2-fpm

RUN apt-get update && apt-get install
RUN apt-get install -y libxml2-dev \
    && apt-get install -y libxslt-dev \
    && docker-php-ext-install soap \
    && docker-php-ext-install xsl
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN apt-get install --yes zip unzip

# Install system dependencies
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg2 \
    unixodbc-dev \
    libgssapi-krb5-2

# Add Microsoft package repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

# Install the Microsoft ODBC driver for SQL Server
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17
RUN pecl install sqlsrv pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

RUN apt-get install -y libicu-dev \
    && docker-php-ext-install intl



# RUN docker-php-ext-install ctype dom fileinfo hash intl session simplexml tokenizer, xml


# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     libzip-dev \
#     libmemcached-dev \
#     zlib1g-dev \
#     libssl-dev \
#     && docker-php-ext-install zip

# # # Install Memcached
# RUN apt-get update && apt-get install -y memcached

# # # Install PHP Memcached extension
# RUN pecl install memcached \
#     && docker-php-ext-enable memcached

COPY --from=composer/composer:latest-bin /composer /usr/bin/composer
# RUN composer create-project laravel/laravel /var/www/html/nzvenz_laravel
WORKDIR /var/www/html/cakephp_web
